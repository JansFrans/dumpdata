-- https://lua.expert

local reduce = require(script.Parent.reduce)

local function zip(...) -- line: 20
    -- upvalues: reduce (copy)
    local v1 = select("#", ...)
    local t1 = { ... }
    local t2 = {}

    if v1 ~= 0 then
        for i = 1,
        reduce(t1, function(p1, p2) -- line: 30
            return (math.min(p1, #p2))
        end, #t1[1]) do
            local t3 = {}

            for _, v3 in ipairs(t1) do
                table.insert(t3, v3[i])
            end

            table.insert(t2, t3)
        end
    end

    return t2
end

return zip
