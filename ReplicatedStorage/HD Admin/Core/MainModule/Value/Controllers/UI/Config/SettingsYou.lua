-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local isNumberSafe = require(Modules.VerifyUtil.isNumberSafe)
local UI = Modules.Parent.Controllers.UI

game:GetService("Workspace")

local Fonts = require(script.Parent.Fonts)

require(UI.Config.InputObjects)

local settingVerifiers = require(Modules.VerifyUtil.settingVerifiers)
local Themes = script:FindFirstAncestor("HD Admin").Config.Themes
local v1 = settingVerifiers.boolean()
local t1 = {
    inputType = "NumberInput",
    default = 1,
    min = 0,
    max = 2,
    step = 0.1
}

local function v2(p1, p2) -- line: 28
    -- upvalues: isNumberSafe (copy)
    if typeof(p2) ~= "number" or not isNumberSafe(p2) then
        return true, p1.default
    end

    return true, (math.clamp(p2, p1.min, p1.max))
end

local function countEnabledThemes() -- line: 38
    -- upvalues: Themes (copy)
    local n1 = 0

    for _, child in Themes:GetChildren() do
        if child:IsA("ModuleScript") then
            local _require = require
            local ok, result = pcall(_require, child)

            if ok and typeof(result) == "table" then
                local Settings = result.Settings

                if not Settings or Settings.ShowInYouSettings == nil or Settings.ShowInYouSettings then
                    n1 += 1
                end
            end
        end
    end

    return n1
end

