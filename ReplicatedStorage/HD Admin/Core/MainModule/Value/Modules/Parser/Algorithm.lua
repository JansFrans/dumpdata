-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Services = Modules.Parent.Services
local Parser = Modules.Parser
local Modifiers = require(Parser.Modifiers)
local Qualifiers = require(Parser.Qualifiers)
local ParserPatterns = require(Parser.ParserPatterns)
local Commands = require(Services.Commands)

return {
    getCommandStatementsFromBatch = function(p1, p2) -- getCommandStatementsFromBatch | line: 33
        -- upvalues: Modules (copy), ParserPatterns (copy)
        local ParserUtility = require(Modules.Parser.ParserUtility)
        local v1 = ParserUtility.escapeSpecialCharacters(p2)
        local v2 = string.format(ParserPatterns.commandStatementsFromBatchUnFormatted, v1, v1)

        return (ParserUtility.getMatches(p1, v2))
    end,
    getDescriptionsFromCommandStatement = function(p3) -- getDescriptionsFromCommandStatement | line: 48
        -- upvalues: Modules (copy), ParserPatterns (copy)
        local v3 = require(Modules.Parser.ParserUtility).getMatches(p3, ParserPatterns.descriptionsFromCommandStatement)
        local t2 = {}

        if #v3 >= 2 then
            for i = 2, #v3 do
                table.insert(t2, v3[i])
            end
        end

        return {
            v3[1] or "",
            v3[2] or "",
            t2
        }
    end,
    parseCommandDescription = function(p4) -- parseCommandDescription | line: 70
        -- upvalues: Modules (copy), Modifiers (copy), Commands (copy)
        local ParserUtility = require(Modules.Parser.ParserUtility)
        local v5 = Commands.getSortedNameAndAliasLengthArray()
        local v6 = Modifiers.getSortedNameAndAliasLengthArray()
        local t3 = {}
        local t4 = {}

        for _, v7 in v5 do
            local v8 = v7:lower()

            if not t3[v8] then
                t3[v8] = "command"
                table.insert(t4, v7)
            end
        end

        for _, v9 in v6 do
            local v10 = v9:lower()

            if not t3[v10] then
                t3[v10] = "modifier"
                table.insert(t4, v9)
            end
        end

        table.sort(t4, function(p5, p6) -- line: 91
            if #p5 == #p6 then
                return p5 < p6
            end

            return #p5 > #p6
        end)

        local v11, v12 = ParserUtility.getCapsuleCaptures(p4, t4)
        local v13, v14 = ParserUtility.getPlainCaptures(v12, t4)
        local t5 = {}
        local t6 = {}

        local function dispatch(p7) -- line: 101
            -- upvalues: t3 (copy), t5 (ref), t6 (ref)
            for _, v15 in p7 do
                for v16 in v15 do
                    table.insert(if t3[tostring(v16):lower()] == "modifier" then t6 else t5, v15)
                    break
                end
            end
        end

        dispatch(v11)
        dispatch(v13)

        local v18

        if #t5 ~= 0 and v14 == "" then
            v18 = v14

            return { t5, t6, v18 }
        end

        local v19, v20 = ParserUtility.getCapsuleCaptures(p4, v5)
        local v21, v22 = ParserUtility.getPlainCaptures(v20, v5)
        local v23, v24 = ParserUtility.getCapsuleCaptures(v22, v6)
        local v25

        v25, v18 = ParserUtility.getPlainCaptures(v24, v6)

        local t7 = {}
        local t8 = {}

        for _, v26 in { v19, v21 } do
            for _, v27 in v26 do
                table.insert(t7, v27)
            end
        end

        for _, v28 in { v23, v25 } do
            for _, v29 in v28 do
                table.insert(t8, v29)
            end
        end

        if #t7 > 0 and v18 == "" then
            t5 = t7
            t6 = t8
        else
            v18 = v14
        end

        return { t5, t6, v18 }
    end,
    parseQualifierDescription = function(p8) -- parseQualifierDescription | line: 150
        -- upvalues: Modules (copy), Qualifiers (copy), ParserPatterns (copy)
        local ParserUtility = require(Modules.Parser.ParserUtility)
        local v30, v31 = ParserUtility.getCapsuleCaptures(p8, Qualifiers.getSortedNameAndAliasLengthArray())
        local v32 = ParserUtility.getMatches(v31, ParserPatterns.argumentsFromCollection)
        local t9 = {}
        local v33 = Qualifiers.getLowercaseDictionary()

        for _, v34 in v32 do
            if v34 ~= "" then
                if not v33[v34:lower()] then
                    table.insert(t9, v34)
                end

                table.insert(v30, {
                    [v34] = {}
                })
            end
        end

        return { v30, t9 }
    end,
    parseExtraArgumentDescription = function(_) -- parseExtraArgumentDescription | line: 181
    end
}
