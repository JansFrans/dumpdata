-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local UI = Modules.Parent.Controllers.UI
local Fonts = require(script.Parent.Fonts)

require(UI.Config.InputObjects)

local settingVerifiers = require(Modules.VerifyUtil.settingVerifiers)
local isNumberSafe = require(Modules.VerifyUtil.isNumberSafe)
local Themes = script:FindFirstAncestor("HD Admin").Config.Themes
local v1 = settingVerifiers.boolean()
local t1 = {
    inputType = "NumberInput",
    default = 1,
    min = 0,
    max = 2,
    step = 0.1
}

local function v2(p1, p2) -- line: 31
    -- upvalues: isNumberSafe (copy)
    if typeof(p2) ~= "number" or not isNumberSafe(p2) then
        return true, p1.default
    end

    return true, (math.clamp(p2, p1.min, p1.max))
end

local function countEnabledThemes() -- line: 41
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
                title = "CanChangeYouSettingsTheme",
                label = "Edit Theme",
                inputType = "Toggle",
                description = "Can users change Theme in their YouSettings?",
                lockedDisplayValue = "none",
                settingPath = { "GameSettings", "SystemSettings", "CanChangeYouSettingsTheme" },
                verifier = v1
            },
            {
                title = "CanChangeYouSettingsPrimaryColor",
                label = "Edit Primary Color",
                inputType = "Toggle",
                description = "Can users change Primary Color in their YouSettings?",
                lockedDisplayValue = "none",
                settingPath = { "GameSettings", "SystemSettings", "CanChangeYouSettingsPrimaryColor" },
                verifier = v1
            },
            {
                title = "CanChangeYouSettingsFont",
                label = "Edit Font",
                inputType = "Toggle",
                description = "Can users change Font in their YouSettings?",
                lockedDisplayValue = "none",
                settingPath = { "GameSettings", "SystemSettings", "CanChangeYouSettingsFont" },
                verifier = v1
            },
            {
                title = "CanChangeYouSettingsContentScale",
                label = "Edit Content Scale",
                inputType = "Toggle",
                description = "Can users change Content Scale in their YouSettings?",
                lockedDisplayValue = "none",
                settingPath = { "GameSettings", "SystemSettings", "CanChangeYouSettingsContentScale" },
                verifier = v1
            },
            {
                title = "CanChangeYouSettingsMenuHeight",
                label = "Edit Menu Height",
                inputType = "Toggle",
                description = "Can users change Menu Height in their YouSettings?",
                lockedDisplayValue = "none",
                settingPath = { "GameSettings", "SystemSettings", "CanChangeYouSettingsMenuHeight" },
                verifier = v1
            },
            {
                title = "Theme",
                inputType = "ItemSelector",
                hidden = countEnabledThemes() <= 1,
                settingPath = { "GameSettings", "PlayerSettings", "Display", "Theme" },
                inputObject = {
                    limitPickerToOneItem = true,
                    pickerGetter = function() -- pickerGetter | line: 118
                        -- upvalues: UI (copy), Themes (copy)
                        local BaseTheme = require(UI.Util.Theme.BaseTheme)
                        local t12 = {}

                        for _, child in Themes:GetChildren() do
                            if child:IsA("ModuleScript") then
                                local v3 = require(child)

                                if not v3.Settings or v3.Settings.ShowInYouSettings == nil or v3.Settings.ShowInYouSettings then
                                    local Body = if v3.Font and v3.Font.Body then v3.Font.Body else BaseTheme.Font.Body
                                    local v4 = if v3.Settings and v3.Settings.LayoutOrder then v3.Settings.LayoutOrder else 999

                                    table.insert(t12, {
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

                        table.sort(t12, function(p3, p4) -- line: 145
                            return p3.displayOrder < p4.displayOrder
                        end)

                        return t12
                    end
                },
                verifier = function(_, p6) -- verifier | line: 151
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
                settingPath = { "GameSettings", "PlayerSettings", "Display", "PrimaryColor" },
                verifier = function(_, p8) -- verifier | line: 169
                    if typeof(p8) == "Color3" then
                        return true, p8
                    end

                    return false, "Invalid color value"
                end
            },
            {
                title = "Font",
                inputType = "ItemSelector",
                settingPath = { "GameSettings", "PlayerSettings", "Display", "Font" },
                inputObject = {
                    limitPickerToOneItem = true,
                    pickerGetter = function() -- pickerGetter | line: 182
                        -- upvalues: Fonts (copy)
                        local t17 = {}

                        for _, v7 in Fonts do
                            table.insert(t17, {
                                category = "qualifier",
                                key = v7.family,
                                label = v7.name,
                                header = v7.name,
                                rawValue = v7.family,
                                fontFamily = v7.family
                            })
                        end

                        return t17
                    end
                },
                verifier = function(_, p10) -- verifier | line: 197
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
                settingPath = { "GameSettings", "PlayerSettings", "Display", "ContentScale" },
                inputObject = {
                    default = 1,
                    min = 0.5,
                    max = 1.5,
                    step = 0.1
                },
                verifier = function(p11, p12) -- verifier | line: 218
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
                settingPath = { "GameSettings", "PlayerSettings", "Display", "MenuHeight" },
                inputObject = {
                    default = 10,
                    min = 5,
                    max = 15,
                    step = 1
                },
                verifier = function(p13, p14) -- verifier | line: 235
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
                title = "AutoApproveNewCommands",
                label = "Auto Approve New",
                inputType = "Toggle",
                description = "New commands from HD Admin updates go live immediately. When off they need vetting first (the engine itself always stays up to date)",
                settingPath = { "GameSettings", "SystemSettings", "AutoApproveNewCommands" },
                verifier = v1
            },
            {
                title = "CanChangeYouSettingsPrefix",
                label = "Edit Prefix",
                inputType = "Toggle",
                description = "Can users change Prefix in their YouSettings?",
                lockedDisplayValue = "none",
                settingPath = { "GameSettings", "SystemSettings", "CanChangeYouSettingsPrefix" },
                verifier = v1
            },
            {
                title = "Prefix",
                inputType = "TextInput",
                settingPath = { "GameSettings", "PlayerSettings", "Prefix" },
                inputObject = {
                    limitTextLength = 1,
                    clearTextOnFocus = true
                },
                verifier = function(_, p16) -- verifier | line: 275
                    -- upvalues: Modules (copy)
                    local isValidPrefix = require(Modules.CommandUtil.isValidPrefix)

                    if typeof(p16) ~= "string" or not isValidPrefix(p16) then
                        return false, "Invalid prefix. Must be a special character such as ;, :, >, !, @, #, etc"
                    end

                    return true, p16
                end
            }
        }
    },
    {
        heading = "Sound",
        objects = {
            {
                title = "CanChangeYouSettingsVolume",
                label = "Edit Volume",
                inputType = "Toggle",
                description = "Can users change the Volume sliders in their YouSettings?",
                lockedDisplayValue = "none",
                settingPath = { "GameSettings", "SystemSettings", "CanChangeYouSettingsVolume" },
                verifier = v1
            },
            {
                title = "CanChangeYouSettingsPitch",
                label = "Edit Pitch",
                hidden = true,
                inputType = "Toggle",
                description = "Can users change the Pitch sliders in their YouSettings?",
                lockedDisplayValue = "none",
                settingPath = { "GameSettings", "SystemSettings", "CanChangeYouSettingsPitch" },
                verifier = v1
            },
            {
                title = "SFX Volume",
                inputType = "NumberInput",
                inputObject = t1,
                settingPath = { "GameSettings", "PlayerSettings", "Sound", "Volume", "Interface" },
                verifier = v2
            },
            {
                title = "SFX Pitch",
                hidden = true,
                inputType = "NumberInput",
                inputObject = t1,
                settingPath = { "GameSettings", "PlayerSettings", "Sound", "Pitch", "Interface" },
                verifier = v2
            },
            {
                title = "Music Volume",
                inputType = "NumberInput",
                inputObject = t1,
                settingPath = { "GameSettings", "PlayerSettings", "Sound", "Volume", "Music" },
                verifier = v2
            },
            {
                title = "Music Pitch",
                hidden = true,
                inputType = "NumberInput",
                inputObject = t1,
                settingPath = { "GameSettings", "PlayerSettings", "Sound", "Pitch", "Music" },
                verifier = v2
            },
            {
                title = "Cmd Volume",
                inputType = "NumberInput",
                inputObject = t1,
                settingPath = { "GameSettings", "PlayerSettings", "Sound", "Volume", "Command" },
                verifier = v2
            },
            {
                title = "Cmd Pitch",
                hidden = true,
                inputType = "NumberInput",
                inputObject = t1,
                settingPath = { "GameSettings", "PlayerSettings", "Sound", "Pitch", "Command" },
                verifier = v2
            }
        }
    },
    {
        heading = "Joining",
        objects = {
            {
                title = "EnableMinimumAccountAge",
                label = "Enable Minimum Age",
                inputType = "Toggle",
                description = "Kicks players with an account age below Minimum Age",
                settingPath = { "GameSettings", "SystemSettings", "EnableMinimumAccountAge" },
                verifier = v1
            },
            {
                title = "MinimumAccountAge",
                label = "Minimum Age",
                inputType = "NumberInput",
                description = "The minimum account age in days",
                settingPath = { "GameSettings", "SystemSettings", "MinimumAccountAge" },
                inputObject = {
                    default = 0,
                    min = 0,
                    max = 365,
                    step = 1,
                    useSlider = false
                },
                verifier = function(p17, p18) -- verifier | line: 386
                    -- upvalues: isNumberSafe (copy)
                    if typeof(p18) ~= "number" or not isNumberSafe(p18) then
                        return false, "Invalid number value"
                    end

                    return true, (math.clamp(math.round(p18), p17.min, p17.max))
                end
            }
        }
    },
    {
        heading = "Use Studio Defaults",
        objects = {
            {
                title = "UseDefaultRoles",
                label = "Use Default Roles",
                inputType = "Toggle",
                settingPath = { "GameSettings", "SystemSettings", "UseDefaultRoles" },
                verifier = v1
            },
            {
                title = "UseDefaultGameSettings",
                label = "Use Default Game Settings",
                inputType = "Toggle",
                settingPath = { "GameSettings", "SystemSettings", "UseDefaultGameSettings" },
                verifier = v1
            }
        }
    }
}
