-- https://lua.expert

local function findLast(p1, p2, p3) -- line: 20
    local v1 = #p1

    if type(p3) == "number" then
        if p3 < 1 then
            v1 += p3
        else
            v1 = p3
        end
    end

    for i = v1, 1, -1 do
        if p1[i] == p2 then
            return i
        end
    end
end

return findLast
