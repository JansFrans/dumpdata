-- https://lua.expert

return function(p1, p2) -- line: 1
    local v1 = 10 ^ (p2 or 0)

    return math.round(p1 * v1) / v1
end
