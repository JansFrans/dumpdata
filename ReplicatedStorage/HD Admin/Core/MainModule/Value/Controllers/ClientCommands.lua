-- https://lua.expert

local t1 = {}
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Log = require(Modules.Log)
local Services = Modules.Parent.Services
local Task = require(Modules.Objects.Task)
local t2 = {}
local t3 = {}
local v1 = true
local Remote = require(Modules.Objects.Remote)
local t4 = {}

Remote.get("RunClientCommand"):onClientEvent(function(p1, ...) -- line: 23
    -- upvalues: t1 (copy), Task (copy), t4 (copy)
    local v2 = t1.getCommand(p1.commandKey)
    local v3 = Task.getTask(p1.UID)

    if v2 then
        if v3 then
            v3.clientArgs = p1.clientArgs
            v3:run()
        else
            local v4 = Task.new(p1)
            local UID = p1.UID

            if not (UID and t4[UID]) then
                v4:keep("Indefinitely")
            end
        end
    end
end)
Remote.get("EndClientTask"):onClientEvent(function(p2, p3) -- line: 44
    -- upvalues: Task (copy), t4 (copy)
    local v5 = Task.getTask(p2)

    if not p3 then
        t4[p2] = true
        task.delay(30, function() -- line: 50
            -- upvalues: p2 (copy), t4 (copy)
            t4[p2] = nil
        end)
    end

    if v5 then
        if v5.hasStartedInitialRun then
            v5:destroy()
        else
            task.defer(function() -- line: 61
                -- upvalues: v5 (copy)
                v5:destroy()
            end)
        end
    end
end)
Remote.get("ReplicateClientCommand"):onClientEvent(function(p4, ...) -- line: 69
    -- upvalues: t1 (copy)
    local v6 = t1.getCommand(p4)

    if v6 and typeof(v6.replication) == "function" then
        v6.replication(...)
    end
end)
require(Modules.References.openPreviewRemote):onClientEvent(function(p5) -- line: 77
    -- upvalues: Modules (copy)
    if typeof(p5) ~= "table" then
        return
    end

    local commandKey = p5.commandKey

    if typeof(commandKey) == "string" then
        local argTokens, modifierTokens = p5.argTokens, p5.modifierTokens
        local Controllers = Modules.Parent.Controllers
        local openPreview = require(Controllers.UI.Config.Panels).openPreview

        if typeof(argTokens) ~= "table" then
            argTokens = nil
        end

        if typeof(modifierTokens) ~= "table" then
            modifierTokens = nil
        end

        openPreview(commandKey, argTokens, modifierTokens)
    end
end)
require(Modules.References.openEmotesRemote):onClientEvent(function() -- line: 93
    -- upvalues: Modules (copy)
    require(Modules.Parent.Controllers.UI.Config.Panels).openEmotes()
end)
require(Modules.References.openProfileRemote):onClientEvent(function(p6) -- line: 99
    -- upvalues: Modules (copy)
    if typeof(p6) == "number" then
        require(Modules.Parent.Controllers.UI.Config.Panels).openProfile(p6)
    end
end)
require(Modules.References.openCommandsRemote):onClientEvent(function(p7) -- line: 106
    -- upvalues: Modules (copy)
    require(Modules.Parent.Controllers.UI.Config.Panels).openCommands(p7)
end)
require(Modules.References.openBoosterRemote):onClientEvent(function(p8, p9) -- line: 112
    -- upvalues: Modules (copy)
    local Panels = require(Modules.Parent.Controllers.UI.Config.Panels)
    local v7 = Panels.isBoosterOpen()

    Panels.openBooster(p8 == true)

    if p8 == true and v7 and typeof(p9) == "string" then
        local promptPurchaseAsync = require(Modules.AssetUtil.promptPurchaseAsync)

        task.spawn(function() -- line: 118
            -- upvalues: p9 (copy), promptPurchaseAsync (copy), Modules (copy)
            local v8, v9 = promptPurchaseAsync(p9)

            if not v8 and typeof(v9) == "string" and v9 ~= "" then
                require(Modules.Prompt).warn(v9)
            end
        end)
    end
end)

local function highlightBooster(p10, p11) -- line: 127
    -- upvalues: Modules (copy)
    local v10 = require(Modules.Parent.Packages.Fusion).peek(require(Modules.Parent.Controllers.UI.Util.Theme).Color.Primary)
    local v16 = string.format("%02X%02X%02X", math.floor(v10.R * 255 + 0.5), math.floor(v10.G * 255 + 0.5), (math.floor(v10.B * 255 + 0.5)))
    local v17 = p10

    for _, v18 in p11 do
        v17 = v17:gsub(v18:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0"), function(p12) -- line: 133
            -- upvalues: v16 (copy)
            return (("<font color=\"#%*\"><b>%*</b></font>"):format(v16, p12))
        end)
    end

    return v17
end

