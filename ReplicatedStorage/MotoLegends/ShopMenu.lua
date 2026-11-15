-- https://lua.expert

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local Parent = script.Parent
local RaceIcons = require(Parent:WaitForChild("RaceIcons"))
local UIArt = require(Parent:WaitForChild("UIArt"))
local ShopCatalog = require(Parent:WaitForChild("ShopCatalog"))
local v1 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)
local v2 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
local v3 = Color3.new(1, 1, 1)
local v4 = Color3.new(0, 0, 0)
local v5 = Color3.fromRGB(231, 0, 0)
local v6 = Color3.fromRGB(150, 154, 162)
local Center = Enum.TextXAlignment.Center
local t1 = {}

t1.BlurSize = 20
t1.PreviewSpin = 0.6

local v7 = Color3.fromRGB(16, 30, 22)
local v8 = Color3.fromRGB(18, 18, 20)
local v9 = Color3.fromRGB(214, 174, 72)
local v10 = Color3.fromRGB(238, 34, 42)
local t2 = {
    {
        "Handle",
        1.2, 0.62, 0,
        v7,
        Enum.Material.Glass
    },
    {
        "BaseRing",
        0.05, 0.6, -0.6,
        Color3.fromRGB(10, 18, 13),
        Enum.Material.Glass
    },
    {
        "Shoulder",
        0.16, 0.52, 0.68,
        v7,
        Enum.Material.Glass
    },
    {
        "ShoulderTop",
        0.14, 0.38, 0.82,
        v7,
        Enum.Material.Glass
    },
    {
        "Neck",
        0.44, 0.25, 1.1,
        v8,
        Enum.Material.SmoothPlastic
    },
    {
        "FoilRing",
        0.06, 0.29, 0.93,
        v9,
        Enum.Material.Metal
    },
    {
        "Cork",
        0.2, 0.29, 1.4,
        v8,
        Enum.Material.SmoothPlastic
    },
    {
        "CorkBand",
        0.05, 0.3, 1.33,
        v9,
        Enum.Material.Metal
    }
}
local t3 = {
    Pink = {
        sparks = 8,
        glow = Color3.fromRGB(255, 120, 200),
        spark = {
            Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(255, 150, 215),
            Color3.fromRGB(255, 110, 190)
        },
        ribbon = Color3.fromRGB(255, 170, 220)
    },
    Golden = {
        sparks = 11,
        glow = Color3.fromRGB(255, 205, 80),
        spark = {
            Color3.fromRGB(255, 252, 220),
            Color3.fromRGB(255, 220, 120),
            Color3.fromRGB(255, 190, 40)
        },
        ribbon = Color3.fromRGB(255, 225, 140)
    },
    Rainbow = {
        spark = nil,
        sparks = 14,
        ribbon = nil,
        rainbow = true,
        glow = Color3.fromRGB(235, 230, 255)
    },
    Community = {
        sparks = 10,
        glow = Color3.fromRGB(90, 160, 255),
        spark = {
            Color3.fromRGB(235, 245, 255),
            Color3.fromRGB(140, 200, 255),
            Color3.fromRGB(70, 140, 255)
        },
        ribbon = Color3.fromRGB(150, 205, 255)
    },
    Blackhole = {
        sparks = 16,
        glow = Color3.fromRGB(255, 170, 40),
        spark = {
            Color3.fromRGB(255, 255, 235),
            Color3.fromRGB(255, 214, 90),
            Color3.fromRGB(255, 140, 30)
        },
        ribbon = Color3.fromRGB(255, 196, 60)
    }
}
local v11

local function glowContent() -- line: 61
    -- upvalues: v11 (ref)
    if v11 ~= nil then
        return v11
    end

    v11 = false

    local function v12() -- line: 64
        local v13 = buffer.create(16384)

        for i = 0, 63 do
            for j = 0, 63 do
                local v14 = (j + 0.5) / 64 * 2 - 1
                local v15 = (i + 0.5) / 64 * 2 - 1
                local v20 = math.floor(math.clamp(1 - math.sqrt(v14 * v14 + v15 * v15), 0, 1) ^ 2.2 * 255 + 0.5) * 16777216 + 16777215

                buffer.writeu32(v13, (i * 64 + j) * 4, v20)
            end
        end

        local v21 = game:GetService("AssetService"):CreateEditableImage({
            Size = Vector2.new(64, 64)
        })

        v21:WritePixelsBuffer(Vector2.zero, Vector2.new(64, 64), v13)

        return Content.fromObject(v21)
    end

    local ok, result = pcall(v12)

    if ok then
        v11 = result
    end

    return v11
end

local function makeAura(p1, p2, p3, p4) -- line: 79
    -- upvalues: t3 (copy), v11 (ref)
    local v22 = t3[p2]

    if not v22 then
        return nil
    end

    local function layer(p5, p6) -- line: 82
        -- upvalues: p1 (copy), p3 (copy), p4 (copy)
        local Frame = Instance.new("Frame")

        Frame.Name = p5
        Frame.BackgroundTransparency = 1
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Position = p3
        Frame.Size = p4
        Frame.ZIndex = p6
        Frame.Parent = p1

        return Frame
    end

    local Frame = Instance.new("Frame")

    Frame.Name = "LuxuryAuraBack"
    Frame.BackgroundTransparency = 1
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = p3
    Frame.Size = p4
    Frame.ZIndex = 7
    Frame.Parent = p1

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "LuxuryAuraFront"
    Frame2.BackgroundTransparency = 1
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame2.Position = p3
    Frame2.Size = p4
    Frame2.ZIndex = 9
    Frame2.Parent = p1

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Glow"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
    ImageLabel.Size = UDim2.fromScale(0.95, 1.05)
    ImageLabel.ImageColor3 = v22.glow
    ImageLabel.ImageTransparency = 0.35
    ImageLabel.ZIndex = 7

    if v11 == nil then
        v11 = false

        local function v23() -- line: 64
            local v24 = buffer.create(16384)

            for i = 0, 63 do
                for j = 0, 63 do
                    local v25 = (j + 0.5) / 64 * 2 - 1
                    local v26 = (i + 0.5) / 64 * 2 - 1
                    local v31 = math.floor(math.clamp(1 - math.sqrt(v25 * v25 + v26 * v26), 0, 1) ^ 2.2 * 255 + 0.5) * 16777216 + 16777215

                    buffer.writeu32(v24, (i * 64 + j) * 4, v31)
                end
            end

            local v32 = game:GetService("AssetService"):CreateEditableImage({
                Size = Vector2.new(64, 64)
            })

            v32:WritePixelsBuffer(Vector2.zero, Vector2.new(64, 64), v24)

            return Content.fromObject(v32)
        end

        local ok, result = pcall(v23)

        if ok then
            v11 = result
        end
    end

    local v33 = v11

    if v33 then
        ImageLabel.ImageContent = v33
    else
        ImageLabel.Image = "rbxasset://textures/particles/smoke_main.dds"
    end

    ImageLabel.Parent = Frame

    local t4 = {
        def = v22,
        holder = Frame,
        front = Frame2,
        glow = ImageLabel,
        sparks = {},
        orbs = {}
    }

    for _ = 1, v22.sparks do
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Sparkle"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Image = "rbxasset://textures/particles/sparkles_main.dds"
        ImageLabel.ImageTransparency = 1
        ImageLabel.ZIndex = 9
        ImageLabel.Parent = Frame2
        table.insert(t4.sparks, {
            x = 0,
            y = 0,
            size = 0,
            col = nil,
            gui = ImageLabel,
            born = -math.random() * 2,
            life = 1.2 + math.random() * 1.2
        })
    end

    for i = 1, 2 do
        for j = 1, 7 do
            local function dot(p7) -- line: 99
                local ImageLabel = Instance.new("ImageLabel")

                ImageLabel.Name = "Ribbon"
                ImageLabel.BackgroundTransparency = 1
                ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                ImageLabel.Image = "rbxasset://textures/particles/sparkles_main.dds"
                ImageLabel.ZIndex = 9
                ImageLabel.Parent = p7

                return ImageLabel
            end

            local orbs = t4.orbs
            local t6 = {}
            local ImageLabel = Instance.new("ImageLabel")

            ImageLabel.Name = "Ribbon"
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            ImageLabel.Image = "rbxasset://textures/particles/sparkles_main.dds"
            ImageLabel.ZIndex = 9
            ImageLabel.Parent = Frame2
            t6.near = ImageLabel

            local ImageLabel2 = Instance.new("ImageLabel")

            ImageLabel2.Name = "Ribbon"
            ImageLabel2.BackgroundTransparency = 1
            ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
            ImageLabel2.Image = "rbxasset://textures/particles/sparkles_main.dds"
            ImageLabel2.ZIndex = 9
            ImageLabel2.Parent = Frame
            t6.far = ImageLabel2
            t6.ribbon = i
            t6.k = j
            table.insert(orbs, t6)
        end
    end

    return t4
end

local function stepAura(p8, p9, p10) -- line: 104
    p8.holder.Visible = p10
    p8.front.Visible = p10

    if not p10 then
        return
    end

    local def = p8.def
    local v34 = def.rainbow and p9 * 0.25 % 1 or nil

    p8.glow.ImageColor3 = (v34 and Color3.fromHSV(v34, 0.45, 1) or def.glow):Lerp(Color3.new(1, 1, 1), 0.45)
    p8.glow.ImageTransparency = 0.4 - math.sin(p9 * 2.2) * 0.1

    for _, v36 in p8.sparks do
        local v37 = p9 - v36.born

        if v36.life < v37 or v37 < 0 then
            v36.born = p9
            v36.life = 1.1 + math.random() * 1.3
            v36.x = 0.5 + (math.random() - 0.5) * 0.62
            v36.y = 0.25 + math.random() * 0.62
            v36.size = 26 + math.random() * 34
            v36.col = def.rainbow and Color3.fromHSV(math.random(), 0.6, 1) or def.spark[math.random(#def.spark)]
            v36.gui.ImageColor3 = v36.col
            v37 = 0
            v36.gui.Rotation = math.random(0, 90)
        end

        local v38 = v37 / v36.life
        local v40 = math.sin(v38 * 3.141592653589793)

        v36.gui.Position = UDim2.fromScale(v36.x, v36.y - v38 * 0.12)
        v36.gui.Size = UDim2.fromOffset(v36.size * (v40 * 0.7 + 0.5), v36.size * (v40 * 0.7 + 0.5))
        v36.gui.ImageTransparency = 1 - v40 * 0.95
    end

    for _, v41 in p8.orbs do
        local v42 = if v41.ribbon == 1 then 1.6 else -1.25
        local v43 = p9 * v42 + (if v41.ribbon == 1 then 0 else 3.141592653589793) - (v41.k - 1) * 0.16 * math.sign(v42)
        local v44 = if v41.ribbon == 1 then 0.22 else -0.18
        local v45 = math.cos(v43) * 0.36 + 0.5
        local v46 = math.sin(v43) * 0.1 + 0.55 + v44 * math.cos(v43) * 0.5 + (if v41.ribbon == 1 then -0.08 else 0.1)
        local v47 = math.sin(v43) > 0
        local v48 = def.rainbow and Color3.fromHSV((p9 * 0.3 + v41.ribbon * 0.5 + v41.k * 0.03) % 1, 0.55, 1) or def.ribbon
        local v49 = (34 - v41.k * 3.4) * (if v47 then 1.1 else 0.8)
        local near = if v47 then v41.near or v41.far else v41.far
        local far = if v47 then v41.far or v41.near else v41.near

        far.Visible = false
        near.Visible = true
        near.Position = UDim2.fromScale(v45, v46)
        near.Size = UDim2.fromOffset(v49, v49)
        near.ImageColor3 = v48
        near.ImageTransparency = v41.k * 0.1 + (v47 and 0 or 0.2)
    end
end

local function gframe(p11, p12, p13, p14, p15, p16, p17, p18) -- line: 144
    local Frame = Instance.new("Frame")

    Frame.Name = p12
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = p17
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromOffset(p13, p14)
    Frame.Size = UDim2.fromOffset(p15, p16)
    Frame.ZIndex = p18 or 1
    Frame.Parent = p11

    return Frame
end

local function circle(p19) -- line: 148
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = p19

    return p19
end

local function heartShape(p20, p21, p22, p23) -- line: 150
    -- upvalues: gframe (copy)
    local v50 = 2 * (p21 / 2.8284271247461903 + p21 / 2)
    local v51 = p21 / 2.8284271247461903 + p21 / 2 + p21 / 1.4142135623730951
    local CanvasGroup = Instance.new("CanvasGroup")

    CanvasGroup.Name = "Heart"
    CanvasGroup.BackgroundTransparency = 1
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5)
    CanvasGroup.Size = UDim2.fromOffset(v50, v51)
    CanvasGroup.ZIndex = p23
    CanvasGroup.Parent = p20

    local v52 = v50 / 2
    local v53 = p21 / 2.8284271247461903 + p21 / 2

    gframe(CanvasGroup, "Body", v52, v53, p21, p21, p22).Rotation = 45

    local v54 = gframe(CanvasGroup, "LobeL", v52 - p21 / 2.8284271247461903, v53 - p21 / 2.8284271247461903, p21, p21, p22)
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = v54

    local v55 = gframe(CanvasGroup, "LobeR", v52 + p21 / 2.8284271247461903, v53 - p21 / 2.8284271247461903, p21, p21, p22)
    local UICorner2 = Instance.new("UICorner")

    UICorner2.CornerRadius = UDim.new(0.5, 0)
    UICorner2.Parent = v55

    return CanvasGroup
end

local function rays(p24, p25, p26, p27, p28, p29, p30) -- line: 159
    -- upvalues: gframe (copy)
    local t7 = {}

    for i = 1, p25 do
        local v56 = gframe(p24, "Ray", 0, 0, p27, p26, p28, p30)

        v56.AnchorPoint = Vector2.new(0.5, 0.5)
        v56.Position = UDim2.fromScale(0.5, 0.5)

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = 90
        UIGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, p29),
            NumberSequenceKeypoint.new(1, 1)
        })
        UIGradient.Parent = v56
        table.insert(t7, {
            f = v56,
            a = (i - 1) * 180 / p25
        })
    end

    return t7
end

local t9 = {
    0, 0.07, 0.15, 0.33, 0.56, 0.68, 0.8
}

