-- https://lua.expert

local t1 = {
    Settings = {
        DragCut = 0.3,
        TopKph = 12,
        FromKph = 140,
        FullKph = 240,
        FullDist = 14,
        MaxDist = 105,
        WidthNear = 3.2,
        WidthNearZero = 6.5,
        WidthFar = 5,
        WidthFarZero = 10,
        Heading = 0.82,
        MinLeadKph = 60,
        LeanFrom = 12,
        LeanFull = 40,
        LeanKeep = 0.45,
        RiseTime = 0.35,
        FallTime = 0.9,
        Scan = 0.1
    }
}
local Parent = script.Parent

function t1.Get(p1) -- line: 30
    -- upvalues: t1 (copy), Parent (copy)
    local Attribute = Parent:GetAttribute("Slipstream_" .. p1)

    if typeof(Attribute) ~= "number" or Attribute ~= Attribute then
        return t1.Settings[p1]
    end

    return Attribute
end

local function ramp(p2, p3, p4) -- line: 35
    local v2 = math.clamp((p2 - p3) / (p4 - p3), 0, 1)

    return v2 * v2 * (3 - 2 * v2)
end

local self = setmetatable({}, {
    __mode = "k"
})

function t1.Raw(p5) -- line: 38
    -- upvalues: t1 (copy), self (copy)
    local RaceBikes = workspace:FindFirstChild("RaceBikes")

    if not RaceBikes then
        return 0
    end

    local Parent, Position = p5.Parent, p5.Position
    local LookVector = p5.CFrame.LookVector
    local v4 = Vector3.new(LookVector.X, 0, LookVector.Z)

    if v4.Magnitude < 0.001 then
        return 0
    end

    local Unit = v4.Unit
    local MaxDist = t1.Get("MaxDist")
    local FullDist = t1.Get("FullDist")
    local elapsed = os.clock()
    local n1 = 0

    for _, child in RaceBikes:GetChildren() do
        if child ~= Parent and child:IsA("Model") and (child:GetAttribute("Crash") or "") == "" then
            local PrimaryPart = child.PrimaryPart

            if PrimaryPart then
                local PrimaryPartPosition = PrimaryPart.Position
                local v5 = self[PrimaryPart]

                self[PrimaryPart] = { PrimaryPartPosition, elapsed }

                local v6 = PrimaryPartPosition - Position
                local v7 = v6.X * Unit.X + v6.Z * Unit.Z

                if v7 > 1 and v7 < MaxDist and math.abs(v6.Y) < 12 then
                    local LookVector = PrimaryPart.CFrame.LookVector
                    local v8 = Vector3.new(LookVector.X, 0, LookVector.Z)

                    if v8.Magnitude > 0.001 and v8.Unit:Dot(Unit) >= t1.Get("Heading") then
                        local AssemblyLinearVelocity = PrimaryPart.AssemblyLinearVelocity
                        local Magnitude = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude

                        if v5 and elapsed - v5[2] > 0.02 and elapsed - v5[2] < 1 then
                            local v9 = PrimaryPartPosition - v5[1]

                            Magnitude = math.max(Magnitude, Vector3.new(v9.X, 0, v9.Z).Magnitude / (elapsed - v5[2]))
                        end

                        local Config = t1.Config

                        if Magnitude * (Config and Config.StudMetres or 0.28) * 3.6 >= t1.Get("MinLeadKph") then
                            local Magnitude = Vector3.new(v6.X - Unit.X * v7, 0, v6.Z - Unit.Z * v7).Magnitude
                            local v14 = math.clamp(v7 / MaxDist, 0, 1)
                            local v15 = t1.Get("WidthNear") + (t1.Get("WidthFar") - t1.Get("WidthNear")) * v14
                            local v16 = t1.Get("WidthNearZero") + (t1.Get("WidthFarZero") - t1.Get("WidthNearZero")) * v14
                            local v18 = math.clamp((v7 - FullDist) / (MaxDist - FullDist), 0, 1)
                            local v19 = 1 - v18 * v18 * (3 - 2 * v18)
                            local v21 = math.clamp((Magnitude - v15) / (v16 - v15), 0, 1)
                            local v22 = v19 * (1 - v21 * v21 * (3 - 2 * v21))

                            if n1 < v22 then
                                n1 = v22
                            end
                        end
                    end
                end
            end
        end
    end

    return n1
end

function t1.Step(p6, p7, p8, p9) -- line: 77
    -- upvalues: t1 (copy)
    if p9 then
        local root = p6.root
        local elapsed = os.clock()

        if not p6.slipAt or elapsed - p6.slipAt >= t1.Get("Scan") then
            p6.slipAt = elapsed

            local v23 = root and root.Parent and t1.Raw(root) or 0

            p6.slipRaw = v23
        end

        local v27 = math.deg((math.abs(p6.lean or 0)))
        local v28 = 1 - t1.Get("LeanKeep")
        local LeanFrom = t1.Get("LeanFrom")
        local LeanFull = t1.Get("LeanFull")
        local v30 = math.clamp((v27 - LeanFrom) / (LeanFull - LeanFrom), 0, 1)
        local v31 = 1 - v28 * (v30 * v30 * (3 - 2 * v30))
        local v32 = p6.slipRaw or 0
        local v33 = p8 or 0
        local FromKph = t1.Get("FromKph")
        local FullKph = t1.Get("FullKph")
        local v35 = math.clamp((v33 - FromKph) / (FullKph - FromKph), 0, 1)
        local v36 = v32 * (v35 * v35 * (3 - 2 * v35)) * v31
        local v37 = p6.slipK or 0
        local RiseTime = v37 < v36 and t1.Get("RiseTime") or t1.Get("FallTime")
        local v40 = v37 + (v36 - v37) * (1 - math.exp(-(p7 or 0) / math.max(RiseTime, 0.01)))

        if v40 < 0.001 then
            v40 = 0
        end

        p6.slipK = v40
        p6.slipDrag = t1.Get("DragCut") * v40
        p6.slipTopKph = t1.Get("TopKph") * v40

        return v40
    end

    if p6.slipK then
        p6.slipK = nil
        p6.slipRaw = nil
        p6.slipAt = nil
    end

    p6.slipDrag = 0
    p6.slipTopKph = 0

    return 0
end

local function v41() -- line: 98
    -- upvalues: t1 (copy), Parent (copy)
    t1.Config = require(Parent:WaitForChild("Config"))
end

pcall(v41)

return t1
