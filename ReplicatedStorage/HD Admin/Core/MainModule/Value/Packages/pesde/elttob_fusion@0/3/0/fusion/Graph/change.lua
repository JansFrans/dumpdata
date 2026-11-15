-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local evaluate = require(ParentParent.Graph.evaluate)

local function change(p1) -- line: 23
    -- upvalues: External (copy), evaluate (copy)
    if p1.validity == "busy" then
        return External.logError("infiniteLoop")
    end

    if not evaluate(p1, true) then
        return
    end

    local v2 = {}
    local t1 = {}
    local v1 = {
        p1
    }
    local v3 = os.clock() + 1 * External.safetyTimerMultiplier

    while not (v3 < os.clock()) do
        local v4 = true

        for _, v5 in v1 do
            local v6 = v4

            for v7 in v5.dependentSet do
                if v7.validity == "valid" then
                    table.insert(t1, v7)
                    v6 = false
                    table.insert(v2, v7)
                elseif v7.validity == "busy" then
                    return External.logError("infiniteLoop")
                end

                v4 = v6
            end
        end

        table.clear(v1)

        if v4 then
            local t2 = {}

            for _, v8 in t1 do
                v8.validity = "invalid"

                if v8.timeliness == "eager" then
                    table.insert(t2, v8)
                end
            end

            table.sort(t2, function(p2, p3) -- line: 73
                return p2.createdAt < p3.createdAt
            end)

            for _, v9 in t2 do
                evaluate(v9, false)
            end

            return
        end

        v1, v2 = v2, v1
    end

    return External.logError("infiniteLoop")
end

return change
