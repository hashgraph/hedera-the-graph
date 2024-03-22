local lunatest = package.loaded.lunatest
local assert_true, assert_false, assert_equal = lunatest.assert_true, lunatest.assert_false, lunatest.assert_equal

-- Load the module to be tested
package.path = package.path .. ";../filters/?.lua"
-- Load common test utilities
local testUtils = require("testUtils")
local tokenVerificationFilter = require("TokenVerificationFilter") -- The Lua file to test
local verifyValidMethod = tokenVerificationFilter.verifyValidMethod

-- Test for valid methods
local function test_valid_methods()
    local validMethods = {"subgraph_deploy", "subgraph_create", "subgraph_remove", "subgraph_pause", "subgraph_resume"}
    for _, method in ipairs(validMethods) do
        local result, err = verifyValidMethod(method)
        assert_true(result, method .. " should be considered valid")
        assert_equal(err, nil, method .. " should not return an error")
    end

    testUtils.printGreen("✓ [PASS] Test for valid methods")
end

-- Test for an invalid method
local function test_invalid_method()
    local result, err = verifyValidMethod("invalid_method")
    assert_false(result, "Invalid method should not be considered valid")
    assert_equal(err, "Invalid method", "Invalid method should return a specific error message")

    testUtils.printGreen("✓ [PASS] Test for invalid method")
end


-- export suite
local test_verifyValidMethod = {}
test_verifyValidMethod.test_valid_methods = test_valid_methods
test_verifyValidMethod.test_invalid_method = test_invalid_method

return test_verifyValidMethod