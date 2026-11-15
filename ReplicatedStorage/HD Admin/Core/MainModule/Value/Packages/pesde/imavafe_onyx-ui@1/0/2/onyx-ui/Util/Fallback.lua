-- https://lua.expert

require(script.Parent.Parent.Parent.Fusion)

local function IsReactive(p1) -- line: 18
    if typeof(p1) == "table" then
        return p1.scope ~= nil
    end

    return false
end

local function FallbackUtil(p2, p3) -- line: 22
    if p2 == nil then
        return p3
    end

    return p2
end

local function FallbackDictionary(p4, p5) -- line: 30
    if (typeof(p4) ~= "table" or p4.scope == nil) and (typeof(p5) ~= "table" or p5.scope == nil) and typeof(p4) == "table" and typeof(p5) == "table" then
        for v1, v2 in pairs(p5) do
            local v3 = p4[v1]

            if v3 == nil then
                v3 = v2
            end

            p4[v1] = v3
        end

        return p4
    end

    if p4 == nil then
        return p5
    end

    return p4
end

return FallbackDictionary
