-- https://lua.expert

return function(p1) -- line: 1
    local v1 = string.len(p1) * 0.08 + 2

    if v1 > 10 then
        v1 = 10
    end

    return v1
end
