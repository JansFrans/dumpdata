-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Icons = require(UI.Config.Icons)
local VERSION = require(UI.Config.VERSION)
local Children = Fusion.Children
local Pressable = require(UI.Components.Pressable)

local function fireCallback(p1) -- line: 32
    -- upvalues: Fusion (copy)
    local v1 = if typeof(p1) == "table" then Fusion.peek(p1) else p1

    if v1 then
        v1()
    end
end

local function iconButton(p2, p3, p4, p5, p6, p7, p8, p9) -- line: 39
    -- upvalues: Fusion (copy), Theme (copy), Children (copy), Pressable (copy)
    p6 = p6 or 20

    local v3 = if p4 == nil then 0 else p4

    return Pressable(p2, {
        anchorPoint = p8,
        position = p9,
        size = UDim2.fromOffset(36, 36),
        iconImage = p3,
        iconColor = Theme.Color.PrimaryContent,
        iconSize = p6,
        iconTransparency = v3,
        interactable = p7,
        onActivate = function() -- onActivate | line: 51
            -- upvalues: p5 (copy), Fusion (copy)
            local v4 = p5

            if typeof(p5) == "table" then
                v4 = Fusion.peek(p5)
            end

            if v4 then
                v4()
            end
        end,
        [Children] = {
            p2:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            p2:New("UIPadding")({
                PaddingTop = UDim.new(0, 4),
                PaddingBottom = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 4),
                PaddingRight = UDim.new(0, 4)
            })
        }
    })
end

