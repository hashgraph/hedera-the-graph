-- Hedera-The-Graph
--
-- Copyright (C) 2024 Hedera Hashgraph, LLC
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.


local cjson = require("cjson")
local http = require("socket.http")
local ltn12 = require("ltn12")

-- Configuration: Replace these with your actual details
local introspectionUrl = os.getenv("TOKEN_INTROSPECTION_URL") or nil
local clientId = os.getenv("CLIENT_ID") or nil
local clientSecret = os.getenv("CLIENT_SECRET") or nil



local function extractToken(request_handle)    
    
    local authHeader = request_handle:headers():get("Authorization")
    if not authHeader then
        return nil
    end

    -- Remove the "Bearer " prefix from the token
    return authHeader:gsub("Bearer%s+", "")
    
end

local function parseJsonBody(body)
    local success, jsonBody = pcall(cjson.decode, body)
    if not success then
        return nil, nil, "INVALID JSON BODY"
    end
    return jsonBody.method, jsonBody.params and jsonBody.params.name, nil
end

local function verifyValidMethod(method)
    if((method == "subgraph_deploy") or (method == "subgraph_create") or (method == "subgraph_remove")) then
        return true, nil
    end
    
    return false, "Invalid method"
end

-- Function to check if a value exists in a table
local function contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

-- Function to check if subgraphName is present in the "subgraph_access" claim
local function checkSubgraphAccessClaim(result, subgraphName)
    local subgraphAccessClaim = result.subgraph_access
    if subgraphAccessClaim then
        local subgraphList = {}
        -- Split the comma-separated string into a table
        for value in subgraphAccessClaim:gmatch("[^,]+") do
            table.insert(subgraphList, value)
        end
        return contains(subgraphList, subgraphName)
    end
    return false
end

-- Function to check if the "method" parameter is included in roles
local function checkMethodInRoles(result, method)
    local roles = result.resource_access[clientId].roles
    if roles then
        return contains(roles, method)
    end
    return false
end

-- Variable to store the user associated with the token
local tokenUser = "";

local function checkTokenPermissions(token, subgraphName, method)

    -- Prepare the HTTP request body
    local requestBody = "token=" .. token .. "&client_id=" .. clientId .. "&client_secret=" .. clientSecret   

    -- Prepare the HTTP request headers
    local headers = {
        ["Content-Type"] = "application/x-www-form-urlencoded",
        ["Content-Length"] = string.len(requestBody)
    }

    -- Prepare a table to collect the response
    local responseBody = {}    

    -- Perform the HTTP POST request
    local response, statusCode, responseHeaders, statusText = http.request{
        method = "POST",
        url = introspectionUrl,
        headers = headers,
        source = ltn12.source.string(requestBody),
        sink = ltn12.sink.table(responseBody)
    }

    -- Check if the request was successful
    if statusCode == 200 then
        -- Concatenate the response body table into a string
        responseBody = table.concat(responseBody)
        
        -- Parse the JSON response
        local result = cjson.decode(responseBody)        
        
        -- Check if the token is active
        if result.active then

            -- check if the token claims has resource roles collection.
            if not result.resource_access[clientId] then
                return false, "Client roles not found in token"
            end

            -- check if the token claims has subgraph_access claim.
            if not result.subgraph_access then
                return false, "subgraph_access claim not found in token"
            end

            local subgraphAccessGranted = checkSubgraphAccessClaim(result, subgraphName)
            local methodAccessGranted = checkMethodInRoles(result, method)

            print("Token introspection successful for user: " .. result.email)
            -- Set the token user for logging purposes
            tokenUser = result.email

            if not result.email_verified then
                return false, "Email not verified for user: " .. tokenUser
            end

            if not subgraphAccessGranted then
                return false, "Subgraph access not granted for '" .. subgraphName .. "'"
            end

            if not methodAccessGranted then
                return false, "Access denied for method: " .. method
            end
        else
            return false, "Token is invalid or expired."
        end
    else
        return false, "Failed to introspect token. Status: " .. tostring(statusCode)
    end

    return true, nil
end



-- This function is called for each request, and is the entry point for the filter
function envoy_on_request(request_handle)
    local token = extractToken(request_handle)

    if not token then
        request_handle:respond({[":status"] = "401"}, "No token provided")
        return
    end

    local body = request_handle:body():getBytes(0, request_handle:body():length())
    local method, subgraphName, parseError = parseJsonBody(body)
    if parseError then
        request_handle:respond({[":status"] = "400"}, parseError)
        return
    end

    if not method or not subgraphName then
        request_handle:respond({[":status"] = "400"}, "Invalid request body")
        return
    end

    if not verifyValidMethod(method) then
        request_handle:respond({[":status"] = "400"}, "Invalid method")
        return
    end

    local hasPermission, permissionError = checkTokenPermissions(token, subgraphName, method)

    if permissionError then
        request_handle:logErr(permissionError)
        request_handle:respond({[":status"] = "401"}, permissionError)
        return
    end

    if not hasPermission then
        request_handle:respond({[":status"] = "401"}, "Unauthorized")
        return
    end

    print("Token is authorized for method: ".. method .. " and subgraph: " .. subgraphName.. " by the user".. tokenUser)
    -- The request is authorized and processing continues
end
