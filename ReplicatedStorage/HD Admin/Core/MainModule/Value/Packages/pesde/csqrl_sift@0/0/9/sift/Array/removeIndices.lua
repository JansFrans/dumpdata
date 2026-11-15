-- https://lua.expert

local function removeIndices(p1, ...) -- line: 19
    local v1 = #p1
    local t1 = {}
    local t2 = {}

    for _, v2 in ipairs({ ... }) do
        t1[if v2 < 1 then v2 + v1 else v2] = true
    end

    for v3, v4 in ipairs(p1) do
        if not t1[v3] then
            table.insert(t2, v4)
        end
    end

    return t2
end

return removeIndices
