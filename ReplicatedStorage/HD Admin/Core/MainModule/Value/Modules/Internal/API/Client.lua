-- https://lua.expert

local t1 = {}
local Players = game:GetService("Players")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Framework = require(Modules.Framework)
local Prompt = require(Modules.Prompt)
local clientUser = require(Modules.References.clientUser)
local Navigate = require(Modules.Parent.Controllers.UI.Util.Navigate)

local function findSettingIn(p1, p2) -- line: 28
    if typeof(p1) ~= "table" then
        return nil
    end

    local PlayerSettings = p1.PlayerSettings

    if typeof(PlayerSettings) == "table" and PlayerSettings[p2] ~= nil then
        return PlayerSettings[p2]
    end

    local SystemSettings = p1.SystemSettings

    if typeof(SystemSettings) ~= "table" or SystemSettings[p2] == nil then
        return p1[p2]
    end

    return SystemSettings[p2]
end

function t1.prompt(p3, p4, p5) -- line: 45
    -- upvalues: Framework (copy), Prompt (copy)
    Framework.waitUntilLoaded()

    local v1 = Prompt[p3]

    if typeof(v1) ~= "function" then
        error((("HD Admin: '%*' is not a valid prompt type"):format((tostring(p3)))))
    end

    return v1(p4, p5)
end

function t1.getSetting(p6, p7) -- line: 54
    -- upvalues: Players (copy), Framework (copy), clientUser (copy)
    Framework.waitUntilLoaded()

    local _, GameSettings = clientUser.everyone:fetchAsync("GameSettings")
    local v2 = false

    if typeof(GameSettings) == "table" then
        local SystemSettings = GameSettings.SystemSettings

        if typeof(SystemSettings) == "table" then
            v2 = SystemSettings["CanChangeYouSettings" .. p6] == false
        end
    end

    local v3

    if not v2 and p7 == Players.LocalPlayer then
        local _, YouSettings = clientUser.perm:fetchAsync("YouSettings")

        if typeof(YouSettings) == "table" then
            local PlayerSettings = YouSettings.PlayerSettings

            if typeof(PlayerSettings) ~= "table" or PlayerSettings[p6] == nil then
                local SystemSettings = YouSettings.SystemSettings

                v3 = if typeof(SystemSettings) ~= "table" or SystemSettings[p6] == nil then YouSettings[p6] else SystemSettings[p6]
            else
                v3 = PlayerSettings[p6]
            end
        end
    end

    if v3 == nil then
        if typeof(GameSettings) ~= "table" then
            return nil
        end

        local PlayerSettings = GameSettings.PlayerSettings

        if typeof(PlayerSettings) == "table" and PlayerSettings[p6] ~= nil then
            return PlayerSettings[p6]
        end

        local SystemSettings = GameSettings.SystemSettings

        if typeof(SystemSettings) == "table" and SystemSettings[p6] ~= nil then
            return SystemSettings[p6]
        end

        v3 = GameSettings[p6]
    end

    return v3
end

function t1.getVersion() -- line: 75
    -- upvalues: Modules (copy), Framework (copy)
    Framework.waitUntilLoaded()

    return require(Modules.Parent.Controllers.UI.Config.VERSION).appVersion
end

function t1.getAppIcon() -- line: 81
    -- upvalues: Modules (copy), Framework (copy)
    Framework.waitUntilLoaded()

    return require(Modules.References.appIcon)
end

function t1.openPanel() -- line: 86
    -- upvalues: Framework (copy), Navigate (copy)
    Framework.waitUntilLoaded()
    Navigate.openPanel()
end

function t1.closePanel() -- line: 91
    -- upvalues: Framework (copy), Navigate (copy)
    Framework.waitUntilLoaded()
    Navigate.closePanel()
end

function t1.isPanelOpen() -- line: 96
    -- upvalues: Framework (copy), Navigate (copy)
    Framework.waitUntilLoaded()

    return Navigate.isPanelOpen()
end

function t1.openPage(p8) -- line: 101
    -- upvalues: Framework (copy), Navigate (copy)
    Framework.waitUntilLoaded()
    Navigate.openPanel()
    Navigate.toPage(p8)
end

function t1.openProfile(p9) -- line: 107
    -- upvalues: Modules (copy), Framework (copy)
    Framework.waitUntilLoaded()
    require(Modules.Parent.Controllers.UI.Config.Panels).openProfile(p9)
end

return t1
