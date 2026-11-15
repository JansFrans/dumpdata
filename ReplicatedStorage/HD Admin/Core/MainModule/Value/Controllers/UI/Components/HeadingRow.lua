-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local SplitRow = require(UI.Components.SplitRow)
local Pressable = require(UI.Components.Pressable)
local HintIcon = require(UI.Components.HintIcon)
local LoadingSpinner = require(UI.Components.LoadingSpinner)
local Icons = require(UI.Config.Icons)

return function(p1, p2) -- line: 49
    -- upvalues: Fusion (copy), Theme (copy), Children (copy), SplitRow (copy), Pressable (copy), HintIcon (copy), LoadingSpinner (copy), Icons (copy)
    debug.profilebegin("HD_HeadingRow")

    local entry, onActivate, onDragStart, hideDrag = p2.entry, p2.onActivate, p2.onDragStart, p2.hideDrag
    local roleInfoFuse, defaultRoleInfoFuse, useDefaults, active = p2.roleInfoFuse, p2.defaultRoleInfoFuse, p2.useDefaults, p2.active
    local v1 = Fusion.peek(entry)
    local v2 = p1:Computed(function(p3) -- line: 62
        -- upvalues: entry (copy), roleInfoFuse (copy), defaultRoleInfoFuse (copy), useDefaults (copy)
        local v3 = p3(entry)

        if roleInfoFuse then
            local v4 = if not (useDefaults ~= nil and p3(useDefaults) == true and defaultRoleInfoFuse) then p3(roleInfoFuse) else p3(defaultRoleInfoFuse)

            if typeof(v4) == "table" then
                local v5 = v4[v3.key]

                if typeof(v5) == "table" and typeof(v5.name) == "string" then
                    return v5.name
                end
            end
        end

        return v3.name
    end)
    local v6 = p1:Computed(function(p4) -- line: 80
        -- upvalues: entry (copy), roleInfoFuse (copy), defaultRoleInfoFuse (copy), useDefaults (copy)
        local v7 = p4(entry)

        if roleInfoFuse then
            local v8 = if not (useDefaults ~= nil and p4(useDefaults) == true and defaultRoleInfoFuse) then p4(roleInfoFuse) else p4(defaultRoleInfoFuse)

            if typeof(v8) == "table" then
                local v9 = v8[v7.key]

                if typeof(v9) == "table" and typeof(v9.color) == "Color3" then
                    return v9.color
                end
            end
        end

        return v7.color or Color3.fromRGB(161, 161, 170)
    end)
    local v10 = if hideDrag then p1:Computed(function(p5) -- line: 97
        -- upvalues: hideDrag (copy)
        return p5(hideDrag) ~= true
    end) else nil
    local v11 = p1:Value(nil)
    local unlockState = p2.unlockState
    local v12 = unlockState ~= nil
    local v13 = p1:Value(false)
    local v14 = false

    table.insert(p1, function() -- line: 109
        -- upvalues: v14 (ref)
        v14 = true
    end)

    local v16, v17, v18, v19

    if v12 then
        v16 = p1:Computed(function(p6) -- line: 118
            -- upvalues: unlockState (copy)
            local v20 = p6(unlockState)

            if v20 == "unlock" then
                return true
            end

            return v20 == "unlocked"
        end)
        v17 = p1:Computed(function(p7) -- line: 123
            -- upvalues: v6 (copy), unlockState (copy), Theme (copy)
            if p7(unlockState) == "unlock" then
                return (p7(v6))
            end

            return p7(Theme.Color.NeutralStroke)
        end)
        v18 = p1:Computed(function(p8) -- line: 128
            -- upvalues: unlockState (copy)
            local v21 = p8(unlockState)

            if v21 == "unlock" then
                return "UNLOCK"
            end

            if v21 == "unlocked" then
                return "UNLOCKED"
            end

            return ""
        end)
        v19 = p1:Computed(function(p9) -- line: 134
            -- upvalues: v6 (copy), unlockState (copy), Theme (copy)
            if p9(unlockState) ~= "unlock" then
                return p9(Theme.Color.NeutralContentDark)
            end

            local v22 = p9(v6)

            if 0.299 * v22.R + 0.587 * v22.G + 0.114 * v22.B > 0.55 then
                return (Color3.fromRGB(20, 20, 24))
            end

            return (Color3.fromRGB(255, 255, 255))
        end)
    end

    local rightLabel = p2.rightLabel
    local v23 = rightLabel ~= nil and not v12
    local v24 = if active == nil then nil else p1:Computed(function(p10) -- line: 148
        -- upvalues: active (copy), v6 (copy), Theme (copy)
        if p10(active) then
            return (p10(v6))
        end

        return p10(Theme.Color.NeutralStroke)
    end)
    local t1 = {
        zIndex = 3,
        name = "HeadingRow_" .. v1.key,
        strokeColor = v24
    }

    t1.left = {
        name = "HeadingNav_" .. v1.key,
        fills = true,
        interactable = p2.interactable,
        onActivate = function() -- onActivate | line: 164
            -- upvalues: entry (copy), onActivate (copy), Fusion (copy)
            if onActivate then
                onActivate(Fusion.peek(entry).key)
            end
        end,
        [Children] = {
            p1:New("Frame")({
                Name = "ContentGroup",
                AnchorPoint = Vector2.new(0, 0.5),
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0.5, 0),
                [Children] = {
                    p1:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Horizontal,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        Padding = UDim.new(0, 10),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    p1:New("Frame")({
                        Name = "ColorDot",
                        BackgroundColor3 = v6,
                        LayoutOrder = 1,
                        Size = UDim2.fromOffset(10, 10),
                        [Children] = {
                            p1:New("UICorner")({
                                CornerRadius = UDim.new(1, 0)
                            }),
                            p1:New("UIStroke")({
                                Transparency = 0.5,
                                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                Color = Theme.Color.NeutralStroke
                            })
                        }
                    }),
                    p1:New("TextLabel")({
                        Name = "Name",
                        BackgroundTransparency = 1,
                        LayoutOrder = 2,
                        AutomaticSize = Enum.AutomaticSize.XY,
                        FontFace = p1:Computed(function(p11) -- line: 204
                            -- upvalues: p2 (copy), Theme (copy)
                            local v28 = if p2.nameFontWeight == nil then p11(Theme.FontWeight.Body) else p11(p2.nameFontWeight)

                            return Font.new(p11(Theme.Font.Body), v28)
                        end),
                        Text = v2,
                        TextColor3 = Theme.Color.BaseContent,
                        TextSize = Theme.TextSize.Subtitle
                    }),
                    if p2.hintIcon ~= nil then p1:New("Frame")({
                        Name = "HintSlot",
                        BackgroundTransparency = 1,
                        LayoutOrder = 3,
                        Size = UDim2.fromOffset(10, 20),
                        Visible = p1:Computed(function(p12) -- line: 223
                            -- upvalues: p2 (copy)
                            local v31 = p12(p2.hintIcon)

                            if typeof(v31) == "string" then
                                return v31 ~= ""
                            end

                            return false
                        end),
                        [Children] = {
                            HintIcon(p1, {
                                icon = p1:Computed(function(p13) -- line: 229
                                    -- upvalues: p2 (copy)
                                    local v32 = p13(p2.hintIcon)

                                    if typeof(v32) == "string" then
                                        return v32
                                    end

                                    return ""
                                end),
                                hintText = p2.hintText or "",
                                anchorPoint = Vector2.new(0, 0.5),
                                position = UDim2.new(0, -6, 0.5, 0),
                                size = UDim2.fromOffset(16, 20)
                            })
                        }
                    }) else nil
                }
            }),
            if v12 then Pressable(p1, {
                name = "UnlockButton_" .. v1.key,
                anchorPoint = Vector2.new(1, 0.5),
                position = UDim2.new(1, -8, 0.5, 0),
                size = UDim2.new(0, 90, 0, 28),
                backgroundColor = v17,
                visible = v16,
                zIndex = 5,
                onActivate = function() -- onActivate | line: 252
                    -- upvalues: p2 (copy), entry (copy), unlockState (copy), v13 (copy), v14 (ref), Fusion (copy)
                    if (if typeof(unlockState) == "table" then Fusion.peek(unlockState) else unlockState) ~= "unlock" or not p2.onUnlock or Fusion.peek(v13) then
                        return
                    end

                    v13:set(true)
                    task.delay(2, function() -- line: 260
                        -- upvalues: v13 (copy), v14 (ref)
                        if not v14 then
                            v13:set(false)
                        end
                    end)

                    local v35 = Fusion.peek(entry)

                    p2.onUnlock(v35.key)
                end,
                [Children] = {
                    p1:New("UICorner")({
                        CornerRadius = UDim.new(0, 6)
                    }),
                    p1:New("TextLabel")({
                        Name = "Label",
                        BackgroundTransparency = 1,
                        FontFace = p1:Computed(function(p14) -- line: 274
                            -- upvalues: Theme (copy)
                            return Font.new(p14(Theme.Font.Body), p14(Theme.FontWeight.Bold))
                        end),
                        Size = UDim2.fromScale(1, 1),
                        Text = v18,
                        TextColor3 = v19,
                        TextSize = Theme.TextSize.Label,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        TextYAlignment = Enum.TextYAlignment.Center,
                        Visible = p1:Computed(function(p15) -- line: 283
                            -- upvalues: v13 (copy)
                            return not p15(v13)
                        end)
                    }),
                    p1:New("Frame")({
                        Name = "Loader",
                        BackgroundTransparency = 1,
                        Size = UDim2.fromScale(1, 1),
                        Visible = v13,
                        [Children] = {
                            p1:New("UIListLayout")({
                                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                VerticalAlignment = Enum.VerticalAlignment.Center,
                                SortOrder = Enum.SortOrder.LayoutOrder
                            }),
                            LoadingSpinner(p1, {
                                size = 11,
                                thickness = 2,
                                paddingY = 0,
                                color = v19,
                                visible = v13
                            })
                        }
                    })
                }
            }) else nil,
            if v23 then p1:New("TextLabel")({
                BackgroundTransparency = 1,
                ZIndex = 5,
                Name = "RightLabel_" .. v1.key,
                AnchorPoint = Vector2.new(1, 0.5),
                AutomaticSize = Enum.AutomaticSize.X,
                FontFace = p1:Computed(function(p16) -- line: 316
                    -- upvalues: Theme (copy)
                    return Font.new(p16(Theme.Font.Body), p16(Theme.FontWeight.Body))
                end),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.new(0, 0, 1, 0),
                Text = rightLabel,
                TextColor3 = Theme.Color.NeutralContentDark,
                TextSize = Theme.TextSize.Label,
                TextXAlignment = Enum.TextXAlignment.Right,
                TextYAlignment = Enum.TextYAlignment.Center
            }) else nil
        }
    }

    local t11

    if p2.previewState ~= nil then
        t11 = {
            name = "PreviewSlot_" .. v1.key,
            fills = false
        }
        t11.visible = p1:Computed(function(p17) -- line: 334
            -- upvalues: p2 (copy)
            local previewState = p2.previewState

            if typeof(previewState) == "table" then
                previewState = p17(previewState)
            end

            if previewState == "active" then
                return true
            end

            return previewState == "inactive"
        end)

        function t11.onActivate() -- line: 339
            -- upvalues: p2 (copy), entry (copy), Fusion (copy)
            local onPreviewToggle = p2.onPreviewToggle

            if onPreviewToggle then
                onPreviewToggle(Fusion.peek(entry).key)
            end
        end

        t11[Children] = {
            p1:New("ImageLabel")({
                Name = "PreviewIcon",
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Image = p1:Computed(function(p18) -- line: 351
                    -- upvalues: p2 (copy)
                    local previewState = p2.previewState

                    if typeof(previewState) == "table" then
                        previewState = p18(previewState)
                    end

                    if previewState == "active" then
                        return "rbxassetid://71274079722169"
                    end

                    return "rbxassetid://86304612989533"
                end),
                ImageColor3 = p1:Computed(function(p19) -- line: 357
                    -- upvalues: p2 (copy), Theme (copy)
                    local previewState = p2.previewState

                    if typeof(previewState) == "table" then
                        previewState = p19(previewState)
                    end

                    if previewState == "active" then
                        return p19(Theme.Color.Primary)
                    end

                    return p19(Theme.Color.NeutralContentDark)
                end),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(18, 18)
            })
        }
    end

    t1.center = t11
    t1.right = if v12 or v23 then nil else {
        name = "DragHandle_" .. v1.key,
        fills = false,
        visible = v10,
        ref = v11,
        onActivate = function() -- onActivate | line: 374
        end,
        [Children] = {
            p1:New("ImageLabel")({
                Name = "DragIcon",
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Image = Icons.DragHandle,
                ImageColor3 = Theme.Color.NeutralContentDark,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(18, 18)
            })
        }
    }

    local v38 = SplitRow(p1, t1)

    if onDragStart then
        local v39 = Fusion.peek(v11)

        if v39 then
            p1:New("TextButton")({
                Name = "DragCatcher",
                Active = true,
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
                Size = UDim2.fromScale(1, 1),
                Text = "",
                TextColor3 = Color3.new(),
                TextSize = 1,
                ZIndex = 5,
                Parent = v39,
                [Fusion.OnEvent("InputBegan")] = function(p20) -- line: 404
                    -- upvalues: entry (copy), onDragStart (copy), v39 (copy), Fusion (copy)
                    if (p20.UserInputType == Enum.UserInputType.MouseButton1 or p20.UserInputType == Enum.UserInputType.Touch) and p20.UserInputState == Enum.UserInputState.Begin and onDragStart then
                        onDragStart(Fusion.peek(entry).key, v39, p20.Position.Y, p20.Position.X)
                    end
                end
            })
        end
    end

    debug.profileend()

    return v38
end
