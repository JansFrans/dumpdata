-- https://lua.expert

local ParentParent = script.Parent.Parent
local reduce = require(script.Parent.reduce)
local None = require(ParentParent.None)

local function zipAll(...) -- line: 24
    -- upvalues: reduce (copy), None (copy)
    local v1 = select("#", ...)
    local t1 = { ... }
    local t2 = {}

    if v1 ~= 0 then
        for i = 1,
        reduce(t1, function(p1, p2) -- line: 33
            return (math.max(p1, #p2))
        end, #t1[1]) do
            local t3 = {}

            for _, v3 in ipairs(t1) do
                local v4 = v3[i]

                if v4 == nil then
                    v4 = None
                end

                table.insert(t3, v4)
            end

            table.insert(t2, t3)
        end
    end

    return t2
end

return zipAll
