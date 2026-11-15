-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Prompt = require(Modules.Prompt)

require(Modules.Objects.Task)

local function computeDuration(p1) -- line: 9
    if p1 == "hint" then
        return 8
    end

    return 30
end

return function(p2, p3, p4, p5, p6) -- line: 13
    -- upvalues: Prompt (copy)
    p6 = p6 or {}

    local v2 = if typeof(p6.duration) == "number" then p6.duration elseif p2 == "hint" then 8 else 30

    if v2 >= 3600 then
        v2 = 0
    end

    p6.duration = v2

    if p6.userText == nil then
        p6.userText = typeof(p3.callerUserId) == "number"
    end

    local t1 = {}

    for v3, v4 in p4 do
        local v5 = Prompt[p2]
        local v6 = ("promptPopup_%*"):format(v3)

        p3.janitor:add(v5(v4, p5, p6), nil, v6)
        table.insert(t1, v6)
    end

    if v2 <= 0 then
        if p3.target then
            p3:keep("UntilTargetLeaves")
        else
            p3:keep("Indefinitely")
        end
    else
        p3.wait(v2)

        if p3.isActive then
            for _, v7 in t1 do
                p3.janitor:removeNoClean(v7)
            end
        end
    end
end
