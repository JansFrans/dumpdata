-- https://lua.expert

local function insert(p1, p2, ...) -- line: 21
    local v1 = #p1
    local v2 = if p2 < 1 then p2 + (v1 + 1) else p2

    if v1 < v2 then
        if v1 + 1 < v2 then
            return p1
        end

        v2 = v1 + 1
        v1 += 1
    end

    local t1 = {}

    for i = 1, v1 do
        if i == v2 then
            for _, v3 in ipairs({ ... }) do
                table.insert(t1, v3)
            end
        end

        table.insert(t1, p1[i])
    end

    return t1
end

return insert
