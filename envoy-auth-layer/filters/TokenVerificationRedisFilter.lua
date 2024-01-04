local cjson = require("cjson")
local redis = require 'redis'

local redisHost = os.getenv("REDIS_HOST") or "host.docker.internal"
local client = redis.connect(redisHost, 6379)

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

local function checkTokenPermissions(token, method, paramName)
    -- Construct a unique key based on token, method, and param_name
    -- The key format should match how you've stored the data in Redis
    local key = "permissions:" .. token .. ":" .. method .. ":" .. paramName

    -- Query Redis for the key
    local result = client:get(key)

    if result then
        -- Assuming a truthy result means permissions exist
        return true
    else
        -- No result found, or permissions do not exist
        return false
    end
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
