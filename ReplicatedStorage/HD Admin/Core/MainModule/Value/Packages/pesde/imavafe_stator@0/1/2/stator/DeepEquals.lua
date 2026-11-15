-- https://lua.expert

return ((function()
    local DeepEquals

    function DeepEquals(p1, p2) -- line: 1
        -- upvalues: DeepEquals (ref)
        for v1, v2 in pairs(p1) do
            if typeof(v2) == "table" then
                if not DeepEquals(p2[v1], v2) then
                    return false
                end
            elseif v2 ~= p2[v1] then
                return false
            end
        end

        return true
    end

    return DeepEquals
end)())
