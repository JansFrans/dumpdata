-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local LegendsCatalog = require(MotoLegends:WaitForChild("LegendsCatalog"))
local LegendRig = require(MotoLegends:WaitForChild("LegendRig"))
local UIArt = require(MotoLegends:WaitForChild("UIArt"))
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local v1 = Color3.fromRGB(225, 6, 0)
local v2 = Color3.new(1, 1, 1)
local v3 = Color3.new(0, 0, 0)
local v4 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)

Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)

local function new(p1, p2, p3) -- line: 50
    local v5 = Instance.new(p1)

    for v6, v7 in p2 do
        v5[v6] = v7
    end

    v5.Parent = p3

    return v5
end

local function corner(p4, p5) -- line: 51
    local t1 = {
        CornerRadius = UDim.new(0, p5)
    }
    local UICorner = Instance.new("UICorner")

    for v8, v9 in t1 do
        UICorner[v8] = v9
    end

    UICorner.Parent = p4

    return p4
end

local t2 = {
    Name = "GridLegendPick",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 42,
    Enabled = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}
local ScreenGui = Instance.new("ScreenGui")

for v10, v11 in t2 do
    ScreenGui[v10] = v11
end

ScreenGui.Parent = PlayerGui

local v12 = false

ScreenGui:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 59
    -- upvalues: ScreenGui (copy), v12 (ref)
    if ScreenGui.Enabled and not v12 then
        ScreenGui.Enabled = false
    end
end)

local t3 = {
    Name = "Panel",
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(209, 419)
}
local Frame = Instance.new("Frame")

for v13, v14 in t3 do
    Frame[v13] = v14
end

Frame.Parent = ScreenGui

local t4 = {
    Scale = 0.5
}
local UIScale = Instance.new("UIScale")

for v15, v16 in t4 do
    UIScale[v15] = v16
end

UIScale.Parent = Frame

local t5 = {
    Name = "LegendTitle",
    BackgroundTransparency = 1,
    TextSize = 52,
    Text = "",
    AutoLocalize = false,
    FontFace = v4,
    TextColor3 = v2,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 311),
    Size = UDim2.new(0, 1000, 0, 58)
}
local TextLabel = Instance.new("TextLabel")

for v17, v18 in t5 do
    TextLabel[v17] = v18
end

TextLabel.Parent = Frame

local t6 = {
    Thickness = 3,
    Transparency = 0,
    Color = v3,
    LineJoinMode = Enum.LineJoinMode.Miter
}
local UIStroke = Instance.new("UIStroke")

for v19, v20 in t6 do
    UIStroke[v19] = v20
end

UIStroke.Parent = TextLabel

local t7 = {
    Offset = Vector2.new(-0.7, 0)
}
local UIGradient = Instance.new("UIGradient")

for v21, v22 in t7 do
    UIGradient[v21] = v22
end

UIGradient.Parent = TextLabel

local function titleColor(p6) -- line: 67
    -- upvalues: v1 (copy), v2 (copy), UIGradient (copy)
    p6 = p6 or v1

    local v24 = p6:Lerp(v2, 0.55)
    local v25 = p6:Lerp(v2, 0.92)

    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, p6),
        ColorSequenceKeypoint.new(0.38, p6),
        ColorSequenceKeypoint.new(0.45, v24),
        ColorSequenceKeypoint.new(0.5, v25),
        ColorSequenceKeypoint.new(0.55, v24),
        ColorSequenceKeypoint.new(0.62, p6),
        ColorSequenceKeypoint.new(1, p6)
    })
end

titleColor(v1)

local t8 = {
    Name = "TitleLine",
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 371),
    Size = UDim2.fromOffset(298, 6)
}
local ImageLabel = Instance.new("ImageLabel")

for v26, v27 in t8 do
    ImageLabel[v26] = v27
end

ImageLabel.Parent = Frame

local v28 = UIArt.Apply

pcall(v28, ImageLabel, "Line")
v28 = {
    Name = "TimerLine",
    BackgroundTransparency = 0.1,
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(8, 8, 10),
    Position = UDim2.fromOffset(0, 285),
    Size = UDim2.new(1, 0, 0, 12)
}

