-- https://lua.expert

local HapticService = game:GetService("HapticService")
local t1 = {}
local n1 = 0
local v1

local function set(p1, p2, p3) -- line: 4
    -- upvalues: HapticService (copy)
    if p1 then
        local function v2() -- line: 5
            -- upvalues: p1 (copy), p2 (copy), p3 (copy), HapticService (copy)
            if not (HapticService:IsVibrationSupported(p1) and HapticService:IsMotorSupported(p1, p2)) then
                return
            end

            HapticService:SetMotor(p1, p2, p3)
        end

        pcall(v2)
    end
end

function t1.Stop() -- line: 7
    -- upvalues: HapticService (copy), n1 (ref), v1 (ref)
    n1 += 1

    local v3 = v1
    local Large = Enum.VibrationMotor.Large

    if v3 then
        local n2 = 0

        local function v4() -- line: 5
            -- upvalues: v3 (copy), Large (copy), n2 (copy), HapticService (copy)
            if not (HapticService:IsVibrationSupported(v3) and HapticService:IsMotorSupported(v3, Large)) then
                return
            end

            HapticService:SetMotor(v3, Large, n2)
        end

        pcall(v4)
    end

    local v5 = v1
    local Small = Enum.VibrationMotor.Small

    if v5 then
        local n3 = 0

        local function v6() -- line: 5
            -- upvalues: v5 (copy), Small (copy), n3 (copy), HapticService (copy)
            if not (HapticService:IsVibrationSupported(v5) and HapticService:IsMotorSupported(v5, Small)) then
                return
            end

            HapticService:SetMotor(v5, Small, n3)
        end

        pcall(v6)
    end

    v1 = nil
end

function t1.Envelope(p4, p5) -- line: 10
    local v8 = math.clamp(0.35 + (p4 or 0) * 0.2, 0, 1)
    local v10 = math.clamp(p4 or 0, 0, 3) * 0.15 + 0.45
    local v12 = math.max(0, 1 - p5 / v10)

    return v8 * v12 * v12, math.min(1, v8 * 1.2) * v12 * (math.cos(p5 * 60) * 0.3 + 0.7), v10
end

function t1.Play(p6, p7) -- line: 16
    -- upvalues: HapticService (copy), t1 (copy), n1 (ref), v1 (ref)
    t1.Stop()

    if not p6 then
        return
    end

    v1 = p6

    local v17 = n1

    task.spawn(function() -- line: 19
        -- upvalues: p6 (copy), p7 (copy), v17 (copy), HapticService (copy), t1 (copy), n1 (ref)
        local elapsed = os.clock()

        while v17 == n1 do
            local v18 = os.clock() - elapsed
            local v19, v20, v21 = t1.Envelope(p7, v18)

            if v21 <= v18 then
                break
            end

            local Large = Enum.VibrationMotor.Large

            if p6 then
                local function v22() -- line: 5
                    -- upvalues: v19 (copy), Large (copy), p6 (copy), HapticService (copy)
                    if not (HapticService:IsVibrationSupported(p6) and HapticService:IsMotorSupported(p6, Large)) then
                        return
                    end

                    HapticService:SetMotor(p6, Large, v19)
                end

                pcall(v22)
            end

            local Small = Enum.VibrationMotor.Small

            if p6 then
                local function v23() -- line: 5
                    -- upvalues: v20 (copy), Small (copy), p6 (copy), HapticService (copy)
                    if not (HapticService:IsVibrationSupported(p6) and HapticService:IsMotorSupported(p6, Small)) then
                        return
                    end

                    HapticService:SetMotor(p6, Small, v20)
                end

                pcall(v23)
            end

            task.wait(0.025)
        end

        if v17 == n1 then
            t1.Stop()
        end
    end)
end

return t1
