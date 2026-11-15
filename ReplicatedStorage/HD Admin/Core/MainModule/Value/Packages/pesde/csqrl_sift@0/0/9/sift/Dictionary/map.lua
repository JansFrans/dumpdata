-- https://lua.expert

local function map(p1, p2) -- line: 26
    local t1 = {}

    for v1, v2 in pairs(p1) do
        local v3, v4 = p2(v2, v1, p1)

        t1[v4 or v1] = v3
    end

    return t1
end

return map
