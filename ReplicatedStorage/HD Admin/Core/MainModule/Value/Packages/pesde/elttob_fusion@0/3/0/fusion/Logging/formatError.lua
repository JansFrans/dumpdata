-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local messages = require(ParentParent.Logging.messages)

local function formatError(p1, p2, p3, ...) -- line: 16
    -- upvalues: messages (copy)
    local v1 = if typeof(p3) == "table" then p3 else nil
    local v2 = if typeof(p3) == "table" then p3.trace else p3
    local v3 = messages[p2]
    local v4 = p2

    if v3 == nil then
        v4 = "unknownMessage"
        v3 = messages.unknownMessage
    end

    local v5 = v3:format(...)
    local v6

    if v1 ~= nil then
        v6 = v5:gsub("ERROR_MESSAGE", v1.message)

        if v1.context ~= nil then
            v6 ..= (" (%*)"):format(v1.context)
        end
    else
        v6 = v5:gsub("ERROR_MESSAGE", p2)
    end

    local v7 = ("[Fusion] %* \nID: %*"):format(v6, v4)

    if p1 ~= nil and p1.policies.allowWebLinks then
        v7 ..= ("\nLearn more: https://elttob.uk/Fusion/0.3/api-reference/general/errors/#%*"):format((v4:lower()))
    end

    if v2 ~= nil then
        v7 ..= (" \n---- Stack trace ----\n%*"):format(v2)
    end

    return v7:gsub("\n", "\n    ")
end

return formatError
