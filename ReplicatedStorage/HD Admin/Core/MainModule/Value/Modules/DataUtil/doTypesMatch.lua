-- https://lua.expert

return function(p1, p2) -- line: 1
    local v1 = typeof(p1)

    if v1 ~= typeof(p2) then
        return false
    end

    if v1 == "EnumItem" then
        if p1.EnumType ~= p2.EnumType then
            return false
        end
    elseif v1 == "Instance" and p1.ClassName ~= p2.ClassName then
        return false
    end

    return true
end
