-- https://lua.expert

local function entries(p1) -- line: 17
    local t1 = {}

    for v1, v2 in pairs(p1) do
        table.insert(t1, {
            v1,
            v2
        })
    end

    return t1
end

return entries
