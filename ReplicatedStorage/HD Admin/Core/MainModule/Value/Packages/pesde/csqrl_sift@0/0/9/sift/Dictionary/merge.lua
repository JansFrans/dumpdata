-- https://lua.expert

local None = require(script.Parent.Parent.None)

local function merge(...) -- line: 27
    -- upvalues: None (copy)
    local t1 = {}

    for i = 1, select("#", ...) do
        local v1 = select(i, ...)

        if type(v1) == "table" then
            for v2, v3 in pairs(v1) do
                if v3 == None then
                    t1[v2] = nil
                else
                    t1[v2] = v3
                end
            end
        end
    end

    return t1
end

return merge
