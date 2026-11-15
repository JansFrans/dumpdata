-- https://lua.expert

game:GetService("EncodingService")

local t1 = {}
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Services = Modules.Parent.Services
local Commands = require(Services.Commands)

require(Modules.Parser.ParserTypes)

local Args = require(Modules.Parser.Args)
local Config = require(Modules.Parent.Services.Config)

require(Modules.Parent.Services.Config.Settings)

function t1.generateEmptyParsedData(p1) -- line: 23
    return {
        commandStatement = nil,
        commandDescription = nil,
        qualifierDescription = nil,
        extraArgumentDescription = nil,
        prematureQualifierParsing = false,
        commandDescriptionResdiue = nil,
        requiresQualifier = false,
        hasEndlessArgument = false,
        isValid = true,
        parserRejection = nil,
        givenPrefix = p1,
        commandCaptures = {},
        modifierCaptures = {},
        qualifierCaptures = {},
        unrecognizedQualifiers = {}
    }
end

function t1.requiresQualifier(p2, p3) -- line: 48
    -- upvalues: Commands (copy), Args (copy)
    local v1 = Commands.getCommand(p2, p3)

    if not v1 then
        return "Never"
    end

    local args = v1.args

    if #args == 0 then
        return "Never"
    end

    local v2 = args[1]
    local v3 = Args.get(v2)

    if v3 == nil or v3.playerArg ~= true then
        return "Never"
    end

    if v3.hidden == true then
        return "Sometimes"
    end

    return "Always"
end

