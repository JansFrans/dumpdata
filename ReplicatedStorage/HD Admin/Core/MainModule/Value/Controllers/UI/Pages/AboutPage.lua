-- https://lua.expert

local RunService = game:GetService("RunService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Icons = require(UI.Config.Icons)
local VERSION = require(UI.Config.VERSION)
local Credits = require(UI.Config.Credits)
local Panels = require(UI.Config.Panels)
local Divider = require(UI.Components.Divider)
local CreditBadge = require(UI.Components.CreditBadge)
local UpdatesLink = require(UI.Components.UpdatesLink)
local CosmeticCard = require(UI.Components.CosmeticCard)
local LoadingSpinner = require(UI.Components.LoadingSpinner)
local Pressable = require(UI.Components.Pressable)
local CosmeticMarket = require(UI.Util.CosmeticMarket)
local Prompt = require(Modules.Prompt)
local products = require(Modules.References.products)
local promptPurchaseAsync = require(Modules.AssetUtil.promptPurchaseAsync)
local shortenNumber = require(Modules.DataUtil.shortenNumber)
local Children = Fusion.Children

return function(p1, _) -- line: 49
    -- upvalues: RunService (copy), Fusion (copy), Theme (copy), Icons (copy), VERSION (copy), Credits (copy), Panels (copy), Divider (copy), CreditBadge (copy), UpdatesLink (copy), CosmeticCard (copy), LoadingSpinner (copy), Pressable (copy), CosmeticMarket (copy), Prompt (copy), products (copy), promptPurchaseAsync (copy), shortenNumber (copy), Children (copy)
    local v1 = false

    table.insert(p1, function() -- line: 52
        -- upvalues: v1 (ref)
        v1 = true
    end)

    local v3 = p1:Value(nil)

    task.spawn(function() -- line: 57
        -- upvalues: v1 (ref), v3 (copy), VERSION (copy)
        local v4 = VERSION.getLatestVersion()

        if not v1 then
            v3:set(v4)
        end
    end)

    local v5 = p1:Computed(function(p3) -- line: 63
        -- upvalues: v3 (copy), VERSION (copy)
        local v6 = p3(v3)

        if VERSION.isOutdatedVersion(v6) then
            return (("You're not on the latest version (%*). Update from the link below"):format(v6))
        end

        return ""
    end)
    local v7 = Color3.fromRGB(255, 255, 255)
    local v8 = p1:Computed(function(p4) -- line: 72
        -- upvalues: v3 (copy), VERSION (copy)
        local v9 = p4(v3)

        if VERSION.isOutdatedVersion(v9) then
            return (Color3.fromRGB(251, 191, 36))
        end

        return (Color3.fromRGB(212, 212, 216))
    end)
    local v10 = p1:Value(Credits.Contributors)
    local v11 = p1:Value(Credits.Libraries)
    local SpecialAccessories = p1:Fuse("everyone", "SpecialAccessories")
    local TopSupporters = p1:Fuse("everyone", "TopSupporters")
    local t1 = {
        Color3.fromRGB(255, 196, 61),
        Color3.fromRGB(196, 204, 216),
        Color3.fromRGB(214, 140, 84)
    }
    local v12 = p1:Computed(function(p5) -- line: 93
        -- upvalues: SpecialAccessories (copy)
        local v13 = p5(SpecialAccessories)

        if typeof(v13) ~= "table" then
            return {}
        end

        local t2 = {}

        for _, v14 in v13 do
            if typeof(v14) == "table" and v14.id then
                table.insert(t2, v14)
            end
        end

        table.sort(t2, function(p6, p7) -- line: 102
            local v15 = p6.order or 1e999
            local v16 = p7.order or 1e999

            if v15 ~= v16 then
                return v15 < v16
            end

            return tostring(p6.name) < tostring(p7.name)
        end)

        local t3 = {}

        for i = 1, math.min(2, #t2) do
            t3[i] = t2[i]
        end

        return t3
    end)
    local t4 = {}

    for _, v19 in products do
        if v19.donationRobux and (v19.id ~= 0 or RunService:IsStudio()) then
            table.insert(t4, v19)
        end
    end

    table.sort(t4, function(p8, p9) -- line: 121
        return p8.donationRobux < p9.donationRobux
    end)
    p1:Value(t4)

    local v20 = p1:Value(nil)

    local function toggleCreditLink(p10, p11, p12) -- line: 128
        -- upvalues: v20 (copy), Fusion (copy)
        local v21 = Fusion.peek(v20)

        if not v21 or v21.url ~= p11 then
            v20:set({
                name = p10,
                url = p11,
                icon = p12
            })
        else
            v20:set(nil)
        end
    end

    local v22 = p1:Computed(function(p13) -- line: 136
        -- upvalues: v20 (copy)
        local v23 = p13(v20)

        if v23 then
            return v23.icon
        end

        return ""
    end)
    local v24 = p1:Computed(function(p14) -- line: 140
        -- upvalues: v20 (copy)
        local v25 = p14(v20)

        if v25 then
            return v25.url
        end

        return ""
    end)
    local v26 = p1:Spring(p1:Computed(function(p15) -- line: 145
        -- upvalues: v20 (copy)
        if p15(v20) then
            return 54
        end

        return 0
    end), 40, 1)

    local function sectionHeading(p16, p17, p18) -- line: 149
        -- upvalues: Theme (copy)
        return p16:New("TextLabel")({
            Name = "Heading",
            BackgroundTransparency = 1,
            TextWrapped = true,
            AutomaticSize = Enum.AutomaticSize.Y,
            FontFace = p16:Computed(function(p19) -- line: 154
                -- upvalues: Theme (copy)
                return Font.new(p19(Theme.Font.Heading), p19(Theme.FontWeight.Heading))
            end),
            LayoutOrder = p18,
            Size = UDim2.fromScale(1, 0),
            Text = p17,
            TextColor3 = Theme.Color.BaseContent,
            TextSize = Theme.TextSize.Title,
            TextXAlignment = Enum.TextXAlignment.Center
        })
    end

    local function groupHeading(p20, p21) -- line: 167
        -- upvalues: Theme (copy)
        return p20:New("TextLabel")({
            Name = "GroupHeading",
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            TextWrapped = true,
            AutomaticSize = Enum.AutomaticSize.XY,
            FontFace = p20:Computed(function(p22) -- line: 172
                -- upvalues: Theme (copy)
                return Font.new(p22(Theme.Font.Body), p22(Theme.FontWeight.Bold))
            end),
            Text = p21,
            TextColor3 = Theme.Color.BaseContent,
            TextSize = Theme.TextSize.Subtitle,
            TextXAlignment = Enum.TextXAlignment.Center
        })
    end

    local function donationText(p23) -- line: 184
        -- upvalues: shortenNumber (copy)
        return shortenNumber(p23)
    end

    local function promptDonation(p24) -- line: 188
        -- upvalues: Prompt (copy), promptPurchaseAsync (copy)
        if p24.id == 0 then
            Prompt.warn("Donations are coming soon")
        else
            task.spawn(function() -- line: 193
                -- upvalues: p24 (copy), Prompt (copy), promptPurchaseAsync (copy)
                local v27, v28 = promptPurchaseAsync(p24.id, nil, p24.infoType)

                if not v27 and typeof(v28) == "string" and v28 ~= "" then
                    Prompt.warn(v28)
                end
            end)
        end
    end

    return p1:New("Frame")({
        Name = "AboutPage",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        [Children] = {
            p1:New("UIPadding")({
                PaddingBottom = UDim.new(0, 20)
            }),
            p1:New("ScrollingFrame")({
                Name = "Sections",
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                BottomImage = "rbxassetid://16547643439",
                CanvasSize = UDim2.new(),
                MidImage = "rbxassetid://16547330984",
                ScrollBarImageTransparency = 1,
                ScrollBarThickness = 0,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                Size = p1:Computed(function(p25) -- line: 224
                    -- upvalues: v26 (copy)
                    return UDim2.new(1, 0, 1, -p25(v26))
                end),
                TopImage = "rbxassetid://16547667444",
                [Children] = {
                    p1:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Vertical,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        Padding = UDim.new(0, 12),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    p1:New("Frame")({
                        Name = "HeroBanner",
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        LayoutOrder = 1,
                        Size = UDim2.fromScale(1, 0),
                        [Children] = {
                            p1:Computed(function(_, p27) -- line: 245
                                -- upvalues: Children (copy)
                                return p27:New("ImageLabel")({
                                    Name = "BannerImage",
                                    BackgroundTransparency = 1,
                                    Image = "rbxassetid://96375899701520",
                                    ScaleType = Enum.ScaleType.Crop,
                                    Size = UDim2.fromScale(1, 1),
                                    ZIndex = 0,
                                    [Children] = {
                                        p27:New("UIGradient")({
                                            Rotation = 90,
                                            Transparency = NumberSequence.new({
                                                NumberSequenceKeypoint.new(0, 0),
                                                NumberSequenceKeypoint.new(0.65, 0.1),
                                                NumberSequenceKeypoint.new(1, 1)
                                            })
                                        })
                                    }
                                })
                            end),
                            p1:New("Frame")({
                                Name = "Content",
                                AutomaticSize = Enum.AutomaticSize.Y,
                                BackgroundTransparency = 1,
                                Size = UDim2.fromScale(1, 0),
                                ZIndex = 2,
                                [Children] = {
                                    p1:New("UIPadding")({
                                        PaddingBottom = UDim.new(0, 14),
                                        PaddingLeft = UDim.new(0, 14),
                                        PaddingRight = UDim.new(0, 14),
                                        PaddingTop = UDim.new(0, 18)
                                    }),
                                    p1:New("UIListLayout")({
                                        FillDirection = Enum.FillDirection.Vertical,
                                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                        Padding = UDim.new(0, 10),
                                        SortOrder = Enum.SortOrder.LayoutOrder
                                    }),
                                    p1:New("TextLabel")({
                                        Name = "Title",
                                        BackgroundTransparency = 1,
                                        LayoutOrder = 2,
                                        AutomaticSize = Enum.AutomaticSize.XY,
                                        FontFace = p1:Computed(function(p28) -- line: 312
                                            -- upvalues: Theme (copy)
                                            return Font.new(p28(Theme.Font.Heading), p28(Theme.FontWeight.Heading))
                                        end),
                                        Text = ("HD Admin %*"):format(VERSION.appVersion),
                                        TextColor3 = v7,
                                        TextSize = Theme.TextSize.Title,
                                        TextXAlignment = Enum.TextXAlignment.Center
                                    }),
                                    p1:New("Frame")({
                                        Name = "BadgeRow",
                                        AutomaticSize = Enum.AutomaticSize.XY,
                                        BackgroundTransparency = 1,
                                        LayoutOrder = 3,
                                        [Children] = {
                                            p1:New("UIListLayout")({
                                                FillDirection = Enum.FillDirection.Vertical,
                                                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                                Padding = UDim.new(0, 6),
                                                SortOrder = Enum.SortOrder.LayoutOrder
                                            }),
                                            p1:Computed(function(p29, p30) -- line: 334
                                                -- upvalues: v3 (copy), Theme (copy), Icons (copy), VERSION (copy), CreditBadge (copy)
                                                local v36 = p29(v3)

                                                if v36 == nil then
                                                    return nil
                                                end

                                                local v37 = VERSION.isOutdatedVersion(v36)
                                                local t10 = {
                                                    paddingRight = 14,
                                                    layoutOrder = 2
                                                }

                                                t10.text = v37 and "Update available" or "All up-to date!"

                                                if v37 then
                                                    t10.icon = Icons.WarningFill
                                                    t10.iconColor = Theme.Color.Warning
                                                else
                                                    t10.icon = Icons.CheckMarkFill
                                                    t10.iconColor = Theme.Color.Success
                                                end

                                                t10.backgroundColor = Theme.Color.Neutral

                                                if v37 then
                                                    t10.strokeColor = Theme.Color.Warning
                                                    t10.textColor = Theme.Color.Warning
                                                else
                                                    t10.strokeColor = Theme.Color.Success
                                                    t10.textColor = Theme.Color.Success
                                                end

                                                return CreditBadge(p30, t10)
                                            end)
                                        }
                                    }),
                                    p1:New("TextLabel")({
                                        Name = "UpdatesHint",
                                        BackgroundTransparency = 1,
                                        LayoutOrder = 4,
                                        TextWrapped = true,
                                        AutomaticSize = Enum.AutomaticSize.Y,
                                        FontFace = p1:Computed(function(p31) -- line: 358
                                            -- upvalues: Theme (copy)
                                            return Font.new(p31(Theme.Font.Body), p31(Theme.FontWeight.Regular))
                                        end),
                                        Size = UDim2.fromScale(0.7, 0),
                                        Text = v5,
                                        TextColor3 = v8,
                                        TextSize = Theme.TextSize.Label,
                                        TextXAlignment = Enum.TextXAlignment.Center,
                                        Visible = p1:Computed(function(p32) -- line: 368
                                            -- upvalues: v5 (copy)
                                            return p32(v5) ~= ""
                                        end)
                                    }),
                                    UpdatesLink(p1, {
                                        label = "Get a free copy:",
                                        layoutOrder = 5,
                                        url = VERSION.updatesUrl
                                    }),
                                    UpdatesLink(p1, {
                                        label = "Try it out:",
                                        layoutOrder = 6,
                                        url = VERSION.tryItUrl
                                    })
                                }
                            })
                        }
                    }),
                    p1:New("Frame")({
                        Name = "Body",
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        LayoutOrder = 2,
                        Size = UDim2.fromScale(1, 0),
                        [Children] = {
                            p1:New("UIPadding")({
                                PaddingBottom = p1:Computed(function(p33) -- line: 397
                                    -- upvalues: Theme (copy)
                                    return UDim.new(0, p33(Theme.Layout.Padding))
                                end),
                                PaddingLeft = p1:Computed(function(p34) -- line: 398
                                    -- upvalues: Theme (copy)
                                    return UDim.new(0, p34(Theme.Layout.Padding))
                                end),
                                PaddingRight = p1:Computed(function(p35) -- line: 399
                                    -- upvalues: Theme (copy)
                                    return UDim.new(0, p35(Theme.Layout.Padding))
                                end)
                            }),
                            p1:New("UIListLayout")({
                                FillDirection = Enum.FillDirection.Vertical,
                                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                                Padding = UDim.new(0, 16),
                                SortOrder = Enum.SortOrder.LayoutOrder
                            }),
                            p1:New("Frame")({
                                Name = "Cosmetics",
                                AutomaticSize = Enum.AutomaticSize.Y,
                                BackgroundTransparency = 1,
                                LayoutOrder = 5,
                                [Children] = {
                                    p1:New("UIListLayout")({
                                        FillDirection = Enum.FillDirection.Vertical,
                                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                                        Padding = UDim.new(0, 16),
                                        SortOrder = Enum.SortOrder.LayoutOrder
                                    }),
                                    sectionHeading(p1, "Cosmetics", 1),
                                    p1:Computed(function(p36, p37) -- line: 422
                                        -- upvalues: v12 (copy), CosmeticCard (copy), LoadingSpinner (copy), CosmeticMarket (copy), Children (copy)
                                        local v44 = p36(v12)

                                        if #v44 == 0 then
                                            return LoadingSpinner(p37, {
                                                layoutOrder = 2
                                            })
                                        end

                                        local t14 = {}

                                        for v45, v46 in v44 do
                                            local id = v46.id
                                            local v47 = v46.comingSoon == true
                                            local v48 = p37:Value(if v47 then 0 else CosmeticMarket.peekPrice(id))
                                            local v49 = p37:Value(not v47 and CosmeticMarket.peekFavourite(id))

                                            if not v47 then
                                                CosmeticMarket.seedPrice(id, v48)
                                                CosmeticMarket.seedFavourite(id, v49)
                                            end

                                            table.insert(t14, CosmeticCard(p37, {
                                                accessoryId = id,
                                                name = if v47 then "Coming Soon" else tostring(v46.name),
                                                robuxPrice = v48,
                                                isFavourited = v49,
                                                onFavourite = function() -- onFavourite | line: 442
                                                    -- upvalues: id (copy), v47 (copy), v49 (copy), CosmeticMarket (copy)
                                                    if v47 then
                                                        CosmeticMarket.notifyComingSoon()
                                                    else
                                                        CosmeticMarket.toggleFavourite(id, v49)
                                                    end
                                                end,
                                                onBuy = function() -- onBuy | line: 449
                                                    -- upvalues: id (copy), v47 (copy), CosmeticMarket (copy)
                                                    if v47 then
                                                        CosmeticMarket.notifyComingSoon()
                                                    else
                                                        CosmeticMarket.buy(id)
                                                    end
                                                end,
                                                layoutOrder = v45
                                            }))
                                        end

                                        return p37:New("Frame")({
                                            Name = "FeaturedCards",
                                            AutomaticSize = Enum.AutomaticSize.Y,
                                            BackgroundTransparency = 1,
                                            LayoutOrder = 2,
                                            Size = UDim2.fromScale(1, 0),
                                            [Children] = {
                                                p37:New("UIListLayout")({
                                                    FillDirection = Enum.FillDirection.Horizontal,
                                                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                                                    Padding = UDim.new(0, 8),
                                                    SortOrder = Enum.SortOrder.LayoutOrder
                                                }),
                                                t14
                                            }
                                        })
                                    end),
                                    Pressable(p1, {
                                        name = "ShopAll",
                                        automaticSize = Enum.AutomaticSize.Y,
                                        backgroundColor = Theme.Color.Primary,
                                        layoutOrder = 3,
                                        onActivate = function() -- onActivate | line: 481
                                            -- upvalues: Panels (copy)
                                            Panels.openOutfits()
                                        end,
                                        size = UDim2.fromScale(1, 0),
                                        [Children] = {
                                            p1:New("UICorner")({
                                                CornerRadius = UDim.new(0, 6)
                                            }),
                                            p1:New("UIPadding")({
                                                PaddingBottom = UDim.new(0, 8),
                                                PaddingLeft = UDim.new(0, 16),
                                                PaddingRight = UDim.new(0, 16),
                                                PaddingTop = UDim.new(0, 8)
                                            }),
                                            p1:New("UIListLayout")({
                                                FillDirection = Enum.FillDirection.Horizontal,
                                                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                                HorizontalFlex = Enum.UIFlexAlignment.None,
                                                VerticalFlex = Enum.UIFlexAlignment.None,
                                                SortOrder = Enum.SortOrder.LayoutOrder,
                                                VerticalAlignment = Enum.VerticalAlignment.Center
                                            }),
                                            p1:New("TextLabel")({
                                                Name = "Label",
                                                BackgroundTransparency = 1,
                                                Text = "Shop All",
                                                AutomaticSize = Enum.AutomaticSize.XY,
                                                FontFace = p1:Computed(function(p38) -- line: 506
                                                    -- upvalues: Theme (copy)
                                                    return Font.new(p38(Theme.Font.Body), p38(Theme.FontWeight.Bold))
                                                end),
                                                TextColor3 = Theme.Color.PrimaryContent,
                                                TextSize = Theme.TextSize.Subtitle
                                            })
                                        }
                                    })
                                }
                            }),
                            Divider(p1, {
                                layoutOrder = 6
                            }),
                            p1:Computed(function(p39, p40) -- line: 520
                                -- upvalues: TopSupporters (copy), t1 (copy), sectionHeading (copy), Theme (copy), VERSION (copy), Divider (copy), UpdatesLink (copy), shortenNumber (copy), Children (copy)
                                local v53 = p39(TopSupporters)
                                local top = if typeof(v53) == "table" then v53.top else nil

                                if typeof(top) ~= "table" or #top == 0 then
                                    return nil
                                end

                                local t16 = {
                                    p40:New("UIListLayout")({
                                        FillDirection = Enum.FillDirection.Vertical,
                                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                                        Padding = UDim.new(0, 6),
                                        SortOrder = Enum.SortOrder.LayoutOrder
                                    })
                                }

                                for v54, v55 in top do
                                    local userId, robux = v55.userId, v55.robux
                                    local v56 = t1[v54]
                                    local v57 = if typeof(v55.displayName) ~= "string" then tostring(userId) elseif v55.displayName == "" then tostring(userId) else v55.displayName
                                    local v58 = if typeof(v55.name) ~= "string" then "" elseif v55.name == "" then "" else ("@%*"):format(v55.name)

                                    table.insert(t16, p40:New("Frame")({
                                        Name = "Supporter_" .. v54,
                                        BackgroundColor3 = Theme.Color.Neutral,
                                        LayoutOrder = v54,
                                        Size = UDim2.new(1, 0, 0, 46),
                                        [Children] = {
                                            p40:New("UICorner")({
                                                CornerRadius = p40:Computed(function(p41) -- line: 548
                                                    -- upvalues: Theme (copy)
                                                    return UDim.new(0, p41(Theme.Layout.CornerRadius) + 4)
                                                end)
                                            }),
                                            p40:New("UIPadding")({
                                                PaddingLeft = UDim.new(0, 12),
                                                PaddingRight = UDim.new(0, 12)
                                            }),
                                            p40:New("UIListLayout")({
                                                FillDirection = Enum.FillDirection.Horizontal,
                                                Padding = UDim.new(0, 10),
                                                SortOrder = Enum.SortOrder.LayoutOrder,
                                                VerticalAlignment = Enum.VerticalAlignment.Center
                                            }),
                                            p40:New("Frame")({
                                                Name = "Place",
                                                BackgroundColor3 = v56 or Theme.Color.NeutralDark,
                                                LayoutOrder = 1,
                                                Size = UDim2.fromOffset(22, 22),
                                                [Children] = {
                                                    p40:New("UICorner")({
                                                        CornerRadius = UDim.new(1, 0)
                                                    }),
                                                    p40:New("TextLabel")({
                                                        Name = "Number",
                                                        BackgroundTransparency = 1,
                                                        FontFace = p40:Computed(function(p42) -- line: 572
                                                            -- upvalues: Theme (copy)
                                                            return Font.new(p42(Theme.Font.Body), p42(Theme.FontWeight.Bold))
                                                        end),
                                                        Size = UDim2.fromScale(1, 1),
                                                        Text = tostring(v54),
                                                        TextColor3 = if v56 then Color3.fromRGB(24, 24, 27) else Theme.Color.NeutralContentDark,
                                                        TextSize = Theme.TextSize.Label
                                                    })
                                                }
                                            }),
                                            p40:New("ImageLabel")({
                                                Name = "Avatar",
                                                BackgroundColor3 = Theme.Color.NeutralDark,
                                                Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(userId),
                                                LayoutOrder = 2,
                                                Size = UDim2.fromOffset(28, 28),
                                                [Children] = {
                                                    p40:New("UICorner")({
                                                        CornerRadius = UDim.new(1, 0)
                                                    }),
                                                    p40:Computed(function(_, p44) -- line: 590
                                                        -- upvalues: v56 (copy)
                                                        if v56 then
                                                            return p44:New("UIStroke")({
                                                                Thickness = 2,
                                                                Color = v56
                                                            })
                                                        end

                                                        return nil
                                                    end)
                                                }
                                            }),
                                            p40:New("Frame")({
                                                Name = "Names",
                                                BackgroundTransparency = 1,
                                                LayoutOrder = 3,
                                                Size = UDim2.new(0, 0, 1, 0),
                                                [Children] = {
                                                    p40:New("UIFlexItem")({
                                                        FlexMode = Enum.UIFlexMode.Fill
                                                    }),
                                                    p40:New("UIListLayout")({
                                                        SortOrder = Enum.SortOrder.LayoutOrder,
                                                        VerticalAlignment = Enum.VerticalAlignment.Center
                                                    }),
                                                    p40:New("TextLabel")({
                                                        Name = "Name",
                                                        BackgroundTransparency = 1,
                                                        LayoutOrder = 1,
                                                        FontFace = p40:Computed(function(p45) -- line: 612
                                                            -- upvalues: Theme (copy)
                                                            return Font.new(p45(Theme.Font.Body), p45(Theme.FontWeight.Bold))
                                                        end),
                                                        Size = UDim2.new(1, 0, 0, 21),
                                                        Text = v57,
                                                        TextColor3 = Theme.Color.BaseContent,
                                                        TextSize = Theme.TextSize.Subtitle,
                                                        TextTruncate = Enum.TextTruncate.AtEnd,
                                                        TextXAlignment = Enum.TextXAlignment.Left
                                                    }),
                                                    p40:Computed(function(_, p47) -- line: 623
                                                        -- upvalues: v58 (copy), Theme (copy)
                                                        if v58 == "" then
                                                            return nil
                                                        end

                                                        return p47:New("TextLabel")({
                                                            Name = "Detail",
                                                            BackgroundTransparency = 1,
                                                            LayoutOrder = 2,
                                                            FontFace = p47:Computed(function(p48) -- line: 630
                                                                -- upvalues: Theme (copy)
                                                                return Font.new(p48(Theme.Font.Body), p48(Theme.FontWeight.Regular))
                                                            end),
                                                            Size = UDim2.new(1, 0, 0, 15),
                                                            Text = v58,
                                                            TextColor3 = Theme.Color.NeutralContentDark,
                                                            TextSize = Theme.TextSize.Small,
                                                            TextTruncate = Enum.TextTruncate.AtEnd,
                                                            TextXAlignment = Enum.TextXAlignment.Left
                                                        })
                                                    end)
                                                }
                                            }),
                                            p40:New("Frame")({
                                                Name = "Amount",
                                                AutomaticSize = Enum.AutomaticSize.X,
                                                BackgroundTransparency = 1,
                                                LayoutOrder = 4,
                                                Size = UDim2.new(0, 0, 1, 0),
                                                [Children] = {
                                                    p40:New("UIListLayout")({
                                                        FillDirection = Enum.FillDirection.Horizontal,
                                                        HorizontalAlignment = Enum.HorizontalAlignment.Right,
                                                        Padding = UDim.new(0, 4),
                                                        SortOrder = Enum.SortOrder.LayoutOrder,
                                                        VerticalAlignment = Enum.VerticalAlignment.Center
                                                    }),
                                                    p40:New("TextLabel")({
                                                        Name = "Value",
                                                        BackgroundTransparency = 1,
                                                        LayoutOrder = 2,
                                                        AutomaticSize = Enum.AutomaticSize.X,
                                                        FontFace = p40:Computed(function(p49) -- line: 662
                                                            -- upvalues: Theme (copy)
                                                            return Font.new(p49(Theme.Font.Body), p49(Theme.FontWeight.Bold))
                                                        end),
                                                        Size = UDim2.new(0, 0, 1, 0),
                                                        Text = ("%*"):format((shortenNumber(robux))),
                                                        TextColor3 = Theme.Color.Primary,
                                                        TextSize = Theme.TextSize.Body
                                                    })
                                                }
                                            })
                                        }
                                    }))
                                end

                                return {
                                    p40:New("Frame")({
                                        Name = "Supporters",
                                        AutomaticSize = Enum.AutomaticSize.Y,
                                        BackgroundTransparency = 1,
                                        LayoutOrder = 3,
                                        Size = UDim2.fromScale(1, 0),
                                        [Children] = {
                                            p40:New("UIListLayout")({
                                                FillDirection = Enum.FillDirection.Vertical,
                                                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                                                Padding = UDim.new(0, 14),
                                                SortOrder = Enum.SortOrder.LayoutOrder
                                            }),
                                            sectionHeading(p40, "Top Supporters", 1),
                                            p40:New("Frame")({
                                                Name = "Rows",
                                                AutomaticSize = Enum.AutomaticSize.Y,
                                                BackgroundTransparency = 1,
                                                LayoutOrder = 2,
                                                Size = UDim2.fromScale(1, 0),
                                                [Children] = t16
                                            }),
                                            UpdatesLink(p40, {
                                                label = "Donate here:",
                                                layoutOrder = 3,
                                                url = VERSION.tryItUrl
                                            })
                                        }
                                    }),
                                    Divider(p40, {
                                        layoutOrder = 4
                                    })
                                }
                            end),
                            p1:New("Frame")({
                                Name = "Credits",
                                AutomaticSize = Enum.AutomaticSize.XY,
                                BackgroundTransparency = 1,
                                LayoutOrder = 7,
                                [Children] = {
                                    p1:New("UIListLayout")({
                                        FillDirection = Enum.FillDirection.Vertical,
                                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                                        Padding = UDim.new(0, 18),
                                        SortOrder = Enum.SortOrder.LayoutOrder
                                    }),
                                    sectionHeading(p1, "Credits", 1),
                                    p1:New("Frame")({
                                        Name = "ContributorGroups",
                                        AutomaticSize = Enum.AutomaticSize.XY,
                                        BackgroundTransparency = 1,
                                        LayoutOrder = 2,
                                        [Children] = {
                                            p1:New("UIListLayout")({
                                                FillDirection = Enum.FillDirection.Vertical,
                                                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                                Padding = UDim.new(0, 18),
                                                SortOrder = Enum.SortOrder.LayoutOrder
                                            }),
                                            p1:ForValues(v10, function(_, p51, p52, p53) -- line: 739
                                                -- upvalues: toggleCreditLink (copy), groupHeading (copy), CreditBadge (copy), Children (copy)
                                                local v72 = p51:Value(p52.Members)

                                                return p51:New("Frame")({
                                                    Name = "Group_" .. p52.Name,
                                                    AutomaticSize = Enum.AutomaticSize.XY,
                                                    BackgroundTransparency = 1,
                                                    LayoutOrder = p53,
                                                    [Children] = {
                                                        p51:New("UIListLayout")({
                                                            FillDirection = Enum.FillDirection.Vertical,
                                                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                                            Padding = UDim.new(0, 9),
                                                            SortOrder = Enum.SortOrder.LayoutOrder
                                                        }),
                                                        groupHeading(p51, p52.Name),
                                                        p51:New("Frame")({
                                                            Name = "Badges",
                                                            AutomaticSize = Enum.AutomaticSize.XY,
                                                            BackgroundTransparency = 1,
                                                            LayoutOrder = 2,
                                                            [Children] = {
                                                                p51:New("UIListLayout")({
                                                                    Wraps = true,
                                                                    FillDirection = Enum.FillDirection.Horizontal,
                                                                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                                                    Padding = UDim.new(0, 9),
                                                                    SortOrder = Enum.SortOrder.LayoutOrder
                                                                }),
                                                                p51:ForValues(v72, function(_, p55, p56, p57) -- line: 769
                                                                    -- upvalues: toggleCreditLink (copy), CreditBadge (copy)
                                                                    local v73 = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(p56.UserId) .. "&w=48&h=48"

                                                                    return CreditBadge(p55, {
                                                                        text = p56.Name,
                                                                        icon = v73,
                                                                        layoutOrder = p57,
                                                                        onActivate = function() -- onActivate | line: 775
                                                                            -- upvalues: p56 (copy), v73 (copy), toggleCreditLink (copy)
                                                                            toggleCreditLink(p56.Name, "https://www.roblox.com/users/" .. tostring(p56.UserId) .. "/profile", v73)
                                                                        end
                                                                    })
                                                                end)
                                                            }
                                                        })
                                                    }
                                                })
                                            end)
                                        }
                                    }),
                                    p1:New("Frame")({
                                        Name = "Libraries",
                                        AutomaticSize = Enum.AutomaticSize.XY,
                                        BackgroundTransparency = 1,
                                        LayoutOrder = 3,
                                        [Children] = {
                                            p1:New("UIListLayout")({
                                                FillDirection = Enum.FillDirection.Vertical,
                                                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                                Padding = UDim.new(0, 9),
                                                SortOrder = Enum.SortOrder.LayoutOrder
                                            }),
                                            groupHeading(p1, "Libraries"),
                                            p1:New("Frame")({
                                                Name = "Badges",
                                                AutomaticSize = Enum.AutomaticSize.XY,
                                                BackgroundTransparency = 1,
                                                LayoutOrder = 2,
                                                [Children] = {
                                                    p1:New("UIListLayout")({
                                                        Wraps = true,
                                                        FillDirection = Enum.FillDirection.Horizontal,
                                                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                                        Padding = UDim.new(0, 9),
                                                        SortOrder = Enum.SortOrder.LayoutOrder
                                                    }),
                                                    p1:ForValues(v11, function(_, p59, p60, p61) -- line: 815
                                                        -- upvalues: toggleCreditLink (copy), CreditBadge (copy)
                                                        return CreditBadge(p59, {
                                                            text = p60.Name,
                                                            icon = p60.Image,
                                                            layoutOrder = p61,
                                                            onActivate = function() -- onActivate | line: 820
                                                                -- upvalues: p60 (copy), toggleCreditLink (copy)
                                                                toggleCreditLink(p60.Name, p60.Link, p60.Image)
                                                            end
                                                        })
                                                    end)
                                                }
                                            })
                                        }
                                    })
                                }
                            }),
                            p1:Computed(function(_, _) -- line: 833
                                return nil
                            end)
                        }
                    })
                }
            }),
            p1:New("Frame")({
                Name = "CreditLinkWrap",
                AnchorPoint = Vector2.new(0, 1),
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                Position = UDim2.fromScale(0, 1),
                Size = p1:Computed(function(p64) -- line: 1006
                    -- upvalues: v26 (copy)
                    return UDim2.new(1, 0, 0, p64(v26))
                end),
                [Children] = {
                    p1:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Vertical,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        VerticalFlex = Enum.UIFlexAlignment.None,
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    Divider(p1, {
                        layoutOrder = 1,
                        paddingY = 0
                    }),
                    p1:New("Frame")({
                        Name = "LinkRow",
                        BackgroundTransparency = 1,
                        LayoutOrder = 2,
                        Size = UDim2.new(1, 0, 0, 0),
                        [Children] = {
                            p1:New("UIFlexItem")({
                                FlexMode = Enum.UIFlexMode.Fill
                            }),
                            p1:New("UIPadding")({
                                PaddingBottom = UDim.new(0, 8),
                                PaddingLeft = UDim.new(0, 14),
                                PaddingRight = UDim.new(0, 14),
                                PaddingTop = UDim.new(0, 8)
                            }),
                            p1:New("UIListLayout")({
                                FillDirection = Enum.FillDirection.Horizontal,
                                HorizontalFlex = Enum.UIFlexAlignment.None,
                                VerticalFlex = Enum.UIFlexAlignment.None,
                                Padding = UDim.new(0, 10),
                                SortOrder = Enum.SortOrder.LayoutOrder,
                                VerticalAlignment = Enum.VerticalAlignment.Center
                            }),
                            p1:New("TextBox")({
                                Name = "Url",
                                AutoLocalize = false,
                                BackgroundColor3 = Theme.Color.Neutral,
                                ClearTextOnFocus = false,
                                ClipsDescendants = true,
                                FontFace = p1:Computed(function(p65) -- line: 1049
                                    -- upvalues: Theme (copy)
                                    return Font.new(p65(Theme.Font.Body), p65(Theme.FontWeight.Body))
                                end),
                                LayoutOrder = 1,
                                Size = UDim2.new(0, 0, 1, 0),
                                Text = v24,
                                TextColor3 = Theme.Color.BaseContent,
                                TextEditable = false,
                                TextSize = Theme.TextSize.Label,
                                TextTruncate = Enum.TextTruncate.AtEnd,
                                TextXAlignment = Enum.TextXAlignment.Left,
                                [Children] = {
                                    p1:New("UICorner")({
                                        CornerRadius = UDim.new(0, 6)
                                    }),
                                    p1:New("UIStroke")({
                                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                        Color = Theme.Color.NeutralStroke
                                    }),
                                    p1:New("UIPadding")({
                                        PaddingLeft = UDim.new(0, 36),
                                        PaddingRight = UDim.new(0, 34)
                                    }),
                                    p1:New("UIFlexItem")({
                                        FlexMode = Enum.UIFlexMode.Fill
                                    }),
                                    p1:New("ImageLabel")({
                                        Name = "Icon",
                                        BackgroundTransparency = 1,
                                        AnchorPoint = Vector2.new(0, 0.5),
                                        Image = v22,
                                        Position = UDim2.new(0, -28, 0.5, 0),
                                        Size = UDim2.fromOffset(20, 20)
                                    }),
                                    Pressable(p1, {
                                        name = "CloseButton",
                                        iconSize = 14,
                                        anchorPoint = Vector2.new(1, 0.5),
                                        position = UDim2.new(1, 30, 0.5, 0),
                                        size = UDim2.fromOffset(26, 26),
                                        iconImage = Icons.Close,
                                        iconColor = Theme.Color.NeutralContentDark,
                                        onActivate = function() -- onActivate | line: 1092
                                            -- upvalues: v20 (copy)
                                            v20:set(nil)
                                        end
                                    })
                                }
                            })
                        }
                    })
                }
            })
        }
    })
end