local Frame2 = Instance.new("Frame")

for v29, v30 in v28 do
    Frame2[v29] = v30
end

Frame2.Parent = Frame

local t9 = {
    Name = "Fill",
    BorderSizePixel = 0,
    BackgroundColor3 = v1,
    Size = UDim2.fromScale(1, 1)
}
local Frame3 = Instance.new("Frame")

for v31, v32 in t9 do
    Frame3[v31] = v32
end

Frame3.Parent = Frame2

local t10 = {
    Name = "Description",
    BackgroundTransparency = 1,
    TextSize = 26,
    Text = "",
    AutoLocalize = true,
    FontFace = v4,
    TextColor3 = v2,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 385),
    Size = UDim2.new(0, 1000, 0, 34)
}
local TextLabel2 = Instance.new("TextLabel")

for v33, v34 in t10 do
    TextLabel2[v33] = v34
end

TextLabel2.Parent = Frame
t10 = {
    Thickness = 2,
    Transparency = 0.35,
    Color = v3
}

local UIStroke2 = Instance.new("UIStroke")

for v35, v36 in t10 do
    UIStroke2[v35] = v36
end

UIStroke2.Parent = TextLabel2
UIStroke2.Enabled = false

local t11 = {}

local function rigView(p7, p8) -- line: 88
    -- upvalues: MotoLegends (copy), LegendRig (copy), v2 (copy), v3 (copy)
    local LegendRigs = MotoLegends:FindFirstChild("LegendRigs")
    local v37 = LegendRigs and LegendRigs:FindFirstChild(p8)
    local v38 = LegendRig.Cameras[p8]
    local v39 = v38 and v38.Slot

    if not v37 or not v39 then
        return nil
    end

    local v43 = math.deg(math.atan(math.tan(math.rad(v39.Fov) / 2) * 1.9) * 2)

    local function view(p9, p10) -- line: 93
        -- upvalues: p7 (copy), v39 (copy), v43 (copy), v2 (copy), v3 (copy)
        local t12 = {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(295.5, 523.5),
            Size = UDim2.fromOffset(362.9, 469.29999999999995),
            ZIndex = p9
        }
        local ViewportFrame = Instance.new("ViewportFrame")

        for v44, v45 in t12 do
            ViewportFrame[v44] = v45
        end

        ViewportFrame.Parent = p7

        if p10 then
            ViewportFrame.Ambient = v2
            ViewportFrame.LightColor = v3
        else
            ViewportFrame.Ambient = Color3.fromRGB(165, 150, 145)
            ViewportFrame.LightColor = Color3.fromRGB(255, 246, 236)
            ViewportFrame.LightDirection = Vector3.new(0.55, -0.6, -0.6)
        end

        local t13 = {
            FieldOfView = v43,
            CFrame = CFrame.lookAt(v39.Pos, v39.Look)
        }
        local Camera = Instance.new("Camera")

        for v46, v47 in t13 do
            Camera[v46] = v47
        end

        Camera.Parent = ViewportFrame
        ViewportFrame.CurrentCamera = Camera

        return ViewportFrame
    end

    local v48 = view(4, true)
    local v49 = view(5, false)
    local v50 = LegendRig.MakeOutline(v37)

    v50.Parent = v48

    local clone = v37:Clone()

    clone.Parent = v49
    LegendRig.Apply(clone, p8, CFrame.identity, 0)
    LegendRig.Apply(v50, p8, CFrame.identity, 0)

    return {
        model = clone,
        outline = v50,
        id = p8
    }
end

local t14 = {
    open = false,
    locked = false,
    serial = 0,
    picked = nil
}

local function setText(p11) -- line: 109
    -- upvalues: LegendsCatalog (copy), v1 (copy), v2 (copy), TextLabel (copy), titleColor (copy), TextLabel2 (copy)
    local v51 = p11 and LegendsCatalog.Legends[p11]

    TextLabel.Text = v51 and v51.Title or ""
    TextLabel.TextColor3 = v2
    titleColor(v51 and v51.Color or v1)
    TextLabel2.Text = v51 and v51.Description:gsub("%.+%s*$", "") or ""
end

