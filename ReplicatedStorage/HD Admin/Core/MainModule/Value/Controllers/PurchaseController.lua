-- https://lua.expert

local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local UI = Modules.Parent.Controllers.UI
local Prompt = require(Modules.Prompt)
local Remote = require(Modules.Objects.Remote)
local equipToAccount = require(UI.Util.equipToAccount)
local t1 = {}
local t2 = {}

local function expectPurchase(p1) -- line: 29
    -- upvalues: t1 (copy)
    if typeof(p1) == "number" then
        t1[p1] = os.clock()
    end
end

local function consumePurchase(p2) -- line: 35
    -- upvalues: t1 (copy)
    local v1 = t1[p2]

    if not v1 then
        return false
    end

    t1[p2] = nil

    return os.clock() - v1 <= 120
end

local function escapeRich(p3) -- line: 44
    return (p3:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function notifyPurchase(p4) -- line: 48
    -- upvalues: Prompt (copy), equipToAccount (copy)
    local v2 = ("<b>%*</b>"):format((p4.name:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")))
    local t3 = {
        duration = 15
    }

    if p4.kind ~= nil then
        local t4 = {
            kind = p4.kind,
            assetId = p4.assetId,
            name = p4.name,
            assetTypeId = p4.assetTypeId
        }

        t3.equip = {
            label = "Equip",
            onActivate = function() -- onActivate | line: 62
                -- upvalues: v2 (copy), t4 (copy), Prompt (copy), equipToAccount (copy)
                local v3 = equipToAccount.equip(t4)

                if v3 == "success" then
                    Prompt.success((("Added %* to your avatar!"):format(v2)))
                elseif v3 == "wheelFull" then
                    Prompt.warn("Your emote wheel is full (8/8). Unequip one in the Roblox avatar editor, then try again.")
                elseif v3 == "noCharacter" then
                    Prompt.warn("Respawn, then try Equip again.")
                elseif v3 == "failed" or v3 == "error" then
                    Prompt.error((("Couldn't add %* to your avatar. Please try again."):format(v2)))
                end
            end
        }
    end

    local v4 = if not p4.typeLabel or p4.typeLabel == "" then "" else (" %*"):format(p4.typeLabel)

    Prompt.success(("Purchased %*%*!"):format(v2, v4), t3)
end

local function handlePurchasedAsset(p5, p6) -- line: 82
    -- upvalues: equipToAccount (copy), t1 (copy), notifyPurchase (copy)
    local v5 = t1[p5]

    if v5 then
        t1[p5] = nil

        if os.clock() - v5 <= 120 then
            task.spawn(function() -- line: 86
                -- upvalues: p5 (copy), p6 (copy), equipToAccount (copy), notifyPurchase (copy)
                notifyPurchase(equipToAccount.classify(p5, p6))
            end)
        end
    end
end

if RunService:IsClient() then
    Remote.get("ExpectPurchase"):onClientEvent(function(p7) -- line: 98
        -- upvalues: t1 (copy)
        if typeof(p7) == "number" and typeof(p7) == "number" then
            t1[p7] = os.clock()
        end
    end)
    MarketplaceService.PromptBulkPurchaseFinished:Connect(function(_, _, p10) -- line: 104
        -- upvalues: equipToAccount (copy), t1 (copy), notifyPurchase (copy)
        local v6 = if typeof(p10) == "table" then p10.Items or p10 else nil

        if typeof(v6) == "table" then
            for _, v7 in v6 do
                if typeof(v7) == "table" and (v7.status or v7.Status) == Enum.MarketplaceItemPurchaseStatus.Success then
                    local v9 = tonumber(v7.id or v7.Id)

                    if v9 then
                        local v10 = v7.type or v7.Type
                        local v11 = t1[v9]

                        if v11 then
                            t1[v9] = nil

                            if os.clock() - v11 <= 120 then
                                task.spawn(function() -- line: 86
                                    -- upvalues: v9 (copy), v10 (copy), equipToAccount (copy), notifyPurchase (copy)
                                    notifyPurchase(equipToAccount.classify(v9, v10))
                                end)
                            end
                        end
                    end
                end
            end
        end
    end)
    MarketplaceService.PromptPurchaseFinished:Connect(function(_, p12, p13) -- line: 124
        -- upvalues: equipToAccount (copy), t1 (copy), notifyPurchase (copy)
        if not p13 or typeof(p12) ~= "number" then
            return
        end

        local AvatarAsset = Enum.MarketplaceProductType.AvatarAsset
        local v12 = t1[p12]
        local v13 = false

        if v12 then
            t1[p12] = nil
            v13 = os.clock() - v12 <= 120
        end

        if not v13 then
            return
        end

        task.spawn(function() -- line: 86
            -- upvalues: p12 (copy), AvatarAsset (copy), equipToAccount (copy), notifyPurchase (copy)
            notifyPurchase(equipToAccount.classify(p12, AvatarAsset))
        end)
    end)
    MarketplaceService.PromptBundlePurchaseFinished:Connect(function(_, p15, p16) -- line: 130
        -- upvalues: equipToAccount (copy), t1 (copy), notifyPurchase (copy)
        if not p16 or typeof(p15) ~= "number" then
            return
        end

        local AvatarBundle = Enum.MarketplaceProductType.AvatarBundle
        local v14 = t1[p15]
        local v15 = false

        if v14 then
            t1[p15] = nil
            v15 = os.clock() - v14 <= 120
        end

        if not v15 then
            return
        end

        task.spawn(function() -- line: 86
            -- upvalues: p15 (copy), AvatarBundle (copy), equipToAccount (copy), notifyPurchase (copy)
            notifyPurchase(equipToAccount.classify(p15, AvatarBundle))
        end)
    end)
    MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(_, p18, p19) -- line: 137
        -- upvalues: equipToAccount (copy), t1 (copy), notifyPurchase (copy)
        if not p19 or typeof(p18) ~= "number" then
            return
        end

        local v16 = t1[p18]

        if v16 then
            t1[p18] = nil

            if os.clock() - v16 <= 120 then
                task.spawn(function() -- line: 144
                    -- upvalues: p18 (copy), equipToAccount (copy), notifyPurchase (copy)
                    notifyPurchase({
                        typeLabel = "gamepass",
                        name = equipToAccount.gamePassName(p18),
                        assetId = p18
                    })
                end)
            end
        end
    end)
end

return t2
