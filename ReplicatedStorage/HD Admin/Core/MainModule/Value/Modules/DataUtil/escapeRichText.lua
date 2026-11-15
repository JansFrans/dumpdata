-- https://lua.expert

return function(p1) -- line: 3
    return (p1:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;"):gsub("'", "&apos;"))
end
