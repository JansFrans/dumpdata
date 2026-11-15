-- https://lua.expert

local None = require(script.Parent.Parent.None)
local copyDeep = require(script.Parent.copyDeep)

local function mergeDeep(...) -- line: 28
    -- upvalues: None (copy), copyDeep (copy), mergeDeep (copy)
    local t1 = {}

    for i = 1, select("#", ...) do
        local v1 = select(i, ...)

        if type(v1) == "table" then
            for v2, v3 in pairs(v1) do
                if v3 == None then
                    t1[v2] = nil
                elseif type(v3) == "table" then
                    if t1[v2] ~= nil then
                        if type(t1[v2]) == "table" then
                            t1[v2] = mergeDeep(t1[v2], v3)
                        else
                            t1[v2] = copyDeep(v3)
                        end
                    else
                        t1[v2] = copyDeep(v3)
                    end
                else
                    t1[v2] = v3
                end
            end
        end
    end

    return t1
end

return mergeDeep
