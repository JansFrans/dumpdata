-- https://lua.expert

local function values(p1) -- line: 17
    local t1 = {}

    for _, v1 in pairs(p1) do
        table.insert(t1, v1)
    end

    return t1
end

return values
