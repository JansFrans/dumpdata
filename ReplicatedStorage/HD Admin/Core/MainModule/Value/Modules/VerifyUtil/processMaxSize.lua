-- https://lua.expert

local Parent = require(script.Parent)
local HttpService = game:GetService("HttpService")

return function(p1, p2) -- line: 3
    -- upvalues: Parent (copy), HttpService (copy)
    p2 = p2 or Parent.KEY_MAX_CHARACTERS * 2

    local function v2() -- line: 5
        -- upvalues: p1 (copy), HttpService (copy)
        return HttpService:JSONEncode(p1)
    end

    local ok, result = pcall(v2)

    if ok and result then
        local v3 = #result

        if v3 <= p2 then
            return true, v3
        end

        return false, v3
    end

    return false, 0
end
