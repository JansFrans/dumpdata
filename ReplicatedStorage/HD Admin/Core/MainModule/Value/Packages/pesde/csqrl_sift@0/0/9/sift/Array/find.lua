-- https://lua.expert

local function find(p1, p2, p3) -- line: 25
    local v1 = #p1
    local v2 = if type(p3) ~= "number" then 1 elseif p3 < 1 then v1 + p3 else p3

    return table.find(p1, p2, v2)
end

return find
