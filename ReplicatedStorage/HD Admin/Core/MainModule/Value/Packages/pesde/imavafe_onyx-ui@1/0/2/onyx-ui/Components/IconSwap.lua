-- https://lua.expert

local ParentParent = script.Parent.Parent
local Util = require(ParentParent.Util)
local Themer = require(ParentParent.Themer)
local Fusion = require(ParentParent.Parent.Fusion)
local IconButton = require(script.Parent.IconButton)

return function(p1, p2) -- line: 29
    -- upvalues: Util (copy), Themer (copy), Fusion (copy), IconButton (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, {
        IconButton = IconButton
    })
    local v2 = Themer.Theme:now()
    local v3 = Util.Fallback(p2.Options, {})
    local v4 = v1:EnsureValue(Util.Fallback(p2.Selection, 1))
    local v5 = Util.Fallback(p2.OnSwap, function() -- line: 37
    end)

    local function RotateSelection(p3) -- line: 39
        -- upvalues: v3 (copy), v4 (copy), Fusion (copy)
        local v6 = Fusion.peek(v3)
        local v7 = Fusion.peek(v4) + p3

        if #v6 < v7 then
            v7 = 1
        elseif v7 < 1 then
            v7 = #v6
        end

        v4:set(v7)
    end

    return v1:IconButton(Util.CombineProps(p2, {
        Style = "Ghost",
        Name = script.Name,
        Color = v2.Colors.BaseContent.Main,
        Image = v1:Computed(function(p4) -- line: 57
            -- upvalues: v3 (copy), v4 (copy)
            return p4(v3)[p4(v4)]
        end),
        OnActivate = function() -- OnActivate | line: 61
            -- upvalues: v3 (copy), v4 (copy), v5 (copy), Fusion (copy)
            local v8 = Fusion.peek(v4)
            local v9 = Fusion.peek(v5)
            local v10 = Fusion.peek(v3)
            local v11 = Fusion.peek(v4) + 1

            if #v10 < v11 then
                v11 = 1
            elseif v11 < 1 then
                v11 = #v10
            end

            v4:set(v11)
            v9(v8, v8 + 1)
        end
    }))
end
