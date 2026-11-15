-- https://lua.expert

local function isSubset(p1, p2) -- line: 19
    for v1, v2 in pairs(p1) do
        if p2[v1] ~= v2 then
            return false
        end
    end

    return true
end

return isSubset
