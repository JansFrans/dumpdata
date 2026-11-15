-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Janitor = require(Modules.Objects.Janitor)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 10
    -- upvalues: Janitor (copy), t1 (copy)
    local t2 = {
        isActive = true,
        janitor = Janitor.new()
    }

    setmetatable(t2, t1)

    return t2
end

function t1.destroy(p1) -- line: 29
    if p1.isActive then
        p1.isActive = false
        p1.janitor:destroy()
    end
end

return t1