return function(p10, p11) -- line: 67
    -- upvalues: Fusion (copy), Theme (copy), Icons (copy), VERSION (copy), Children (copy), Pressable (copy), iconButton (copy)
    local v5 = Vector2.zero
    local Frame = p10:New("Frame")
    local t2 = {
        Name = "TitleBar",
        AutomaticSize = Enum.AutomaticSize.None,
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        LayoutOrder = 1
    }
    local v6 = p10:New("UIPadding")({
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8)
    })
    local v7 = p10:New("UIGradient")({
        Rotation = -90,
        Color = p10:Computed(function(p12) -- line: 86
            -- upvalues: Theme (copy)
            local v8 = p12(Theme.Color.Primary)
            local v9, v10, v11 = Color3.toHSV(v8)
            local v14 = Color3.fromHSV(v9, v10 * 0.92, (math.min(v11 * 1.06, 1)))

            return ColorSequence.new({
                ColorSequenceKeypoint.new(0, v8),
                ColorSequenceKeypoint.new(1, v14)
            })
        end)
    })
    local v15 = p10:New("UIListLayout")({
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
        Padding = UDim.new(0, 16),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
    local v16 = p10:New("UIDragDetector")({
        DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
        ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale,
        [Fusion.OnEvent("DragStart")] = function(p13) -- line: 108
            -- upvalues: v5 (ref)
            v5 = p13
        end,
        [Fusion.OnEvent("DragContinue")] = function(p14) -- line: 112
            -- upvalues: p11 (copy), v5 (ref)
            if p11.onDrag then
                p11.onDrag(p14 - v5)
            end

            v5 = p14
        end
    })
    local Frame2 = p10:New("Frame")
    local t4 = {
        Name = "LeftSlot",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 36, 1, 0)
    }
    local v18 = iconButton(p10, Icons.ArrowLeft, p10:Computed(function(p15) -- line: 129
        -- upvalues: p11 (copy)
        local canGoBack = p11.canGoBack

        if typeof(canGoBack) == "table" then
            canGoBack = p15(canGoBack)
        end

        if canGoBack then
            return 0
        end

        return 1
    end), p11.onBack, 23, p10:Computed(function(p16) -- line: 136
        -- upvalues: p11 (copy)
        local canGoBack = p11.canGoBack

        if typeof(canGoBack) == "table" then
            canGoBack = p16(canGoBack)
        end

        return canGoBack == true
    end), Vector2.new(0, 0.5), UDim2.new(0, 0, 0.5, 0))
    local leftAction = p11.leftAction

    local function v19() -- line: 148
        -- upvalues: p10 (copy), p11 (copy), Fusion (copy), Theme (copy), VERSION (copy), Children (copy), Pressable (copy)
        local v20 = p10:Value(false)
        local v21 = p10:Value(false)
        local v22 = p10:Computed(function(p17) -- line: 151
            -- upvalues: v20 (copy), v21 (copy), Theme (copy), Pressable (copy)
            local v23 = p17(Theme.Color.Primary):Lerp(Color3.new(0, 0, 0), 0.25)

            return Pressable.applyHighlight(p17, v23, v21, v20)
        end)

        return p10:New("CanvasGroup")({
            Name = "BetaBadge",
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(-8, -8),
            Size = UDim2.fromOffset(64, 45),
            Visible = p11.showBeta ~= nil and p11.showBeta,
            ZIndex = 3,
            [Children] = {
                p10:New("Frame")({
                    Name = "Ribbon",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = v22,
                    BackgroundTransparency = 0.15,
                    BorderSizePixel = 0,
                    Position = UDim2.fromOffset(24, 22),
                    Rotation = -45,
                    Size = UDim2.fromOffset(110, 21),
                    [Children] = {
                        p10:New("TextLabel")({
                            Name = "Label",
                            BackgroundTransparency = 1,
                            FontFace = p10:Computed(function(p18) -- line: 178
                                -- upvalues: Theme (copy)
                                return Font.new(p18(Theme.Font.Body), p18(Theme.FontWeight.Bold))
                            end),
                            Size = UDim2.fromScale(1, 1),
                            Text = VERSION.appVersion,
                            TextColor3 = Theme.Color.PrimaryContent,
                            TextSize = Theme.TextSize.Small,
                            TextXAlignment = Enum.TextXAlignment.Center,
                            TextYAlignment = Enum.TextYAlignment.Center
                        })
                    }
                }),
                Pressable(p10, {
                    name = "RibbonHit",
                    size = UDim2.fromScale(1, 1),
                    onActivate = function() -- onActivate | line: 194
                        -- upvalues: p11 (copy), Fusion (copy)
                        local onBeta = p11.onBeta

                        if typeof(onBeta) == "table" then
                            onBeta = Fusion.peek(onBeta)
                        end

                        if onBeta then
                            onBeta()
                        end
                    end,
                    onHoverChanged = function(p19) -- onHoverChanged | line: 195
                        -- upvalues: v20 (copy)
                        v20:set(p19)
                    end,
                    onPressChanged = function(p20) -- onPressChanged | line: 196
                        -- upvalues: v21 (copy)
                        v21:set(p20)
                    end
                })
            }
        })
    end

    t4[Children] = {
        v18,
        leftAction,
        v19()
    }

    local v25 = Frame2(t4)
    local v27 = p10:New("Frame")({
        Name = "Title",
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,
        [Children] = {
            p10:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, 9),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }),
            p10:New("ImageLabel")({
                Name = "Logo",
                BackgroundTransparency = 1,
                Image = Icons.LogoGlyph,
                ImageColor3 = Theme.Color.PrimaryContent,
                Size = UDim2.fromOffset(24, 24),
                Visible = p11.showLogo ~= nil and p11.showLogo,
                [Children] = {
                    p10:New("UICorner")({
                        CornerRadius = UDim.new(0, 3)
                    })
                }
            }),
            p10:New("TextLabel")({
                Name = "Text",
                BackgroundTransparency = 1,
                RichText = true,
                AutomaticSize = Enum.AutomaticSize.XY,
                FontFace = p10:Computed(function(p21) -- line: 230
                    -- upvalues: Theme (copy)
                    return Font.new(p21(Theme.Font.Heading), p21(Theme.FontWeight.Heading))
                end),
                Text = p11.title or "HD Admin",
                TextColor3 = Theme.Color.PrimaryContent,
                TextSize = Theme.TextSize.Title,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        }
    })
    local Frame4 = p10:New("Frame")
    local t9 = {
        Name = "RightSlot",
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 36, 1, 0)
    }
    local v28 = p10:New("UIListLayout")({
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
    local rightAction = p11.rightAction
    local v29 = iconButton(p10, Icons.Close, nil, p11.onClose)

    v29.LayoutOrder = 10
    t9[Children] = { v28, rightAction, v29 }
    t2[Children] = {
        v6,
        v7,
        v15,
        v16,
        v25,
        v27,
        Frame4(t9)
    }

    return Frame(t2)
end
