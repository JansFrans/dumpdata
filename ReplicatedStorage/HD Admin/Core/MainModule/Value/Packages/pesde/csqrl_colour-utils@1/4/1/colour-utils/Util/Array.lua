-- https://lua.expert

local insert = table.insert

return {
    map = function(p1, p2) -- map | line: 3
        -- upvalues: insert (copy)
        local t1 = {}

        for v1, v2 in ipairs(p1) do
            local v3 = p2(v2, v1)

            if v3 ~= nil then
                insert(t1, v3)
            end
        end

        return t1
    end,
    reduce = function(p3, p4, p5) -- reduce | line: 17
        local v5 = p5 or p3[1]
        local v4 = if p5 then 1 else 2

        for i = v4, #p3 do
            v5 = p4(v5, p3[i], i)
        end

        return v5
    end
}
