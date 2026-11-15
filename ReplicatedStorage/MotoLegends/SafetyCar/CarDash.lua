-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(script.Parent:WaitForChild("Config"))
local t1 = {}
local v1 = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Bold)
local v2 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
local v3 = Color3.fromRGB(240, 244, 248)
local v4 = Color3.fromRGB(120, 128, 140)
local v5 = Color3.fromRGB(34, 38, 46)
local v6 = Color3.fromRGB(0, 154, 218)
local v7 = Color3.fromRGB(255, 170, 30)
local v8 = Color3.fromRGB(235, 40, 45)
local v9 = Color3.fromRGB(70, 220, 100)
local v10 = Color3.fromRGB(6, 8, 12)

local function make(p1, p2, p3) -- line: 23
    local v11 = Instance.new(p1)

    for v12, v13 in p2 do
        v11[v12] = v13
    end

    v11.Parent = p3

    return v11
end

local function label(p4, p5) -- line: 30
    -- upvalues: v2 (copy), v3 (copy)
    local t2 = {
        BackgroundTransparency = 1,
        TextScaled = true,
        Text = "",
        AutoLocalize = false,
        FontFace = v2,
        TextColor3 = v3
    }
    local TextLabel = Instance.new("TextLabel")

    for v14, v15 in t2 do
        TextLabel[v14] = v15
    end

    TextLabel.Parent = p4

    for v16, v17 in p5 do
        TextLabel[v16] = v17
    end

    return TextLabel
end

local function screen(p6) -- line: 37
    -- upvalues: v10 (copy)
    local t3 = {
        Name = "SafetyCarDash",
        PixelsPerStud = 260,
        LightInfluence = 0,
        Brightness = 1.5,
        MaxDistance = 70,
        ClipsDescendants = true,
        Face = Enum.NormalId.Front,
        SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud,
        Adornee = p6
    }
    local SurfaceGui = Instance.new("SurfaceGui")

    for v18, v19 in t3 do
        SurfaceGui[v18] = v19
    end

    SurfaceGui.Parent = p6

    local t4 = {
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = v10
    }
    local Frame = Instance.new("Frame")

    for v20, v21 in t4 do
        Frame[v20] = v21
    end

    Frame.Parent = SurfaceGui

    local t5 = {
        Rotation = 90,
        Color = ColorSequence.new(Color3.fromRGB(16, 20, 28), Color3.fromRGB(4, 5, 8))
    }
    local UIGradient = Instance.new("UIGradient")

    for v22, v23 in t5 do
        UIGradient[v22] = v23
    end

    UIGradient.Parent = Frame

    return SurfaceGui, Frame
end

local function set(p7, p8, p9) -- line: 46
    if p7[p8] ~= p9 then
        p7[p8] = p9
    end
end

