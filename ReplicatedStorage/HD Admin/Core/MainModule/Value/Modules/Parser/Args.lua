-- https://lua.expert

local t1 = {
    "default",
    "min",
    "title",
    "max",
    "maxItems",
    "step",
    "useSlider",
    "logarithmic"
}
local t2 = {}
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Log = require(Modules.Log)
local Config = script:FindFirstAncestor("HD Admin").Config
local Args = require(Config.Args)
local UI = Modules.Parent.Controllers.UI

require(UI.Config.InputObjects)
require(Modules.Parser.Args.ArgTypes)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

game:GetService("Workspace")

local v1 = true
local t3 = {}
local t4 = {}
local v2 = RunService:IsServer()
local isTableEmpty = require(Modules.TableUtil.isTableEmpty)
local splitByCollective = require(Modules.Parser.splitByCollective)
local ParserSettings = require(Modules.Parser.ParserSettings)
local EndlessFieldsPattern = ParserSettings.EndlessFieldsPattern

local function register(p1) -- line: 51
    return p1
end

local function isDeveloperCaller(p2) -- line: 57
    return typeof(p2) ~= "number"
end

local function newParse(p3) -- line: 61
    -- upvalues: t2 (copy)
    return function(p4, p5, ...) -- line: 63
        -- upvalues: p3 (copy), t2 (copy)
        local maxCharacters = p4.maxCharacters

        return p3(p4, if typeof(p5) == "table" then p5 else t2.processStringToParse(p5, maxCharacters), ...)
    end
end

local function processDeveloperArg(p6) -- line: 73
    -- upvalues: t2 (copy)
    local v4 = if typeof(p6) == "table" then p6 else {}
    local parse = v4.parse

    if typeof(parse) == "function" and v4.hasUpdatedParse ~= true then
        v4.hasUpdatedParse = true

        v4.parse = function(p7, p8, ...) -- line: 63
            -- upvalues: parse (copy), t2 (copy)
            local maxCharacters = p7.maxCharacters

            return parse(p7, if typeof(p8) == "table" then p8 else t2.processStringToParse(p8, maxCharacters), ...)
        end
    end

    return v4
end

local function moveMultiKeysIntoInputObject(p9) -- line: 86
    -- upvalues: t1 (copy)
    for _, v6 in t1 do
        local v7 = p9[v6]

        if v7 ~= nil then
            local inputObject = p9.inputObject

            if not p9.inputObject then
                inputObject = {}
                p9.inputObject = inputObject
            end

            if inputObject[v6] == nil then
                inputObject[v6] = v7
            end
        end
    end

    return p9
end

local function becomeArg(p10, p11) -- line: 107
    -- upvalues: t2 (copy), Modules (copy), processDeveloperArg (copy), moveMultiKeysIntoInputObject (copy), becomeArg (copy)
    local v8 = t2.items[p11]
    local key = p10.key

    if not v8 then
        error((("Args: %* can not become alias because %* is not a valid argument"):format(key, p11)))
    end

    if v8.mustCreateAliasOf then
        becomeArg(v8, v8.mustCreateAliasOf)
    end

    local deepCopyTable = require(Modules.TableUtil.deepCopyTable)

    moveMultiKeysIntoInputObject(p10)

    local v9 = p10.parse ~= nil

    for v10, v11 in v8 do
        if v10 == "inputObject" and typeof(v11) == "table" then
            if typeof(p10.inputObject) == "table" then
                for v12, v13 in v11 do
                    if p10.inputObject[v12] == nil then
                        local v14 = if typeof(v13) == "table" then deepCopyTable(v13) else v13

                        p10.inputObject[v12] = v14
                    end
                end
            elseif (v10 ~= "hasUpdatedParse" or not v9) and not p10[v10] then
                if typeof(v11) == "table" then
                    p10[v10] = deepCopyTable(v11)
                else
                    p10[v10] = v11
                end
            end
        elseif (v10 ~= "hasUpdatedParse" or not v9) and not p10[v10] then
            if typeof(v11) == "table" then
                p10[v10] = deepCopyTable(v11)
            else
                p10[v10] = v11
            end
        end
    end

    p10.mustCreateAliasOf = nil
    p10.aliasOf = p11
    moveMultiKeysIntoInputObject(p10)
    processDeveloperArg(p10)
end

local t5 = {}

local function resolveInlineArg(p12) -- line: 158
    -- upvalues: t2 (copy), Modules (copy), Log (copy), becomeArg (copy), t5 (copy)
    local v15 = t5[p12]

    if v15 ~= nil then
        return v15
    end

    local arg = p12.arg

    if arg == nil then
        return p12
    end

    local v16 = t2.get(arg)

    if v16 then
        v16 = v16.key

        if v16 then
            local deepCopyTable = require(Modules.TableUtil.deepCopyTable)
            local t6 = {}

            for v17, v18 in p12 do
                if v17 ~= "arg" then
                    if typeof(v18) == "table" then
                        t6[v17] = deepCopyTable(v18)
                    else
                        t6[v17] = v18
                    end
                end
            end

            t6.key = v16
            becomeArg(t6, v16)
            t5[p12] = t6

            return t6
        end
    end

    Log.warn((("'%*' isn't a known command argument"):format((tostring(arg)))))

    return nil
end

local function recordArg(p13, p14) -- line: 187
    -- upvalues: t2 (copy), Log (copy), v2 (copy)
    if t2.items[p13] and v2 then
        Log.warn((("An argument called '%*' already exists. Rename your custom argument to avoid a clash"):format(p13)))
    end

    t2.items[p13] = p14
end

