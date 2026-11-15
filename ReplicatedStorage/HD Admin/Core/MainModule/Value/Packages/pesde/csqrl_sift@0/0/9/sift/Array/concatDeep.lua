-- https://lua.expert

local ParentParent = script.Parent.Parent
local copyDeep = require(script.Parent.copyDeep)
local None = require(ParentParent.None)

local function concatDeep(...) -- line: 28
    -- upvalues: copyDeep (copy), None (copy)
    local t1 = {}

    for i = 1, select("#", ...) do
        local v1 = select(i, ...)

        if type(v1) == "table" then
            for _, v2 in ipairs(v1) do
                if v2 ~= None then
                    if type(v2) == "table" then
                        table.insert(t1, copyDeep(v2))
                    else
                        table.insert(t1, v2)
                    end
                end
            end
        end
    end

    return t1
end

return concatDeep
