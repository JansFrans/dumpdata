-- https://lua.expert

local Util = require(script.Parent.Parent.Util)
local copy = require(script.Parent.copy)

local function call(p1, p2) -- line: 10
    if type(p1) == "function" then
        return p1(p2)
    end
end

local function update(p3, p4, p5, p6) -- line: 44
    -- upvalues: Util (copy), copy (copy)
    local v1 = #p3
    local v2 = copy(p3)
    local v3 = if p4 < 1 then p4 + v1 else p4
    local v4 = if type(p5) == "function" then p5 else Util.func.returned

    if v2[v3] ~= nil then
        v2[v3] = v4(v2[v3], v3)
    elseif type(p6) == "function" then
        v2[v3] = p6(v3)
    else
        v2[v3] = nil
    end

    return v2
end

return update
