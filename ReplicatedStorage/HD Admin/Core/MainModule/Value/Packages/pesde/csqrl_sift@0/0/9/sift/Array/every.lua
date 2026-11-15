-- https://lua.expert

local function every(p1, p2) -- line: 24
    for v1, v2 in ipairs(p1) do
        if not p2(v2, v1, p1) then
            return false
        end
    end

    return true
end

return every
