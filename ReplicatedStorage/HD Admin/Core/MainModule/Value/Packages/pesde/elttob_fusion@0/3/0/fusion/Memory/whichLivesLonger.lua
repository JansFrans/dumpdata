-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)

local function whichScopeLivesLonger(p1, p2) -- line: 15
    local t1 = {}
    local v1 = { p1, p2 }
    local v2 = {}
    local v3 = 2
    local v4 = 0

    while true do
        if not (v3 > 0) then
            return "unsure"
        end

        v3 = v4

        for _, v5 in v1 do
            t1[v5] = true

            local v6 = v3

            for _, v7 in ipairs(v5) do
                if v7 == p1 then
                    return "definitely-b"
                end

                if v7 == p2 then
                    return "definitely-a"
                end

                if typeof(v7) == "table" and v7[1] ~= nil and t1[v5] == nil then
                    v6 += 1
                    v2[v6] = v7
                end

                v3 = v6
            end
        end

        table.clear(v1)
        v1, v2, v4 = v2, v1, 0
    end
end

local function whichLivesLonger(p3, p4, p5, p6) -- line: 51
    -- upvalues: External (copy), whichScopeLivesLonger (copy)
    if External.isTimeCritical() then
        return "unsure"
    end

    if p3 ~= p5 then
        return (whichScopeLivesLonger(p3, p5))
    end

    for i = #p3, 1, -1 do
        local v8 = p3[i]

        if v8 == p4 then
            return "definitely-b"
        end

        if v8 == p6 then
            return "definitely-a"
        end
    end

    return "unsure"
end

return whichLivesLonger
