-- https://lua.expert

return function(p1) -- line: 4
    local v1 = p1

    if p1 > 1E+08 then
        local v2 = #tostring(1E+08)

        v1 = tonumber((string.sub(tostring(p1), -v2)))
    end

    math.randomseed(v1)

    return v1
end
