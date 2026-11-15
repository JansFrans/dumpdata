-- https://lua.expert

local function findWhereLast(p1, p2, p3) -- line: 25
    local v1 = #p1

    if type(p3) == "number" then
        if p3 < 1 then
            v1 += p3
        else
            v1 = p3
        end
    end

    for i = v1, 1, -1 do
        if p2(p1[i], i, p1) then
            return i
        end
    end
end

return findWhereLast