local function paint() -- line: 114
    -- upvalues: TweenService (copy), LegendsCatalog (copy), v1 (copy), v2 (copy), TextLabel (copy), titleColor (copy), TextLabel2 (copy), t11 (copy), t14 (copy)
    for _, v53 in t11 do
        local v54 = v53.slot == t14.picked

        v53.stroke.Color = v1
        v53.stroke.Transparency = v54 and 0 or 1
        v53.badge.Visible = v54
        TweenService:Create(v53.pop, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = v54 and 1.06 or 1
        }):Play()

        if v54 then
            local id = v53.id
            local v56 = id and LegendsCatalog.Legends[id]

            TextLabel.Text = v56 and v56.Title or ""
            TextLabel.TextColor3 = v2
            titleColor(v56 and v56.Color or v1)
            TextLabel2.Text = v56 and v56.Description:gsub("%.+%s*$", "") or ""
        end
    end
end

local function choose(p12, p13) -- line: 123
    -- upvalues: MotoLegends (copy), t14 (copy), paint (copy)
    if t14.locked or t14.picked == p12 then
        return
    end

    t14.picked = p12
    paint()

    if not p13 then
        task.spawn(function() -- line: 127
            -- upvalues: p12 (copy), MotoLegends (copy)
            local function v59() -- line: 128
                -- upvalues: p12 (copy), MotoLegends (copy)
                return MotoLegends:WaitForChild("LegendsAction"):InvokeServer("Select", p12)
            end

            local ok, result = pcall(v59)

            if ok and result and not result.ok then
                warn("[GridLegendPick] select: " .. tostring(result.err))
            end
        end)
    end
end

