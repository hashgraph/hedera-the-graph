local lunatest = package.loaded.lunatest
local assert_equal = lunatest.assert_equal
local assert_nil = lunatest.assert_nil
local assert_not_nil = lunatest.assert_not_nil
-- Load the module to be tested
package.path = package.path .. ";../filters/?.lua"
-- Load common test utilities
local testUtils = require("testUtils")
local tokenVerificationFilter = require("TokenVerificationFilter") -- The Lua file to test
local parseJsonBody = tokenVerificationFilter.parseJsonBody

-- Test for valid JSON input
local function test_valid_json()
    local body = '{"method": "greet", "params": {"name": "Lua"}}'
    local method, name, error = parseJsonBody(body)
    assert_equal("greet", method)
    assert_equal("Lua", name)
    assert_nil(error)
    testUtils.printGreen("✓ [PASS] Test for valid JSON input")
end

-- Test for invalid JSON input
local function test_invalid_json()
    local body = '{"method": "greet", "params": {"name": "Lua"'  -- Missing closing bracket
    local method, name, error = parseJsonBody(body)
    assert_nil(method)
    assert_nil(name)
    assert_not_nil(error)
    assert_equal("INVALID JSON BODY", error)

    testUtils.printGreen("✓ [PASS] Test for invalid JSON input")
end

-- Test for JSON without params
local function test_json_without_params()
    local body = '{"method": "goodbye"}'
    local method, name, error = parseJsonBody(body)
    assert_equal("goodbye", method)
    assert_nil(name)
    assert_nil(error)

    testUtils.printGreen("✓ [PASS] Test for JSON without params")
end

-- Test for JSON without method
local function test_json_without_method()
    local body = '{"params": {"name": "Lua"}}'
    local method, name, error = parseJsonBody(body)
    assert_nil(method)
    assert_not_nil(name)
    assert_nil(error)
    
    testUtils.printGreen("✓ [PASS] Test for JSON without method")
end

-- Test for empty JSON
local function test_empty_json()
    local body = '{}'
    local method, name, error = parseJsonBody(body)
    assert_nil(method)
    assert_nil(name)
    assert_nil(error)   

    testUtils.printGreen("✓ [PASS] Test for empty JSON")
end

-- Test for empty body
local function test_empty_body()
    local body = ''
    local method, name, error = parseJsonBody(body)
    assert_nil(method)
    assert_nil(name)
    assert_not_nil(error)
    assert_equal("INVALID JSON BODY", error)

    testUtils.printGreen("✓ [PASS] Test for empty body")
end

-- Test for nil body
local function test_nil_body()
    local method, name, error = parseJsonBody(nil)
    assert_nil(method)
    assert_nil(name)
    assert_not_nil(error)
    assert_equal("INVALID JSON BODY", error)

    testUtils.printGreen("✓ [PASS] Test for nil body")
end

-- Test for non-JSON body
local function test_non_json_body()
    local body = "This is not a JSON body"
    local method, name, error = parseJsonBody(body)
    assert_nil(method)
    assert_nil(name)
    assert_not_nil(error)
    assert_equal("INVALID JSON BODY", error)
    
    testUtils.printGreen("✓ [PASS] Test for non-JSON body")
end

-- export suite
local test_parseJsonBody = {}
test_parseJsonBody.test_valid_json = test_valid_json
test_parseJsonBody.test_invalid_json = test_invalid_json
test_parseJsonBody.test_json_without_params = test_json_without_params
test_parseJsonBody.test_json_without_method = test_json_without_method
test_parseJsonBody.test_empty_json = test_empty_json
test_parseJsonBody.test_empty_body = test_empty_body
test_parseJsonBody.test_nil_body = test_nil_body
test_parseJsonBody.test_non_json_body = test_non_json_body

return test_parseJsonBody
