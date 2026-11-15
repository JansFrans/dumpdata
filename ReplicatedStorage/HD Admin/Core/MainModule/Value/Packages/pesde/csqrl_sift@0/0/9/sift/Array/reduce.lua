-- https://lua.expert

local function reduce(p1, p2, p3) -- line: 27
    local v1, v2

    if p3 ~= nil then
        v2 = p3
        v1 = 1
    else
        v2 = p1[1]
        v1 = 2
    end

    for i = v1, #p1 do
        v2 = p2(v2, p1[i], i, p1)
    end

    return v2
end

return reduce
