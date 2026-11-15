-- https://lua.expert

return function(p1, p2) -- line: 6
    local Utility = require(script.Parent.Parent.Utility)
    local v1 = false
    local Frame = Instance.new("Frame")

    Frame:SetAttribute("WidgetUID", p1.UID)
    Frame.Name = "Widget"
    Frame.BackgroundTransparency = 1
    Frame.Visible = true
    Frame.ZIndex = 20
    Frame.Active = false
    Frame.ClipsDescendants = true

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "IconButton"
    Frame2.Visible = true
    Frame2.ZIndex = 2
    Frame2.BorderSizePixel = 0
    Frame2.Parent = Frame
    Frame2.ClipsDescendants = true
    Frame2.Active = false
    p1.deselected:Connect(function() -- line: 28
        -- upvalues: p1 (copy), Frame2 (copy)
        Frame2.ClipsDescendants = true
        task.delay(0.2, function() -- line: 30
            -- upvalues: p1 (copy), Frame2 (copy)
            if p1.isSelected then
                Frame2.ClipsDescendants = false
            end
        end)
    end)

    local GuiService = game:GetService("GuiService")

    p1:setBehaviour("IconButton", "BackgroundTransparency", function(p3) -- line: 39
        -- upvalues: GuiService (copy)
        local v2 = p3 * GuiService.PreferredTransparency

        if p3 == 1 then
            return p3
        end

        return v2
    end)
    p1.janitor:add(GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() -- line: 47
        -- upvalues: p1 (copy), Frame2 (copy)
        p1:refreshAppearance(Frame2, "BackgroundTransparency")
    end))

    local UICorner = Instance.new("UICorner")

    UICorner:SetAttribute("Collective", "IconCorners")
    UICorner.Name = "UICorner"
    UICorner.Parent = Frame2

    local v3 = require(script.Parent.Menu)(p1)
    local MenuUIListLayout, MenuGap = v3.MenuUIListLayout, v3.MenuGap

    v3.Parent = Frame2

    local Frame3 = Instance.new("Frame")

    Frame3.Name = "IconSpot"
    Frame3.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
    Frame3.BackgroundTransparency = 0.9
    Frame3.Visible = true
    Frame3.AnchorPoint = Vector2.new(0, 0.5)
    Frame3.ZIndex = 5
    Frame3.Parent = v3
    UICorner:Clone().Parent = Frame3

    local clone = Frame3:Clone()

    clone.UICorner.Name = "OverlayUICorner"
    clone.Name = "IconOverlay"
    clone.BackgroundColor3 = Color3.fromRGB(208, 217, 251)
    clone.ZIndex = Frame3.ZIndex + 1
    clone.Size = UDim2.new(1, 0, 1, 0)
    clone.Position = UDim2.new(0, 0, 0, 0)
    clone.AnchorPoint = Vector2.new(0, 0)
    clone.Visible = false
    clone.Parent = Frame3

    local TextButton = Instance.new("TextButton")

    TextButton:SetAttribute("CorrespondingIconUID", p1.UID)
    TextButton.Name = "ClickRegion"
    TextButton.BackgroundTransparency = 1
    TextButton.Visible = true
    TextButton.Text = ""
    TextButton.ZIndex = 20
    TextButton.Selectable = true
    TextButton.SelectionGroup = true
    TextButton.Parent = Frame3
    require(script.Parent.Parent.Features.Gamepad).registerButton(TextButton)
    UICorner:Clone().Parent = TextButton

    local Frame4 = Instance.new("Frame")

    Frame4.Name = "Contents"
    Frame4.BackgroundTransparency = 1
    Frame4.Size = UDim2.fromScale(1, 1)
    Frame4.Parent = Frame3

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.Name = "ContentsList"
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.VerticalFlex = Enum.UIFlexAlignment.SpaceEvenly
    UIListLayout.Padding = UDim.new(0, 3)
    UIListLayout.Parent = Frame4

    local Frame5 = Instance.new("Frame")

    Frame5.Name = "PaddingLeft"
    Frame5.LayoutOrder = 0
    Frame5.ZIndex = 5
    Frame5.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame5.BackgroundTransparency = 1
    Frame5.BorderSizePixel = 0
    Frame5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame5.Parent = Frame4

    local Frame6 = Instance.new("Frame")

    Frame6.Name = "PaddingCenter"
    Frame6.LayoutOrder = 3
    Frame6.ZIndex = 5
    Frame6.Size = UDim2.new(0, 0, 1, 0)
    Frame6.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame6.BackgroundTransparency = 1
    Frame6.BorderSizePixel = 0
    Frame6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame6.Parent = Frame4

    local Frame7 = Instance.new("Frame")

    Frame7.Name = "PaddingRight"
    Frame7.LayoutOrder = 7
    Frame7.ZIndex = 5
    Frame7.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame7.BackgroundTransparency = 1
    Frame7.BorderSizePixel = 0
    Frame7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame7.Parent = Frame4

    local Frame8 = Instance.new("Frame")

    Frame8.Name = "IconLabelContainer"
    Frame8.LayoutOrder = 4
    Frame8.ZIndex = 3
    Frame8.AnchorPoint = Vector2.new(0, 0.5)
    Frame8.Size = UDim2.new(0, 0, 0.5, 0)
    Frame8.BackgroundTransparency = 1
    Frame8.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame8.Parent = Frame4

    local TextLabel = Instance.new("TextLabel")
    local v4 = workspace.CurrentCamera.ViewportSize.X + 200

    TextLabel.Name = "IconLabel"
    TextLabel.LayoutOrder = 4
    TextLabel.ZIndex = 15
    TextLabel.AnchorPoint = Vector2.new(0, 0)
    TextLabel.Size = UDim2.new(0, v4, 1, 0)
    TextLabel.ClipsDescendants = false
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.fromScale(0, 0)
    TextLabel.RichText = true
    TextLabel.TextColor3 = Color3.fromRGB(247, 247, 248)
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Text = ""
    TextLabel.TextWrapped = true
    TextLabel.TextScaled = false
    TextLabel.Active = false
    TextLabel.AutoLocalize = true
    TextLabel.Parent = Frame8

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "IconImage"
    ImageLabel.LayoutOrder = 2
    ImageLabel.ZIndex = 15
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
    ImageLabel.Size = UDim2.new(0, 0, 0.5, 0)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Position = UDim2.new(0, 11, 0.5, 0)
    ImageLabel.ScaleType = Enum.ScaleType.Stretch
    ImageLabel.Active = false
    ImageLabel.Parent = Frame4

    local clone2 = UICorner:Clone()

    clone2:SetAttribute("Collective", nil)
    clone2.CornerRadius = UDim.new(0, 0)
    clone2.Name = "IconImageCorner"
    clone2.Parent = ImageLabel

    local TweenService = game:GetService("TweenService")
    local n1 = 0

    local function handleLabelAndImageChangesUnstaggered(_) -- line: 197
        -- upvalues: p1 (copy), p2 (copy), Utility (copy), v1 (ref), Frame (copy), Frame2 (copy), v3 (copy), MenuUIListLayout (copy), MenuGap (copy), Frame3 (copy), TextButton (copy), Frame4 (copy), UIListLayout (copy), Frame5 (copy), Frame6 (copy), Frame7 (copy), Frame8 (copy), TextLabel (copy), v4 (copy), ImageLabel (copy), TweenService (copy), n1 (ref)
        task.defer(function() -- line: 204
            -- upvalues: p1 (copy), p2 (copy), Utility (copy), v1 (ref), Frame (copy), Frame2 (copy), v3 (copy), MenuUIListLayout (copy), MenuGap (copy), Frame3 (copy), TextButton (copy), Frame4 (copy), UIListLayout (copy), Frame5 (copy), Frame6 (copy), Frame7 (copy), Frame8 (copy), TextLabel (copy), v4 (copy), ImageLabel (copy), TweenService (copy), n1 (ref)
            local indicator = p1.indicator
            local v5 = indicator and indicator.Visible
            local v6 = v5 or TextLabel.Text ~= ""
            local v7 = ImageLabel.Image ~= "" or ImageLabel.ImageContent.SourceType ~= Enum.ContentSourceType.None
            local _ = Enum.HorizontalAlignment.Center
            local v8 = UDim2.fromScale(1, 1)

            if not v7 or v6 then
                if v7 or not v6 then
                    if v7 and v6 then
                        Frame8.Visible = true
                        ImageLabel.Visible = true
                        Frame5.Visible = true
                        Frame6.Visible = not v5
                        Frame7.Visible = not v5

                        local _ = Enum.HorizontalAlignment.Left
                    end
                else
                    Frame8.Visible = true
                    ImageLabel.Visible = false
                    Frame5.Visible = true
                    Frame6.Visible = false
                    Frame7.Visible = true
                end
            else
                Frame8.Visible = false
                ImageLabel.Visible = true
                Frame5.Visible = false
                Frame6.Visible = false
                Frame7.Visible = false
            end

            Frame2.Size = v8

            local function getItemWidth(p5) -- line: 234
                local TargetWidth = p5:GetAttribute("TargetWidth")

                if TargetWidth then
                    return TargetWidth
                end

                local AutomaticSize = p5.AutomaticSize
                local v9 = AutomaticSize == Enum.AutomaticSize.X or AutomaticSize == Enum.AutomaticSize.XY

                if p5.Size.X.Scale ~= 0 or v9 then
                    return p5.AbsoluteSize.X
                end

                return p5.Size.X.Offset
            end

            local Offset = UIListLayout.Padding.Offset
            local X = TextLabel.TextBounds.X

            Frame8.Size = UDim2.new(0, X, TextLabel.Size.Y.Scale, 0)

            local v10 = Offset

            for _, child in pairs(Frame4:GetChildren()) do
                if child:IsA("GuiObject") and child.Visible == true then
                    v10 += getItemWidth(child) + Offset
                end
            end

            local MinimumWidth = Frame:GetAttribute("MinimumWidth")
            local MinimumHeight = Frame:GetAttribute("MinimumHeight")
            local BorderSize = Frame:GetAttribute("BorderSize")
            local v12 = math.clamp(v10, MinimumWidth, (math.max(v4, MinimumWidth)))
            local v13 = #p1.menuIcons > 0 and p1.isSelected
            local v14

            if v13 then
                local n2 = 0

                for _, child in pairs(v3:GetChildren()) do
                    if child ~= Frame3 and child:IsA("GuiObject") and child.Visible then
                        n2 += getItemWidth(child) + MenuUIListLayout.Padding.Offset
                    end
                end

                if not Frame3.Visible then
                    v12 -= getItemWidth(Frame3) + MenuUIListLayout.Padding.Offset * 2 + BorderSize
                end

                v14 = n2 - BorderSize * 0.5
                v12 += v14 - BorderSize * 0.75
            else
                v14 = 0
            end

            MenuGap.Visible = v13 and Frame3.Visible

            local DesiredWidth = Frame:GetAttribute("DesiredWidth")

            if not (DesiredWidth and v12 < DesiredWidth) then
                DesiredWidth = v12
            end

            p1.updateMenu:Fire()

            local v16 = math.max(DesiredWidth - v14, MinimumWidth) - BorderSize * 2
            local MenuWidth = v3:GetAttribute("MenuWidth")
            local v17 = MenuWidth and MenuWidth + v16 + MenuUIListLayout.Padding.Offset + 10
            local v18 = DesiredWidth

            if v17 then
                local MaxWidth = v3:GetAttribute("MaxWidth")
                local v19 = if MaxWidth then math.max(MaxWidth, MinimumWidth) else v17

                v3:SetAttribute("MenuCanvasWidth", DesiredWidth)

                if v19 < DesiredWidth then
                    v18 = v19
                end
            end

            local Quint = Enum.EasingStyle.Quint
            local Out = Enum.EasingDirection.Out
            local v21 = math.max(v16, getItemWidth(Frame3), Frame3.AbsoluteSize.X)
            local v23 = math.max(v18, getItemWidth(Frame), Frame.AbsoluteSize.X)
            local v24, v25

            if not v1 and Frame4.AbsoluteSize.Y > 0 then
                v1 = true
                v24 = TweenInfo.new(0)
                v25 = TweenInfo.new(0)
            else
                v24 = Utility.getTweenInfo(TweenInfo.new(v21 / 750, Quint, Out))
                v25 = Utility.getTweenInfo(TweenInfo.new(v23 / 750, Quint, Out))
            end

            TweenService:Create(Frame3, v24, {
                Position = UDim2.new(0, BorderSize, 0.5, 0),
                Size = UDim2.new(0, v16, 1, -BorderSize * 2)
            }):Play()
            TweenService:Create(TextButton, v24, {
                Size = UDim2.new(0, v16, 1, 0)
            }):Play()

            local v26 = UDim2.fromOffset(v18, MinimumHeight)

            if Frame.Size.Y.Offset ~= MinimumHeight then
                Frame.Size = v26
            end

            Frame:SetAttribute("TargetWidth", v26.X.Offset)
            TweenService:Create(Frame, v25, {
                Size = v26
            }):Play()
            n1 += 1

            for i = 1, math.max(v25.Time * 100, 1) do
                task.delay(i / 100, function() -- line: 331
                    -- upvalues: p1 (copy), p2 (copy)
                    p2.iconChanged:Fire(p1)
                end)
            end

            task.delay(v25.Time - 0.2, function() -- line: 335
                -- upvalues: p1 (copy), n1 (ref)
                n1 -= 1
                task.defer(function() -- line: 337
                    -- upvalues: p1 (copy), n1 (ref)
                    if n1 == 0 then
                        p1.resizingComplete:Fire()
                    end
                end)
            end)
            p1:updateParent()
        end)
    end

    local v28 = Utility.createStagger(0.01, handleLabelAndImageChangesUnstaggered)
    local Y = Frame4.AbsoluteSize.Y

    Frame4:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 351
        -- upvalues: Frame4 (copy), v28 (copy), Y (ref)
        local Y2 = Frame4.AbsoluteSize.Y

        if Y2 ~= Y then
            Y = Y2
            v28()
        end
    end)
    TextLabel:GetPropertyChangedSignal("TextBounds"):Connect(v28)

    local v29 = true

    p1:setBehaviour("IconLabel", "Text", v28)
    p1:setBehaviour("IconLabel", "FontFace", function(p6) -- line: 361
        -- upvalues: TextLabel (copy), v28 (copy), v29 (ref)
        if TextLabel.FontFace ~= p6 then
            task.spawn(function() -- line: 366
                -- upvalues: v28 (copy), v29 (ref)
                v28()

                if v29 then
                    v29 = false

                    for _ = 1, 10 do
                        task.wait(1)
                        v28()
                    end
                end
            end)
        end
    end)

    local function updateBorderSize() -- line: 388
        -- upvalues: p1 (copy), Frame (copy), v3 (copy), MenuUIListLayout (copy), MenuGap (copy), Frame3 (copy), v28 (copy)
        task.defer(function() -- line: 389
            -- upvalues: p1 (copy), Frame (copy), v3 (copy), MenuUIListLayout (copy), MenuGap (copy), Frame3 (copy), v28 (copy)
            local BorderSize = Frame:GetAttribute("BorderSize")
            local alignment = p1.alignment
            local v30 = if Frame3.Visible == false then 0 else alignment == "Right" and -BorderSize or BorderSize

            v3.Position = UDim2.new(0, v30, 0, 0)
            MenuGap.Size = UDim2.fromOffset(BorderSize, 0)
            MenuUIListLayout.Padding = UDim.new(0, 0)
            v28()
        end)
    end

    p1:setBehaviour("Widget", "BorderSize", updateBorderSize)
    p1:setBehaviour("IconSpot", "Visible", updateBorderSize)
    p1.startMenuUpdate:Connect(v28)
    p1.updateSize:Connect(v28)
    p1:setBehaviour("ContentsList", "HorizontalAlignment", v28)
    p1:setBehaviour("Widget", "Visible", v28)
    p1:setBehaviour("Widget", "DesiredWidth", v28)
    p1:setBehaviour("Widget", "MinimumWidth", v28)
    p1:setBehaviour("PaddingLeft", "Size", v28)
    p1:setBehaviour("PaddingCenter", "Size", v28)
    p1:setBehaviour("PaddingRight", "Size", v28)
    p1:setBehaviour("Widget", "MinimumHeight", v28)
    p1:setBehaviour("Indicator", "Visible", v28)
    p1:setBehaviour("IconImageRatio", "AspectRatio", v28)
    p1:setBehaviour("IconImage", "Image", function(p7) -- line: 413
        -- upvalues: ImageLabel (copy), v28 (copy)
        local v32, v33

        if typeof(p7) == "Content" then
            v33 = p7
            v32 = ImageLabel.ImageContent
        else
            v33 = if tonumber(p7) then ("rbxassetid://%*"):format(p7) else p7 or ""
            v32 = ImageLabel.Image
        end

        if v32 ~= v33 then
            v28()
        end

        return v33
    end)
    p1.alignmentChanged:Connect(function(p8) -- line: 422
        -- upvalues: p1 (copy), Frame (copy), v3 (copy), MenuUIListLayout (copy), MenuGap (copy), Frame3 (copy), v28 (copy)
        local v34 = if p8 == "Center" then "Left" else p8

        MenuUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment[v34]
        task.defer(function() -- line: 389
            -- upvalues: p1 (copy), Frame (copy), v3 (copy), MenuUIListLayout (copy), MenuGap (copy), Frame3 (copy), v28 (copy)
            local BorderSize = Frame:GetAttribute("BorderSize")
            local alignment = p1.alignment
            local v35 = if Frame3.Visible == false then 0 else alignment == "Right" and -BorderSize or BorderSize

            v3.Position = UDim2.new(0, v35, 0, 0)
            MenuGap.Size = UDim2.fromOffset(BorderSize, 0)
            MenuUIListLayout.Padding = UDim.new(0, 0)
            v28()
        end)
    end)

    local LocalPlayer = game:GetService("Players").LocalPlayer
    local LocaleId = LocalPlayer.LocaleId

    p1.janitor:add(LocalPlayer:GetPropertyChangedSignal("LocaleId"):Connect(function() -- line: 434
        -- upvalues: p1 (copy), LocalPlayer (copy), LocaleId (ref)
        task.delay(0.2, function() -- line: 435
            -- upvalues: p1 (copy), LocalPlayer (copy), LocaleId (ref)
            local LocaleId2 = LocalPlayer.LocaleId

            if LocaleId2 == LocaleId then
                return
            end

            LocaleId = LocaleId2
            p1:refresh()
            task.wait(0.5)
            p1:refresh()
        end)
    end))

    local NumberValue = Instance.new("NumberValue")

    NumberValue.Name = "IconImageScale"
    NumberValue.Parent = ImageLabel
    NumberValue:GetPropertyChangedSignal("Value"):Connect(function() -- line: 449
        -- upvalues: ImageLabel (copy), NumberValue (copy)
        ImageLabel.Size = UDim2.new(NumberValue.Value, 0, NumberValue.Value, 0)
    end)

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint.Name = "IconImageRatio"
    UIAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
    UIAspectRatioConstraint.Parent = ImageLabel

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Name = "IconGradient"
    UIGradient.Enabled = true
    UIGradient.Parent = Frame2

    local UIGradient2 = Instance.new("UIGradient")

    UIGradient2.Name = "IconSpotGradient"
    UIGradient2.Enabled = true
    UIGradient2.Parent = Frame3

    return Frame
end
