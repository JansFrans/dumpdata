-- https://lua.expert

local TweenService = game:GetService("TweenService")

local function getTweenRatio(p1, p2) -- line: 13
    -- upvalues: TweenService (copy)
    local DelayTime, Time, Reverses = p1.DelayTime, p1.Time, p1.Reverses
    local v1 = 1 + p1.RepeatCount
    local EasingStyle, EasingDirection = p1.EasingStyle, p1.EasingDirection
    local v2 = DelayTime + Time

    if Reverses then
        v2 += Time
    end

    if p2 == 1e999 or v2 * v1 <= p2 and p1.RepeatCount > -1 then
        return 1
    end

    local v3 = p2 % v2

    if v3 <= DelayTime then
        return 0
    end

    local v4 = (v3 - DelayTime) / Time

    if v4 > 1 then
        v4 = 2 - v4
    end

    return (TweenService:GetValue(v4, EasingStyle, EasingDirection))
end

return getTweenRatio
