-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Popup = require(UI.Components.Popup)
local Pressable = require(UI.Components.Pressable)
local Icons = require(UI.Config.Icons)
local UpdateLog = require(UI.Config.UpdateLog)
local Children = Fusion.Children

local function updateBodyBlocks(p1, p2) -- line: 27
    -- upvalues: Theme (copy), Children (copy)
    local v1 = p1:Computed(function(p3) -- line: 28
        -- upvalues: Theme (copy)
        return Font.new(p3(Theme.Font.Body), Enum.FontWeight.Medium)
    end)
    local t1 = {
        p1:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
    }
    local n1 = 0
    local t2 = {}

    local function pushParagraph() -- line: 41
        -- upvalues: p1 (copy), v1 (copy), t1 (copy), n1 (ref), t2 (ref), Theme (copy)
        if #t2 == 0 then
            return
        end

        n1 += 1
        table.insert(t1, p1:New("TextLabel")({
            Name = "Paragraph",
            BackgroundTransparency = 1,
            RichText = true,
            TextTransparency = 0.1,
            TextWrapped = true,
            AutomaticSize = Enum.AutomaticSize.Y,
            FontFace = v1,
            LayoutOrder = n1,
            Size = UDim2.new(1, 0, 0, 0),
            Text = table.concat(t2, "\n"),
            TextColor3 = Theme.Color.BaseContent,
            TextSize = Theme.TextSize.Body,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top
        }))
        t2 = {}
    end

    for match in string.gmatch(p2 .. "\n", "(.-)\n") do
        local v2 = string.match(match, "^%s*%-%s+(.*)")

        if v2 then
            pushParagraph()
            n1 += 1
            table.insert(t1, p1:New("Frame")({
                Name = "Bullet",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = n1,
                Size = UDim2.new(1, 0, 0, 0),
                [Children] = {
                    p1:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Horizontal,
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    p1:New("TextLabel")({
                        Name = "Point",
                        BackgroundTransparency = 1,
                        LayoutOrder = 1,
                        Text = "•",
                        TextTransparency = 0.1,
                        AutomaticSize = Enum.AutomaticSize.Y,
                        FontFace = v1,
                        Size = UDim2.fromOffset(16, 0),
                        TextColor3 = Theme.Color.BaseContent,
                        TextSize = Theme.TextSize.Body,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Top
                    }),
                    p1:New("TextLabel")({
                        Name = "Text",
                        BackgroundTransparency = 1,
                        LayoutOrder = 2,
                        RichText = true,
                        TextTransparency = 0.1,
                        TextWrapped = true,
                        AutomaticSize = Enum.AutomaticSize.Y,
                        FontFace = v1,
                        Size = UDim2.new(1, -16, 0, 0),
                        Text = v2,
                        TextColor3 = Theme.Color.BaseContent,
                        TextSize = Theme.TextSize.Body,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Top
                    })
                }
            }))
        elseif match == "" then
            pushParagraph()
            n1 += 1
            table.insert(t1, p1:New("Frame")({
                Name = "Gap",
                BackgroundTransparency = 1,
                LayoutOrder = n1,
                Size = UDim2.new(1, 0, 0, 8)
            }))
        else
            table.insert(t2, match)
        end
    end

    pushParagraph()

    return t1
end

local function updateEntryChildren(p4, p5) -- line: 129
    -- upvalues: Theme (copy), Children (copy), updateBodyBlocks (copy)
    local t7 = {
        p4:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.None,
            VerticalFlex = Enum.UIFlexAlignment.None,
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
    }

    if p5.AuthorName and p5.AuthorUserId then
        table.insert(t7, p4:New("ImageLabel")({
            Name = "Avatar",
            BackgroundColor3 = Theme.Color.NeutralContent,
            Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(p5.AuthorUserId) .. "&w=48&h=48",
            LayoutOrder = 1,
            Size = UDim2.fromOffset(20, 20),
            [Children] = {
                p4:New("UICorner")({
                    CornerRadius = UDim.new(1, 0)
                })
            }
        }))
        table.insert(t7, p4:New("TextLabel")({
            Name = "Name",
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            AutomaticSize = Enum.AutomaticSize.XY,
            FontFace = p4:Computed(function(p6) -- line: 155
                -- upvalues: Theme (copy)
                return Font.new(p6(Theme.Font.Body), p6(Theme.FontWeight.Bold))
            end),
            Text = p5.AuthorName,
            TextColor3 = Theme.Color.BaseContent,
            TextSize = Theme.TextSize.Small
        }))
    end

    table.insert(t7, p4:New("TextLabel")({
        Name = "Date",
        BackgroundTransparency = 1,
        LayoutOrder = 3,
        AutomaticSize = Enum.AutomaticSize.XY,
        FontFace = p4:Computed(function(p7) -- line: 168
            -- upvalues: Theme (copy)
            return Font.new(p7(Theme.Font.Body), p7(Theme.FontWeight.Body))
        end),
        Text = p5.Date,
        TextColor3 = Theme.Color.NeutralContentDark,
        TextSize = Theme.TextSize.Small
    }))

    local t11 = {
        p4:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 12),
            SortOrder = Enum.SortOrder.LayoutOrder
        }),
        p4:New("Frame")({
            Name = "AuthorDate",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Size = UDim2.fromScale(1, 0),
            [Children] = t7
        })
    }

    if p5.Image then
        table.insert(t11, p4:New("ImageLabel")({
            Name = "Banner",
            BackgroundTransparency = 1,
            Image = p5.Image,
            LayoutOrder = 2,
            ScaleType = Enum.ScaleType.Crop,
            Size = UDim2.new(1, 0, 0, 110),
            [Children] = {
                p4:New("UICorner")({
                    CornerRadius = UDim.new(0, 9)
                })
            }
        }))
    end

    table.insert(t11, p4:New("Frame")({
        Name = "Body",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 4,
        Size = UDim2.new(1, 0, 0, 0),
        [Children] = updateBodyBlocks(p4, p5.Body)
    }))

    return t11
