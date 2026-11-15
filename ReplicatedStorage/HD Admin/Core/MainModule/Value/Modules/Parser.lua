-- https://lua.expert

local t1 = {}
local Modules = script:FindFirstAncestor("MainModule").Value.Modules

require(script.ParserTypes)

function t1.parse(p1, p2) -- line: 13
    -- upvalues: Modules (copy)
    local Services = Modules.Parent.Services
    local Commands = require(Services.Commands)
    local Config = require(Modules.Parent.Services.Config)

    require(Modules.Parser.Modifiers)
    require(Modules.Objects.User)

    local Algorithm = require(script.Algorithm)

    require(script.Parent.CommandUtil.forEveryCommand)

    local ParsedData = require(script.ParsedData)
    local t2 = {}
    local v1 = if typeof(p1) == "string" then p1 else ""

    if #v1 > 1000 then
        v1 = string.sub(v1, 1, 1000)
    end

    local v2 = string.gsub(v1, "&gt;", ">")
    local v3 = string.gsub(v2, "&lt;", "<")

    if string.sub(v3, 1, 3) == "/e " then
        v3 = string.sub(v3, 4)
    end

    local v4 = string.find(v3, "%S")
    local v5 = if v4 then string.sub(v3, v4, v4) else nil

    if v5 == nil then
        return {}
    end

    local v8 = string.sub(v3, v4 + 1, v4 + 1)
    local v9 = Commands.getCommandPrefixes()
    local Prefix = Config.getSetting("Prefix")
    local v10 = Config.getSetting("Prefix", p2)
    local v11 = v5 ~= Prefix and v5 ~= v10
    local t3 = {}

    t3[Prefix] = true
    t3[v10] = true

    for v12, _ in v9 do
        t3[v12] = true
    end

    if not t3[v5] then
        return {}
    end

    for _, v13 in (Algorithm.getCommandStatementsFromBatch(v3, v5)) do
        local v14 = ParsedData.generateEmptyParsedData(v5)

        v14.commandStatement = v13
        ParsedData.parseCommandStatement(v14)

        if v14.isValid then
            ParsedData.parseCommandDescriptionAndSetFlags(v14, p2)

            if v14.isValid then
                ParsedData.parseQualifierDescription(v14)

                if v14.isValid then
                    ParsedData.parseExtraArgumentDescription(v14, t2, v3)
                    table.insert(t2, v14)

                    if v14.hasTextArgument then
                        break
                    end
                else
                    table.insert(t2, v14)
                end
            else
                table.insert(t2, v14)
            end
        else
            table.insert(t2, v14)
        end
    end

    local v15 = ParsedData.generateOrganizedParsedData(t2)

    for _, v16 in v15 do
        local modifiers = v16.modifiers
        local t4 = {}
        local commands = v16.commands

        for v17, _ in commands do
            local v18, v19 = Commands.getCommand(v17, v5)

            if v18 ~= nil then
                local prefixes = v18.prefixes
                local v20

                if not v11 or v19 then
                    v20 = true
                else
                    v20 = false

                    if prefixes then
                        for _, v21 in prefixes do
                            if v21 == v5 then
                                v20 = true
                                break
                            end

                            v20 = false
                        end
                    end
                end

                local v22 = v5 == v8

                if v19 then
                    local v23 = v5 .. v17

                    if v20 then
                        t4[v17] = v23

                        if v20 == false then
                            ParsedData.invalidateStatement(v16, (("Command '%*' is not valid with prefix '%*"):format(v23, v5)))
                        else
                            local v24 = v23:lower()
                            local undoAliases = v18.undoAliases

                            if typeof(undoAliases) == "table" and not modifiers.undo and not modifiers.un then
                                for _, v25 in undoAliases do
                                    if typeof(v25) == "string" and v25:lower() == v24 then
                                        modifiers.undo = {}
                                    end
                                end
                            end
                        end
                    elseif Commands.getCommand(v23) ~= nil then
                        t4[v17] = v23

                        local v26 = v23:lower()
                        local undoAliases = v18.undoAliases

                        if typeof(undoAliases) == "table" and not modifiers.undo and not modifiers.un then
                            for _, v27 in undoAliases do
                                if typeof(v27) == "string" and v27:lower() == v26 then
                                    modifiers.undo = {}
                                end
                            end
                        end
                    else
                        ParsedData.invalidateStatement(v16, (("Override command '%*' does not exist"):format(v23)))
                    end
                elseif v20 then
                    local v28 = v17

                    if v22 then
                        v28 = v5 .. v17
                        t4[v17] = v28
                    end

                    if v20 == false then
                        ParsedData.invalidateStatement(v16, (("Command '%*' is not valid with prefix '%*"):format(v28, v5)))
                    else
                        local v29 = v28:lower()
                        local undoAliases = v18.undoAliases

                        if typeof(undoAliases) == "table" and not modifiers.undo and not modifiers.un then
                            for _, v30 in undoAliases do
                                if typeof(v30) == "string" and v30:lower() == v29 then
                                    modifiers.undo = {}
                                end
                            end
                        end
                    end
                else
                    local v31 = v5 .. v17

                    if Commands.getCommand(v31) ~= nil then
                        t4[v17] = v31

                        local v32 = v31:lower()
                        local undoAliases = v18.undoAliases

                        if typeof(undoAliases) == "table" and not modifiers.undo and not modifiers.un then
                            for _, v33 in undoAliases do
                                if typeof(v33) == "string" and v33:lower() == v32 then
                                    modifiers.undo = {}
                                end
                            end
                        end
                    else
                        ParsedData.invalidateStatement(v16, (("Override command '%*' does not exist"):format(v31)))
                    end
                end
            else
                ParsedData.invalidateStatement(v16, (("Command '%*' does not exist"):format(v17)))
            end
        end

        for v34, v35 in t4 do
            commands[v35] = commands[v34]
            commands[v34] = nil
        end
    end

    return v15
