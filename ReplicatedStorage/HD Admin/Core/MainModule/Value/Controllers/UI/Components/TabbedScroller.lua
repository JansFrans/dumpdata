-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local TabBar = require(UI.Components.TabBar)
local Children = Fusion.Children
local UserInputService = game:GetService("UserInputService")
local v1 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

return function(p1, p2) -- line: 31
    -- upvalues: Theme (copy), TabBar (copy), Children (copy), v1 (copy)
    local v2 = p2.activeTabRef or p1:Value(1)
    local v3 = p1:Value(nil)
    local v4 = p1:Value(1)
    local onTabChanged = p2.onTabChanged
    local v5 = false

    table.insert(p1, function() -- line: 38
        -- upvalues: v5 (ref)
        v5 = true
    end)

    local t1 = {}
    local t2 = {}

    for i = 1, #p2.tabs do
        t1[i] = p1:Value(Vector2.zero)
        t2[i] = i
    end

    local v7 = p1:Value(Vector2.zero)
    local v8 = p1:Value(Vector2.zero)
    local v9 = p2.headerPadding or UDim.new(0, 14)
    local _ = p2.contentPadding

    local function onTabChange(p3, p4) -- line: 55
        -- upvalues: v3 (copy), v4 (copy), onTabChanged (copy), v5 (ref)
        if p4 ~= nil then
            v4:set(p4 < p3 and 1 or -1)
            v3:set(p4)
            task.delay(0.6, function() -- line: 63
                -- upvalues: v3 (copy), v5 (ref)
                if not v5 then
                    v3:set(nil)
                end
            end)

            if onTabChanged then
                onTabChanged(p3, p4)
            end
        else
            v3:set(nil)

            if onTabChanged then
                onTabChanged(p3, nil)
            end
        end
    end

    local v10 = p1:Computed(function(p5) -- line: 71
        -- upvalues: t1 (copy), v7 (copy), v8 (copy), v9 (copy), v2 (copy)
        local v12 = t1[p5(v2)]
        local v13 = 0

        if v12 then
            local v14 = p5(v12)

            v13 = if typeof(v14) == "Vector2" then v14.Y else 0
        end

        local v15 = p5(v7)
        local v16 = if typeof(v15) == "Vector2" then v15.Y else 0
        local v17 = p5(v8)

        return (math.max(v13, (math.max(0, v16 - (if typeof(v17) == "Vector2" then v17.Y else 0) - v9.Offset - 10))))
    end)
    local v20 = TabBar(p1, {
        tabs = p2.tabs,
        activeTab = v2,
        onTabChange = onTabChange
    })

    local function getCumulativeUIScale(p6) -- line: 98
        local n1 = 1
        local v21 = p6

        while v21 do
            local UIScale = v21:FindFirstChildOfClass("UIScale")

            if UIScale then
                n1 *= UIScale.Scale
            end

            v21 = v21.Parent
        end

        return n1
    end

    local function trackUnscaledSize(p7, p8, p9) -- line: 109
        local function write() -- line: 110
            -- upvalues: p8 (copy), p9 (copy)
            if p8.Parent then
                local n2 = 1
                local v22 = p8

                while v22 do
                    local UIScale = v22:FindFirstChildOfClass("UIScale")

                    if UIScale then
                        n2 *= UIScale.Scale
                    end

                    v22 = v22.Parent
                end

                local v23 = math.max(n2, 1E-04)
                local AbsoluteSize = p8.AbsoluteSize

                p9:set(Vector2.new(AbsoluteSize.X / v23, AbsoluteSize.Y / v23))
            end
        end

        local connection = p8:GetPropertyChangedSignal("AbsoluteSize"):Connect(write)

        table.insert(p7, function() -- line: 117
            -- upvalues: connection (copy)
            connection:Disconnect()
        end)
        task.defer(write)
    end

    local function buildMeasuredTab(p10, p11) -- line: 121
        -- upvalues: p2 (copy), t1 (copy), trackUnscaledSize (copy), Children (copy)
        local v25 = p2.buildTabContent(p10, p11)
        local v26 = p10:New("Frame")({
            Name = "TabContent_" .. p11,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            [Children] = { v25 }
        })

        trackUnscaledSize(p10, v26, t1[p11])

        return v26
    end

    local v27 = p1:New("Frame")({
        Name = "TabBarSlot",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Size = UDim2.fromScale(1, 0),
        [Children] = {
            p1:New("UIPadding")({
                PaddingRight = UDim.new(0, 5)
            }),
            v20
        }
    })

    trackUnscaledSize(p1, v27, v8)

    local t4 = {
        p1:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = v9,
            SortOrder = Enum.SortOrder.LayoutOrder
        }),
        v27,
        p1:New("Frame")({
            Name = "TabContentArea",
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            LayoutOrder = 1,
            Size = p1:Computed(function(p12) -- line: 165
                -- upvalues: v10 (copy)
                return UDim2.new(1, 0, 0, math.round((p12(v10))) + 2)
            end),
            [Children] = {
                p1:ForValues(t2, function(_, p14, p15) -- line: 170
                    -- upvalues: v3 (copy), v4 (copy), buildMeasuredTab (copy), v2 (copy), Children (copy)
                    local v30 = p14:Spring(p14:Computed(function(p16) -- line: 171
                        -- upvalues: p15 (copy), v3 (copy), v4 (copy), v2 (copy)
                        local v31 = p16(v2)
                        local v32 = p16(v3)
                        local v33 = p16(v4)

                        if v31 ~= nil then
                            if v31 == p15 then
                                return UDim2.fromScale(0, 0)
                            end

                            if v32 == p15 then
                                return UDim2.fromScale(-v33, 0)
                            end

                            if p15 < v31 then
                                return (UDim2.fromScale(-1, 0))
                            end
                        elseif p15 == 1 then
                            return (UDim2.fromScale(0, 0))
                        end

                        return (UDim2.fromScale(1, 0))
                    end), p14:Computed(function(p17) -- line: 186
                        -- upvalues: p15 (copy), v3 (copy), v2 (copy)
                        if p17(v2) == p15 or p17(v3) == p15 then
                            return 120
                        end

                        return 9999
                    end), 2.25)

                    return p14:New("Frame")({
                        Name = "TabSlide_" .. p15,
                        BackgroundTransparency = 1,
                        ClipsDescendants = true,
                        Position = v30,
                        Size = UDim2.fromScale(1, 1),
                        [Children] = {
                            p14:New("UIPadding")({
                                Name = "UIPadding",
                                PaddingBottom = UDim.new(0, 1),
                                PaddingLeft = UDim.new(0, 1),
                                PaddingRight = UDim.new(0, 5),
                                PaddingTop = UDim.new(0, 1)
                            }),
                            (buildMeasuredTab(p14, p15))
                        }
                    })
                end)
            }
        })
    }
    local v34 = if v1 then Enum.ScrollBarInset.None else Enum.ScrollBarInset.Always
    local v35 = p1:New("ScrollingFrame")({
        Name = "Scroll",
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        BottomImage = "rbxassetid://16547643439",
        CanvasSize = UDim2.new(),
        ClipsDescendants = true,
        MidImage = "rbxassetid://16547330984",
        ScrollBarImageColor3 = Theme.Color.NeutralContentDark,
        ScrollBarImageTransparency = v1 and 1 or 0,
        ScrollBarThickness = v1 and 0 or 8,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Selectable = false,
        Size = UDim2.fromScale(1, 1),
        TopImage = "rbxassetid://16547667444",
        VerticalScrollBarInset = v34,
        [Children] = {
            p1:New("UIPadding")({
                Name = "UIPadding",
                PaddingBottom = UDim.new(0, 1),
                PaddingLeft = UDim.new(0, 1),
                PaddingRight = UDim.new(0, 1),
                PaddingTop = UDim.new(0, 1)
            }),
            t4
        }
    })

    trackUnscaledSize(p1, v35, v7)

    if not p2.footerSlot then
        return v35
    end

    local v36 = p2.footerHeight or 0

    return p1:New("Frame")({
        Name = "TabbedScroller",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        [Children] = {
            p1:New("Frame")({
                Name = "ScrollArea",
                BackgroundTransparency = 1,
                Size = p1:Computed(function(p18) -- line: 263
                    -- upvalues: v36 (copy)
                    local v37 = if typeof(v36) == "table" then p18(v36) or 0 else v36

                    return UDim2.new(1, 0, 1, -v37)
                end),
                [Children] = { v35 }
            }),
            p1:New("Frame")({
                Name = "FooterHost",
                AnchorPoint = Vector2.new(0, 1),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0, 1),
                Size = p1:Computed(function(p19) -- line: 277
                    -- upvalues: v36 (copy)
                    local v39 = if typeof(v36) == "table" then p19(v36) or 0 else v36

                    return UDim2.new(1, 0, 0, v39)
                end),
                [Children] = { p2.footerSlot }
            })
        }
    })
end
