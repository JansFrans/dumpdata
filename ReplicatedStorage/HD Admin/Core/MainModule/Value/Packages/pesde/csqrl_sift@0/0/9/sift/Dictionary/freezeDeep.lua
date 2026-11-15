-- https://lua.expert

require(script.Parent.Parent.Types)

return ((function()
    local freezeDeep

    function freezeDeep(p1) -- line: 22
        -- upvalues: freezeDeep (ref)
        local t1 = {}

        for v1, v2 in pairs(p1) do
            if type(v2) == "table" then
                t1[v1] = freezeDeep(v2)
            else
                t1[v1] = v2
            end
        end

        table.freeze(t1)

        return t1
    end

    return freezeDeep
end)())