end

function t1.addCapsule(p3, p4) -- line: 184
    -- upvalues: Modules (copy)
    local Collective = require(Modules.Parser.ParserSettings).Collective
    local v36 = if typeof(p4) == "table" then table.concat(p4, Collective) else p4

    if v36 ~= "" and v36 ~= " " then
        return (("%*(%*)"):format(p3, v36))
    end

    return p3
end

function t1.unparse(p5, p6, ...) -- line: 200
    -- upvalues: t1 (copy), Modules (copy)
    local v37 = require(Modules.CommandUtil.getCommand)(p5)

    if not v37 then
        return ";unknownResult"
    end

    local args = v37.args
    local Args = require(Modules.Parser.Args)
    local t5 = { ... }
    local t6 = {}

    local function forEveryArg(p7) -- line: 220
        -- upvalues: args (copy), Args (copy)
        for v38, v39 in args do
            p7(Args.get(v39) or v39, v38)
        end
    end

    local n1 = 0
    local n2 = 0

    forEveryArg(function(p8, p9) -- line: 229
        -- upvalues: n1 (ref), n2 (ref)
        if p8.endlessArg then
            if n1 == 0 then
                n2 = p9
            end

            n1 += 1
        end
    end)

    local ParserSettings = require(Modules.Parser.ParserSettings)
    local v40 = #args
    local t7 = {}

    forEveryArg(function(p10, p11) -- line: 242
        -- upvalues: t5 (copy), t6 (copy), n1 (ref), n2 (ref), ParserSettings (copy), v40 (copy), t7 (copy)
        local v41 = p10 and p10.hidden == true and not p10.playerArg
        local v42 = t5[p11] == ParserSettings.EmptyUnparsedValue

        if not v42 or v41 then
            local v43, v44

            if not p10 or not p10.unparse or v42 then
                v44 = ""
            else
                local v45 = p10:unparse(t5[p11])

                if typeof(v45) == "string" then
                    v43 = if not (n2 <= p11) or not (n1 > 1) or p11 == v40 then v45 else v45 .. ParserSettings.EndlessArgCutPattern
                    v44 = v43
                else
                    v44 = ""
                end
            end

            if not p10.playerArg or v44 ~= "" then
                if v41 then
                    table.insert(t7, v44)
                else
                    table.insert(t6, v44)
                end
            end
        else
            table.insert(t6, ParserSettings.EmptyUnparsedValue)
        end
    end)

    for i = #t7, 1, -1 do
        if t7[i] ~= "" then
            break
        end

        table.remove(t7, i)
    end

    if p6 and #p6 >= 2 then
        for v46, v47 in p6 do
            if not string.find(v47, "%b()") then
                p6[v46] = v47 .. "()"
            end
        end
    end

    local t8 = {}
    local capitalize = require(Modules.DataUtil.capitalize)

    if p6 then
        for _, v48 in p6 do
            table.insert(t8, (capitalize(v48)))
        end
    end

    table.insert(t8, (capitalize(v37.name or p5)))
    t8[1] = (t8[1] or ""):lower()

    local SpaceSeparator = ParserSettings.SpaceSeparator
    local v51 = table.concat(t6, SpaceSeparator)
    local v52 = table.concat(t8, "")
    local v53 = t1.addCapsule("", t7)
    local getYouSetting = require(Modules.CommandUtil.getYouSetting)

    return (("%*%*%*%*%*"):format(v37.prefix or getYouSetting("Prefix") or "", v52, v53, SpaceSeparator, v51))
end

return t1
