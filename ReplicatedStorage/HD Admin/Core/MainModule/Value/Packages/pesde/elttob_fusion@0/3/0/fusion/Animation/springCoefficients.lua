-- https://lua.expert

local function springCoefficients(p1, p2, p3) -- line: 22
    if p1 == 0 or p3 == 0 then
        return 1, 0, 0, 1
    end

    if p2 > 1 then
        local v2 = math.sqrt(p2 ^ 2 - 1)
        local v3 = -0.5 / (v2 * p3)
        local v4 = p3 * (v2 + p2) * -1
        local v5 = p3 * (v2 - p2)
        local v7 = math.exp(p1 * v4)
        local v9 = math.exp(p1 * v5)

        return (v9 * v4 - v7 * v5) * v3, (v7 - v9) * v3 / p3, (v9 - v7) * v3 * p3, (v7 * v4 - v9 * v5) * v3
    end

    if p2 == 1 then
        local v10 = p1 * p3
        local v11 = v10 * -1
        local v12 = math.exp(v11)

        return v12 * (v10 + 1), v12 * p1, v12 * (v11 * p3), v12 * (v11 + 1)
    end

    local v14 = p3 * math.sqrt(1 - p2 ^ 2)
    local v15 = 1 / v14
    local v17 = math.exp(p1 * -1 * p3 * p2)
    local v19 = math.sin(v14 * p1)
    local v21 = math.cos(v14 * p1)
    local v22 = v17 * v19
    local v23 = v17 * v21
    local v24 = v22 * p3 * p2 * v15

    return v24 + v23, v22 * v15, (v22 * v14 + p3 * p2 * v24) * -1, v23 - v24
end

return springCoefficients
