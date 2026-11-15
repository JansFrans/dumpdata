-- https://lua.expert

local t1 = {
    MaxLift = 0.45
}

local function bottomY(p1) -- line: 6
    local CFrame, Size = p1.CFrame, p1.Size

    return p1.Position.Y - (math.abs(CFrame.RightVector.Y) * Size.X + math.abs(CFrame.UpVector.Y) * Size.Y + math.abs(CFrame.LookVector.Y) * Size.Z) / 2
end

function t1.Apply(p2) -- line: 11
    -- upvalues: t1 (copy)
    local v3 = p2:FindFirstChild("Object_1", true)

    if not (v3 and v3:IsA("BasePart")) then
        return false
    end

    v3.Transparency = 0

    local v4 = p2:FindFirstChild("Object_8", true)
    local v5 = p2:FindFirstChild("Object_92", true)

    if v4 and v5 then
        local n1 = 1

        local function v6() -- line: 17
            -- upvalues: p2 (copy), n1 (ref)
            n1 = p2:GetScale()
        end

        pcall(v6)

        local _CFrame, Size = v5.CFrame, v5.Size
        local v9 = v5.Position.Y - (math.abs(_CFrame.RightVector.Y) * Size.X + math.abs(_CFrame.UpVector.Y) * Size.Y + math.abs(_CFrame.LookVector.Y) * Size.Z) / 2
        local _CFrame2, Size2 = v3.CFrame, v3.Size
        local v14 = math.clamp(v9 - (v3.Position.Y - (math.abs(_CFrame2.RightVector.Y) * Size2.X + math.abs(_CFrame2.UpVector.Y) * Size2.Y + math.abs(_CFrame2.LookVector.Y) * Size2.Z) / 2), 0, t1.MaxLift * n1)

        if not (v14 < 0.005) then
            local Pivot = p2:GetPivot()
            local X = v4.Position.X
            local _CFrame, Size = v4.CFrame, v4.Size
            local v18 = Vector3.new(X, v4.Position.Y - (math.abs(_CFrame.RightVector.Y) * Size.X + math.abs(_CFrame.UpVector.Y) * Size.Y + math.abs(_CFrame.LookVector.Y) * Size.Z) / 2, v4.Position.Z)
            local Magnitude = Vector3.new(v3.Position.X - v18.X, 0, v3.Position.Z - v18.Z).Magnitude

            if not (Magnitude < 0.5) then
                local RightVector = Pivot.RightVector
                local v23 = Vector3.new(v3.Position.X - v18.X, 0, v3.Position.Z - v18.Z)
                local v24 = CFrame.fromAxisAngle(RightVector, 0.01) * v23
                local v27 = math.asin((math.clamp(v14 / Magnitude, 0, 0.2)))

                if v24.Y < 0 then
                    v27 = -v27
                end

                p2:PivotTo(CFrame.new(v18) * CFrame.fromAxisAngle(RightVector, v27) * CFrame.new(-v18) * Pivot)
            end
        end
    end

    return true
end

return t1
