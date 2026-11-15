-- https://lua.expert

local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Icons = require(UI.Config.Icons)
local Panels = require(UI.Config.Panels)
local Pressable = require(UI.Components.Pressable)
local OutfitsButton = require(UI.Components.OutfitsButton)
local Prompt = require(Modules.Prompt)
local products = require(Modules.References.products)
local promptPurchaseAsync = require(Modules.AssetUtil.promptPurchaseAsync)
local Children = Fusion.Children
local t1 = {
    {
        text = "Unlock exclusive fun commands",
        icon = Icons.ZapFill
    },
    {
        text = "Use in thousands of Roblox games",
        icon = Icons.GlobeFill
    },
    {
        text = "Support this game and HD Admin",
        subMessage = "(40% of your purchase goes to this game)",
        icon = Icons.HeartFill
    }
}
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 84, 175)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 205, 84)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(84, 224, 255)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(150, 120, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 84, 175))
})
local v2, v3
local v4 = false

local function fetchBoosterPricesOnce() -- line: 48
    -- upvalues: MarketplaceService (copy), products (copy), v2 (ref), v3 (ref), v4 (ref)
    if v4 then
        return
    end

    local function fetchPrice(p1) -- line: 52
        -- upvalues: MarketplaceService (copy)
        local function v5() -- line: 53
            -- upvalues: p1 (copy), MarketplaceService (copy)
            return MarketplaceService:GetProductInfo(p1, Enum.InfoType.Asset)
        end

        local ok, result = pcall(v5)

        return if ok and typeof(result) == "table" then tonumber(result.PriceInRobux) else nil
    end

    local id = products.Booster.id

    local function v6() -- line: 53
        -- upvalues: id (copy), MarketplaceService (copy)
        return MarketplaceService:GetProductInfo(id, Enum.InfoType.Asset)
    end

    local ok, result = pcall(v6)
    local v7 = if ok and typeof(result) == "table" then tonumber(result.PriceInRobux) else nil
    local id2 = products.BoosterDiscount.id

    local function v8() -- line: 53
        -- upvalues: id2 (copy), MarketplaceService (copy)
        return MarketplaceService:GetProductInfo(id2, Enum.InfoType.Asset)
    end

    local ok2, result2 = pcall(v8)
    local v9 = if ok2 and typeof(result2) == "table" then tonumber(result2.PriceInRobux) else nil

    if not (v7 and v9) then
        return
    end

    v2 = v7
    v3 = v9
    v4 = true
end

task.spawn(fetchBoosterPricesOnce)

