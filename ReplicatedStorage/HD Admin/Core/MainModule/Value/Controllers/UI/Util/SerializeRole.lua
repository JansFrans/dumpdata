-- https://lua.expert

local t1 = {
    key = true,
    rank = true,
    internal = true,
    useDefaults = true
}
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local UI = Modules.Parent.Controllers.UI
local defaultRole = require(Modules.References.defaultRole)
local SettingsRole = require(UI.Config.SettingsRole)
local RoleLockRules = require(UI.Config.RoleLockRules)
local areValuesEqual = require(Modules.DataUtil.areValuesEqual)
local t2, t3

local function buildHeadingMaps() -- line: 26
    -- upvalues: SettingsRole (copy), t2 (ref), t3 (ref)
    if t2 and t3 then
        return
    end

    local t4 = {}
    local t5 = {}
    local t6 = {}

    for _, v1 in SettingsRole do
        local heading = v1.heading

        if typeof(heading) == "string" then
            if not t6[heading] then
                table.insert(t5, heading)
                t6[heading] = true
            end

            for _, v2 in v1.objects do
                if typeof(v2.title) == "string" then
                    t4[v2.title] = heading
                end
            end
        end
    end

    table.insert(t5, "Other")
    t2 = t4
    t3 = t5
end

local function valueToLuau(p1, p2) -- line: 49
    -- upvalues: valueToLuau (copy)
    local v3 = typeof(p1)

    if v3 == "boolean" or v3 == "number" then
        return (tostring(p1))
    end

    if v3 == "string" then
        return string.format("%q", p1)
    end

    if v3 == "Color3" then
        return (("Color3.fromRGB(%*, %*, %*)"):format(math.round(p1.R * 255), math.round(p1.G * 255), (math.round(p1.B * 255))))
    end

    if v3 ~= "table" then
        return (tostring(p1))
    end

    if #p1 > 0 then
        local v9 = true

        for _, v10 in p1 do
            local v11 = typeof(v10)

            if v11 ~= "number" and v11 ~= "string" and v11 ~= "boolean" then
                v9 = false
                break
            end
        end

        if v9 then
            local t7 = {}

            for _, v12 in p1 do
                table.insert(t7, valueToLuau(v12, p2))
            end

            return "{" .. table.concat(t7, ", ") .. "}"
        end

        local t8 = {}
        local v13 = p2 .. "\t"

        for _, v14 in p1 do
            table.insert(t8, v13 .. valueToLuau(v14, v13) .. ",")
        end

        return "{\n" .. table.concat(t8, "\n") .. "\n" .. p2 .. "}"
    end

    local t9 = {}

    for v16 in p1 do
        if typeof(v16) == "string" then
            table.insert(t9, v16)
        end
    end

    if #t9 == 0 then
        return "{}"
    end

    local t10 = {
        type = 1,
        groupId = 2,
        userId = 2,
        id = 2,
        preset = 3
    }

    table.sort(t9, function(p3, p4) -- line: 100
        -- upvalues: t10 (copy)
        local v17 = t10[p3] or 100
        local v18 = t10[p4] or 100

        if v17 == v18 then
            return p3 < p4
        end

        return v17 < v18
    end)

    local t11 = {}
    local v19 = p2 .. "\t"

    for _, v20 in t9 do
        table.insert(t11, (("%*%* = %*,"):format(v19, v20, (valueToLuau(p1[v20], v19)))))
    end

    return "{\n" .. table.concat(t11, "\n") .. "\n" .. p2 .. "}"
end

return function(p5) -- line: 119
    -- upvalues: t1 (copy), defaultRole (copy), RoleLockRules (copy), areValuesEqual (copy), t2 (ref), t3 (ref), buildHeadingMaps (copy), valueToLuau (copy)
    buildHeadingMaps()

    local t12 = t2
    local t13 = t3
    local t14 = {}

    for v22, v23 in p5 do
        if not t1[v22] then
            local v24 = defaultRole[v22]

            if (v24 ~= nil or v22 == "name") and not areValuesEqual(v23, v24) and not RoleLockRules.isSuppressed(v22, p5) then
                local v25 = t12[v22] or "Other"
                local v26 = t14[v25]

                if not v26 then
                    v26 = {}
                    t14[v25] = v26
                end

                table.insert(v26, {
                    title = v22,
                    value = v23
                })
            end
        end
    end

    local t16 = {}

    table.insert(t16, "return {")
    table.insert(t16, "")

    local v27 = true

    for _, v28 in t13 do
        local v29 = t14[v28]

        if v29 and #v29 ~= 0 then
            if not v27 then
                table.insert(t16, "")
            end

            local v30 = ("\t-- %*"):format(v28)

            v27 = false
            table.insert(t16, v30)

            for _, v31 in v29 do
                table.insert(t16, (("\t%* = %*,"):format(v31.title, (valueToLuau(v31.value, "\t")))))
            end
        end
    end

    table.insert(t16, "")
    table.insert(t16, "}")

    return table.concat(t16, "\n")
end
