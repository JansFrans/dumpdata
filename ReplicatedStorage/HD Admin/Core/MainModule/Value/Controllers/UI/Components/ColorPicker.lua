-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Navigate = require(UI.Util.Navigate)
local Children = Fusion.Children
local ColorSlider = require(script.Parent.ColorSlider)
local InputRow = require(script.Parent.InputRow)

local function parseColorInput(p1) -- line: 28
    local v1 = p1:match("^%s*(.-)%s*$")
    local v2 = v1:match("^#?(%x%x%x%x%x%x)$")

    if v2 then
        local v4 = tonumber(v2:sub(1, 2), 16)
        local v6 = tonumber(v2:sub(3, 4), 16)
        local v8 = tonumber(v2:sub(5, 6), 16)

        return Color3.fromRGB(v4, v6, v8)
    end

    local v9, v10, v11 = v1:match("^(%d+)%s*,%s*(%d+)%s*,%s*(%d+)$")

    if v9 and v10 and v11 then
        local v13 = math.clamp(tonumber(v9), 0, 255)
        local v15 = math.clamp(tonumber(v10), 0, 255)
        local v17 = math.clamp(tonumber(v11), 0, 255)

        return Color3.fromRGB(v13, v15, v17)
    end

    return nil
end

local function colorToRgbString(p2) -- line: 50
    return math.round(p2.R * 255) .. "," .. math.round(p2.G * 255) .. "," .. math.round(p2.B * 255)
end