local function buildCluster(p10) -- line: 51
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy), screen (copy)
    local _, v24 = screen(p10)
    local t6 = {
        lights = {}
    }

    for i = 1, 12 do
        local v25 = if i <= 6 and v9 then v9 elseif i <= 10 and v7 then v7 else v8
        local lights = t6.lights
        local t7 = {}
        local t8 = {
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale((i - 1) * 0.42 / 11 + 0.29, 0.1),
            Size = UDim2.fromScale(0.026, 0.07),
            BackgroundColor3 = v5
        }
        local Frame = Instance.new("Frame")

        for v26, v27 in t8 do
            Frame[v26] = v27
        end

        Frame.Parent = v24
        t7.frame = Frame
        t7.color = v25
        lights[i] = t7

        local t9 = {
            CornerRadius = UDim.new(1, 0)
        }
        local frame = t6.lights[i].frame
        local UICorner = Instance.new("UICorner")

        for v28, v29 in t9 do
            UICorner[v28] = v29
        end

        UICorner.Parent = frame
    end

    local t10 = {
        Position = UDim2.fromScale(0.04, 0.2),
        Size = UDim2.fromScale(0.3, 0.5),
        FontFace = v1,
        TextXAlignment = Enum.TextXAlignment.Right
    }
    local t11 = {
        BackgroundTransparency = 1,
        TextScaled = true,
        Text = "",
        AutoLocalize = false,
        FontFace = v2,
        TextColor3 = v3
    }
    local TextLabel = Instance.new("TextLabel")

    for v30, v31 in t11 do
        TextLabel[v30] = v31
    end

    TextLabel.Parent = v24

    for v32, v33 in t10 do
        TextLabel[v32] = v33
    end

    t6.speed = TextLabel

    local t12 = {
        Text = "km/h",
        Position = UDim2.fromScale(0.04, 0.7),
        Size = UDim2.fromScale(0.3, 0.14),
        TextColor3 = v4,
        TextXAlignment = Enum.TextXAlignment.Right
    }
    local t13 = {
        BackgroundTransparency = 1,
        TextScaled = true,
        Text = "",
        AutoLocalize = false,
        FontFace = v2,
        TextColor3 = v3
    }
    local TextLabel2 = Instance.new("TextLabel")

    for v34, v35 in t13 do
        TextLabel2[v34] = v35
    end

    TextLabel2.Parent = v24

    for v36, v37 in t12 do
        TextLabel2[v36] = v37
    end

    local t14 = {
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, 0.22),
        Size = UDim2.fromScale(0.15, 0.5),
        BackgroundColor3 = Color3.fromRGB(10, 14, 22)
    }
    local Frame = Instance.new("Frame")

    for v38, v39 in t14 do
        Frame[v38] = v39
    end

    Frame.Parent = v24

    local t15 = {
        CornerRadius = UDim.new(0.12, 0)
    }
    local UICorner = Instance.new("UICorner")

    for v40, v41 in t15 do
        UICorner[v40] = v41
    end

    UICorner.Parent = Frame

    local t16 = {
        Thickness = 2,
        Color = v6
    }
    local UIStroke = Instance.new("UIStroke")

    for v42, v43 in t16 do
        UIStroke[v42] = v43
    end

    UIStroke.Parent = Frame
    t6.gearStroke = UIStroke

    local t17 = {
        Size = UDim2.fromScale(1, 1),
        FontFace = v1
    }
    local t18 = {
        BackgroundTransparency = 1,
        TextScaled = true,
        Text = "",
        AutoLocalize = false,
        FontFace = v2,
        TextColor3 = v3
    }
    local TextLabel3 = Instance.new("TextLabel")

    for v44, v45 in t18 do
        TextLabel3[v44] = v45
    end

    TextLabel3.Parent = Frame

    for v46, v47 in t17 do
        TextLabel3[v46] = v47
    end

    t6.gear = TextLabel3

    local t19 = {
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.64, 0.3),
        Size = UDim2.fromScale(0.32, 0.09),
        BackgroundColor3 = v5
    }
    local Frame2 = Instance.new("Frame")

    for v48, v49 in t19 do
        Frame2[v48] = v49
    end

    Frame2.Parent = v24

    local t20 = {
        BorderSizePixel = 0,
        Size = UDim2.fromScale(0, 1),
        BackgroundColor3 = v6
    }
    local Frame3 = Instance.new("Frame")

    for v50, v51 in t20 do
        Frame3[v50] = v51
    end

    Frame3.Parent = Frame2
    t6.rpmBar = Frame3

    local t21 = {
        Position = UDim2.fromScale(0.64, 0.44),
        Size = UDim2.fromScale(0.32, 0.26),
        FontFace = v1,
        TextXAlignment = Enum.TextXAlignment.Left
    }
    local t22 = {
        BackgroundTransparency = 1,
        TextScaled = true,
        Text = "",
        AutoLocalize = false,
        FontFace = v2,
        TextColor3 = v3
    }
    local TextLabel4 = Instance.new("TextLabel")

    for v52, v53 in t22 do
        TextLabel4[v52] = v53
    end

    TextLabel4.Parent = v24

    for v54, v55 in t21 do
        TextLabel4[v54] = v55
    end

    t6.rpm = TextLabel4

    local t23 = {
        Text = "RPM",
        Position = UDim2.fromScale(0.64, 0.7),
        Size = UDim2.fromScale(0.32, 0.14),
        TextColor3 = v4,
        TextXAlignment = Enum.TextXAlignment.Left
    }
    local t24 = {
        BackgroundTransparency = 1,
        TextScaled = true,
        Text = "",
        AutoLocalize = false,
        FontFace = v2,
        TextColor3 = v3
    }
    local TextLabel5 = Instance.new("TextLabel")

    for v56, v57 in t24 do
        TextLabel5[v56] = v57
    end

    TextLabel5.Parent = v24

    for v58, v59 in t23 do
        TextLabel5[v58] = v59
    end

    local t25 = {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, 0.78),
        Size = UDim2.fromScale(0.5, 0.15),
        TextColor3 = v7
    }
    local t26 = {
        BackgroundTransparency = 1,
        TextScaled = true,
        Text = "",
        AutoLocalize = false,
        FontFace = v2,
        TextColor3 = v3
    }
    local TextLabel6 = Instance.new("TextLabel")

    for v60, v61 in t26 do
        TextLabel6[v60] = v61
    end

    TextLabel6.Parent = v24

    for v62, v63 in t25 do
        TextLabel6[v62] = v63
    end

    t6.status = TextLabel6

    return t6
