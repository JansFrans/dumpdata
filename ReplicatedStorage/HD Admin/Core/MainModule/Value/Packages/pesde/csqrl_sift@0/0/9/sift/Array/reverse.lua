-- https://lua.expert

local function reverse(p1) -- line: 17
    local t1 = {}

    for i = #p1, 1, -1 do
        table.insert(t1, p1[i])
    end

    return t1
end

return reverse
