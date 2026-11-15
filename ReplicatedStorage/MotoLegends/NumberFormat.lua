-- https://lua.expert

local t1 = {}
local t2 = {
    { 1E+12, "T" },
    { 1E+09, "B" },
    { 1E+06, "M" },
    { 1000, "k" }
}

local function oneDecimal(p1) -- line: 5
    local v2 = math.floor(p1 * 10 + 1E-06) / 10

    if v2 % 1 ~= 0 then
        return string.format("%.1f", v2)
    end

    return (tostring((math.floor(v2))))
end

function t1.Short(p2) -- line: 10
    -- upvalues: t2 (copy)
    local v4 = tonumber(p2) or 0

    if v4 ~= v4 then
        v4 = 0
    end

    local v5 = if v4 < 0 then "-" else ""
    local v6 = math.abs(v4)

    if v6 < 1000 then
        return v5 .. tostring((math.floor(v6)))
    end

    for _, v8 in t2 do
        if v8[1] <= v6 then
            local v10 = math.floor(v6 / v8[1] * 10 + 1E-06) / 10

            return v5 .. (if v10 % 1 == 0 then tostring((math.floor(v10))) else string.format("%.1f", v10)) .. v8[2]
        end
    end

    return v5 .. tostring((math.floor(v6)))
end

function t1.Full(p3) -- line: 22
    local v14 = tonumber(p3) or 0

    if v14 ~= v14 then
        v14 = 0
    end

    local v15 = if v14 < 0 then "-" else ""
    local v17 = string.format("%d", (math.floor((math.abs(v14))))):reverse():gsub("(%d%d%d)", "%1,"):reverse()

    if v17:sub(1, 1) == "," then
        v17 = v17:sub(2)
    end

    return v15 .. v17
end

function t1.Money(p4) -- line: 32
    -- upvalues: t1 (copy)
    return "$" .. t1.Short(p4)
end

return t1