end

return function(p8, p9) -- line: 219
    -- upvalues: Fusion (copy), Theme (copy), Popup (copy), Pressable (copy), Icons (copy), UpdateLog (copy), Children (copy), updateEntryChildren (copy)
    local visible = p9.visible
    local v3 = p8:Value(1)

    p8:Observer(visible):onChange(function() -- line: 224
        -- upvalues: visible (copy), v3 (copy), Fusion (copy)
        if Fusion.peek(visible) then
            v3:set(1)
        end
    end)

    local function pageArrow(p10, p11) -- line: 231
        -- upvalues: p8 (copy), v3 (copy), Fusion (copy), Theme (copy), Pressable (copy), Icons (copy), UpdateLog (copy), Children (copy)
        local v4 = p8:Computed(function(p12) -- line: 232
            -- upvalues: p10 (copy), v3 (copy), UpdateLog (copy)
            local v5 = p12(v3) + p10

            if v5 >= 1 then
                return v5 <= #UpdateLog
            end

            return false
        end)

        return Pressable(p8, {
            name = p10 < 0 and "NewerButton" or "OlderButton",
            layoutOrder = p11,
            size = UDim2.fromOffset(20, 20),
            interactable = v4,
            onActivate = function() -- onActivate | line: 241
                -- upvalues: p10 (copy), v3 (copy), Fusion (copy), UpdateLog (copy)
                local v6 = Fusion.peek(v3) + p10

                if v6 >= 1 and v6 <= #UpdateLog then
                    v3:set(v6)
                end
            end,
            [Children] = {
                p8:New("ImageLabel")({
                    Name = "Icon",
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = Icons.ArrowLeft,
                    ImageColor3 = Theme.Color.BaseContent,
                    ImageTransparency = p8:Computed(function(p13) -- line: 254
                        -- upvalues: v4 (copy)
                        if p13(v4) then
                            return 0
                        end

                        return 0.7
                    end),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Rotation = p10 > 0 and 180 or 0,
                    Size = UDim2.fromOffset(13, 13)
                })
            }
        })
    end

    local v11 = p8:New("Frame")({
        Name = "UpdateLogTitle",
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,
        [Children] = {
            p8:New("UIPadding")({
                PaddingLeft = UDim.new(0, -6)
            }),
            p8:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.None,
                VerticalFlex = Enum.UIFlexAlignment.None,
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }),
            p8:New("Frame")({
                Name = "Arrows",
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                [Children] = {
                    p8:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalFlex = Enum.UIFlexAlignment.None,
                        VerticalFlex = Enum.UIFlexAlignment.None,
                        Padding = UDim.new(0, 2),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        VerticalAlignment = Enum.VerticalAlignment.Center
                    }),
                    pageArrow(-1, 1),
                    pageArrow(1, 2)
                }
            }),
            p8:New("TextLabel")({
                Name = "Title",
                BackgroundTransparency = 1,
                LayoutOrder = 3,
                AutomaticSize = Enum.AutomaticSize.XY,
                FontFace = p8:Computed(function(p14) -- line: 304
                    -- upvalues: Theme (copy)
                    return Font.new(p14(Theme.Font.Heading), p14(Theme.FontWeight.Heading))
                end),
                Text = p8:Computed(function(p15) -- line: 308
                    -- upvalues: v3 (copy), UpdateLog (copy)
                    local v10 = UpdateLog[p15(v3)]

                    if v10 then
                        return v10.Title
                    end

                    return ""
                end),
                TextColor3 = Theme.Color.BaseContent,
                TextSize = Theme.TextSize.Subtitle
            })
        }
    })
    local v13 = p8:New("ScrollingFrame")({
        Name = "UpdateLogScroller",
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        BottomImage = "rbxassetid://16547643439",
        CanvasSize = UDim2.new(),
        MidImage = "rbxassetid://16547330984",
        ScrollBarImageTransparency = 1,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Size = UDim2.fromScale(1, 1),
        TopImage = "rbxassetid://16547667444",
        [Children] = {
            p8:Computed(function(p16, p17) -- line: 332
                -- upvalues: v3 (copy), UpdateLog (copy), Children (copy), updateEntryChildren (copy)
                local v12 = UpdateLog[p16(v3)]

                if v12 then
                    return p17:New("Frame")({
                        Name = "Entry",
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        Size = UDim2.fromScale(1, 0),
                        [Children] = updateEntryChildren(p17, v12)
                    })
                end

                return nil
            end)
        }
    })

    return Popup(p8, {
        title = "Update Log",
        backdropTransparency = 1,
        visible = visible,
        titleContent = v11,
        cardSize = UDim2.fromScale(1, 1),
        content = { v13 }
    })
end
