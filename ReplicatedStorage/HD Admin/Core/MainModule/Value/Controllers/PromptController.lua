-- https://lua.expert

local t1 = {}
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Log = require(Modules.Log)
local Remote = require(Modules.Objects.Remote)
local Prompt = require(Modules.Prompt)
local Popups = require(Modules.Parent.Controllers.UI.Util.Popups)
local Fusion = require(Modules.Parent.Packages.Fusion)
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local t6 = {}
local v1

local function getControlRemote() -- line: 24
    -- upvalues: Remote (copy), v1 (ref)
    v1 = v1 or Remote.get("PromptControl")

    return v1
end

local function openPageDirect(p1) -- line: 31
    -- upvalues: Modules (copy)
    local Navigate = require(Modules.Parent.Controllers.UI.Util.Navigate)

    Navigate.awaitReady(3)

    if Navigate.isPanelOpen() then
        Navigate.toPage(p1)
    else
        Navigate.toPage(p1)
        task.wait(0.35)
        Navigate.openPanel()
    end
end

local v2 = false

local function ensurePromptUpdateListener() -- line: 46
    -- upvalues: Remote (copy), Fusion (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), v2 (ref)
    if v2 then
        return
    end

    v2 = true

    local PromptUpdate = Remote.get("PromptUpdate")

    if PromptUpdate then
        PromptUpdate:onClientEvent(function(p2, p3, p4) -- line: 55
            -- upvalues: Fusion (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy)
            if typeof(p2) ~= "string" then
                return
            end

            local v3 = t3[p2]

            if v3 and typeof(p3) == "string" then
                v3:set(p3)
            end

            if typeof(p4) ~= "table" then
                return
            end

            local v4 = t4[p2]

            if v4 and p4.iconButtons then
                v4:set(p4.iconButtons)
            end

            local v5 = t5[p2]
            local v6

            if v5 and typeof(p4.buttonLoading) == "table" then
                v6 = Fusion.peek(v5)

                local v7 = table.clone(if typeof(v6) ~= "table" then {} else v6)

                for v8, v9 in p4.buttonLoading do
                    v7[v8] = v9 == true
                end

                v5:set(v7)
            end

            local v10 = t6[p2]

            if v10 and typeof(p4.controlValues) == "table" then
                v10:set(p4.controlValues)
            end
        end)
    end
end

