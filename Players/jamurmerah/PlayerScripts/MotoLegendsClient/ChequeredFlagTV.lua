-- https://lua.expert

local Track = require(game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends"):WaitForChild("Config")).Track
local RunService = game:GetService("RunService")
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local v1 = workspace:WaitForChild(Track):WaitForChild("Signage"):WaitForChild("ChequeredFlagTV", 30)

if not v1 then
    return
end

local Background = v1:WaitForChild("Screen"):WaitForChild("Display"):WaitForChild("Background")
local Frame = Instance.new("Frame")

Frame.Name = "Flag"
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.fromScale(0.5, 0.5)
Frame.Size = UDim2.fromScale(0.86, 0.8)
Frame.BackgroundTransparency = 1
Frame.Visible = false
Frame.Parent = Background

local t1 = {}

for i = 0, 9 do
    for j = 0, 5 do
        local Frame2 = Instance.new("Frame")

        Frame2.BorderSizePixel = 0
        Frame2.Size = UDim2.new(0.1, 1, 0.16666666666666666, 1)
        Frame2.Position = UDim2.fromScale(i / 10, j / 6)

        local v2 = (i + j) % 2 == 0
        local v3 = if v2 then Color3.new(1, 1, 1) else nil

        if not v2 or not v3 then
            Frame2.BackgroundColor3 = Color3.new(0, 0, 0)
        else
            Frame2.BackgroundColor3 = v3
        end

        Frame2.Parent = Frame
        table.insert(t1, {
            frame = Frame2,
            c = i,
            r = j,
            white = (i + j) % 2 == 0
        })
    end
end

local Frame2 = Instance.new("Frame")

Frame2.Size = UDim2.fromScale(1, 1)
Frame2.BackgroundTransparency = 1
Frame2.ZIndex = 5
Frame2.Parent = Background

for i = 1, 24 do
    local Frame = Instance.new("Frame")

    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame.BackgroundTransparency = 0.55
    Frame.Size = UDim2.new(1, 0, 0, 1)
    Frame.Position = UDim2.fromScale(0, i / 25)
    Frame.ZIndex = 5
    Frame.Parent = Frame2
end

local v4 = false
local n1 = 0

RunService.RenderStepped:Connect(function(p1) -- line: 22
    -- upvalues: MotoLegends (copy), Frame (copy), t1 (copy), v4 (ref), n1 (ref)
    local v5 = MotoLegends:GetAttribute("ChequeredFlag") == true

    if v5 ~= v4 then
        v4 = v5
        Frame.Visible = v5
        n1 = 0
    end

    if v5 then
        n1 += p1

        for _, v6 in t1 do
            local v7 = v6.c / 10
            local v8 = n1 * 5.5 - v6.c * 0.75
            local v9 = math.sin(v8) * 0.045 * (0.25 + v7)

            v6.frame.Position = UDim2.fromScale(v7, v6.r / 6 + v9)

            local v10 = math.cos(v8) * 0.22 + 0.78

            if not (v6.white and v10) then
                v10 *= 0.05
            end

            v6.frame.BackgroundColor3 = Color3.new(v10, v10, v10)
        end
    end
end)
