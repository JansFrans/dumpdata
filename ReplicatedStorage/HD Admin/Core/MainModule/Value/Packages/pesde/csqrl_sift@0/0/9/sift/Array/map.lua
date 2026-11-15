-- https://lua.expert

local function map(p1, p2) -- line: 20
    local t1 = {}

    for v1, v2 in ipairs(p1) do
        local v3 = p2(v2, v1, p1)

        if v3 ~= nil then
            table.insert(t1, v3)
        end
    end

    return t1
end

return map
