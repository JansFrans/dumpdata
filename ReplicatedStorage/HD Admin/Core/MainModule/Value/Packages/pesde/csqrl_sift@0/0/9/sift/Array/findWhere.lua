-- https://lua.expert

local function findWhere(p1, p2, p3) -- line: 21
    local v1 = #p1

    for i = if type(p3) ~= "number" then 1 elseif p3 < 1 then v1 + p3 else p3, #p1 do
        if p2(p1[i], i, p1) then
            return i
        end
    end
end

return findWhere
