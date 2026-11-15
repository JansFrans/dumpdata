-- https://lua.expert

require(script.Parent.Parent.Types)

local function differenceSymmetric(p1, ...) -- line: 21
    local v1 = table.clone(p1)

    for _, v2 in { ... } do
        if typeof(v2) == "table" then
            for v3 in v2 do
                v1[v3] = v1[v3] == nil
            end
        end
    end

    for v4, v5 in v1 do
        if v5 then
            v1[v4] = true
        else
            v1[v4] = nil
        end
    end

    return v1
end

return differenceSymmetric
