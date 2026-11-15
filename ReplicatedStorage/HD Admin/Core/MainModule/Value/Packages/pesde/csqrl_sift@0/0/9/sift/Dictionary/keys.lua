-- https://lua.expert

local function keys(p1) -- line: 17
    local t1 = {}

    for v1 in pairs(p1) do
        table.insert(t1, v1)
    end

    return t1
end

return keys
