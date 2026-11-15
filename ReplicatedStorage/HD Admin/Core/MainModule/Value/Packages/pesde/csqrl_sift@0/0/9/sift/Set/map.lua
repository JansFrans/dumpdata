-- https://lua.expert

local function map(p1, p2) -- line: 20
    local t1 = {}

    for v1, _ in pairs(p1) do
        local v2 = p2(v1, p1)

        if v2 ~= nil then
            t1[v2] = true
        end
    end

    return t1
end

return map
