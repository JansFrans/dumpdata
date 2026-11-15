-- https://lua.expert

local function roundToNearest(p1, p2) -- line: 1
    return math.round(p1 / p2) / (1 / p2)
end

return roundToNearest
