-- https://lua.expert

local function is(p1) -- line: 21
    if typeof(p1) == "table" and #p1 > 0 then
        return next(p1, #p1) == nil
    end

    return false
end

return is
