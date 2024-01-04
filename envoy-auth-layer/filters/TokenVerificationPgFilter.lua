local cjson = require("cjson")
local luasql = require("luasql.postgres")

local function extractToken(request_handle)
    -- Adjust the header name to match your token header
    return request_handle:headers():get("Authorization")
end

local function parseJsonBody(body)
    local success, jsonBody = pcall(cjson.decode, body)
    if not success then
        return nil, nil, "JSON parsing failed"
    end
    return jsonBody.method, jsonBody.params and jsonBody.params.name, nil
end

local function escapeLiteral(conn, literal)
    -- Use the connection's escape method to safely escape literals
    return conn:escape(literal)
end

local function getDbConnection()
    local env = luasql.postgres()
    local db_user = os.getenv("DB_USER") or "postgres"
    local db_password = os.getenv("DB_PASSWORD") or ""
    local db_name = os.getenv("DB_NAME") or "thegraphauth"
    local db_host = os.getenv("DB_HOST") or "host.docker.internal"
    local db_port = tonumber(os.getenv("DB_PORT")) or 5432

    return env:connect(db_name, db_user, db_password, db_host, db_port)
end

local function checkTokenPermissions(token, method, paramName)
    local conn, err = getDbConnection()
    if not conn then
        return false, "Database connection error: " .. err
    end

    -- Escape parameters
    token = escapeLiteral(conn, token)
    method = escapeLiteral(conn, method)
    paramName = escapeLiteral(conn, paramName)

    -- Build and execute the query
    local query = string.format("SELECT * FROM auth.permissions WHERE token = '%s' AND method = '%s' AND param_name = '%s'", token, method, paramName)
    local cursor, error = conn:execute(query)

    if not cursor then
        conn:close()
        return false, "Database error: " .. error
    end

    local result = cursor:numrows() > 0
    cursor:close()
    conn:close()

    return result, nil
end

function envoy_on_request(request_handle)
    local token = extractToken(request_handle)
    if not token then
        request_handle:respond({[":status"] = "401"}, "No token provided")
        return
    end

    local body = request_handle:body():getBytes(0, request_handle:body():length())
    local method, paramName, parseError = parseJsonBody(body)
    if parseError then
        request_handle:respond({[":status"] = "400"}, parseError)
        return
    end

    if not method or not paramName then
        request_handle:respond({[":status"] = "400"}, "Invalid request body")
        return
    end

    local hasPermission, permissionError = checkTokenPermissions(token, method, paramName)
    if permissionError then
        request_handle:logErr(permissionError)
        request_handle:respond({[":status"] = "500"}, "Internal Server Error")
        return
    end

    if not hasPermission then
        request_handle:respond({[":status"] = "401"}, "Unauthorized")
        return
    end

    -- The request is authorized and processing continues
end
