-- https://lua.expert

local function reduceRight(p1, p2, p3) -- line: 28
    local v1 = #p1
    local v2 = p3

    if p3 == nil then
        v2 = p1[v1]
        v1 -= 1
    end

    for i = v1, 1, -1 do
        v2 = p2(v2, p1[i], i, p1)
    end

    return v2
end

return reduceRight