end

local function buildInfo(p11) -- line: 76
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), v4 (copy), v6 (copy), screen (copy)
    local _, v64 = screen(p11)
    local t27 = {}
    local t28 = {
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 0.18),
        BackgroundColor3 = Color3.fromRGB(14, 20, 32)
    }
    local Frame = Instance.new("Frame")

    for v65, v66 in t28 do
        Frame[v65] = v66
    end

    Frame.Parent = v64

    local t29 = {
        Text = "SAFETY CAR",
        Position = UDim2.fromScale(0.03, 0.12),
        Size = UDim2.fromScale(0.5, 0.76),
        TextColor3 = v6,
        TextXAlignment = Enum.TextXAlignment.Left
    }
    local t30 = {
        BackgroundTransparency = 1,
        TextScaled = true,
        Text = "",
        AutoLocalize = false,
        FontFace = v2,
        TextColor3 = v3
    }
    local TextLabel = Instance.new("TextLabel")

    for v67, v68 in t30 do
        TextLabel[v67] = v68
    end

    TextLabel.Parent = Frame

    for v69, v70 in t29 do
        TextLabel[v69] = v70
    end

    local t31 = {
        Position = UDim2.fromScale(0.62, 0.12),
        Size = UDim2.fromScale(0.35, 0.76),
        TextXAlignment = Enum.TextXAlignment.Right
    }
    local t32 = {
        BackgroundTransparency = 1,
        TextScaled = true,
        Text = "",
        AutoLocalize = false,
        FontFace = v2,
        TextColor3 = v3
    }
    local TextLabel2 = Instance.new("TextLabel")

    for v71, v72 in t32 do
        TextLabel2[v71] = v72
    end

    TextLabel2.Parent = Frame

    for v73, v74 in t31 do
        TextLabel2[v73] = v74
    end

    t27.clock = TextLabel2

    local t33 = {
        Text = "ROOF LIGHT BAR",
        Position = UDim2.fromScale(0.05, 0.24),
        Size = UDim2.fromScale(0.9, 0.12),
        TextColor3 = v4
    }
    local t34 = {
        BackgroundTransparency = 1,
        TextScaled = true,
        Text = "",
        AutoLocalize = false,
        FontFace = v2,
        TextColor3 = v3
    }
    local TextLabel3 = Instance.new("TextLabel")

    for v75, v76 in t34 do
        TextLabel3[v75] = v76
    end

    TextLabel3.Parent = v64

    for v77, v78 in t33 do
        TextLabel3[v77] = v78
    end

    t27.barTitle = TextLabel3

    local t35 = {
        Position = UDim2.fromScale(0.05, 0.36),
        Size = UDim2.fromScale(0.9, 0.28),
        FontFace = v1
    }
    local t36 = {
        BackgroundTransparency = 1,
        TextScaled = true,
        Text = "",
        AutoLocalize = false,
        FontFace = v2,
        TextColor3 = v3
    }
    local TextLabel4 = Instance.new("TextLabel")

    for v79, v80 in t36 do
        TextLabel4[v79] = v80
    end

    TextLabel4.Parent = v64

    for v81, v82 in t35 do
        TextLabel4[v81] = v82
    end

    t27.bar = TextLabel4
    t27.tiles = {}

    for v83, v84 in { "HEADLIGHTS", "GEARBOX", "SPEED" } do
        local t37 = {
            BorderSizePixel = 0,
            Position = UDim2.fromScale(0.03 + (v83 - 1) * 0.325, 0.7),
            Size = UDim2.fromScale(0.3, 0.26),
            BackgroundColor3 = Color3.fromRGB(16, 22, 34)
        }
        local Frame = Instance.new("Frame")

        for v85, v86 in t37 do
            Frame[v85] = v86
        end

        Frame.Parent = v64

        local t38 = {
            CornerRadius = UDim.new(0.15, 0)
        }
        local UICorner = Instance.new("UICorner")

        for v87, v88 in t38 do
            UICorner[v87] = v88
        end

        UICorner.Parent = Frame

        local t39 = {
            Position = UDim2.fromScale(0.06, 0.06),
            Size = UDim2.fromScale(0.88, 0.36),
            Text = v84,
            TextColor3 = v4
        }
        local t40 = {
            BackgroundTransparency = 1,
            TextScaled = true,
            Text = "",
            AutoLocalize = false,
            FontFace = v2,
            TextColor3 = v3
        }
        local TextLabel = Instance.new("TextLabel")

        for v89, v90 in t40 do
            TextLabel[v89] = v90
        end

        TextLabel.Parent = Frame

        for v91, v92 in t39 do
            TextLabel[v91] = v92
        end

        local tiles = t27.tiles
        local t41 = {
            Position = UDim2.fromScale(0.06, 0.45),
            Size = UDim2.fromScale(0.88, 0.48)
        }
        local t42 = {
            BackgroundTransparency = 1,
            TextScaled = true,
            Text = "",
            AutoLocalize = false,
            FontFace = v2,
            TextColor3 = v3
        }
        local TextLabel2 = Instance.new("TextLabel")

        for v93, v94 in t42 do
            TextLabel2[v93] = v94
        end

        TextLabel2.Parent = Frame

        for v95, v96 in t41 do
            TextLabel2[v95] = v96
        end

        tiles[v83] = TextLabel2
    end

    return t27
