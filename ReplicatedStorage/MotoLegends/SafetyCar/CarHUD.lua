-- https://lua.expert

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(script.Parent:WaitForChild("Config"))
local t1 = {}
local v1 = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Bold)
local v2 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
local v3 = Color3.fromRGB(255, 255, 255)
local v4 = Color3.fromRGB(195, 255, 0)
local v5 = Color3.fromRGB(255, 65, 34)
local v6 = Color3.fromRGB(255, 170, 30)
local v7 = Color3.fromRGB(120, 124, 130)

local function make(p1, p2, p3) -- line: 19
    local v8 = Instance.new(p1)

    for v9, v10 in p2 do
        v8[v9] = v10
    end

    v8.Parent = p3

    return v8
end

local function text(p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14) -- line: 25
    -- upvalues: v1 (copy), v3 (copy)
    local t2 = {
        BackgroundTransparency = 1,
        Name = p5,
        Text = p6,
        Position = UDim2.fromOffset(p7, p8),
        Size = UDim2.fromOffset(p9, p10),
        FontFace = p12 or v1,
        TextSize = p11,
        TextColor3 = p13 or v3,
        TextXAlignment = p14 or Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center
    }
    local TextLabel = Instance.new("TextLabel")

    for v11, v12 in t2 do
        TextLabel[v11] = v12
    end

    TextLabel.Parent = p4

    return TextLabel
end

local function corner(p15, p16) -- line: 30
    local t3 = {
        CornerRadius = UDim.new(0, p16)
    }
    local UICorner = Instance.new("UICorner")

    for v13, v14 in t3 do
        UICorner[v13] = v14
    end

    UICorner.Parent = p15
end

local t4 = {
    Driver = {
        "W / S  gas / brake (hold S when stopped = reverse)",
        "A / D  steer",
        "Q / E  gear down / up",
        "M  automatic / manual",
        "Shift  handbrake",
        "C  camera   X  look back",
        "R  roof lights   L  headlights",
        "H  horn   U  ESC + TCS on / off",
        "Space  get out"
    },
    Passenger = { "C  camera   X  look back", "Right mouse  look around", "Space  get out" }
}
local t5 = {
    Driver = {
        "RT / LT  gas / brake (hold LT when stopped = reverse)",
        "Left stick  steer",
        "X / Y  gear down / up",
        "A  handbrake",
        "RB  camera   R3  look back",
        "B  roof lights   LB  horn",
        "D-pad left  ESC + TCS   D-pad right  auto / manual",
        "D-pad up  headlights",
        "L3  get out"
    },
    Passenger = { "RB  camera   R3  look back", "Right stick  look around", "L3  get out" }
}