local function makeSellingPoint(p2, p3, p4) -- line: 82
    -- upvalues: Theme (copy), Children (copy)
    local t2 = {
        p2:New("UIListLayout")({
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            VerticalFlex = Enum.UIFlexAlignment.None,
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder
        }),
        p2:New("TextLabel")({
            Name = "Line",
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            TextWrapped = true,
            AutomaticSize = Enum.AutomaticSize.Y,
            FontFace = p2:Computed(function(p5) -- line: 95
                -- upvalues: Theme (copy)
                return Font.new(p5(Theme.Font.Body), p5(Theme.FontWeight.Body))
            end),
            Size = UDim2.fromScale(1, 0),
            Text = p4.text,
            TextColor3 = Theme.Color.NeutralContentMain,
            TextSize = Theme.TextSize.Label,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    }

    if p4.subMessage then
        table.insert(t2, p2:New("TextLabel")({
            Name = "SubMessage",
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            TextTransparency = 0.45,
            TextWrapped = true,
            AutomaticSize = Enum.AutomaticSize.Y,
            FontFace = p2:Computed(function(p6) -- line: 112
                -- upvalues: Theme (copy)
                return Font.new(p6(Theme.Font.Body), p6(Theme.FontWeight.Body))
            end),
            Size = UDim2.fromScale(1, 0),
            Text = p4.subMessage,
            TextColor3 = Theme.Color.NeutralContentDark,
            TextSize = Theme.TextSize.Small,
            TextXAlignment = Enum.TextXAlignment.Left
        }))
    end

    return p2:New("Frame")({
        Name = "Point",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = p3,
        Size = UDim2.fromScale(1, 0),
        [Children] = {
            p2:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.None,
                VerticalFlex = Enum.UIFlexAlignment.None,
                Padding = UDim.new(0, 12),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = if p4.subMessage then Enum.VerticalAlignment.Top else Enum.VerticalAlignment.Center
            }),
            p2:New("Frame")({
                Name = "IconChip",
                BackgroundColor3 = Theme.Color.Primary,
                BackgroundTransparency = 0.82,
                LayoutOrder = 1,
                Size = UDim2.fromOffset(28, 28),
                [Children] = {
                    p2:New("UICorner")({
                        CornerRadius = UDim.new(0, 6)
                    }),
                    p2:New("ImageLabel")({
                        Name = "Icon",
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Image = p4.icon,
                        ImageColor3 = Theme.Color.Primary,
                        Position = UDim2.fromScale(0.5, 0.5),
                        Size = UDim2.fromOffset(16, 16)
                    })
                }
            }),
            p2:New("Frame")({
                Name = "Text",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                Size = UDim2.new(1, -40, 0, 0),
                [Children] = t2
            })
        }
    })
end

local function makeSecondaryButton(p7, p8, p9, p10, p11) -- line: 174
    -- upvalues: Theme (copy), Pressable (copy), Children (copy)
    return Pressable(p7, {
        name = p9 .. "Button",
        backgroundColor = Theme.Color.Neutral,
        size = p11 or UDim2.new(1, 0, 0, 44),
        automaticSize = Enum.AutomaticSize.None,
        layoutOrder = p8,
        onActivate = p10,
        [Children] = {
            p7:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            p7:New("UIStroke")({
                Transparency = 0.5,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.NeutralStroke
            }),
            p7:New("TextLabel")({
                Name = "Label",
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                FontFace = p7:Computed(function(p12) -- line: 195
                    -- upvalues: Theme (copy)
                    return Font.new(p12(Theme.Font.Body), p12(Theme.FontWeight.Bold))
                end),
                Position = UDim2.fromScale(0.5, 0.5),
                Text = p9,
                TextColor3 = Theme.Color.BaseContent,
                TextSize = Theme.TextSize.Subtitle
            })
        }
    })
end

