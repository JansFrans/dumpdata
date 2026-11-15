-- https://lua.expert

return function(p1) -- line: 2
    local tags = p1.tags

    return not (typeof(tags) == "table" and table.find(tags, "_Booster"))
end
