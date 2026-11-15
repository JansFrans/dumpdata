-- https://lua.expert

return {
    Loose = function(p1, p2) -- Loose | line: 1
        if type(p2) ~= "table" then
            return p1
        end

        local t1 = {}

        for v1, v2 in pairs(p1) do
            t1[v1] = p2[v1] or v2
        end

        return t1
    end,
    Strict = function(p3, p4) -- Strict | line: 15
        if type(p4) ~= "table" then
            return p3
        end

        local t2 = {}

        for v3, v4 in pairs(p3) do
            if typeof(p4[v3]) == typeof(v4) then
                t2[v3] = p4[v3]
            else
                t2[v3] = v4
            end
        end

        return t2
    end
}
