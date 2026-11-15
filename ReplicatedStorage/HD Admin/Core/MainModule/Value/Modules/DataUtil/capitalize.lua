-- https://lua.expert

return function(p1) -- line: 1
    local v1 = p1.lower(p1 or "")

    return v1:sub(1, 1):upper() .. v1:sub(2)
end