function t1.New(p17) -- line: 43
    -- upvalues: ReplicatedStorage (copy), Config (copy), t1 (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v7 (copy), text (copy)
    local t6 = {
        role = nil,
        touch = {
            gas = 0,
            brake = 0,
            left = false,
            right = false,
            handbrake = false
        },
        playerGui = p17
    }
    local v15 = {
        Name = "SafetyCarHUD",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 7,
        Enabled = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }
    local ScreenGui = Instance.new("ScreenGui")

    for v16, v17 in v15 do
        ScreenGui[v16] = v17
    end

    ScreenGui.Parent = p17
    t6.gui = ScreenGui

    local t7 = {
        Name = "Gauge",
        BackgroundTransparency = 0.35,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -24, 1, -20),
        Size = UDim2.fromOffset(520, 178),
        BackgroundColor3 = Color3.fromRGB(8, 10, 14)
    }
    local Frame = Instance.new("Frame")

    for v18, v19 in t7 do
        Frame[v18] = v19
    end

    Frame.Parent = ScreenGui
    t7 = {
        CornerRadius = UDim.new(0, 14)
    }

    local UICorner = Instance.new("UICorner")

    for v20, v21 in t7 do
        UICorner[v20] = v21
    end

    UICorner.Parent = Frame
    t7 = {
        Transparency = 0.85,
        Thickness = 1,
        Color = Color3.fromRGB(255, 255, 255)
    }
    UICorner = Instance.new("UIStroke")

    for v22, v23 in t7 do
        UICorner[v22] = v23
    end

    UICorner.Parent = Frame

    local t8 = {}
    local Frame2 = Instance.new("UIScale")

    for v24, v25 in t8 do
        Frame2[v24] = v25
    end

    Frame2.Parent = Frame
    t6.scale = Frame2
    t6.gauge = Frame
    t8 = {
        Name = "RevBar",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(20, 12),
        Size = UDim2.fromOffset(480, 14)
    }
    Frame2 = Instance.new("Frame")

    for v26, v27 in t8 do
        Frame2[v26] = v27
    end

    Frame2.Parent = Frame
    t6.segments = {}

    local Frame3

    for i = 1, 30 do
        local t9 = {
            BackgroundTransparency = 0.6,
            BorderSizePixel = 0,
            Name = "S" .. i,
            Position = UDim2.fromOffset((i - 1) * 16, 0),
            Size = UDim2.fromOffset(14, 14),
            BackgroundColor3 = v7
        }

        Frame3 = Instance.new("Frame")

        for v28, v29 in t9 do
            Frame3[v28] = v29
        end

        Frame3.Parent = Frame2
        t9 = {
            CornerRadius = UDim.new(0, 3)
        }

        local UICorner = Instance.new("UICorner")

        for v30, v31 in t9 do
            UICorner[v30] = v31
        end

        UICorner.Parent = Frame3
        t6.segments[i] = Frame3
    end

    t8 = {
        Name = "GearBox",
        BackgroundTransparency = 0.92,
        Position = UDim2.fromOffset(20, 36),
        Size = UDim2.fromOffset(112, 104),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    }
    Frame2 = Instance.new("Frame")

    for v32, v33 in t8 do
        Frame2[v32] = v33
    end

    Frame2.Parent = Frame
    t8 = {
        CornerRadius = UDim.new(0, 10)
    }

    local UICorner2 = Instance.new("UICorner")

    for v34, v35 in t8 do
        UICorner2[v34] = v35
    end

    UICorner2.Parent = Frame2
    t6.gear = text(Frame2, "Gear", "1", 0, 2, 112, 78, 70)
    t6.mode = text(Frame2, "Mode", "AUTO", 0, 78, 112, 22, 13, v2, v7)
    t6.speed = text(Frame, "Speed", "0", 140, 34, 250, 90, 74, v1, v3, Enum.TextXAlignment.Right)
    t6.unit = text(Frame, "Unit", "KM/H", 396, 88, 110, 30, 18, v1, v3, Enum.TextXAlignment.Left)
    t6.rpmText = text(Frame, "RPM", "750 RPM", 396, 48, 110, 24, 13, v2, v7, Enum.TextXAlignment.Left)
    t8 = {
        Name = "InputBar",
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(150, 132),
        Size = UDim2.fromOffset(350, 10),
        BackgroundColor3 = Color3.new(0, 0, 0)
    }
    Frame2 = Instance.new("Frame")

    for v36, v37 in t8 do
        Frame2[v36] = v37
    end

    Frame2.Parent = Frame
    t8 = {
        CornerRadius = UDim.new(0, 5)
    }
    UICorner2 = Instance.new("UICorner")

    for v38, v39 in t8 do
        UICorner2[v38] = v39
    end

    UICorner2.Parent = Frame2
    UICorner2 = {
        Name = "Brake",
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(0.5, 0),
        Size = UDim2.fromScale(0, 1),
        BackgroundColor3 = v5
    }

    local Frame4 = Instance.new("Frame")

    for v40, v41 in UICorner2 do
        Frame4[v40] = v41
    end

    Frame4.Parent = Frame2
    t6.brakeFill = Frame4
    UICorner2 = {
        Name = "Throttle",
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.5, 0),
        Size = UDim2.fromScale(0, 1),
        BackgroundColor3 = v4
    }
    Frame4 = Instance.new("Frame")

    for v42, v43 in UICorner2 do
        Frame4[v42] = v43
    end

    Frame4.Parent = Frame2
    t6.throttleFill = Frame4
    t6.chips = {}

    for v44, v45 in { "ESC", "TCS", "ABS", "LIGHTS", "HB" } do
        t6.chips[v45] = text(Frame, "Chip" .. v45, v45, 20 + (v44 - 1) * 96, 150, 90, 22, 13, v2, v7)
    end

    local v46 = Config.PitLimitKph or 60

    t6.pitChip = text(Frame, "PitLimiter", "PIT LIMITER  " .. tostring(v46) .. " KM/H", 0, 0, 230, 30, 15, v2, Color3.fromRGB(20, 20, 20))
    t6.pitChip.AnchorPoint = Vector2.new(0.5, 1)
    t6.pitChip.Position = UDim2.new(0.5, 0, 0, -8)
    t6.pitChip.TextXAlignment = Enum.TextXAlignment.Center
    t6.pitChip.BackgroundColor3 = Color3.fromRGB(255, 200, 40)
    t6.pitChip.BackgroundTransparency = 0
    t6.pitChip.Visible = false
    Frame = t6.pitChip
    Frame2 = {
        CornerRadius = UDim.new(0, 6)
    }
    Frame4 = Instance.new("UICorner")

    for v47, v48 in Frame2 do
        Frame4[v47] = v48
    end

    Frame4.Parent = Frame
    Frame = {
        Name = "SafetyCarNotice",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 8
    }
    Frame2 = Instance.new("ScreenGui")

    for v49, v50 in Frame do
        Frame2[v49] = v50
    end

    Frame2.Parent = p17
    t6.toast = text(Frame2, "Toast", "", 0, 0, 640, 36, 20, v2, v3)
    t6.toast.AnchorPoint = Vector2.new(0.5, 0)
    t6.toast.Position = UDim2.new(0.5, 0, 0, 70)
    t6.toast.TextStrokeTransparency = 1
    t6.toast.TextTransparency = 1
    t6.toastUntil = 0

    Frame2 = function() -- line: 103
        -- upvalues: t6 (copy), ScreenGui (copy), ReplicatedStorage (copy)
        local MotoLegends = ReplicatedStorage:FindFirstChild("MotoLegends")
        local Config = require(MotoLegends:FindFirstChild("Config"))
        local Layout = require(MotoLegends.Tracks[Config.Track].Layout)

        t6.minimap = require(MotoLegends:FindFirstChild("RaceMinimap")).New(ScreenGui, Layout, Config)
        t6.layout = Layout

        local SettingsBridge = MotoLegends:FindFirstChild("SettingsBridge")

        t6.settings = SettingsBridge and require(SettingsBridge) or nil
    end

    pcall(Frame2)

    local v52

    if t6.minimap then
        v15 = t6.layout

        local MapForward = v15.MapForward

        local function flat(p18) -- line: 116
            -- upvalues: MapForward (copy)
            return Vector2.new(-p18.X * MapForward.X + p18.Z * MapForward.Y, -p18.X * MapForward.Y - p18.Z * MapForward.X)
        end

        Frame4 = Vector2.new(1e999, 1e999)
        v52 = Vector2.new((-1e999), (-1e999))

        for _, v53 in v15.Points do
            local v54 = Vector2.new(-v53.X * MapForward.X + v53.Z * MapForward.Y, -v53.X * MapForward.Y - v53.Z * MapForward.X)

            Frame4 = Vector2.new(math.min(Frame4.X, v54.X), (math.min(Frame4.Y, v54.Y)))
            v52 = Vector2.new(math.max(v52.X, v54.X), (math.max(v52.Y, v54.Y)))
        end

        Frame3 = 122 / (v52.X - Frame4.X)
        v46 = 134 / (v52.Y - Frame4.Y)

        local v56 = math.min(Frame3, v46)
        local v57 = Vector2.new(73, 79) - (Frame4 + v52) * 0.5 * v56

        t6.project = function(p19) -- line: 125
            -- upvalues: MapForward (copy), v56 (copy), v57 (copy)
            return Vector2.new(-p19.X * MapForward.X + p19.Z * MapForward.Y, -p19.X * MapForward.Y - p19.Z * MapForward.X) * v56 + v57
        end

        t6.carDots = {}
        v46 = {
            Name = "SafetyCarCorner",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            TextStrokeTransparency = 0.55,
            TextSize = 14,
            RichText = true,
            AutoLocalize = false,
            Text = "",
            Visible = false,
            AnchorPoint = Vector2.new(0.5, 1),
            Size = UDim2.fromOffset(200, 20),
            TextStrokeColor3 = Color3.new(0, 0, 0),
            Font = Enum.Font.GothamBlack,
            TextColor3 = Color3.fromRGB(242, 244, 244)
        }

        local cornerLabel = Instance.new("TextLabel")

        for v58, v59 in v46 do
            cornerLabel[v58] = v59
        end

        cornerLabel.Parent = ScreenGui
        t6.cornerLabel = cornerLabel

        local t10 = {}

        cornerLabel = t6.cornerLabel

        local UIScale = Instance.new("UIScale")

        for v60, v61 in t10 do
            UIScale[v60] = v61
        end

        UIScale.Parent = cornerLabel
        t6.cornerScale = UIScale
        t6.cornerClock = 0
    end

    Frame2 = {
        Name = "Help",
        BackgroundTransparency = 0.35,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -16, 0, 80),
        Size = UDim2.fromOffset(360, 250),
        BackgroundColor3 = Color3.fromRGB(8, 10, 14)
    }
    Frame4 = Instance.new("Frame")

    for v62, v63 in Frame2 do
        Frame4[v62] = v63
    end

    Frame4.Parent = ScreenGui
    Frame2 = {
        CornerRadius = UDim.new(0, 10)
    }

    local UICorner3 = Instance.new("UICorner")

    for v64, v65 in Frame2 do
        UICorner3[v64] = v65
    end

    UICorner3.Parent = Frame4

    local UICorner4 = {}

    v52 = Instance.new("UIScale")

    for v66, v67 in UICorner4 do
        v52[v66] = v67
    end

    v52.Parent = Frame4
    t6.helpScale = v52
    Frame2 = {
        PaddingLeft = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    }
    UICorner4 = Instance.new("UIPadding")

    for v68, v69 in Frame2 do
        UICorner4[v68] = v69
    end

    UICorner4.Parent = Frame4
    Frame2 = {
        Padding = UDim.new(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder
    }
    UICorner4 = Instance.new("UIListLayout")

    for v70, v71 in Frame2 do
        UICorner4[v70] = v71
    end

    UICorner4.Parent = Frame4
    t6.help = Frame4
    t6.helpUntil = 0
    Frame2 = {
        Name = "Touch",
        BackgroundTransparency = 1,
        Visible = false,
        Size = UDim2.fromScale(1, 1)
    }

    local Frame5 = Instance.new("Frame")

    for v72, v73 in Frame2 do
        Frame5[v72] = v73
    end

    Frame5.Parent = ScreenGui
    t6.touchRoot = Frame5

    local function button(p20, p21, p22, p23, p24, p25, p26) -- line: 148
        -- upvalues: t6 (copy), Frame5 (copy), v2 (copy), v3 (copy)
        local t11 = {
            AutoButtonColor = false,
            BackgroundTransparency = 0.3,
            TextSize = 20,
            Name = p20,
            Text = p21,
            AnchorPoint = p22,
            Position = p23,
            Size = p24,
            BackgroundColor3 = p25 or Color3.fromRGB(20, 22, 28),
            TextColor3 = v3,
            FontFace = v2
        }
        local TextButton = Instance.new("TextButton")

        for v74, v75 in t11 do
            TextButton[v74] = v75
        end

        TextButton.Parent = Frame5

        local t12 = {
            CornerRadius = UDim.new(0, 16)
        }
        local UICorner = Instance.new("UICorner")

        for v76, v77 in t12 do
            UICorner[v76] = v77
        end

        UICorner.Parent = TextButton

        local t13 = {
            Transparency = 0.7,
            Thickness = 2,
            Color = v3,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        }
        local UIStroke = Instance.new("UIStroke")

        for v78, v79 in t13 do
            UIStroke[v78] = v79
        end

        UIStroke.Parent = TextButton

        local t14 = {}

        TextButton.InputBegan:Connect(function(p27) -- line: 154
            -- upvalues: p20 (copy), p26 (copy), TextButton (copy), t14 (copy), t6 (copy)
            if p27.UserInputType ~= Enum.UserInputType.Touch and p27.UserInputType ~= Enum.UserInputType.MouseButton1 then
                return
            end

            t14[p27] = true
            TextButton.BackgroundTransparency = 0.05

            if p26 then
                p26(true)
            elseif t6.OnButton then
                t6.OnButton(p20)
            end
        end)
        TextButton.InputEnded:Connect(function(p28) -- line: 160
            -- upvalues: p26 (copy), TextButton (copy), t14 (copy)
            if t14[p28] then
                t14[p28] = nil

                if next(t14) == nil then
                    TextButton.BackgroundTransparency = 0.3

                    if p26 then
                        p26(false)
                    end
                end
            end
        end)

        return TextButton
    end

    local touch = t6.touch

    button("SteerLeft", "◀", Vector2.new(0, 1), UDim2.new(0, 24, 1, -40), UDim2.fromOffset(120, 120), nil, function(p29) -- line: 171
        -- upvalues: touch (copy)
        touch.left = p29
    end)
    button("SteerRight", "▶", Vector2.new(0, 1), UDim2.new(0, 160, 1, -40), UDim2.fromOffset(120, 120), nil, function(p30) -- line: 172
        -- upvalues: touch (copy)
        touch.right = p30
    end)
    button("Gas", "GAS", Vector2.new(1, 1), UDim2.new(1, -24, 1, -40), UDim2.fromOffset(110, 170), Color3.fromRGB(40, 70, 20), function(p31) -- line: 173
        -- upvalues: touch (copy)
        touch.gas = p31 and 1 or 0
    end)
    button("Brake", "BRAKE", Vector2.new(1, 1), UDim2.new(1, -150, 1, -40), UDim2.fromOffset(110, 120), Color3.fromRGB(90, 25, 20), function(p32) -- line: 174
        -- upvalues: touch (copy)
        touch.brake = p32 and 1 or 0
    end)
    button("Handbrake", "HB", Vector2.new(1, 1), UDim2.new(1, -150, 1, -176), UDim2.fromOffset(110, 56), nil, function(p33) -- line: 175
        -- upvalues: touch (copy)
        touch.handbrake = p33
    end)
    button("GearUp", "GEAR +", Vector2.new(1, 0), UDim2.new(1, -24, 0, 110), UDim2.fromOffset(104, 56))
    button("GearDown", "GEAR -", Vector2.new(1, 0), UDim2.new(1, -24, 0, 174), UDim2.fromOffset(104, 56))
    button("Camera", "CAM", Vector2.new(1, 0), UDim2.new(1, -136, 0, 110), UDim2.fromOffset(84, 56))
    button("LightBar", "LIGHTS", Vector2.new(1, 0), UDim2.new(1, -136, 0, 174), UDim2.fromOffset(84, 56))
    button("Horn", "HORN", Vector2.new(1, 0), UDim2.new(1, -228, 0, 174), UDim2.fromOffset(84, 56), nil, function(p34) -- line: 180
        -- upvalues: t6 (copy)
        if t6.OnHorn then
            t6.OnHorn(p34)
        end
    end)
    button("Exit", "EXIT", Vector2.new(1, 0), UDim2.new(1, -228, 0, 110), UDim2.fromOffset(84, 56), Color3.fromRGB(90, 25, 20))
    t6.driverOnly = {
        "SteerLeft",
        "SteerRight",
        "Gas",
        "Brake",
        "Handbrake",
        "GearUp",
        "GearDown",
        "LightBar",
        "Horn"
    }

    return (setmetatable(t6, {
        __index = t1
    }))
end

function t1.SetHelp(p35, p36) -- line: 186
    -- upvalues: UserInputService (copy), v1 (copy), v2 (copy), v3 (copy), v6 (copy), t4 (copy), t5 (copy)
    for _, child in p35.help:GetChildren() do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    local v80 = UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled
    local v81 = if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.GamepadEnabled then p36 == "Driver" and {
        "GAS / BRAKE pedals (hold BRAKE when stopped = reverse)",
        "◀ ▶ steer, HB handbrake",
        "GEAR + / - , CAM, LIGHTS, HORN, EXIT"
    } or { "CAM camera, EXIT get out" } else (v80 and t5 or t4)[p36]
    local t15 = {
        Name = "Title",
        LayoutOrder = 0,
        BackgroundTransparency = 1,
        TextSize = 15,
        Text = p36 == "Driver" and "SAFETY CAR - DRIVER" or "SAFETY CAR - PASSENGER",
        Size = UDim2.new(1, 0, 0, 24),
        FontFace = v1,
        TextColor3 = v6,
        TextXAlignment = Enum.TextXAlignment.Left
    }
    local help = p35.help
    local TextLabel = Instance.new("TextLabel")

    for v83, v84 in t15 do
        TextLabel[v83] = v84
    end

    TextLabel.Parent = help
    TextLabel.TextTransparency = 0

    for v85, v86 in v81 do
        local t16 = {
            BackgroundTransparency = 1,
            TextSize = 14,
            TextWrapped = true,
            Name = "Line" .. v85,
            LayoutOrder = v85,
            Text = v86,
            Size = UDim2.new(1, 0, 0, 20),
            FontFace = v2,
            TextColor3 = v3,
            TextXAlignment = Enum.TextXAlignment.Left
        }
        local help = p35.help
        local TextLabel = Instance.new("TextLabel")

        for v87, v88 in t16 do
            TextLabel[v87] = v88
        end

        TextLabel.Parent = help
    end

    p35.help.Size = UDim2.fromOffset(380, #v81 * 23 + 24 + 26)
end

local t17 = {
    RaceMinimap = "RaceMinimap_Bike",
    CornerLabel = "CornerLabel_Bike"
}

function t1.DockMap(p37, p38) -- line: 212
    -- upvalues: t17 (copy)
    local minimap = p37.minimap

    if not minimap then
        return
    end

    local Root = minimap.Root
    local cornerLabel = p37.cornerLabel

    if p38 then
        local JerezRaceHUD = p37.playerGui:FindFirstChild("JerezRaceHUD")

        if JerezRaceHUD and p37.docked ~= JerezRaceHUD then
            for _, child in JerezRaceHUD:GetChildren() do
                local v89 = t17[child.Name]

                if v89 and child ~= Root and child ~= cornerLabel then
                    child.Name = v89
                end
            end

            Root.Parent = JerezRaceHUD
            cornerLabel.Name = "CornerLabel"
            cornerLabel.Parent = JerezRaceHUD
            p37.docked = JerezRaceHUD
        end
    elseif p37.docked then
        local docked = p37.docked

        Root.Parent = p37.gui
        cornerLabel.Name = "SafetyCarCorner"
        cornerLabel.Parent = p37.gui

        for v90, v91 in t17 do
            for _, child in docked:GetChildren() do
                if child.Name == v91 then
                    child.Name = v90
                end
            end
        end

        p37.docked = nil
    end
end

function t1.Show(p39, p40, p41) -- line: 241
    -- upvalues: UserInputService (copy)
    p39.role = p40
    p39.car = p41
    p39.gui.Enabled = true
    p39:DockMap(true)
    p39:SetHelp(p40)
    p39.helpUntil = os.clock() + 14

    local v92 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

    p39.touchRoot.Visible = v92

    for _, v93 in p39.driverOnly do
        local v94 = p39.touchRoot:FindFirstChild(v93)

        if v94 then
            v94.Visible = p40 == "Driver"
        end
    end

    p39.gui.Gauge.Visible = true

    if v92 then
        p39.gauge.AnchorPoint = Vector2.new(0.5, 1)
        p39.help.AnchorPoint = Vector2.new(0, 0)
        p39.help.Position = UDim2.new(0, 16, 0.42, 0)
    else
        p39.gauge.AnchorPoint = Vector2.new(1, 1)
        p39.help.AnchorPoint = Vector2.new(1, 0)
        p39.help.Position = UDim2.new(1, -16, 0, 80)
    end

    p39.viewSize = nil
end

function t1.Hide(p42) -- line: 267
    p42.role = nil
    p42.car = nil
    p42:DockMap(false)
    p42.gui.Enabled = false

    local touch = p42.touch

    touch.gas = 0
    touch.brake = 0
    touch.left = false
    touch.right = false
    touch.handbrake = false
end

function t1.Toast(p43, p44, p45) -- line: 276
    p43.toast.Text = p44
    p43.toastUntil = os.clock() + (p45 or 1.4)
end

function t1.UpdateToast(p46) -- line: 282
    local v96 = math.clamp((p46.toastUntil - os.clock()) / 0.3, 0, 1)

    p46.toast.TextTransparency = 1 - v96
    p46.toast.TextStrokeTransparency = 1 - v96 * 0.6
end

local function shade(p47, p48, p49) -- line: 288
    -- upvalues: v7 (copy)
    if not p48 or not p49 then
        p47.TextColor3 = v7
    else
        p47.TextColor3 = p49
    end

    p47.TextTransparency = p48 and 0 or 0.35
end

local function cornerAt(p50, p51) -- line: 294
    local Points = p50.Points
    local v97 = #Points
    local n1 = 1
    local n2 = 1e999

    for i = 1, v97, 3 do
        local Magnitude = (Points[i] - p51).Magnitude

        if Magnitude < n2 then
            n2 = Magnitude
            n1 = i
        end
    end

    for i = n1 - 3, n1 + 3 do
        local v98 = (i - 1) % v97 + 1
        local Magnitude = (Points[v98] - p51).Magnitude

        if Magnitude < n2 then
            n2 = Magnitude
            n1 = v98
        end
    end

    if n2 > 140 then
        return nil
    end

    local n3 = 1e999
    local v99

    for _, v100 in p50.Corners or {} do
        local v101 = (n1 - v100.index + v97 / 2) % v97 - v97 / 2

        if v101 >= -24 and v101 <= 16 then
            local v102 = math.abs(v101) * (if v101 > 0 then 1.4 else 1)

            if v102 < n3 then
                n3 = v102
                v99 = v100
            end
        end
    end

    return v99
end

function t1.UpdateMap(p52, p53, _) -- line: 319
    -- upvalues: v6 (copy), cornerAt (copy)
    local minimap = p52.minimap

    if not minimap then
        return
    end

    if not p52.docked then
        p52:DockMap(true)
    end

    local settings = p52.settings
    local v103 = true

    if settings and settings.ready and settings.get then
        local get = settings.get
        local minimap, minimap2 = pcall(get, "minimap")

        v103 = not minimap or minimap2 ~= false
    end

    minimap.Update(p53, v103)

    local Root = minimap.Root
    local Visible = Root.Visible
    local t18 = {}
    local SafetyCars = workspace:FindFirstChild("SafetyCars")

    if Visible and SafetyCars then
        for _, child in SafetyCars:GetChildren() do
            local v104 = child:IsA("Model") and child.PrimaryPart

            if v104 then
                local v105 = p52.project(v104.Position)

                if v105.X > -8 and v105.X < 154 and v105.Y > -8 and v105.Y < 166 then
                    local v106 = p52.carDots[child]
                    local v107 = child == p52.car

                    if not v106 then
                        local t19 = {
                            Name = "SafetyCar",
                            BorderSizePixel = 0,
                            AnchorPoint = Vector2.new(0.5, 0.5)
                        }

                        v106 = Instance.new("Frame")

                        for v108, v109 in t19 do
                            v106[v108] = v109
                        end

                        v106.Parent = Root

                        local t20 = {
                            CornerRadius = UDim.new(1, 0)
                        }
                        local UICorner = Instance.new("UICorner")

                        for v110, v111 in t20 do
                            UICorner[v110] = v111
                        end

                        UICorner.Parent = v106

                        local t21 = {
                            Thickness = 1,
                            Transparency = 0.35,
                            Color = Color3.fromRGB(15, 22, 26)
                        }
                        local UIStroke = Instance.new("UIStroke")

                        for v112, v113 in t21 do
                            UIStroke[v112] = v113
                        end

                        UIStroke.Parent = v106
                        p52.carDots[child] = v106
                    end

                    v106.Size = UDim2.fromOffset(v107 and 9 or 7, v107 and 9 or 7)
                    v106.BackgroundColor3 = v107 and Color3.fromRGB(242, 37, 48) or v6
                    v106.ZIndex = v107 and 6 or 5
                    v106.Position = UDim2.fromOffset(math.clamp(v105.X, 4, 142), (math.clamp(v105.Y, 4, 154)))
                    v106.Visible = true
                    t18[child] = true
                end
            end
        end
    end

    for v115, v116 in p52.carDots do
        if not t18[v115] then
            if v115.Parent then
                v116.Visible = false
            else
                v116:Destroy()
                p52.carDots[v115] = nil
            end
        end
    end

    local cornerLabel = p52.cornerLabel

    p52.cornerClock += p53

    if not Visible or not p52.car or not p52.car.PrimaryPart then
        cornerLabel.Visible = false
        p52.cornerIndex = nil

        return
    end

    if p52.cornerClock > 0.15 then
        p52.cornerClock = 0

        local v117 = cornerAt(p52.layout, p52.car.PrimaryPart.Position)

        if v117 then
            if p52.cornerIndex ~= v117.number then
                p52.cornerIndex = v117.number

                local number, v118

                if not v117.name or v117.name == "Turn " .. v117.number then
                    number = v117.number
                    v118 = ""
                else
                    local name = v117.name

                    number = v117.number
                    v118 = name and "  <font size=\"11\" color=\"#C3CDD1\" weight=\"500\">" .. name:upper() .. "</font>" or ""
                end

                cornerLabel.Text = "TURN " .. number .. v118
            end

            cornerLabel.Visible = true
        else
            p52.cornerIndex = nil
            cornerLabel.Visible = false
        end
    end
end

function t1.Update(p55, p56, p57) -- line: 388
    -- upvalues: Config (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy)
    if p55.gui.Enabled then
        local ViewportSize = workspace.CurrentCamera.ViewportSize
        local elapsed = os.clock()

        if ViewportSize ~= p55.viewSize then
            p55.viewSize = ViewportSize

            local v122 = math.clamp(math.min(ViewportSize.X / 1500, ViewportSize.Y / 850), 0.5, 1)
            local Visible = p55.touchRoot.Visible

            if Visible then
                v122 *= 0.8
            end

            p55.scale.Scale = v122
            p55.helpScale.Scale = math.max(v122, 0.6)

            local v125 = math.min(ViewportSize.X / 737, ViewportSize.Y / 412)

            if Visible then
                p55.gauge.Position = UDim2.new(0.5, 0, 1, -10)
            else
                p55.gauge.Position = UDim2.new(1, -math.floor(v125 * 18), 1, -math.floor(v125 * 16))
            end

            if p55.minimap then
                p55.minimap.Resize(ViewportSize, v125)

                local v130 = math.min(v125 * 0.8, 1.5)

                p55.cornerScale.Scale = v130
                p55.cornerLabel.Position = UDim2.fromOffset(v125 * 18 + v130 * 73, ViewportSize.Y - v125 * 16 - v130 * 161)
            end
        end

        p55:UpdateMap(p56, ViewportSize)

        local v131 = p57.gear or 1
        local gear = p55.gear

        if v131 == -1 then
            gear.Text = "R"
        elseif v131 == 0 then
            gear.Text = "N"
        else
            gear.Text = tostring(v131)
        end

        p55.gear.TextColor3 = v131 == -1 and v5 or v3
        p55.mode.Text = p57.transmission == "Manual" and "MANUAL" or "AUTO"
        p55.speed.Text = tostring((math.clamp(math.floor((p57.kph or 0) + 0.5), 0, 999)))

        local v135 = p57.rpm or Config.IdleRPM

        p55.rpmText.Text = string.format("%d RPM", math.floor(v135 / 50 + 0.5) * 50)

        local v139 = math.floor(math.clamp(v135 / Config.RedlineRPM, 0, 1) * 30 + 0.5)
        local v140 = Config.UpshiftRPM - 150 <= v135 and os.clock() * 12 % 2 < 1

        for v141, v142 in p55.segments do
            local v143 = v141 <= v139
            local v144 = v141 / 30
            local v145

            if v144 > 0.86 then
                v145 = v5

                if not v5 then
                    v145 = v144 > 0.6 and v4 or v3
                end
            else
                v145 = v144 > 0.6 and v4 or v3
            end

            if v140 then
                v143 = true
                v145 = v5
            end

            v142.BackgroundColor3 = if not (v143 and v145) then v7 else v145
            v142.BackgroundTransparency = v143 and 0 or 0.65
        end

        p55.throttleFill.Size = UDim2.fromScale(math.clamp(p57.throttle or 0, 0, 1) * 0.5, 1)
        p55.brakeFill.Size = UDim2.fromScale(math.clamp(math.max(p57.brake or 0, if p57.handbrake then 0.6 else 0), 0, 1) * 0.5, 1)

        local chips = p55.chips

        chips.ESC.Text = p57.esc == false and "ESC OFF" or "ESC"

        local ESC = chips.ESC
        local v150 = p57.esc == false or p57.escActive
        local v151 = p57.esc == false and v5 or v6

        ESC.TextColor3 = if not v150 or not v151 then v7 else v151
        ESC.TextTransparency = v150 and 0 or 0.35
        chips.TCS.Text = p57.esc == false and "TCS OFF" or "TCS"

        local TCS = chips.TCS
        local v152 = p57.esc == false or p57.tcsActive
        local v153 = p57.esc == false and v5 or v6

        TCS.TextColor3 = if not v152 or not v153 then v7 else v153
        TCS.TextTransparency = v152 and 0 or 0.35

        local ABS = chips.ABS
        local absActive = p57.absActive

        ABS.TextColor3 = if not absActive or not v6 then v7 else v6
        ABS.TextTransparency = absActive and 0 or 0.35

        local LIGHTS = chips.LIGHTS
        local lights = p57.lights

        LIGHTS.TextColor3 = if not lights or not v6 then v7 else v6
        LIGHTS.TextTransparency = lights and 0 or 0.35

        local HB = chips.HB
        local handbrake = p57.handbrake

        HB.TextColor3 = if not handbrake or not v5 then v7 else v5
        HB.TextTransparency = handbrake and 0 or 0.35
        p55.pitChip.Visible = p57.pitLimiter == true

        local v158 = math.clamp((p55.helpUntil - elapsed) / 0.6, 0, 1)

        p55.help.Visible = v158 > 0
        p55.help.BackgroundTransparency = 1 - v158 * 0.65

        for _, child in p55.help:GetChildren() do
            if child:IsA("TextLabel") then
                child.TextTransparency = 1 - v158
            end
        end
    end
end

return t1