return {
    {
        heading = "Display",
        objects = {
            {
                title = "Theme",
                inputType = "ItemSelector",
                hidden = countEnabledThemes() <= 1,
                settingPath = { "YouSettings", "Display", "Theme" },
                defaultFromEveryone = { "GameSettings", "PlayerSettings", "Display", "Theme" },
                inputObject = {
                    limitPickerToOneItem = true,
                    pickerGetter = function() -- pickerGetter | line: 71
                        -- upvalues: UI (copy), Themes (copy)
                        local BaseTheme = require(UI.Util.Theme.BaseTheme)
                        local t7 = {}

                        for _, child in Themes:GetChildren() do
                            if child:IsA("ModuleScript") then
                                local v3 = require(child)

                                if not v3.Settings or v3.Settings.ShowInYouSettings == nil or v3.Settings.ShowInYouSettings then
                                    local Body = if v3.Font and v3.Font.Body then v3.Font.Body else BaseTheme.Font.Body
                                    local v4 = if v3.Settings and v3.Settings.LayoutOrder then v3.Settings.LayoutOrder else 999

                                    table.insert(t7, {
                                        category = "qualifier",
                                        key = child.Name,
                                        label = child.Name,
                                        header = child.Name,
                                        rawValue = child.Name,
                                        fontFamily = Body,
                                        displayOrder = v4
                                    })
                                end
                            end
                        end

                        table.sort(t7, function(p3, p4) -- line: 98
                            return p3.displayOrder < p4.displayOrder
                        end)

                        return t7
                    end
                },
                verifier = function(_, p6) -- verifier | line: 104
                    -- upvalues: Themes (copy)
                    local v5 = if typeof(p6) == "table" and #p6 == 1 then p6[1] else p6

                    if typeof(v5) == "string" then
                        local v6 = Themes:FindFirstChild(v5)

                        if v6 and v6:IsA("ModuleScript") then
                            return true, v5
                        end
                    end

                    return false, "Invalid theme"
                end
            },
            {
                title = "Primary Color",
                inputType = "ColorPicker",
                settingPath = { "YouSettings", "Display", "PrimaryColor" },
                defaultFromEveryone = { "GameSettings", "PlayerSettings", "Display", "PrimaryColor" },
                updateThemeValues = { { "Color", "Primary" } },
                lockSetting = { "Settings", "LockPrimaryColor" },
                verifier = function(_, p8) -- verifier | line: 125
                    if typeof(p8) == "Color3" then
                        return true, p8
                    end

                    return false, "Invalid color value"
                end
            },
            {
                title = "Font",
                inputType = "ItemSelector",
                settingPath = { "YouSettings", "Display", "Font" },
                defaultFromEveryone = { "GameSettings", "PlayerSettings", "Display", "Font" },
                updateThemeValues = {
                    { "Font", "Heading" },
                    { "Font", "Body" }
                },
                lockSetting = { "Settings", "LockFont" },
                inputObject = {
                    limitPickerToOneItem = true,
                    pickerGetter = function() -- pickerGetter | line: 141
                        -- upvalues: Fonts (copy)
                        local t12 = {}

                        for _, v7 in Fonts do
                            table.insert(t12, {
                                category = "qualifier",
                                key = v7.family,
                                label = v7.name,
                                header = v7.name,
                                rawValue = v7.family,
                                fontFamily = v7.family
                            })
                        end

                        return t12
                    end
                },
                verifier = function(_, p10) -- verifier | line: 156
                    local v8 = if typeof(p10) == "table" and #p10 == 1 then p10[1] else p10

                    if typeof(v8) ~= "string" or not v8:find("^rbxasset://fonts/families/") then
                        return false, "Invalid font value"
                    end

                    return true, v8
                end
            },
            {
                title = "Content Scale",
                inputType = "NumberInput",
                updateThemeValues = { { "Layout", "ContentScale" } },
                lockSetting = { "Settings", "LockContentScale" },
                settingPath = { "YouSettings", "Display", "ContentScale" },
                defaultFromEveryone = { "GameSettings", "PlayerSettings", "Display", "ContentScale" },
                inputObject = {
                    default = 1,
                    min = 0.5,
                    max = 1.5,
                    step = 0.1
                },
                verifier = function(p11, p12) -- verifier | line: 180
                    -- upvalues: isNumberSafe (copy)
                    if typeof(p12) ~= "number" or not isNumberSafe(p12) then
                        return false, "Invalid number value"
                    end

                    return true, (math.clamp(p12, p11.min, p11.max))
                end
            },
            {
                title = "Menu Height",
                inputType = "NumberInput",
                settingPath = { "YouSettings", "Display", "MenuHeight" },
                defaultFromEveryone = { "GameSettings", "PlayerSettings", "Display", "MenuHeight" },
                inputObject = {
                    default = 10,
                    min = 5,
                    max = 15,
                    step = 1
                },
                verifier = function(p13, p14) -- verifier | line: 198
                    -- upvalues: isNumberSafe (copy)
                    if typeof(p14) ~= "number" or not isNumberSafe(p14) then
                        return false, "Invalid number value"
                    end

                    return true, (math.clamp(math.round(p14), p13.min, p13.max))
                end
            }
        }
    },
    {
        heading = "Command",
        objects = {
            {
                title = "Prefix",
                inputType = "TextInput",
                settingPath = { "YouSettings", "Prefix" },
                defaultFromEveryone = { "GameSettings", "PlayerSettings", "Prefix" },
                inputObject = {
                    limitTextLength = 1,
                    clearTextOnFocus = true
                },
                verifier = function(_, p16) -- verifier | line: 222
                    -- upvalues: Modules (copy)
                    local isValidPrefix = require(Modules.CommandUtil.isValidPrefix)

                    if typeof(p16) ~= "string" or not isValidPrefix(p16) then
                        return false, "Invalid prefix. Must be a special character such as ;, :, >, !, @, #, etc"
                    end

                    return true, p16
                end
            },
            {
                title = "Block commands",
                inputType = "Toggle",
                description = "Block commands run on you from equal or lower roles",
                settingPath = { "YouSettings", "BlockCommands" },
                defaultFromEveryone = { "GameSettings", "PlayerSettings", "BlockCommands" },
                verifier = v1
            },
            {
                title = "Block prompts",
                inputType = "Toggle",
                description = "Block prompts sent to you from equal or lower roles",
                settingPath = { "YouSettings", "BlockPrompts" },
                defaultFromEveryone = { "GameSettings", "PlayerSettings", "BlockPrompts" },
                verifier = v1
            }
        }
    },
    {
        heading = "Sound",
        objects = {
            {
                title = "SFX Volume",
                inputType = "NumberInput",
                inputObject = t1,
                settingPath = { "YouSettings", "Sound", "Volume", "Interface" },
                defaultFromEveryone = { "GameSettings", "PlayerSettings", "Sound", "Volume", "Interface" },
                verifier = v2
            },
            {
                title = "SFX Pitch",
                hidden = true,
                inputType = "NumberInput",
                inputObject = t1,
                settingPath = { "YouSettings", "Sound", "Pitch", "Interface" },
                defaultFromEveryone = { "GameSettings", "PlayerSettings", "Sound", "Pitch", "Interface" },
                verifier = v2
            },
            {
                title = "Music Volume",
                inputType = "NumberInput",
                inputObject = t1,
                settingPath = { "YouSettings", "Sound", "Volume", "Music" },
                defaultFromEveryone = { "GameSettings", "PlayerSettings", "Sound", "Volume", "Music" },
                verifier = v2
            },
            {
                title = "Music Pitch",
                hidden = true,
                inputType = "NumberInput",
                inputObject = t1,
                settingPath = { "YouSettings", "Sound", "Pitch", "Music" },
                defaultFromEveryone = { "GameSettings", "PlayerSettings", "Sound", "Pitch", "Music" },
                verifier = v2
            },
            {
                title = "Cmd Volume",
                inputType = "NumberInput",
                inputObject = t1,
                settingPath = { "YouSettings", "Sound", "Volume", "Command" },
                defaultFromEveryone = { "GameSettings", "PlayerSettings", "Sound", "Volume", "Command" },
                verifier = v2
            },
            {
                title = "Cmd Pitch",
                hidden = true,
                inputType = "NumberInput",
                inputObject = t1,
                settingPath = { "YouSettings", "Sound", "Pitch", "Command" },
                defaultFromEveryone = { "GameSettings", "PlayerSettings", "Sound", "Pitch", "Command" },
                verifier = v2
            }
        }
    }
}
