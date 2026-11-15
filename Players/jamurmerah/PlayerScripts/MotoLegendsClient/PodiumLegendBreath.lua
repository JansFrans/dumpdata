-- https://lua.expert

local RunService = game:GetService("RunService")
local t1 = {
    Head = true,
    Hair = true,
    Cap = true,
    CapLiner = true
}

local function isShoulder(p1) -- line: 15
    -- upvalues: t1 (copy)
    local v1 = t1[p1]

    if not v1 then
        v1 = p1:find("Arm") ~= nil or p1:find("Hand") ~= nil
    end

    return v1
end

local t2 = {}

local function add(p2) -- line: 18
    -- upvalues: t1 (copy), t2 (copy)
    if not t2[p2] and p2:IsA("Model") and p2.Name == "PodiumLegend" then
        local BreathPivot = p2:GetAttribute("BreathPivot")

        if typeof(BreathPivot) ~= "CFrame" then
            return
        end

        local t3 = {
            pivot = BreathPivot,
            parts = {},
            base = {},
            shoulder = {},
            scale = p2:GetAttribute("BreathScale") or 1
        }

        for _, descendant in p2:GetDescendants() do
            if descendant:IsA("BasePart") and not descendant.Name:find("_Fade") and descendant.Position.Y > BreathPivot.Position.Y then
                table.insert(t3.parts, descendant)
                table.insert(t3.base, BreathPivot:ToObjectSpace(descendant.CFrame))

                local shoulder = t3.shoulder
                local Name = descendant.Name
                local v2 = t1[Name]

                if not v2 then
                    v2 = Name:find("Arm") ~= nil or Name:find("Hand") ~= nil
                end

                table.insert(shoulder, v2)
            end
        end

        local v5 = Random.new(#t3.parts * 7919 + math.floor(BreathPivot.Position.X * 13))

        t3.period = 3.6 * v5:NextNumber(0.85, 1.15)
        t3.phase = v5:NextNumber(0, 6.283185307179586)
        t2[p2] = t3
        p2.Destroying:Connect(function() -- line: 30
            -- upvalues: p2 (copy), t2 (copy)
            t2[p2] = nil
        end)
    end
end

workspace.DescendantAdded:Connect(function(p3) -- line: 32
    -- upvalues: add (copy)
    if p3:IsA("Model") and p3.Name == "PodiumLegend" then
        task.defer(add, p3)
    end
end)

for _, descendant in workspace:GetDescendants() do
    if descendant:IsA("Model") and descendant.Name == "PodiumLegend" then
        add(descendant)
    end
end

RunService.RenderStepped:Connect(function() -- line: 35
    -- upvalues: t2 (copy)
    if next(t2) == nil then
        return
    end

    local CFramePosition = workspace.CurrentCamera.CFrame.Position
    local elapsed = os.clock()
    local t4 = {}
    local t5 = {}

    for v6, v7 in t2 do
        if v6.Parent then
            if (v7.pivot.Position - CFramePosition).Magnitude < 400 then
                local v9 = 0.5 - math.cos(elapsed * 2 * 3.141592653589793 / v7.period + v7.phase) * 0.5
                local v10 = CFrame.Angles((v9 - 0.5) * -0.012217304763960306, 0, 0)
                local v12 = Vector3.new(0, 0.035 * v7.scale * v9, 0)
                local v13 = v7.pivot * v10

                for v14, v15 in v7.parts do
                    local v16 = v13 * v7.base[v14]

                    if v7.shoulder[v14] then
                        v16 += v12
                    end

                    t4[#t4 + 1] = v15
                    t5[#t5 + 1] = v16
                end
            end
        else
            t2[v6] = nil
        end
    end

    if #t4 > 0 then
        workspace:BulkMoveTo(t4, t5, Enum.BulkMoveMode.FireCFrameChanged)
    end
end)
