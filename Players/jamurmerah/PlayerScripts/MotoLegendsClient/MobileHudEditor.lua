-- https://lua.expert

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local MobileHudLayout = require(MotoLegends:WaitForChild("MobileHudLayout"))
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local JerezRaceHUD = PlayerGui:WaitForChild("JerezRaceHUD")
local v1 = Color3.new(1, 1, 1)
local v2 = Color3.fromRGB(14, 14, 16)
local v3 = Color3.fromRGB(236, 39, 49)

Color3.fromRGB(150, 154, 166)

local v4 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Regular)
local n1 = 12
local GuiService = game:GetService("GuiService")
local ScreenGui, ScreenGui2, Frame, t1
local v5 = nil
local Name, t2, connection, v6, v7

local function root() -- line: 25
    -- upvalues: JerezRaceHUD (copy)
    return JerezRaceHUD:FindFirstChild("TouchControls")
end

local function entry(p1) -- line: 27
    -- upvalues: JerezRaceHUD (copy), v5 (ref)
    local v8 = JerezRaceHUD:FindFirstChild("TouchControls") and JerezRaceHUD:FindFirstChild("TouchControls"):FindFirstChild(p1)
    local v9 = v5[p1]

    if not v9 and v8 then
        local TouchControls = JerezRaceHUD:FindFirstChild("TouchControls")
        local v10 = v8.AbsolutePosition + v8.AbsoluteSize * v8.AnchorPoint - TouchControls.AbsolutePosition

        v9 = {
            s = 1
        }
        v9.x = v10.X / math.max(TouchControls.AbsoluteSize.X, 1)
        v9.y = v10.Y / math.max(TouchControls.AbsoluteSize.Y, 1)

        local v11 = v5

        v11[p1] = v9
    end

    return v9
end

local n2 = 0

local function nextOrder() -- line: 37
    -- upvalues: n2 (ref)
    n2 += 1

    return n2
end

local function button(p2, p3, p4, p5) -- line: 38
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), v4 (copy), n1 (ref), n2 (ref)
    local TextButton = Instance.new("TextButton")

    n2 += 1
    TextButton.LayoutOrder = n2
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = p5 or v1
    TextButton.BorderSizePixel = 0
    TextButton.Text = p3
    TextButton.FontFace = v4
    TextButton.TextScaled = false
    TextButton.TextSize = n1

    if (p5 == v3 or p5 == v2) and v1 then
        TextButton.TextColor3 = v1
    else
        TextButton.TextColor3 = v2
    end

    TextButton.Size = UDim2.new(0, p4, 1, 0)
    TextButton.AutoLocalize = false
    Instance.new("UICorner", TextButton).CornerRadius = UDim.new(1, 0)
    TextButton.Parent = p2

    return TextButton
end

local v12

