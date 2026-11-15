-- https://lua.expert

local function set(p1, p2, p3) -- line: 20
    local v1 = #p1
    local t1 = {}
    local v2 = if p2 < 1 then p2 + v1 else p2

    for v3, v4 in ipairs(p1) do
        if v3 == v2 then
            table.insert(t1, p3)
        else
            table.insert(t1, v4)
        end
    end

    return t1
end

return set