local function makeCard(p14, p15, p16) -- line: 133
    -- upvalues: MotoLegends (copy), LegendsCatalog (copy), UIArt (copy), v1 (copy), v2 (copy), v3 (copy), Frame (copy), t11 (copy), rigView (copy), t14 (copy), paint (copy)
    local v60 = LegendsCatalog.Legends[p15]
    local t16 = {
        BackgroundTransparency = 1,
        Name = "Slot" .. p14,
        Position = UDim2.fromOffset(p16, 0),
        Size = UDim2.fromOffset(209, 265)
    }
    local Frame2 = Instance.new("Frame")

    for v61, v62 in t16 do
        Frame2[v61] = v62
    end

    Frame2.Parent = Frame

    local t17 = {
        Name = "Body",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1)
    }
    local Frame3 = Instance.new("Frame")

    for v63, v64 in t17 do
        Frame3[v63] = v64
    end

    Frame3.Parent = Frame2

    local t18 = {
        Scale = 1
    }
    local UIScale = Instance.new("UIScale")

    for v65, v66 in t18 do
        UIScale[v65] = v66
    end

    UIScale.Parent = Frame3

    local t19 = {
        Name = "Card",
        BorderSizePixel = 0,
        ZIndex = 1,
        BackgroundColor3 = v2,
        Size = UDim2.fromOffset(209, 265)
    }
    local Frame4 = Instance.new("Frame")

    for v67, v68 in t19 do
        Frame4[v67] = v68
    end

    Frame4.Parent = Frame3

    local t20 = {
        CornerRadius = UDim.new(0, 18)
    }
    local UICorner = Instance.new("UICorner")

    for v69, v70 in t20 do
        UICorner[v69] = v70
    end

    UICorner.Parent = Frame4

    local t21 = {
        Thickness = 6,
        Transparency = 1,
        Color = v1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }
    local UIStroke = Instance.new("UIStroke")

    for v71, v72 in t21 do
        UIStroke[v71] = v72
    end

    UIStroke.Parent = Frame4

    local t22 = {
        Name = "Solid",
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 2,
        BackgroundColor3 = v60.Color or v1,
        Position = UDim2.fromOffset(8, 8),
        Size = UDim2.fromOffset(193, 249)
    }
    local Frame5 = Instance.new("Frame")

    for v73, v74 in t22 do
        Frame5[v73] = v74
    end

    Frame5.Parent = Frame3

    local t23 = {
        CornerRadius = UDim.new(0, 12)
    }
    local UICorner2 = Instance.new("UICorner")

    for v75, v76 in t23 do
        UICorner2[v75] = v76
    end

    UICorner2.Parent = Frame5

    local t24 = {
        BorderSizePixel = 0,
        ZIndex = 3,
        BackgroundColor3 = v2,
        Size = UDim2.fromScale(1, 1)
    }
    local Frame6 = Instance.new("Frame")

    for v77, v78 in t24 do
        Frame6[v77] = v78
    end

    Frame6.Parent = Frame5

    local t25 = {
        Rotation = 15,
        Offset = Vector2.new(-1.2, 0),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.34, 1),
            NumberSequenceKeypoint.new(0.5, 0.6),
            NumberSequenceKeypoint.new(0.66, 1),
            NumberSequenceKeypoint.new(1, 1)
        })
    }
    local UIGradient = Instance.new("UIGradient")

    for v79, v80 in t25 do
        UIGradient[v79] = v80
    end

    UIGradient.Parent = Frame6

    local t26 = {
        Name = "RigClip",
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 4,
        Position = UDim2.fromOffset(-191, -391),
        Size = UDim2.fromOffset(591, 647)
    }
    local Frame7 = Instance.new("Frame")

    for v81, v82 in t26 do
        Frame7[v81] = v82
    end

    Frame7.Parent = Frame3

    local v83 = rigView(Frame7, v60.Rig or p15)

    if not v83 and v60.Art then
        local t27 = {
            BackgroundTransparency = 1,
            ZIndex = 5,
            Position = UDim2.fromOffset(153, 417),
            Size = UDim2.fromOffset(279, 349)
        }
        local ImageLabel = Instance.new("ImageLabel")

        for v84, v85 in t27 do
            ImageLabel[v84] = v85
        end

        ImageLabel.Parent = Frame7
        UIArt.Apply(ImageLabel, v60.Art)
    end

    local v86 = v60.Number and MotoLegends.UIArt:FindFirstChild(v60.Number)

    if v86 then
        local v87 = v86:GetAttribute("W") or 2
        local v88 = v86:GetAttribute("H") or 1
        local v90 = math.min(54, 104 * v88 / v87)
        local t28 = {
            BackgroundTransparency = 1,
            ZIndex = 7,
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.fromOffset(204, 261),
            Size = UDim2.fromOffset(math.floor(v90 * v87 / v88 + 0.5), (math.floor(v90 + 0.5)))
        }
        local ImageLabel = Instance.new("ImageLabel")

        for v94, v95 in t28 do
            ImageLabel[v94] = v95
        end

        ImageLabel.Parent = Frame3
        UIArt.Apply(ImageLabel, v60.Number)
    end

    local t29 = {
        Name = "Selected",
        BackgroundTransparency = 1,
        ZIndex = 8,
        Visible = false,
        Position = UDim2.fromOffset(1, -1),
        Size = UDim2.fromOffset(58, 58)
    }
    local ImageLabel = Instance.new("ImageLabel")

    for v96, v97 in t29 do
        ImageLabel[v96] = v97
    end

    ImageLabel.Parent = Frame3
    UIArt.Apply(ImageLabel, "SelectedSlot")

    local t30 = {
        Name = "Dim",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 9,
        BackgroundColor3 = v3,
        Size = UDim2.fromOffset(209, 265)
    }
    local Frame8 = Instance.new("Frame")

    for v98, v99 in t30 do
        Frame8[v98] = v99
    end

    Frame8.Parent = Frame3

    local t31 = {
        CornerRadius = UDim.new(0, 18)
    }
    local UICorner3 = Instance.new("UICorner")

    for v100, v101 in t31 do
        UICorner3[v100] = v101
    end

    UICorner3.Parent = Frame8

    local t32 = {
        Name = "Hit",
        Text = "",
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        ZIndex = 10,
        Size = UDim2.fromScale(1, 1)
    }
    local TextButton = Instance.new("TextButton")

    for v102, v103 in t32 do
        TextButton[v102] = v103
    end

    TextButton.Parent = Frame3
    TextButton:SetAttribute("NoHover", true)
    TextButton.Activated:Connect(function() -- line: 165
        -- upvalues: p14 (copy), MotoLegends (copy), t14 (copy), paint (copy)
        if t14.locked or t14.picked == p14 then
            return
        end

        t14.picked = p14
        paint()
        task.spawn(function() -- line: 127
            -- upvalues: p14 (copy), MotoLegends (copy)
            local function v104() -- line: 128
                -- upvalues: p14 (copy), MotoLegends (copy)
                return MotoLegends:WaitForChild("LegendsAction"):InvokeServer("Select", p14)
            end

            local ok, result = pcall(v104)

            if ok and result and not result.ok then
                warn("[GridLegendPick] select: " .. tostring(result.err))
            end
        end)
    end)
    TextButton.MouseEnter:Connect(function() -- line: 166
        -- upvalues: p14 (copy), UIStroke (copy), v2 (copy), t14 (copy)
        if not t14.locked and t14.picked ~= p14 then
            UIStroke.Color = v2
            UIStroke.Transparency = 0.5
        end
    end)
    TextButton.MouseLeave:Connect(function() -- line: 167
        -- upvalues: p14 (copy), UIStroke (copy), t14 (copy)
        if t14.picked ~= p14 then
            UIStroke.Transparency = 1
        end
    end)

    local t33 = {
        slot = p14,
        id = p15,
        holder = Frame2,
        x = p16,
        stroke = UIStroke,
        badge = ImageLabel,
        dim = Frame8,
        pop = UIScale,
        rig = v83,
        shine = UIGradient
    }

    table.insert(t11, t33)

    return t33
