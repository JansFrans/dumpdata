-- https://lua.expert

local t1 = {}
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Services = Modules.Parent.Services

require(Modules.Parser.ParserTypes)

function t1.getPlayersFromString(p1, p2) -- line: 15
    -- upvalues: t1 (copy), Modules (copy)
    local t2 = {}
    local Players = game:GetService("Players"):GetPlayers()
    local Config = require(Modules.Parent.Services.Config)
    local v1 = Config.getSetting("PlayerIdentifier", p2)
    local v2 = Config.getSetting("PlayerDefinedSearch", p2)
    local v3 = Config.getSetting("PlayerUndefinedSearch", p2)
    local v4 = p1:sub(1, 1) == v1
    local v5 = p1:lower()
    local v6 = t1.ternary(v4, v5:sub(2, #v5), v5)
    local v7 = t1.ternary(v4, v2 == "UserName", v3 == "UserName")
    local v8 = t1.ternary(v4, v2 == "DisplayName", v3 == "DisplayName")
    local v9 = t1.ternary(v4, v2 == "UserNameAndDisplayName", v3 == "UserNameAndDisplayName")

    if v7 or v9 then
        for _, player in Players do
            if string.find(player.Name:lower(), v6, 1, true) == 1 and table.find(t2, player) == nil then
                table.insert(t2, player)
            end
        end
    end

    if v8 or v9 then
        for _, player in Players do
            if string.find(player.DisplayName:lower(), v6, 1, true) == 1 and table.find(t2, player) == nil then
                table.insert(t2, player)
            end
        end
    end

    return t2
end

function t1.verifyAndParseUsername(p3, p4) -- line: 75
    -- upvalues: Modules (copy)
    if not p3 or not p4 then
        return false, nil
    end

    local Config = require(Modules.Parent.Services.Config)
    local v10 = Config.getSetting("PlayerIdentifier", p3)

    if string.sub(p4, 1, 1) == v10 then
        local v11 = Config.getSetting("PlayerDefinedSearch", p3)

        if v11 == "UserName" or v11 == "UserNameAndDisplayName" then
            return true, (string.sub(p4, 2))
        end
    else
        local v12 = Config.getSetting("PlayerUndefinedSearch", p3)

        if v12 == "UserName" or v12 == "UserNameAndDisplayName" then
            return true, p4
        end
    end

    return false, nil
end

function t1.getMatches(p5, p6) -- line: 99
    local t3 = {}

    for match in string.gmatch(p5, p6) do
        table.insert(t3, match)
    end

    return t3
end

function t1.getCapsuleRanges(p7) -- line: 110
    local t4 = {}
    local n1 = 0

    while true do
        if n1 == nil then
            return t4
        end

        local v13 = string.find(p7, "%(", n1)

        if not v13 then
            return t4
        end

        n1 = string.find(p7, "%)", v13)

        if n1 then
            table.insert(t4, {
                lower = v13,
                upper = n1
            })
            continue
        end

        break
    end

    return nil
end

function t1.getCapsuleCaptures(p8, p9) -- line: 134
    -- upvalues: t1 (copy), Modules (copy)
    local v14 = p8:lower()
    local t6 = {}

    for i = 1, #p9 do
        if string.match(v14, "^%s*$") ~= nil then
            break
        end

        local v15 = p9[i]:lower()

        if string.match(v15, "^%s*$") == nil then
            local v16 = t1.escapeSpecialCharacters(v15)
            local v17 = false
            local ParserPatterns = require(Modules.Parser.ParserPatterns)

            v14 = string.gsub(v14, string.format("(%s)%s", v16, ParserPatterns.capsuleFromKeyword), function(p10, p11) -- line: 162
                -- upvalues: t6 (copy), v17 (ref), ParserPatterns (copy), t1 (copy)
                if not v17 then
                    table.insert(t6, {
                        [p10] = t1.getMatches(p11, ParserPatterns.argumentsFromCollection)
                    })
                end

                v17 = true

                return ""
            end)
        end
    end

    return t6, v14
end

function t1.getPlainCaptures(p12, p13) -- line: 181
    -- upvalues: t1 (copy)
    local v18 = p12:lower()
    local t8 = {}

    for i = 1, #p13 do
        if string.match(v18, "^%s*$") ~= nil then
            break
        end

        local v19 = p13[i]:lower()

        if string.match(v19, "^%s*$") == nil then
            local v20 = t1.escapeSpecialCharacters(v19)
            local v21 = false

            v18 = string.gsub(v18, v20, function(p14, _) -- line: 203
                -- upvalues: t8 (copy), v21 (ref)
                if not v21 then
                    table.insert(t8, {
                        [p14] = {}
                    })
                end

                v21 = true

                return ""
            end)
        end
    end

    return t8, v18
end

function t1.combineCaptures(p16, p17) -- line: 217
    local t10 = {}

    for v22, v23 in p16 do
        t10[v22] = v23
    end

    for v24, v25 in p17 do
        if t10[v24] == nil then
            t10[v24] = v25
        end
    end

    return t10
end

function t1.escapeSpecialCharacters(p18) -- line: 233
    return (p18:gsub("([%.%%%^%$%(%)%[%]%+%*%-%?])", "%%%1"))
end

function t1.ternary(p19, p20, p21) -- line: 238
    if p19 then
        return p20
    end

    return p21
end

function t1.convertStatementToRealNames(p22) -- line: 246
    -- upvalues: Modules (copy), Services (copy)
    if p22.isConverted == true then
        return
    end

    p22.isConverted = true

    for v26, v27 in {
            commands = {
                Services.Commands,
                "getCommand"
            },
            modifiers = {
                Modules.Parser.Modifiers,
                "get"
            }
        } do
        local v28 = p22[v26]

        if v28 then
            local v29 = v27[1]
            local v30 = require(v29)[v27[2]]
            local t11 = {}
            local v31 = "original" .. v26:sub(1, 1):upper() .. v26:sub(2)
            local t12 = {}

            for v32, v33 in v28 do
                local v34 = v30(v32)

                v34 = v34 and (v34.aliasOf or v34.key)

                local v35 = v34 and string.lower(v34)

                if v35 then
                    t11[v35] = v33
                end

                t12[v32] = true
            end

            p22[v31] = t12
            p22[v26] = t11
        end
    end

    local t13 = {
        permjoin = { "perm", "join" },
        permspawn = { "perm", "spawn" },
        permschedule = { "perm", "schedule" },
        permloop = { "perm", "loop" },
        permdelay = { "perm", "delay" }
    }
    local modifiers = p22.modifiers

    if modifiers then
        for v36, v37 in t13 do
            local v38 = modifiers[v36]

            if v38 ~= nil then
                modifiers[v36] = nil

                for _, v39 in v37 do
                    if modifiers[v39] == nil then
                        modifiers[v39] = v38
                    end
                end
            end
        end
    end
end

return t1
