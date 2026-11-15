-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Navigate = require(UI.Util.Navigate)
local Children = Fusion.Children
local InputRow = require(script.Parent.InputRow)

require(script.Parent.Pressable)

local convertSecondsToTimeString = require(Modules.DataUtil.convertSecondsToTimeString)
local t1 = {
    {
        label = "Secs",
        seconds = 1
    },
    {
        label = "Mins",
        seconds = 60
    },
    {
        label = "Hours",
        seconds = 3600
    },
    {
        label = "Days",
        seconds = 86400
    }
}

local function secondsToUnits(p1) -- line: 36
    -- upvalues: t1 (copy)
    local v2 = math.max(0, (math.floor(p1)))
    local t2 = {}

    for i = #t1, 1, -1 do
        local seconds = t1[i].seconds

        t2[i] = math.floor(v2 / seconds)
        v2 %= seconds
    end

    return t2
end

local function unitsToSeconds(p2) -- line: 47
    -- upvalues: t1 (copy)
    local n1 = 0

    for v4, v5 in t1 do
        n1 += (p2[v4] or 0) * v5.seconds
    end

    return n1
end

return function(p3, p4) -- line: 60
    -- upvalues: Fusion (copy), Theme (copy), Navigate (copy), Children (copy), InputRow (copy), convertSecondsToTimeString (copy), t1 (copy), secondsToUnits (copy)
    local v6 = p4.title or ""
    local v8 = tonumber(if p4.value then Fusion.peek(p4.value) else p4.default) or 0
    local v9 = secondsToUnits(v8)
    local t3 = {}
    local t4 = {}

    for i = 1, #t1 do
        t3[i] = p3:Value(v9[i] or 0)
        t4[i] = p3:Value((tostring(v9[i] or 0)))
    end

    local v11 = p3:Value(v8)
    local v12 = p3:Value(false)

    local function toggleExpanded() -- line: 77
        -- upvalues: v12 (copy), Fusion (copy)
        v12:set(not Fusion.peek(v12))
    end

    local v14 = p3:Value(if v8 > 0 then convertSecondsToTimeString(v8) else "None")
    local v15 = false

    table.insert(p3, function() -- line: 85
        -- upvalues: v15 (ref)
        v15 = false
    end)

    local function rebuildTotal() -- line: 86
        -- upvalues: p4 (copy), t3 (copy), t4 (copy), v11 (copy), v14 (copy), v15 (ref), Fusion (copy), convertSecondsToTimeString (copy), t1 (copy), secondsToUnits (copy)
        if not v15 then
            v15 = true

            local t5 = {}

            for v17, v18 in t3 do
                t5[v17] = math.max(0, (math.floor(Fusion.peek(v18) or 0)))
            end

            local n2 = 0

            for v21, v22 in t1 do
                n2 += (t5[v21] or 0) * v22.seconds
            end

            local v23 = secondsToUnits(n2)

            for v24, v25 in t3 do
                local v26 = v23[v24] or 0

                v25:set(v26)
                t4[v24]:set((tostring(v26)))
            end

            v11:set(n2)
            v14:set(if n2 > 0 then convertSecondsToTimeString(n2) else "None")

            if p4.value then
                p4.value:set(n2)
            end

            v15 = false
        end
    end

    if p4.value ~= nil then
        p3:Observer(p4.value):onChange(function() -- line: 107
            -- upvalues: p4 (copy), t3 (copy), t4 (copy), v11 (copy), v14 (copy), v15 (ref), Fusion (copy), convertSecondsToTimeString (copy), secondsToUnits (copy)
            if v15 then
                return
            end

            local v28 = tonumber(Fusion.peek(p4.value)) or 0

            if v28 == Fusion.peek(v11) then
                return
            end

            local v29 = secondsToUnits(v28)

            v15 = true

            for v30, v31 in t3 do
                local v32 = v29[v30] or 0

                v31:set(v32)
                t4[v30]:set((tostring(v32)))
            end

            v11:set(v28)
            v14:set(if v28 > 0 then convertSecondsToTimeString(v28) else "None")
            v15 = false
        end)
    end

    local v34 = p3:Spring(p3:Computed(function(p5) -- line: 125
        -- upvalues: v12 (copy)
        if p5(v12) then
            return 1
        end

        return 0
    end), 50, 1)

    local function makeUnitColumn(p6) -- line: 131
        -- upvalues: p3 (copy), t3 (copy), t4 (copy), rebuildTotal (copy), Fusion (copy), Theme (copy), Children (copy), t1 (copy)
        local v35 = t1[p6]
        local v36 = t3[p6]
        local v37 = t4[p6]
        local v38

        local function commit(p7) -- line: 137
            -- upvalues: v36 (copy), rebuildTotal (copy)
            v36:set((math.max(0, (math.floor(tonumber(p7) or 0)))))
            rebuildTotal()
        end

        v38 = p3:New("TextBox")({
            Name = "Input",
            LayoutOrder = 1,
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = Theme.Color.NeutralContent,
            ClearTextOnFocus = false,
            FontFace = p3:Computed(function(p8) -- line: 149
                -- upvalues: Theme (copy)
                return Font.new(p8(Theme.Font.Body), p8(Theme.FontWeight.Bold))
            end),
            Text = v37,
            TextColor3 = Theme.Color.BaseContent,
            TextSize = Theme.TextSize.Body,
            TextXAlignment = Enum.TextXAlignment.Center,
            [Fusion.OnEvent("FocusLost")] = function() -- line: 156
                -- upvalues: v36 (copy), v37 (copy), rebuildTotal (copy), Fusion (copy)
                v36:set((math.max(0, (math.floor(tonumber((Fusion.peek(v37))) or 0)))))
                rebuildTotal()
            end,
            [Fusion.OnChange("Text")] = function(p9) -- line: 159
                -- upvalues: v37 (copy), v38 (ref)
                local v46 = p9:gsub("[^0-9]", "")

                if v46 ~= p9 then
                    local v47 = v38

                    if v47 then
                        v47.Text = v46
                    end
                end

                v37:set(v46)
            end,
            [Children] = {
                p3:New("UICorner")({
                    CornerRadius = UDim.new(0, 6)
                }),
                p3:New("UIStroke")({
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Theme.Color.NeutralStroke
                })
            }
        })

        return p3:New("Frame")({
            Name = v35.label,
            LayoutOrder = p6,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0),
            [Children] = {
                p3:New("UIFlexItem")({
                    FlexMode = Enum.UIFlexMode.Fill
                }),
                p3:New("UIListLayout")({
                    FillDirection = Enum.FillDirection.Vertical,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 4)
                }),
                v38,
                p3:New("TextLabel")({
                    Name = "Label",
                    LayoutOrder = 2,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 14),
                    FontFace = p3:Computed(function(p10) -- line: 196
                        -- upvalues: Theme (copy)
                        return Font.new(p10(Theme.Font.Body), p10(Theme.FontWeight.Regular))
                    end),
                    Text = v35.label,
                    TextColor3 = Theme.Color.NeutralContentDark,
                    TextSize = Theme.TextSize.Small,
                    TextXAlignment = Enum.TextXAlignment.Center
                })
            }
        })
    end

    return p3:New("Frame")({
        Name = "DurationSelector",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 0),
        [Children] = {
            p3:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8)
            }),
            InputRow(p3, {
                title = v6,
                name = "TriggerRow",
                labelSize = p4.labelSize,
                labelTextSize = p4.labelTextSize,
                autoHeight = true,
                framePaddingY = 8,
                framePaddingX = 8,
                [Children] = {
                    Navigate.makeActivatable(p3:New("TextButton")({
                        Name = "ExpandButton",
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        Size = UDim2.fromScale(1, 0),
                        Text = "",
                        [Fusion.OnEvent("Activated")] = toggleExpanded,
                        [Children] = {
                            p3:New("TextLabel")({
                                Name = "TimeString",
                                AutomaticSize = Enum.AutomaticSize.Y,
                                BackgroundTransparency = 1,
                                ClipsDescendants = true,
                                Position = UDim2.new(0, 0, 0, 0),
                                Size = UDim2.new(1, -26, 1, 0),
                                FontFace = p3:Computed(function(p11) -- line: 248
                                    -- upvalues: Theme (copy)
                                    return Font.new(p11(Theme.Font.Body), p11(Theme.FontWeight.Bold))
                                end),
                                Text = v14,
                                TextColor3 = p3:Computed(function(p12) -- line: 252
                                    -- upvalues: v11 (copy), Theme (copy)
                                    if p12(v11) > 0 then
                                        return (p12(Theme.Color.BaseContent))
                                    end

                                    return (p12(Theme.Color.NeutralContentDark))
                                end),
                                TextSize = Theme.TextSize.Subtitle,
                                TextXAlignment = Enum.TextXAlignment.Left,
                                TextYAlignment = Enum.TextYAlignment.Top,
                                [Children] = {
                                    p3:New("UIFlexItem")({
                                        FlexMode = Enum.UIFlexMode.Fill
                                    })
                                }
                            }),
                            p3:New("ImageLabel")({
                                Name = "ChevronIcon",
                                BackgroundTransparency = 1,
                                Image = "rbxassetid://78914100674850",
                                AnchorPoint = Vector2.new(1, 0.5),
                                ImageColor3 = Theme.Color.NeutralContentDark,
                                Position = UDim2.new(1, 0, 0.5, 0),
                                Size = UDim2.fromOffset(20, 20),
                                Rotation = p3:Spring(p3:Computed(function(p13) -- line: 275
                                    -- upvalues: v12 (copy)
                                    if p13(v12) then
                                        return 180
                                    end

                                    return 0
                                end), 60, 1)
                            })
                        }
                    }), toggleExpanded)
                }
            }),
            p3:New("Frame")({
                Name = "ExpandClip",
                LayoutOrder = 2,
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                Size = p3:Computed(function(p14) -- line: 291
                    -- upvalues: v34 (copy)
                    local v52 = math.round(p14(v34) * 68)

                    return UDim2.new(1, 0, 0, v52)
                end),
                [Children] = {
                    p3:New("Frame")({
                        Name = "BoxRow",
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        Size = UDim2.fromScale(1, 0),
                        [Children] = {
                            p3:New("UIListLayout")({
                                FillDirection = Enum.FillDirection.Horizontal,
                                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                                VerticalAlignment = Enum.VerticalAlignment.Top,
                                SortOrder = Enum.SortOrder.LayoutOrder,
                                Padding = UDim.new(0, 8)
                            }),
                            makeUnitColumn(1),
                            makeUnitColumn(2),
                            makeUnitColumn(3),
                            makeUnitColumn(4)
                        }
                    })
                }
            })
        }
    })
end
