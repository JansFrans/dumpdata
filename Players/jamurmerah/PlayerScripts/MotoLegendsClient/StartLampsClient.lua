-- https://lua.expert

game:GetService("RunService")

local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local Config = require(MotoLegends:WaitForChild("Config"))
local v1 = Color3.fromRGB(255, 15, 10)
local v2 = Color3.fromRGB(24, 24, 24)
local t1 = {}

local function collect() -- line: 12
    -- upvalues: Config (copy), t1 (copy)
    local v3 = workspace:FindFirstChild(Config.Track or "")
    local StartingGrid = v3 and v3:FindFirstChild("StartingGrid")

    table.clear(t1)

    if not StartingGrid then
        return
    end

    for _, descendant in StartingGrid:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Name == "StartingLamp" then
            table.insert(t1, descendant)
        end
    end

    table.sort(t1, function(p1, p2) -- line: 17
        return p1.Position.X < p2.Position.X
    end)
end

local function apply() -- line: 19
    -- upvalues: MotoLegends (copy), v1 (copy), v2 (copy), t1 (copy)
    local v4 = MotoLegends:GetAttribute("StartRedLights") or 0
    local v5 = MotoLegends:GetAttribute("SessionPhase") == "Lights" or MotoLegends:GetAttribute("PracticeStartLights") == true

    for v6, v7 in t1 do
        if v7.Parent then
            local v8 = v5 and v6 <= v4
            local v9 = v8 and v1 or v2
            local Neon = if v8 then Enum.Material.Neon or Enum.Material.SmoothPlastic else Enum.Material.SmoothPlastic

            v7.Color = v9
            v7.Material = Neon

            for _, child in v7:GetChildren() do
                if child:IsA("BasePart") and child.Name == "Bulb" then
                    child.Color = v9
                    child.Material = Neon
                end
            end

            local Glow = v7:FindFirstChild("Glow")

            if Glow then
                Glow.Enabled = v8
                Glow.Color = v1
            end
        end
    end
end

collect()
apply()

local v10 = false

workspace.DescendantAdded:Connect(function(p3) -- line: 35
    -- upvalues: collect (copy), apply (copy), v10 (ref)
    if (p3.Name == "StartingLamp" or p3.Name == "Bulb") and not v10 then
        v10 = true
        task.defer(function() -- line: 37
            -- upvalues: collect (copy), apply (copy), v10 (ref)
            v10 = false
            collect()
            apply()
        end)
    end
end)
MotoLegends:GetAttributeChangedSignal("StartRedLights"):Connect(apply)
MotoLegends:GetAttributeChangedSignal("SessionPhase"):Connect(apply)
MotoLegends:GetAttributeChangedSignal("PracticeStartLights"):Connect(apply)
