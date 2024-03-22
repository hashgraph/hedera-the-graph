local lunatest = package.loaded.lunatest
local assert_true, assert_false, assert_equal = lunatest.assert_true, lunatest.assert_false, lunatest.assert_equal



-- Load common test utilities
local testUtils = require("testUtils")
local mocks = require("testMocks")

-- Save the original os.getenv
local originalGetEnv = os.getenv

-- Test Setup: Replace os.getenv with the mock
os.getenv = mocks.mockGetEnv

-- Load the module to be tested, assuming our working directory is /tests
package.path = package.path .. ";../filters/?.lua" -- we need this since the module to test is not on the same folder
local tokenVerificationFilter = require("TokenVerificationFilter") -- The Lua file to test
local envoy_on_request = tokenVerificationFilter.envoy_on_request -- The function to test

-- Mock request_handle object
local request_handle = {
    body = function()
        return {
            length = function() return 0 end,
            getBytes = function(start, finish) return "" end
        }
    end,
    respond = function(handler, statusCode, message)

        response = {
            statusCode = statusCode[":status"], 
            message = message
        }
    end,
    logErr = function(error_message)
        -- Capture the error log for assertion
        error_log = error_message
    end,

}


-- Test case 1: No token provided, should return 401
local function test_noTokenProvided()
    
    -- Mock extractToken to return nil
    tokenVerificationFilter.extractToken = function(request_handle)
        return nil
    end    
    tokenVerificationFilter.envoy_on_request(request_handle)    

    assert_equal(response.statusCode, "401", testUtils.wrapTextInRed("No token provided should return 401. [FAIL] ✗"))
    assert_equal(response.message, "No token provided", testUtils.wrapTextInRed("No token provided should return correct error message. [FAIL] ✗"))
    testUtils.printGreen("✓ [PASS] Test case 1: No token provided")
end

-- Test case 2: Invalid JSON, should return 400
local function test_parseError()

    -- Mock extractToken to return "token"
    tokenVerificationFilter.extractToken = function(request_handle)
        return "token"
    end

    -- Mock parseJsonBody
    tokenVerificationFilter.parseJsonBody = function(body)
        return nil, nil, "INVALID JSON BODY"
    end


    tokenVerificationFilter.envoy_on_request(request_handle)

    assert_equal(response.statusCode, "400", testUtils.wrapTextInRed("Invalid JSON should return 400. [FAIL] ✗"))
    assert_equal(response.message, "INVALID JSON BODY", testUtils.wrapTextInRed("Invalid JSON should return correct error message. [FAIL] ✗"))
    testUtils.printGreen("✓ [PASS] Test case 2: Invalid JSON")

end

-- Test case 3: Invalid Method, should return 400
local function test_invalidMethod()
    -- Mock extractToken to return "token"
    tokenVerificationFilter.extractToken = function(request_handle)
        return "token"
    end

    -- Mock parseJsonBody
    tokenVerificationFilter.parseJsonBody = function(body)        
        return "subgraph1", "subgraph_deploy", nil
    end

    -- Mock verifyValidMethod to return true
    tokenVerificationFilter.verifyValidMethod = function(method)
        return false
    end

    tokenVerificationFilter.envoy_on_request(request_handle)

    assert_equal(response.statusCode, "400", testUtils.wrapTextInRed("Invalid method should return 400. [FAIL] ✗"))
    assert_equal(response.message, "Invalid method", testUtils.wrapTextInRed("Invalid method should return correct error message. [FAIL] ✗"))
    testUtils.printGreen("✓ [PASS] Test case 3: Invalid method")
end

-- Test case 4: hasPermission is false, should return 401
local function test_noPermission()
    -- Mock extractToken to return "token"
    tokenVerificationFilter.extractToken = function(request_handle)
        return "token"
    end

    -- Mock parseJsonBody
    tokenVerificationFilter.parseJsonBody = function(body)
        return "subgraph1", "subgraph_deploy", nil
    end

    -- Mock verifyValidMethod to return true
    tokenVerificationFilter.verifyValidMethod = function(method)
        return true
    end

    -- Mock checkTokenPermissions to return false
    tokenVerificationFilter.checkTokenPermissions = function(token, subgraphName, method)        
        return false, "No permission"
    end

    tokenVerificationFilter.envoy_on_request(request_handle)

    assert_equal(response.statusCode, "401", testUtils.wrapTextInRed("No permission, should return 401. [FAIL] ✗"))
    assert_equal(response.message, "No permission", testUtils.wrapTextInRed("No permission should return correct error message. [FAIL] ✗"))
    testUtils.printGreen("✓ [PASS] Test case 4: No permission")    
end


-- Test case 5: hasPermission is true, should return 200
local function test_hasPermission()
    -- Mock extractToken to return "validToken"
    tokenVerificationFilter.extractToken = function(request_handle)
        return "validToken"
    end

    -- Mock parseJsonBody
    tokenVerificationFilter.parseJsonBody = function(body)
        return "subgraph1", "subgraph_deploy", nil
    end

    -- Mock verifyValidMethod to return true
    tokenVerificationFilter.verifyValidMethod = function(method)
        return true
    end

    -- Mock checkTokenPermissions to return true
    tokenVerificationFilter.checkTokenPermissions = function(token, subgraphName, method)        
        return true, nil
    end
    tokenVerificationFilter.envoy_on_request(request_handle)
    testUtils.printGreen("✓ [PASS] Test case 5: Has permission")

end


-- @module suite-envoy_on_request
local test_envoy_on_request = {}

test_envoy_on_request.test_noTokenProvided = test_noTokenProvided
test_envoy_on_request.test_parseError = test_parseError
test_envoy_on_request.test_invalidMethod = test_invalidMethod
test_envoy_on_request.test_noPermission = test_noPermission
test_envoy_on_request.test_hasPermission = test_hasPermission

return test_envoy_on_request
