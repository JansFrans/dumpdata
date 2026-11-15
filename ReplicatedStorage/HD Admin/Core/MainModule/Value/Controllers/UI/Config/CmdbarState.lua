-- https://lua.expert

local Packages = script:FindFirstAncestor("MainModule").Value.Modules.Parent.Packages
local Fusion = require(Packages.Fusion)
local v1 = Fusion.scoped(Fusion)
local v2 = v1:Value(false)
local v3 = v1:Value(false)

local function setOpen(p1) -- line: 23
    -- upvalues: Fusion (copy), v2 (copy), v3 (copy)
    local v4

    if p1 then
        v4 = Fusion.peek(v3)
    else
        v2:set(false)
    end

    if (not p1 or v4) and p1 then
        v2:set(true)
    end
end

return {
    visible = v2,
    canOpen = v3,
    setOpen = setOpen,
    toggle = function() -- toggle | line: 33
        -- upvalues: Fusion (copy), v2 (copy), v3 (copy)
        local v5 = not Fusion.peek(v2)
        local v6

        if v5 then
            v6 = Fusion.peek(v3)
        else
            v2:set(false)
        end

        if (not v5 or v6) and v5 then
            v2:set(true)
        end
    end
}
