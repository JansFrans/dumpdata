-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local Pressable = require(UI.Components.Pressable)
local Popup = require(UI.Components.Popup)

return function(p1, p2) -- line: 27
    -- upvalues: Fusion (copy), Theme (copy), Children (copy), Pressable (copy), Popup (copy)
    local Copy = p1:Value("Copy")
    local v1 = p1:Value("")
    local v2 = p1:Value("")
    local v3 = p1:Value(false)
    local n1 = 0

    p1:Observer(v2):onChange(function() -- line: 34
        -- upvalues: v2 (copy), n1 (ref), Fusion (copy)
        local v4 = Fusion.peek(v2)

        if typeof(v4) ~= "string" or v4 == "" then
            return
        end

        n1 += 1

        local v5 = n1

        task.delay(4, function() -- line: 39
            -- upvalues: v5 (copy), v2 (copy), n1 (ref)
            if n1 == v5 then
                v2:set("")
            end
        end)
    end)
    p1:Observer(p2.visible):onChange(function() -- line: 46
        -- upvalues: p2 (copy), Copy (copy), v1 (copy), v2 (copy), v3 (copy), Fusion (copy)
        if not Fusion.peek(p2.visible) then
            return
        end

        Copy:set("Copy")
        v1:set("")
        v2:set("")
        v3:set(false)
    end)

    if p2.hideLoad ~= nil then
        p1:Observer(p2.hideLoad):onChange(function() -- line: 56
            -- upvalues: p2 (copy), Copy (copy), Fusion (copy)
            if Fusion.peek(p2.hideLoad) == true and Fusion.peek(Copy) == "Load" then
                Copy:set("Copy")
            end
        end)
    end

    local v6 = p1:New("TextBox")({
        Name = "CopyBox",
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,
        ClearTextOnFocus = false,
        FontFace = p1:Computed(function(p3) -- line: 68
            -- upvalues: Theme (copy)
            return Font.new(p3(Theme.Font.Body), p3(Theme.FontWeight.Body))
        end),
        MultiLine = true,
        Size = UDim2.fromScale(1, 0),
        Text = p2.copyText,
        TextColor3 = Theme.Color.BaseContent,
        TextEditable = false,
        TextSize = Theme.TextSize.Body,
        TextWrapped = false,
        TextXAlignment = Enum.TextXAlignment.Left,
        [Children] = {
            p1:New("UIPadding")({
                PaddingTop = UDim.new(0, 8),
                PaddingBottom = UDim.new(0, 8),
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10)
            })
        }
    })
    local v7 = p1:New("ScrollingFrame")({
        Name = "CopyScroller",
        LayoutOrder = 2,
        AutomaticCanvasSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = Theme.Color.Base,
        CanvasSize = UDim2.new(),
        ClipsDescendants = true,
        ScrollBarImageColor3 = Theme.Color.NeutralContentDark,
        ScrollBarThickness = 6,
        ScrollingDirection = Enum.ScrollingDirection.XY,
        Selectable = false,
        Size = UDim2.fromScale(1, 1),
        Visible = p1:Computed(function(p4) -- line: 101
            -- upvalues: Copy (copy)
            return p4(Copy) == "Copy"
        end),
        [Children] = {
            p1:New("UICorner")({
                CornerRadius = p1:Computed(function(p5) -- line: 104
                    -- upvalues: Theme (copy)
                    return UDim.new(0, (p5(Theme.Layout.CornerRadius)))
                end)
            }),
            p1:New("UIStroke")({
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.NeutralStroke
            }),
            p1:New("UIFlexItem")({
                FlexMode = Enum.UIFlexMode.Fill
            }),
            v6
        }
    })

    p1:Observer(Copy):onChange(function() -- line: 117
        -- upvalues: p2 (copy), Copy (copy), v6 (copy), Fusion (copy)
        if Fusion.peek(Copy) == "Copy" and Fusion.peek(p2.visible) then
            task.defer(function() -- line: 119
                -- upvalues: p2 (copy), Copy (copy), v6 (copy), Fusion (copy)
                if Fusion.peek(p2.visible) and Fusion.peek(Copy) == "Copy" then
                    v6:CaptureFocus()
                end
            end)
        end
    end)
    p1:Observer(p2.visible):onChange(function() -- line: 126
        -- upvalues: p2 (copy), Copy (copy), v6 (copy), Fusion (copy)
        if Fusion.peek(p2.visible) and Fusion.peek(Copy) == "Copy" then
            task.defer(function() -- line: 128
                -- upvalues: p2 (copy), Copy (copy), v6 (copy), Fusion (copy)
                if Fusion.peek(p2.visible) and Fusion.peek(Copy) == "Copy" then
                    v6:CaptureFocus()
                end
            end)
        end
    end)

    local v8 = p1:New("TextBox")({
        Name = "LoadBox",
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,
        ClearTextOnFocus = false,
        FontFace = p1:Computed(function(p6) -- line: 141
            -- upvalues: Theme (copy)
            return Font.new(p6(Theme.Font.Body), p6(Theme.FontWeight.Body))
        end),
        MultiLine = true,
        PlaceholderText = "Paste role data here...",
        PlaceholderColor3 = Theme.Color.NeutralContentDark,
        Size = UDim2.new(1, 0, 1, -50),
        Text = "",
        TextColor3 = Theme.Color.BaseContent,
        TextSize = Theme.TextSize.Body,
        TextWrapped = false,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        [Children] = {
            p1:New("UIPadding")({
                PaddingTop = UDim.new(0, 8),
                PaddingBottom = UDim.new(0, 8),
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10)
            })
        },
        [Fusion.Out("Text")] = v1
    })
    local v9 = p1:New("ScrollingFrame")({
        Name = "LoadScroller",
        LayoutOrder = 2,
        AutomaticCanvasSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = Theme.Color.Base,
        CanvasSize = UDim2.new(),
        ClipsDescendants = true,
        ScrollBarImageColor3 = Theme.Color.NeutralContentDark,
        ScrollBarThickness = 6,
        ScrollingDirection = Enum.ScrollingDirection.XY,
        Selectable = false,
        Size = UDim2.fromScale(1, 1),
        Visible = p1:Computed(function(p7) -- line: 177
            -- upvalues: Copy (copy)
            return p7(Copy) == "Load"
        end),
        [Children] = {
            p1:New("UICorner")({
                CornerRadius = p1:Computed(function(p8) -- line: 180
                    -- upvalues: Theme (copy)
                    return UDim.new(0, (p8(Theme.Layout.CornerRadius)))
                end)
            }),
            p1:New("UIStroke")({
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.NeutralStroke
            }),
            p1:New("UIFlexItem")({
                FlexMode = Enum.UIFlexMode.Fill
            }),
            v8
        }
    })

    local function makeTabButton(p9, p10) -- line: 193
        -- upvalues: p1 (copy), Copy (copy), Theme (copy), Children (copy), Pressable (copy)
        local v10 = p1:Computed(function(p11) -- line: 194
            -- upvalues: p9 (copy), Copy (copy)
            return p11(Copy) == p9
        end)

        return Pressable(p1, {
            name = p9 .. "Tab",
            size = UDim2.fromOffset(96, 28),
            visible = p10,
            backgroundColor = p1:Computed(function(p12) -- line: 199
                -- upvalues: v10 (copy), Theme (copy)
                if p12(v10) then
                    return (p12(Theme.Color.Primary))
                end

                return (p12(Theme.Color.Neutral))
            end),
            onActivate = function() -- onActivate | line: 202
                -- upvalues: p9 (copy), Copy (copy)
                Copy:set(p9)
            end,
            [Children] = {
                p1:New("UICorner")({
                    CornerRadius = p1:Computed(function(p13) -- line: 207
                        -- upvalues: Theme (copy)
                        return UDim.new(0, (p13(Theme.Layout.CornerRadius)))
                    end)
                }),
                p1:New("UIStroke")({
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Theme.Color.NeutralContent
                }),
                p1:New("TextLabel")({
                    Name = "Label",
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    FontFace = p1:Computed(function(p14) -- line: 219
                        -- upvalues: Theme (copy)
                        return Font.new(p14(Theme.Font.Body), p14(Theme.FontWeight.Body))
                    end),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(1, 1),
                    Text = p9,
                    TextColor3 = p1:Computed(function(p15) -- line: 225
                        -- upvalues: v10 (copy), Theme (copy)
                        if p15(v10) then
                            return (p15(Theme.Color.PrimaryContent))
                        end

                        return (p15(Theme.Color.BaseContent))
                    end),
                    TextSize = Theme.TextSize.Body,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextYAlignment = Enum.TextYAlignment.Center
                })
            }
        })
    end

    local v15 = p1:New("Frame")({
        Name = "Tabs",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Size = UDim2.fromScale(1, 0),
        [Children] = {
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            makeTabButton("Copy"),
            makeTabButton("Load", if p2.hideLoad == nil then nil else p1:Computed(function(p16) -- line: 252
                -- upvalues: p2 (copy)
                return p16(p2.hideLoad) ~= true
            end))
        }
    })
    local v19 = Pressable(p1, {
        name = "LoadButton",
        size = UDim2.new(1, 0, 0, 32),
        backgroundColor = Theme.Color.Primary,
        onActivate = function() -- onActivate | line: 264
            -- upvalues: p2 (copy), v1 (copy), v2 (copy), v3 (copy), Fusion (copy)
            local v16 = Fusion.peek(v1)
            local v17, v18 = p2.onLoad(v16)

            v2:set(v18)
            v3:set(not v17)

            if v17 then
                if p2.onClose then
                    p2.onClose()
                else
                    p2.visible:set(false)
                end
            end
        end,
        [Children] = {
            p1:New("UICorner")({
                CornerRadius = p1:Computed(function(p17) -- line: 279
                    -- upvalues: Theme (copy)
                    return UDim.new(0, (p17(Theme.Layout.CornerRadius)))
                end)
            }),
            p1:New("UIStroke")({
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.NeutralStroke
            }),
            p1:New("TextLabel")({
                Name = "Label",
                BackgroundTransparency = 1,
                Text = "Load Data",
                AnchorPoint = Vector2.new(0.5, 0.5),
                FontFace = p1:Computed(function(p18) -- line: 291
                    -- upvalues: Theme (copy)
                    return Font.new(p18(Theme.Font.Body), p18(Theme.FontWeight.Body))
                end),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
                TextColor3 = Theme.Color.PrimaryContent,
                TextSize = Theme.TextSize.Body,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center
            })
        }
    })
    local v22 = p1:New("Frame")({
        Name = "LoadControls",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 3,
        Size = UDim2.fromScale(1, 0),
        Visible = p1:Computed(function(p19) -- line: 311
            -- upvalues: Copy (copy)
            return p19(Copy) == "Load"
        end),
        [Children] = {
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Vertical,
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            v19,
            p1:New("TextLabel")({
                Name = "Status",
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                TextWrapped = true,
                AutomaticSize = Enum.AutomaticSize.Y,
                FontFace = p1:Computed(function(p20) -- line: 323
                    -- upvalues: Theme (copy)
                    return Font.new(p20(Theme.Font.Body), p20(Theme.FontWeight.Regular))
                end),
                Size = UDim2.fromScale(1, 0),
                Text = v2,
                TextColor3 = p1:Computed(function(p21) -- line: 329
                    -- upvalues: v3 (copy), Theme (copy)
                    if p21(v3) then
                        return (p21(Theme.Color.Error))
                    end

                    return (p21(Theme.Color.NeutralContentDark))
                end),
                TextSize = Theme.TextSize.Body,
                TextXAlignment = Enum.TextXAlignment.Left,
                Visible = p1:Computed(function(p22) -- line: 335
                    -- upvalues: v2 (copy)
                    local v21 = p22(v2)

                    if typeof(v21) == "string" then
                        return v21 ~= ""
                    end

                    return false
                end)
            })
        }
    })

    return Popup(p1, {
        title = "Role Data",
        dismissible = true,
        backdropDismiss = true,
        visible = p2.visible,
        onClose = p2.onClose,
        cardSize = p1:Computed(function(p23) -- line: 349
            -- upvalues: Theme (copy)
            local v23 = p23(Theme.Layout.Padding)

            return UDim2.new(1, -v23 * 2, 1, -32)
        end),
        content = { v15, v7, v9 },
        actions = { v22 }
    })
end
