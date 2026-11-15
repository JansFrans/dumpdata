-- https://lua.expert

local function toPascalCase(p1) -- line: 1
    if p1 == nil or p1 == "" then
        return ""
    end

    local t1 = {}

    for match in p1:gsub("[^%w]", " "):gsub("(%l)(%u)", "%1 %2"):gsub("(%u)(%u%l)", "%1 %2"):gmatch("%S+") do
        table.insert(t1, match)
    end

    if #t1 == 0 then
        return ""
    end

    local t2 = {}

    for i = 1, #t1 do
        local v1 = t1[i]
        local v2 = v1:sub(1, 1)
        local v3 = v1:sub(2)

        t2[i] = string.upper(v2) .. string.lower(v3)
    end

    return table.concat(t2, "")
end

return toPascalCase
