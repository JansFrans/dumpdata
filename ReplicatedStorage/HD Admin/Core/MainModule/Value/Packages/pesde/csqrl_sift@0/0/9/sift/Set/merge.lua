-- https://lua.expert

local function merge(...) -- line: 20
    local t1 = {}

    for i = 1, select("#", ...) do
        local v1 = select(i, ...)

        if type(v1) == "table" then
            for v2, _ in pairs(v1) do
                t1[v2] = true
            end
        end
    end

    return t1
end

return merge