return function(p13, p14) -- line: 209
    -- upvalues: MarketplaceService (copy), RunService (copy), Fusion (copy), Theme (copy), Icons (copy), Panels (copy), Pressable (copy), OutfitsButton (copy), Prompt (copy), products (copy), promptPurchaseAsync (copy), Children (copy), t1 (copy), v1 (copy), v2 (ref), v3 (ref), v4 (ref), makeSellingPoint (copy), makeSecondaryButton (copy)
    local OfferStartTime = p13:Fuse("perm", "OfferStartTime")
    local v10 = p13:Value(os.time())
    local v11 = p13:Computed(function(p15) -- line: 212
        -- upvalues: OfferStartTime (copy), v10 (copy)
        local v12 = p15(OfferStartTime)

        if typeof(v12) ~= "number" or v12 <= 0 then
            return 0
        end

        return (math.max(0, 900 - (p15(v10) - v12)))
    end)
    local v14 = p13:Computed(function(p16) -- line: 219
        -- upvalues: v11 (copy)
        return p16(v11) > 0
    end)
    local v15 = false
    local v16 = p13:Value(0)
    local n1 = 0
    local connection

    connection = RunService.Heartbeat:Connect(function(p17) -- line: 230
        -- upvalues: v15 (ref), v16 (copy), n1 (ref), connection (ref)
        if v15 then
            connection:Disconnect()
        else
            n1 += p17

            local v18 = math.min(n1 / 0.7, 1)

            v16:set((1 - (1 - v18) ^ 3) * 50)

            if v18 >= 1 then
                v16:set(50)
                connection:Disconnect()
            end
        end
    end)
    table.insert(p13, connection)
    task.spawn(function() -- line: 246
        -- upvalues: v10 (copy), v14 (copy), v15 (ref), Fusion (copy)
        while not v15 do
            task.wait(1)

            if not v15 and Fusion.peek(v14) then
                v10:set(os.time())
            end
        end
    end)

    local v19 = p13:Value(v2)
    local v20 = p13:Value(v3)

    if not v4 then
        task.spawn(function() -- line: 258
            -- upvalues: v15 (ref), v19 (copy), v20 (copy), MarketplaceService (copy), products (copy), v2 (ref), v3 (ref), v4 (ref)
            if not v4 then
                local function fetchPrice(p18) -- line: 52
                    -- upvalues: MarketplaceService (copy)
                    local function v21() -- line: 53
                        -- upvalues: MarketplaceService (copy), p18 (copy)
                        return MarketplaceService:GetProductInfo(p18, Enum.InfoType.Asset)
                    end

                    local ok, result = pcall(v21)

                    return if ok and typeof(result) == "table" then tonumber(result.PriceInRobux) else nil
                end

                local id = products.Booster.id

                local function v22() -- line: 53
                    -- upvalues: id (copy), MarketplaceService (copy)
                    return MarketplaceService:GetProductInfo(id, Enum.InfoType.Asset)
                end

                local ok, result = pcall(v22)
                local v23 = if ok and typeof(result) == "table" then tonumber(result.PriceInRobux) else nil
                local id2 = products.BoosterDiscount.id

                local function v24() -- line: 53
                    -- upvalues: id2 (copy), MarketplaceService (copy)
                    return MarketplaceService:GetProductInfo(id2, Enum.InfoType.Asset)
                end

                local ok2, result2 = pcall(v24)
                local v25 = if ok2 and typeof(result2) == "table" then tonumber(result2.PriceInRobux) else nil

                if v23 and v25 then
                    v2 = v23
                    v3 = v25
                    v4 = true
                end
            end

            if v15 or not v4 then
                return
            end

            v19:set(v2)
            v20:set(v3)
        end)
    end

    local v28 = p13:Computed(function(p19) -- line: 267
        -- upvalues: v14 (copy), v19 (copy), v20 (copy)
        if p19(v14) then
            return p19(v20) or p19(v19)
        end

        return p19(v19)
    end)
    local v29 = p13:Computed(function(p20) -- line: 273
        -- upvalues: v28 (copy)
        local v30 = p20(v28)

        if v30 then
            return (tostring(v30))
        end

        return "..."
    end)
    local v31 = p13:Computed(function(p21) -- line: 277
        -- upvalues: v19 (copy)
        local v32 = p21(v19)

        if v32 then
            return (tostring(v32))
        end

        return "..."
    end)
    local v33 = p13:Computed(function(p22) -- line: 281
        -- upvalues: Theme (copy)
        return p22(Theme.Color.Primary):Lerp(Color3.new(0, 0, 0), 0.28)
    end)
    local v34 = p13:Computed(function(p23) -- line: 284
        -- upvalues: v16 (copy)
        return (("%*+"):format((math.round((p23(v16))))))
    end)
    local v36 = p13:Computed(function(p24) -- line: 287
        -- upvalues: Theme (copy)
        return p24(Theme.TextSize.Label) * 1.5
    end)
    local v37 = p13:Computed(function(p25) -- line: 290
        -- upvalues: v11 (copy), Theme (copy)
        local v38 = p25(v11)
        local v40 = string.format("%d:%02d", math.floor(v38 / 60), v38 % 60)
        local v41 = p25(Theme.Color.Primary)

        return (("<font color=\"#%*\" weight=\"Heavy\">20%% OFF!</font> Offer ends in %*"):format(string.format("%02X%02X%02X", math.floor(v41.R * 255 + 0.5), math.floor(v41.G * 255 + 0.5), (math.floor(v41.B * 255 + 0.5))), v40))
    end)

    local function purchase() -- line: 298
        -- upvalues: v14 (copy), Fusion (copy), Prompt (copy), promptPurchaseAsync (copy)
        local v47 = if Fusion.peek(v14) then "BoosterDiscount" else "Booster"

        task.spawn(function() -- line: 300
            -- upvalues: v47 (copy), Prompt (copy), promptPurchaseAsync (copy)
            local v48, v49 = promptPurchaseAsync(v47)

            if not v48 and typeof(v49) == "string" and v49 ~= "" then
                Prompt.warn(v49)
            end
        end)
    end

    local function viewCommands() -- line: 308
        -- upvalues: Panels (copy)
        Panels.openCommands(nil, true)
    end

    local v50 = p13:New("UIGradient")({
        Color = v1
    })
    local n2 = 0

    table.insert(p13, RunService.Heartbeat:Connect(function(p26) -- line: 317
        -- upvalues: v50 (copy), n2 (ref)
        if v50.Parent then
            n2 = (n2 + p26 * 240) % 360
            v50.Rotation = n2
        end
    end))
    table.insert(p13, function() -- line: 327
        -- upvalues: p14 (copy), v15 (ref), Fusion (copy), Panels (copy)
        v15 = true

        if not (p14.idle ~= nil and Fusion.peek(p14.idle) or Panels.consumeBoosterSilentClose()) then
            Panels.notifyBoosterStackClosed("booster")
        end
    end)

    local Frame = p13:New("Frame")
    local t7 = {
        Name = "BoosterPage",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }
    local v54 = p13:New("Frame")({
        Name = "Background",
        BackgroundColor3 = Theme.Color.Base,
        ClipsDescendants = true,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 0,
        [Children] = {
            p13:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            p13:New("Frame")({
                Name = "Recess",
                BackgroundColor3 = Theme.Color.NeutralDark,
                BackgroundTransparency = 0.35,
                Size = UDim2.fromScale(1, 1),
                ZIndex = 0,
                [Children] = {
                    p13:New("UICorner")({
                        CornerRadius = UDim.new(0, 6)
                    })
                }
            }),
            p13:New("Frame")({
                Name = "Glow",
                BackgroundColor3 = Theme.Color.Primary,
                Size = UDim2.fromScale(1, 0.55),
                ZIndex = 1,
                [Children] = {
                    p13:New("UICorner")({
                        CornerRadius = UDim.new(0, 6)
                    }),
                    p13:New("UIGradient")({
                        Rotation = 90,
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.72),
                            NumberSequenceKeypoint.new(0.6, 0.9),
                            NumberSequenceKeypoint.new(1, 1)
                        })
                    })
                }
            })
        }
    })
    local Frame2 = p13:New("Frame")
    local t8 = {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 2
    }
    local v55 = p13:New("UIPadding")({
        PaddingTop = UDim.new(0, 14),
        PaddingBottom = UDim.new(0, 14),
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 14)
    })
    local v56 = p13:New("UIListLayout")({
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        VerticalFlex = Enum.UIFlexAlignment.None,
        Padding = UDim.new(0, 14),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local v57 = p13:New("Frame")({
        Name = "Header",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Size = UDim2.fromScale(1, 0),
        [Children] = {
            p13:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }),
            p13:New("ImageLabel")({
                Name = "Logo",
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                Image = Icons.LogoGlyph,
                Size = UDim2.fromOffset(24, 24)
            }),
            p13:New("TextLabel")({
                Name = "Title",
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                Text = "Extra",
                AutomaticSize = Enum.AutomaticSize.XY,
                FontFace = p13:Computed(function(p27) -- line: 432
                    -- upvalues: Theme (copy)
                    return Font.new(p27(Theme.Font.Heading), p27(Theme.FontWeight.Heading))
                end),
                TextColor3 = Theme.Color.BaseContent,
                TextSize = Theme.TextSize.Title
            })
        }
    })
    local Frame3 = p13:New("Frame")
    local t9 = {
        Name = "Body",
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Size = UDim2.fromScale(1, 0)
    }
    local v58 = p13:New("UIFlexItem")({
        FlexMode = Enum.UIFlexMode.Fill
    })
    local v59 = p13:New("UIPadding")({
        PaddingBottom = UDim.new(0, 8)
    })
    local v60 = p13:New("UIListLayout")({
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        VerticalFlex = Enum.UIFlexAlignment.None,
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
    local v61 = p13:New("Frame")({
        Name = "HeroStat",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Size = UDim2.fromScale(1, 0),
        [Children] = {
            p13:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }),
            p13:New("TextLabel")({
                Name = "Count",
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                AutomaticSize = Enum.AutomaticSize.XY,
                FontFace = p13:Computed(function(p28) -- line: 481
                    -- upvalues: Theme (copy)
                    return Font.new(p28(Theme.Font.Heading), p28(Theme.FontWeight.Heading))
                end),
                Text = v34,
                TextColor3 = Theme.Color.Primary,
                TextSize = v36
            }),
            p13:New("TextLabel")({
                Name = "CountLabel",
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                Text = "chat commands",
                AutomaticSize = Enum.AutomaticSize.XY,
                FontFace = p13:Computed(function(p29) -- line: 493
                    -- upvalues: Theme (copy)
                    return Font.new(p29(Theme.Font.Body), p29(Theme.FontWeight.Body))
                end),
                TextColor3 = Theme.Color.NeutralContentDark,
                TextSize = v36
            })
        }
    })
    local Frame4 = p13:New("Frame")
    local t10 = {
        Name = "SellingPoints",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Color.Neutral,
        LayoutOrder = 2,
        Size = UDim2.fromScale(1, 0)
    }
    local v62 = p13:New("UICorner")({
        CornerRadius = UDim.new(0, 9)
    })
    local v63 = p13:New("UIStroke")({
        Transparency = 0.5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Theme.Color.NeutralContent
    })
    local v64 = p13:New("UIPadding")({
        PaddingTop = UDim.new(0, 14),
        PaddingBottom = UDim.new(0, 14),
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 14)
    })
    local v65 = p13:New("UIListLayout")({
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        VerticalFlex = Enum.UIFlexAlignment.None,
        Padding = UDim.new(0, 20),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local t12 = {}

    for v66, v67 in t1 do
        table.insert(t12, makeSellingPoint(p13, v66, v67))
    end

    t10[Children] = {
        v62,
        v63,
        v64,
        v65,
        t12
    }
    t9[Children] = {
        v58,
        v59,
        v60,
        v61,
        Frame4(t10)
    }
    t8[Children] = {
        v55,
        v56,
        v57,
        Frame3(t9),
        p13:New("Frame")({
            Name = "Actions",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = 3,
            Size = UDim2.fromScale(1, 0),
            [Children] = {
                p13:New("UIListLayout")({
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    VerticalFlex = Enum.UIFlexAlignment.None,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }),
                p13:New("Frame")({
                    Name = "Timer",
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    LayoutOrder = 1,
                    Size = UDim2.fromScale(1, 0),
                    Visible = v14,
                    [Children] = {
                        p13:New("UIListLayout")({
                            FillDirection = Enum.FillDirection.Horizontal,
                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                            Padding = UDim.new(0, 4),
                            SortOrder = Enum.SortOrder.LayoutOrder,
                            VerticalAlignment = Enum.VerticalAlignment.Center
                        }),
                        p13:New("ImageLabel")({
                            Name = "Hourglass",
                            BackgroundTransparency = 1,
                            LayoutOrder = 1,
                            Image = Icons.HourglassHalfOutline,
                            ImageColor3 = Theme.Color.BaseContent,
                            Size = UDim2.fromOffset(14, 14)
                        }),
                        p13:New("TextLabel")({
                            Name = "Label",
                            BackgroundTransparency = 1,
                            LayoutOrder = 2,
                            RichText = true,
                            AutomaticSize = Enum.AutomaticSize.XY,
                            FontFace = p13:Computed(function(p30) -- line: 584
                                -- upvalues: Theme (copy)
                                return Font.new(p30(Theme.Font.Body), p30(Theme.FontWeight.Bold))
                            end),
                            Text = v37,
                            TextColor3 = Theme.Color.BaseContent,
                            TextSize = Theme.TextSize.Label
                        })
                    }
                }),
                Pressable(p13, {
                    name = "UnlockButton",
                    backgroundColor = Theme.Color.Primary,
                    size = UDim2.new(1, 0, 0, 44),
                    automaticSize = Enum.AutomaticSize.None,
                    layoutOrder = 2,
                    onActivate = purchase,
                    [Children] = {
                        p13:New("UICorner")({
                            CornerRadius = UDim.new(0, 6)
                        }),
                        p13:New("UIStroke")({
                            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                            Enabled = v14,
                            LineJoinMode = Enum.LineJoinMode.Round,
                            Color = Color3.new(1, 1, 1),
                            Thickness = 2,
                            Transparency = 0.35,
                            [Children] = { v50 }
                        }),
                        p13:New("Frame")({
                            Name = "Content",
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            AutomaticSize = Enum.AutomaticSize.X,
                            BackgroundTransparency = 1,
                            Position = UDim2.fromScale(0.5, 0.5),
                            Size = UDim2.fromScale(0, 1),
                            [Children] = {
                                p13:New("UIListLayout")({
                                    FillDirection = Enum.FillDirection.Horizontal,
                                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                    Padding = UDim.new(0, 6),
                                    SortOrder = Enum.SortOrder.LayoutOrder,
                                    VerticalAlignment = Enum.VerticalAlignment.Center
                                }),
                                p13:New("TextLabel")({
                                    Name = "Label",
                                    BackgroundTransparency = 1,
                                    LayoutOrder = 1,
                                    Text = "Unlock",
                                    AutomaticSize = Enum.AutomaticSize.XY,
                                    FontFace = p13:Computed(function(p31) -- line: 638
                                        -- upvalues: Theme (copy)
                                        return Font.new(p31(Theme.Font.Body), p31(Theme.FontWeight.Bold))
                                    end),
                                    TextColor3 = Theme.Color.PrimaryContent,
                                    TextSize = Theme.TextSize.Subtitle
                                }),
                                p13:New("Frame")({
                                    Name = "OldPrice",
                                    AutomaticSize = Enum.AutomaticSize.X,
                                    BackgroundTransparency = 1,
                                    LayoutOrder = 2,
                                    Size = UDim2.fromScale(0, 1),
                                    Visible = v14,
                                    [Children] = {
                                        p13:New("Frame")({
                                            Name = "Inner",
                                            AutomaticSize = Enum.AutomaticSize.X,
                                            BackgroundTransparency = 1,
                                            Size = UDim2.fromScale(0, 1),
                                            [Children] = {
                                                p13:New("UIListLayout")({
                                                    FillDirection = Enum.FillDirection.Horizontal,
                                                    Padding = UDim.new(0, 6),
                                                    SortOrder = Enum.SortOrder.LayoutOrder,
                                                    VerticalAlignment = Enum.VerticalAlignment.Center
                                                }),
                                                p13:New("ImageLabel")({
                                                    Name = "Robux",
                                                    BackgroundTransparency = 1,
                                                    LayoutOrder = 1,
                                                    Image = Icons.RobuxFill,
                                                    ImageColor3 = Theme.Color.PrimaryContent,
                                                    Size = UDim2.fromOffset(18, 18)
                                                }),
                                                p13:New("TextLabel")({
                                                    Name = "Amount",
                                                    BackgroundTransparency = 1,
                                                    LayoutOrder = 2,
                                                    AutomaticSize = Enum.AutomaticSize.XY,
                                                    FontFace = p13:Computed(function(p32) -- line: 678
                                                        -- upvalues: Theme (copy)
                                                        return Font.new(p32(Theme.Font.Body), p32(Theme.FontWeight.Bold))
                                                    end),
                                                    Text = v31,
                                                    TextColor3 = Theme.Color.PrimaryContent,
                                                    TextSize = Theme.TextSize.Subtitle
                                                })
                                            }
                                        }),
                                        p13:New("Frame")({
                                            Name = "Strike",
                                            BackgroundTransparency = 0.1,
                                            BorderSizePixel = 0,
                                            Rotation = -5,
                                            AnchorPoint = Vector2.new(0.5, 0.5),
                                            BackgroundColor3 = v33,
                                            Position = UDim2.new(0.5, 0, 0.49, 0),
                                            Size = UDim2.new(1, 0, 0, 2)
                                        })
                                    }
                                }),
                                p13:New("Frame")({
                                    Name = "NewPrice",
                                    AutomaticSize = Enum.AutomaticSize.X,
                                    BackgroundTransparency = 1,
                                    LayoutOrder = 3,
                                    Size = UDim2.fromScale(0, 1),
                                    [Children] = {
                                        p13:New("UIListLayout")({
                                            FillDirection = Enum.FillDirection.Horizontal,
                                            Padding = UDim.new(0, 6),
                                            SortOrder = Enum.SortOrder.LayoutOrder,
                                            VerticalAlignment = Enum.VerticalAlignment.Center
                                        }),
                                        p13:New("ImageLabel")({
                                            Name = "Robux",
                                            BackgroundTransparency = 1,
                                            LayoutOrder = 1,
                                            Image = Icons.RobuxFill,
                                            ImageColor3 = Theme.Color.PrimaryContent,
                                            Size = UDim2.fromOffset(18, 18)
                                        }),
                                        p13:New("TextLabel")({
                                            Name = "Amount",
                                            BackgroundTransparency = 1,
                                            LayoutOrder = 2,
                                            AutomaticSize = Enum.AutomaticSize.XY,
                                            FontFace = p13:Computed(function(p33) -- line: 725
                                                -- upvalues: Theme (copy)
                                                return Font.new(p33(Theme.Font.Body), p33(Theme.FontWeight.Bold))
                                            end),
                                            Text = v29,
                                            TextColor3 = Theme.Color.PrimaryContent,
                                            TextSize = Theme.TextSize.Subtitle
                                        })
                                    }
                                })
                            }
                        })
                    }
                }),
                p13:New("Frame")({
                    Name = "ViewRow",
                    BackgroundTransparency = 1,
                    LayoutOrder = 3,
                    Size = UDim2.new(1, 0, 0, 44),
                    [Children] = {
                        p13:New("UIListLayout")({
                            FillDirection = Enum.FillDirection.Horizontal,
                            Padding = UDim.new(0, 6),
                            SortOrder = Enum.SortOrder.LayoutOrder,
                            VerticalAlignment = Enum.VerticalAlignment.Center
                        }),
                        makeSecondaryButton(p13, 1, "View commands", viewCommands, UDim2.new(1, -50, 0, 44)),
                        OutfitsButton(p13, {
                            layoutOrder = 2,
                            size = UDim2.fromOffset(44, 44),
                            onActivate = function() -- onActivate | line: 756
                                -- upvalues: Panels (copy)
                                Panels.openOutfits()
                            end
                        })
                    }
                })
            }
        })
    }
    t7[Children] = {
        v54,
        Frame2(t8)
    }

    return Frame(t7)
end
