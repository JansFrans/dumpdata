-- https://lua.expert

local SoundService = game:GetService("SoundService")
local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local Themer = require(ParentParent.Themer)
local OnEvent = Fusion.OnEvent
local t1 = {
    Base = require(script.Parent.Base)
}

return function(p1, p2) -- line: 54
    -- upvalues: SoundService (copy), Fusion (copy), Util (copy), Themer (copy), OnEvent (copy), t1 (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, t1)
    local v2 = Themer.Theme:now()
    local v3 = Util.Fallback(p2.Disabled, false)
    local v4 = Util.Fallback(p2.OnActivate, function() -- line: 59
    end)
    local v5 = Util.Fallback(p2.OnHover, function() -- line: 60
    end)
    local v6 = Util.Fallback(p2.OnHoverEnd, function() -- line: 61
    end)
    local v7 = Util.Fallback(p2.OnHold, function() -- line: 62
    end)
    local v8 = Util.Fallback(p2.OnHoldEnd, function() -- line: 63
    end)
    local v9 = Util.Fallback(p2.HoverSound, v2.Sound.Hover)
    local v10 = Util.Fallback(p2.ClickSound, v2.Sound.Click)
    local v11 = Util.Fallback(p2.Active, v1:Computed(function(p3) -- line: 68
        -- upvalues: v3 (copy)
        return not p3(v3)
    end))
    local v12 = Util.Fallback(p2.Selectable, v1:Computed(function(p4) -- line: 74
        -- upvalues: v3 (copy)
        return not p4(v3)
    end))
    local v13 = v1:EnsureValue(Util.Fallback(p2.Hovering, false))
    local v14 = v1:EnsureValue(Util.Fallback(p2.Holding, false))

    return v1:Hydrate(v1:Base(Util.CombineProps(p2, {
        ClassName = "TextButton",
        BackgroundTransparency = 1,
        Name = script.Name,
        AutomaticSize = Enum.AutomaticSize.XY,
        Selectable = v12
    })))({
        Text = "",
        RichText = false,
        TextSize = 0,
        [OnEvent("Activated")] = function() -- line: 93
            -- upvalues: v3 (copy), v4 (copy), v10 (copy), SoundService (copy), Fusion (copy)
            if Fusion.peek(v3) then
                return
            end

            SoundService:PlayLocalSound(Fusion.peek(v10))
            Fusion.peek(v4)()
        end,
        [OnEvent("MouseEnter")] = function() -- line: 100
            -- upvalues: v5 (copy), v9 (copy), v11 (copy), v13 (copy), SoundService (copy), Fusion (copy)
            if Fusion.peek(v11) then
                SoundService:PlayLocalSound(Fusion.peek(v9))
            end

            v13:set(true)
            Fusion.peek(v5)()
        end,
        [OnEvent("SelectionGained")] = function() -- line: 109
            -- upvalues: v5 (copy), v9 (copy), v11 (copy), v13 (copy), SoundService (copy), Fusion (copy)
            if Fusion.peek(v11) then
                SoundService:PlayLocalSound(Fusion.peek(v9))
            end

            v13:set(true)
            Fusion.peek(v5)()
        end,
        [OnEvent("SelectionLost")] = function() -- line: 118
            -- upvalues: v6 (copy), v13 (copy), v14 (copy), Fusion (copy)
            v13:set(false)
            v14:set(false)
            Fusion.peek(v6)()
        end,
        [OnEvent("MouseLeave")] = function() -- line: 124
            -- upvalues: v6 (copy), v13 (copy), v14 (copy), Fusion (copy)
            v13:set(false)
            v14:set(false)
            Fusion.peek(v6)()
        end,
        [OnEvent("MouseButton1Down")] = function() -- line: 130
            -- upvalues: v3 (copy), v7 (copy), v14 (copy), Fusion (copy)
            if not Fusion.peek(v3) then
                v14:set(true)
                Fusion.peek(v7)()
            end
        end,
        [OnEvent("MouseButton1Up")] = function() -- line: 137
            -- upvalues: v8 (copy), v14 (copy), Fusion (copy)
            v14:set(false)
            Fusion.peek(v8)()
        end
    })
end
