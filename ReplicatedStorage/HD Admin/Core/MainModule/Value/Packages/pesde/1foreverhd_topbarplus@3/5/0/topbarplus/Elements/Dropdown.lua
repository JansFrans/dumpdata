-- https://lua.expert

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Themes = require(script.Parent.Parent.Features.Themes)
local Utility = require(script.Parent.Parent.Utility)

return function(p1) -- line: 6
    -- upvalues: TweenService (copy), RunService (copy), Themes (copy), Utility (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = "Dropdown"
    Frame.AutomaticSize = Enum.AutomaticSize.X
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.AnchorPoint = Vector2.new(0.5, 0)
    Frame.Position = UDim2.new(0.5, 0, 1, 10)
    Frame.ZIndex = -2
    Frame.ClipsDescendants = true
    Frame.Parent = p1.widget

    local GuiService = game:GetService("GuiService")

    p1:setBehaviour("Dropdown", "BackgroundTransparency", function(p2) -- line: 21
        -- upvalues: GuiService (copy)
        local v1 = p2 * GuiService.PreferredTransparency

        if p2 == 1 then
            return p2
        end

        return v1
    end)
    p1.janitor:add(GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() -- line: 29
        -- upvalues: p1 (copy), Frame (copy)
        p1:refreshAppearance(Frame, "BackgroundTransparency")
    end))

    local UICorner = Instance.new("UICorner")

    UICorner.Name = "DropdownCorner"
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Frame

    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = "DropdownScroller"
    ScrollingFrame.AutomaticSize = Enum.AutomaticSize.X
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.AnchorPoint = Vector2.new(0, 0)
    ScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.ZIndex = -1
    ScrollingFrame.ClipsDescendants = true
    ScrollingFrame.Visible = true
    ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.None
    ScrollingFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    ScrollingFrame.Active = false
    ScrollingFrame.ScrollingEnabled = true
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.ScrollBarThickness = 5
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    ScrollingFrame.ScrollBarImageTransparency = 0.8
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.Selectable = false
    ScrollingFrame.Active = true
    ScrollingFrame.Parent = Frame

    local NumberValue = Instance.new("NumberValue")

    NumberValue.Name = "DropdownSpeed"
    NumberValue.Value = 0.07
    NumberValue.Parent = Frame

    local UIPadding = Instance.new("UIPadding")

    UIPadding.Name = "DropdownPadding"
    UIPadding.PaddingTop = UDim.new(0, 0)
    UIPadding.PaddingBottom = UDim.new(0, 0)
    UIPadding.Parent = ScrollingFrame

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.Name = "DropdownList"
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.HorizontalFlex = Enum.UIFlexAlignment.SpaceEvenly
    UIListLayout.Parent = ScrollingFrame

    local dropdownJanitor = p1.dropdownJanitor
    local iconModule = require(p1.iconModule)

    p1.dropdownChildAdded:Connect(function(p3) -- line: 82
        -- upvalues: Themes (copy)
        local t1 = {
            { "Widget", "BorderSize", 0 },
            {
                "IconCorners",
                "CornerRadius",
                UDim.new(0, 8)
            },
            { "Widget", "MinimumWidth", 192 },
            { "Widget", "MinimumHeight", 56 },
            { "IconLabel", "TextSize", 20 },
            {
                "IconOverlay",
                "Size",
                UDim2.new(1, 0, 1, 0)
            },
            {
                "PaddingLeft",
                "Size",
                UDim2.fromOffset(15, 0)
            },
            {
                "PaddingCenter",
                "Size",
                UDim2.fromOffset(12, 0)
            },
            {
                "Notice",
                "Position",
                UDim2.new(1, -24, 0, 5)
            },
            {
                "ContentsList",
                "HorizontalAlignment",
                Enum.HorizontalAlignment.Left
            },
            {
                "Selection",
                "Size",
                UDim2.new(1, -0, 1, -0)
            },
            {
                "Selection",
                "Position",
                UDim2.new(0, 0, 0, 0)
            }
        }
        local Value = Themes.getThemeValue(p3:getStateGroup("Deselected"), "IconImageScale", "Value")

        if Value == nil or Value == 0.5 then
            table.insert(t1, {
                "IconImageScale",
                "Value",
                0.45
            })
        end

        local _, v2 = p3:modifyTheme(t1)

        task.defer(function() -- line: 104
            -- upvalues: p3 (copy), v2 (copy)
            p3.joinJanitor:add(function() -- line: 105
                -- upvalues: p3 (copy), v2 (copy)
                p3:removeModification(v2)
            end)
        end)
    end)
    p1.dropdownSet:Connect(function(p4) -- line: 110
        -- upvalues: p1 (copy), iconModule (copy)
        for _, v3 in pairs(p1.dropdownIcons) do
            iconModule.getIconByUID(v3):destroy()
        end

        if type(p4) == "table" then
            for _, v4 in pairs(p4) do
                v4:joinDropdown(p1)
            end
        end
    end)

    local function updateMaxIcons() -- line: 122
        -- upvalues: Frame (copy), ScrollingFrame (copy), UIPadding (copy), UIListLayout (copy)
        local MaxIcons = Frame:GetAttribute("MaxIcons")

        if not MaxIcons then
            return 0
        end

        local t3 = {}

        for _, child in pairs(ScrollingFrame:GetChildren()) do
            if child:IsA("GuiObject") and child.Visible then
                table.insert(t3, child)
            end
        end

        table.sort(t3, function(p5, p6) -- line: 133
            return p5.AbsolutePosition.Y < p6.AbsolutePosition.Y
        end)

        local v5 = math.ceil(MaxIcons)
        local n1 = 0
        local n2 = 0

        for i = 1, v5 do
            local v6 = t3[i]

            if not v6 then
                break
            end

            local Y = v6.AbsoluteSize.Y

            if i == v5 and v5 ~= MaxIcons then
                Y *= MaxIcons - v5 + 1
            end

            n1 += Y
            n2 += 1
        end

        return n1 + UIListLayout.Padding.Offset * math.max(n2 - 1, 0) + (UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset)
    end

    local v8, v9, v10, v11

    local function getTweenInfo() -- line: 158
        -- upvalues: Frame (copy), NumberValue (copy), v10 (ref), v11 (ref), Themes (copy)
        local v12 = Themes.getInstanceValue(Frame, "MaxIcons") or 1

        if v10 and v10 == v12 and v11 then
            return v11
        end

        local v13 = TweenInfo.new(NumberValue.Value * v12, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

        v11 = v13
        v10 = v12

        return v13
    end

    local function updateVisibility() -- line: 172
        -- upvalues: p1 (copy), Frame (copy), NumberValue (copy), updateMaxIcons (copy), v8 (ref), v9 (ref), v10 (ref), v11 (ref), TweenService (copy), Themes (copy), Utility (copy)
        local v14 = Themes.getInstanceValue(Frame, "MaxIcons") or 1
        local v15

        if v10 and v10 == v14 and v11 then
            v15 = v11
        else
            v15 = TweenInfo.new(NumberValue.Value * v14, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
            v11 = v15
            v10 = v14
        end

        if v8 then
            v8:Cancel()
            v8 = nil
        end

        if v9 then
            v9:Cancel()
            v9 = nil
        end

        if p1.isSelected then
            local v16 = updateMaxIcons()

            Frame.Visible = true
            Frame.BackgroundTransparency = 0
            Frame.Size = UDim2.new(0, Frame.Size.X.Offset, 0, 0)
            v8 = TweenService:Create(Frame, Utility.getTweenInfo(v15), {
                Size = UDim2.new(0, Frame.Size.X.Offset, 0, v16)
            })
            v8:Play()
            v8.Completed:Connect(function() -- line: 193
                -- upvalues: v8 (ref)
                v8 = nil
            end)
        else
            v9 = TweenService:Create(Frame, TweenInfo.new(0), {
                Size = UDim2.new(0, Frame.Size.X.Offset, 0, 0)
            })
            v9:Play()
            v9.Completed:Connect(function() -- line: 200
                -- upvalues: v9 (ref)
                v9 = nil
            end)
        end
    end

    dropdownJanitor:add(p1.toggled:Connect(updateVisibility))
    updateVisibility()

    local function updateChildSize() -- line: 210
        -- upvalues: p1 (copy), Frame (copy), NumberValue (copy), updateMaxIcons (copy), v8 (ref), v9 (ref), v10 (ref), v11 (ref), TweenService (copy), RunService (copy), Themes (copy), Utility (copy)
        local v18 = Themes.getInstanceValue(Frame, "MaxIcons") or 1
        local v19

        if v10 and v10 == v18 and v11 then
            v19 = v11
        else
            v19 = TweenInfo.new(NumberValue.Value * v18, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
            v11 = v19
            v10 = v18
        end

        if p1.isSelected then
            if v8 then
                v8:Cancel()
                v8 = nil
            end

            if v9 then
                v9:Cancel()
                v9 = nil
            end

            RunService.Heartbeat:Wait()

            local v20 = updateMaxIcons()

            v8 = TweenService:Create(Frame, Utility.getTweenInfo(v19), {
                Size = UDim2.new(0, Frame.Size.X.Offset, 0, v20)
            })
            v8:Play()
            v8.Completed:Connect(function() -- line: 228
                -- upvalues: v8 (ref)
                v8 = nil
            end)
        end
    end

    dropdownJanitor:add(p1.toggled:Connect(updateVisibility))

    local n3 = 0
    local v21 = false

    local function updateMaxIconsListener() -- line: 241
        -- upvalues: p1 (copy), Frame (copy), ScrollingFrame (copy), UIPadding (copy), UIListLayout (copy), iconModule (copy), n3 (ref), v21 (ref), updateMaxIconsListener (copy)
        n3 += 1

        if v21 then
            return
        end

        local v22 = n3

        v21 = true
        task.defer(function() -- line: 246
            -- upvalues: v22 (copy), n3 (ref), v21 (ref), updateMaxIconsListener (copy)
            v21 = false

            if n3 ~= v22 then
                updateMaxIconsListener()
            end
        end)

        local MaxIcons = Frame:GetAttribute("MaxIcons")

        if not MaxIcons then
            return
        end

        local t4 = {}

        for _, child in pairs(ScrollingFrame:GetChildren()) do
            if child:IsA("GuiObject") and child.Visible then
                table.insert(t4, {
                    child,
                    child.AbsolutePosition.Y
                })
            end
        end

        table.sort(t4, function(p7, p8) -- line: 261
            return p7[2] < p8[2]
        end)

        local v23 = math.ceil(MaxIcons)
        local n4 = 0
        local n5 = 0
        local v24 = false

        for i = 1, v23 do
            local v25 = t4[i]

            if not v25 then
                break
            end

            local v26 = v25[1]
            local Y = v26.AbsoluteSize.Y
            local v27 = i == v23 and v23 ~= MaxIcons

            if v27 then
                Y *= MaxIcons - v23 + 1
            end

            n4 += Y
            n5 += 1

            if not v27 then
                local WidgetUID = v26:GetAttribute("WidgetUID")
                local v28 = WidgetUID and iconModule.getIconByUID(WidgetUID)

                if v28 then
                    local v29, v30

                    if v24 then
                        v30 = v24
                    else
                        v30 = true
                        v29 = p1:getInstance("ClickRegion")
                    end

                    v24 = v30
                    v28:getInstance("ClickRegion").NextSelectionUp = v29
                end
            end
        end

        local v32 = n4 + UIListLayout.Padding.Offset * math.max(n5 - 1, 0) + (UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset)

        ScrollingFrame.Size = UDim2.fromOffset(0, v32)
    end

    dropdownJanitor:add(ScrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateMaxIconsListener))
    dropdownJanitor:add(ScrollingFrame.ChildAdded:Connect(updateMaxIconsListener))
    dropdownJanitor:add(ScrollingFrame.ChildRemoved:Connect(updateChildSize))
    dropdownJanitor:add(ScrollingFrame.ChildRemoved:Connect(updateMaxIconsListener))
    dropdownJanitor:add(Frame:GetAttributeChangedSignal("MaxIcons"):Connect(updateMaxIconsListener))
    dropdownJanitor:add(Frame:GetAttributeChangedSignal("MaxIcons"):Connect(updateChildSize))
    dropdownJanitor:add(p1.childThemeModified:Connect(updateMaxIconsListener))
    updateMaxIconsListener()

    local function connectVisibilityListeners(p9) -- line: 309
        -- upvalues: updateChildSize (copy)
        if not p9:IsA("GuiObject") then
            return
        end

        p9:GetPropertyChangedSignal("Visible"):Connect(updateChildSize)
        p9:GetPropertyChangedSignal("Size"):Connect(updateChildSize)
    end

    for _, child in pairs(ScrollingFrame:GetChildren()) do
        if child:IsA("GuiObject") then
            child:GetPropertyChangedSignal("Visible"):Connect(updateChildSize)
            child:GetPropertyChangedSignal("Size"):Connect(updateChildSize)
        end
    end

    ScrollingFrame.ChildAdded:Connect(function(p10) -- line: 321
        -- upvalues: updateChildSize (copy), RunService (copy)
        RunService.Heartbeat:Wait()

        if p10:IsA("GuiObject") then
            p10:GetPropertyChangedSignal("Visible"):Connect(updateChildSize)
            p10:GetPropertyChangedSignal("Size"):Connect(updateChildSize)
        end

        updateChildSize()
    end)
    Frame.Visible = false

    return Frame
end
