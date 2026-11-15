-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local UserCheckbox = require(UI.Components.UserCheckbox)
local Pressable = require(UI.Components.Pressable)
local Children = Fusion.Children

return function(p1, p2) -- line: 26
    -- upvalues: Fusion (copy), Theme (copy), UserCheckbox (copy), Pressable (copy), Children (copy)
    local v1 = p2.userIds or p1:Value({})
    local v2 = p2.selection or p1:Value({})
    local v3 = p2.confirmLabel or "Confirm"
    local onConfirm, onUserActivate = p2.onConfirm, p2.onUserActivate
    local v4 = p1:Value("")
    local v5 = p1:Computed(function(p3) -- line: 35
        -- upvalues: v4 (copy), v1 (copy)
        local v6 = p3(v1)

        if p3(v4):lower() == "" then
        end

        return v6
    end)
    local v7 = p1:Computed(function(p4) -- line: 42
        -- upvalues: v2 (copy)
        return #p4(v2) > 0
    end)
    local v8 = p1:Computed(function(p5) -- line: 48
        -- upvalues: v5 (copy)
        local t1 = {}

        for v9, v10 in (p5(v5)) do
            t1[v10] = v9
        end

        return t1
    end)
    local v11 = p1:Computed(function(p6) -- line: 56
        -- upvalues: v3 (copy), v2 (copy)
        local v12 = if typeof(v3) == "table" then p6(v3) else v3
        local v13 = p6(v2)

        if not (#v13 > 0) then
            return v12
        end

        return v12 .. " (" .. tostring(#v13) .. ")"
    end)

    return p1:New("Frame")({
        Name = "UsersPage",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        [Children] = {
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                Padding = UDim.new(0, 0),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            p1:New("Frame")({
                Name = "SearchBar",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Color.Neutral,
                LayoutOrder = 1,
                Size = UDim2.new(1, 0, 0, 0),
                [Children] = {
                    p1:New("UICorner")({
                        CornerRadius = UDim.new(0, 6)
                    }),
                    p1:New("UIStroke")({
                        Transparency = 0.5,
                        Thickness = 1,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Color = Theme.Color.NeutralContent
                    }),
                    p1:New("UIPadding")({
                        PaddingTop = UDim.new(0, 9),
                        PaddingBottom = UDim.new(0, 9),
                        PaddingLeft = UDim.new(0, 12),
                        PaddingRight = UDim.new(0, 12)
                    }),
                    p1:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Horizontal,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        Padding = UDim.new(0, 8),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    p1:New("ImageLabel")({
                        BackgroundTransparency = 1,
                        Image = "rbxassetid://3926305904",
                        LayoutOrder = 1,
                        ImageColor3 = Theme.Color.NeutralContentDark,
                        Size = UDim2.fromOffset(14, 14)
                    }),
                    p1:New("TextBox")({
                        BackgroundTransparency = 1,
                        ClearTextOnFocus = false,
                        FontFace = p1:Computed(function(p7) -- line: 116
                            -- upvalues: Theme (copy)
                            return Font.new(p7(Theme.Font.Body), p7(Theme.FontWeight.Body))
                        end),
                        LayoutOrder = 2,
                        PlaceholderColor3 = Theme.Color.NeutralContentDark,
                        PlaceholderText = "Search users...",
                        Size = UDim2.new(1, -22, 0, 20),
                        Text = v4,
                        TextColor3 = Theme.Color.BaseContent,
                        TextSize = Theme.TextSize.Label,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        [Fusion.OnChange("Text")] = function(p8) -- line: 128
                            -- upvalues: v4 (copy)
                            v4:set(p8)
                        end
                    })
                }
            }),
            p1:New("ScrollingFrame")({
                Name = "UserList",
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                CanvasSize = UDim2.new(),
                ClipsDescendants = true,
                LayoutOrder = 2,
                ScrollBarThickness = 0,
                Size = UDim2.new(1, 0, 1, -80),
                [Children] = {
                    p1:New("UIFlexItem")({
                        FlexMode = Enum.UIFlexMode.Fill
                    }),
                    p1:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Vertical,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        Padding = UDim.new(0, 6),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    p1:New("UIPadding")({
                        PaddingTop = UDim.new(0, 8)
                    }),
                    p1:ForValues(v5, function(_, p10, p11) -- line: 155
                        -- upvalues: onUserActivate (copy), v2 (copy), v8 (copy), Fusion (copy), UserCheckbox (copy), Children (copy)
                        local v25 = p10:Computed(function(p12) -- line: 156
                            -- upvalues: p11 (copy), v2 (copy)
                            return table.find(p12(v2), p11) ~= nil
                        end)

                        return p10:New("Frame")({
                            Name = "Row_" .. tostring(p11),
                            AutomaticSize = Enum.AutomaticSize.Y,
                            BackgroundTransparency = 1,
                            LayoutOrder = p10:Computed(function(p13) -- line: 163
                                -- upvalues: p11 (copy), v8 (copy)
                                return p13(v8)[p11] or 0
                            end),
                            Size = UDim2.new(1, 0, 0, 0),
                            [Children] = {
                                UserCheckbox(p10, {
                                    userId = p11,
                                    isChecked = v25,
                                    onCheck = function(p14) -- onCheck | line: 171
                                        -- upvalues: p11 (copy), v2 (copy), Fusion (copy)
                                        local v26 = table.clone(Fusion.peek(v2))

                                        if p14 then
                                            if not table.find(v26, p11) then
                                                table.insert(v26, p11)
                                            end
                                        else
                                            local v27 = table.find(v26, p11)

                                            if v27 then
                                                table.remove(v26, v27)
                                            end
                                        end

                                        v2:set(v26)
                                    end,
                                    onUserActivate = function() -- onUserActivate | line: 183
                                        -- upvalues: p11 (copy), onUserActivate (copy), Fusion (copy)
                                        if onUserActivate then
                                            local v28 = if typeof(onUserActivate) == "table" then Fusion.peek(onUserActivate) else onUserActivate

                                            if v28 then
                                                v28(p11)
                                            end
                                        end
                                    end
                                })
                            }
                        })
                    end)
                }
            }),
            p1:New("Frame")({
                Name = "Footer",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = 3,
                Size = UDim2.new(1, 0, 0, 0),
                [Children] = {
                    p1:New("UIPadding")({
                        PaddingTop = UDim.new(0, 8)
                    }),
                    Pressable(p1, {
                        name = "ConfirmButton",
                        automaticSize = Enum.AutomaticSize.Y,
                        backgroundColor = p1:Computed(function(p15) -- line: 209
                            -- upvalues: v7 (copy), Theme (copy)
                            if p15(v7) then
                                return (p15(Theme.Color.Primary))
                            end

                            return (p15(Theme.Color.NeutralContent))
                        end),
                        size = UDim2.new(1, 0, 0, 0),
                        onActivate = function() -- onActivate | line: 216
                            -- upvalues: onConfirm (copy), v2 (copy), v7 (copy), Fusion (copy)
                            if Fusion.peek(v7) and onConfirm then
                                local v31 = if typeof(onConfirm) == "table" then Fusion.peek(onConfirm) else onConfirm

                                if v31 then
                                    v31(table.clone(Fusion.peek(v2)))
                                end
                            end
                        end,
                        [Children] = {
                            p1:New("UICorner")({
                                CornerRadius = UDim.new(0, 6)
                            }),
                            p1:New("UIPadding")({
                                PaddingTop = UDim.new(0, 10),
                                PaddingBottom = UDim.new(0, 10)
                            }),
                            p1:New("TextLabel")({
                                Name = "Label",
                                BackgroundTransparency = 1,
                                AutomaticSize = Enum.AutomaticSize.XY,
                                FontFace = p1:Computed(function(p16) -- line: 235
                                    -- upvalues: Theme (copy)
                                    return Font.new(p16(Theme.Font.Body), p16(Theme.FontWeight.Bold))
                                end),
                                Text = v11,
                                TextColor3 = p1:Computed(function(p17) -- line: 239
                                    -- upvalues: v7 (copy), Theme (copy)
                                    if p17(v7) then
                                        return (p17(Theme.Color.BaseContent))
                                    end

                                    return (p17(Theme.Color.NeutralContentDark))
                                end),
                                TextSize = Theme.TextSize.Body
                            })
                        }
                    })
                }
            })
        }
    })
end