local function emblem(p31, p32, p33, p34) -- line: 170
    -- upvalues: gframe (copy), heartShape (copy), rays (copy), t9 (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = "Backdrop"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.ZIndex = 7
    Frame.Parent = p31

    if p32 == "Pink" then
        local v57 = heartShape(Frame, 112, Color3.fromRGB(255, 70, 160), 7)

        v57.Position = UDim2.fromOffset(p33, p34 + 10)
        v57.GroupTransparency = 0.08

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = 70
        UIGradient.Color = ColorSequence.new(Color3.fromRGB(255, 215, 235), Color3.fromRGB(255, 60, 150))
        UIGradient.Parent = v57

        local UIScale = Instance.new("UIScale")

        UIScale.Parent = v57

        local t10 = {}

        for i = 1, 7 do
            local v58 = 14 + math.random() * 10
            local v59 = i % 2 == 0
            local v60 = if v59 then Color3.fromRGB(255, 120, 190) else nil

            table.insert(t10, {
                g = heartShape(Frame, v58, if not v59 or not v60 then Color3.fromRGB(255, 225, 240) else v60, 7),
                x = 24 + math.random() * 210,
                phase = math.random(),
                speed = 0.18 + math.random() * 0.14,
                sway = math.random() * 6
            })
        end

        return function(p35) -- line: 182
            -- upvalues: UIScale (copy), t10 (copy)
            local v62 = p35 % 0.9 / 0.9

            UIScale.Scale = math.exp(-((v62 - 0.08) / 0.05) ^ 2) * 0.09 + 1 + math.exp(-((v62 - 0.3) / 0.05) ^ 2) * 0.05

            for _, v66 in t10 do
                local v67 = (p35 * v66.speed + v66.phase) % 1

                v66.g.Position = UDim2.fromOffset(v66.x + math.sin(p35 * 2 + v66.sway) * 8, 250 - v67 * 240)
                v66.g.GroupTransparency = 1 - math.sin(v67 * 3.141592653589793) * 0.85
                v66.g.Rotation = math.sin(p35 * 1.6 + v66.sway) * 14
            end
        end
    end

    if p32 == "Golden" then
        local Frame2 = Instance.new("Frame")

        Frame2.Name = "Rays"
        Frame2.BackgroundTransparency = 1
        Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame2.Position = UDim2.fromOffset(p33, p34)
        Frame2.Size = UDim2.fromOffset(10, 10)
        Frame2.ZIndex = 7
        Frame2.Parent = Frame

        local v71 = rays(Frame2, 10, 330, 22, Color3.fromRGB(255, 228, 130), 0.55, 7)
        local CanvasGroup = Instance.new("CanvasGroup")

        CanvasGroup.Name = "Trophy"
        CanvasGroup.BackgroundTransparency = 1
        CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5)
        CanvasGroup.Position = UDim2.fromOffset(p33, p34 + 4)
        CanvasGroup.Size = UDim2.fromOffset(170, 200)
        CanvasGroup.GroupTransparency = 0
        CanvasGroup.ZIndex = 7

        local UIScale = Instance.new("UIScale")

        UIScale.Scale = 1.18
        UIScale.Parent = CanvasGroup

        local v72 = Color3.fromRGB(255, 214, 80)
        local v73 = Color3.fromRGB(110, 70, 6)
        local v74 = gframe(CanvasGroup, "Bowl", 85, 78, 110, 110, v72)
        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0.5, 0)
        UICorner.Parent = v74
        gframe(CanvasGroup, "Cup", 85, 50, 110, 56, v72)
        gframe(CanvasGroup, "Rim", 85, 22, 126, 13, v72)

        for _, v75 in { -1, 1 } do
            local v76 = gframe(CanvasGroup, "Handle", 85 + v75 * 58, 62, 50, 58, v72)
            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(0.5, 0)
            UICorner.Parent = v76
            v76.BackgroundTransparency = 1

            local UIStroke = Instance.new("UIStroke")

            UIStroke.Color = v72
            UIStroke.Thickness = 10
            UIStroke.Parent = v76
        end

        local v77 = gframe(CanvasGroup, "Knob", 85, 136, 30, 30, v72)
        local UICorner2 = Instance.new("UICorner")

        UICorner2.CornerRadius = UDim.new(0.5, 0)
        UICorner2.Parent = v77
        gframe(CanvasGroup, "Stem", 85, 150, 20, 36, v72)
        gframe(CanvasGroup, "Foot", 85, 170, 72, 12, v72)
        gframe(CanvasGroup, "Plinth", 85, 187, 104, 24, v73)

        local v78 = gframe(CanvasGroup, "Shine", 60, 52, 16, 40, Color3.fromRGB(255, 252, 225))
        local UICorner3 = Instance.new("UICorner")

        UICorner3.CornerRadius = UDim.new(0.5, 0)
        UICorner3.Parent = v78
        v78.BackgroundTransparency = 0.25

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = 55
        UIGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 250, 215)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 214, 80)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(205, 135, 12))
        })
        UIGradient.Parent = CanvasGroup

        local clone = CanvasGroup:Clone()

        clone.Name = "TrophyShadow"
        clone.Position = UDim2.fromOffset(p33 + 6, p34 + 10)
        clone.GroupTransparency = 0.45
        clone:FindFirstChildOfClass("UIGradient").Color = ColorSequence.new(Color3.fromRGB(40, 24, 0))
        clone.Parent = Frame
        CanvasGroup.Parent = Frame

        return function(p36) -- line: 213
            -- upvalues: v71 (copy)
            for _, v79 in v71 do
                v79.f.Rotation = v79.a + p36 * 10
            end
        end
    end

    if p32 == "Community" then
        local Frame2 = Instance.new("Frame")

        Frame2.Name = "Rays"
        Frame2.BackgroundTransparency = 1
        Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame2.Position = UDim2.fromOffset(p33, p34)
        Frame2.Size = UDim2.fromOffset(10, 10)
        Frame2.ZIndex = 7
        Frame2.Parent = Frame

        local v80 = rays(Frame2, 10, 330, 22, Color3.fromRGB(130, 195, 255), 0.55, 7)
        local t12 = {}

        for _ = 1, 10 do
            local v81 = 10 + math.random() * 16
            local v82 = gframe(Frame, "Bubble", 0, 0, v81, v81, Color3.fromRGB(170, 215, 255), 7)
            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(0.5, 0)
            UICorner.Parent = v82
            v82.BackgroundTransparency = 0.7

            local UIStroke = Instance.new("UIStroke")

            UIStroke.Color = Color3.fromRGB(235, 245, 255)
            UIStroke.Thickness = 1.5
            UIStroke.Transparency = 0.2
            UIStroke.Parent = v82
            table.insert(t12, {
                f = v82,
                st = UIStroke,
                x = 20 + math.random() * 218,
                phase = math.random(),
                speed = 0.16 + math.random() * 0.14,
                sway = math.random() * 6
            })
        end

        return function(p37) -- line: 228
            -- upvalues: v80 (copy), t12 (copy)
            for _, v83 in v80 do
                v83.f.Rotation = v83.a + p37 * 8
            end

            for _, v84 in t12 do
                local v85 = (p37 * v84.speed + v84.phase) % 1

                v84.f.Position = UDim2.fromOffset(v84.x + math.sin(p37 * 2 + v84.sway) * 7, 250 - v85 * 240)

                local v88 = 1 - math.sin(v85 * 3.141592653589793) * 0.8

                v84.f.BackgroundTransparency = v88 * 0.45 + 0.55
                v84.st.Transparency = v88
            end
        end
    end

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Rays"
    Frame2.BackgroundTransparency = 1
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame2.Position = UDim2.fromOffset(p33, p34)
    Frame2.Size = UDim2.fromOffset(10, 10)
    Frame2.ZIndex = 7
    Frame2.Parent = Frame

    local v89 = rays(Frame2, 12, 340, 18, Color3.new(1, 1, 1), 0.62, 7)
    local Frame3 = Instance.new("Frame")

    Frame3.Name = "Arch"
    Frame3.BackgroundTransparency = 1
    Frame3.ClipsDescendants = true
    Frame3.AnchorPoint = Vector2.new(0.5, 1)
    Frame3.Position = UDim2.fromOffset(p33, p34 + 30)
    Frame3.Size = UDim2.fromOffset(254, 127)
    Frame3.ZIndex = 7
    Frame3.Parent = Frame

    local t14 = {}

    for v90, v91 in t9 do
        local v92 = 250 - 22 * v90
        local v93 = gframe(Frame3, "Band", 127, 127, v92, v92, Color3.new(), 7)
        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0.5, 0)
        UICorner.Parent = v93
        v93.BackgroundTransparency = 1

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Thickness = 11.6
        UIStroke.Color = Color3.fromHSV(v91, 0.8, 1)
        UIStroke.Parent = v93
        table.insert(t14, {
            st = UIStroke,
            h = v91
        })
    end

    for _, v94 in { -1, 1 } do
        for _, v95 in {
                { 0, 0, 40 },
                {
                    v94 * -16,
                    6, 30
                },
                {
                    v94 * 18,
                    8, 28
                },
                {
                    v94 * -2,
                    -12, 28
                }
            } do
            local v96 = gframe(Frame, "Cloud", p33 + v94 * 86.5 + v95[1], p34 + 30 + v95[2], v95[3], v95[3], Color3.new(1, 1, 1), 7)
            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(0.5, 0)
            UICorner.Parent = v96
            v96.BackgroundTransparency = 0.04
        end
    end

    return function(p38) -- line: 256
        -- upvalues: v89 (copy), t14 (copy)
        for _, v97 in t14 do
            v97.st.Color = Color3.fromHSV((v97.h + p38 * 0.1) % 1, 0.78, 1)
        end

        for v98, v99 in v89 do
            v99.f.Rotation = v99.a - p38 * 8
            v99.f.BackgroundColor3 = Color3.fromHSV((v98 / #v89 + p38 * 0.1) % 1, 0.45, 1)
        end
    end
end

local function addShine(p39, p40) -- line: 263
    local Frame = Instance.new("Frame")

    Frame.Name = "Shine"
    Frame.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.ZIndex = p40
    Frame.Parent = p39

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 15
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.34, 1),
        NumberSequenceKeypoint.new(0.5, 0.6),
        NumberSequenceKeypoint.new(0.66, 1),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Offset = Vector2.new(-1.2, 0)
    UIGradient.Parent = Frame

    return UIGradient
end

local function buildPreviewBottle(p41) -- line: 272
    -- upvalues: v7 (copy), v8 (copy), v9 (copy), v10 (copy), t2 (copy)
    local Model = Instance.new("Model")

    Model.Name = "Bottle"

    local v100, v101

    if p41 then
        local PreviewGlass = p41.PreviewGlass

        if PreviewGlass then
            v100 = PreviewGlass
            v101 = true
        else
            local Glass = p41.Glass

            if Glass then
                v100 = Glass
                v101 = true
            else
                v101 = false
            end
        end
    else
        v101 = false
    end

    if not v101 then
        v100 = v7
    end

    local v102, v103

    if p41 then
        local PreviewMaterial = p41.PreviewMaterial

        if PreviewMaterial then
            v102 = PreviewMaterial
            v103 = true
        else
            local Material = p41.Material

            if Material then
                v102 = Material
                v103 = true
            else
                v103 = false
            end
        end
    else
        v103 = false
    end

    if not v103 then
        v102 = Enum.Material.Glass
    end

    local v104 = CFrame.Angles(0, 0, 1.5707963267948966)
    local t16 = {}

    local function part(p42, p43, p44, p45, p46, p47) -- line: 279
        -- upvalues: Model (copy), v104 (copy)
        local Part = Instance.new("Part")

        Part.Name = p42
        Part.Size = p43
        Part.Color = p45
        Part.Material = p46 or Enum.Material.SmoothPlastic

        if p47 then
            Part.Shape = p47
        end

        Part.Anchored = true
        Part.CanCollide = false
        Part.CanTouch = false
        Part.CanQuery = false
        Part.CastShadow = false
        Part.TopSurface = Enum.SurfaceType.Smooth
        Part.BottomSurface = Enum.SurfaceType.Smooth
        Part.CFrame = v104 * CFrame.new(-0.4375, 0, 0) * p44
        Part.Parent = Model

        return Part
    end

    for _, v105 in t2 do
        local v106 = v105[5]
        local v107 = v105[6]

        if p41 then
            if v106 == v7 then
                v107 = v102
                v106 = v100
            elseif v105[1] == "BaseRing" then
                v106 = v100:Lerp(Color3.new(), 0.45)
            elseif v106 == v9 then
                v106 = p41.Foil
            end
        end

        local v112 = part(v105[1], Vector3.new(v105[2], v105[3], v105[3]), CFrame.new(v105[4], 0, 0), v106, v107, Enum.PartType.Cylinder)

        if v105[1] == "Handle" then
            v112.Reflectance = p41 and p41.PreviewReflectance or 0.15
        end

        if v105[5] == v7 then
            table.insert(t16, v112)
        end
    end

    local v113 = CFrame.Angles(0, 0, -1.5707963267948966)

    part("Label", Vector3.new(0.36, 0.62, 0.02), CFrame.new(-0.05, 0, -0.302) * v113, v8)

    local v114 = part("Logo", Vector3.new(0.29, 0.22, 0.01), CFrame.new(0.12, 0, -0.315) * v113, v8)

    v114.Transparency = 1

    local Decal = Instance.new("Decal")

    Decal.Face = Enum.NormalId.Front
    Decal.Texture = "rbxassetid://88917895758743"
    Decal.Parent = v114
    part("LabelBar", Vector3.new(0.25, 0.016, 0.01), CFrame.new(-0.06, 0, -0.315) * v113, v10)
    Model.WorldPivot = CFrame.new()

    return Model, t16
end

t1.AddShine = addShine
t1.CardSize = Vector2.new(274, 395)
t1.CardStrip = 78

function t1.BottleCard(p48, p49) -- line: 314
    -- upvalues: ShopCatalog (copy), t1 (copy), v1 (copy), v3 (copy), makeAura (copy), stepAura (copy), emblem (copy), addShine (copy), buildPreviewBottle (copy)
    local v115 = ShopCatalog.Bottles[p49]
    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Card_" .. p49
    TextButton.Text = ""
    TextButton.BackgroundTransparency = 1
    TextButton.Size = UDim2.fromOffset(274, 395)
    TextButton.ZIndex = 5
    TextButton.AutoButtonColor = false
    TextButton.Parent = p48

    local function frame(p50, p51, p52, p53, p54, p55, p56, p57) -- line: 317
        local Frame = Instance.new("Frame")

        Frame.Name = p51
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = p56
        Frame.Position = UDim2.fromOffset(p52, p53)
        Frame.Size = UDim2.fromOffset(p54, p55)
        Frame.ZIndex = p57
        Frame.Parent = p50

        return Frame
    end

    local function round(p58, p59) -- line: 320
        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0, p59)
        UICorner.Parent = p58
    end

    local Frame = Instance.new("Frame")

    Frame.Name = "Base"
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = v3
    Frame.Position = UDim2.fromOffset(0, 0)
    Frame.Size = UDim2.fromOffset(274, 395)
    Frame.ZIndex = 5
    Frame.Parent = TextButton

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, 18)
    UICorner.Parent = Frame

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Art"
    Frame2.BorderSizePixel = 0
    Frame2.BackgroundColor3 = v3
    Frame2.Position = UDim2.fromOffset(8, 8)
    Frame2.Size = UDim2.fromOffset(258, 309)
    Frame2.ZIndex = 6
    Frame2.Parent = TextButton

    local UICorner2 = Instance.new("UICorner")

    UICorner2.CornerRadius = UDim.new(0, 12)
    UICorner2.Parent = Frame2
    Frame2.ClipsDescendants = true

    local Frame3 = Instance.new("Frame")

    Frame3.Name = "ArtBottom"
    Frame3.BorderSizePixel = 0
    Frame3.BackgroundColor3 = v3
    Frame3.Position = UDim2.fromOffset(8, 303)
    Frame3.Size = UDim2.fromOffset(258, 14)
    Frame3.ZIndex = 6
    Frame3.Parent = TextButton

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Color = v115.Gradient or ColorSequence.new(v115.Top, v115.Bottom)
    UIGradient.Parent = Frame2

    local Keypoints = UIGradient.Color.Keypoints

    Frame3.BackgroundColor3 = Keypoints[#Keypoints].Value

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Name"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = v115.Short .. "\nBOTTLE"
    TextLabel.TextColor3 = v3
    TextLabel.FontFace = v1
    TextLabel.TextSize = 30
    TextLabel.LineHeight = 1
    TextLabel.Position = UDim2.fromOffset(0, 215)
    TextLabel.Size = UDim2.fromOffset(258, 72)
    TextLabel.ZIndex = 8
    TextLabel.AutoLocalize = false
    TextLabel.Parent = Frame2

    local ViewportFrame = Instance.new("ViewportFrame")

    ViewportFrame.Name = "Preview3D"
    ViewportFrame.BackgroundTransparency = 1
    ViewportFrame.AnchorPoint = Vector2.new(0.5, 0)
    ViewportFrame.Position = UDim2.new(0.5, 0, 0, 2)
    ViewportFrame.Size = UDim2.fromOffset(240, 214)
    ViewportFrame.ZIndex = 8
    ViewportFrame.Ambient = Color3.fromRGB(205, 205, 210)
    ViewportFrame.LightColor = Color3.fromRGB(255, 255, 255)
    ViewportFrame.LightDirection = Vector3.new(-0.5, -0.6, 1)
    ViewportFrame.Parent = Frame2

    local v116 = buildPreviewBottle(v115)

    v116.Parent = ViewportFrame

    local Camera = Instance.new("Camera")

    Camera.FieldOfView = 30
    Camera.CFrame = CFrame.lookAt(Vector3.new(0, 0.1, -4.1), (Vector3.new(0, -0.02, 0)))
    Camera.Parent = ViewportFrame
    ViewportFrame.CurrentCamera = Camera

    local v117 = emblem(Frame2, p49, 129, 109)
    local v118 = makeAura(Frame2, p49, UDim2.new(0.5, 0, 0, 109), UDim2.fromOffset(200, 214))
    local v119 = addShine(Frame2, 10)
    local Frame4 = Instance.new("Frame")

    Frame4.Name = "Strip"
    Frame4.BackgroundTransparency = 1
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame4.Position = UDim2.fromOffset(137, 352)
    Frame4.Size = UDim2.fromOffset(0, 48)
    Frame4.AutomaticSize = Enum.AutomaticSize.X
    Frame4.ZIndex = 7
    Frame4.Parent = TextButton

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Frame4

    return {
        button = TextButton,
        base = Frame,
        strip = Frame4,
        step = function(p60, p61) -- step | line: 340
            -- upvalues: v116 (copy), v117 (copy), v118 (copy), v119 (copy), t1 (copy), stepAura (copy)
            local v121 = math.clamp(p60 % 3 / 1.8, 0, 1)
            local v122 = v121 * v121 * (3 - v121 * 2)

            v119.Offset = Vector2.new(v122 * 2.4 + -1.2, 0)

            if v117 then
                v117(p60)
            end

            v116:PivotTo(CFrame.Angles(0, p60 * t1.PreviewSpin, 0))

            if v118 then
                stepAura(v118, p60, p61)
            end
        end
    }
end

function t1.New(p62) -- line: 349
    -- upvalues: TweenService (copy), RunService (copy), UserInputService (copy), Players (copy), MarketplaceService (copy), HttpService (copy), Parent (copy), RaceIcons (copy), UIArt (copy), ShopCatalog (copy), t1 (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), Center (copy), v11 (ref), makeAura (copy), stepAura (copy), rays (copy), emblem (copy), addShine (copy), buildPreviewBottle (copy)
    local t18 = {}
    local LocalPlayer = Players.LocalPlayer
    local ShopAction = Parent:WaitForChild("ShopAction")
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "ShopHUD"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 36
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Enabled = false
    ScreenGui.Archivable = false
    ScreenGui.Parent = p62

    local Frame = Instance.new("Frame")

    Frame.Name = "Root"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.Parent = ScreenGui

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "ReferenceCanvas"
    Frame2.BackgroundTransparency = 1
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame2.Position = UDim2.fromScale(0.5, 0.5)
    Frame2.Size = UDim2.fromOffset(2000, 1125)
    Frame2.Parent = Frame

    local UIScale = Instance.new("UIScale", Frame2)

    local function fit() -- line: 359
        -- upvalues: Frame (copy), UIScale (copy)
        local AbsoluteSize = Frame.AbsoluteSize

        if AbsoluteSize.X < 1 or AbsoluteSize.Y < 1 then
            AbsoluteSize = workspace.CurrentCamera.ViewportSize
        end

        UIScale.Scale = math.min(AbsoluteSize.X / 2000, AbsoluteSize.Y / 1125)
    end

    Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)

    local function text(p63, p64, p65, p66, p67, p68, p69, p70, p71, p72) -- line: 364
        -- upvalues: v1 (copy), v3 (copy)
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = p64
        TextLabel.Text = p65
        TextLabel.BackgroundTransparency = 1
        TextLabel.Position = UDim2.fromOffset(p66, p67)
        TextLabel.Size = UDim2.fromOffset(p68, p69)
        TextLabel.TextColor3 = p71 or v3
        TextLabel.FontFace = p72 or v1
        TextLabel.TextSize = p70
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.ZIndex = 5
        TextLabel.AutoLocalize = false
        TextLabel.Parent = p63

        return TextLabel
    end

    local function frame(p73, p74, p75, p76, p77, p78, p79, p80) -- line: 368
        -- upvalues: v3 (copy)
        local Frame = Instance.new("Frame")

        Frame.Name = p74
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = p79 or v3
        Frame.Position = UDim2.fromOffset(p75, p76)
        Frame.Size = UDim2.fromOffset(p77, p78)
        Frame.ZIndex = p80 or 5
        Frame.Parent = p73

        return Frame
    end

    local function round(p81, p82) -- line: 371
        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0, p82)
        UICorner.Parent = p81

        return UICorner
    end

    local function pressable(p83, p84) -- line: 373
        -- upvalues: TweenService (copy)
        p83:SetAttribute("NoHover", true)
        p83.AutoButtonColor = false

        local v125 = p83:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", p83)

        local function set(p85) -- line: 376
            -- upvalues: p84 (copy)
            if p84 then
                p84(p85)
            end
        end

        p83.MouseEnter:Connect(function() -- line: 377
            -- upvalues: p84 (copy)
            if p84 then
                p84(true)
            end
        end)
        p83.MouseLeave:Connect(function() -- line: 378
            -- upvalues: p84 (copy), v125 (copy), TweenService (copy)
            if p84 then
                p84(false)
            end

            TweenService:Create(v125, TweenInfo.new(0.12), {
                Scale = 1
            }):Play()
        end)
        p83.SelectionGained:Connect(function() -- line: 379
            -- upvalues: p84 (copy)
            if p84 then
                p84(true)
            end
        end)
        p83.SelectionLost:Connect(function() -- line: 379
            -- upvalues: p84 (copy)
            if p84 then
                p84(false)
            end
        end)
        p83.MouseButton1Down:Connect(function() -- line: 380
            -- upvalues: v125 (copy), TweenService (copy)
            TweenService:Create(v125, TweenInfo.new(0.08), {
                Scale = 0.95
            }):Play()
        end)
        p83.MouseButton1Up:Connect(function() -- line: 381
            -- upvalues: v125 (copy), TweenService (copy)
            TweenService:Create(v125, TweenInfo.new(0.16, Enum.EasingStyle.Back), {
                Scale = 1
            }):Play()
        end)

        return p83, v125
    end

    local function closeButton(p86, p87, p88, p89, p90, p91, p92) -- line: 385
        -- upvalues: text (copy), pressable (copy), TweenService (copy), RaceIcons (copy), v3 (copy), v4 (copy), v5 (copy), Center (copy)
        local TextButton = Instance.new("TextButton")

        TextButton.Name = "Close"
        TextButton.Text = ""
        TextButton.BackgroundTransparency = 1
        TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
        TextButton.Position = UDim2.fromOffset(p87, p88)
        TextButton.Size = UDim2.fromOffset(p89, p90)
        TextButton.ZIndex = p92
        TextButton.Parent = p86

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "ClosePlate"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Size = UDim2.fromScale(1, 1)
        ImageLabel.ImageColor3 = v3
        ImageLabel.ZIndex = p92
        ImageLabel.Parent = TextButton

        local ref_top_plate = RaceIcons.Get("ref_top_plate")

        if ref_top_plate then
            ImageLabel.ImageContent = ref_top_plate
        else
            ImageLabel.BackgroundTransparency = 0
            ImageLabel.BackgroundColor3 = v3
        end

        local v126 = text(TextButton, "X", "X", 0, 0, p89, p90, p91, v4)

        v126.TextXAlignment = Center
        v126.ZIndex = p92 + 1

        local function hover(p93) -- line: 391
            -- upvalues: ImageLabel (copy), v126 (copy), TweenService (copy), v3 (copy), v4 (copy), v5 (copy)
            TweenService:Create(ImageLabel, TweenInfo.new(0.18), {
                ImageColor3 = p93 and v5 or v3,
                BackgroundColor3 = p93 and v5 or v3
            }):Play()
            TweenService:Create(v126, TweenInfo.new(0.18), {
                TextColor3 = p93 and v3 or v4
            }):Play()
        end

        pressable(TextButton, hover)

        return TextButton, function() -- reset | line: 396
            -- upvalues: ImageLabel (copy), v126 (copy), v3 (copy), v4 (copy)
            ImageLabel.ImageColor3 = v3

            if ImageLabel.BackgroundTransparency < 1 then
                ImageLabel.BackgroundColor3 = v3
            end

            v126.TextColor3 = v4
        end
    end

    local Frame3 = Instance.new("Frame")

    Frame3.Name = "ShopPanel"
    Frame3.BorderSizePixel = 0
    Frame3.BackgroundColor3 = v4 or v3
    Frame3.Position = UDim2.fromOffset(240, 147)
    Frame3.Size = UDim2.fromOffset(1520, 832)
    Frame3.ZIndex = 1
    Frame3.Parent = Frame2
    Frame3.Active = true
    Frame3.ClipsDescendants = true

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, 26)
    UICorner.Parent = Frame3

    local UIScale2 = Instance.new("UIScale", Frame3)

    t1.PanelScale = 1.2
    Frame3.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame3.Position = UDim2.fromOffset(1000, 563)
    UIScale2.Scale = t1.PanelScale

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Halftone"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0)
    ImageLabel.Position = UDim2.fromOffset(760, 30)
    ImageLabel.Size = UDim2.fromOffset(780, 805)
    ImageLabel.ZIndex = 1
    ImageLabel.Parent = Frame3
    UIArt.Apply(ImageLabel, "LegendsDots")
    ImageLabel = text(Frame3, "Title", "SHOP", 160, 42, 1200, 44, 36)
    ImageLabel.TextXAlignment = Center
    ImageLabel.ZIndex = 6

    local v129, v130 = closeButton(Frame3, 1439, 56, 94, 50, 31, 20)
    local Frame4 = Instance.new("Frame")

    Frame4.Name = "Categories"
    Frame4.BackgroundTransparency = 1
    Frame4.Position = UDim2.fromOffset(0, 112)
    Frame4.Size = UDim2.fromOffset(300, 696)
    Frame4.ZIndex = 4
    Frame4.Parent = Frame3

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Frame4
    UIListLayout = Color3.fromRGB(44, 46, 54)

    local Frame5 = Instance.new("Frame")

    Frame5.Name = "Separator"
    Frame5.BorderSizePixel = 0
    Frame5.BackgroundColor3 = UIListLayout or v3
    Frame5.Position = UDim2.fromOffset(306, 112)
    Frame5.Size = UDim2.fromOffset(3, 696)
    Frame5.ZIndex = 4
    Frame5.Parent = Frame3

    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = "Items"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Position = UDim2.fromOffset(316, 104)
    ScrollingFrame.Size = UDim2.fromOffset(1190, 714)
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.ScrollBarThickness = 6
    ScrollingFrame.ScrollBarImageColor3 = v3
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.None
    ScrollingFrame.ZIndex = 4
    ScrollingFrame.Parent = Frame3
    Frame5 = Instance.new("UIListLayout")
    Frame5.SortOrder = Enum.SortOrder.LayoutOrder
    Frame5.Padding = UDim.new(0, 44)
    Frame5.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Frame5.Parent = ScrollingFrame
    Frame5 = Instance.new("UIPadding")
    Frame5.PaddingTop = UDim.new(0, 20)
    Frame5.PaddingBottom = UDim.new(0, 56)
    Frame5.PaddingLeft = UDim.new(0, 14)
    Frame5.Parent = ScrollingFrame

    local t21 = {}

    local function section(p94, p95, p96) -- line: 427
        -- upvalues: UIScale (copy), text (copy), UIScale2 (copy), Frame4 (copy), ScrollingFrame (copy), t21 (copy), TweenService (copy), v2 (copy), v3 (copy), v5 (copy)
        local Frame = Instance.new("Frame")

        Frame.Name = "Section_" .. p94
        Frame.BackgroundTransparency = 1
        Frame.Size = UDim2.fromOffset(870, 447)
        Frame.LayoutOrder = p95
        Frame.ZIndex = 4
        Frame.Parent = ScrollingFrame
        text(Frame, "Title", p94, 0, 0, 870, 36, 30).ZIndex = 5

        local t22 = {
            frame = Frame
        }
        local TextButton = Instance.new("TextButton")

        TextButton.Name = "Cat_" .. p96
        TextButton.AutoButtonColor = false
        TextButton:SetAttribute("NoHover", true)
        TextButton.BorderSizePixel = 0
        TextButton.Size = UDim2.new(1, 0, 0, 66)
        TextButton.LayoutOrder = p95
        TextButton.BackgroundColor3 = v5
        TextButton.BackgroundTransparency = 1
        TextButton.Text = p96
        TextButton.FontFace = v2
        TextButton.TextSize = 30
        TextButton.TextColor3 = v3
        TextButton.TextXAlignment = Enum.TextXAlignment.Left
        TextButton.AutoLocalize = false
        TextButton.ZIndex = 5
        TextButton.Parent = Frame4

        local UIPadding = Instance.new("UIPadding")

        UIPadding.PaddingLeft = UDim.new(0, 40)
        UIPadding.Parent = TextButton
        TextButton.MouseEnter:Connect(function() -- line: 435
            -- upvalues: t22 (copy)
            t22.hover = true
        end)
        TextButton.MouseLeave:Connect(function() -- line: 435
            -- upvalues: t22 (copy)
            t22.hover = false
        end)
        TextButton.Activated:Connect(function() -- line: 436
            -- upvalues: Frame (copy), UIScale (copy), UIScale2 (copy), ScrollingFrame (copy), TweenService (copy)
            local v131 = Frame.AbsolutePosition.Y - ScrollingFrame.AbsolutePosition.Y + ScrollingFrame.CanvasPosition.Y - 20 * UIScale.Scale * UIScale2.Scale
            local v133 = math.max(0, ScrollingFrame.AbsoluteCanvasSize.Y - ScrollingFrame.AbsoluteWindowSize.Y)

            TweenService:Create(ScrollingFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                CanvasPosition = Vector2.new(0, (math.clamp(v131, 0, v133)))
            }):Play()
        end)
        t22.button = TextButton
        table.insert(t21, t22)

        return Frame
    end

    local t23 = {}
    local v134

    local function card(p97, p98, p99) -- line: 450
        -- upvalues: t18 (copy), text (copy), pressable (copy), t23 (copy), v134 (ref), TweenService (copy), UIArt (copy), ShopCatalog (copy), v3 (copy), v4 (copy), v5 (copy), Center (copy), makeAura (copy), emblem (copy), addShine (copy), buildPreviewBottle (copy)
        local v135 = ShopCatalog.ByKey(p99)
        local t24 = {
            key = p99,
            item = v135
        }
        local TextButton = Instance.new("TextButton")

        TextButton.Name = "Card_" .. p99
        TextButton.Text = ""
        TextButton.BackgroundTransparency = 1
        TextButton.Size = UDim2.fromOffset(274, 395)
        TextButton.Position = UDim2.fromOffset((p98 - 1) * 298, 52)
        TextButton.ZIndex = 5
        TextButton.Parent = p97

        local Frame = Instance.new("Frame")

        Frame.Name = "Base"
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = v3 or v3
        Frame.Position = UDim2.fromOffset(0, 0)
        Frame.Size = UDim2.fromOffset(274, 395)
        Frame.ZIndex = 5
        Frame.Parent = TextButton

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0, 18)
        UICorner.Parent = Frame

        local Frame2 = Instance.new("Frame")

        Frame2.Name = "Art"
        Frame2.BorderSizePixel = 0
        Frame2.BackgroundColor3 = v3 or v3
        Frame2.Position = UDim2.fromOffset(8, 8)
        Frame2.Size = UDim2.fromOffset(258, 309)
        Frame2.ZIndex = 6
        Frame2.Parent = TextButton

        local UICorner2 = Instance.new("UICorner")

        UICorner2.CornerRadius = UDim.new(0, 12)
        UICorner2.Parent = Frame2

        local Frame3 = Instance.new("Frame")

        Frame3.Name = "ArtBottom"
        Frame3.BorderSizePixel = 0
        Frame3.BackgroundColor3 = v3 or v3
        Frame3.Position = UDim2.fromOffset(8, 303)
        Frame3.Size = UDim2.fromOffset(258, 14)
        Frame3.ZIndex = 6
        Frame3.Parent = TextButton

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = 90
        UIGradient.Parent = Frame2

        local v136 = v135.kind == "Bottle" and ShopCatalog.Bottles[v135.id]
        local Top, v137

        if v136 then
            if v136.Gradient then
                v137 = true
            else
                Top = v136.Top or ShopCatalog.CashTop
                v137 = false
            end
        else
            Top = ShopCatalog.CashTop
            v137 = false
        end

        if v137 then
            UIGradient.Color = v136.Gradient
        else
            local Bottom = if v136 then v136.Bottom else nil

            if not v136 or not Bottom then
                Bottom = ShopCatalog.CashBottom
            end

            UIGradient.Color = ColorSequence.new(Top, Bottom)
        end

        local Keypoints = UIGradient.Color.Keypoints

        Frame3.BackgroundColor3 = Keypoints[#Keypoints].Value
        Frame2.ClipsDescendants = true

        if v136 then
            local v138 = text(Frame2, "Name", v136.Short .. "\nBOTTLE", 0, 215, 258, 72, 30)

            v138.TextXAlignment = Center
            v138.LineHeight = 1
            v138.ZIndex = 8

            local ViewportFrame = Instance.new("ViewportFrame")

            ViewportFrame.Name = "Preview3D"
            ViewportFrame.BackgroundTransparency = 1
            ViewportFrame.AnchorPoint = Vector2.new(0.5, 0)
            ViewportFrame.Position = UDim2.new(0.5, 0, 0, 2)
            ViewportFrame.Size = UDim2.fromOffset(240, 214)
            ViewportFrame.ZIndex = 8
            ViewportFrame.Ambient = Color3.fromRGB(205, 205, 210)
            ViewportFrame.LightColor = Color3.fromRGB(255, 255, 255)
            ViewportFrame.LightDirection = Vector3.new(-0.5, -0.6, 1)
            ViewportFrame.Parent = Frame2

            local v139, v140 = buildPreviewBottle(v136)

            v139.Parent = ViewportFrame

            local Camera = Instance.new("Camera")

            Camera.FieldOfView = 30
            Camera.CFrame = CFrame.lookAt(Vector3.new(0, 0.1, -4.1), (Vector3.new(0, -0.02, 0)))
            Camera.Parent = ViewportFrame
            ViewportFrame.CurrentCamera = Camera
            t24.preview = {
                model = v139,
                glass = v136.Rainbow and v140 or nil,
                phase = (p98 - 1) * 0.9
            }
            t24.emblem = emblem(Frame2, p99, 129, 109)
            t24.aura = makeAura(Frame2, p99, UDim2.new(0.5, 0, 0, 109), UDim2.fromOffset(200, 214))
        else
            local ImageLabel = Instance.new("ImageLabel")

            ImageLabel.Name = "Cash"
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0)
            ImageLabel.Position = UDim2.new(0.5, 0, 0, 36)
            ImageLabel.Size = UDim2.fromOffset(176, 152)
            ImageLabel.ScaleType = Enum.ScaleType.Fit
            ImageLabel.ZIndex = 8
            ImageLabel.Parent = Frame2
            UIArt.Apply(ImageLabel, "CashStack")

            local v141 = text(Frame2, "Amount", ShopCatalog.Money(v135.amount), 0, 209, 258, 42, 32)

            v141.TextXAlignment = Center
            v141.ZIndex = 8
        end

        t24.shine = addShine(Frame2, 10)

        local Frame4 = Instance.new("Frame")

        Frame4.Name = "Price"
        Frame4.BackgroundTransparency = 1
        Frame4.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame4.Position = UDim2.fromOffset(137, 352)
        Frame4.Size = UDim2.fromOffset(0, 48)
        Frame4.AutomaticSize = Enum.AutomaticSize.X
        Frame4.ZIndex = 7
        Frame4.Parent = TextButton

        local UIListLayout = Instance.new("UIListLayout")

        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        UIListLayout.Padding = UDim.new(0, 10)
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Parent = Frame4

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Robux"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Size = UDim2.fromOffset(36, 40)
        ImageLabel.ImageColor3 = v4
        ImageLabel.ZIndex = 8
        ImageLabel.LayoutOrder = 1
        ImageLabel.Parent = Frame4
        UIArt.Apply(ImageLabel, "RobuxIcon")

        local v142 = text(Frame4, "Value", tostring(v135.price), 0, 0, 0, 48, 38, v4)

        v142.AutomaticSize = Enum.AutomaticSize.X
        v142.ZIndex = 8
        v142.LayoutOrder = 2
        t24.robux = ImageLabel
        t24.price = v142

        local ImageButton = Instance.new("ImageButton")

        ImageButton.Name = "Gift"
        ImageButton.BackgroundTransparency = 1
        ImageButton.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageButton.Position = UDim2.fromOffset(224, 30)
        ImageButton.Size = UDim2.fromOffset(92, 50)
        ImageButton.ScaleType = Enum.ScaleType.Fit
        ImageButton.ZIndex = 12
        ImageButton.Parent = TextButton
        UIArt.Apply(ImageButton, "GiftTag")
        pressable(ImageButton, function(p100) -- line: 504
            -- upvalues: ImageButton (copy), TweenService (copy), v3 (copy), v5 (copy)
            TweenService:Create(ImageButton, TweenInfo.new(0.15), {
                ImageColor3 = p100 and v5 or v3
            }):Play()
        end)
        ImageButton.Activated:Connect(function() -- line: 505
            -- upvalues: p99 (copy), v134 (ref)
            v134(p99)
        end)
        Instance.new("UIScale", TextButton)
        pressable(TextButton, function(p101) -- line: 510
            -- upvalues: t24 (copy), Frame (copy), ImageLabel (copy), v142 (copy), TweenService (copy), v3 (copy), v4 (copy), v5 (copy)
            t24.hover = p101
            TweenService:Create(Frame, TweenInfo.new(0.15), {
                BackgroundColor3 = p101 and v5 or v3
            }):Play()

            local v145 = t24.stripColor or v4
            local v146 = TweenInfo.new(0.15)
            local v147 = if p101 then v3 else nil

            if p101 and v147 then
                v145 = v147
            end

            TweenService:Create(v142, v146, {
                TextColor3 = v145
            }):Play()
            TweenService:Create(ImageLabel, TweenInfo.new(0.15), {
                ImageColor3 = p101 and v3 or v4
            }):Play()
        end)
        TextButton.Activated:Connect(function() -- line: 517
            -- upvalues: p99 (copy), t18 (copy)
            t18.Choose(p99)
        end)
        t24.button = TextButton
        t24.base = Frame
        t23[p99] = t24

        return t24
    end

    local _require = require
    local ok, result = pcall(_require, Parent:WaitForChild("RaceNametags"))
    local v149 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)

    local function tagPreview(p102, p103, p104, p105, p106, p107, p108) -- line: 527
        -- upvalues: LocalPlayer (copy), ok (copy), result (copy), v149 (copy), v3 (copy), v4 (copy)
        local function width(p109) -- line: 528
            return (math.clamp(math.ceil(p109) + 34, 90, 175))
        end

        local Frame = Instance.new("Frame")

        Frame.Name = "TagPreview"
        Frame.BackgroundTransparency = 1
        Frame.AnchorPoint = Vector2.new(p107, 0.5)
        Frame.Position = UDim2.fromOffset(p105, p106)
        Frame.ZIndex = p108 or 9
        Frame.Parent = p102
        Frame.Size = UDim2.fromOffset(math.clamp(math.ceil(game:GetService("TextService"):GetTextSize(LocalPlayer.DisplayName, 14, Enum.Font.GothamBlack, Vector2.new(400, 30)).X * 1.1) + 34, 90, 175), 30)

        local UIScale = Instance.new("UIScale")

        UIScale.Scale = p104
        UIScale.Parent = Frame
        task.spawn(function() -- line: 533
            -- upvalues: Frame (copy), LocalPlayer (copy), v149 (copy)
            local function v153() -- line: 534
                -- upvalues: LocalPlayer (copy), v149 (copy)
                local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

                GetTextBoundsParams.Text = LocalPlayer.DisplayName
                GetTextBoundsParams.Font = v149
                GetTextBoundsParams.Size = 14
                GetTextBoundsParams.Width = 400

                return game:GetService("TextService"):GetTextBoundsAsync(GetTextBoundsParams)
            end

            local ok, result = pcall(v153)

            if ok and typeof(result) == "Vector2" and Frame.Parent then
                Frame.Size = UDim2.fromOffset(math.clamp(math.ceil(result.X) + 34, 90, 175), 30)
            end
        end)

        local Frame2 = Instance.new("Frame")

        Frame2.Name = "Panel"
        Frame2.BorderSizePixel = 0
        Frame2.BackgroundColor3 = v4
        Frame2.BackgroundTransparency = 0.5
        Frame2.Size = UDim2.fromScale(1, 1)
        Frame2.ZIndex = p108 or 9
        Frame2.Parent = Frame

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0, 6)
        UICorner.Parent = Frame2

        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = "PlayerName"
        TextLabel.BackgroundTransparency = 1
        TextLabel.Position = UDim2.fromOffset(15, 0)
        TextLabel.Size = UDim2.new(1, -21, 1, 0)
        TextLabel.FontFace = v149
        TextLabel.TextSize = 14
        TextLabel.TextColor3 = v3
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
        TextLabel.AutoLocalize = false
        TextLabel.Text = LocalPlayer.DisplayName
        TextLabel.ZIndex = 1
        TextLabel.Parent = Frame2

        local v155, v156, v157

        if ok then
            local SetRole = result.SetRole
            local v158, v159, v160, v161 = pcall(SetRole, Frame, p103)

            if v158 then
                v155 = v159
                v156 = v160
                v157 = v161
            end
        end

        return {
            holder = Frame,
            step = function(p110) -- step | line: 545
                -- upvalues: v155 (ref), v156 (ref), v157 (ref), ok (copy), result (copy)
                if v155 and v155.Parent then
                    local v163 = math.clamp(p110 % 3 / 1.8, 0, 1)
                    local v164 = v163 * v163 * (3 - v163 * 2)
                    local v165 = v155

                    v165.Offset = Vector2.new(v164 * 2.4 + -1.2, 0)
                end

                if ok and v156 and v156.Parent then
                    local StepGlow = result.StepGlow
                    local v166 = v156

                    StepGlow(v166, p110, math.sin(p110 * 3.2) * 0.5 + 0.5, 1)
                end

                if ok and v157 then
                    result.StepFx(v157, p110, 1)
                end
            end
        }
    end

    local Frame6, ok2, result2, v168, v169, v170, ViewportFrame, v171, v172, v173, v174, Part, Frame7, Nametag, Frame8, TextButton, Frame9

    if ShopCatalog.Vip then
        local Vip = ShopCatalog.Vip
        local VIP = section("VIP", 0, "VIP")

        VIP.Size = UDim2.fromOffset(870, 412)

        local t30 = {
            key = Vip.Key,
            item = ShopCatalog.ByKey(Vip.Key)
        }
        local TextButton2 = Instance.new("TextButton")

        TextButton2.Name = "Card_VIP"
        TextButton2.Text = ""
        TextButton2.BackgroundTransparency = 1
        TextButton2.Size = UDim2.fromOffset(870, 360)
        TextButton2.Position = UDim2.fromOffset(0, 52)
        TextButton2.ZIndex = 5
        TextButton2.Parent = VIP

        local Frame = Instance.new("Frame")

        Frame.Name = "Base"
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = v3 or v3
        Frame.Position = UDim2.fromOffset(0, 0)
        Frame.Size = UDim2.fromOffset(870, 360)
        Frame.ZIndex = 5
        Frame.Parent = TextButton2

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0, 18)
        UICorner.Parent = Frame

        local Frame2 = Instance.new("Frame")

        Frame2.Name = "Art"
        Frame2.BorderSizePixel = 0
        Frame2.BackgroundColor3 = v3 or v3
        Frame2.Position = UDim2.fromOffset(8, 8)
        Frame2.Size = UDim2.fromOffset(854, 344)
        Frame2.ZIndex = 6
        Frame2.Parent = TextButton2

        local v175 = Instance.new("UICorner")

        v175.CornerRadius = UDim.new(0, 12)
        v175.Parent = Frame2
        Frame2.ClipsDescendants = true
        v175 = Instance.new("UIGradient")
        v175.Rotation = 0
        v175.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(3, 2, 6)),
            ColorSequenceKeypoint.new(0.45, Color3.fromRGB(10, 6, 12)),
            ColorSequenceKeypoint.new(0.8, Color3.fromRGB(34, 16, 6)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 32, 6))
        })
        v175.Parent = Frame2
        v175 = Color3.fromRGB(255, 150, 40)

        local t31 = {}

        for _ = 1, 48 do
            local v176, v177

            repeat
                v176 = math.random(6, 848)
                v177 = math.random(6, 338)
            until (Vector2.new(v176, v177) - Vector2.new(138, 172)).Magnitude > 120

            local v178 = if math.random() < 0.15 then 4 elseif math.random() < 0.5 then 3 else 2

            Frame6 = Instance.new("Frame")
            Frame6.Name = "Star"
            Frame6.BorderSizePixel = 0
            Frame6.BackgroundColor3 = v3 or v3
            Frame6.Position = UDim2.fromOffset(v176, v177)
            Frame6.Size = UDim2.fromOffset(v178, v178)
            Frame6.ZIndex = 6
            Frame6.Parent = Frame2
            TextButton = Instance.new("UICorner")
            TextButton.CornerRadius = UDim.new(0, v178)
            TextButton.Parent = Frame6
            ViewportFrame = {
                f = Frame6,
                ph = math.random() * 6.28,
                sp = 0.8 + math.random() * 2.2,
                base = 0.15 + math.random() * 0.5
            }
            table.insert(t31, ViewportFrame)
        end

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "DiskGlow"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Position = UDim2.fromOffset(138, 172)
        ImageLabel.Size = UDim2.fromOffset(380, 380)
        ImageLabel.ImageColor3 = v175
        ImageLabel.ImageTransparency = 0.35
        ImageLabel.ZIndex = 6
        ImageLabel.Parent = Frame2

        if v11 == nil then
            v11 = false

            result2 = function() -- line: 64
                local v179 = buffer.create(16384)

                for i = 0, 63 do
                    for j = 0, 63 do
                        local v180 = (j + 0.5) / 64 * 2 - 1
                        local v181 = (i + 0.5) / 64 * 2 - 1
                        local v186 = math.floor(math.clamp(1 - math.sqrt(v180 * v180 + v181 * v181), 0, 1) ^ 2.2 * 255 + 0.5) * 16777216 + 16777215

                        buffer.writeu32(v179, (i * 64 + j) * 4, v186)
                    end
                end

                local v187 = game:GetService("AssetService"):CreateEditableImage({
                    Size = Vector2.new(64, 64)
                })

                v187:WritePixelsBuffer(Vector2.zero, Vector2.new(64, 64), v179)

                return Content.fromObject(v187)
            end

            ok2, result2 = pcall(result2)

            if ok2 then
                v11 = result2
            end
        end

        v168 = v11

        if v168 then
            ImageLabel.ImageContent = v168
        else
            ImageLabel.Image = "rbxasset://textures/particles/smoke_main.dds"
        end

        v168 = Instance.new("Frame")
        v168.Name = "Rays"
        v168.BackgroundTransparency = 1
        v168.AnchorPoint = Vector2.new(0.5, 0.5)
        v168.Position = UDim2.fromOffset(138, 172)
        v168.Size = UDim2.fromOffset(10, 10)
        v168.ZIndex = 6
        v168.Parent = Frame2

        local v188 = rays(v168, 9, 560, 24, Color3.fromRGB(255, 170, 60), 0.72, 6)

        local function ring(p111, p112, p113, p114) -- line: 588
            -- upvalues: Frame2 (copy), v3 (copy), v4 (copy)
            local Frame = Instance.new("Frame")

            Frame.Name = "Ring"
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = v4 or v3
            Frame.Position = UDim2.fromOffset(0, 0)
            Frame.Size = UDim2.fromOffset(p111, p111)
            Frame.ZIndex = p114 or 5
            Frame.Parent = Frame2
            Frame.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame.Position = UDim2.fromOffset(138, 172)
            Frame.BackgroundTransparency = 1

            local v189 = p111 / 2
            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(0, v189)
            UICorner.Parent = Frame

            local UIStroke = Instance.new("UIStroke")

            UIStroke.Thickness = p112
            UIStroke.Color = v3
            UIStroke.Transparency = p113
            UIStroke.Parent = Frame

            local UIGradient = Instance.new("UIGradient")

            UIGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 96, 8)),
                ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 190, 30)),
                ColorSequenceKeypoint.new(0.32, Color3.fromRGB(255, 248, 205)),
                ColorSequenceKeypoint.new(0.44, Color3.fromRGB(255, 190, 30)),
                ColorSequenceKeypoint.new(0.62, Color3.fromRGB(255, 110, 10)),
                ColorSequenceKeypoint.new(0.8, Color3.fromRGB(255, 210, 60)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 96, 8))
            })
            UIGradient.Parent = UIStroke

            return UIGradient, Frame, UIStroke
        end

        local v190, v191 = ring(222, 3, 0.5, 7)
        local v192, _, v193 = ring(164, 10, 0, 8)
        local t32 = {}

        for _ = 1, 18 do
            Frame9 = Instance.new("ImageLabel")
            Frame9.Name = "Infall"
            Frame9.BackgroundTransparency = 1
            Frame9.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame9.Image = "rbxasset://textures/particles/sparkles_main.dds"
            Frame9.ZIndex = 8
            Frame9.Parent = Frame2
            v169 = {
                f = Frame9,
                ph = math.random(),
                sp = 0.12 + math.random() * 0.12,
                a0 = math.random() * 6.28
            }

            local v194 = math.random() < 0.5

            if v194 then
                v170 = Color3.fromRGB(255, 220, 140)
            end

            if not v194 or not v170 then
                v169.col = v175
            else
                v169.col = v170
            end

            table.insert(t32, v169)
        end

        local v195 = Color3.fromRGB(4, 3, 6)

        ViewportFrame = Instance.new("Frame")
        ViewportFrame.Name = "Core"
        ViewportFrame.BorderSizePixel = 0
        ViewportFrame.BackgroundColor3 = v195 or v3
        ViewportFrame.Position = UDim2.fromOffset(0, 0)
        ViewportFrame.Size = UDim2.fromOffset(150, 150)
        ViewportFrame.ZIndex = 9
        ViewportFrame.Parent = Frame2
        ViewportFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        ViewportFrame.Position = UDim2.fromOffset(138, 172)
        v195 = Instance.new("UICorner")
        v195.CornerRadius = UDim.new(0, 75)
        v195.Parent = ViewportFrame
        ViewportFrame.ClipsDescendants = true

        local ImageLabel2 = Instance.new("ImageLabel")

        ImageLabel2.Name = "InnerGlow"
        ImageLabel2.BackgroundTransparency = 1
        ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel2.Position = UDim2.fromScale(0.5, 0.5)
        ImageLabel2.Size = UDim2.fromOffset(150, 150)
        ImageLabel2.ImageColor3 = Color3.fromRGB(255, 170, 70)
        ImageLabel2.ImageTransparency = 0.55
        ImageLabel2.ZIndex = 9
        ImageLabel2.Parent = ViewportFrame

        if v11 == nil then
            v11 = false

            Frame6 = function() -- line: 64
                local v196 = buffer.create(16384)

                for i = 0, 63 do
                    for j = 0, 63 do
                        local v197 = (j + 0.5) / 64 * 2 - 1
                        local v198 = (i + 0.5) / 64 * 2 - 1
                        local v203 = math.floor(math.clamp(1 - math.sqrt(v197 * v197 + v198 * v198), 0, 1) ^ 2.2 * 255 + 0.5) * 16777216 + 16777215

                        buffer.writeu32(v196, (i * 64 + j) * 4, v203)
                    end
                end

                local v204 = game:GetService("AssetService"):CreateEditableImage({
                    Size = Vector2.new(64, 64)
                })

                v204:WritePixelsBuffer(Vector2.zero, Vector2.new(64, 64), v196)

                return Content.fromObject(v204)
            end

            ViewportFrame, Frame6 = pcall(Frame6)

            if ViewportFrame then
                v11 = Frame6
            end
        end

        v175 = v11

        if v175 then
            ImageLabel2.ImageContent = v175
        else
            ImageLabel2.Image = "rbxasset://textures/particles/smoke_main.dds"
        end

        ViewportFrame = Instance.new("ViewportFrame")
        ViewportFrame.Name = "Bottle3D"
        ViewportFrame.BackgroundTransparency = 1
        ViewportFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        ViewportFrame.Position = UDim2.fromOffset(138, 172)
        ViewportFrame.Size = UDim2.fromOffset(260, 260)
        ViewportFrame.ZIndex = 11
        ViewportFrame.Ambient = Color3.fromRGB(150, 140, 135)
        ViewportFrame.LightColor = Color3.fromRGB(255, 215, 160)
        ViewportFrame.LightDirection = Vector3.new(-0.5, -0.6, 1)
        ViewportFrame.Parent = Frame2

        local v205 = buildPreviewBottle(ShopCatalog.Bottles[Vip.Bottle])

        v205.Parent = ViewportFrame

        local v206 = makeAura(Frame2, Vip.Bottle, UDim2.fromOffset(138, 176), UDim2.fromOffset(190, 200))

        if v206 then
            v206.front.ZIndex = 13
            v206.holder.ZIndex = 7

            for _, v207 in v206.orbs do
                v207.near:Destroy()
                v207.far:Destroy()
            end

            v206.orbs = {}
        end

        local t33 = {}
        local t34 = {}
        local v208
        local t35 = {}

        v171 = {
            Color3.fromRGB(255, 248, 210),
            Color3.fromRGB(255, 192, 30),
            Color3.fromRGB(255, 110, 10)
        }

        for i = 1, 4 do
            v173 = if i % 2 == 0 then -1 else 1
            v172 = {
                amp = 0.336,
                phase = (i - 1) / 4 * 3.141592653589793 * 2,
                speed = v173 * (i * 0.55 + 3.6),
                x = ((i - 1) * 0.4 / 3 + -0.2) * 1.2,
                wave = i * 0.3 + 1.4,
                r = (i * 0.1 + 1.3) * 0.31,
                dots = {}
            }

            for j = 1, 9 do
                v173 = (j - 1) / 8

                local v209 = v173 < 0.5

                if v209 then
                    v174 = v171[1]:Lerp(v171[2], v173 * 2)
                end

                local v210 = if not v209 or not v174 then v171[2]:Lerp(v171[3], (v173 - 0.5) * 2) else v174

                Part = Instance.new("Part")
                Part.Name = "BHRibbon"
                Part.Shape = Enum.PartType.Ball
                Part.Material = Enum.Material.Neon
                Part.Color = v210
                Part.Transparency = v173 * 0.85 + 0.05
                Part.Anchored = true
                Part.CanCollide = false
                Part.CanQuery = false
                Part.CanTouch = false
                Part.CastShadow = false
                v210 = (1 - v173 * 0.8) * 0.075
                Part.Size = Vector3.new(v210, v210, v210)
                Part.Parent = ViewportFrame
                table.insert(v172.dots, {
                    p = Part,
                    lag = v173 * 0.32
                })
            end

            table.insert(t35, v172)
        end

        local v211

        for _, v212 in {
                {
                    Color3.fromRGB(255, 242, 180),
                    0.18, 2.5, 0.06
                },
                {
                    Color3.fromRGB(255, 190, 40),
                    0.36, 3.5, 0.045
                },
                {
                    Color3.fromRGB(255, 122, 15),
                    0.6, 4.6, 0.03
                },
                {
                    Color3.fromRGB(190, 70, 10),
                    0.84, 5.8, 0.018
                }
            } do
            v172 = Instance.new("Part")
            v172.Name = "BHDisk"
            v172.Shape = Enum.PartType.Cylinder
            v172.Material = Enum.Material.Neon
            v172.Color = v212[1]
            v172.Transparency = v212[2]
            v172.Anchored = true
            v172.CanCollide = false
            v172.CanQuery = false
            v172.CanTouch = false
            v172.CastShadow = false

            local v213 = v212[4]

            v211 = 0.41850000000000004 * v212[3]
            v174 = 0.41850000000000004 * v212[3]
            v172.Size = Vector3.new(v213, v211, v174)
            v172.Parent = ViewportFrame
            v211 = v212[2] - 0.12
            v172.Transparency = math.max(0, v211)
            table.insert(t33, v172)
        end

        for _ = 1, 7 do
            Frame8 = 0.41850000000000004 * (1.4 + math.random() * 1.3)
            v173 = {
                r = Frame8,
                th = math.random() * 3.141592653589793 * 2,
                w = 7 / (Frame8 / 0.41850000000000004) ^ 1.5,
                dots = {}
            }

            for i = 1, 4 do
                v211 = Instance.new("Part")
                v211.Name = "BHStreak"
                v211.Shape = Enum.PartType.Ball
                v211.Material = Enum.Material.Neon
                v211.Color = Color3.fromRGB(255, 250, 220):Lerp(Color3.fromRGB(255, 110, 10), (i - 1) / 3)
                v211.Transparency = (i - 1) * 0.22
                v211.Anchored = true
                v211.CanCollide = false
                v211.CanQuery = false
                v211.CanTouch = false
                v211.CastShadow = false

                local v214 = (1 - (i - 1) * 0.2) * 0.05

                v211.Size = Vector3.new(v214, v214, v214)
                v211.Parent = ViewportFrame
                Part = v173.dots
                table.insert(Part, v211)
            end

            table.insert(t34, v173)
        end

        v171 = Instance.new("Camera")
        v171.FieldOfView = 46
        v171.CFrame = CFrame.lookAt(Vector3.new(0, 1.05, -3.98), (Vector3.new(0, -0.02, 0)))
        v171.Parent = ViewportFrame
        ViewportFrame.CurrentCamera = v171
        v171 = Color3.fromRGB(255, 196, 40)
        Frame7 = Instance.new("Frame")
        Frame7.Name = "VipChip"
        Frame7.BorderSizePixel = 0
        Frame7.BackgroundColor3 = v171 or v3
        Frame7.Position = UDim2.fromOffset(0, 0)
        Frame7.Size = UDim2.fromOffset(74, 28)
        Frame7.ZIndex = 14
        Frame7.Parent = Frame2
        Frame7.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame7.Position = UDim2.fromOffset(138, 254)
        v171 = Instance.new("UICorner")
        v171.CornerRadius = UDim.new(0, 14)
        v171.Parent = Frame7
        v171 = Instance.new("UIStroke")
        v171.Color = Color3.fromRGB(40, 20, 0)
        v171.Thickness = 2
        v171.Parent = Frame7
        v171 = text(Frame7, "VIP", "VIP", 0, 0, 74, 28, 20, Color3.fromRGB(30, 16, 0))
        v171.TextXAlignment = Center
        v171.ZIndex = 15
        v171 = text(Frame2, "Title", Vip.Name, 262, 34, 560, 42, 34)
        v171.ZIndex = 8
        Frame7 = Instance.new("UIGradient")
        Frame7.Rotation = 90
        Frame7.Color = ColorSequence.new(Color3.fromRGB(255, 250, 225), Color3.fromRGB(255, 190, 70))
        Frame7.Parent = v171
        text(Frame2, "Sub", "+" .. Vip.Days .. " DAYS PER BUY · MAX " .. Vip.MaxDays .. " DAYS", 264, 76, 560, 22, 17, Color3.fromRGB(235, 210, 170), v2).ZIndex = 8

        for v215, v216 in {
                "INSTANTLY OBTAIN " .. ShopCatalog.Money(Vip.Instant),
                "EARN " .. ShopCatalog.Money(Vip.Daily) .. " DAILY",
                "BLACK HOLE NAMETAG",
                "BLACK HOLE BOTTLE"
            } do
            text(Frame2, "Perk" .. v215, "•  " .. v216, 264, 110 + (v215 - 1) * 30, 420, 28, 20).ZIndex = 8
        end

        text(Frame2, "Note", "NAMETAG + BOTTLE WHILE VIP IS ACTIVE", 264, 310, 330, 20, 13, Color3.fromRGB(200, 180, 150), v2).ZIndex = 8
        Nametag = Vip.Nametag or "vip"

        local v217 = tagPreview(Frame2, Nametag, 1.6, 264, 268, 0, 9)
        local v218 = text(Frame2, "Status", "", 544, 300, 290, 26, 17)

        v218.TextXAlignment = Enum.TextXAlignment.Right
        v218.ZIndex = 8

        local Frame3 = Instance.new("Frame")

        Frame3.Name = "PricePill"
        Frame3.BorderSizePixel = 0
        Frame3.BackgroundColor3 = v3 or v3
        Frame3.Position = UDim2.fromOffset(624, 216)
        Frame3.Size = UDim2.fromOffset(210, 66)
        Frame3.ZIndex = 8
        Frame3.Parent = Frame2
        Frame8 = Instance.new("UICorner")
        Frame8.CornerRadius = UDim.new(0, 33)
        Frame8.Parent = Frame3

        if Vip.WasPrice then
            v174 = Vip.WasPrice
            Frame8 = text(Frame2, "WasPrice", "<s>" .. tostring(v174) .. "</s>", 624, 178, 210, 36, 30, Color3.fromRGB(255, 60, 60))
            Frame8.RichText = true
            Frame8.TextXAlignment = Center
            Frame8.ZIndex = 8
        end

        Frame8 = Instance.new("Frame")
        Frame8.Name = "Price"
        Frame8.BackgroundTransparency = 1
        Frame8.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame8.Position = UDim2.fromScale(0.5, 0.5)
        Frame8.Size = UDim2.fromOffset(0, 48)
        Frame8.AutomaticSize = Enum.AutomaticSize.X
        Frame8.ZIndex = 9
        Frame8.Parent = Frame3
        v173 = Instance.new("UIListLayout")
        v173.FillDirection = Enum.FillDirection.Horizontal
        v173.VerticalAlignment = Enum.VerticalAlignment.Center
        v173.Padding = UDim.new(0, 10)
        v173.SortOrder = Enum.SortOrder.LayoutOrder
        v173.Parent = Frame8

        local ImageLabel3 = Instance.new("ImageLabel")

        ImageLabel3.Name = "Robux"
        ImageLabel3.BackgroundTransparency = 1
        ImageLabel3.Size = UDim2.fromOffset(36, 40)
        ImageLabel3.ImageColor3 = v4
        ImageLabel3.ZIndex = 10
        ImageLabel3.LayoutOrder = 1
        ImageLabel3.Parent = Frame8
        UIArt.Apply(ImageLabel3, "RobuxIcon")
        v174 = Vip.Price

        local v219 = text(Frame8, "Value", tostring(v174), 0, 0, 0, 48, 38, v4)

        v219.AutomaticSize = Enum.AutomaticSize.X
        v219.ZIndex = 10
        v219.LayoutOrder = 2
        t30.robux = ImageLabel3
        t30.price = v219

        local ImageButton = Instance.new("ImageButton")

        ImageButton.Name = "Gift"
        ImageButton.BackgroundTransparency = 1
        ImageButton.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageButton.Position = UDim2.fromOffset(820, 30)
        ImageButton.Size = UDim2.fromOffset(92, 50)
        ImageButton.ScaleType = Enum.ScaleType.Fit
        ImageButton.ZIndex = 12
        ImageButton.Parent = TextButton2
        UIArt.Apply(ImageButton, "GiftTag")
        pressable(ImageButton, function(p115) -- line: 700
            -- upvalues: ImageButton (copy), TweenService (copy), v3 (copy), v5 (copy)
            TweenService:Create(ImageButton, TweenInfo.new(0.15), {
                ImageColor3 = p115 and v5 or v3
            }):Play()
        end)
        ImageButton.Activated:Connect(function() -- line: 701
            -- upvalues: v134 (ref), Vip (copy)
            v134(Vip.Key)
        end)
        t30.shine = addShine(Frame2, 11)
        pressable(TextButton2, function(p116) -- line: 703
            -- upvalues: t30 (copy), Frame (copy), Frame3 (copy), ImageLabel3 (copy), v219 (copy), TweenService (copy), v3 (copy), v4 (copy), v5 (copy)
            t30.hover = p116
            TweenService:Create(Frame, TweenInfo.new(0.15), {
                BackgroundColor3 = p116 and v5 or v3
            }):Play()
            TweenService:Create(Frame3, TweenInfo.new(0.15), {
                BackgroundColor3 = p116 and v5 or v3
            }):Play()
            TweenService:Create(v219, TweenInfo.new(0.15), {
                TextColor3 = p116 and v3 or v4
            }):Play()
            TweenService:Create(ImageLabel3, TweenInfo.new(0.15), {
                ImageColor3 = p116 and v3 or v4
            }):Play()
        end)
        TextButton2.Activated:Connect(function() -- line: 710
            -- upvalues: t18 (copy), Vip (copy)
            t18.Choose(Vip.Key)
        end)

        local v225

        t30.emblem = function(p117) -- line: 713
            -- upvalues: LocalPlayer (copy), t31 (copy), ImageLabel (copy), v188 (copy), v190 (copy), v191 (copy), v192 (copy), v193 (copy), t32 (copy), ImageLabel2 (copy), v205 (copy), v206 (copy), t33 (copy), t34 (copy), v208 (ref), t35 (copy), v217 (copy), v218 (copy), v225 (ref), t1 (copy), stepAura (copy)
            v192.Rotation = p117 * 140 % 360
            v190.Rotation = -p117 * 60 % 360

            local v227 = (math.sin(p117 * 1.7) + 1) / 2

            v191.Size = UDim2.fromOffset(v227 * 10 + 222, v227 * 10 + 222)
            v193.Thickness = v227 * 3 + 9
            ImageLabel.ImageTransparency = 0.42 - v227 * 0.14
            ImageLabel.Size = UDim2.fromOffset(v227 * 30 + 370, v227 * 30 + 370)
            ImageLabel2.ImageTransparency = 0.6 - v227 * 0.12

            for _, v228 in v188 do
                v228.f.Rotation = v228.a + p117 * 6
            end

            for _, v229 in t31 do
                v229.f.BackgroundTransparency = 1 - (v229.base + (1 - v229.base) * ((math.sin(p117 * v229.sp + v229.ph) + 1) / 2)) * 0.9
            end

            for _, v232 in t32 do
                local v233 = (p117 * v232.sp + v232.ph) % 1
                local v234 = 125 - v233 * 58
                local v235 = v232.a0 + v233 * 7 + p117 * 0.6

                v232.f.Position = UDim2.fromOffset(138 + math.cos(v235) * v234, 172 + math.sin(v235) * v234 * 0.82)

                local v236 = 8 + 10 * (1 - v233)

                v232.f.Size = UDim2.fromOffset(v236, v236)
                v232.f.ImageColor3 = v232.col
                v232.f.ImageTransparency = v233 < 0.12 and 1 - v233 / 0.12 or v233 > 0.85 and (v233 - 0.85) / 0.15 or 0.05
            end

            v205:PivotTo(CFrame.Angles(0, p117 * t1.PreviewSpin, 0))

            local v238 = v208 and math.clamp(p117 - v208, 0, 0.1) or 0

            v208 = p117

            local Handle = v205:FindFirstChild("Handle")
            local Position = Handle and Handle.Position or Vector3.new(0, 0, 0)
            local v241 = CFrame.Angles(0, 0, math.sin(p117 * 0.9) * 0.07 + 0.3141592653589793)
            local v242 = (Handle and Handle.CFrame or CFrame.new(Position) * CFrame.Angles(0, 0, 1.5707963267948966)) * CFrame.new(0.28, 0, 0) * v241

            for _, v243 in t33 do
                v243.CFrame = v242
            end

            if Handle then
                local _CFrame = Handle.CFrame

                for _, v244 in t35 do
                    for _, v245 in v244.dots do
                        local v246 = p117 - v245.lag
                        local v247 = v246 * v244.speed + v244.phase
                        local v250 = Vector3.new(0, math.cos(v247), (math.sin(v247)))

                        v245.p.CFrame = _CFrame * CFrame.new(Vector3.new(v244.x + v244.amp * math.sin(v246 * v244.wave + v244.phase), 0, 0) + v250 * v244.r)
                    end
                end
            end

            for _, v253 in t34 do
                v253.th += v238 * v253.w

                for v254, v255 in v253.dots do
                    local v256 = v253.th - (v254 - 1) * 0.09 * v253.w / 7

                    v255.CFrame = v242 * CFrame.new(0, math.cos(v256) * v253.r, math.sin(v256) * v253.r)
                end
            end

            if v206 then
                stepAura(v206, p117, LocalPlayer:GetAttribute("GfxEffects") ~= false)
            end

            if v217 then
                v217.step(p117)
            end

            local v258 = (tonumber(LocalPlayer:GetAttribute("VipUntil")) or 0) - workspace:GetServerTimeNow()
            local v259

            if v258 <= 0 then
                v259 = "NOT ACTIVE"
            elseif v258 >= 86400 then
                local v261 = math.floor(v258 / 86400)

                v259 = "ACTIVE · " .. v261 .. (if v261 == 1 then " DAY" else " DAYS") .. " LEFT"
            else
                v259 = "ACTIVE · " .. math.max(1, (math.floor(v258 / 3600))) .. "H LEFT"
            end

            if v259 == v225 then
                return
            end

            v225 = v259
            v218.Text = v259
            v218.TextColor3 = v258 > 0 and Color3.fromRGB(120, 255, 160) or Color3.fromRGB(235, 215, 240)
        end

        t30.button = TextButton2
        t30.base = Frame
        t23[Vip.Key] = t30
    end

    local v265, v266

    if ShopCatalog.RaceDirector then
        local RaceDirector = ShopCatalog.RaceDirector

        v265 = section("RACE DIRECTOR", 1, "Race Director")
        v265.Size = UDim2.fromOffset(870, 557)
        v266 = ok and result.CheckerContent and result.CheckerContent() or nil

        local v267 = Color3.fromRGB(120, 255, 160)
        local v268 = Color3.fromRGB(205, 208, 216)
        local v269 = Color3.fromRGB(255, 60, 60)

        for v270, v271 in ShopCatalog.RaceDirectorOrder do
            local v272 = RaceDirector[v271]
            local v273 = v272.Tier == 2
            local t42 = {
                key = v272.Key,
                item = ShopCatalog.ByKey(v272.Key)
            }

            TextButton = Instance.new("TextButton")
            TextButton.Name = "Card_" .. v272.Key
            TextButton.Text = ""
            TextButton.BackgroundTransparency = 1
            TextButton.Size = UDim2.fromOffset(423, 505)
            TextButton.Position = UDim2.fromOffset((v270 - 1) * 447, 52)
            TextButton.ZIndex = 5
            TextButton.Parent = v265

            local Frame = Instance.new("Frame")

            Frame.Name = "Base"
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = v3 or v3
            Frame.Position = UDim2.fromOffset(0, 0)
            Frame.Size = UDim2.fromOffset(423, 505)
            Frame.ZIndex = 5
            Frame.Parent = TextButton
            ViewportFrame = Instance.new("UICorner")
            ViewportFrame.CornerRadius = UDim.new(0, 18)
            ViewportFrame.Parent = Frame
            Frame9 = Instance.new("Frame")
            Frame9.Name = "Art"
            Frame9.BorderSizePixel = 0
            Frame9.BackgroundColor3 = v3 or v3
            Frame9.Position = UDim2.fromOffset(8, 8)
            Frame9.Size = UDim2.fromOffset(407, 419)
            Frame9.ZIndex = 6
            Frame9.Parent = TextButton
            Frame6 = Instance.new("UICorner")
            Frame6.CornerRadius = UDim.new(0, 12)
            Frame6.Parent = Frame9
            Frame9.ClipsDescendants = true

            local front = Instance.new("Frame")

            front.Name = "ArtBottom"
            front.BorderSizePixel = 0
            front.BackgroundColor3 = v3 or v3
            front.Position = UDim2.fromOffset(8, 413)
            front.Size = UDim2.fromOffset(407, 14)
            front.ZIndex = 6
            front.Parent = TextButton

            local UIGradient = Instance.new("UIGradient")

            UIGradient.Rotation = 90
            UIGradient.Color = v273 and ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 14)),
                ColorSequenceKeypoint.new(0.6, Color3.fromRGB(28, 8, 10)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(74, 6, 10))
            }) or ColorSequence.new(Color3.fromRGB(16, 16, 20), Color3.fromRGB(46, 48, 56))
            UIGradient.Parent = Frame9

            local new = UIGradient.Color.Keypoints

            front.BackgroundColor3 = new[#new].Value

            if v266 then
                front = Instance.new("Frame")
                front.Name = "Flag"
                front.BorderSizePixel = 0
                front.BackgroundColor3 = v3 or v3
                front.Position = UDim2.fromOffset(0, 0)
                front.Size = UDim2.fromOffset(407, 419)
                front.ZIndex = 6
                front.Parent = Frame9
                front.BackgroundTransparency = 1
                front.ClipsDescendants = true
                UIGradient = Instance.new("ImageLabel")
                UIGradient.Name = "Checker"
                UIGradient.BackgroundTransparency = 1
                UIGradient.BorderSizePixel = 0
                UIGradient.ImageContent = v266
                UIGradient.ScaleType = Enum.ScaleType.Tile
                UIGradient.TileSize = UDim2.fromOffset(44, 44)
                UIGradient.ResampleMode = Enum.ResamplerMode.Pixelated
                UIGradient.Size = UDim2.new(1, 44, 1, 0)
                UIGradient.Position = UDim2.fromOffset(-44, 0)
                UIGradient.ZIndex = 6
                UIGradient.Parent = front
                new = Instance.new("UIGradient")
                new.Name = "Fade"
                new.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.7),
                    NumberSequenceKeypoint.new(0.3, 0.8),
                    NumberSequenceKeypoint.new(0.6, 0.94),
                    NumberSequenceKeypoint.new(0.78, 1),
                    NumberSequenceKeypoint.new(1, 1)
                })
                new.Parent = UIGradient
                t42.flag = {
                    img = UIGradient,
                    fade = new,
                    holder = front,
                    run = v273
                }
            end

            UIGradient = text(Frame9, "Title", "RACE DIRECTOR", 22, 20, 257, 40, 32)
            UIGradient.ZIndex = 8
            front = Instance.new("UIGradient")
            front.Rotation = 90
            front.Color = v273 and ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 175, 165)) or ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 204, 214))
            front.Parent = UIGradient

            if v273 then
                UIGradient = 98
                v169 = v5 or v3
            else
                UIGradient = 90
                v169 = v3
            end

            v170 = Instance.new("Frame")
            v170.Name = "TierChip"
            v170.BorderSizePixel = 0
            v170.BackgroundColor3 = v169 or v3
            v170.Position = UDim2.fromOffset(22, 64)
            v170.Size = UDim2.fromOffset(UIGradient, 30)
            v170.ZIndex = 8
            v170.Parent = Frame9
            v169 = Instance.new("UICorner")
            v169.CornerRadius = UDim.new(0, 15)
            v169.Parent = v170
            v171 = v272.Short

            local Activated = v273 and v3 or v4

            v169 = text(v170, "Tier", v171, 0, 0, UIGradient, 30, 18, Activated)
            v169.TextXAlignment = Center
            v169.ZIndex = 9
            v171 = if v273 then "PERMANENT · YOURS FOREVER" else "+" .. v272.Days .. " DAYS PER BUY · MAX " .. v272.MaxDays .. " DAYS"
            text(Frame9, "Sub", v171, 22 + UIGradient + 14, 68, 407 - UIGradient - 50, 22, 15, v268, v2).ZIndex = 8

            for v274, v275 in v273 and {
                    "RACE DIRECTOR ON PRIVATE SERVERS",
                    "SAFETY CAR",
                    "ANIMATED NAMETAG + SPARKLES"
                } or {
                    "RACE DIRECTOR ON PRIVATE SERVERS",
                    "CHEQUERED FLAG NAMETAG",
                    "WHILE ACTIVE · STACKS UP TO " .. v272.MaxDays .. " DAYS"
                } do
                text(Frame9, "Perk" .. v274, "•  " .. v275, 24, 108 + (v274 - 1) * 28, 367, 26, 18).ZIndex = 8
            end

            local v276 = text(Frame9, "Status", "", 24, 196, 367, 22, 16, v268, v2)

            v276.ZIndex = 8

            local t43 = nil

            if v273 then
                local ViewportFrame = Parent:FindFirstChild("SafetyCar")
                local ShopPreview = ViewportFrame and ViewportFrame:FindFirstChild("ShopPreview")

                if ShopPreview then
                    ViewportFrame = Instance.new("ViewportFrame")
                    ViewportFrame.Name = "SafetyCar3D"
                    ViewportFrame.BackgroundTransparency = 1
                    ViewportFrame.AnchorPoint = Vector2.new(0.5, 0)
                    ViewportFrame.Position = UDim2.fromOffset(203.5, 218)
                    ViewportFrame.Size = UDim2.fromOffset(387, 123)
                    ViewportFrame.ZIndex = 8
                    ViewportFrame.Ambient = Color3.fromRGB(190, 190, 198)
                    ViewportFrame.LightColor = Color3.fromRGB(255, 255, 255)
                    ViewportFrame.LightDirection = Vector3.new(-0.4, -0.7, 0.6)
                    ViewportFrame.Parent = Frame9
                    v171 = ShopPreview:Clone()
                    v171.Parent = ViewportFrame
                    Frame7, Nametag = v171:GetBoundingBox()
                    Frame8 = Frame7.Position
                    v173 = Instance.new("Camera")
                    v173.FieldOfView = 26
                    v173.Parent = ViewportFrame
                    ViewportFrame.CurrentCamera = v173
                    v172 = Nametag.X
                    Activated = Nametag.Z

                    local v277 = math.max(v172, Activated) * 0.5 / 0.23086819112556312 * 0.62

                    v172 = CFrame.lookAt
                    v174 = v277 * 0.32
                    Activated = Frame8 + Vector3.new(0, v174, v277)
                    Part = -Nametag.Y * 0.08
                    v173.CFrame = v172(Activated, Frame8 + Vector3.new(0, Part, 0))
                    t43 = {
                        model = v171,
                        centre = Frame8,
                        base = v171:GetPivot()
                    }
                end
            else
                local ViewportFrame = text(Frame9, "Days", "+" .. v272.Days, 0, 218, 407, 93, 78)

                ViewportFrame.TextXAlignment = Center
                ViewportFrame.ZIndex = 7
                ViewportFrame.TextTransparency = 0.1
                v171 = Instance.new("UIGradient")
                v171.Rotation = 90
                v171.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(170, 176, 190))
                v171.Parent = ViewportFrame
                ViewportFrame = text(Frame9, "DaysWord", "DAYS OF RACE DIRECTOR", 0, 305, 407, 24, 17, v268, v2)
                ViewportFrame.TextXAlignment = Center
                ViewportFrame.ZIndex = 7
            end

            local v278 = tagPreview(Frame9, v272.Nametag, 2, 203.5, 373, 0.5, 9)

            t42.shine = addShine(Frame9, 11)
            v171 = Instance.new("Frame")
            v171.Name = "Price"
            v171.BackgroundTransparency = 1
            v171.AnchorPoint = Vector2.new(0.5, 0.5)
            v171.Position = UDim2.fromOffset(211.5, 462)
            v171.Size = UDim2.fromOffset(0, 48)
            v171.AutomaticSize = Enum.AutomaticSize.X
            v171.ZIndex = 7
            v171.Parent = TextButton

            local UIListLayout = Instance.new("UIListLayout")

            UIListLayout.FillDirection = Enum.FillDirection.Horizontal
            UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            UIListLayout.Padding = UDim.new(0, 10)
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Parent = v171

            local ImageLabel = Instance.new("ImageLabel")

            ImageLabel.Name = "Robux"
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Size = UDim2.fromOffset(36, 40)
            ImageLabel.ImageColor3 = v4
            ImageLabel.ZIndex = 8
            ImageLabel.LayoutOrder = 1
            ImageLabel.Parent = v171
            UIArt.Apply(ImageLabel, "RobuxIcon")
            v172 = v272.Price

            local v279 = text(v171, "Value", tostring(v172), 0, 0, 0, 48, 38, v4)

            v279.AutomaticSize = Enum.AutomaticSize.X
            v279.ZIndex = 8
            v279.LayoutOrder = 2

            local v280 = nil

            if v272.WasPrice then
                v174 = v272.WasPrice

                local v281 = text(v171, "WasPrice", "<s>" .. tostring(v174) .. "</s>", 0, 0, 0, 48, 28, v269)

                v280 = v281
                v281.RichText = true
                v281.AutomaticSize = Enum.AutomaticSize.X
                v281.ZIndex = 8
                v281.LayoutOrder = 3
            end

            t42.robux = ImageLabel
            t42.price = v279

            local ImageButton = Instance.new("ImageButton")

            ImageButton.Name = "Gift"
            ImageButton.BackgroundTransparency = 1
            ImageButton.AnchorPoint = Vector2.new(0.5, 0.5)
            ImageButton.Position = UDim2.fromOffset(373, 30)
            ImageButton.Size = UDim2.fromOffset(92, 50)
            ImageButton.ScaleType = Enum.ScaleType.Fit
            ImageButton.ZIndex = 12
            ImageButton.Parent = TextButton
            UIArt.Apply(ImageButton, "GiftTag")
            pressable(ImageButton, function(p118) -- line: 867
                -- upvalues: ImageButton (copy), TweenService (copy), v3 (copy), v5 (copy)
                TweenService:Create(ImageButton, TweenInfo.new(0.15), {
                    ImageColor3 = p118 and v5 or v3
                }):Play()
            end)
            Frame8 = ImageButton.Activated
            Frame8:Connect(function() -- line: 868
                -- upvalues: v134 (ref), v272 (copy)
                v134(v272.Key)
            end)
            pressable(TextButton, function(p119) -- line: 869
                -- upvalues: v269 (copy), t42 (copy), Frame (copy), ImageLabel (copy), v279 (copy), v280 (ref), TweenService (copy), v3 (copy), v4 (copy), v5 (copy)
                t42.hover = p119
                TweenService:Create(Frame, TweenInfo.new(0.15), {
                    BackgroundColor3 = p119 and v5 or v3
                }):Play()
                TweenService:Create(v279, TweenInfo.new(0.15), {
                    TextColor3 = p119 and v3 or t42.stripColor or v4
                }):Play()
                TweenService:Create(ImageLabel, TweenInfo.new(0.15), {
                    ImageColor3 = p119 and v3 or v4
                }):Play()

                if not v280 then
                    return
                end

                local v286 = v280

                TweenService:Create(v286, TweenInfo.new(0.15), {
                    TextColor3 = p119 and v3 or v269
                }):Play()
            end)
            Frame8 = TextButton.Activated
            Frame8:Connect(function() -- line: 876
                -- upvalues: t18 (copy), v272 (copy)
                t18.Choose(v272.Key)
            end)

            local v288 = nil

            t42.emblem = function(p120) -- line: 879
                -- upvalues: LocalPlayer (copy), v267 (copy), v268 (copy), t42 (copy), v276 (copy), t43 (ref), v278 (copy), v280 (ref), v288 (ref), v273 (copy)
                local flag = t42.flag

                if flag and flag.run then
                    local v289 = p120 * 44 * 0.6 % 44

                    flag.img.Position = UDim2.fromOffset(-44 + v289, 0)

                    local X = flag.img.AbsoluteSize.X
                    local X2 = flag.holder.AbsoluteSize.X

                    if X2 > 0 and X2 < X then
                        flag.fade.Offset = Vector2.new(-(v289 / 44) * (X - X2) / X + math.sin(p120 * 1.8) * 0.04, 0)
                    end
                end

                if t43 then
                    t43.model:PivotTo(CFrame.new(t43.centre) * CFrame.Angles(0, p120 * 0.5, 0) * CFrame.new(-t43.centre) * t43.base)
                end

                if v278 then
                    v278.step(p120)
                end

                local v292 = v268
                local v293 = LocalPlayer:GetAttribute("RaceDirector2Owned") == true

                if v280 then
                    v280.Visible = not v293
                end

                local v295

                if v273 then
                    if v293 then
                        v295 = "OWNED · YOURS FOREVER"
                        v292 = v267
                    else
                        v295 = "NOT OWNED"
                    end
                else
                    local v296 = (tonumber(LocalPlayer:GetAttribute("RaceDirector1Until")) or 0) - workspace:GetServerTimeNow()

                    if v293 then
                        v295 = "INCLUDED IN YOUR TIER 2"
                        v292 = v267
                    elseif v296 <= 0 then
                        v295 = "NOT ACTIVE"
                    else
                        if v296 >= 86400 then
                            local v298 = math.floor(v296 / 86400)

                            v295 = "ACTIVE · " .. v298 .. (if v298 == 1 then " DAY" else " DAYS") .. " LEFT"
                        else
                            v295 = "ACTIVE · " .. math.max(1, (math.floor(v296 / 3600))) .. "H LEFT"
                        end

                        v292 = v267
                    end
                end

                if v295 == v288 then
                    return
                end

                v288 = v295
                v276.Text = v295
                v276.TextColor3 = v292
            end

            t42.button = TextButton
            t42.base = Frame
            t23[v272.Key] = t42
        end
    end

    local Bottle = section("BOTTLE", 2, "Bottle")

    for v301, v302 in ShopCatalog.BottleOrder do
        card(Bottle, v301, v302)
    end

    Bottle = section("CURRENCY", 3, "Currency")

    for v303, v304 in ShopCatalog.Cash do
        card(Bottle, v303, v304.Key)
    end

    local n1 = 0

    RunService.RenderStepped:Connect(function() -- line: 912
        -- upvalues: LocalPlayer (copy), ScreenGui (copy), UIScale (copy), UIScale2 (copy), ScrollingFrame (copy), t21 (copy), t23 (copy), n1 (ref), t1 (copy), stepAura (copy)
        if ScreenGui.Enabled then
            local v305 = t21[1]
            local v307 = math.max(0, ScrollingFrame.AbsoluteCanvasSize.Y - ScrollingFrame.AbsoluteWindowSize.Y)

            if not (v307 > 0 and ScrollingFrame.CanvasPosition.Y >= v307 - 2) then
                for _, v309 in t21 do
                    if v309.frame.AbsolutePosition.Y - ScrollingFrame.AbsolutePosition.Y <= 40 * UIScale.Scale * UIScale2.Scale then
                        v305 = v309
                    end
                end
            else
                v305 = t21[#t21]
            end

            for _, v310 in t21 do
                local button = v310.button

                if v310 == v305 then
                    button.BackgroundTransparency = 0
                elseif v310.hover then
                    button.BackgroundTransparency = 0.75
                else
                    button.BackgroundTransparency = 1
                end
            end

            local elapsed = os.clock()

            if elapsed - (n1 or 0) < 0.03333333333333333 then
                return
            end

            n1 = elapsed

            local AbsolutePosition, AbsoluteWindowSize = ScrollingFrame.AbsolutePosition, ScrollingFrame.AbsoluteWindowSize
            local v312 = math.clamp(elapsed % 3 / 1.8, 0, 1)
            local v313 = v312 * v312 * (3 - v312 * 2)

            for _, v314 in t23 do
                local button = v314.button

                if button then
                    local AbsolutePosition2, AbsoluteSize = button.AbsolutePosition, button.AbsoluteSize

                    if not (AbsolutePosition2.Y + AbsoluteSize.Y < AbsolutePosition.Y) and not (AbsolutePosition2.Y > AbsolutePosition.Y + AbsoluteWindowSize.Y) and not (AbsolutePosition2.X + AbsoluteSize.X < AbsolutePosition.X) and not (AbsolutePosition2.X > AbsolutePosition.X + AbsoluteWindowSize.X) then
                        if v314.shine then
                            v314.shine.Offset = Vector2.new(v313 * 2.4 + -1.2, 0)
                        end

                        if v314.emblem then
                            v314.emblem(elapsed)
                        end

                        local preview = v314.preview

                        if preview then
                            preview.model:PivotTo(CFrame.Angles(0, elapsed * t1.PreviewSpin + preview.phase, 0))

                            if v314.aura then
                                stepAura(v314.aura, elapsed, LocalPlayer:GetAttribute("GfxEffects") ~= false)
                            end

                            if preview.glass then
                                local v315 = elapsed * 0.35

                                for _, v316 in preview.glass do
                                    local v317 = if v316.Name == "Shoulder" then 0.68 elseif v316.Name == "ShoulderTop" then 0.82 else 0

                                    v316.Color = Color3.fromHSV((v315 + v317 * 0.18) % 1, 0.8, 1)
                                end
                            end
                        end
                    end
                else
                    if v314.shine then
                        v314.shine.Offset = Vector2.new(v313 * 2.4 + -1.2, 0)
                    end

                    if v314.emblem then
                        v314.emblem(elapsed)
                    end

                    local preview = v314.preview

                    if preview then
                        preview.model:PivotTo(CFrame.Angles(0, elapsed * t1.PreviewSpin + preview.phase, 0))

                        if v314.aura then
                            stepAura(v314.aura, elapsed, LocalPlayer:GetAttribute("GfxEffects") ~= false)
                        end

                        if preview.glass then
                            local v318 = elapsed * 0.35

                            for _, v319 in preview.glass do
                                local v320 = if v319.Name == "Shoulder" then 0.68 elseif v319.Name == "ShoulderTop" then 0.82 else 0

                                v319.Color = Color3.fromHSV((v318 + v320 * 0.18) % 1, 0.8, 1)
                            end
                        end
                    end
                end
            end
        end
    end)

    local function owned() -- line: 956
        -- upvalues: LocalPlayer (copy), HttpService (copy)
        local JSONDecode = HttpService.JSONDecode
        local v321 = LocalPlayer:GetAttribute("OwnedBottles") or "[]"
        local ok, result = pcall(JSONDecode, HttpService, v321)
        local t49 = {}

        if ok and typeof(result) == "table" then
            for _, v322 in result do
                t49[v322] = true
            end
        end

        return t49
    end

    local function refresh() -- line: 961
        -- upvalues: LocalPlayer (copy), t23 (copy), owned (copy), ShopCatalog (copy), v3 (copy), v4 (copy), v5 (copy)
        local v323 = owned()
        local v324 = LocalPlayer:GetAttribute("SelectedBottle") or ShopCatalog.DefaultBottle

        for _, v325 in t23 do
            if v325.item.kind == "Bottle" and v323[v325.item.id] then
                v325.robux.Visible = false
                v325.price.Text = v324 == v325.item.id and "EQUIPPED" or "EQUIP"
                v325.price.TextSize = 30
                v325.stripColor = v324 == v325.item.id and v5 or v4
            elseif v325.item.kind == "RaceDirector" and LocalPlayer:GetAttribute("RaceDirector2Owned") == true then
                v325.robux.Visible = false
                v325.price.Text = v325.item.tier == 2 and "OWNED" or "INCLUDED"
                v325.price.TextSize = 30
                v325.stripColor = v5
            else
                v325.robux.Visible = true
                v325.price.Text = tostring(v325.item.price)
                v325.price.TextSize = 38
                v325.stripColor = v4
            end

            v325.price.TextColor3 = v325.hover and v3 or v325.stripColor
        end
    end

    LocalPlayer:GetAttributeChangedSignal("OwnedBottles"):Connect(refresh)
    LocalPlayer:GetAttributeChangedSignal("SelectedBottle"):Connect(refresh)
    LocalPlayer:GetAttributeChangedSignal("RaceDirector2Owned"):Connect(refresh)
    refresh()
    v265 = Instance.new("ScreenGui")
    v265.Name = "ShopToast"
    v265.IgnoreGuiInset = true
    v265.ResetOnSpawn = false
    v265.DisplayOrder = 60
    v265.Parent = p62

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Toast"
    TextLabel.AnchorPoint = Vector2.new(0.5, 1)
    TextLabel.Position = UDim2.new(0.5, 0, 1, -90)
    TextLabel.Size = UDim2.fromOffset(0, 40)
    TextLabel.AutomaticSize = Enum.AutomaticSize.X
    TextLabel.BackgroundColor3 = v4
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextColor3 = v3
    TextLabel.TextTransparency = 1
    TextLabel.FontFace = v1
    TextLabel.TextSize = 18
    TextLabel.Text = ""
    TextLabel.AutoLocalize = false
    TextLabel.Parent = v265
    v266 = Instance.new("UICorner")
    v266.CornerRadius = UDim.new(0, 20)
    v266.Parent = TextLabel
    v266 = Instance.new("UIPadding")
    v266.PaddingLeft = UDim.new(0, 22)
    v266.PaddingRight = UDim.new(0, 22)
    v266.Parent = TextLabel
    v266 = Instance.new("UIStroke")
    v266.Color = v3
    v266.Thickness = 2
    v266.Transparency = 1
    v266.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    v266.Parent = TextLabel

    local n2 = 0

    function t18.Toast(p121) -- line: 989
        -- upvalues: TextLabel (copy), n2 (ref), TweenService (copy)
        n2 += 1

        local v326 = n2

        TextLabel.Text = string.upper(p121)

        local UIStroke = TextLabel:FindFirstChildOfClass("UIStroke")

        TweenService:Create(TextLabel, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.1,
            TextTransparency = 0
        }):Play()
        TweenService:Create(UIStroke, TweenInfo.new(0.2), {
            Transparency = 0.2
        }):Play()
        task.delay(3, function() -- line: 994
            -- upvalues: v326 (copy), UIStroke (copy), TextLabel (copy), n2 (ref), TweenService (copy)
            if v326 == n2 then
                TweenService:Create(TextLabel, TweenInfo.new(0.35), {
                    BackgroundTransparency = 1,
                    TextTransparency = 1
                }):Play()
                TweenService:Create(UIStroke, TweenInfo.new(0.35), {
                    Transparency = 1
                }):Play()
            end
        end)
    end

    local v327 = false

    local function invoke(...) -- line: 1002
        -- upvalues: ShopAction (copy)
        local InvokeServer = ShopAction.InvokeServer
        local ok, result = pcall(InvokeServer, ShopAction, ...)

        if not ok or typeof(result) ~= "table" then
            return {
                ok = false,
                err = "TRY AGAIN"
            }
        end

        return result
    end

    function t18.Choose(p122) -- line: 1007
        -- upvalues: t18 (copy), LocalPlayer (copy), owned (copy), v327 (ref), invoke (copy), MarketplaceService (copy), ShopCatalog (copy)
        if v327 then
            return
        end

        local v328 = ShopCatalog.ByKey(p122)

        if v328 then
            v327 = true

            if v328.kind ~= "Bottle" or not owned()[v328.id] then
                local v329 = invoke("Buy", p122)

                if v329.ok and v329.product then
                    MarketplaceService:PromptProductPurchase(LocalPlayer, v329.product)
                elseif v329.err then
                    t18.Toast(v329.err)
                end
            else
                local v330 = invoke("Equip", v328.id)

                if v330.ok then
                    t18.Toast(v328.name .. " EQUIPPED")
                elseif v330.err then
                    t18.Toast(v330.err)
                end
            end

            v327 = false
        end
    end

    local Frame10 = Instance.new("Frame")

    Frame10.Name = "GiftPicker"
    Frame10.BorderSizePixel = 0
    Frame10.BackgroundColor3 = v4 or v3
    Frame10.Position = UDim2.fromOffset(0, 0)
    Frame10.Size = UDim2.fromOffset(1520, 832)
    Frame10.ZIndex = 30
    Frame10.Parent = Frame3
    Frame10.BackgroundTransparency = 0.35
    Frame10.Active = true
    Frame10.Visible = false

    local Frame11 = Instance.new("Frame")

    Frame11.Name = "Box"
    Frame11.BorderSizePixel = 0
    Frame11.BackgroundColor3 = v4 or v3
    Frame11.Position = UDim2.fromOffset(350, 110)
    Frame11.Size = UDim2.fromOffset(820, 612)
    Frame11.ZIndex = 31
    Frame11.Parent = Frame10
    Frame11.Active = true

    local UICorner2 = Instance.new("UICorner")

    UICorner2.CornerRadius = UDim.new(0, 22)
    UICorner2.Parent = Frame11
    UICorner2 = Instance.new("UIStroke")
    UICorner2.Color = Color3.fromRGB(70, 72, 80)
    UICorner2.Thickness = 3
    UICorner2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UICorner2.Parent = Frame11

    local v331 = text(Frame11, "Title", "GIFT", 36, 26, 640, 40, 32)

    v331.ZIndex = 32
    v331.TextTruncate = Enum.TextTruncate.AtEnd
    ok2 = Instance.new("Frame")
    ok2.Name = "Divider"
    ok2.BorderSizePixel = 0
    ok2.BackgroundColor3 = v3 or v3
    ok2.Position = UDim2.fromOffset(34, 76)
    ok2.Size = UDim2.fromOffset(250, 3)
    ok2.ZIndex = 32
    ok2.Parent = Frame11
    v168 = Instance.new("UIGradient")
    v168.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.8, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    v168.Parent = ok2

    local v332

    v168, v332 = closeButton(Frame11, 754, 48, 80, 42, 26, 40)

    local ScrollingFrame2 = Instance.new("ScrollingFrame")

    ScrollingFrame2.Name = "Players"
    ScrollingFrame2.BackgroundTransparency = 1
    ScrollingFrame2.BorderSizePixel = 0
    ScrollingFrame2.Position = UDim2.fromOffset(30, 100)
    ScrollingFrame2.Size = UDim2.fromOffset(760, 486)
    ScrollingFrame2.ScrollBarThickness = 5
    ScrollingFrame2.ScrollBarImageColor3 = v3
    ScrollingFrame2.CanvasSize = UDim2.new()
    ScrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame2.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame2.ZIndex = 32
    ScrollingFrame2.Parent = Frame11
    result2 = Instance.new("UIListLayout")
    result2.Padding = UDim.new(0, 12)
    result2.SortOrder = Enum.SortOrder.LayoutOrder
    result2.Parent = ScrollingFrame2
    result2 = Instance.new("UIPadding")
    result2.PaddingRight = UDim.new(0, 14)
    result2.PaddingTop = UDim.new(0, 4)
    result2.PaddingBottom = UDim.new(0, 8)
    result2.Parent = ScrollingFrame2

    local v333 = text(Frame11, "Empty", "NO OTHER RIDERS IN THIS SERVER", 0, 300, 820, 40, 24, v6)

    v333.TextXAlignment = Center
    v333.ZIndex = 32

    local v334

    local function closeGift() -- line: 1037
        -- upvalues: Frame10 (copy), v332 (ref), v334 (ref)
        Frame10.Visible = false
        v334 = nil
        v332()
    end

    local function ownsBottle(p123, p124) -- line: 1038
        -- upvalues: HttpService (copy)
        local JSONDecode = HttpService.JSONDecode
        local v335 = p123:GetAttribute("OwnedBottles") or "[]"
        local ok, result = pcall(JSONDecode, HttpService, v335)

        if ok then
            ok = typeof(result) == "table" and table.find(result, p124) ~= nil
        end

        return ok
    end

    local function buildRows() -- line: 1042
        -- upvalues: t18 (copy), LocalPlayer (copy), text (copy), pressable (copy), v327 (ref), invoke (copy), Frame10 (copy), v332 (ref), ScrollingFrame2 (copy), v333 (copy), v334 (ref), TweenService (copy), Players (copy), MarketplaceService (copy), HttpService (copy), ShopCatalog (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy)
        for _, child in ScrollingFrame2:GetChildren() do
            if child:IsA("GuiObject") then
                child:Destroy()
            end
        end

        local v336 = v334 and ShopCatalog.ByKey(v334)

        if not v336 then
            return
        end

        local t50 = {}

        for _, player in Players:GetPlayers() do
            if player ~= LocalPlayer then
                table.insert(t50, player)
            end
        end

        table.sort(t50, function(p125, p126) -- line: 1047
            return p125.DisplayName:lower() < p126.DisplayName:lower()
        end)
        v333.Visible = #t50 == 0

        for v337, v338 in t50 do
            local v339 = "Row_" .. v338.UserId
            local v340 = Color3.fromRGB(24, 24, 28)
            local Frame = Instance.new("Frame")

            Frame.Name = v339
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = v340 or v3
            Frame.Position = UDim2.fromOffset(0, 0)
            Frame.Size = UDim2.fromOffset(746, 92)
            Frame.ZIndex = 33
            Frame.Parent = ScrollingFrame2
            Frame.LayoutOrder = v337

            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(0, 16)
            UICorner.Parent = Frame

            local ImageLabel = Instance.new("ImageLabel")

            ImageLabel.Name = "Avatar"
            ImageLabel.BackgroundColor3 = Color3.fromRGB(46, 46, 52)
            ImageLabel.Position = UDim2.fromOffset(14, 13)
            ImageLabel.Size = UDim2.fromOffset(66, 66)
            ImageLabel.ZIndex = 34
            ImageLabel.Parent = Frame

            local UICorner2 = Instance.new("UICorner")

            UICorner2.CornerRadius = UDim.new(0, 33)
            UICorner2.Parent = ImageLabel
            task.spawn(function() -- line: 1053
                -- upvalues: v338 (copy), ImageLabel (copy), Players (copy)
                local GetUserThumbnailAsync = Players.GetUserThumbnailAsync
                local UserId = v338.UserId
                local HeadShot = Enum.ThumbnailType.HeadShot
                local Size100x100 = Enum.ThumbnailSize.Size100x100
                local ok, result = pcall(GetUserThumbnailAsync, Players, UserId, HeadShot, Size100x100)

                if ok and ImageLabel.Parent then
                    ImageLabel.Image = result
                end
            end)

            local v341 = text(Frame, "DisplayName", v338.DisplayName, 98, 14, 440, 36, 27)

            v341.ZIndex = 34
            v341.TextTruncate = Enum.TextTruncate.AtEnd
            v341.AutoLocalize = false

            local v342 = text(Frame, "UserName", "@" .. v338.Name, 98, 50, 440, 26, 19, v6, v2)

            v342.ZIndex = 34
            v342.TextTruncate = Enum.TextTruncate.AtEnd

            local ok

            if v336.kind == "Bottle" then
                local id = v336.id
                local JSONDecode = HttpService.JSONDecode
                local v343 = v338:GetAttribute("OwnedBottles") or "[]"
                local result

                ok, result = pcall(JSONDecode, HttpService, v343)

                if ok then
                    ok = typeof(result) == "table" and table.find(result, id) ~= nil
                end

                if not ok then
                    ok = v336.kind == "RaceDirector" and v338:GetAttribute("RaceDirector2Owned") == true
                end
            else
                ok = v336.kind == "RaceDirector" and v338:GetAttribute("RaceDirector2Owned") == true
            end

            local TextButton = Instance.new("TextButton")

            TextButton.Name = "GiftButton"
            TextButton.AnchorPoint = Vector2.new(1, 0.5)
            TextButton.Position = UDim2.new(1, -18, 0.5, 0)
            TextButton.Size = UDim2.fromOffset(150, 54)
            TextButton.BackgroundColor3 = ok and Color3.fromRGB(60, 62, 70) or v3
            TextButton.Text = ok and "OWNED" or "GIFT"
            TextButton.TextColor3 = ok and v6 or v4
            TextButton.FontFace = v1
            TextButton.TextSize = 24
            TextButton.ZIndex = 35
            TextButton.AutoLocalize = false
            TextButton.Parent = Frame

            local UICorner3 = Instance.new("UICorner")

            UICorner3.CornerRadius = UDim.new(0, 27)
            UICorner3.Parent = TextButton

            if ok then
                TextButton:SetAttribute("NoHover", true)
                TextButton.AutoButtonColor = false
            else
                pressable(TextButton, function(p127) -- line: 1064
                    -- upvalues: TextButton (copy), TweenService (copy), v3 (copy), v4 (copy), v5 (copy)
                    TweenService:Create(TextButton, TweenInfo.new(0.15), {
                        BackgroundColor3 = p127 and v5 or v3,
                        TextColor3 = p127 and v3 or v4
                    }):Play()
                end)
                TextButton.Activated:Connect(function() -- line: 1065
                    -- upvalues: v338 (copy), t18 (copy), LocalPlayer (copy), v327 (ref), invoke (copy), Frame10 (copy), v332 (ref), v334 (ref), MarketplaceService (copy)
                    if v327 then
                        return
                    end

                    v327 = true

                    local v347 = invoke("Gift", v334, v338.UserId)

                    v327 = false

                    if not (v347.ok and v347.product) then
                        if v347.err then
                            t18.Toast(v347.err)
                        end
                    else
                        Frame10.Visible = false
                        v334 = nil
                        v332()
                        t18.Toast("GIFT FOR " .. v338.DisplayName)
                        MarketplaceService:PromptProductPurchase(LocalPlayer, v347.product)
                    end
                end)
            end
        end
    end

    v134 = function(p128) -- line: 1079
        -- upvalues: Frame10 (copy), v331 (copy), ScrollingFrame2 (copy), v334 (ref), buildRows (copy), ShopCatalog (copy)
        local v348 = ShopCatalog.ByKey(p128)

        if not v348 then
            return
        end

        v334 = p128
        v331.Text = "GIFT " .. v348.name
        buildRows()
        ScrollingFrame2.CanvasPosition = Vector2.zero
        Frame10.Visible = true
    end

    v168.Activated:Connect(closeGift)
    Players.PlayerAdded:Connect(function() -- line: 1086
        -- upvalues: Frame10 (copy), buildRows (copy)
        if Frame10.Visible then
            buildRows()
        end
    end)
    Players.PlayerRemoving:Connect(function() -- line: 1087
        -- upvalues: Frame10 (copy), buildRows (copy)
        if Frame10.Visible then
            task.defer(buildRows)
        end
    end)

    local t52 = {
        ShopHUD = true,
        ShopToast = true,
        TouchGui = true,
        ExitTeleportCover = true,
        WeatherVote = true
    }
    local t53 = {}
    local v349

    local function hideGui(p129) -- line: 1092
        -- upvalues: ScreenGui (copy), t52 (copy), t53 (copy)
        if p129 == ScreenGui or not p129:IsA("ScreenGui") or t52[p129.Name] or t53[p129] then
            return
        end

        local t54 = {
            own = 0,
            wanted = p129.Enabled
        }

        t53[p129] = t54

        local function off() -- line: 1096
            -- upvalues: p129 (copy), t54 (copy)
            if p129.Enabled then
                t54.own += 1
                p129.Enabled = false
            end
        end

        t54.conn = p129:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 1097
            -- upvalues: p129 (copy), t54 (copy)
            local Enabled = p129.Enabled
            local Enabled2

            if Enabled then
                t54.wanted = true
                Enabled2 = p129.Enabled
            else
                if t54.own > 0 then
                    t54.own -= 1

                    return
                end

                t54.wanted = false
            end

            if (not Enabled or Enabled2) and Enabled then
                t54.own += 1
                p129.Enabled = false
            end
        end)

        if p129.Enabled then
            t54.own += 1
            p129.Enabled = false
        end
    end

    local function hideGuis() -- line: 1104
        -- upvalues: p62 (copy), v349 (ref), hideGui (copy)
        for _, child in p62:GetChildren() do
            hideGui(child)
        end

        v349 = v349 or p62.ChildAdded:Connect(hideGui)
    end

    local function restoreGuis() -- line: 1108
        -- upvalues: t53 (copy), v349 (ref)
        if v349 then
            v349:Disconnect()
            v349 = nil
        end

        for v350, v351 in t53 do
            v351.conn:Disconnect()

            if v350.Parent and v351.wanted then
                v350.Enabled = true
            end
        end

        table.clear(t53)
    end

    local BlurEffect

    local function setBlur(p130) -- line: 1114
        -- upvalues: BlurEffect (ref), TweenService (copy), t1 (copy)
        if p130 then
            local CurrentCamera = workspace.CurrentCamera

            if not (BlurEffect and BlurEffect.Parent) then
                BlurEffect = Instance.new("BlurEffect")
                BlurEffect.Name = "ShopBlur"
                BlurEffect.Size = 0
                BlurEffect.Parent = CurrentCamera
            end

            TweenService:Create(BlurEffect, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = t1.BlurSize
            }):Play()
        elseif BlurEffect then
            local BlurEffect2 = BlurEffect

            BlurEffect = nil

            local tween = TweenService:Create(BlurEffect2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = 0
            })

            tween.Completed:Connect(function() -- line: 1122
                -- upvalues: BlurEffect2 (copy)
                BlurEffect2:Destroy()
            end)
            tween:Play()
        end
    end

    local function flagOpen(p131) -- line: 1125
        -- upvalues: p62 (copy)
        local JerezRaceHUD = p62:FindFirstChild("JerezRaceHUD")

        if JerezRaceHUD then
            JerezRaceHUD:SetAttribute("ShopOpen", p131)
        end
    end

    function t18.Open() -- line: 1129
        -- upvalues: p62 (copy), ScreenGui (copy), Frame (copy), UIScale (copy), v130 (copy), ScrollingFrame (copy), refresh (copy), Frame10 (copy), v332 (ref), v334 (ref), v349 (ref), hideGui (copy), BlurEffect (ref), TweenService (copy), t1 (copy)
        local AbsoluteSize = Frame.AbsoluteSize

        if AbsoluteSize.X < 1 or AbsoluteSize.Y < 1 then
            AbsoluteSize = workspace.CurrentCamera.ViewportSize
        end

        UIScale.Scale = math.min(AbsoluteSize.X / 2000, AbsoluteSize.Y / 1125)
        refresh()
        Frame10.Visible = false
        v334 = nil
        v332()
        v130()

        if ScreenGui.Enabled then
            return
        end

        for _, child in p62:GetChildren() do
            hideGui(child)
        end

        v349 = v349 or p62.ChildAdded:Connect(hideGui)

        local CurrentCamera = workspace.CurrentCamera

        if not (BlurEffect and BlurEffect.Parent) then
            BlurEffect = Instance.new("BlurEffect")
            BlurEffect.Name = "ShopBlur"
            BlurEffect.Size = 0
            BlurEffect.Parent = CurrentCamera
        end

        TweenService:Create(BlurEffect, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = t1.BlurSize
        }):Play()

        local JerezRaceHUD = p62:FindFirstChild("JerezRaceHUD")

        if JerezRaceHUD then
            JerezRaceHUD:SetAttribute("ShopOpen", true)
        end

        ScrollingFrame.CanvasPosition = Vector2.zero
        ScreenGui.Enabled = true
    end

    function t18.Close() -- line: 1137
        -- upvalues: p62 (copy), ScreenGui (copy), v130 (copy), Frame10 (copy), v332 (ref), v334 (ref), restoreGuis (copy), BlurEffect (ref), TweenService (copy)
        if ScreenGui.Enabled then
            Frame10.Visible = false
            v334 = nil
            v332()

            if BlurEffect then
                local BlurEffect2 = BlurEffect

                BlurEffect = nil

                local tween = TweenService:Create(BlurEffect2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Size = 0
                })

                tween.Completed:Connect(function() -- line: 1122
                    -- upvalues: BlurEffect2 (copy)
                    BlurEffect2:Destroy()
                end)
                tween:Play()
            end

            local JerezRaceHUD = p62:FindFirstChild("JerezRaceHUD")

            if JerezRaceHUD then
                JerezRaceHUD:SetAttribute("ShopOpen", false)
            end

            ScreenGui.Enabled = false
            v130()
            restoreGuis()
        end
    end

    function t18.IsOpen() -- line: 1142
        -- upvalues: ScreenGui (copy)
        return ScreenGui.Enabled
    end

    v129.Activated:Connect(function() -- line: 1143
        -- upvalues: t18 (copy)
        t18.Close()
    end)
    UserInputService.InputBegan:Connect(function(p132) -- line: 1144
        -- upvalues: t18 (copy), ScreenGui (copy), Frame10 (copy), v332 (ref), v334 (ref)
        if not ScreenGui.Enabled or p132.KeyCode ~= Enum.KeyCode.ButtonB then
            return
        end

        if Frame10.Visible then
            Frame10.Visible = false
            v334 = nil
            v332()

            return
        end

        t18.Close()
    end)
    t18.Gui = ScreenGui
    v129 = Frame.AbsoluteSize

    if v129.X < 1 or v129.Y < 1 then
        v129 = workspace.CurrentCamera.ViewportSize
    end

    UIScale.Scale = math.min(v129.X / 2000, v129.Y / 1125)

    return t18
end

return t1
