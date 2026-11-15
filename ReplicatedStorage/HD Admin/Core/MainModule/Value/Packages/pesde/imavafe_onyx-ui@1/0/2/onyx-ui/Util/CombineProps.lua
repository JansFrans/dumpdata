-- https://lua.expert

require(script.Parent.Parent.Parent.Fusion)

return ((function()
    local CombineProps

    function CombineProps(p1, p2, p3) -- line: 16
        -- upvalues: CombineProps (ref)
        for v1, v2 in pairs(p1) do
            if typeof(v2) == "table" and v2.kind == nil then
                if typeof(p2[v1]) == "table" then
                    p2[v1] = CombineProps(v2, p2[v1])
                elseif p3 == nil or table.find(p3, v1) == nil then
                    p2[v1] = v2
                end
            elseif p3 == nil or table.find(p3, v1) == nil then
                p2[v1] = v2
            end
        end

        return p2
    end

    return CombineProps
end)())
