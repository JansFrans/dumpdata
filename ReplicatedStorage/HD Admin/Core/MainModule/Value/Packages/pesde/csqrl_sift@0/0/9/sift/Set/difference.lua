-- https://lua.expert

require(script.Parent.Parent.Types)

local function difference(p1, ...) -- line: 21
    local v1 = table.clone(p1)

    for _, v2 in { ... } do
        if typeof(v2) == "table" then
            for v3 in v2 do
                v1[v3] = nil
            end
        end
    end

    return v1
end

return difference
