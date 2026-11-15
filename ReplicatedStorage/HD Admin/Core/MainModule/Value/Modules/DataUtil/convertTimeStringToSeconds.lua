-- https://lua.expert

return function(p1) -- line: 1
    local t1 = {
        s = 1,
        m = 60,
        h = 3600,
        d = 86400,
        w = 604800,
        o = 2628000,
        y = 31540000
    }
    local v1 = tonumber(p1) or 0

    for match, v2 in string.gmatch(p1, "(%d+)(%a)") do
        if t1[v2] then
            v1 += match * t1[v2]
        end
    end

    return v1
end
