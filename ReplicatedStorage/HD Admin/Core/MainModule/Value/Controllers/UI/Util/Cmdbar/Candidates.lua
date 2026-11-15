-- https://lua.expert

local t1 = {
    Red = Color3.fromRGB(255, 0, 0),
    Orange = Color3.fromRGB(250, 100, 0),
    Yellow = Color3.fromRGB(255, 255, 0),
    Green = Color3.fromRGB(0, 255, 0),
    DarkGreen = Color3.fromRGB(0, 125, 0),
    Blue = Color3.fromRGB(0, 255, 255),
    DarkBlue = Color3.fromRGB(0, 50, 255),
    Purple = Color3.fromRGB(150, 0, 255),
    Pink = Color3.fromRGB(255, 85, 185),
    Black = Color3.fromRGB(0, 0, 0),
    White = Color3.fromRGB(255, 255, 255)
}
local t2 = {
    {
        text = "30s",
        label = "30 seconds"
    },
    {
        text = "5m",
        label = "5 minutes"
    },
    {
        text = "1h",
        label = "1 hour"
    },
    {
        text = "1d",
        label = "1 day"
    },
    {
        text = "1w",
        label = "1 week"
    }
}
local Players = game:GetService("Players")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Qualifiers = require(Modules.Parser.Qualifiers)
local getGameSetting = require(Modules.CommandUtil.getGameSetting)
local t3 = {}
local t4 = {}
local t5 = {}
local v1 = "@"
local CommandColors

task.spawn(function() -- line: 47
    -- upvalues: getGameSetting (copy), v1 (ref)
    local PlayerIdentifier = getGameSetting("PlayerIdentifier")

    if typeof(PlayerIdentifier) == "string" and #PlayerIdentifier > 0 then
        v1 = PlayerIdentifier
    end
end)
task.spawn(function() -- line: 53
    -- upvalues: getGameSetting (copy), CommandColors (ref)
    local CommandColors2 = getGameSetting("CommandColors")

    if typeof(CommandColors2) == "table" then
        CommandColors = CommandColors2
    end
end)

local function makeCandidate(p1) -- line: 78
    return {
        keys = p1.keys,
        text = p1.text,
        display = p1.display or p1.text,
        insert = p1.insert or p1.text,
        advance = p1.advance ~= false,
        caretBack = p1.caretBack or 0,
        kind = p1.kind,
        description = p1.description,
        image = p1.image,
        swatch = p1.swatch,
        isDefault = p1.isDefault
    }
end

local function numberCandidates(p2) -- line: 94
    -- upvalues: makeCandidate (copy)
    local t7 = {}
    local t8 = {}

    local function add(p3, p4) -- line: 97
        -- upvalues: t7 (copy), t8 (copy), makeCandidate (copy)
        local t9, makeCandidate2, t10, v2

        if typeof(p3) ~= "number" or t8[p3] then
            return
        else
            t8[p3] = true

            local v4 = tostring(p3)

            t9 = t7
            makeCandidate2 = makeCandidate
            t10 = {
                kind = "number",
                keys = { v4 },
                text = v4,
                description = p4
            }
            v2 = p4 == "default"
        end

        t10.isDefault = v2
        table.insert(t9, (makeCandidate2(t10)))
    end

    add(p2.default, "default")
    add(p2.min, "min")
    add(p2.max, "max")

    return t7
end

local function durationCandidates() -- line: 110
    -- upvalues: t2 (copy), makeCandidate (copy)
    local t11 = {}

    for _, v6 in t2 do
        table.insert(t11, (makeCandidate({
            kind = "duration",
            keys = { v6.text },
            text = v6.text,
            description = v6.label
        })))
    end

    return t11
end

local function colorCandidates(p5) -- line: 123
    -- upvalues: t1 (copy), CommandColors (ref), makeCandidate (copy)
    local t12 = {}
    local v8 = if typeof(CommandColors) == "table" then CommandColors else t1
    local t13 = {}

    for v9 in v8 do
        table.insert(t13, (tostring(v9)))
    end

    table.sort(t13)

    for _, v11 in t13 do
        local v12 = v8[v11]
        local v13 = typeof(p5) == "Color3" and v12 == p5
        local v14 = makeCandidate({
            kind = "color",
            keys = { v11 },
            text = v11,
            description = if v13 then "default" else nil,
            swatch = if typeof(v12) ~= "Color3" then nil else v12,
            isDefault = v13
        })

        if v13 then
            table.insert(t12, 1, v14)
        else
            table.insert(t12, v14)
        end
    end

    return t12
end

local function playerCandidates() -- line: 151
    -- upvalues: Players (copy), Qualifiers (copy), v1 (ref), makeCandidate (copy)
    local t15 = {}
    local t16 = {}

    for _, v15 in Qualifiers.getAll() do
        if v15.isHidden ~= true and typeof(v15.key) == "string" then
            table.insert(t16, v15)
        end
    end

    table.sort(t16, function(p6, p7) -- line: 160
        return (p6.displayOrder or 1e999) < (p7.displayOrder or 1e999)
    end)

    for _, v16 in t16 do
        local v17 = tostring(v16.key):lower()
        local v18 = v16.requiresCapsule == true
        local t17 = {
            kind = "qualifier",
            keys = { v17 },
            text = v17,
            display = v16.key
        }

        if v18 then
            v17 ..= "()"
        end

        t17.insert = v17
        t17.advance = not v18
        t17.caretBack = v18 and 1 or 0
        t17.description = v16.description
        table.insert(t15, (makeCandidate(t17)))
    end

    for _, player in Players:GetPlayers() do
        local v20 = v1 .. player.Name

        table.insert(t15, (makeCandidate({
            kind = "player",
            keys = {
                player.Name,
                player.DisplayName,
                v20
            },
            text = player.Name,
            display = player.DisplayName,
            insert = v20,
            description = if player.DisplayName == player.Name then nil else v20,
            image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=48&h=48"):format(player.UserId)
        })))
    end

    return t15