end

local function fit() -- line: 174
    -- upvalues: Frame (copy), UIScale (copy)
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local Offset = Frame.Size.X.Offset

    UIScale.Scale = math.min(ViewportSize.Y * 0.42 / 419, (ViewportSize.X - 24) / math.max(Offset, 600))
end

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 179
    -- upvalues: Frame (copy), UIScale (copy), t14 (copy)
    if t14.open then
        local ViewportSize = workspace.CurrentCamera.ViewportSize
        local Offset = Frame.Size.X.Offset

        UIScale.Scale = math.min(ViewportSize.Y * 0.42 / 419, (ViewportSize.X - 24) / math.max(Offset, 600))
    end
end)

local function readState() -- line: 182
    -- upvalues: HttpService (copy), LocalPlayer (copy), LegendsCatalog (copy)
    local JSONDecode = HttpService.JSONDecode
    local v109 = LocalPlayer:GetAttribute("LegendsState") or "{}"
    local ok, result = pcall(JSONDecode, HttpService, v109)
    local Clean = LegendsCatalog.Clean

    if not ok or not result then
        result = nil
    end

    return Clean(result)
end

local function clear() -- line: 186
    -- upvalues: t11 (copy)
    for _, v110 in t11 do
        v110.holder:Destroy()
    end

    table.clear(t11)
end

local function pickLeft() -- line: 187
    -- upvalues: MotoLegends (copy)
    return (MotoLegends:GetAttribute("LegendPickEnd") or 0) - workspace:GetServerTimeNow()
end

local function above() -- line: 188
    -- upvalues: UIScale (copy)
    return -(workspace.CurrentCamera.ViewportSize.Y / math.max(UIScale.Scale, 0.05))
end

