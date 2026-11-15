-- https://lua.expert

game:GetService("Debris")

local t1 = {
    Severity = function(p1, p2, p3) -- Severity | line: 4
        local v2 = math.max(0, p2 or 0)
        local v4 = math.max(0, p3 or 0)
        local v5 = if p1 == "IMPACT" then math.max(v4, v2 * 0.1) elseif p1 ~= "HIGHSIDE" and p1 ~= "LOOPOVER" and p1 ~= "STOPPIE" then math.max(v2 * 0.25, v4 * 0.75) else math.max(v2 * 0.55, v4 * 0.85)

        if v5 < 22 then
            return 0
        end

        if v5 < 55 then
            return 1
        end

        if v5 < 105 then
            return 2
        end

        return 3
    end,
    LockCore = function(p4) -- LockCore | line: 22
        local PrimaryPart = p4.PrimaryPart
        local VisualFrame = p4:FindFirstChild("VisualFrame")

        if not (PrimaryPart and VisualFrame) then
            return
        end

        if workspace:GetAttribute("PrivateFeatures") == true then
            if not PrimaryPart:FindFirstChild("WreckVisualLock") then
                local Weld = Instance.new("Weld")

                Weld.Name = "WreckVisualLock"
                Weld.Part0 = PrimaryPart
                Weld.Part1 = VisualFrame
                Weld.C0 = CFrame.identity
                Weld.C1 = CFrame.identity
                Weld.Parent = PrimaryPart
            end

            local VisualSlide = PrimaryPart:FindFirstChild("VisualSlide")

            if VisualSlide then
                VisualSlide:Destroy()
            end
        else
            local VisualSlide = PrimaryPart:FindFirstChild("VisualSlide")

            if VisualSlide then
                VisualSlide:Destroy()
            end

            VisualFrame.CFrame = PrimaryPart.CFrame

            if not PrimaryPart:FindFirstChild("WreckVisualLock") then
                local Weld = Instance.new("Weld")

                Weld.Name = "WreckVisualLock"
                Weld.Part0 = PrimaryPart
                Weld.Part1 = VisualFrame
                Weld.C0 = CFrame.identity
                Weld.C1 = CFrame.identity
                Weld.Parent = PrimaryPart
            end
        end

        p4:SetAttribute("VisualSlideBaked", true)
        p4:SetAttribute("VisualRearYaw", 0)
    end
}

function t1.Apply(p5, p6, _, _) -- line: 53
    -- upvalues: t1 (copy)
    t1.LockCore(p5)
    p5:SetAttribute("DamageLevel", (math.clamp(p6 or 0, 0, 3)))

    local _ = p5.PrimaryPart

    p5:SetAttribute("DetachedParts", 0)

    return 0
end

function t1.BindImpact(p9) -- line: 102
    -- upvalues: t1 (copy)
    if p9:GetAttribute("WheelImpactBound") then
        return
    end

    p9:SetAttribute("WheelImpactBound", true)

    local PrimaryPart = p9.PrimaryPart

    for _, v12 in {
            PrimaryPart,
            p9:FindFirstChild("CrashMass")
        } do
        if v12 then
            v12.CanTouch = true
            v12.Touched:Connect(function(p10) -- line: 109
                -- upvalues: p9 (copy), PrimaryPart (copy), v12 (copy), t1 (copy)
                if p10.CanCollide and not p10:IsDescendantOf(p9) and (not p10:FindFirstAncestorWhichIsA("Model") or not p10:FindFirstAncestorWhichIsA("Model"):FindFirstChildOfClass("Humanoid")) then
                    local Surface = p10:GetAttribute("Surface")

                    if Surface ~= "Asphalt" and Surface ~= "Grass" and Surface ~= "Gravel" and Surface ~= "Sand" and p10 ~= workspace.Terrain and not p10:GetAttribute("Kerb") and (p9:GetAttribute("Crash") or "") ~= "" and not ((PrimaryPart:GetVelocityAtPosition(v12.Position) - p10.AssemblyLinearVelocity).Magnitude < 12) and not p9:GetAttribute("ImpactConfirmed") then
                        p9:SetAttribute("ImpactConfirmed", true)
                        t1.Apply(p9, 3, PrimaryPart.AssemblyLinearVelocity, 1)
                    end
                end
            end)
        end
    end
end

function t1.Fire(_, _) -- line: 122
end

return t1
