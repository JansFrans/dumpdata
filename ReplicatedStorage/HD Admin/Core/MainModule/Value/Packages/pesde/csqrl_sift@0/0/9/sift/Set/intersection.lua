-- https://lua.expert

local function intersection(...) -- line: 20
    local v1 = select("#", ...)
    local v2 = select(1, ...)
    local t1 = {}

    for v3, _ in pairs(v2) do
        local v4 = true

        for i = 2, v1 do
            if select(i, ...)[v3] ~= true then
                v4 = false
                break
            end
        end

        if v4 then
            t1[v3] = true
        end
    end

    return t1
end

return intersection
