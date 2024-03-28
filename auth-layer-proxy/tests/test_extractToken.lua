local lunatest = package.loaded.lunatest
local assert_true, assert_false = lunatest.assert_true, lunatest.assert_false
-- Load the module to be tested
package.path = package.path .. ";../filters/?.lua"
-- Load common test utilities
local testUtils = require("testUtils")

local token_verification = require("TokenVerificationFilter") -- The Lua file to test

-- Refined mock request_handle object
local function mockRequestHandle(authHeader)
    return {
        headers = function()
            return {
                get = function(_, headerName)
                    if headerName == "Authorization" then
                        return authHeader
                    end
                end
            }
        end
    }
end

-- Test case 1: Authorization header present
local function test_extractToken_withAuthHeader()
    local request_handle = mockRequestHandle("Bearer abc123")    
    local token = token_verification.extractToken(request_handle)    
    assert_true(token == "abc123", testUtils.wrapTextInRed("extractToken should return the correct token. [FAIL] ✗"))
    testUtils.printGreen("✓ [PASS] Test case 1: Authorization header present ")
end

-- Test case 2: Authorization header present, but without "Bearer
local function test_extractToken_withAuthHeaderWithoutBearerKeyword()
    --print("\n")
    local request_handle = mockRequestHandle("abc123")    
    local token = token_verification.extractToken(request_handle)    
    assert(token == "abc123", "extractToken should return the correct token. [FAIL] ✗")
    testUtils.printGreen("✓ [PASS] Test case 2: Authorization header present, but without Bearer")
end

-- Test case 3: Authorization header absent
local function test_extractToken_withoutAuthHeader()
    local request_handle = mockRequestHandle(nil)
    local token = token_verification.extractToken(request_handle)
    assert(token == nil, "extractToken should return nil when Authorization header is absent. [FAIL] ✗")
    testUtils.printGreen("✓ [PASS] Test case 3: Authorization header absent")    
end

-- @module suite-extractToken
local test_extractToken = {}

test_extractToken.test_extractToken_withAuthHeader = test_extractToken_withAuthHeader
test_extractToken.test_extractToken_withAuthHeaderWithoutBearerKeyword = test_extractToken_withAuthHeaderWithoutBearerKeyword
test_extractToken.test_extractToken_withoutAuthHeader = test_extractToken_withoutAuthHeader

return test_extractToken