end

local function optionCandidates(p8) -- line: 193
    -- upvalues: makeCandidate (copy)
    local t19 = {}
    local optionsArray = p8.optionsArray

    if typeof(optionsArray) == "table" then
        local optionsDisplayArray = p8.optionsDisplayArray

        for v22, v23 in optionsArray do
            local v24 = if typeof(optionsDisplayArray) == "table" then optionsDisplayArray[v22] else nil

            table.insert(t19, (makeCandidate({
                kind = "option",
                keys = { (tostring(v23)) },
                text = tostring(v23),
                display = v24 or tostring(v23)
            })))
        end
    end

    return t19
end

local function describeItem(p9) -- line: 212
    local v26 = typeof(p9)

    if v26 == "string" then
        return p9, p9
    end

    if v26 == "EnumItem" then
        local Name = p9.Name

        return Name, Name
    end

    if v26 == "Instance" then
        local Name = p9.Name

        return Name, Name
    end

    if v26 ~= "table" then
        return nil, nil
    end

    local rawValue = p9.rawValue
        or p9.name
        or p9.Name
        or p9.key
        or p9.label
        or p9.title

    if typeof(rawValue) ~= "string" then
        return nil, nil
    end

    local label = p9.label
        or p9.display
        or p9.displayName
        or p9.name
        or p9.Name
        or p9.title
        or rawValue

    if typeof(label) == "string" then
        return rawValue, label
    end

    return rawValue, rawValue
end

local function pickerCandidates(p10) -- line: 233
    -- upvalues: makeCandidate (copy), describeItem (copy)
    local t21 = {}

    for _, v27 in p10 do
        local v28, v29 = describeItem(v27)

        if v28 then
            table.insert(t21, (makeCandidate({
                kind = "picker",
                keys = { v28, v29 },
                text = v28,
                display = v29
            })))
        end
    end

    return t21
end

local function pickerKeyFor(p11) -- line: 249
    local inputObject = p11.inputObject

    if typeof(inputObject) == "table" and typeof(inputObject.pickerGetter) == "function" then
        local key = p11.key or inputObject.inputType or "picker"

        return (tostring(key))
    end

    return nil
end

function t3.forArg(p12) -- line: 260
    -- upvalues: t4 (copy), numberCandidates (copy), durationCandidates (copy), colorCandidates (copy), playerCandidates (copy), optionCandidates (copy), pickerCandidates (copy)
    if typeof(p12) ~= "table" then
        return {}
    end

    local inputObject = p12.inputObject

    if typeof(inputObject) ~= "table" then
        return {}
    end

    if p12.playerArg == true or inputObject.displayQualifiersInPicker == true then
        return (playerCandidates())
    end

    if typeof(inputObject.optionsArray) == "table" then
        return (optionCandidates(inputObject))
    end

    if inputObject.inputType == "ColorPicker" then
        return (colorCandidates(inputObject.default))
    end

    if inputObject.inputType == "NumberInput" then
        return (numberCandidates(inputObject))
    end

    if inputObject.inputType == "DurationSelector" then
        return (durationCandidates())
    end

    local inputObject2 = p12.inputObject
    local key, v31

    if typeof(inputObject2) == "table" then
        if typeof(inputObject2.pickerGetter) == "function" then
            key = p12.key or inputObject2.inputType or "picker"
            v31 = false
        else
            v31 = true
        end
    else
        v31 = true
    end

    local v32 = if v31 then nil else tostring(key)
    local v33 = if v32 then t4[v32] else nil

    if not v32 or not v33 then
        return {}
    end

    return (pickerCandidates(v33.items))
end

function t3.needsPicker(p13) -- line: 295
    -- upvalues: t4 (copy)
    local inputObject = p13.inputObject
    local key, v34

    if typeof(inputObject) == "table" then
        if typeof(inputObject.pickerGetter) == "function" then
            key = p13.key or inputObject.inputType or "picker"
            v34 = false
        else
            v34 = true
        end
    else
        v34 = true
    end

    local v35 = if v34 then nil else tostring(key)

    if not v35 then
        return false
    end

    local v36 = t4[v35]

    if v36 == nil then
        return true
    end

    return os.clock() - v36.fetchedAt > 5
end

function t3.ensurePicker(p14, p15) -- line: 304
    -- upvalues: t3 (copy), t4 (copy), t5 (copy)
    local inputObject = p14.inputObject
    local key, v37

    if typeof(inputObject) == "table" then
        if typeof(inputObject.pickerGetter) == "function" then
            key = p14.key or inputObject.inputType or "picker"
            v37 = false
        else
            v37 = true
        end
    else
        v37 = true
    end

    local v38 = if v37 then nil else tostring(key)

    if v38 and not t5[v38] and t3.needsPicker(p14) then
        t5[v38] = true

        local pickerGetter = p14.inputObject.pickerGetter

        task.spawn(function() -- line: 314
            -- upvalues: p15 (copy), v38 (copy), pickerGetter (copy), t4 (copy), t5 (copy)
            local ok, result = pcall(pickerGetter)

            t5[v38] = false
            t4[v38] = {
                fetchedAt = os.clock(),
                items = if not ok or typeof(result) ~= "table" then {} else result
            }
            p15()
        end)
    end
end

return t3
