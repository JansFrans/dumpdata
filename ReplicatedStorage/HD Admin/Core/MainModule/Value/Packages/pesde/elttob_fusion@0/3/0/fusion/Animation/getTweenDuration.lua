-- https://lua.expert

game:GetService("TweenService")

local function getTweenDuration(p1) -- line: 13
    if p1.RepeatCount <= -1 then
        return 1e999
    end

    local v1 = p1.DelayTime + p1.Time

    if p1.Reverses then
        v1 += p1.Time
    end

    return v1 * (p1.RepeatCount + 1)
end

return getTweenDuration
