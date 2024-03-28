testUtils = {}

function printGreen(text)
    print("\27[32m" .. text .. "\27[0m")    
end

-- Function to print text in red
function printRed(text)
    print("\27[31m" .. text .. "\27[0m")
end

function wrapTextInRed(text)
    return "\27[31m" .. text .. "\27[0m"
end


-- export functions
testUtils.printGreen = printGreen
testUtils.printRed = printRed
testUtils.wrapTextInRed = wrapTextInRed

return testUtils
