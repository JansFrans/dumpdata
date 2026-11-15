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

return function(p1, p2) -- line: 75
    -- upvalues: SoundService (copy), Fusion (copy), Util (copy), Themer (copy), OnEvent (copy), t1 (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, t1)
    local v2 = Themer.Theme:now()
    local v3 = v1:EnsureValue(Util.Fallback(p2.Text, ""))
    local v4 = v1:EnsureValue(Util.Fallback(p2.Focusing, false))
    local v5 = v1:EnsureValue(Util.Fallback(p2.Hovering, false))
    local v6 = Util.Fallback(p2.Disabled, false)
    local v7 = Util.Fallback(p2.OnFocus, function() -- line: 84
    end)
    local v8 = Util.Fallback(p2.OnFocusEnd, function() -- line: 85
    end)
    local v9 = Util.Fallback(p2.Color, v2.Colors.Primary.Main)
    local v10 = Util.Fallback(p2.CharacterLimit, -1)
    local v11 = Util.Fallback(p2.ClearTextOnFocus, false)
    local v12 = Util.Fallback(p2.PlaceholderText, "")
    local v13 = Util.Fallback(p2.TextSize, v2.TextSize["1"])
    local v14 = Util.Fallback(p2.PlaceholderColor3, v2.Colors.NeutralContent.Dark)
    local v15 = Util.Fallback(p2.TextColor3, v1:Computed(function(p3) -- line: 94
        -- upvalues: v2 (copy)
        return p3(v2.Colors.BaseContent.Main)
    end))
    local v16 = Util.Fallback(p2.FontFace, v1:Font(v2.Font.Body, v2.FontWeight.Body))
    local v17 = Util.Fallback(p2.TextXAlignment, Enum.TextXAlignment.Left)
    local v18 = Util.Fallback(p2.TextYAlignment, Enum.TextYAlignment.Top)
    local v19 = Util.Fallback(p2.TextTransparency, v1:Computed(function(p4) -- line: 104
        -- upvalues: v4 (copy), v6 (copy)
        if p4(v6) then
            return 0.75
        end

        if p4(v4) then
            return 0
        end

        return 0.5
    end))
    local v20 = Util.Fallback(p2.TextProcessor, function(p5) -- line: 114
        return p5
    end)
    local v21 = Util.Fallback(p2.TextEditable, v1:Computed(function(p6) -- line: 119
        -- upvalues: v6 (copy)
        return not p6(v6)
    end))
    local v22 = v1:Value(false)

    local function ProcessText(p7) -- line: 126
        -- upvalues: v10 (copy), v20 (copy), Fusion (copy)
        local v23 = Fusion.peek(v10)

        return (Fusion.peek(v20)((p7:sub(1, utf8.offset(p7, v23)))))
    end

    local v25 = v1:Hydrate(v1:Base(Util.CombineProps(p2, {
        ClassName = "TextBox",
        AutoLocalize = false,
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Name = script.Name,
        Corner = {
            Radius = v1:UDim(0, v2.CornerRadius["1"])
        },
        Padding = {
            All = v1:UDim(0, v2.Padding["0.5"])
        },
        Stroke = {
            Color = v1:Spring(v1:Computed(function(p8) -- line: 146
                -- upvalues: v2 (copy), v4 (copy), v9 (copy), v22 (copy)
                if p8(v22) then
                    return p8(v2.Colors.Error.Main)
                end

                if p8(v4) then
                    return p8(v9)
                end

                return p8(v2.Colors.NeutralContent.Dark)
            end), v2.SpringSpeed["1"], v2.SpringDampening["1"]),
            Transparency = v1:Spring(v1:Computed(function(p9) -- line: 159
                -- upvalues: v4 (copy), v6 (copy)
                if p9(v6) then
                    return 0.8
                end

                if p9(v4) then
                    return 0
                end

                return 0.6
            end), v2.SpringSpeed["1"], v2.SpringDampening["1"])
        },
        AutomaticSize = Enum.AutomaticSize.XY,
        Active = v1:Computed(function(p10) -- line: 175
            -- upvalues: v6 (copy)
            return not p10(v6)
        end)
    })))({
        Text = v3,
        TextColor3 = v1:Spring(v1:Computed(function(p11) -- line: 183
            -- upvalues: v2 (copy), v15 (copy), v22 (copy)
            if p11(v22) then
                return p11(v2.Colors.Error.Main)
            end

            return p11(v15)
        end), v2.SpringSpeed.Immediate, v2.SpringDampening["1"]),
        TextSize = v13,
        FontFace = v16,
        PlaceholderColor3 = v14,
        PlaceholderText = v12,
        TextXAlignment = v17,
        TextYAlignment = v18,
        ClearTextOnFocus = v11,
        TextTransparency = v1:Spring(v19, v2.SpringSpeed["1"], v2.SpringDampening["1"]),
        TextEditable = v21,
        MultiLine = p2.MultiLine,
        TextWrapped = p2.TextWrapped,
        [OnEvent("Focused")] = function() -- line: 206
            -- upvalues: v2 (copy), v4 (copy), v6 (copy), v7 (copy), v21 (copy), SoundService (copy), Fusion (copy)
            if Fusion.peek(v6) or not Fusion.peek(v21) then
                return
            end

            v4:set(true)
            SoundService:PlayLocalSound(Fusion.peek(v2.Sound.Focus))
            Fusion.peek(v7)()
        end,
        [OnEvent("FocusLost")] = function() -- line: 215
            -- upvalues: v4 (copy), v8 (copy), Fusion (copy)
            v4:set(false)
            Fusion.peek(v8)()
        end,
        [OnEvent("MouseEnter")] = function() -- line: 220
            -- upvalues: v2 (copy), v5 (copy), v6 (copy), SoundService (copy), Fusion (copy)
            if not Fusion.peek(v6) then
                v5:set(true)
                SoundService:PlayLocalSound(Fusion.peek(v2.Sound.Hover))
            end
        end,
        [OnEvent("MouseLeave")] = function() -- line: 227
            -- upvalues: v5 (copy), v6 (copy), Fusion (copy)
            if not Fusion.peek(v6) then
                v5:set(false)
            end
        end,
        [OnEvent("SelectionGained")] = function() -- line: 232
            -- upvalues: v2 (copy), v6 (copy), v21 (copy), SoundService (copy), Fusion (copy)
            if not Fusion.peek(v6) and Fusion.peek(v21) then
                SoundService:PlayLocalSound(Fusion.peek(v2.Sound.Hover))
            end
        end
    })

    table.insert(v1, v25:GetPropertyChangedSignal("Text"):Connect(function() -- line: 241
        -- upvalues: v3 (copy), v10 (copy), v20 (copy), v22 (copy), v25 (copy), Fusion (copy)
        local Text = v25.Text
        local v27 = Fusion.peek(v10)
        local v28 = Fusion.peek(v20)((Text:sub(1, utf8.offset(Text, v27))))

        v3:set(v28)

        if v25.Text ~= v28 then
            v25.Text = v28
        end

        if utf8.len(Text) == utf8.len(v28) then
            return
        end

        v22:set(true)
        task.wait(0.075)
        v22:set(false)
    end))

    return v25
end
