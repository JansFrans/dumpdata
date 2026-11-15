-- https://lua.expert

local copy = require(script.Parent.copy)

local function shuffle(p1) -- line: 19
    -- upvalues: copy (copy)
    local v1 = Random.new(os.time() * #p1)
    local v2 = copy(p1)

    for i = #v2, 1, -1 do
        local v3 = v1:NextInteger(1, i)
        local v4 = v2[i]

        v2[i] = v2[v3]
        v2[v3] = v4
    end

    return v2
end

return shuffle