local function open() -- line: 190
    -- upvalues: HttpService (copy), LocalPlayer (copy), MotoLegends (copy), LegendsCatalog (copy), ScreenGui (copy), v12 (ref), Frame (copy), UIScale (copy), TextLabel (copy), UIStroke (copy), ImageLabel (copy), Frame2 (copy), Frame3 (copy), TextLabel2 (copy), UIStroke2 (copy), t11 (copy), t14 (copy), paint (copy), makeCard (copy)
    local Clean, v111, v112

    if MotoLegends:GetAttribute("RDLegendsDisabled") == true then
        v112 = true
    elseif LocalPlayer:GetAttribute("RaceParticipant") == true then
        local JSONDecode = HttpService.JSONDecode
        local v113 = LocalPlayer:GetAttribute("LegendsState") or "{}"
        local ok, result = pcall(JSONDecode, HttpService, v113)

        Clean = LegendsCatalog.Clean
        v111 = ok and result or nil
        v112 = false
    else
        v112 = true
    end

    if v112 then
        return
    end

    local v114 = Clean(v111)
    local t34 = {}

    for i = 1, LegendsCatalog.SlotCount do
        local v115 = v114.slots[i]

        if v114.unlocked[i] and v115 ~= "" and LegendsCatalog.Legends[v115] then
            table.insert(t34, {
                slot = i,
                id = v115
            })
        end
    end

    if #t34 == 0 then
        return
    end

    t14.serial += 1
    t14.open = true
    t14.locked = false
    t14.picked = nil

    for _, v116 in t11 do
        v116.holder:Destroy()
    end

    table.clear(t11)

    local v117 = #t34

    Frame.Size = UDim2.fromOffset(v117 * 209 + (v117 - 1) * 30, 419)

    for v118, v119 in t34 do
        makeCard(v119.slot, v119.id, (v118 - 1) * 239)
    end

    local slot

    for _, v120 in t34 do
        if v120.slot == v114.selected then
            slot = v120.slot
        end
    end

    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local Offset = Frame.Size.X.Offset

    UIScale.Scale = math.min(ViewportSize.Y * 0.42 / 419, (ViewportSize.X - 24) / math.max(Offset, 600))
    Frame3.Size = UDim2.fromScale(1, 1)
    v12 = true
    ScreenGui.Enabled = true

    if slot then
        if not t14.locked and t14.picked ~= slot then
            t14.picked = slot
            paint()
        end
    else
        local slot = t34[1].slot

        if not t14.locked and t14.picked ~= slot then
            t14.picked = slot
            paint()
            task.spawn(function() -- line: 127
                -- upvalues: slot (copy), MotoLegends (copy)
                local function v123() -- line: 128
                    -- upvalues: slot (copy), MotoLegends (copy)
                    return MotoLegends:WaitForChild("LegendsAction"):InvokeServer("Select", slot)
                end

                local ok, result = pcall(v123)

                if ok and result and not result.ok then
                    warn("[GridLegendPick] select: " .. tostring(result.err))
                end
            end)
        end
    end

    for _, v124 in t11 do
        v124.holder.Position = UDim2.fromOffset(v124.x, 0)
    end

    for _, v125 in { TextLabel, TextLabel2 } do
        v125.TextTransparency = 0
    end

    UIStroke.Transparency = 0
    UIStroke2.Transparency = 0.35
    ImageLabel.ImageTransparency = 0
    Frame2.BackgroundTransparency = 0.1
    Frame3.BackgroundTransparency = 0
end

local function close() -- line: 217
    -- upvalues: ScreenGui (copy), v12 (ref), t11 (copy), t14 (copy)
    if t14.open then
        t14.serial += 1
        t14.open = false
        v12 = false
        ScreenGui.Enabled = false

        for _, v126 in t11 do
            v126.holder:Destroy()
        end

        table.clear(t11)
    end
end

local function lockIn() -- line: 225
    -- upvalues: TweenService (copy), v2 (copy), ScreenGui (copy), v12 (ref), Frame3 (copy), t11 (copy), t14 (copy)
    if not t14.open or t14.locked then
        return
    end

    t14.locked = true
    Frame3.Size = UDim2.fromScale(0, 1)

    for _, v127 in t11 do
        if v127.slot == t14.picked then
            v127.stroke.Color = v2
            v127.stroke.Transparency = 0
            TweenService:Create(v127.pop, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Scale = 1.1
            }):Play()
        else
            TweenService:Create(v127.dim, TweenInfo.new(0.3), {
                BackgroundTransparency = 0.5
            }):Play()
        end
    end

    local serial = t14.serial

    task.delay(2.5, function() -- line: 235
        -- upvalues: serial (copy), ScreenGui (copy), v12 (ref), t11 (copy), t14 (copy)
        if serial ~= t14.serial then
            return
        end

        if t14.open then
            t14.serial += 1
            t14.open = false
            v12 = false
            ScreenGui.Enabled = false

            for _, v128 in t11 do
                v128.holder:Destroy()
            end

            table.clear(t11)
        end
    end)
end

local v129 = MotoLegends:GetAttribute("LegendPickId") or 0

