pcall(require, "luacov")    --measure code coverage, if luacov is present
local lunatest = require "lunatest"


print '=============================='
print('Tests of auth-layer-proxy')
print("Tests are being executed on current directory: " .. os.getenv("PWD"))
print '=============================='

lunatest.suite("test_checkTokenPermissions")
lunatest.suite("test_extractToken")
lunatest.suite("test_parseJsonBody")
lunatest.suite("test_verifyValidMethod")
lunatest.suite("test_envoy_on_request")


lunatest.run()
