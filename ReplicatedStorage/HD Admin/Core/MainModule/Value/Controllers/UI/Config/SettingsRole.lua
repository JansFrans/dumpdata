-- https://lua.expert

local t1 = {
    GamePass = Enum.InfoType.GamePass,
    Asset = Enum.InfoType.Asset,
    Bundle = Enum.InfoType.Bundle
}
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local UI = Modules.Parent.Controllers.UI

require(UI.Config.InputObjects)

local Presets = require(UI.Config.Presets)
local Icons = require(UI.Config.Icons)
local settingVerifiers = require(Modules.VerifyUtil.settingVerifiers)
local areValuesEqual = require(Modules.DataUtil.areValuesEqual)

local function presetKeysFrom(p1) -- line: 32
    local t2 = {}

    if typeof(p1) == "table" then
        for v1 in p1 do
            if typeof(v1) == "string" then
                table.insert(t2, v1)
            end
        end
    end

    return t2
end

local t3 = {
    UserId = {
        userId = "positiveInteger",
        type = {
            oneOf = { "UserId" }
        }
    },
    Preset = {
        type = {
            oneOf = { "Preset" }
        },
        preset = {
            oneOf = presetKeysFrom(Presets.users)
        }
    }
}
local t4 = {
    AnyMember = {
        groupId = "positiveInteger",
        type = {
            oneOf = { "AnyMember" }
        }
    },
    SpecificRoles = {
        groupId = "positiveInteger",
        type = {
            oneOf = { "SpecificRoles" }
        },
        roles = {
            max = 50,
            array = {
                shape = {
                    rank = "nonNegativeInteger",
                    name = "string"
                }
            }
        }
    }
}
local t5 = {
    GamePass = {
        id = "positiveInteger",
        type = {
            oneOf = { "GamePass" }
        }
    },
    Asset = {
        id = "positiveInteger",
        type = {
            oneOf = { "Asset" }
        }
    },
    Bundle = {
        id = "positiveInteger",
        type = {
            oneOf = { "Bundle" }
        }
    },
    Preset = {
        type = {
            oneOf = { "Preset" }
        },
        preset = {
            oneOf = presetKeysFrom(Presets.products)
        }
    }
}

local function giveToUsersDedupKey(p2) -- line: 62
    if p2.type == "UserId" then
        return "UserId:" .. tostring(p2.userId)
    end

    return if p2.type == "Preset" then "Preset:" .. tostring(p2.preset) else nil
end

local function giveToGroupsDedupKey(p3) -- line: 67
    return "Group:" .. tostring(p3.groupId)
end

local function giveToProductsDedupKey(p4) -- line: 70
    if p4.type == "Preset" then
        return "Preset:" .. tostring(p4.preset)
    end

    return string.lower(p4.type) .. ":" .. tostring(p4.id)
end

local v3 = settingVerifiers.boolean()
local t6 = {
    None = 0,
    Commands = 1,
    Menu = 2
}

local function mayViewIconEscalation(p5, _, p7, p8) -- line: 85
    -- upvalues: t6 (copy)
    if p8.hasPermission(p5, "mayEditAll") or p8.hasPermission(p5, "mayViewAll") then
        return true
    end

    local v4 = t6[tostring(p7)] or 0

    if v4 == 0 then
        return true
    end

    local n1 = 0

    for _, v5 in p8.getRolesForUser(p5) do
        local v6 = t6[tostring(v5.mayViewIcon)] or 0

        if n1 < v6 then
            n1 = v6
        end
    end

    if v4 <= n1 then
        return true
    end

    return false, (("You cannot grant icon '%*' because you don't have it yourself"):format((tostring(p7))))
end

local function mayViewPagesEscalation(p9, p10, p11, p12) -- line: 100
    if p12.hasPermission(p9, "mayEditAll") or p12.hasPermission(p9, "mayViewAll") or typeof(p11) ~= "table" then
        return true
    end

    local t7 = {}

    if typeof(p10) == "table" then
        for _, v7 in p10 do
            if typeof(v7) == "string" then
                t7[v7] = true
            end
        end
    end

    for _, v8 in p11 do
        if typeof(v8) == "string" and not t7[v8] then
            if v8 == "All" then
                return false, "You cannot grant 'All' pages without mayViewAll"
            end

            if not p12.canViewPage(p9, v8) then
                return false, (("You cannot grant page '%*' because you cannot view it yourself"):format(v8))
            end
        end
    end

    return true
end

local function canUseEveryCommandWithTag(p13, p14, p15) -- line: 125
    -- upvalues: Modules (copy)
    for _, v9 in require(Modules.Parent.Services.Commands).getCommandsArray() do
        local tags = v9.tags

        if typeof(tags) == "table" and table.find(tags, p14) and not p15.canUseCommand(p13, v9) then
            return false
        end
    end

    return true
end

