-- https://lua.expert

local function isSimilar(p1, p2) -- line: 13
    local v1 = typeof(p1)
    local v2 = v1 == "table"
    local v3 = v1 == "userdata"
    local v4

    if v2 or v3 then
        if v1 == typeof(p2) and (v3 or table.isfrozen(p1) or getmetatable(p1) ~= nil) then
            return p1 == p2
        end

        v4 = false
    elseif p1 == p2 then
        v4 = true
    else
        local v5

        if p1 == p1 then
            v4 = false
        else
            v5 = p2 ~= p2

            return v5
        end
    end

    return v4
end

return isSimilar