end

local function buildRaceControl(p12) -- line: 96
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), v4 (copy), v7 (copy), v9 (copy), screen (copy)
    local _, v97 = screen(p12)
    local t43 = {}
    local t44 = {
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 0.2),
        BackgroundColor3 = v7
    }
    local Frame = Instance.new("Frame")

    for v98, v99 in t44 do
        Frame[v98] = v99
    end

    Frame.Parent = v97

    local t45 = {
        Text = "RACE CONTROL",
        Position = UDim2.fromScale(0.05, 0.12),
        Size = UDim2.fromScale(0.9, 0.76),
        TextColor3 = Color3.new(0, 0, 0)
    }
    local t46 = {
        BackgroundTransparency = 1,
        TextScaled = true,
        Text = "",
        AutoLocalize = false,
        FontFace = v2,
        TextColor3 = v3
    }
    local TextLabel = Instance.new("TextLabel")

    for v100, v101 in t46 do
        TextLabel[v100] = v101
    end

    TextLabel.Parent = Frame

    for v102, v103 in t45 do
        TextLabel[v102] = v103
    end

    local t47 = {
        Text = "SESSION",
        Position = UDim2.fromScale(0.06, 0.25),
        Size = UDim2.fromScale(0.4, 0.11),
        TextColor3 = v4,
        TextXAlignment = Enum.TextXAlignment.Left
    }
    local t48 = {
        BackgroundTransparency = 1,
        TextScaled = true,
        Text = "",
        AutoLocalize = false,
        FontFace = v2,
        TextColor3 = v3
    }
    local TextLabel2 = Instance.new("TextLabel")

    for v104, v105 in t48 do
        TextLabel2[v104] = v105
    end

    TextLabel2.Parent = v97

    for v106, v107 in t47 do
        TextLabel2[v106] = v107
    end

    local t49 = {
        Position = UDim2.fromScale(0.06, 0.35),
        Size = UDim2.fromScale(0.88, 0.14),
        TextXAlignment = Enum.TextXAlignment.Left
    }
    local t50 = {
        BackgroundTransparency = 1,
        TextScaled = true,
        Text = "",
        AutoLocalize = false,
        FontFace = v2,
        TextColor3 = v3
    }
    local TextLabel3 = Instance.new("TextLabel")

    for v108, v109 in t50 do
        TextLabel3[v108] = v109
    end

    TextLabel3.Parent = v97

    for v110, v111 in t49 do
        TextLabel3[v110] = v111
    end

    t43.session = TextLabel3

    local t51 = {
        Text = "ON TRACK",
        Position = UDim2.fromScale(0.06, 0.51),
        Size = UDim2.fromScale(0.4, 0.11),
        TextColor3 = v4,
        TextXAlignment = Enum.TextXAlignment.Left
    }
    local t52 = {
        BackgroundTransparency = 1,
        TextScaled = true,
        Text = "",
        AutoLocalize = false,
        FontFace = v2,
        TextColor3 = v3
    }
    local TextLabel4 = Instance.new("TextLabel")

    for v112, v113 in t52 do
        TextLabel4[v112] = v113
    end

    TextLabel4.Parent = v97

    for v114, v115 in t51 do
        TextLabel4[v114] = v115
    end

    local t53 = {
        Position = UDim2.fromScale(0.06, 0.6),
        Size = UDim2.fromScale(0.4, 0.14),
        TextXAlignment = Enum.TextXAlignment.Left
    }
    local t54 = {
        BackgroundTransparency = 1,
        TextScaled = true,
        Text = "",
        AutoLocalize = false,
        FontFace = v2,
        TextColor3 = v3
    }
    local TextLabel5 = Instance.new("TextLabel")

    for v116, v117 in t54 do
        TextLabel5[v116] = v117
    end

    TextLabel5.Parent = v97

    for v118, v119 in t53 do
        TextLabel5[v118] = v119
    end

    t43.riders = TextLabel5

    local t55 = {
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.44, 0.44),
        BackgroundColor3 = v9
    }
    local Frame2 = Instance.new("Frame")

    for v120, v121 in t55 do
        Frame2[v120] = v121
    end

    Frame2.Parent = v97
    t43.board = Frame2

    local t56 = {
        CornerRadius = UDim.new(0.1, 0)
    }
    local board = t43.board
    local UICorner = Instance.new("UICorner")

    for v122, v123 in t56 do
        UICorner[v122] = v123
    end

    UICorner.Parent = board

    local board2 = t43.board
    local t57 = {
        Position = UDim2.fromScale(0.08, 0.15),
        Size = UDim2.fromScale(0.84, 0.7),
        FontFace = v1,
        TextColor3 = Color3.new(0, 0, 0)
    }
    local t58 = {
        BackgroundTransparency = 1,
        TextScaled = true,
        Text = "",
        AutoLocalize = false,
        FontFace = v2,
        TextColor3 = v3
    }
    local TextLabel6 = Instance.new("TextLabel")

    for v124, v125 in t58 do
        TextLabel6[v124] = v125
    end

    TextLabel6.Parent = board2

    for v126, v127 in t57 do
        TextLabel6[v126] = v127
    end

    t43.boardText = TextLabel6

    return t43