local function inheritCommandsWithTagsEscalation(p16, p17, p18, p19) -- line: 138
    -- upvalues: canUseEveryCommandWithTag (copy)
    if p19.hasPermission(p16, "mayEditAll") or typeof(p18) ~= "table" then
        return true
    end

    local t8 = {}

    if typeof(p17) == "table" then
        for _, v10 in p17 do
            if typeof(v10) == "string" then
                t8[v10] = true
            end
        end
    end

    local t9 = {}

    for _, v11 in p19.getRolesForUser(p16) do
        local inheritCommandsWithTags = v11.inheritCommandsWithTags

        if typeof(inheritCommandsWithTags) == "table" then
            for _, v12 in inheritCommandsWithTags do
                if typeof(v12) == "string" then
                    t9[v12] = true
                end
            end
        end
    end

    for _, v13 in p18 do
        if typeof(v13) == "string" and not t8[v13] and not t9[v13] and not canUseEveryCommandWithTag(p16, v13, p19) then
            return false, (("You can't add '%*' because your roles can't use all of its commands"):format(v13))
        end
    end

    return true
end

local function isPermissionField(p20) -- line: 168
    if p20:sub(1, 6) == "permit" or p20:sub(1, 7) == "mayEdit" or p20:sub(1, 7) == "mayView" then
        return true
    end

    return p20:sub(1, 6) == "prompt"
end

local function inheritCommandsWithNamesEscalation(p21, p22, p23, p24) -- line: 174
    -- upvalues: Modules (copy)
    if p24.hasPermission(p21, "mayEditAll") or typeof(p23) ~= "table" then
        return true
    end

    local t10 = {}

    if typeof(p22) == "table" then
        for _, v14 in p22 do
            if typeof(v14) == "string" then
                t10[string.lower(v14)] = true
            end
        end
    end

    local Commands = require(Modules.Parent.Services.Commands)

    for _, v15 in p23 do
        if typeof(v15) == "string" and not t10[string.lower(v15)] then
            local v16 = Commands.getCommandByIdentity(v15) or Commands.getCommand(v15)

            if not v16 then
                return false, (("'%*' is not a loaded command"):format(v15))
            end

            if not p24.canUseCommand(p21, v16) then
                return false, (("You can't grant '%*' because your roles can't use it"):format(v15))
            end
        end
    end

    return true
end

local function firstUngrantableReason(p25, p26, p27) -- line: 200
    -- upvalues: mayViewIconEscalation (copy), mayViewPagesEscalation (copy), inheritCommandsWithTagsEscalation (copy), isPermissionField (copy), inheritCommandsWithNamesEscalation (copy)
    if typeof(p26) ~= "table" then
        return nil
    end

    for v17, v18 in p26 do
        if v18 == true and typeof(v17) == "string" and isPermissionField(v17) and not p27.canGrantPermission(p25, v17) then
            return (("has the '%*' ability which your roles don't"):format(v17))
        end
    end

    if not mayViewPagesEscalation(p25, nil, p26.mayViewPages, p27) then
        return "can view pages which your roles can't"
    end

    if not mayViewIconEscalation(p25, "None", p26.mayViewIcon, p27) then
        return "has icon access which your roles don't"
    end

    return if not inheritCommandsWithTagsEscalation(p25, nil, p26.inheritCommandsWithTags, p27) or not inheritCommandsWithNamesEscalation(p25, nil, p26.inheritCommandsWithNames, p27) then "includes commands which your roles can't use" else nil
end

local function giverExpanded(p28, p29) -- line: 226
    -- upvalues: areValuesEqual (copy)
    if typeof(p29) == "boolean" then
        if p29 == true then
            return p28 ~= true
        end

        return false
    end

    if typeof(p29) == "table" then
        local v19 = if typeof(p28) == "table" then p28 else {}

        for _, v20 in p29 do
            local v21 = false

            for _, v22 in v19 do
                if areValuesEqual(v20, v22) then
                    v21 = true
                    break
                end
            end

            if not v21 then
                return true
            end
        end
    end

    return false
end

local function giverEscalation(p30, p31, p32, p33, p34) -- line: 245
    -- upvalues: firstUngrantableReason (copy), giverExpanded (copy)
    if not p33.hasPermission(p30, "mayEditAll") and giverExpanded(p31, p32) then
        local v23 = firstUngrantableReason(p30, p34, p33)

        if v23 then
            return false, (("This role can't be given out automatically because it %*. Ask a higher rank to set this up"):format(v23))
        end
    end

    return true
end

local function pascalSplit(p35) -- line: 261
    local v24 = p35:gsub("(%l)(%u)", "%1 %2")

    return v24:sub(1, 1):upper() .. v24:sub(2)
end

local function stripFirstWord(p36) -- line: 266
    local v25 = p36:match("^%l+(.*)$")

    if not v25 or v25 == "" then
        local v26 = p36:gsub("(%l)(%u)", "%1 %2")

        return v26:sub(1, 1):upper() .. v26:sub(2)
    end

    local v27 = v25:gsub("(%l)(%u)", "%1 %2")

    return v27:sub(1, 1):upper() .. v27:sub(2)
end

