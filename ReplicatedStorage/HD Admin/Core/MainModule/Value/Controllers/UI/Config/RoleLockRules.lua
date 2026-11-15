-- https://lua.expert

local t1 = {
    {
        prefix = "permit",
        parent = "permitAll",
        exclude = { "permitAll" }
    },
    {
        titles = { "permitMultipleTargets" },
        requiredTrue = { "permitTargetingOthers" }
    },
    {
        prefix = "mayEdit",
        parent = "mayEditAll",
        exclude = { "mayEditAll" }
    },
    {
        prefix = "mayVet",
        parent = "mayEditAll"
    },
    {
        prefix = "mayView",
        parent = "mayViewAll",
        exclude = { "mayViewAll" }
    },
    {
        prefix = "prompt",
        parent = "promptAll",
        exclude = { "promptAll" }
    },
    {
        prefix = "giveTo",
        parent = "giveToEveryone",
        exclude = { "giveToEveryone" }
    },
    {
        prefix = "limit",
        parents = { "permitAll", "permitBypassLimits" }
    }
}
local t2 = {}

local function titleMatches(p1, p2) -- line: 39
    if p1.titles then
        for _, v1 in p1.titles do
            if v1 == p2 then
                return true
            end
        end

        return false
    end

    if not p1.prefix or p2:sub(1, #p1.prefix) ~= p1.prefix then
        return false
    end

    if p1.exclude then
        for _, v2 in p1.exclude do
            if v2 == p2 then
                return false
            end
        end
    end

    return true
end

function t2.getRulesFor(p3) -- line: 60
    -- upvalues: t1 (copy), titleMatches (copy)
    local t3 = {}

    for _, v3 in t1 do
        if titleMatches(v3, p3) then
            table.insert(t3, v3)
        end
    end

    return t3
end

function t2.isSuppressed(p4, p5) -- line: 71
    -- upvalues: t2 (copy)
    for _, v4 in t2.getRulesFor(p4) do
        if v4.parent and p5[v4.parent] == true then
            return true
        end

        if v4.parents then
            for _, v5 in v4.parents do
                if p5[v5] == true then
                    return true
                end
            end
        end

        if v4.requiredTrue then
            for _, v6 in v4.requiredTrue do
                if p5[v6] ~= true then
                    return true
                end
            end
        end
    end

    return false
end

function t2.isEffectivelyEnabledOnRole(p6, p7) -- line: 91
    -- upvalues: t2 (copy)
    if typeof(p6) ~= "table" then
        return false
    end

    if p6[p7] == true then
        return true
    end

    for _, v7 in t2.getRulesFor(p7) do
        if v7.parent and p6[v7.parent] == true then
            return true
        end

        if v7.parents then
            for _, v8 in v7.parents do
                if p6[v8] == true then
                    return true
                end
            end
        end
    end

    return false
end

function t2.isForcedOnRole(p8, p9) -- line: 108
    -- upvalues: t2 (copy)
    if typeof(p8) ~= "table" or p8[p9] == true then
        return false
    end

    for _, v9 in t2.getRulesFor(p9) do
        if v9.parent and p8[v9.parent] == true then
            return true
        end

        if v9.parents then
            for _, v10 in v9.parents do
                if p8[v10] == true then
                    return true
                end
            end
        end
    end

    return false
end

return t2
