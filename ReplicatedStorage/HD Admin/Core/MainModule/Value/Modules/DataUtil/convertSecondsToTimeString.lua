-- https://lua.expert

return function(p1) -- line: 1
    local v1 = tonumber(p1) or 0
    local v2 = v1 < 0
    local v3 = math.abs(v1) + 0.5
    local t1 = {
        y = 31540000,
        o = 2628000,
        w = 604800,
        d = 86400,
        h = 3600,
        m = 60,
        s = 1
    }
    local t2 = {}
    local v4 = math.floor(v3)

    for _, v5 in { "y", "o", "w", "d", "h", "m", "s" } do
        local v6 = t1[v5]

        if v6 <= v4 then
            local v8 = math.floor(v4 / v6)

            v4 -= v8 * v6
            table.insert(t2, tostring(v8) .. v5)
        end
    end

    if #t2 == 0 then
        return (if v2 then "-" else "") .. "0s"
    end

    local v10 = table.concat(t2)

    if v2 then
        v10 = "-" .. v10
    end

    return v10
end
