-- https://lua.expert

local t1 = {
    { 1E+09, "B" },
    { 1E+06, "M" },
    { 1000, "K" }
}

return function(p1) -- line: 10
    -- upvalues: t1 (copy)
    local v1 = math.floor(p1)

    for v2, v3 in t1 do
        local v4 = v3[1]
        local v5 = v3[2]

        if v4 <= v1 then
            local v6 = v1 / v4
            local v7 = if v6 < 10 then 2 elseif v6 < 100 then 1 else 0
            local v8 = string.format(("%%.%*f"):format(v7), v6)

            if v7 > 0 then
                v8 = v8:gsub("0+$", ""):gsub("%.$", "")
            end

            local v9 = t1[v2 - 1]

            if v9 and tonumber(v8) >= 1000 then
                return "1" .. v9[2]
            end

            return v8 .. v5
        end
    end

    return (tostring(v1))
end
