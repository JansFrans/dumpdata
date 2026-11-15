-- https://lua.expert

local function push(p1, ...) -- line: 22
    local t1 = {}

    for _, v1 in ipairs(p1) do
        table.insert(t1, v1)
    end

    for _, v2 in ipairs({ ... }) do
        table.insert(t1, v2)
    end

    return t1
end

return push