require(Modules.References.showBoosterOfferRemote):onClientEvent(function(p13, p14) -- line: 141
    -- upvalues: Modules (copy), Remote (copy), highlightBooster (copy)
    local Panels = require(Modules.Parent.Controllers.UI.Config.Panels)

    if Panels.isBoosterOpen() then
        return
    end

    require(Modules.Prompt).info(highlightBooster(p13, { "20% off", "bonus chat commands" }), {
        duration = 0,
        onActivate = function() -- onActivate | line: 148
            -- upvalues: p14 (copy), Panels (copy), Remote (copy)
            task.spawn(function() -- line: 149
                -- upvalues: p14 (copy), Panels (copy), Remote (copy)
                if p14 then
                    Remote.get("StartBoosterOffer"):invokeServerAsync()
                end

                Panels.openBooster()
            end)
        end
    })
end)
require(Modules.References.boosterUnlockedRemote):onClientEvent(function(p15) -- line: 160
    -- upvalues: Modules (copy), highlightBooster (copy)
    local UI = Modules.Parent.Controllers.UI

    require(Modules.Prompt).info(highlightBooster("You've unlocked Chat Commands! Type /commands in chat any time to view these commands", { "Chat Commands", "/commands" }), {
        duration = 0
    })
    require(UI.Config.Panels).swapBoosterToCommands(if typeof(p15) == "table" then p15 else nil)
end)

local MarketplaceService = game:GetService("MarketplaceService")
local recheckBoosterPurchaseRemote = require(Modules.References.recheckBoosterPurchaseRemote)
local productPromptClosedRemote = require(Modules.References.productPromptClosedRemote)
local products = require(Modules.References.products)

MarketplaceService.PromptBulkPurchaseFinished:Connect(function(_, _, p18) -- line: 171
    -- upvalues: recheckBoosterPurchaseRemote (copy), productPromptClosedRemote (copy), products (copy)
    local v20 = if typeof(p18) == "table" then p18.Items or p18 else nil

    if typeof(v20) == "table" then
        local v21 = false

        for _, v22 in v20 do
            if typeof(v22) == "table" then
                local v24 = tonumber(v22.id or v22.Id)

                if v24 then
                    local v25 = (v22.status or v22.Status) == Enum.MarketplaceItemPurchaseStatus.Success

                    if not v21 and v25 and (v24 == products.Booster.id or v24 == products.BoosterDiscount.id) then
                        v21 = true
                        recheckBoosterPurchaseRemote:fireServer()
                    end

                    productPromptClosedRemote:fireServer(v24)
                end
            end
        end
    end
end)
require(Modules.References.openPageRemote):onClientEvent(function(p19, p20, p21) -- line: 189
    -- upvalues: Modules (copy)
    if typeof(p19) ~= "string" then
        return
    end

    local Controllers = Modules.Parent.Controllers
    local Navigate = require(Controllers.UI.Util.Navigate)

    if p21 == true then
        require(Controllers.UI.Config.Panels).closePreviews()
    end

    Navigate.awaitReady(3)

    if Navigate.isPanelOpen() then
        Navigate.toPage(p19)
    else
        Navigate.toPage(p19)
        task.wait(0.35)
        Navigate.openPanel()
    end

    if typeof(p20) == "string" then
        task.defer(function() -- line: 208
            -- upvalues: p20 (copy), Navigate (copy)
            for _, v26 in p20:split("/") do
                Navigate.waitForLabel(v26, 2)
                Navigate.activate("Tab_" .. v26)
            end
        end)
    end
end)

function t1.updateCommands() -- line: 219
    -- upvalues: Modules (copy), Log (copy), Services (copy), t2 (ref), t3 (ref), v1 (ref)
    if not v1 then
        return false
    end

    v1 = false
    t2 = {}
    t3 = {}

    local forEveryCommand = require(Modules.CommandUtil.forEveryCommand)

    local function scanContainerForClientCommands(p22, p23) -- line: 227
        -- upvalues: forEveryCommand (copy), scanContainerForClientCommands (copy), Log (copy), t2 (ref), t3 (ref)
        for _, child in p22:GetChildren() do
            if child:IsA("ModuleScript") then
                if p23 == true then
                    if child:GetAttribute("IsActive") then
                        for _, child in child:GetChildren() do
                            if child:IsA("ModuleScript") and child.Name:lower() == "client" then
                                local _require = require
                                local ok, result = pcall(_require, child)

                                if ok then
                                    forEveryCommand(result, function(p24) -- line: 250
                                        -- upvalues: t2 (ref), t3 (ref)
                                        table.insert(t2, p24)
                                        t3[p24.name:lower()] = p24
                                    end)
                                else
                                    Log.warn((("Client command module '%*' couldn't be loaded: %*"):format(child:GetFullName(), result)))
                                end
                            end
                        end

                        scanContainerForClientCommands(child, p23)
                    end
                else
                    for _, child in child:GetChildren() do
                        if child:IsA("ModuleScript") and child.Name:lower() == "client" then
                            local _require = require
                            local ok, result = pcall(_require, child)

                            if ok then
                                forEveryCommand(result, function(p25) -- line: 250
                                    -- upvalues: t2 (ref), t3 (ref)
                                    table.insert(t2, p25)
                                    t3[p25.name:lower()] = p25
                                end)
                            else
                                Log.warn((("Client command module '%*' couldn't be loaded: %*"):format(child:GetFullName(), result)))
                            end
                        end
                    end

                    scanContainerForClientCommands(child, p23)
                end
            elseif child:IsA("Folder") then
                scanContainerForClientCommands(child, p23)
            end
        end
    end

    scanContainerForClientCommands(Modules.Internal.Commands, true)

    local Commands = Services:FindFirstChild("Commands")

    if Commands then
        scanContainerForClientCommands(Commands)
    end

    return true
end

function t1.getCommand(p26) -- line: 266
    -- upvalues: t1 (copy), t3 (ref)
    t1.updateCommands()

    local v27 = p26:lower()

    return t3[v27]
end

function t1.getCommandsArray() -- line: 273
    -- upvalues: t1 (copy), t2 (ref)
    t1.updateCommands()

    return t2
end

return t1