local function stripTwoWords(p37) -- line: 275
    local v28 = p37:match("^%l+(.*)$")

    if not v28 or v28 == "" then
        local v29 = p37:gsub("(%l)(%u)", "%1 %2")

        return v29:sub(1, 1):upper() .. v29:sub(2)
    end

    local v30 = v28:match("^%u%l*(.*)$")

    if not v30 or v30 == "" then
        local v31 = v28:gsub("(%l)(%u)", "%1 %2")

        return v31:sub(1, 1):upper() .. v31:sub(2)
    end

    local v32 = v30:gsub("(%l)(%u)", "%1 %2")

    return v32:sub(1, 1):upper() .. v32:sub(2)
end

local function toggleFor(p38, p39) -- line: 287
    -- upvalues: v3 (copy)
    local t11 = {
        inputType = "Toggle",
        title = p38
    }

    if p39 then
        t11.label = p39
    else
        local v33 = p38:gsub("(%l)(%u)", "%1 %2")

        t11.label = v33:sub(1, 1):upper() .. v33:sub(2)
    end

    t11.settingPath = { p38 }
    t11.verifier = v3

    return t11
end

local function stripToggle(p40, p41) -- line: 297
    -- upvalues: v3 (copy)
    local t12 = {
        inputType = "Toggle",
        title = p40
    }
    local v34 = p40:match("^%l+(.*)$")

    if not v34 or v34 == "" then
        local v35 = p40:gsub("(%l)(%u)", "%1 %2")

        t12.label = v35:sub(1, 1):upper() .. v35:sub(2)
    else
        local v36 = v34:gsub("(%l)(%u)", "%1 %2")

        t12.label = v36:sub(1, 1):upper() .. v36:sub(2)
    end

    t12.settingPath = { p40 }
    t12.description = p41
    t12.verifier = v3

    return t12
end

local function stripTextField(p42) -- line: 308
    -- upvalues: settingVerifiers (copy)
    local t13 = {
        inputType = "TextInput",
        title = p42
    }
    local v37 = p42:match("^%l+(.*)$")

    if not v37 or v37 == "" then
        local v38 = p42:gsub("(%l)(%u)", "%1 %2")

        t13.label = v38:sub(1, 1):upper() .. v38:sub(2)
    else
        local v39 = v37:gsub("(%l)(%u)", "%1 %2")

        t13.label = v39:sub(1, 1):upper() .. v39:sub(2)
    end

    t13.settingPath = { p42 }
    t13.verifier = settingVerifiers.safeString(64)

    return t13
end

local function stripTwoToggle(p43, p44) -- line: 318
    -- upvalues: v3 (copy), stripTwoWords (copy)
    return {
        inputType = "Toggle",
        title = p43,
        label = stripTwoWords(p43),
        settingPath = { p43 },
        verifier = v3,
        escalationCheck = p44
    }
end

local function stripTwoTextField(p45) -- line: 329
    -- upvalues: settingVerifiers (copy), stripTwoWords (copy)
    return {
        inputType = "TextInput",
        title = p45,
        label = stripTwoWords(p45),
        settingPath = { p45 },
        verifier = settingVerifiers.safeString(64)
    }
end

