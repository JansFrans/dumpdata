-- https://lua.expert

return function(_, p2, p3) -- line: 1
    if not p2 then
        return true, p3
    end

    local v1 = p2.DenyList or {}
    local v2 = p2.ReplaceList or {}
    local v3 = p2.AllowList or {}
    local v4 = v2[p3] or p3

    if #v3 > 0 then
        if table.find(v3, v4) then
            return true, v4
        end

        return false, (("%* is not within AllowList"):format(v4))
    end

    if table.find(v1, v4) then
        return false, (("%* is within DenyList"):format(v4))
    end

    return true, v4
end
