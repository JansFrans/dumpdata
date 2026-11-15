-- https://lua.expert

local function flip(p1) -- line: 17
    local t1 = {}

    for v1, v2 in pairs(p1) do
        t1[v2] = v1
    end

    return t1
end

return flip