local t15 = {
    heading = "About",
    objects = {
        {
            title = "key",
            label = "Key",
            inputType = "TextInput",
            immutable = true,
            settingPath = { "key" },
            inputObject = {
                limitTextLength = 32,
                preventWhitespaces = true
            }
        },
        {
            title = "rank",
            label = "Rank",
            inputType = "NumberInput",
            immutable = true,
            settingPath = { "rank" },
            inputObject = {
                default = 1,
                min = 0,
                max = 255,
                step = 1,
                useSlider = false
            }
        },
        {
            title = "data",
            label = "Data",
            inputType = "ActionButton",
            settingPath = { "__data" },
            inputObject = {
                buttonText = "Copy or Load",
                buttonIcon = "rbxassetid://131861503167070"
            }
        }
    }
}
local t16 = {
    heading = "Display",
    objects = {
        {
            title = "name",
            label = "Name",
            inputType = "TextInput",
            settingPath = { "name" },
            inputObject = {
                limitTextLength = 32,
                mustBeStringSafe = true,
                filterText = true
            },
            verifier = settingVerifiers.filteredText(128)
        },
        {
            title = "color",
            label = "Color",
            inputType = "ColorPicker",
            settingPath = { "color" },
            verifier = settingVerifiers.color3()
        }
    }
}
local t17 = {
    heading = "Give To",
    objects = {
        stripTwoToggle("giveToEveryone", giverEscalation),
        stripTwoToggle("giveToPrivateServerOwner", giverEscalation),
        {
            title = "giveToUsers",
            label = "Users",
            inputType = "ItemSelector",
            settingPath = { "giveToUsers" },
            verifier = settingVerifiers.taggedArray(t3, 50, 2048, giveToUsersDedupKey),
            escalationCheck = giverEscalation,
            inputObject = {
                canAnyUserBeAddedToPicker = true,
                displayServerPlayersInPicker = true,
                presetGetter = function() -- presetGetter | line: 427
                    -- upvalues: Presets (copy)
                    local t20 = {}

                    for v42, v43 in Presets.users do
                        table.insert(t20, {
                            category = "preset",
                            key = "preset:" .. v42,
                            label = v43.label,
                            header = v43.label,
                            body = v43.description,
                            icon = v43.icon,
                            rawValue = v42
                        })
                    end

                    return t20
                end,
                itemToEntry = function(p46) -- itemToEntry | line: 442
                    if p46.category == "preset" then
                        return {
                            type = "Preset",
                            preset = p46.rawValue
                        }
                    end

                    local rawValue = p46.rawValue

                    return {
                        type = "UserId",
                        userId = (if typeof(rawValue) ~= "Instance" or not rawValue:IsA("Player") then tonumber(rawValue) else rawValue.UserId) or 0
                    }
                end,
                entryToKey = function(p47) -- entryToKey | line: 452
                    if typeof(p47) ~= "table" then
                        return nil
                    end

                    local type = p47.type
                    local v44 = type == "Preset"
                    local v45 = if v44 then typeof(p47.preset) == "string" else nil

                    if v44 and v45 then
                        return "preset:" .. p47.preset
                    end

                    return if type == "UserId" and typeof(p47.userId) == "number" then tostring(p47.userId) else nil
                end,
                hydrateEntry = function(p48) -- hydrateEntry | line: 462
                    if typeof(p48) ~= "table" or p48.type ~= "UserId" then
                        return nil
                    end

                    local v48 = tonumber(p48.userId)

                    if not v48 then
                        return nil
                    end

                    local Players = game:GetService("Players")
                    local GetNameFromUserIdAsync = Players.GetNameFromUserIdAsync
                    local ok, result = pcall(GetNameFromUserIdAsync, Players, v48)

                    if not ok or typeof(result) ~= "string" then
                        result = tostring(v48)
                    end

                    return {
                        category = "custom",
                        key = tostring(v48),
                        label = result .. " @" .. result,
                        header = result,
                        body = "@" .. result,
                        icon = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. v48 .. "&width=48&height=48&format=png",
                        rawValue = v48
                    }
                end
            }
        },
        {
            title = "giveToGroups",
            label = "Groups",
            inputType = "ItemSelector",
            settingPath = { "giveToGroups" },
            verifier = settingVerifiers.taggedArray(t4, 20, 2048, giveToGroupsDedupKey),
            escalationCheck = giverEscalation,
            inputObject = {
                addFlow = "Group",
                itemToEntry = function(p49) -- itemToEntry | line: 492
                    local rawValue = p49.rawValue

                    return if typeof(rawValue) == "table" and typeof(rawValue.type) == "string" then rawValue else nil
                end,
                entryToKey = function(p50) -- entryToKey | line: 499
                    if typeof(p50) ~= "table" then
                        return nil
                    end

                    local v51 = tonumber(p50.groupId)

                    return if v51 then "group:" .. tostring(v51) else nil
                end,
                hydrateEntry = function(p51) -- hydrateEntry | line: 505
                    if typeof(p51) ~= "table" then
                        return nil
                    end

                    local v52 = tonumber(p51.groupId)

                    if not v52 then
                        return nil
                    end

                    local type = p51.type

                    if type ~= "AnyMember" and type ~= "SpecificRoles" then
                        return nil
                    end

                    local GroupService = game:GetService("GroupService")

                    local function v53() -- line: 512
                        -- upvalues: v52 (copy), GroupService (copy)
                        return GroupService:GetGroupInfoAsync(v52)
                    end

                    local ok, result = pcall(v53)
                    local v55 = if not not (ok and typeof(result) == "table" and typeof(result.Name) == "string") then result.Name else "Group " .. tostring(v52)
                    local v56 = type == "SpecificRoles"
                    local v57 = if v56 then typeof(p51.roles) == "table" else nil
                    local v58

                    if not v56 or not v57 then
                        v58 = "All Roles"
                    else
                        local roles = p51.roles

                        if #roles == 0 then
                            v58 = "All Roles"
                        else
                            local t23 = {}

                            for _, v59 in roles do
                                if typeof(v59.name) == "string" and #v59.name > 0 then
                                    table.insert(t23, v59.name)
                                else
                                    table.insert(t23, "Rank " .. tostring(v59.rank))
                                end
                            end

                            v58 = table.concat(t23, ", ")
                        end
                    end

                    return {
                        category = "custom",
                        groupConfig = true,
                        key = "group:" .. tostring(v52),
                        label = v55,
                        header = v55,
                        body = tostring(v52),
                        icon = "rbxthumb://type=GroupIcon&id=" .. tostring(v52) .. "&w=150&h=150",
                        rawValue = p51,
                        roleLabel = v58
                    }
                end
            }
        },
        {
            title = "giveToProducts",
            label = "Products",
            inputType = "ItemSelector",
            settingPath = { "giveToProducts" },
            verifier = settingVerifiers.taggedArray(t5, 50, 4096, giveToProductsDedupKey),
            escalationCheck = giverEscalation,
            inputObject = {
                addFlow = "Product",
                presetGetter = function() -- presetGetter | line: 561
                    -- upvalues: Presets (copy)
                    local t26 = {}

                    for v61, v62 in Presets.products do
                        table.insert(t26, {
                            category = "preset",
                            key = "preset:" .. v61,
                            label = v62.label,
                            header = v62.label,
                            body = v62.description,
                            icon = v62.icon,
                            rawValue = v61
                        })
                    end

                    return t26
                end,
                itemToEntry = function(p52) -- itemToEntry | line: 576
                    if p52.category == "preset" then
                        return {
                            type = "Preset",
                            preset = p52.rawValue
                        }
                    end

                    local rawValue = p52.rawValue

                    return if typeof(rawValue) == "table" and typeof(rawValue.type) == "string" then {
                        type = rawValue.type,
                        id = rawValue.id
                    } else nil
                end,
                entryToKey = function(p53) -- entryToKey | line: 586
                    -- upvalues: t1 (copy)
                    if typeof(p53) ~= "table" then
                        return nil
                    end

                    local type = p53.type
                    local v65 = type == "Preset"
                    local v66 = if v65 then typeof(p53.preset) == "string" else nil

                    if v65 and v66 then
                        return "preset:" .. p53.preset
                    end

                    return if t1[type] and typeof(p53.id) == "number" then string.lower(type) .. ":" .. tostring(p53.id) else nil
                end,
                hydrateEntry = function(p54) -- hydrateEntry | line: 596
                    -- upvalues: t1 (copy)
                    if typeof(p54) ~= "table" then
                        return nil
                    end

                    local type = p54.type
                    local v70 = t1[type]

                    if not v70 then
                        return nil
                    end

                    local v71 = tonumber(p54.id)

                    if not v71 then
                        return nil
                    end

                    local MarketplaceService = game:GetService("MarketplaceService")

                    local function v72() -- line: 604
                        -- upvalues: v70 (copy), v71 (copy), MarketplaceService (copy)
                        return MarketplaceService:GetProductInfo(v71, v70)
                    end

                    local ok, result = pcall(v72)
                    local v74 = if not not (ok and typeof(result) == "table" and typeof(result.Name) == "string") then result.Name else "#" .. tostring(v71)
                    local v75 = if not ok or typeof(result) ~= "table" then "" elseif typeof(result.IconImageAssetId) == "number" and result.IconImageAssetId > 0 then "rbxassetid://" .. tostring(result.IconImageAssetId) else ""

                    return {
                        category = "custom",
                        productConfig = true,
                        key = string.lower(type) .. ":" .. tostring(v71),
                        label = v74,
                        header = v74,
                        icon = if not (#v75 > 0) then nil else v75,
                        rawValue = {
                            type = type,
                            id = v71
                        }
                    }
                end
            }
        }
    }
}
local t29 = {
    heading = "Commands",
    objects = {
        {
            title = "inheritCommandsFromJuniorRoles",
            label = "From Roles Below",
            inputType = "Toggle",
            description = "This role can use the commands of all roles below this role",
            settingPath = { "inheritCommandsFromJuniorRoles" },
            verifier = v3
        },
        {
            title = "inheritCommandsWithTags",
            label = "From Tags",
            inputType = "ItemSelector",
            description = "This role can use commands with these tags",
            settingPath = { "inheritCommandsWithTags" },
            escalationCheck = inheritCommandsWithTagsEscalation,
            verifier = function(_, p56, _) -- verifier | line: 648
                -- upvalues: Modules (copy)
                if typeof(p56) ~= "table" then
                    return false, "Expected an array"
                end

                local isWithinMaxSize = require(Modules.VerifyUtil.isWithinMaxSize)
                local isStringSafe = require(Modules.VerifyUtil.isStringSafe)

                if not isWithinMaxSize(p56, 2048) then
                    return false, "Array too large"
                end

                local t32 = {}
                local t33 = {}

                for i = 1, #p56 do
                    local v76 = p56[i]

                    if not isStringSafe(v76) then
                        return false, (("Entry %* is not a safe string"):format(i))
                    end

                    if not t32[v76] then
                        t32[v76] = true
                        table.insert(t33, v76)
                    end
                end

                if #t33 > 100 then
                    return false, "Too many tags (max 100)"
                end

                return true, t33
            end,
            inputObject = {
                itemsGetter = function(p58) -- itemsGetter | line: 668
                    local Modules = script:FindFirstAncestor("MainModule").Value.Modules

                    require(Modules.Parent.Packages.Fusion)

                    local CommandTags = p58:Fuse("everyone", "CommandTags")

                    return p58:Computed(function(p59) -- line: 672
                        -- upvalues: CommandTags (copy)
                        local v77 = p59(CommandTags)

                        if typeof(v77) ~= "table" then
                            return {}
                        end

                        local t34 = {}

                        for _, v78 in v77 do
                            local Tag = v78.Tag
                            local v79 = v78.TotalCommands or 0

                            if typeof(Tag) == "string" and Tag:sub(1, 1) ~= "_" then
                                table.insert(t34, {
                                    category = "qualifier",
                                    tagConfig = true,
                                    key = Tag,
                                    label = Tag,
                                    header = Tag,
                                    body = ("%* Commands"):format(v79),
                                    rawValue = Tag
                                })
                            end
                        end

                        return t34
                    end)
                end
            }
        },
        {
            title = "inheritCommandsWithNames",
            label = "From Names",
            inputType = "ItemSelector",
            description = "This role can use these commands",
            settingPath = { "inheritCommandsWithNames" },
            escalationCheck = inheritCommandsWithNamesEscalation,
            verifier = function(_, p61, _) -- verifier | line: 704
                -- upvalues: Modules (copy)
                if typeof(p61) ~= "table" then
                    return false, "Expected an array"
                end

                local isWithinMaxSize = require(Modules.VerifyUtil.isWithinMaxSize)
                local isStringSafe = require(Modules.VerifyUtil.isStringSafe)

                if not isWithinMaxSize(p61, 2048) then
                    return false, "Array too large"
                end

                local t37 = {}
                local t38 = {}

                for i = 1, #p61 do
                    local v80 = p61[i]

                    if not isStringSafe(v80) then
                        return false, (("Entry %* is not a safe string"):format(i))
                    end

                    if not t37[v80] then
                        t37[v80] = true
                        table.insert(t38, v80)
                    end
                end

                if #t38 > 100 then
                    return false, "Too many commands (max 100)"
                end

                return true, t38
            end,
            inputObject = {
                itemsGetter = function(p63) -- itemsGetter | line: 723
                    -- upvalues: Icons (copy)
                    local Commands = p63:Fuse("everyone", "Commands")
                    local CommandVetting = p63:Fuse("everyone", "CommandVetting")
                    local UnresolvedCommandGrants = p63:Fuse("everyone", "UnresolvedCommandGrants")

                    return p63:Computed(function(p64) -- line: 727
                        -- upvalues: Commands (copy), CommandVetting (copy), UnresolvedCommandGrants (copy), Icons (copy)
                        local v81 = p64(Commands)

                        if typeof(v81) ~= "table" then
                            return {}
                        end

                        local v82 = p64(CommandVetting)
                        local states = if typeof(v82) == "table" then v82.states else nil
                        local t40 = {}

                        for _, v83 in v81 do
                            if typeof(v83) == "table" and v83.hide ~= true then
                                local tags = v83.tags
                                local v84 = false

                                if typeof(tags) == "table" then
                                    for _, v85 in tags do
                                        if typeof(v85) == "string" and v85:sub(1, 1) == "_" then
                                            v84 = true
                                            break
                                        end

                                        v84 = false
                                    end
                                end

                                if not v84 then
                                    local v86 = v83.identity or v83.key
                                    local name = v83.name

                                    if typeof(v86) == "string" and typeof(name) == "string" then
                                        table.insert(t40, {
                                            category = "qualifier",
                                            key = v86,
                                            label = name,
                                            header = name,
                                            body = if typeof(states) == "table" and states[v86] == "pending" then "Awaiting vetting" else nil,
                                            rawValue = v86
                                        })
                                    end
                                end
                            end
                        end

                        local v88 = p64(UnresolvedCommandGrants)

                        if typeof(v88) == "table" then
                            local t42 = {}

                            for _, v89 in v88 do
                                if typeof(v89) == "table" and typeof(v89.key) == "string" then
                                    local key = v89.key

                                    if not t42[key] then
                                        t42[key] = true

                                        local v90 = v89.state == "excluded"
                                        local v91 = key:sub(1, 1):upper() .. key:sub(2)

                                        table.insert(t40, {
                                            category = "qualifier",
                                            hiddenFromPicker = true,
                                            unresolved = true,
                                            key = key,
                                            label = v91,
                                            header = v91,
                                            rawValue = key,
                                            hintIcon = Icons.WarningFill,
                                            hintText = v90 and "This command was disabled by the game dev in Config > Commands." or "This command no longer exists. Consider removing it from the role."
                                        })
                                    end
                                end
                            end
                        end

                        table.sort(t40, function(p65, p66) -- line: 788
                            if p65.unresolved == true == (p66.unresolved == true) then
                                return p65.label < p66.label
                            end

                            return p65.unresolved == true
                        end)

                        return t40
                    end)
                end
            }
        },
        {
            title = "viewCommands",
            label = "View",
            inputType = "ActionButton",
            description = "The commands this role is able to use",
            settingPath = { "__viewCommands" },
            inputObject = {
                buttonText = "View Commands",
                buttonIcon = "rbxassetid://116538790441934"
            }
        }
    }
}
local t44 = {
    heading = "Command Permissions"
}
local t46 = {
    title = "permitAll",
    label = "All Permissions",
    inputType = "Toggle",
    description = "This is DANGEROUS",
    settingPath = { "permitAll" },
    verifier = v3
}
local v92 = stripToggle("permitTargetingOthers", "Can use commands on other players instead of solely yourself (like ;jump @ForeverHD)")
local t47 = {
    title = "permitMultipleTargets",
    inputType = "Toggle",
    description = "Can use commands on more than one player in a single command-run (like ;jump all, ;fly others)"
}
local v93 = ("permitMultipleTargets"):match("^%l+(.*)$")

if not v93 or v93 == "" then
    local v94 = ("permitMultipleTargets"):gsub("(%l)(%u)", "%1 %2")

    t47.label = v94:sub(1, 1):upper() .. v94:sub(2)
else
    local v95 = v93:gsub("(%l)(%u)", "%1 %2")

    t47.label = v95:sub(1, 1):upper() .. v95:sub(2)
end

t47.settingPath = { "permitMultipleTargets" }
t47.verifier = v3

function t47.lockedDisplayValue(p67) -- line: 827
    local permitAll = p67.valueByTitle.permitAll

    return permitAll and p67.use(permitAll) == true
end

t44.objects = {
    t46,
    v92,
    t47,
    stripToggle("permitBlockCommands", "Can switch on Block commands in their You settings, which stops equal or lower roles running commands on them"),
    stripToggle("permitModifiersAbusive", "Permits potentially-abusive modifiers including 'loop', 'spawn', and 'delay'"),
    stripToggle("permitModifiersGlobal", "Permits EXTREMELY DANGEROUS modifiers including 'global', 'perm' and 'join'"),
    (stripToggle("permitBypassLimits", "Ignores role limits and command-specific limits (such as scale limits for ;width, ;size, etc). This is DANGEROUS and can crash servers if abused."))
}

local t48 = {
    heading = "Command Limits"
}
local t50 = {
    title = "limitCommandsPerMinute",
    inputType = "NumberInput"
}
local v100 = ("limitCommandsPerMinute"):match("^%l+(.*)$")

if not v100 or v100 == "" then
    local v101 = ("limitCommandsPerMinute"):gsub("(%l)(%u)", "%1 %2")

    t50.label = v101:sub(1, 1):upper() .. v101:sub(2)
else
    local v102 = v100:gsub("(%l)(%u)", "%1 %2")

    t50.label = v102:sub(1, 1):upper() .. v102:sub(2)
end

t50.settingPath = { "limitCommandsPerMinute" }
t50.inputObject = {
    default = 60,
    min = 0,
    max = 600,
    step = 1,
    useSlider = false
}
t50.verifier = settingVerifiers.integerRange(0, 600)

local t51 = {
    title = "limitRequestsPerSecond",
    inputType = "NumberInput"
}
local v103 = ("limitRequestsPerSecond"):match("^%l+(.*)$")

if not v103 or v103 == "" then
    local v104 = ("limitRequestsPerSecond"):gsub("(%l)(%u)", "%1 %2")

    t51.label = v104:sub(1, 1):upper() .. v104:sub(2)
else
    local v105 = v103:gsub("(%l)(%u)", "%1 %2")

    t51.label = v105:sub(1, 1):upper() .. v105:sub(2)
end

t51.settingPath = { "limitRequestsPerSecond" }
t51.inputObject = {
    default = 10,
    min = 0,
    max = 60,
    step = 1,
    useSlider = false
}
t51.verifier = settingVerifiers.integerRange(0, 60)
t48.objects = {
    t50,
    t51
}

return {
    t15,
    t16,
    t17,
    t29,
    t44,
    t48,
    {
        heading = "Role Permissions",
        objects = {
            {
                title = "mayPreviewRoles",
                label = "Preview Roles",
                inputType = "Toggle",
                description = "Can preview and act-as selected roles equal or below this role. Be careful because it grants all permissions from roles below.",
                settingPath = { "mayPreviewRoles" },
                verifier = v3
            }
        }
    },
    {
        heading = "View Permissions",
        objects = {
            {
                title = "mayViewAll",
                label = "All Permissions",
                inputType = "Toggle",
                settingPath = { "mayViewAll" },
                verifier = v3
            },
            {
                title = "mayViewIcon",
                label = "Icon",
                inputType = "ItemSelector",
                lockedDisplayValue = "Menu",
                description = "Should the TopbarPlus Icon appear, and for which page? If 'Commands', only the Commands page is accessible (not the dashboard)",
                settingPath = { "mayViewIcon" },
                escalationCheck = mayViewIconEscalation,
                verifier = settingVerifiers.oneOfString({ "Menu", "Commands", "None" }),
                inputObject = {
                    limitPickerToOneItem = true,
                    pickerGetter = function() -- pickerGetter | line: 909
                        return {
                            {
                                key = "None",
                                label = "None",
                                header = "None",
                                rawValue = "None",
                                category = "qualifier"
                            },
                            {
                                key = "Commands",
                                label = "Commands",
                                header = "Commands",
                                rawValue = "Commands",
                                category = "qualifier"
                            },
                            {
                                key = "Menu",
                                label = "Menu",
                                header = "Menu",
                                rawValue = "Menu",
                                category = "qualifier"
                            }
                        }
                    end
                }
            },
            {
                title = "mayViewPages",
                label = "Pages",
                inputType = "ItemSelector",
                lockedDisplayValue = "All",
                settingPath = { "mayViewPages" },
                escalationCheck = mayViewPagesEscalation,
                verifier = settingVerifiers.arrayOfOneOfString({
                    "Commands",
                    "CommandBar",
                    "Analytics",
                    "Bans",
                    "Warns",
                    "Roles",
                    "RoleSettings",
                    "MembersServer",
                    "MembersPermanent",
                    "Tasks",
                    "Logs",
                    "YouSettings",
                    "GameSettings"
                }, 13, 512),
                inputObject = {
                    pickerGetter = function() -- pickerGetter | line: 931
                        return {
                            {
                                key = "All",
                                label = "All",
                                header = "All",
                                rawValue = "All",
                                category = "qualifier",
                                hiddenFromPicker = true
                            },
                            {
                                key = "Commands",
                                label = "Commands",
                                header = "Commands",
                                rawValue = "Commands",
                                category = "qualifier"
                            },
                            {
                                key = "CommandBar",
                                label = "Command Bar",
                                header = "Command Bar",
                                rawValue = "CommandBar",
                                category = "qualifier"
                            },
                            {
                                key = "Analytics",
                                label = "Analytics",
                                header = "Analytics",
                                rawValue = "Analytics",
                                category = "qualifier"
                            },
                            {
                                key = "Bans",
                                label = "Bans",
                                header = "Bans",
                                rawValue = "Bans",
                                category = "qualifier"
                            },
                            {
                                key = "Warns",
                                label = "Warns",
                                header = "Warns",
                                rawValue = "Warns",
                                category = "qualifier"
                            },
                            {
                                key = "Roles",
                                label = "Roles",
                                header = "Roles",
                                rawValue = "Roles",
                                category = "qualifier"
                            },
                            {
                                key = "RoleSettings",
                                label = "Role Settings",
                                header = "Role Settings",
                                rawValue = "RoleSettings",
                                category = "qualifier"
                            },
                            {
                                key = "MembersServer",
                                label = "Members Server",
                                header = "Members Server",
                                rawValue = "MembersServer",
                                category = "qualifier"
                            },
                            {
                                key = "MembersPermanent",
                                label = "Members Permanent",
                                header = "Members Permanent",
                                rawValue = "MembersPermanent",
                                category = "qualifier"
                            },
                            {
                                key = "Tasks",
                                label = "Tasks",
                                header = "Tasks",
                                rawValue = "Tasks",
                                category = "qualifier"
                            },
                            {
                                key = "Logs",
                                label = "Logs",
                                header = "Logs",
                                rawValue = "Logs",
                                category = "qualifier"
                            },
                            {
                                key = "YouSettings",
                                label = "You Settings",
                                header = "You Settings",
                                rawValue = "YouSettings",
                                category = "qualifier"
                            },
                            {
                                key = "GameSettings",
                                label = "Game Settings",
                                header = "Game Settings",
                                rawValue = "GameSettings",
                                category = "qualifier"
                            }
                        }
                    end
                }
            },
            {
                title = "mayViewUnavailableCommands",
                label = "Unavailable Commands",
                inputType = "Toggle",
                description = "Can the user see commands that can't be used, bought or unlocked?",
                settingPath = { "mayViewUnavailableCommands" },
                verifier = v3
            }
        }
    },
    {
        heading = "Edit Permissions",
        objects = {
            {
                title = "mayEditAll",
                label = "All Permissions",
                inputType = "Toggle",
                description = "This is DANGEROUS",
                settingPath = { "mayEditAll" },
                verifier = v3
            },
            {
                title = "mayEditRoles",
                label = "Roles",
                inputType = "Toggle",
                description = "Can create, edit, delete, and reorder roles ranked below this one. Can only grant permissions this role already holds.",
                settingPath = { "mayEditRoles" },
                verifier = v3
            },
            {
                title = "mayEditTasks",
                label = "Tasks",
                inputType = "Toggle",
                description = "Can pause, resume, and cancel running command tasks within the Tasks page, except tasks from equal or higher roles with 'Block commands' enabled.",
                settingPath = { "mayEditTasks" },
                verifier = v3
            },
            {
                title = "mayEditSettingsYou",
                label = "You Settings",
                inputType = "Toggle",
                description = "Can edit personal settings like theme, prefix, and sound",
                settingPath = { "mayEditSettingsYou" },
                verifier = v3
            },
            {
                title = "mayEditSettingsGame",
                label = "Game Settings",
                inputType = "Toggle",
                description = "This is DANGEROUS. Users of this role can make universe-wide changes",
                settingPath = { "mayEditSettingsGame" },
                verifier = v3
            },
            {
                title = "mayVetCommands",
                label = "Vet Commands",
                inputType = "Toggle",
                description = "Can approve, disable and test new commands that arrive from HD Admin updates",
                settingPath = { "mayVetCommands" },
                verifier = v3
            }
        }
    },
    {
        heading = "Prompt",
        objects = {
            {
                title = "promptAll",
                label = "All Prompts",
                inputType = "Toggle",
                settingPath = { "promptAll" },
                verifier = v3
            },
            stripToggle("promptWarnings", "Shows warning notices (like invalid command, missing permission)"),
            (stripToggle("promptWelcome", "Shows welcome notices on join (like 'your roles are [xyz]')"))
        }
    }
}
