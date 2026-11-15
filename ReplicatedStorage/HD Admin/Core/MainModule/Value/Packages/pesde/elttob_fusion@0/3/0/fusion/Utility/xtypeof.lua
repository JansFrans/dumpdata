-- https://lua.expert

local function xtypeof(p1) -- line: 12
    local v1 = typeof(p1)

    if not (v1 == "table" and typeof(p1.type) == "string") then
        return v1
    end

    return p1.type
end

return xtypeof
