-- https://lua.expert

local t1 = {
    Kinds = { "Gold", "Silver", "Bronze" },
    LoopHeight = 0.37
}
local PodiumMedals = script.Parent:WaitForChild("PodiumMedals")

function t1.Template(p1) -- line: 13
    -- upvalues: t1 (copy), PodiumMedals (copy)
    return PodiumMedals:FindFirstChild(t1.Kinds[p1] or "")
end

function t1.Worn(p2, p3) -- line: 15
    local v1 = p2 * CFrame.new(0, -p3.Y * 0.2, -(p3.Z / 2 + 0.07))
    local v2 = p3.Y / 2 + 0.03

    return v1, p2 * Vector3.new(-p3.X * 0.2, v2, -p3.Z * 0.1), p2 * Vector3.new(p3.X * 0.2, v2, -p3.Z * 0.1)
end

local function ribbonCF(p4, p5, p6) -- line: 20
    local v8 = p6 - p5
    local Magnitude = v8.Magnitude

    if Magnitude < 0.05 then
        return nil, 0
    end

    local Unit = v8.Unit
    local v9 = -p4.LookVector
    local v10 = v9 - Unit * v9:Dot(Unit)
    local Unit2 = v10.Magnitude > 0.001 and v10.Unit or Vector3.new(0, 0, 1)

    return CFrame.fromMatrix((p6 + p5) / 2, Unit:Cross(Unit2), Unit, Unit2), Magnitude
end

function t1.Layout(p7, p8, p9, p10) -- line: 29
    -- upvalues: t1 (copy), ribbonCF (copy)
    local t2 = {}

    for _, descendant in p7:GetDescendants() do
        if descendant:IsA("BasePart") then
            local Offset = descendant:GetAttribute("Offset")

            if typeof(Offset) == "CFrame" then
                t2[descendant] = p8 * Offset
            elseif descendant == p7.PrimaryPart then
                t2[descendant] = p8
            end
        end
    end

    for _, v11 in {
            { "RibbonL", p9, -1 },
            { "RibbonR", p10, 1 }
        } do
        local v13, v14 = ribbonCF(p8, p8 * Vector3.new(v11[3] * 0.05, t1.LoopHeight, 0), v11[2])
        local v15 = p7:FindFirstChild(v11[1])
        local v16 = p7:FindFirstChild(v11[1] .. "Stripe")

        if v13 then
            if v15 then
                v15.Size = Vector3.new(0.17, v14, 0.025)
                t2[v15] = v13
            end

            if v16 then
                v16.Size = Vector3.new(0.045, v14, 0.028)
                t2[v16] = v13 * CFrame.new(0, 0, -0.003)
            end
        end
    end

    return t2
end

function t1.Place(p11, p12, p13, p14) -- line: 46
    -- upvalues: t1 (copy)
    for v17, v18 in t1.Layout(p11, p12, p13, p14) do
        v17.CFrame = v18
    end
end

function t1.Wear(p15, p16) -- line: 48
    -- upvalues: t1 (copy)
    local v19 = p16 and (p16:FindFirstChild("UpperTorso") or p16:FindFirstChild("Torso"))

    if not v19 then
        return false
    end

    for v20, v21 in (t1.Layout(p15, t1.Worn(CFrame.identity, v19.Size))) do
        for _, child in v20:GetChildren() do
            if child:IsA("JointInstance") or child:IsA("WeldConstraint") then
                child:Destroy()
            end
        end

        v20.Anchored = false
        v20.Massless = true
        v20.CanCollide = false
        v20.CanTouch = false
        v20.CanQuery = false
        v20.CFrame = v19.CFrame * v21

        local Weld = Instance.new("Weld")

        Weld.Name = "MedalWeld"
        Weld.Part0 = v19
        Weld.Part1 = v20
        Weld.C0 = v21
        Weld.Parent = v20
    end

    p15:SetAttribute("Worn", true)
    p15.Parent = p16

    return true
end

return t1