function t1.parsedDataSetRequiresQualifierFlag(p4, p5) -- line: 70
    -- upvalues: t1 (copy), Modules (copy), Config (copy)
    local givenPrefix = p4.givenPrefix
    local v4 = "Sometimes"

    for _, v5 in p4.commandCaptures do
        local v6 = v4

        for v7, _ in v5 do
            local v8 = t1.requiresQualifier(v7, givenPrefix)

            if v8 == "Always" then
                v4 = "Always"
                break
            end

            if v8 == "Never" then
                v6 = "Never"
            end

            v4 = v6
        end
    end

    local function enableRequiresQualifier(p6) -- line: 86
        -- upvalues: p4 (copy)
        if not p4.requiresQualifier and not p6 then
            local extraArgumentDescription = p4.extraArgumentDescription

            if extraArgumentDescription and #extraArgumentDescription > 0 then
                table.remove(extraArgumentDescription, 1)
            end
        end

        p4.requiresQualifier = true
    end

    if v4 == "Sometimes" then
        local _ = not p4.requiresQualifier

        p4.requiresQualifier = true
        t1.parseQualifierDescription(p4)
        p4.prematureQualifierParsing = true

        if #p4.qualifierCaptures ~= #p4.unrecognizedQualifiers then
            if not p4.requiresQualifier then
                local extraArgumentDescription = p4.extraArgumentDescription

                if extraArgumentDescription and #extraArgumentDescription > 0 then
                    table.remove(extraArgumentDescription, 1)
                end
            end

            p4.requiresQualifier = true
        else
            local ParserUtility = require(Modules.Parser.ParserUtility)
            local Players = game:GetService("Players"):GetPlayers()
            local t2 = {}

            for _, player in Players do
                table.insert(t2, player.Name:lower())
            end

            local v9 = Config.getSetting("PlayerIdentifier", p5)
            local v10 = Config.getSetting("PlayerDefinedSearch", p5)
            local v11 = Config.getSetting("PlayerUndefinedSearch", p5)

            for _, v12 in p4.unrecognizedQualifiers do
                local v13 = v12:sub(1, 1) == v9
                local v14 = ParserUtility.ternary(v13, v12:sub(2, #v12), v12)
                local v15 = ParserUtility.ternary(v13, v10 == "UserName", v11 == "UserName")
                local v16 = ParserUtility.ternary(v13, v10 == "UserNameAndDisplayName", v11 == "UserNameAndDisplayName")

                if (v15 or v16) and table.find(t2, v14:lower()) then
                    if not p4.requiresQualifier then
                        local extraArgumentDescription = p4.extraArgumentDescription

                        if extraArgumentDescription and #extraArgumentDescription > 0 then
                            table.remove(extraArgumentDescription, 1)
                        end
                    end

                    p4.requiresQualifier = true

                    return
                end
            end

            p4.requiresQualifier = false
            p4.qualifierCaptures = {}
        end
    elseif v4 == "Always" then
        if not p4.requiresQualifier then
            local extraArgumentDescription = p4.extraArgumentDescription

            if extraArgumentDescription and #extraArgumentDescription > 0 then
                table.remove(extraArgumentDescription, 1)
            end
        end

        p4.requiresQualifier = true
    end
end

function t1.hasEndlessArgument(p7, p8) -- line: 154
    -- upvalues: Commands (copy), Args (copy)
    local v17 = Commands.getCommand(p7, p8)

    if not v17 then
        return false, 0
    end

    local args = v17.args

    if #args == 0 then
        return false, 0
    end

    local v18 = false
    local n1 = 0

    for _, v19 in args do
        local v20 = Args.get(v19)

        if v20 and v20.endlessArg == true then
            v18 = true
            n1 += 1
        end
    end

    return v18, n1
end

function t1.parsedDataSetHasEndlessArgumentFlag(p9) -- line: 175
    -- upvalues: t1 (copy)
    local givenPrefix = p9.givenPrefix

    p9.totalEndlessArguments = 0

    for _, v21 in p9.commandCaptures do
        for v22, _ in v21 do
            local v23, v24 = t1.hasEndlessArgument(v22, givenPrefix)

            if v23 then
                p9.totalEndlessArguments += v24
            end
        end
    end
end

function t1.parsedDataUpdateIsValidFlag(p10, p11) -- line: 188
    -- upvalues: Modules (copy)
    if p10.isValid then
        local ParserUtility = require(Modules.Parser.ParserUtility)

        if p11 == "MissingCommandDescription" then
            p10.errorMessage = "Invalid command name(s)"

            if p10.commandDescription == "" then
                p10.isValid = false
            end
        elseif p11 == "UnbalancedCapsulesInCommandDescription" then
            if ParserUtility.getCapsuleRanges(p10.commandDescription) == nil then
                p10.isValid = false
            end
        elseif p11 == "UnbalancedCapsulesInQualifierDescription" then
            if ParserUtility.getCapsuleRanges(p10.qualifierDescription) == nil then
                p10.isValid = false
            end
        elseif p11 == "MissingCommands" then
            if #p10.commandCaptures == 0 then
                p10.isValid = false
            end
        elseif p11 == "MalformedCommandDescription" then
            if p10.commandDescriptionResidue ~= "" then
                p10.isValid = false
            end
        elseif p11 == "AccidentalCommandChain" then
            local commandCaptures = p10.commandCaptures

            if #commandCaptures > 1 then
                for _, v25 in commandCaptures do
                    for v26 in v25 do
                        if #tostring(v26) < 3 then
                            p10.isValid = false
                            p10.errorMessage = ("Unknown command '%*'"):format(p10.commandDescription)
                        end

                        break
                    end
                end
            end
        end

        if not p10.isValid then
            p10.parserRejection = p11
        end
    end
end

function t1.invalidateStatement(p12, p13) -- line: 237
    p12.isValid = false
    p12.errorMessage = p13
end

function t1.generateOrganizedParsedData(p14) -- line: 242
    -- upvalues: t1 (copy)
    local t3 = {}

    for _, v27 in p14 do
        local t4 = {
            isValid = true,
            isConverted = false,
            errorMessage = nil,
            commands = {},
            modifiers = {},
            qualifiers = {}
        }

        if v27.isValid then
            for _, v28 in v27.commandCaptures do
                for v29, v30 in v28 do
                    t4.commands[v29] = v30
                end
            end

            for _, v31 in v27.modifierCaptures do
                for v32, v33 in v31 do
                    t4.modifiers[v32] = v33
                end
            end

            for _, v34 in v27.qualifierCaptures do
                for v35, v36 in v34 do
                    t4.qualifiers[v35] = v36
                end
            end
        else
            local v37 = v27.errorMessage or v27.parserRejection

            t1.invalidateStatement(t4, v37)
        end

        table.insert(t3, t4)
    end

    return t3
end

function t1.parseCommandStatement(p15) -- line: 282
    -- upvalues: t1 (copy), Modules (copy)
    local v38 = require(Modules.Parser.Algorithm).getDescriptionsFromCommandStatement(p15.commandStatement)

    p15.commandDescription = v38[1]
    p15.qualifierDescription = v38[2]
    p15.extraArgumentDescription = v38[3]
    t1.parsedDataUpdateIsValidFlag(p15, "MissingCommandDescription")
    t1.parsedDataUpdateIsValidFlag(p15, "UnbalancedCapsulesInCommandDescription")
    t1.parsedDataUpdateIsValidFlag(p15, "UnbalancedCapsulesInQualifierDescription")
end

function t1.parseCommandDescription(p16) -- line: 296
    -- upvalues: t1 (copy), Modules (copy)
    local v39 = require(Modules.Parser.Algorithm).parseCommandDescription(p16.commandDescription)

    p16.commandCaptures = v39[1]
    p16.modifierCaptures = v39[2]
    p16.commandDescriptionResidue = v39[3]
    t1.parsedDataUpdateIsValidFlag(p16, "MissingCommands")
    t1.parsedDataUpdateIsValidFlag(p16, "MalformedCommandDescription")
    t1.parsedDataUpdateIsValidFlag(p16, "AccidentalCommandChain")
end

function t1.parseCommandDescriptionAndSetFlags(p17, p18) -- line: 310
    -- upvalues: t1 (copy)
    t1.parseCommandDescription(p17)

    if p17.isValid then
        t1.parsedDataSetRequiresQualifierFlag(p17, p18)
        t1.parsedDataSetHasEndlessArgumentFlag(p17)
    end
end

function t1.parseQualifierDescription(p19) -- line: 318
    -- upvalues: Modules (copy)
    if p19.requiresQualifier and not p19.prematureQualifierParsing then
        local v40 = require(Modules.Parser.Algorithm).parseQualifierDescription(p19.qualifierDescription)

        p19.qualifierCaptures = v40[1]
        p19.unrecognizedQualifiers = v40[2]
    end
end

function t1.parseExtraArgumentDescription(p20, p21, p22) -- line: 340
    -- upvalues: Modules (copy), Commands (copy), Args (copy)
    local givenPrefix = p20.givenPrefix
    local v41 = p20.totalEndlessArguments or 0
    local v42 = v41 > 1

    if v41 == 0 then
        if not p20.requiresQualifier then
            p20.qualifierDescription = nil
        end

        for _, v43 in p20.extraArgumentDescription do
            for _, v44 in p20.commandCaptures do
                for _, v45 in v44 do
                    table.insert(v45, v43)
                end
            end
        end
    else
        local v46 = if typeof(givenPrefix) ~= "string" or givenPrefix == "" then ";" else givenPrefix
        local v47 = #p21 + 1
        local n2 = 0

        for _ = 1, v47 do
            n2 = select(2, string.find(p22, v46, n2 + 1, true))

            if not n2 then
                break
            end
        end

        local v48 = if n2 then select(2, string.find(p22, p20.commandDescription, n2 + 1, true)) else nil

        if v48 then
            local v49 = v48 + 2

            if p20.requiresQualifier then
                local v50 = select(2, string.find(p22, p20.qualifierDescription, v49, true))

                if v50 then
                    v49 = v50 + 2
                end
            end

            local n3 = 1e999
            local n4 = 0

            for _, v51 in p20.commandCaptures do
                local v52 = n3
                local v53 = n4

                for v54, v55 in v51 do
                    local args = Commands.getCommand(v54, givenPrefix).args
                    local v56 = args[1]
                    local v57 = Args.get(v56).playerArg == true
                    local v58

                    for v59, v60 in args do
                        local v61 = Args.get(v60)

                        if v61 and v61.endlessArg == true then
                            v58 = v59
                            break
                        end

                        v58 = nil
                    end

                    for _, v62 in args do
                        local v63 = Args.get(v62)

                        if v63 then
                            v63 = v63.playerArg ~= true and v63.hidden == true
                        end

                        if v63 then
                            v53 += 1
                            v58 = nil
                        end
                    end

                    n4 = v53

                    local v64 = (v58 or #args) - #v55 - (if v57 then 1 else 0)

                    if v58 then
                        v52 = math.min(v52, v64 - 1)
                    end

                    n3 = v52
                end
            end

            if n3 == 1e999 then
                n3 = 0
            end

            for _ = 1, n3 do
                v49 = select(2, string.find(p22, " ", v49 + 1))

                if not v49 then
                    break
                end

                v49 += 1
            end

            local v66 = v49 and string.sub(p22, v49) or nil

            for _, v67 in p20.commandCaptures do
                for _, v68 in v67 do
                    for i = 1, n3 do
                        table.insert(v68, p20.extraArgumentDescription[i])
                    end

                    for j = 1, n4 do
                        if not v68[j] then
                            table.insert(v68, "")
                        end
                    end

                    table.insert(v68, v66)
                end
            end

            if v42 then
                local ParserSettings = require(Modules.Parser.ParserSettings)

                for _, v70 in p20.commandCaptures do
                    for v71, v72 in v70 do
                        local t5 = {}

                        for _, v73 in v72 do
                            if typeof(v73) ~= "string" then
                                table.insert(t5, v73)
                            end

                            for _, v74 in (string.split(v73, ParserSettings.EndlessArgPattern)) do
                                table.insert(t5, v74)
                            end
                        end

                        v70[v71] = t5
                    end
                end
            end
        end
    end
end

return t1
