-- https://lua.expert

return function(p1) -- line: 1
    local v1 = table.create(#p1)

    for v2, v3 in p1 do
        v1[v2] = v3
    end

    return v1
end
