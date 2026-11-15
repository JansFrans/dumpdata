-- https://lua.expert

local Util = require(script.Parent.Parent.Util)

local function count(p1, p2) -- line: 25
    -- upvalues: Util (copy)
    local v1 = if type(p2) == "function" then p2 else Util.func.truthy
    local n1 = 0

    for v2, _ in pairs(p1) do
        if v1(v2, p1) then
            n1 += 1
        end
    end

    return n1
end

return count