return function(p3, p4) -- line: 56
    -- upvalues: Fusion (copy), Theme (copy), Navigate (copy), Children (copy), ColorSlider (copy), InputRow (copy), parseColorInput (copy)
    local v23 = p4.title or ""
    local v24 = p4.value and Fusion.peek(p4.value)
    local v25 = if typeof(v24) == "Color3" then Fusion.peek(p4.value) elseif typeof(p4.default) == "Color3" then p4.default else Fusion.peek(Theme.Color.Primary)
    local v26 = p3:Value(v25)
    local v27 = p3:Value(false)
    local v28 = p3:Value(false)

    p3:Observer(v26):onChange(function() -- line: 67
        -- upvalues: p4 (copy), v26 (copy), Fusion (copy)
        if p4.value then
            p4.value:set(Fusion.peek(v26))
        end
    end)

    if p4.value ~= nil then
        p3:Observer(p4.value):onChange(function() -- line: 74
            -- upvalues: p4 (copy), v26 (copy), Fusion (copy)
            local v29 = Fusion.peek(p4.value)

            if typeof(v29) ~= "Color3" then
                return
            end

            local v30 = Fusion.peek(v26)

            if v30.R == v29.R and v30.G == v29.G and v30.B == v29.B then
                return
            end

            v26:set(v29)
        end)
    end

    local v31 = p3:Spring(p3:Computed(function(p5) -- line: 84
        -- upvalues: v27 (copy)
        if p5(v27) then
            return 1
        end

        return 0
    end), 50, 1)
    local v37 = p3:Value(math.round(v25.R * 255) .. "," .. math.round(v25.G * 255) .. "," .. math.round(v25.B * 255))

    p3:Observer(v26):onChange(function() -- line: 91
        -- upvalues: v26 (copy), v28 (copy), v37 (copy), Fusion (copy)
        if Fusion.peek(v28) then
            return
        end

        local v38 = Fusion.peek(v26)

        v37:set(math.round(v38.R * 255) .. "," .. math.round(v38.G * 255) .. "," .. math.round(v38.B * 255))
    end)

    local function toggleExpanded() -- line: 97
        -- upvalues: v27 (copy), Fusion (copy)
        v27:set(not Fusion.peek(v27))
    end

    return p3:New("Frame")({
        Name = "ColorPicker",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 0),
        [Children] = {
            p3:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2)
            }),
            InputRow(p3, {
                title = v23,
                name = "SwatchRow",
                labelSize = p4.labelSize,
                labelTextSize = p4.labelTextSize,
                autoHeight = true,
                framePaddingY = 0,
                framePaddingX = 0,
                strokeFocused = v28,
                [Children] = {
                    Navigate.makeActivatable(p3:New("TextButton")({
                        Name = "ToggleButton",
                        AutoButtonColor = false,
                        BackgroundTransparency = 1,
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
                        Size = UDim2.fromScale(1, 1),
                        Text = "",
                        TextColor3 = Color3.new(),
                        TextSize = 1,
                        ZIndex = 1,
                        [Fusion.OnEvent("Activated")] = toggleExpanded
                    }), toggleExpanded),
                    p3:New("TextBox")({
                        Name = "TextInput",
                        AutoLocalize = false,
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        ClearTextOnFocus = false,
                        ClipsDescendants = true,
                        FontFace = p3:Computed(function(p6) -- line: 146
                            -- upvalues: Theme (copy)
                            return Font.new(p6(Theme.Font.Body), p6(Theme.FontWeight.Body))
                        end),
                        PlaceholderColor3 = Theme.Color.NeutralContentDark,
                        PlaceholderText = "R,G,B or #hex",
                        Size = UDim2.new(1, -60, 0, 0),
                        Text = v37,
                        TextColor3 = Theme.Color.BaseContent,
                        TextSize = Theme.TextSize.Subtitle,
                        TextTransparency = 0.5,
                        TextTruncate = Enum.TextTruncate.SplitWord,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Top,
                        ZIndex = 2,
                        [Fusion.OnEvent("Focused")] = function() -- line: 160
                            -- upvalues: v28 (copy)
                            v28:set(true)
                        end,
                        [Fusion.OnEvent("FocusLost")] = function(_) -- line: 163
                            -- upvalues: v26 (copy), v28 (copy), v37 (copy), Fusion (copy), parseColorInput (copy)
                            v28:set(false)

                            local v47 = parseColorInput((Fusion.peek(v37)))

                            if v47 then
                                v26:set(v47)
                            end

                            local v48 = Fusion.peek(v26)

                            v37:set(math.round(v48.R * 255) .. "," .. math.round(v48.G * 255) .. "," .. math.round(v48.B * 255))
                        end,
                        [Fusion.OnChange("Text")] = function(p8) -- line: 172
                            -- upvalues: v37 (copy)
                            v37:set(p8)
                        end,
                        [Children] = {
                            p3:New("UICorner")({
                                CornerRadius = UDim.new(0, 6)
                            }),
                            p3:New("UIPadding")({
                                PaddingBottom = UDim.new(0, 8),
                                PaddingLeft = UDim.new(0, 8),
                                PaddingRight = UDim.new(0, 8),
                                PaddingTop = UDim.new(0, 8)
                            })
                        }
                    }),
                    Navigate.makeActivatable(p3:New("TextButton")({
                        Name = "SwatchButton",
                        AnchorPoint = Vector2.new(1, 0.5),
                        AutoButtonColor = false,
                        BackgroundColor3 = v26,
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
                        Position = UDim2.new(1, -5, 0.5, 0),
                        Size = UDim2.new(0, 28, 1, -12),
                        Text = "",
                        TextColor3 = Color3.new(),
                        TextSize = 1,
                        ZIndex = 3,
                        [Fusion.OnEvent("Activated")] = toggleExpanded,
                        [Children] = {
                            p3:New("UICorner")({
                                CornerRadius = UDim.new(0, 4)
                            }),
                            p3:New("UIStroke")({
                                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                Color = Theme.Color.NeutralStroke
                            }),
                            p3:New("UIAspectRatioConstraint")({})
                        }
                    }), toggleExpanded)
                }
            }),
            p3:New("Frame")({
                Name = "SlidersClip",
                LayoutOrder = 2,
                AutomaticSize = Enum.AutomaticSize.None,
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                Size = p3:Computed(function(p9) -- line: 221
                    -- upvalues: p4 (copy), v31 (copy)
                    local v56 = p9(v31)

                    return UDim2.new(1, 0, 0, (math.round(v56 * (p4.slidersHeight or 100))))
                end),
                [Children] = {
                    p3:New("UIPadding")({
                        PaddingTop = UDim.new(0, 8)
                    }),
                    ColorSlider(p3, {
                        color = v26
                    })
                }
            })
        }
    })
end