local function open() -- line: 46
    -- upvalues: RunService (copy), MobileHudLayout (copy), PlayerGui (copy), JerezRaceHUD (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), n1 (ref), GuiService (copy), ScreenGui (ref), ScreenGui2 (ref), Frame (ref), t1 (ref), v5 (ref), Name (ref), t2 (ref), connection (ref), v6 (ref), v7 (ref), entry (copy), n2 (ref), button (copy), v12 (ref)
    if ScreenGui then
        return
    end

    n2 = 0

    local TouchControls = JerezRaceHUD:FindFirstChild("TouchControls")

    if not TouchControls then
        JerezRaceHUD:SetAttribute("MobileHudEditing", false)

        return
    end

    v5 = MobileHudLayout.Decode(JerezRaceHUD:GetAttribute("MobileHudLayout"))
    JerezRaceHUD:SetAttribute("MobileHudPreview", MobileHudLayout.Encode(v5))
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MobileHudEditor"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 200
    ScreenGui.IgnoreGuiInset = JerezRaceHUD.IgnoreGuiInset

    local function v14() -- line: 55
        -- upvalues: JerezRaceHUD (copy), ScreenGui (ref)
        ScreenGui.ScreenInsets = JerezRaceHUD.ScreenInsets
    end

    pcall(v14)

    local function v15() -- line: 55
        -- upvalues: JerezRaceHUD (copy), ScreenGui (ref)
        ScreenGui.SafeAreaCompatibility = JerezRaceHUD.SafeAreaCompatibility
    end

    pcall(v15)

    local function v16() -- line: 55
        -- upvalues: JerezRaceHUD (copy), ScreenGui (ref)
        ScreenGui.ClipToDeviceSafeArea = JerezRaceHUD.ClipToDeviceSafeArea
    end

    pcall(v16)
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui
    Frame = Instance.new("Frame")
    Frame.Name = "OriginProbe"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromOffset(0, 0)
    Frame.Position = UDim2.fromOffset(0, 0)
    Frame.Parent = ScreenGui

    local Frame4 = Instance.new("Frame")

    Frame4.Name = "Dim"
    Frame4.Size = UDim2.fromScale(1, 1)
    Frame4.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame4.BackgroundTransparency = 0.65
    Frame4.BorderSizePixel = 0
    Frame4.Active = true
    Frame4.ZIndex = 0
    Frame4.Parent = ScreenGui
    ScreenGui2 = Instance.new("ScreenGui")
    ScreenGui2.Name = "MobileHudEditorBar"
    ScreenGui2.ResetOnSpawn = false
    ScreenGui2.DisplayOrder = 201
    ScreenGui2.IgnoreGuiInset = true
    ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local function v17() -- line: 67
        -- upvalues: ScreenGui2 (ref)
        ScreenGui2.ScreenInsets = Enum.ScreenInsets.None
    end

    pcall(v17)
    ScreenGui2.Parent = PlayerGui

    local function topbarHeight() -- line: 68
        -- upvalues: GuiService (copy)
        local Height = GuiService.TopbarInset.Height

        if Height <= 0 then
            Height = GuiService:GetGuiInset().Y
        end

        return (math.max(Height, 36))
    end

    local Height = GuiService.TopbarInset.Height

    if Height <= 0 then
        Height = GuiService:GetGuiInset().Y
    end

    local v20 = math.clamp(math.floor(math.max(Height, 36) * 0.5), 22, 30)

    n1 = math.max(9, (math.floor(v20 * 0.42)))

    local v24 = math.floor(v20 * 15.6 + 28 + 12)
    local Frame5 = Instance.new("Frame")

    Frame5.Name = "Toolbar"
    Frame5.AnchorPoint = Vector2.new(0.5, 0)

    local new = UDim2.new
    local Height2 = GuiService.TopbarInset.Height

    if Height2 <= 0 then
        Height2 = GuiService:GetGuiInset().Y
    end

    Frame5.Position = new(0.5, 0, 0, (math.floor((math.max(Height2, 36) - v20) / 2)))
    Frame5.Size = UDim2.fromOffset(v24, v20)
    Frame5.BackgroundColor3 = v2
    Frame5.BackgroundTransparency = 0.1
    Frame5.BorderSizePixel = 0
    Frame5.ZIndex = 20
    Frame5.Active = true
    Frame5.Parent = ScreenGui2

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = Frame5

    local function fitBar() -- line: 77
        -- upvalues: v24 (copy), UIScale (copy), ScreenGui2 (ref)
        UIScale.Scale = math.min(1, (ScreenGui2.AbsoluteSize.X - 16) / math.max(v24, 1))
    end

    Instance.new("UIStroke", Frame5).Color = Color3.fromRGB(60, 60, 66)

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingLeft = UDim.new(0, 6)
    UIPadding.PaddingRight = UDim.new(0, 6)
    UIPadding.Parent = Frame5
    Instance.new("UICorner", Frame5).CornerRadius = UDim.new(0, 8)

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0, 4)
    UIListLayout.Parent = Frame5
    UIPadding.PaddingTop = UDim.new(0, 3)
    UIPadding.PaddingBottom = UDim.new(0, 3)

    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.FontFace = v4
    TextLabel.TextScaled = false
    TextLabel.TextSize = n1
    TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
    TextLabel.TextColor3 = v1
    TextLabel.Size = UDim2.new(0, v20 * 3.6, 1, 0)
    TextLabel.Text = "TAP A CONTROL"
    TextLabel.AutoLocalize = false
    n2 += 1
    TextLabel.LayoutOrder = n2
    TextLabel.Parent = Frame5

    local v27 = button(Frame5, "−", v20, v1)
    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.BackgroundTransparency = 1
    TextLabel2.FontFace = v4
    TextLabel2.TextScaled = false
    TextLabel2.TextSize = n1
    TextLabel2.TextColor3 = v1
    TextLabel2.Size = UDim2.new(0, v20 * 1.4, 1, 0)
    TextLabel2.Text = "100%"
    TextLabel2.AutoLocalize = false
    n2 += 1
    TextLabel2.LayoutOrder = n2
    TextLabel2.Parent = Frame5

    local v28 = button(Frame5, "+", v20, v1)

    local function outline(p6) -- line: 90
        -- upvalues: v1 (copy)
        local UIStroke = Instance.new("UIStroke")

        UIStroke.Color = v1
        UIStroke.Thickness = 1
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.Parent = p6
    end

    local v29 = button(Frame5, "RESET", v20 * 1.9, v2)
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = v1
    UIStroke.Thickness = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = v29

    local v30 = button(Frame5, "RESET ALL", v20 * 2.6, v2)
    local UIStroke2 = Instance.new("UIStroke")

    UIStroke2.Color = v1
    UIStroke2.Thickness = 1
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke2.Parent = v30

    local v31 = button(Frame5, "CANCEL", v20 * 2.3, v1)
    local v32 = button(Frame5, "SAVE", v20 * 1.8, v3)

    UIScale.Scale = math.min(1, (ScreenGui2.AbsoluteSize.X - 16) / math.max(v24, 1))

    for _, descendant in Frame5:GetDescendants() do
        if descendant:IsA("GuiObject") then
            descendant.ZIndex = 21
        end
    end

    v6 = function() -- line: 101
        -- upvalues: v20 (copy), v24 (copy), Frame5 (copy), UIScale (copy), PlayerGui (copy), GuiService (copy), ScreenGui (ref), ScreenGui2 (ref), t1 (ref), t2 (ref)
        if t2 then
            return
        end

        local X = ScreenGui2.AbsoluteSize.X
        local GuiInset = GuiService:GetGuiInset()
        local TopbarInset = GuiService.TopbarInset
        local Height = GuiService.TopbarInset.Height

        if Height <= 0 then
            Height = GuiService:GetGuiInset().Y
        end

        local v34 = math.max(Height, 36)
        local v35 = X - 8
        local v36

        if TopbarInset.Width > 0 then
            v36 = math.max(8, TopbarInset.Min.X + 6)
            v35 = math.min(v35, TopbarInset.Max.X - 6)
        else
            v36 = 8
        end

        local t3 = {}

        local function block(p7) -- line: 110
            -- upvalues: X (copy), GuiInset (copy), v34 (copy), t3 (copy)
            local v39 = p7.AbsolutePosition + GuiInset
            local AbsoluteSize = p7.AbsoluteSize

            if not (AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 or AbsoluteSize.X > X * 0.4) and v39.Y < v34 and v39.Y + AbsoluteSize.Y > 0 then
                table.insert(t3, {
                    v39.X - 6,
                    v39.X + AbsoluteSize.X + 6
                })
            end
        end

        for _, child in PlayerGui:GetChildren() do
            if child:IsA("ScreenGui") and child.Enabled and child ~= ScreenGui and child ~= ScreenGui2 then
                for _, descendant in child:GetDescendants() do
                    if descendant:IsA("GuiButton") and descendant.Visible then
                        block(descendant)
                    end
                end
            end
        end

        for v40 in t1 or {} do
            if v40.Parent and v40.Visible then
                block(v40)
            end
        end

        table.sort(t3, function(p8, p9) -- line: 121
            return p8[1] < p9[1]
        end)

        local t5 = {}
        local v41 = v36

        for _, v42 in t3 do
            if v41 < v42[1] then
                table.insert(t5, {
                    v41,
                    (math.min(v42[1], v35))
                })
            end

            v41 = math.max(v41, v42[2])
        end

        if v41 < v35 then
            table.insert(t5, {
                v41,
                v35
            })
        end

        local v45, v46

        for _, v47 in t5 do
            if v47[2] - v47[1] > 0 then
                if not v45 or v47[2] - v47[1] > v45[2] - v45[1] then
                    v45 = v47
                end

                if v47[1] <= X / 2 and v47[2] >= X / 2 then
                    v46 = v47
                end
            end
        end

        if v46 and v45 and v46[2] - v46[1] < (v45[2] - v45[1]) * 0.6 then
            v46 = nil
        end

        local v48 = v46 or v45 or { v36, v35 }
        local v50 = math.clamp((v48[2] - v48[1]) / math.max(v24, 1), 0.35, 1)

        UIScale.Scale = v50

        local v51 = v24 * v50 / 2
        local v57 = math.clamp(X / 2, v48[1] + v51, (math.max(v48[1] + v51, v48[2] - v51)))

        Frame5.Position = UDim2.fromOffset(math.floor(v57), (math.floor((v34 - v20 * v50) / 2)))
    end

    local function refreshBar() -- line: 143
        -- upvalues: TextLabel (copy), v27 (copy), TextLabel2 (copy), v28 (copy), v29 (copy), MobileHudLayout (copy), v5 (ref), Name (ref)
        local v60 = Name and v5[Name]
        local v61, v62

        if Name then
            local v63 = string.upper(MobileHudLayout.Names[Name] or Name)

            if v63 then
                v61 = v63
                v62 = true
            else
                v62 = false
            end
        else
            v62 = false
        end

        TextLabel.Text = if not v62 then "TAP A CONTROL" else v61

        local v64, v65

        if Name then
            local v67 = math.floor((v60 and v60.s or 1) * 100 + 0.5) .. "%"

            if v67 then
                v64 = v67
                v65 = true
            else
                v65 = false
            end
        else
            v65 = false
        end

        TextLabel2.Text = if not v65 then "—" else v64

        for _, v68 in { v27, v28, v29 } do
            v68.AutoButtonColor = false
            v68.BackgroundTransparency = Name and 0 or 0.6
        end
    end

    v27.Activated:Connect(function() -- line: 155
        -- upvalues: refreshBar (copy), MobileHudLayout (copy), JerezRaceHUD (copy), v5 (ref), Name (ref), entry (copy)
        if not Name then
            return
        end

        local v69 = entry(Name)

        if v69 then
            v69.s = math.clamp(math.floor(((v69.s or 1) + -0.1) * 10 + 0.5) / 10, MobileHudLayout.MinScale, MobileHudLayout.MaxScale)
            JerezRaceHUD:SetAttribute("MobileHudPreview", MobileHudLayout.Encode(v5))
            refreshBar()
        end
    end)
    v28.Activated:Connect(function() -- line: 156
        -- upvalues: refreshBar (copy), MobileHudLayout (copy), JerezRaceHUD (copy), v5 (ref), Name (ref), entry (copy)
        if not Name then
            return
        end

        local v73 = entry(Name)

        if v73 then
            v73.s = math.clamp(math.floor(((v73.s or 1) + 0.1) * 10 + 0.5) / 10, MobileHudLayout.MinScale, MobileHudLayout.MaxScale)
            JerezRaceHUD:SetAttribute("MobileHudPreview", MobileHudLayout.Encode(v5))
            refreshBar()
        end
    end)
    v29.Activated:Connect(function() -- line: 157
        -- upvalues: refreshBar (copy), MobileHudLayout (copy), JerezRaceHUD (copy), v5 (ref), Name (ref)
        if not Name then
            return
        end

        v5[Name] = nil
        JerezRaceHUD:SetAttribute("MobileHudPreview", MobileHudLayout.Encode(v5))
        refreshBar()
    end)
    v30.Activated:Connect(function() -- line: 158
        -- upvalues: refreshBar (copy), MobileHudLayout (copy), JerezRaceHUD (copy), v5 (ref), Name (ref)
        v5 = {}
        Name = nil
        JerezRaceHUD:SetAttribute("MobileHudPreview", MobileHudLayout.Encode(v5))
        refreshBar()
    end)
    v31.Activated:Connect(function() -- line: 159
        -- upvalues: v12 (ref)
        v12(false)
    end)
    v32.Activated:Connect(function() -- line: 160
        -- upvalues: v12 (ref)
        v12(true)
    end)
    t1 = {}

    for _, child in TouchControls:GetChildren() do
        if child:IsA("GuiObject") and not MobileHudLayout.IsFollower[child.Name] then
            local TextButton = Instance.new("TextButton")

            TextButton.Name = "Handle_" .. child.Name
            TextButton.Text = ""
            TextButton.AutoButtonColor = false
            TextButton.BackgroundColor3 = v1
            TextButton.BackgroundTransparency = 0.88
            TextButton.BorderSizePixel = 0
            TextButton.ZIndex = 10
            TextButton.Parent = ScreenGui

            local UIStroke = Instance.new("UIStroke")

            UIStroke.Color = v1
            UIStroke.Thickness = 2
            UIStroke.Transparency = 0.2
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke.Parent = TextButton
            Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 8)
            TextButton.InputBegan:Connect(function(p10) -- line: 169
                -- upvalues: refreshBar (copy), child (copy), Name (ref), t2 (ref)
                if p10.UserInputType ~= Enum.UserInputType.Touch and p10.UserInputType ~= Enum.UserInputType.MouseButton1 or p10.UserInputState ~= Enum.UserInputState.Begin then
                    return
                end

                Name = child.Name
                refreshBar()

                local v80 = child.AbsolutePosition + child.AbsoluteSize * child.AnchorPoint

                t2 = {
                    moved = false,
                    input = p10,
                    name = child.Name,
                    control = child,
                    offset = Vector2.new(p10.Position.X, p10.Position.Y) - v80
                }
            end)
            t1[child] = TextButton
        end
    end

    connection = RunService.RenderStepped:Connect(function() -- line: 179
        -- upvalues: v1 (copy), v3 (copy), Frame (ref), t1 (ref), Name (ref), v6 (ref), v7 (ref)
        local AbsolutePosition = Frame and Frame.AbsolutePosition or Vector2.zero

        for v81, v82 in t1 do
            if v81.Parent then
                v82.Visible = v81.Visible

                local v83 = v81.AbsolutePosition - AbsolutePosition

                v82.Position = UDim2.fromOffset(v83.X, v83.Y)
                v82.Size = UDim2.fromOffset(v81.AbsoluteSize.X, v81.AbsoluteSize.Y)

                local UIStroke = v82:FindFirstChildOfClass("UIStroke")

                UIStroke.Color = v81.Name == Name and v3 or v1
                UIStroke.Thickness = v81.Name == Name and 3 or 2
                v82.BackgroundTransparency = v81.Name == Name and 0.78 or 0.9
            end
        end

        if v6 and os.clock() >= (v7 or 0) then
            v7 = os.clock() + 0.25
            v6()
        end
    end)
    refreshBar()
