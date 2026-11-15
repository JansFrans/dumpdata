-- https://lua.expert

local Util = require(script.Parent.Parent.Util)

local function filter(p1, p2) -- line: 24
    -- upvalues: Util (copy)
    local t1 = {}
    local v1 = if type(p2) == "function" then p2 else Util.func.truthy

    for v2, _ in pairs(p1) do
        if v1(v2, p1) then
            t1[v2] = true
        end
    end

    return t1
end

return filter