local function check() -- line: 240
    -- upvalues: MotoLegends (copy), t14 (copy), open (copy), lockIn (copy), v129 (ref)
    local v130 = MotoLegends:GetAttribute("LegendPickId") or 0

    if v130 == v129 or not ((MotoLegends:GetAttribute("LegendPickEnd") or 0) - workspace:GetServerTimeNow() > 0.5) then
        if t14.open and not t14.locked and (MotoLegends:GetAttribute("LegendPickEnd") or 0) - workspace:GetServerTimeNow() <= 0 then
            lockIn()
        end
    else
        v129 = v130
        open()
    end
end

MotoLegends:GetAttributeChangedSignal("LegendPickId"):Connect(check)
MotoLegends:GetAttributeChangedSignal("LegendPickEnd"):Connect(check)
MotoLegends:GetAttributeChangedSignal("SessionPhase"):Connect(function() -- line: 252
    -- upvalues: MotoLegends (copy), ScreenGui (copy), v12 (ref), t11 (copy), t14 (copy), lockIn (copy)
    if not t14.open or MotoLegends:GetAttribute("SessionPhase") == "Grid" then
        return
    elseif not t14.locked then
        lockIn()
    end

    if t14.open then
        t14.serial += 1
        t14.open = false
        v12 = false
        ScreenGui.Enabled = false

        for _, v132 in t11 do
            v132.holder:Destroy()
        end

        table.clear(t11)
    end
end)
MotoLegends:GetAttributeChangedSignal("RDLegendsDisabled"):Connect(function() -- line: 256
    -- upvalues: MotoLegends (copy), ScreenGui (copy), v12 (ref), t11 (copy), t14 (copy)
    if MotoLegends:GetAttribute("RDLegendsDisabled") ~= true or not t14.open then
        return
    end

    if t14.open then
        t14.serial += 1
        t14.open = false
        v12 = false
        ScreenGui.Enabled = false

        for _, v133 in t11 do
            v133.holder:Destroy()
        end

        table.clear(t11)
    end
end)
LocalPlayer:GetAttributeChangedSignal("LegendsState"):Connect(function() -- line: 260
    -- upvalues: HttpService (copy), LocalPlayer (copy), LegendsCatalog (copy), t11 (copy), t14 (copy), paint (copy)
    local Clean, v134

    if not t14.open or t14.locked then
        return
    else
        local JSONDecode = HttpService.JSONDecode
        local v136 = LocalPlayer:GetAttribute("LegendsState") or "{}"
        local ok, result = pcall(JSONDecode, HttpService, v136)

        Clean = LegendsCatalog.Clean
        v134 = ok and result or nil
    end

    local v137 = Clean(v134)

    for _, v138 in t11 do
        if v138.slot == v137.selected and t14.picked ~= v138.slot then
            t14.picked = v138.slot
            paint()
        end
    end
end)
task.defer(check)
PlayerGui:SetAttribute("GridLegendBottom", 0)

local elapsed = os.clock()

RunService.RenderStepped:Connect(function() -- line: 271
    -- upvalues: MotoLegends (copy), LegendRig (copy), UIGradient (copy), Frame3 (copy), t11 (copy), t14 (copy), lockIn (copy), elapsed (copy)
    if t14.open then
        local v139 = os.clock() - elapsed
        local v141 = math.clamp(os.clock() % 3 / 1.8, 0, 1)
        local v142 = v141 * v141 * (3 - v141 * 2)

        for _, v143 in t11 do
            if v143.rig then
                LegendRig.Apply(v143.rig.model, v143.rig.id, CFrame.identity, v139)
                LegendRig.Apply(v143.rig.outline, v143.rig.id, CFrame.identity, v139)
            end

            v143.shine.Offset = Vector2.new(v142 * 2.4 + -1.2, 0)
        end

        UIGradient.Offset = Vector2.new(v142 * 1.4 + -0.7, 0)

        if t14.locked then
            return
        end

        local v144 = (MotoLegends:GetAttribute("LegendPickEnd") or 0) - workspace:GetServerTimeNow()

        Frame3.Size = UDim2.fromScale(math.clamp(v144 / (MotoLegends:GetAttribute("LegendPickSeconds") or 10), 0, 1), 1)

        if v144 <= 0 then
            lockIn()
        end
    end
end)
