local cjson = require("cjson")

-- Mock for HTTP request
local function mockHttpRequest(params)

    local requestBody = params.source()
    local token, clientId, clientSecret = requestBody:match("token=(.*)&client_id=(.*)&client_secret=(.*)")

    -- You can adjust the response based on the input parameters for different test cases
    if token == "validToken" then        
        statusCode = 200
        response = cjson.encode({
            active = true,
            subgraph_access = "subgraph1,subgraph2",
            email = "user@example.com",
            email_verified = true,
            ["realm_access"] = { -- Use square brackets and quotes for the key
                roles = { -- Use equals sign for assignment                    
                    "subgraph_create",
                    "subgraph_deploy",
                    "subgraph_resume",
                    "subgraph_pause"
                }
            }
        })        
        params.sink(response)
        return 1, statusCode, nil, nil                       
    elseif token == "emailNotVerified" then
        statusCode = 200
        response = cjson.encode({
            active = true,
            subgraph_access = "subgraph1,subgraph2",
            email = "test@email.com",
            email_verified = false,
            ["realm_access"] = { -- Use square brackets and quotes for the key
                roles = { -- Use equals sign for assignment
                    "subgraph_remove",
                    "subgraph_create",
                    "subgraph_deploy",
                    "subgraph_resume",
                    "subgraph_pause"
                }
            }
        })
        params.sink(response)
        return 1, statusCode, nil, nil
    
    elseif token == "invalidToken" then
        statusCode = 200
        response = cjson.encode({
            active = false
        })
        params.sink(response)
        return 1, statusCode, nil, nil
    else
        -- Simulate a failed HTTP request
        statusCode = 500
        statusText = "Internal Server Error"
        return 1, statusCode, statusText, nil        
    end
end

local function mockGetEnv(envVarName)
    local envVars = {
        CLIENT_ID = "htg-auth_layer",
        CLIENT_SECRET = "wEGsZafep01LKNPkJhiOMQSmgAGAMWUi",
        TOKEN_INTROSPECTION_URL = "http://host.docker.internal:8080/realms/HederaTheGraph/protocol/openid-connect/token/introspect"
    }
    return envVars[envVarName]
end

-- export module
local testMocks = {}
testMocks.mockHttpRequest = mockHttpRequest
testMocks.mockGetEnv = mockGetEnv
return testMocks