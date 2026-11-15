-- https://lua.expert

return function(p1) -- line: 1
    local n1 = 0

    for _, _ in p1 do
        n1 += 1
    end

    return n1
end
