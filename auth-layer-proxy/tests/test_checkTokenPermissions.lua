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
local checkTokenPermissions = tokenVerificationFilter.checkTokenPermissions -- The function to test

-- Replace the http.request with the mock
tokenVerificationFilter.http.request = mocks.mockHttpRequest

-- Test case 1: Successful token verification with all claims present
local function test_checkTokenPermissions_success()
    local result, errorMessage = checkTokenPermissions("validToken", "subgraph1", "subgraph_deploy")
    assert_true(result, testUtils.wrapTextInRed("checkTokenPermissions should succeed when all conditions are met. [FAIL] ✗"))
    testUtils.printGreen("✓ [PASS] Test case 1: Successful token verification with all claims present")
end

-- Test case 2: Token is invalid or expired
local function test_checkTokenPermissions_invalidToken()
    local result, errorMessage = checkTokenPermissions("invalidToken", "subgraph1", "subgraph_deploy")
    assert_false(result, testUtils.wrapTextInRed("checkTokenPermissions should fail when the token is invalid or expired. [FAIL] ✗"))
    assert_equal("Token is invalid or expired.", errorMessage, "Error message should indicate invalid or expired token")
    testUtils.printGreen("✓ [PASS] Test case 2: Token is invalid or expired")
end

-- Test case 3: Failed to introspect token (simulate HTTP request failure)
local function test_checkTokenPermissions_httpRequestFailure()
    local result, errorMessage = checkTokenPermissions("anyTokenCausingFailure", "subgraph1", "subgraph_deploy")
    assert_false(result, testUtils.wrapTextInRed("checkTokenPermissions should fail when the HTTP request fails. [FAIL] ✗"))
    assert(errorMessage:find("Failed to introspect token"), "Error message should indicate a failure in token introspection due to HTTP request failure [FAIL] ✗")
    testUtils.printGreen("✓ [PASS] Test case 3: Failed to introspect token (simulate HTTP request failure)")
end

-- Test Case 4: token is active but does not have the required permission to subgraph
local function test_checkTokenPermissions_noPermission()
    local result, errorMessage = checkTokenPermissions("validToken", "subgraph3", "subgraph_create")
    assert_false(result, testUtils.wrapTextInRed("checkTokenPermissions should fail when the token does not have the required permission. [FAIL] ✗"))
    assert_equal("Subgraph access not granted for 'subgraph3'", errorMessage, testUtils.wrapTextInRed("Error message should indicate unauthorized access [FAIL] ✗"))
    testUtils.printGreen("✓ [PASS] Test case 4: token is active but does not have the required permission to subgraph")
end

-- Test Case 5: Token is active and valid but does not have email verified
local function test_checkTokenPermissions_emailNotVerified()
    local result, errorMessage = checkTokenPermissions("emailNotVerified", "subgraph1", "subgraph_deploy")
    assert_false(result, testUtils.wrapTextInRed("checkTokenPermissions should fail when the token does not have the required permission. [FAIL] ✗"))
    assert_equal("Email not verified for user: test@email.com", errorMessage, testUtils.wrapTextInRed("Error message should indicate unauthorized access [FAIL] ✗"))
    testUtils.printGreen("✓ [PASS] Test case 5: Token is active and valid but does not have email verified")
end

-- Test Case 6: Token is active and valid but method is not Valid
local function test_checkTokenPermissions_invalidMethod()
    local result, errorMessage = checkTokenPermissions("validToken", "subgraph1", "invalid_method")
    assert_false(result, testUtils.wrapTextInRed("checkTokenPermissions should fail when the token does not have the required permission. [FAIL] ✗"))
    assert_equal("Access denied for method: invalid_method", errorMessage, testUtils.wrapTextInRed("Error message should indicate unauthorized access [FAIL] ✗"))
    testUtils.printGreen("✓ [PASS] Test case 6: Token is active and valid but method is not Valid")
end

-- Test Case 7: Token is active and valid but does not have permission for the method
local function test_checkTokenPermissions_noPermissionForMethod()
    local result, errorMessage = checkTokenPermissions("validToken", "subgraph1", "subgraph_remove")
    assert_false(result, testUtils.wrapTextInRed("checkTokenPermissions should fail when the token does not have the required permission. [FAIL] ✗"))
    assert_equal("Access denied for method: subgraph_remove", errorMessage, testUtils.wrapTextInRed("Error message should indicate unauthorized access [FAIL] ✗"))
    testUtils.printGreen("✓ [PASS] Test case 7: Token is active and valid but does not have permission for the method")
end

-- @module suite-checkTokenPermissions
local test_checkTokenPermissions = {}
test_checkTokenPermissions.test_checkTokenPermissions_success = test_checkTokenPermissions_success
test_checkTokenPermissions.test_checkTokenPermissions_invalidToken = test_checkTokenPermissions_invalidToken
test_checkTokenPermissions.test_checkTokenPermissions_httpRequestFailure = test_checkTokenPermissions_httpRequestFailure
test_checkTokenPermissions.test_checkTokenPermissions_noPermission = test_checkTokenPermissions_noPermission
test_checkTokenPermissions.test_checkTokenPermissions_emailNotVerified = test_checkTokenPermissions_emailNotVerified
test_checkTokenPermissions.test_checkTokenPermissions_invalidMethod = test_checkTokenPermissions_invalidMethod
test_checkTokenPermissions.test_checkTokenPermissions_noPermissionForMethod = test_checkTokenPermissions_noPermissionForMethod

return test_checkTokenPermissions
