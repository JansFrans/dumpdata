-- https://lua.expert

local None = require(script.Parent.Parent.None)

local function concat(...) -- line: 26
    -- upvalues: None (copy)
    local t1 = {}

    for i = 1, select("#", ...) do
        local v1 = select(i, ...)

        if type(v1) == "table" then
            for _, v2 in ipairs(v1) do
                if v2 ~= None then
                    table.insert(t1, v2)
                end
            end
        end
    end

    return t1
end

return concat
