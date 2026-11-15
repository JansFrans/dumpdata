-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)

local function evaluate(p1, p2) -- line: 17
    -- upvalues: External (copy), evaluate (copy)
    if p1.validity == "busy" then
        return External.logError("infiniteLoop")
    end

    local v1 = p1.lastChange == nil
    local v2 = p1.validity == "invalid"

    if not v1 and not v2 and not p2 then
        return false
    end

    local v3 = v1 or p2

    if not v3 then
        for v4 in p1.dependencySet do
            evaluate(v4, false)

            if v4.lastChange > p1.lastChange then
                v3 = true
                break
            end
        end
    end

    local v5 = false

    if v3 then
        for v6 in p1.dependencySet do
            v6.dependentSet[p1] = nil
            p1.dependencySet[v6] = nil
        end

        p1.validity = "busy"
        v5 = p1:_evaluate() or v1
    end

    if v5 then
        p1.lastChange = os.clock()
    end

    p1.validity = "valid"

    return v5
end

return evaluate