Remote.get("Prompt"):onClientEvent(function(p5, p6, p7, p8) -- line: 87
    -- upvalues: Modules (copy), Log (copy), Remote (copy), Prompt (copy), Popups (copy), Fusion (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), v1 (ref), openPageDirect (copy), v2 (ref)
    local v11 = Prompt[p5]

    if not v11 then
        Log.debug((("no client handler for prompt type %*"):format(p5)))

        return
    end

    local v12 = p6

    if typeof(p7) == "table" and typeof(p7.localEpoch) == "number" and typeof(p6) == "string" then
        v12 = p6:gsub("%%TIME%%", (tostring((os.date("%H:%M on %d %b %Y", p7.localEpoch)))))
    end

    if typeof(v12) == "string" and v12:find("%PRIMARY%", 1, true) then
        local Theme = require(Modules.Parent.Controllers.UI.Util.Theme)
        local v14 = Fusion.peek(Theme.Color.Primary)

        v12 = v12:gsub("%%PRIMARY%%", "#" .. string.format("%02X%02X%02X", math.floor(v14.R * 255 + 0.5), math.floor(v14.G * 255 + 0.5), (math.floor(v14.B * 255 + 0.5))))
    end

    if typeof(p7) == "table" and typeof(p7.openPage) == "string" then
        local openPage = p7.openPage

        if openPage == "About" then
            require(Modules.Parent.Controllers.UI.Util.AboutPreload).warm()
        end

        p7.onActivate = function() -- line: 109
            -- upvalues: openPage (copy), openPageDirect (copy)
            task.spawn(openPageDirect, openPage)
        end
    end

    if typeof(p7) == "table" and p7.openVetting == true then
        p7.onActivate = function() -- line: 114
            -- upvalues: Modules (copy)
            task.spawn(function() -- line: 115
                -- upvalues: Modules (copy)
                require(Modules.Parent.Controllers.UI.Config.VettingState).open(true)
            end)
        end
    end

    if typeof(p7) == "table" and p7.openProfile == true then
        p7.onActivate = function() -- line: 122
            -- upvalues: Modules (copy)
            task.spawn(function() -- line: 123
                -- upvalues: Modules (copy)
                require(Modules.Parent.Controllers.UI.Config.Panels).openProfile(game:GetService("Players").LocalPlayer.UserId)
            end)
        end
    end

    if typeof(p7) == "table" and typeof(p7.linkButtons) == "table" then
        local Icons = require(Modules.Parent.Controllers.UI.Config.Icons)
        local t7 = {}

        for _, v20 in p7.linkButtons do
            if typeof(v20) == "table" and typeof(v20.label) == "string" then
                local page2 = if typeof(v20.page) == "string" then v20.page else nil

                if page2 == "About" then
                    require(Modules.Parent.Controllers.UI.Util.AboutPreload).warm()
                end

                local v21 = v20.profile == true
                local unlockRole2 = if typeof(v20.unlockRole) == "string" then v20.unlockRole else nil
                local promptProduct2 = if typeof(v20.promptProduct) == "string" then v20.promptProduct else nil
                local v22 = if page2 then Icons.Pages[page2]
                    elseif v21 then Icons.Pages.Profile
                    elseif promptProduct2 then Icons.Unlock
                    else nil

                table.insert(t7, {
                    label = v20.label,
                    icon = v22,
                    large = unlockRole2 ~= nil or promptProduct2 ~= nil,
                    hideAfterPress = v20.hideAfterPress == true,
                    style = if typeof(v20.style) == "string" then v20.style else nil,
                    onActivate = function() -- onActivate | line: 154
                        -- upvalues: page2 (copy), v21 (copy), promptProduct2 (copy), unlockRole2 (copy), Modules (copy), openPageDirect (copy)
                        if promptProduct2 then
                            local promptPurchaseAsync = require(Modules.AssetUtil.promptPurchaseAsync)
                            local awaitPurchaseFinished = require(Modules.AssetUtil.awaitPurchaseFinished)

                            if promptPurchaseAsync(promptProduct2) then
                                awaitPurchaseFinished()
                            end
                        elseif v21 then
                            require(Modules.Parent.Controllers.UI.Config.Panels).openProfile(game:GetService("Players").LocalPlayer.UserId)
                        elseif unlockRole2 then
                            local CommandAccess = require(Modules.Parent.Controllers.UI.Util.CommandAccess)
                            local RoleInfo, RoleInfo2 = require(Modules.References.clientUser).everyone:fetchAsync("RoleInfo")

                            if RoleInfo then
                                CommandAccess.promptUnlockAsync(RoleInfo2, unlockRole2)
                            end
                        elseif page2 then
                            openPageDirect(page2)
                        end
                    end
                })
            end
        end

        if #t7 > 0 then
            p7.footerButtons = t7
        end
    end

    if typeof(p7) == "table" and typeof(p7.openImage) == "table" and typeof(p7.openImage.image) == "string" then
        local openImage = p7.openImage

        p7.keepOpenOnActivate = true

        p7.onActivate = function() -- line: 187
            -- upvalues: openImage (copy), Popups (copy)
            Popups.push("centre", {
                kind = "message",
                text = "",
                options = {
                    duration = 0,
                    userOpened = true,
                    title = openImage.title,
                    image = openImage.image,
                    imageRatio = if typeof(openImage.ratio) == "number" then openImage.ratio else nil
                }
            })
        end
    end

    local v23 = p7

    if typeof(p8) == "string" then
        v23 = p7 or {}

        v23.onClosed = function() -- line: 204
            -- upvalues: p8 (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy)
            t2[p8] = nil
            t3[p8] = nil
            t4[p8] = nil
            t5[p8] = nil
            t6[p8] = nil
        end

        if p5 == "action" then
            if not v2 then
                v2 = true

                local PromptUpdate = Remote.get("PromptUpdate")

                if PromptUpdate then
                    PromptUpdate:onClientEvent(function(p9, p10, p11) -- line: 55
                        -- upvalues: Fusion (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy)
                        if typeof(p9) ~= "string" then
                            return
                        end

                        local v25 = t3[p9]

                        if v25 and typeof(p10) == "string" then
                            v25:set(p10)
                        end

                        if typeof(p11) ~= "table" then
                            return
                        end

                        local v26 = t4[p9]

                        if v26 and p11.iconButtons then
                            v26:set(p11.iconButtons)
                        end

                        local v27 = t5[p9]
                        local v28

                        if v27 and typeof(p11.buttonLoading) == "table" then
                            v28 = Fusion.peek(v27)

                            local v29 = table.clone(if typeof(v28) ~= "table" then {} else v28)

                            for v30, v31 in p11.buttonLoading do
                                v29[v30] = v31 == true
                            end

                            v27:set(v29)
                        end

                        local v32 = t6[p9]

                        if v32 and typeof(p11.controlValues) == "table" then
                            v32:set(p11.controlValues)
                        end
                    end)
                end
            end

            t3[p8] = Popups.value(if typeof(v23.state) == "string" then v23.state else "active")
            v23.actionState = t3[p8]
            t4[p8] = Popups.value(v23.iconButtons)
            v23.iconButtonsState = t4[p8]
            t5[p8] = Popups.value({})
            v23.buttonLoadingState = t5[p8]
            t6[p8] = Popups.value({})
            v23.controlValuesState = t6[p8]

            v23.onAction = function(p12, p13, p14) -- line: 221
                -- upvalues: p8 (copy), Remote (copy), v1 (ref)
                v1 = v1 or Remote.get("PromptControl")

                local v34 = v1

                if v34 then
                    v34:fireServer(p8, p12, p13, p14)
                end
            end
        end
    end

    local v35 = v11(v12, v23)

    if typeof(p8) == "string" then
        t2[p8] = v35
    end
end)
Remote.get("PromptDismiss"):onClientEvent(function(p15) -- line: 235
    -- upvalues: t2 (copy), t3 (copy), t4 (copy), t5 (copy)
    if typeof(p15) ~= "string" then
        return
    end

    local v36 = t2[p15]

    if v36 then
        t2[p15] = nil
        t3[p15] = nil
        t4[p15] = nil
        t5[p15] = nil

        if typeof(v36) == "table" and v36.Disconnect then
            v36.Disconnect()
        end
    end
end)
require(Modules.References.promptClientReadyRemote):fireServer()

return t1
