-- https://lua.expert

local function add(p1, ...) -- line: 18
    local t1 = {}

    for v1, _ in pairs(p1) do
        t1[v1] = true
    end

    for _, v2 in ipairs({ ... }) do
        t1[v2] = true
    end

    return t1
end

return add
