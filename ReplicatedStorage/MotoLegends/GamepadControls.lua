-- https://lua.expert

local t1 = {}

local function finite(p1) -- line: 3
    if typeof(p1) == "number" and p1 == p1 then
        return math.abs(p1) < 1e999
    end

    return false
end

function t1.Axis(p2, p3, p4) -- line: 4
    if typeof(p2) ~= "number" or p2 ~= p2 or not (math.abs(p2) < 1e999) then
        return 0
    end

    local v2 = math.clamp((math.abs(p2) - (p3 or 0.12)) / (1 - (p3 or 0.12)), 0, 1)

    return math.sign(p2) * v2 ^ (p4 or 1.3)
end

t1.SteerDeadzone = 0.1
t1.SteerOuter = 0.8
t1.SteerCurve = 1.15

function t1.Steer(p5) -- line: 13
    -- upvalues: t1 (copy)
    if typeof(p5) ~= "number" or p5 ~= p5 or not (math.abs(p5) < 1e999) then
        return 0
    end

    local v4 = math.clamp((math.abs(p5) - t1.SteerDeadzone) / (t1.SteerOuter - t1.SteerDeadzone), 0, 1)

    return math.sign(p5) * v4 ^ t1.SteerCurve
end

function t1.New() -- line: 18
    return {
        throttle = 0,
        brake = 0,
        rearBrake = 0,
        steer = 0,
        lift = 0,
        cameraX = 0,
        cameraY = 0
    }
end

function t1.Reset(p6) -- line: 19
    for _, v5 in { "throttle", "brake", "rearBrake", "steer", "lift", "cameraX", "cameraY" } do
        p6[v5] = 0
    end
end

function t1.Update(p7, p8, p9, p10) -- line: 20
    -- upvalues: t1 (copy)
    local v6 = p9 == Enum.UserInputState.End or p9 == Enum.UserInputState.Cancel
    local v7 = not v6 and p10 or Vector3.new(0, 0, 0)

    if p8 == Enum.KeyCode.Thumbstick1 then
        p7.steer = t1.Steer(v7.X)
        p7.lift = t1.Axis(v7.Y, 0.18, 1)
    elseif p8 == Enum.KeyCode.Thumbstick2 then
        p7.cameraX = t1.Axis(v7.X, 0.14, 1.2)
        p7.cameraY = t1.Axis(v7.Y, 0.14, 1.2)
    elseif p8 == Enum.KeyCode.ButtonR2 then
        p7.throttle = math.max(0, t1.Axis(v7.Z, 0.04, 1))
    elseif p8 == Enum.KeyCode.ButtonL2 then
        p7.brake = math.max(0, t1.Axis(v7.Z, 0.04, 1))
    elseif p8 == Enum.KeyCode.ButtonA then
        if v6 then
            p7.rearBrake = 0
        elseif p9 == Enum.UserInputState.Begin or p9 == Enum.UserInputState.Change and v7.Z > 0.5 then
            p7.rearBrake = 1
        else
            p7.rearBrake = 0
        end
    end
end

function t1.UpdateMapped(p11, p12, p13, p14, p15) -- line: 32
    -- upvalues: t1 (copy)
    local v8 = p12 == Enum.KeyCode.ButtonR2 or p12 == Enum.KeyCode.ButtonL2
    local v9 = p13 == Enum.KeyCode.ButtonR2 or p13 == Enum.KeyCode.ButtonL2

    if not v8 or v9 then
        t1.Update(p11, p12, p14, p15)
    else
        local v10 = p14 == Enum.UserInputState.Begin or p14 == Enum.UserInputState.Change

        if p12 == Enum.KeyCode.ButtonR2 then
            p11.throttle = v10 and 1 or 0
        else
            p11.brake = v10 and 1 or 0
        end
    end
end

return t1
