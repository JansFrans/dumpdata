-- https://lua.expert

return ((function()
    local deepEquals

    function deepEquals(p1, p2) -- line: 3
        -- upvalues: deepEquals (ref)
        if p1 == p2 then
            return true
        end

        if typeof(p1) ~= "table" or typeof(p2) ~= "table" then
            return false
        end

        for v1, v2 in p1 do
            if not deepEquals(v2, p2[v1]) then
                return false
            end
        end

        for v3 in p2 do
            if p1[v3] == nil then
                return false
            end
        end

        return true
    end

    return deepEquals
end)())
