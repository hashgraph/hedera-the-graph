local cjson = require "cjson"

function envoy_on_request(request_handle)
    -- Read the request body
    local body = request_handle:body()
    local json_body = body:getBytes(0, body:length())

    -- Try to parse the JSON body using cjson
    local status, parsed_body = pcall(cjson.decode, json_body)

    if not status then
        -- If parsing failed, return a 400 Bad Request response
        request_handle:respond({[":status"] = "400"}, "Invalid JSON body")
    end

    -- If the script reaches here, it means the request is authorized
    -- The request will continue processing
end