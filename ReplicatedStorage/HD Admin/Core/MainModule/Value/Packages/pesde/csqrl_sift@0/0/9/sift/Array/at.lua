-- https://lua.expert

local function at(p1, p2) -- line: 19
    local v1 = #p1

    return p1[if p2 < 1 then p2 + v1 else p2]
end

return at
