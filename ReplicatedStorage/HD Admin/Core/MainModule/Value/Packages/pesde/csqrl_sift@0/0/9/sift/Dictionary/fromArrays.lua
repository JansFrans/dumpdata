-- https://lua.expert

local function fromArrays(p1, p2) -- line: 20
    local v1 = #p1
    local t1 = {}

    for i = 1, v1 do
        t1[p1[i]] = p2[i]
    end

    return t1
end

return fromArrays