end

UserInputService.InputChanged:Connect(function(p11) -- line: 195
    -- upvalues: JerezRaceHUD (copy), ScreenGui (ref), t2 (ref), entry (copy)
    if not (t2 and ScreenGui) or p11 ~= t2.input and (t2.input.UserInputType ~= Enum.UserInputType.MouseButton1 or p11.UserInputType ~= Enum.UserInputType.MouseMovement) then
        return
    end

    local TouchControls = JerezRaceHUD:FindFirstChild("TouchControls")

    if not TouchControls then
        return
    end

    local v84 = Vector2.new(p11.Position.X, p11.Position.Y) - t2.offset - TouchControls.AbsolutePosition
    local AbsoluteSize = TouchControls.AbsoluteSize
    local v85 = entry(t2.name)

    if v85 then
        v85.x = math.clamp(v84.X / math.max(AbsoluteSize.X, 1), 0, 1)
        v85.y = math.clamp(v84.Y / math.max(AbsoluteSize.Y, 1), 0, 1)
        t2.control.Position = UDim2.fromScale(v85.x, v85.y)
        t2.moved = true
    end
end)
UserInputService.InputEnded:Connect(function(p12) -- line: 206
    -- upvalues: MobileHudLayout (copy), JerezRaceHUD (copy), v5 (ref), t2 (ref)
    if not t2 or p12 ~= t2.input and (t2.input.UserInputType ~= Enum.UserInputType.MouseButton1 or p12.UserInputType ~= Enum.UserInputType.MouseButton1) then
        return
    end

    local moved = t2.moved

    t2 = nil

    if not moved then
        return
    end

    JerezRaceHUD:SetAttribute("MobileHudPreview", MobileHudLayout.Encode(v5))
end)