local function unparsePlayer(p15) -- line: 194
    -- upvalues: Modules (copy)
    local v19 = if typeof(p15) == "Instance" and p15:IsA("Player") or typeof(p15) == "string" then { p15 } elseif typeof(p15) == "table" then p15 else {}
    local ParserSettings = require(Modules.Parser.ParserSettings)
    local v21 = tostring(require(Modules.CommandUtil.getGameSetting)("PlayerIdentifier") or "")
    local Collective = ParserSettings.Collective
    local t7 = {}

    for _, v22 in v19 do
        local v23 = if typeof(v22) == "Instance" and v22:IsA("Player") then v21 .. v22.Name
            elseif typeof(v22) == "string" then v22
            elseif typeof(v22) == "number" then v21 .. tostring(v22)
            else nil

        if v23 then
            table.insert(t7, v23)
        end
    end

    return (tostring((table.concat(t7, Collective))))
end

local function parseStringIntoRoles(p16, p17) -- line: 227
    -- upvalues: Modules (copy), splitByCollective (copy)
    if p17 == "" or p17 == " " then
        return {}
    end

    local t8 = {}

    for _, v25 in (splitByCollective(p17)) do
        t8[v25:lower()] = true
    end

    local v26 = require(Modules.Parent.Services.Roles).getRoles()
    local t9 = {}
    local t10 = {}

    for v27, _ in t8 do
        t10[v27] = true
    end

    for _, v28 in v26 do
        local v29 = (v28.name or ""):lower()
        local v30 = (v28.key or ""):lower()
        local v31 = v28.key or v28.name

        if v30 == "" then
            if t8[v29] then
                t9[v31] = v28
                t10[v29] = nil
            end
        elseif t8[v30] then
            t9[v31] = v28
            t10[v30] = nil
        elseif t8[v29] then
            t9[v31] = v28
            t10[v29] = nil
        end
    end

    for v32, _ in t10 do
        local v33, v34

        for _, v35 in v26 do
            if string.sub((v35.name or ""):lower(), 1, #v32) == v32 then
                if v33 then
                    v34 = nil
                    break
                end

                v33 = v35
            end

            v34 = v33
        end

        if v34 then
            t9[v34.key or v34.name] = v34
        end
    end

    local t11 = {}
    local v38 = p16.inputObject.maxItems or 100
    local n1 = 0

    for _, v39 in t9 do
        if v38 <= n1 then
            break
        end

        n1 += 1
        table.insert(t11, v39)
    end

    return t11
end

function t2.update() -- line: 289
    -- upvalues: t2 (copy), v1 (ref), t3 (ref), t4 (ref)
    if not v1 then
        return false
    end

    v1 = false

    local v40 = t2.getAll()

    t3 = {}
    t4 = {}

    for v41, v42 in v40 do
        local v43 = tostring(v41):lower()

        t4[v43] = v42

        local t13 = t3

        table.insert(t13, (tostring(v41)))
    end

    table.sort(t3, function(p18, p19) -- line: 302
        return #p18 > #p19
    end)

    return true
end

function t2.getSortedNameAndAliasLengthArray() -- line: 308
    -- upvalues: t2 (copy), t3 (ref)
    t2.update()

    return t3
end

function t2.getLowercaseDictionary() -- line: 313
    -- upvalues: t2 (copy), t4 (ref)
    t2.update()

    return t4
end

function t2.processStringToParse(p20, p21) -- line: 318
    -- upvalues: Modules (copy), ParserSettings (copy)
    if typeof(p20) ~= "string" then
        return ParserSettings.EmptyUnparsedValue
    end

    local v45 = if typeof(p21) ~= "number" or not (p21 > 1) then 100 else p21
    local v46 = p20

    if v45 < #p20 then
        v46 = string.sub(p20, 1, v45)

        while #v46 > 0 and utf8.len(v46) == nil do
            v46 = string.sub(v46, 1, -2)
        end
    end

    local isNumberSafe = require(Modules.VerifyUtil.isNumberSafe)

    if not tonumber(v46) or isNumberSafe(v46) then
        return v46
    end

    return "0"
end

function t2.get(p22) -- line: 338
    -- upvalues: t2 (copy), becomeArg (copy), resolveInlineArg (copy)
    if typeof(p22) == "table" then
        return (resolveInlineArg(p22))
    end

    local v47 = tostring(p22):lower()
    local v48 = t2.getLowercaseDictionary()[v47]

    if not v48 then
        return nil
    end

    local mustCreateAliasOf = v48.mustCreateAliasOf

    if mustCreateAliasOf then
        becomeArg(v48, mustCreateAliasOf)
    end

    return v48
end

function t2.getAll() -- line: 355
    -- upvalues: t2 (copy)
    for v49, v50 in t2.items do
        if not v50.key then
            v50.key = v49
        end

        t2.get(v49)
    end

    return t2.items
end

function t2.create(p23) -- line: 367
    -- upvalues: t2 (copy), Log (copy), v2 (copy), processDeveloperArg (copy), moveMultiKeysIntoInputObject (copy)
    moveMultiKeysIntoInputObject(p23)
    processDeveloperArg(p23)

    local key = p23.key

    if key then
        if t2.items[key] and v2 then
            Log.warn((("An argument called '%*' already exists. Rename your custom argument to avoid a clash"):format(key)))
        end

        t2.items[key] = p23
    end

    return p23
end

function t2.createAliasOf(p24, p25) -- line: 377
    -- upvalues: t2 (copy), Log (copy), v2 (copy), becomeArg (copy)
    local v51 = if typeof(p25) == "table" then p25 else {}

    task.defer(function() -- line: 382
        -- upvalues: p24 (copy), t2 (copy)
        if not t2.items[p24] then
            error((("Args: %* is not a valid argument"):format(p24)))
        end
    end)

    if t2.items then
        becomeArg(v51, p24)
    else
        v51.mustCreateAliasOf = p24
    end

    local key = v51.key

    if key then
        if t2.items[key] and v2 then
            Log.warn((("An argument called '%*' already exists. Rename your custom argument to avoid a clash"):format(key)))
        end

        t2.items[key] = v51
    end

    return v51
end

local function commandKeyFrom(p26) -- line: 404
    return if typeof(p26) == "table" and typeof(p26.commandKey) == "string" then p26.commandKey else nil
end

local function silentFrom(p27) -- line: 409
    if typeof(p27) == "table" then
        return p27.silent == true
    end

    return false
end

t2.items = {
    Player = t2.create({
        description = "Accepts qualifiers (like 'raza', '@ForeverHD', 'others' from ';paint raza,@ForeverHD,others'), calls the command *for each player*, and returns a single Player instance.",
        playerArg = true,
        runForEachPlayer = true,
        inputObject = {
            inputType = "ItemSelector",
            title = "Players",
            displayServerPlayersInPicker = true,
            displayQualifiersInPicker = true
        },
        unparse = function(_, p29) -- unparse | line: 427
            -- upvalues: unparsePlayer (copy)
            return (unparsePlayer(p29))
        end,
        parse = function(_, p31, p32, p33) -- parse | line: 430
            -- upvalues: Modules (copy), Players (copy), isTableEmpty (copy)
            require(Modules.Parser.ParserUtility)

            local v54 = p31 == nil or isTableEmpty(p31)
            local ignoreDefault = if typeof(p33) == "table" then p33.ignoreDefault else nil

            if v54 and not ignoreDefault then
                local t16 = {}
                local PlayerByUserId = Players:GetPlayerByUserId(p32)

                if PlayerByUserId then
                    table.insert(t16, PlayerByUserId)
                end

                return t16
            end

            local t17 = {}

            for v55, v56 in p31 or {} do
                if v55 ~= "" then
                    local Qualifiers = require(Modules.Parser.Qualifiers)
                    local v57 = Qualifiers.get(v55)
                    local v58

                    if v57 then
                        v58 = v57.getTargets(p32, unpack(v56))
                    else
                        local Default = Qualifiers.get("Default")

                        if Default then
                            v58 = Default.getTargets(p32, v55)
                        else
                            v58 = {}
                        end
                    end

                    for _, v59 in v58 do
                        t17[v59] = true
                    end
                end
            end

            local t18 = {}

            for v60, _ in t17 do
                if typeof(v60) == "Instance" and v60:IsA("Player") then
                    table.insert(t18, v60)
                end
            end

            local filterBlockedTargets = require(Modules.RoleUtil.filterBlockedTargets)
            local v61 = typeof(p33) == "table" and p33.prompt == true
            local v62 = typeof(p33) == "table"
            local v63 = if v62 then typeof(p33.commandKey) == "string" else nil

            return (filterBlockedTargets(t18, p32, v61, if not v62 or not v63 then nil else p33.commandKey, typeof(p33) == "table" and p33.silent == true))
        end
    }),
    Caller = t2.createAliasOf("Player"),
    Players = t2.create({
        description = "Accepts qualifiers (like 'raza', '@ForeverHD', 'others' from ';paint raza,@ForeverHD,others') and returns an array of Player instances.",
        playerArg = true,
        runForEachPlayer = false,
        inputObject = {
            inputType = "ItemSelector",
            title = "Players",
            displayServerPlayersInPicker = true,
            displayQualifiersInPicker = true
        },
        default = {},
        unparse = function(_, p35) -- unparse | line: 492
            -- upvalues: unparsePlayer (copy)
            return (unparsePlayer(p35))
        end,
        parse = function(_, p37, p38, p39) -- parse | line: 495
            -- upvalues: t2 (copy), Modules (copy), isTableEmpty (copy)
            require(Modules.Parser.ParserUtility)

            if isTableEmpty(p37) then
                return nil
            end

            local Player = t2.get("Player")

            if not Player then
                return {}
            end

            local t20 = {
                ignoreDefault = true
            }
            local v64 = typeof(p39) == "table"
            local v65 = if v64 then typeof(p39.commandKey) == "string" else nil

            t20.commandKey = if not v64 or not v65 then nil else p39.commandKey
            t20.silent = typeof(p39) == "table" and p39.silent == true

            return (Player:parse(p37, p38, t20))
        end
    }),
    SinglePlayer = t2.create({
        description = "Accepts qualifiers (like 'raza', '@ForeverHD', 'others' from ';paint raza,@ForeverHD,others') and returns a single Player instance (or nil).",
        playerArg = true,
        runForEachPlayer = true,
        inputObject = {
            inputType = "ItemSelector",
            title = "Player",
            displayServerPlayersInPicker = true,
            displayQualifiersInPicker = true,
            limitPickerToOneItem = true
        },
        default = {},
        unparse = function(_, p41) -- unparse | line: 518
            -- upvalues: unparsePlayer (copy)
            return (unparsePlayer(p41))
        end,
        parse = function(_, p43, p44, p45) -- parse | line: 521
            -- upvalues: t2 (copy), Modules (copy), Players (copy), isTableEmpty (copy)
            local Player = t2.get("Player")
            local v66 = if Player then Player:parse(p43, p44, {
                ignoreDefault = true,
                commandKey = if typeof(p45) ~= "table" then nil elseif typeof(p45.commandKey) == "string" then p45.commandKey else nil,
                silent = typeof(p45) == "table" and p45.silent == true
            }) else {}

            require(Modules.Parser.ParserUtility)

            if v66[1] == nil and (typeof(p43) ~= "table" or isTableEmpty(p43)) then
                return { (Players:GetPlayerByUserId(tonumber(p44) or 0)) }
            end

            return { v66[1] }
        end
    }),
    OptionalPlayer = t2.create({
        description = "Hides the players argument for general use and only displays it within the preview menu. If no player specified, defaults to me",
        playerArg = true,
        hidden = true,
        runForEachPlayer = true,
        inputObject = {
            inputType = "ItemSelector",
            title = "Players",
            displayServerPlayersInPicker = true,
            displayQualifiersInPicker = true,
            default = "all"
        },
        unparse = function(_, p47) -- unparse | line: 549
            -- upvalues: unparsePlayer (copy)
            return (unparsePlayer(p47))
        end,
        parse = function(_, p49, p50, p51) -- parse | line: 552
            -- upvalues: t2 (copy), Players (copy), isTableEmpty (copy)
            if p49 == nil or isTableEmpty(p49) then
                local t24 = {}
                local PlayerByUserId = Players:GetPlayerByUserId(p50)

                if PlayerByUserId then
                    table.insert(t24, PlayerByUserId)
                end

                return t24
            end

            local Player = t2.get("Player")

            if not Player then
                return {}
            end

            local t25 = {
                ignoreDefault = true
            }
            local v67 = typeof(p51) == "table"
            local v68 = if v67 then typeof(p51.commandKey) == "string" else nil

            t25.commandKey = if not v67 or not v68 then nil else p51.commandKey
            t25.silent = typeof(p51) == "table" and p51.silent == true

            return (Player:parse(p49, p50, t25))
        end
    }),
    OptionalPlayers = t2.create({
        description = "Hides the players argument for general use and only displays it within the preview menu. This is useful for message commands. For example, you can do ;m others Hello World, AND ;m Hello World",
        playerArg = true,
        hidden = true,
        runForEachPlayer = false,
        inputObject = {
            inputType = "ItemSelector",
            title = "Players",
            displayServerPlayersInPicker = true,
            displayQualifiersInPicker = true,
            canAnyUserBeAddedToPicker = false,
            default = "all"
        },
        default = {},
        unparse = function(_, p53) -- unparse | line: 583
            -- upvalues: unparsePlayer (copy)
            return (unparsePlayer(p53))
        end,
        parse = function(_, p55, p56, p57) -- parse | line: 586
            -- upvalues: t2 (copy), isTableEmpty (copy)
            local Player, v69

            if typeof(p55) ~= "table" or isTableEmpty(p55) then
                return nil
            else
                Player = t2.get("Player")
                v69 = typeof(p57) == "table" and p57.prompt == true
            end

            if not Player then
                return {}
            end

            return (Player:parse(p55, p56, {
                ignoreDefault = true,
                prompt = v69,
                commandKey = if typeof(p57) ~= "table" then nil elseif typeof(p57.commandKey) == "string" then p57.commandKey else nil,
                silent = typeof(p57) == "table" and p57.silent == true
            }))
        end
    }),
    AnyUser = t2.create({
        display = "User",
        description = "Accepts an @userName, display, userId or qualifier and returns a userId.",
        default = 0,
        inputObject = {
            inputType = "ItemSelector",
            displayServerPlayersInPicker = true,
            displayQualifiersInPicker = false,
            canAnyUserBeAddedToPicker = true,
            limitPickerToOneItem = true
        },
        inputOptions = {},
        unparse = function(_, p59) -- unparse | line: 609
            local v71 = if type(p59) == "table" then p59[1] else p59

            if typeof(v71) == "Instance" and v71:IsA("Player") then
                v71 = v71.UserId
            end

            return tostring((tonumber(v71))) or ""
        end,
        parse = function(_, p61, p62) -- parse | line: 618
            -- upvalues: t2 (copy), Modules (copy)
            local v73 = tonumber(p61)

            if v73 then
                return v73
            end

            local Player = t2.get("Player")
            local v74 = (Player and Player:parse({
                [p61] = {}
            }, p62, {
                silent = true
            }))[1]

            if v74 then
                return v74.UserId
            end

            local v75 = require(Modules.Objects.User).getUser(p62)
            local v76, v77 = require(Modules.Parser.ParserUtility).verifyAndParseUsername(v75, p61)

            if not v76 then
                v77 = p61
            end

            local v78, v79 = require(Modules.PlayerUtil.getUserIdFromNameAsync)(v77)

            return if v78 and typeof(v79) == "number" then v79 else nil
        end
    }),
    Roles = t2.create({
        description = "Accepts a string and returns a table of roles.",
        inputObject = {
            inputType = "ItemSelector",
            title = "Roles",
            pickerGetter = function() -- pickerGetter | line: 649
                -- upvalues: Modules (copy)
                local _, Roles = require(Modules.References.clientUser).everyone:fetchAsync("Roles")

                if typeof(Roles) ~= "table" then
                    return {}
                end

                local t31 = {}

                for _, v80 in Roles do
                    if typeof(v80) == "table" and typeof(v80.name) == "string" then
                        local name = if string.find(v80.name, "%s") == nil then v80.name elseif typeof(v80.key) == "string" then v80.key else v80.name

                        table.insert(t31, {
                            category = "qualifier",
                            key = v80.key or v80.name,
                            label = v80.name,
                            header = v80.name,
                            rawValue = name,
                            color = v80.color
                        })
                    end
                end

                return t31
            end
        },
        default = {},
        unparse = function(_, p64) -- unparse | line: 681
            -- upvalues: Modules (copy)
            local Collective = require(Modules.Parser.ParserSettings).Collective
            local v81 = if typeof(p64) == "table" then p64 else { (tostring(p64)) }

            return (table.concat(v81, Collective))
        end,
        parse = function(p65, p66, _) -- parse | line: 693
            -- upvalues: parseStringIntoRoles (copy)
            return (parseStringIntoRoles(p65, p66))
        end
    }),
    Role = t2.createAliasOf("Roles", {
        maxItems = 1,
        default = false,
        parse = function(p68, p69, _) -- parse | line: 701
            -- upvalues: parseStringIntoRoles (copy)
            return parseStringIntoRoles(p68, p69)[1]
        end
    }),
    Text = t2.create({
        description = "Accepts a string and broadcast filters it based upon the caller. Shown text like this is limited to one message a minute per sender.",
        default = "",
        endlessArg = true,
        maxCharacters = 420,
        textSurface = "Message",
        inputObject = {
            inputType = "TextInput",
            filterText = true
        },
        unparse = function(_, p72) -- unparse | line: 718
            -- upvalues: ParserSettings (copy)
            local v82 = p72:split(ParserSettings.EndlessArgPattern)

            return (table.concat(v82, ""))
        end,
        parse = function(_, p74, p75, _) -- parse | line: 725
            -- upvalues: Modules (copy), ParserSettings (copy)
            local v83

            if typeof(p74) ~= "string" or p74:match("^%s*$") ~= nil or p74 == ParserSettings.EmptyUnparsedValue then
                return "Example"
            else
                v83 = typeof(p75) ~= "number"
            end

            if v83 then
                return p74
            end

            local v85, v86 = require(Modules.VerifyUtil.filterTextAsync)(p74, p75)

            if not v85 then
                v86 = "####"
            end

            return v86
        end
    }),
    String = t2.createAliasOf("Text"),
    Reason = t2.createAliasOf("Text", {
        description = "Same as 'Text' but for kick and ban reasons, which have their own one a minute limit per sender. Leaving it empty never uses the limit.",
        textSurface = "Reason"
    }),
    SurfaceText = t2.createAliasOf("Text", {
        display = "Text",
        description = "Same as 'Text' but for text that stays on display for everyone, like names, titles, signs, teams and stats. These share one change a minute per sender.",
        textSurface = "SurfaceText"
    }),
    ChatText = t2.createAliasOf("Text", {
        display = "Text",
        description = "Same as 'Text' but for text attached to a player's chat, like chat tags and chat names. These share one change a minute per sender.",
        textSurface = "ChatText"
    }),
    PrivateText = t2.createAliasOf("Text", {
        description = "Same as 'Text' but filters per recipient. Only use for one to one text like direct messages that nobody else sees.",
        parse = function(_, p78, p79, p80) -- parse | line: 762
            -- upvalues: Modules (copy), ParserSettings (copy)
            local v87

            if typeof(p78) ~= "string" or p78:match("^%s*$") ~= nil or p78 == ParserSettings.EmptyUnparsedValue then
                return "Example"
            else
                v87 = typeof(p79) ~= "number"
            end

            if v87 then
                return p78
            end

            local v89, v90 = require(Modules.VerifyUtil.filterTextAsync)(p78, p79, p80)

            if not v89 then
                v90 = "####"
            end

            return v90
        end
    }),
    SingleText = t2.create({
        description = "Accepts a non-endless string (a string with no whitespace gaps) and filters it based upon the caller and target.",
        default = "",
        endlessArg = false,
        textSurface = "Message",
        inputObject = {
            title = "Text",
            inputType = "TextInput",
            filterText = true,
            preventWhitespaces = true
        },
        unparse = function(_, p82) -- unparse | line: 789
            return p82
        end,
        parse = function(_, p84, p85, p86) -- parse | line: 792
            -- upvalues: Modules (copy)
            if typeof(p84) ~= "string" then
                return ""
            end

            local v91 = p84:gsub("%s", "")

            if v91 == "" or typeof(p85) ~= "number" then
                return v91
            end

            local v92, v93 = require(Modules.VerifyUtil.filterTextAsync)(v91, p85, p86)

            if not v92 then
                v93 = "####"
            end

            return v93
        end
    }),
    UnfilteredSingleText = t2.create({
        description = "Accepts a non-endless string (a string with no whitespace gaps).",
        default = "",
        endlessArg = false,
        inputObject = {
            title = "Text",
            inputType = "TextInput",
            filterText = false,
            preventWhitespaces = true
        },
        unparse = function(_, p88) -- unparse | line: 819
            return p88
        end,
        parse = function(_, p90) -- parse | line: 822
            return p90
        end
    }),
    UnfilteredText = t2.create({
        description = "Accepts a string and returns it unfiltered.",
        default = "",
        endlessArg = true,
        maxCharacters = 420,
        inputObject = {
            title = "Text",
            inputType = "TextInput",
            filterText = false
        },
        unparse = function(_, p92) -- unparse | line: 837
            return p92
        end,
        parse = function(_, p94) -- parse | line: 840
            return p94
        end
    }),
    EmoteIdOrName = t2.createAliasOf("UnfilteredSingleText"),
    Code = t2.createAliasOf("UnfilteredText"),
    Number = t2.create({
        description = "Accepts a number string and returns a Number",
        default = 0,
        inputObject = {
            inputType = "NumberInput"
        },
        unparse = function(_, p96) -- unparse | line: 855
            -- upvalues: t2 (copy)
            return (t2.processStringToParse((tostring(p96))))
        end,
        parse = function(p97, p98, p99) -- parse | line: 859
            -- upvalues: Modules (copy)
            local v94 = tonumber(p98)

            if not v94 then
                return nil
            end

            local divAmount = p97.divAmount

            if typeof(divAmount) == "number" then
                v94 %= divAmount
            end

            local v95 = require(Modules.Objects.User).getUserByUserId(p99)
            local permitBypassLimits = require(Modules.Parent.Services.Roles).hasPermission(v95, "permitBypassLimits")
            local v96 = p97.min or (-1e999)
            local v97 = p97.max or 1e999

            if not permitBypassLimits then
                v94 = math.clamp(v94, v96, v97)
            end

            local step = p97.step

            if typeof(step) == "number" then
                v94 = require(Modules.MathUtil.roundToNearest)(v94, step)
            end

            return v94
        end
    }),
    Integer = t2.createAliasOf("Number", {
        step = 1
    }),
    Speed = t2.createAliasOf("Number", {
        min = 0,
        max = 100,
        step = 1,
        default = 10
    }),
    FlightSpeed = t2.createAliasOf("Number", {
        display = "Speed",
        min = 0,
        max = 1000,
        step = 1,
        default = 50,
        logarithmic = true
    }),
    Unit = t2.createAliasOf("Number", {
        display = "Number",
        min = 0,
        max = 1,
        step = 0.05,
        default = 0.5
    }),
    Degrees = t2.createAliasOf("Number", {
        description = "Accepts a number and returns a value between 0 and 360.",
        min = 0,
        max = 360,
        divAmount = 360,
        step = 1,
        default = 180
    }),
    Duration = t2.create({
        description = "Accepts a timestring (such as '5s7d8h') and returns the integer equivalent in seconds. Timestring letters are: seconds(s), minutes(m), hours(h), days(d), weeks(w), months(o) and years(y).",
        default = 0,
        inputObject = {
            inputType = "DurationSelector"
        },
        unparse = function(_, p101) -- unparse | line: 930
            -- upvalues: Modules (copy)
            local v98 = tonumber(p101) or 0

            if v98 < 0 then
                v98 = 0
            end

            return require(Modules.DataUtil.convertSecondsToTimeString)(v98)
        end,
        parse = function(_, p103) -- parse | line: 938
            -- upvalues: Modules (copy)
            return require(Modules.DataUtil.convertTimeStringToSeconds)(p103)
        end
    }),
    Color = t2.create({
        description = "Accepts a color name (such as 'red'), a hex code (such as '#FF0000') or an RGB capsule (such as '[255,0,0]') and returns a Color3.",
        inputObject = {
            inputType = "ColorPicker"
        },
        default = Color3.fromRGB(255, 255, 255),
        unparse = function(_, p105) -- unparse | line: 950
            -- upvalues: Modules (copy)
            local v99 = if typeof(p105) == "Color3" then p105 else Color3.fromRGB(255, 255, 255)

            return (require(Modules.DataUtil.colorToHex)(v99))
        end,
        parse = function(p106, p107) -- parse | line: 958
            -- upvalues: Modules (copy)
            local Config = require(Modules.Parent.Services.Config)
            local lowerCommandColors = p106.lowerCommandColors
            local v100

            if lowerCommandColors then
                v100 = lowerCommandColors
            else
                local CommandColors = Config.getSetting("CommandColors")
                local t40 = {}

                p106.lowerCommandColors = t40
                v100 = t40

                for v101, v102 in CommandColors do
                    v100 = t40
                    t40[tostring(v101):lower()] = v102
                end
            end

            local v103 = v100[p107:lower()]

            if v103 then
                return v103
            end

            local v104 = p107:gsub(" ", ""):split(",")

            if v104 then
                local v106 = tonumber(v104[1])
                local v108 = tonumber(v104[2])
                local v110 = tonumber(v104[3])

                if v106 and v108 and v110 then
                    return Color3.fromRGB(v106, v108, v110)
                end
            end

            local v111 = if p107:sub(1, 1) == "#" then p107 else "#" .. p107

            v111:sub(2, #v111)

            local hexToColor = require(Modules.DataUtil.hexToColor)

            return #v111 > 2 and hexToColor(v111) or nil
        end
    }),
    Colour = t2.createAliasOf("Color"),
    OptionalColor = t2.createAliasOf("Color", {
        description = "Same as 'Color' but but must be wrapped in a command capsule. E.g. ';message(yellow) Hello World!'",
        display = "Color",
        hidden = true,
        default = Color3.fromRGB(255, 255, 255)
    }),
    OptionalDuration = t2.createAliasOf("Number", {
        description = "Same as 'Number' but must be wrapped in a command capsule. When left out the duration is worked out from the text length. A value of 0, or 3600 and above, keeps it up until dismissed, like ';notice(0) Hello World!'",
        display = "Duration",
        min = 0,
        max = 3600,
        step = 1,
        useSlider = false,
        hidden = true,
        inputObject = {
            inputType = "NumberInput",
            allowEmpty = true,
            placeholderText = "Auto"
        }
    }),
    OptionalVoteTime = t2.createAliasOf("Duration", {
        description = "Same as 'Duration' but must be wrapped in a command capsule. How long the poll stays open for, like ';vote(2m30s) Best colour? || Red | Blue'",
        default = 120,
        display = "Vote Time",
        hidden = true
    }),
    OptionalShareResults = t2.createAliasOf("Bool", {
        description = "Same as 'Bool' but must be wrapped in a command capsule. When true the poll results are shown to everyone once it ends, like ';vote(30, yes) Best colour? || Red | Blue'",
        display = "Share Results with Voters",
        hidden = true
    }),
    Bool = t2.create({
        description = "Accepts 'true', 'false', 'yes', 'y', 'no' or 'n' and returns a boolean.",
        default = false,
        inputObject = {
            inputType = "Toggle"
        },
        unparse = function(_, p109) -- unparse | line: 1042
            if p109 == true then
                return "true"
            end

            return "false"
        end,
        parse = function(_, p111) -- parse | line: 1049
            local v112 = p111:lower()
            local t41 = {
                ["false"] = true,
                f = true,
                no = true,
                n = true
            }

            if ({
                ["true"] = true,
                t = true,
                yes = true,
                y = true
            })[v112] then
                return true
            end

            return if t41[v112] then false else nil
        end
    }),
    Toggle = t2.createAliasOf("Bool"),
    Options = t2.create({
        description = "Accepts any value within the optionsArray and returns the value.",
        inputObject = {
            inputType = "Options",
            optionsArray = { "Yes", "No" }
        },
        unparse = function(_, p113) -- unparse | line: 1080
            return p113
        end,
        parse = function(p114, p115) -- parse | line: 1083
            local v113 = p115:lower()
            local v114 = #v113
            local v115 = p114.inputObject.optionsArray or {}

            for _, v116 in v115 do
                if v116:lower():sub(1, v114) == v113 then
                    return v116
                end
            end

            return v115[1] or "Empty"
        end
    }),
    BanImpact = t2.createAliasOf("Options", {
        description = "Alts issues a Roblox-platform ban that catches alt accounts; User is HD record only",
        inputObject = {
            inputType = "Options",
            title = "Ban Impact",
            optionsArray = { "Alts", "User" },
            optionsDisplayArray = { "Alts (IP Ban)", "User-Only" }
        }
    }),
    OptionalBanDuration = t2.createAliasOf("Duration", {
        title = "Duration",
        uiHidden = true,
        revealedBy = {
            dependsOn = "BanOptions",
            equals = "Time"
        }
    }),
    OptionalBanImpact = t2.createAliasOf("BanImpact", {
        uiHidden = true,
        revealedBy = {
            dependsOn = "BanOptions",
            equalsAny = { "Perm", "Time" }
        }
    }),
    BanOptions = t2.createAliasOf("Options", {
        description = "Pick which ban command to apply (Server / Time / Perm). Each option requires permission to run the matching scope-locked command.",
        inputObject = {
            inputType = "Options",
            title = "Options",
            optionsArray = { "Perm", "Time", "Server" },
            optionCommands = {
                Server = "serverBan",
                Time = "timeBan",
                Perm = "permBan"
            }
        }
    }),
    Leaderstat = t2.create({
        description = "Accepts a valid stat name and returns the stat (defined in Server/Modules/StatHandler)",
        default = false,
        endlessArg = true,
        inputObject = {
            inputType = "ItemSelector",
            title = "Leaderstat",
            limitPickerToOneItem = true,
            pickerGetter = function() -- pickerGetter | line: 1141
                -- upvalues: Players (copy)
                local t44 = {}
                local leaderstats = Players.LocalPlayer:FindFirstChild("leaderstats")

                if leaderstats then
                    for _, child in leaderstats:GetChildren() do
                        table.insert(t44, child.Name)
                    end
                end

                return t44
            end
        },
        unparse = function(_, p117) -- unparse | line: 1157
            -- upvalues: ParserSettings (copy)
            local v117

            if typeof(p117) == "string" then
                v117 = p117
            elseif typeof(p117) == "Instance" then
                v117 = p117.Name
            elseif typeof(p117) == "table" then
                v117 = p117[1]

                if typeof(v117) ~= "string" then
                    v117 = if typeof(v117) == "Instance" then v117.Name else nil
                end
            end

            return v117 or ParserSettings.EmptyUnparsedValue
        end,
        parse = function(_, p119, p120, p121) -- parse | line: 1176
            -- upvalues: Players (copy)
            local v119 = tonumber(p121 or p120)
            local v120 = v119 and Players:GetPlayerByUserId(v119)

            if v120 then
                local v121 = v120:FindFirstChild("leaderstats") or v120:FindFirstChild("Leaderstats")

                if v121 then
                    local v122 = string.lower(p119)

                    if string.len(v122) ~= 0 then
                        for _, child in v121:GetChildren() do
                            if string.lower(child.Name) == v122 then
                                return child
                            end
                        end

                        for _, child in v121:GetChildren() do
                            if string.sub(string.lower(child.Name), 1, #v122) == v122 then
                                return child
                            end
                        end
                    end
                end
            end

            return nil
        end
    }),
    Team = t2.create({
        display = "Team",
        description = "Accepts a valid team name and returns the team instance.",
        default = false,
        endlessArg = true,
        inputObject = {
            inputType = "ItemSelector",
            title = "Team",
            limitPickerToOneItem = true,
            pickerGetter = function() -- pickerGetter | line: 1211
                local t46 = {}

                for _, child in game:GetService("Teams"):GetChildren() do
                    if child:IsA("Team") then
                        table.insert(t46, child.Name)
                    end
                end

                return t46
            end
        },
        unparse = function(_, p123) -- unparse | line: 1226
            -- upvalues: ParserSettings (copy)
            if typeof(p123) == "string" then
                return p123
            end

            if typeof(p123) == "Instance" then
                return p123.Name
            end

            if typeof(p123) == "table" then
                local v125 = p123[1]

                if typeof(v125) == "string" then
                    return v125
                end

                if typeof(v125) == "Instance" then
                    return v125.Name
                end
            end

            return ParserSettings.EmptyUnparsedValue
        end,
        parse = function(_, p125) -- parse | line: 1242
            local Teams = game:GetService("Teams")
            local v126 = string.lower(p125)

            if string.len(v126) > 0 then
                for _, child in Teams:GetChildren() do
                    local v127 = string.lower(child.Name)

                    if child:IsA("Team") and string.sub(v127, 1, #v126) == v126 then
                        return child
                    end
                end
            end

            return nil
        end
    }),
    Material = t2.create({
        description = "Accepts a valid material and returns a Material enum.",
        inputObject = {
            inputType = "ItemSelector",
            title = "Material",
            limitPickerToOneItem = true,
            pickerGetter = function() -- pickerGetter | line: 1262
                return (Enum.Material:GetEnumItems())
            end
        },
        default = Enum.Material.Plastic,
        unparse = function(_, p127) -- unparse | line: 1269
            -- upvalues: ParserSettings (copy)
            if typeof(p127) == "string" then
                return p127
            end

            if typeof(p127) == "EnumItem" then
                return p127.Name
            end

            if typeof(p127) == "table" then
                local v129 = p127[1]

                if typeof(v129) == "string" then
                    return v129
                end

                if typeof(v129) == "EnumItem" then
                    return v129.Name
                end
            end

            return ParserSettings.EmptyUnparsedValue
        end,
        parse = function(p128, p129) -- parse | line: 1285
            local materialEnumNamesLowercase = p128.materialEnumNamesLowercase

            if not materialEnumNamesLowercase then
                materialEnumNamesLowercase = {}
                p128.materialEnumNamesLowercase = materialEnumNamesLowercase

                for _, v130 in Enum.Material:GetEnumItems() do
                    materialEnumNamesLowercase[v130.Name:lower()] = v130
                end
            end

            local v131 = p129:lower()
            local v132 = materialEnumNamesLowercase[v131]

            if v132 then
                return v132
            end

            for v133, v134 in materialEnumNamesLowercase do
                if string.sub(v133, 1, #p129) == v131 then
                    return v134
                end
            end

            return nil
        end
    }),
    Tools = t2.create({
        display = "Tool",
        description = "Accepts a name and returns a copy of any matching tools located in ServerStorage, ReplicatedStorage, StarterPack, Lighting. You MUST Clone the returned tool before using.",
        endlessArg = true,
        inputObject = {
            inputType = "ItemSelector",
            title = "Tools",
            pickerGetter = function() -- pickerGetter | line: 1312
                -- upvalues: Modules (copy)
                local v136, v137 = require(Modules.CommandUtil.getToolsInfoAsync)()
                local t50 = {}

                return v136 and v137 or t50
            end
        },
        default = {},
        unparse = function(_, p131) -- unparse | line: 1326
            -- upvalues: ParserSettings (copy)
            local function getName(p132) -- line: 1327
                if typeof(p132) == "string" then
                    return p132
                end

                if typeof(p132) == "Instance" then
                    return p132.Name
                end

                return if typeof(p132) == "table" then p132.name or p132.Name else nil
            end

            if typeof(p131) ~= "table" or p131[1] == nil then
                local v138 = if typeof(p131) == "string" then p131
                    elseif typeof(p131) == "Instance" then p131.Name
                    elseif typeof(p131) == "table" then p131.name or p131.Name
                    else nil

                return v138 or ""
            end

            local Collective = ParserSettings.Collective
            local t51 = {}

            for _, v139 in p131 do
                local v140 = if typeof(v139) == "string" then v139
                    elseif typeof(v139) == "Instance" then v139.Name
                    elseif typeof(v139) == "table" then v139.name or v139.Name
                    else nil

                if v140 then
                    table.insert(t51, v140)
                end
            end

            return table.concat(t51, Collective)
        end,
        parse = function(_, p134) -- parse | line: 1347
            -- upvalues: Modules (copy), splitByCollective (copy)
            local v141, v142 = require(Modules.CommandUtil.getToolsInfoAsync)()

            if not v141 or not v142 or #p134 == 0 then
                return nil
            end

            local t52 = {}

            for _, v143 in (splitByCollective(p134)) do
                local v144 = v143:lower()

                for _, v145 in v142 do
                    local v146 = v145.name:lower()

                    if v144 == "all" or string.sub(v146, 1, #p134) == v144 or string.find(v146, v144, 1, true) then
                        t52[v145.tool] = true
                    end
                end
            end

            local t53 = {}

            for v148, _ in t52 do
                table.insert(t53, v148)
            end

            return t53
        end
    }),
    Fields = t2.create({
        endlessArg = true,
        maxCharacters = 420,
        textSurface = "Message",
        inputObject = {
            inputType = "InputFields",
            filterText = true,
            maxItems = 10
        },
        default = {},
        unparse = function(_, p136) -- unparse | line: 1386
            -- upvalues: EndlessFieldsPattern (copy)
            return (table.concat(p136, EndlessFieldsPattern))
        end,
        parse = function(p137, p138, p139) -- parse | line: 1390
            -- upvalues: Modules (copy), EndlessFieldsPattern (copy)
            if typeof(p138) ~= "string" then
                return nil
            end

            local v149 = string.split(p138, EndlessFieldsPattern)
            local filterTextAsync = require(Modules.VerifyUtil.filterTextAsync)
            local v150 = typeof(p137.inputObject) == "table" and tonumber(p137.inputObject.maxItems) or 10
            local t55 = {}

            for _, v151 in v149 do
                local v152 = v151:gsub("^%s+", ""):gsub("%s+$", "")

                if v152 ~= "" then
                    local v153

                    if typeof(p139) ~= "number" then
                        v153 = true
                    else
                        v153, v152 = filterTextAsync(v152, p139)
                    end

                    if not v153 then
                        v152 = "####"
                    end

                    table.insert(t55, v152)

                    if v150 <= #t55 then
                        break
                    end
                end
            end

            return t55
        end
    }),
    Scale = t2.createAliasOf("Number", {
        min = 0.1,
        max = 4,
        step = 0.1,
        logarithmic = true,
        default = 2
    }),
    CountdownTime = t2.createAliasOf("Number", {
        display = "Time",
        min = 1,
        step = 1,
        max = 3600,
        default = 30,
        logarithmic = true
    }),
    AnimationSpeed = t2.createAliasOf("Number", {
        display = "Speed",
        min = 0.5,
        max = 2,
        step = 0.1,
        default = 1
    }),
    SoundId = t2.createAliasOf("Number", {
        display = "Sound ID",
        step = 1,
        default = 1837324500
    }),
    MusicVolume = t2.createAliasOf("Number", {
        display = "Volume",
        min = 0,
        max = 5,
        step = 0.2,
        default = 1
    }),
    MusicSpeed = t2.createAliasOf("Number", {
        display = "Pitch",
        min = 0,
        max = 3,
        step = 0.1,
        default = 1
    }),
    ClockTime = t2.createAliasOf("Number", {
        display = "Time",
        min = 0,
        max = 24,
        step = 0.1,
        default = 14
    }),
    ServersOptions = t2.createAliasOf("Options", {
        display = "Server",
        inputObject = {
            inputType = "Options",
            optionsArray = { "Current", "All" }
        }
    }),
    BanLengthOptions = t2.createAliasOf("Options", {
        display = "Length",
        inputObject = {
            inputType = "Options",
            optionsArray = { "Infinite", "Time" }
        }
    })
}

for v154, v155 in (Args(t2)) do
    if t2.items[v154] and v2 then
        Log.warn((("An argument called '%*' already exists. Rename your custom argument to avoid a clash"):format(v154)))
    end

    t2.items[v154] = v155
end

return t2
