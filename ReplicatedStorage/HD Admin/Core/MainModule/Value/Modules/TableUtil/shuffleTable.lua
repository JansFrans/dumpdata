-- https://lua.expert

return function(p1) -- line: 1
    assert(type(p1) == "table", "First argument must be a table")

    for i = #p1, 1, -1 do
        local v2 = math.random(i)
        local v3 = p1[i]

        p1[i] = p1[v2]
        p1[v2] = v3
    end

    return p1
end