v12 = function(p13) -- line: 212
    -- upvalues: MobileHudLayout (copy), JerezRaceHUD (copy), ScreenGui (ref), ScreenGui2 (ref), Frame (ref), t1 (ref), v5 (ref), Name (ref), t2 (ref), connection (ref), v6 (ref), v7 (ref)
    if not ScreenGui then
        return
    end

    if connection then
        connection:Disconnect()
        connection = nil
    end

    ScreenGui:Destroy()
    ScreenGui = nil
    Frame = nil
    t1 = nil
    t2 = nil
    Name = nil

    if ScreenGui2 then
        ScreenGui2:Destroy()
        ScreenGui2 = nil
    end

    v6 = nil
    v7 = nil

    if p13 then
        JerezRaceHUD:SetAttribute("MobileHudLayout", MobileHudLayout.Encode(v5))
    end

    JerezRaceHUD:SetAttribute("MobileHudEditing", false)
    JerezRaceHUD:SetAttribute("MobileHudPreview", nil)
end

JerezRaceHUD:GetAttributeChangedSignal("MobileHudEditing"):Connect(function() -- line: 221
    -- upvalues: JerezRaceHUD (copy), ScreenGui (ref), v12 (ref), open (copy)
    if JerezRaceHUD:GetAttribute("MobileHudEditing") == true then
        task.defer(open)
    elseif ScreenGui then
        v12(false)
    end
end)