end

function t1.Build(p13) -- line: 112
    -- upvalues: buildCluster (copy), buildInfo (copy), buildRaceControl (copy)
    local Interior = p13:FindFirstChild("Interior")

    if not Interior then
        return nil
    end

    local t59 = {
        buttons = {}
    }
    local ClusterScreen = Interior:FindFirstChild("ClusterScreen")

    if ClusterScreen then
        t59.cluster = buildCluster(ClusterScreen)
    end

    local InfoScreen = Interior:FindFirstChild("InfoScreen")

    if InfoScreen then
        t59.info = buildInfo(InfoScreen)
    end

    local RaceControlScreen = Interior:FindFirstChild("RaceControlScreen")

    if RaceControlScreen then
        t59.rc = buildRaceControl(RaceControlScreen)
    end

    for _, v128 in { "BtnLightBar", "BtnFlash", "BtnHeadlights", "BtnHorn" } do
        local v129 = Interior:FindFirstChild(v128)

        if v129 then
            t59.buttons[v128] = {
                part = v129,
                color = v129:GetAttribute("OnColor") or v129.Color
            }
        end
    end

    return t59
end

local function button(p14, p15) -- line: 129
    if not p14 or p14.on == p15 then
        return
    end

    p14.on = p15
    p14.part.Material = p15 and Enum.Material.Neon or Enum.Material.SmoothPlastic
    p14.part.Color = p15 and p14.color or p14.color:Lerp(Color3.new(0, 0, 0), 0.7)
