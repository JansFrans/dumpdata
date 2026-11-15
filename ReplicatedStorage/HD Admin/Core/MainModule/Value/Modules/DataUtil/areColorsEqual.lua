-- https://lua.expert

return function(p1, p2, p3) -- line: 1
    p3 = p3 or 0.001

    if p3 < math.abs(p1.R - p2.R) or p3 < math.abs(p1.G - p2.G) then
        return false
    end

    return not (p3 < math.abs(p1.B - p2.B))
end
