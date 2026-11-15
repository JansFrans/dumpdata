-- https://lua.expert

local function removeValue(p1, p2) -- line: 19
    local t1 = {}

    for v1, v2 in pairs(p1) do
        if v2 ~= p2 then
            t1[v1] = v2
        end
    end

    return t1
end

return removeValue