end

local MotoLegends = ReplicatedStorage:FindFirstChild("MotoLegends")
local n1 = 0
local n2 = 0

local function ridersOnTrack(p16) -- line: 139
    -- upvalues: n1 (ref), n2 (ref)
    if not (p16 - n1 > 1) then
        return n2
    end

    n1 = p16
    n2 = 0

    local RaceBikes = workspace:FindFirstChild("RaceBikes")

    if RaceBikes then
        for _, child in RaceBikes:GetChildren() do
            local RiderSeat = child:FindFirstChild("RiderSeat")

            if RiderSeat and RiderSeat:IsA("Seat") and RiderSeat.Occupant then
                n2 += 1
            end
        end
    end

    return n2
end

function t1.Update(p17, p18) -- line: 155
    -- upvalues: Config (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy), button (copy), MotoLegends (copy), ridersOnTrack (copy)
    local elapsed = os.clock()
    local cluster = p17.cluster
    local v130 = if not p18.driven then "P"
        elseif p18.gear < 0 then "R"
        elseif p18.gear == 0 then "N"
        else (if p18.transmission == "Manual" then "M" else "D") .. p18.gear
    local v132 = math.clamp((p18.rpm - Config.IdleRPM) / (Config.RedlineRPM - Config.IdleRPM), 0, 1)

    if cluster then
        local speed = cluster.speed
        local v135 = tostring((math.floor(p18.kph + 0.5)))

        if speed.Text ~= v135 then
            speed.Text = v135
        end

        local gear = cluster.gear

        if gear.Text ~= v130 then
            gear.Text = v130
        end

        local rpm = cluster.rpm
        local v138 = tostring(math.floor(p18.rpm / 50 + 0.5) * 50)

        if rpm.Text ~= v138 then
            rpm.Text = v138
        end

        cluster.rpmBar.Size = UDim2.fromScale(v132, 1)

        local rpmBar = cluster.rpmBar
        local v139 = if v132 > 0.9 and v8 then v8 elseif v132 > 0.75 and v7 then v7 else v6

        if rpmBar.BackgroundColor3 ~= v139 then
            rpmBar.BackgroundColor3 = v139
        end

        local v142 = math.clamp(math.floor((v132 - 0.55) / 0.42 * 12 + 0.5), 0, 12)
        local v143 = v132 > 0.97 and elapsed * 8 % 1 < 0.5

        for v144, v145 in cluster.lights do
            local v146 = v144 <= v142 and not (v132 > 0.97 and not v143)
            local frame = v145.frame
            local color = v146 and v145.color or v5

            if frame.BackgroundColor3 ~= color then
                frame.BackgroundColor3 = color
            end
        end

        local v147 = if p18.esc == false then "ESC OFF" elseif p18.lightBar then "SAFETY CAR LIGHTS ON" else ""
        local status = cluster.status

        if status.Text ~= v147 then
            status.Text = v147
        end

        local status2 = cluster.status
        local v148 = p18.esc == false and v8 or v7

        if status2.TextColor3 ~= v148 then
            status2.TextColor3 = v148
        end
    end

    local info = p17.info

    if info then
        local clock = info.clock
        local v149 = os.date("%H:%M")

        if clock.Text ~= v149 then
            clock.Text = v149
        end

        local bar = info.bar
        local v150 = if p18.lightBar then "ON" else "OFF"

        if bar.Text ~= v150 then
            bar.Text = v150
        end

        local bar2 = info.bar
        local v151, v152

        if p18.lightBar then
            if p18.flash and v7 then
                v151 = v7
                v152 = true
            else
                local v153 = Color3.fromRGB(150, 100, 20)

                if v153 then
                    v151 = v153
                    v152 = true
                else
                    v152 = false
                end
            end
        else
            v152 = false
        end

        if not v152 then
            v151 = v4
        end

        if bar2.TextColor3 ~= v151 then
            bar2.TextColor3 = v151
        end

        local v154 = info.tiles[1]
        local v155 = if p18.headlights then "ON" else "OFF"

        if v154.Text ~= v155 then
            v154.Text = v155
        end

        local v156 = info.tiles[1]
        local v157 = p18.headlights and v9 or v4

        if v156.TextColor3 ~= v157 then
            v156.TextColor3 = v157
        end

        local v158 = info.tiles[2]
        local v159 = if p18.transmission == "Manual" then "MANUAL" else "AUTO"

        if v158.Text ~= v159 then
            v158.Text = v159
        end

        local v160 = info.tiles[3]
        local v162 = math.floor(p18.kph + 0.5) .. " km/h"

        if v160.Text ~= v162 then
            v160.Text = v162
        end
    end

    local rc = p17.rc

    if rc then
        local v164 = tostring(MotoLegends and MotoLegends:GetAttribute("SessionPhase") or "Waiting"):gsub("(%l)(%u)", "%1 %2"):upper()
        local session = rc.session

        if session.Text ~= v164 then
            session.Text = v164
        end

        local riders = rc.riders
        local v166 = tostring((ridersOnTrack(elapsed)))

        if riders.Text ~= v166 then
            riders.Text = v166
        end

        local board = rc.board
        local v167 = p18.lightBar and v7 or v9

        if board.BackgroundColor3 ~= v167 then
            board.BackgroundColor3 = v167
        end

        local boardText = rc.boardText
        local v168 = if p18.lightBar then "SC" else "CLEAR"

        if boardText.Text ~= v168 then
            boardText.Text = v168
        end
    end

    local buttons = p17.buttons

    button(buttons.BtnLightBar, p18.lightBar)
    button(buttons.BtnFlash, p18.lightBar and p18.flash)
    button(buttons.BtnHeadlights, p18.headlights)
    button(buttons.BtnHorn, p18.horn)
end

return t1
