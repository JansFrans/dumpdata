-- https://lua.expert

local function some(p1, p2) -- line: 24
    for v1, v2 in pairs(p1) do
        if p2(v2, v1, p1) then
            return true
        end
    end

    return false
end

return some
