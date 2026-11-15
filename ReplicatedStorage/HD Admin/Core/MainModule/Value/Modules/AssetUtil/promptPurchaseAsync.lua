-- https://lua.expert

local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")

game:GetService("Players")

local LogService = game:GetService("LogService")
local v1 = RunService:IsClient()
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local products = require(Modules.References.products)
local v2, connection

local function watchForThirdPartyBlock() -- line: 16
    -- upvalues: LogService (copy), Modules (copy), connection (ref)
    if connection then
        connection:Disconnect()
        connection = nil
    end

    connection = LogService.MessageOut:Connect(function(p1, p2) -- line: 21
        -- upvalues: Modules (copy), connection (ref)
        if p2 == Enum.MessageType.MessageWarning and tostring(p1):match("AllowThirdPartySales") then
            require(Modules.Prompt).warn("ThirdPartySales must be enabled by the game owner to prompt this item")

            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end)
    task.delay(5, function() -- line: 34
        -- upvalues: connection (ref)
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end)
end

return function(p3, p4, p5) -- line: 42
    -- upvalues: MarketplaceService (copy), v1 (copy), Modules (copy), products (copy), v2 (ref), watchForThirdPartyBlock (copy)
    local v3

    if typeof(p3) == "number" then
        v3 = p3
    else
        local v4 = products[p3]

        if not v4 then
            return false, (("Invalid product name: %*"):format(p3))
        end

        v3 = v4.id
    end

    if v1 then
        v2 = v2 or require(Modules.Objects.Remote).get("PromptProduct")
        watchForThirdPartyBlock()

        local Name = if typeof(p5) == "EnumItem" then p5.Name else nil
        local v5, v6 = v2:invokeServerAsync(v3, Name)

        return v5, v6
    end

    if typeof(p4) ~= "Instance" or not p4:IsA("Player") then
        return false, "Player must be specified on server"
    end

    local v7 = p5
    local infoType, v8

    infoType = p5

    if typeof(p5) ~= "EnumItem" then
        for _, v9 in products do
            if v9.id == v3 then
                infoType = v9.infoType
                v7 = infoType
                v8 = v9.infoType == Enum.InfoType.Asset
                break
            end

            infoType = p5
            v8 = nil
        end
    end

    if infoType == Enum.InfoType.Asset and v8 == nil then
        local v10 = v3

        local function v11() -- line: 76
            -- upvalues: v10 (copy), MarketplaceService (copy)
            return MarketplaceService:GetProductInfo(v10, Enum.InfoType.Asset)
        end

        local ok, result = pcall(v11)

        if ok and result and result.CollectibleItemId then
            v8 = true
        end
    end

    local v12 = infoType == Enum.InfoType.Bundle

    if not (v8 or v12) then
        local ExpectPurchase = require(Modules.Objects.Remote).find("ExpectPurchase")

        if ExpectPurchase then
            ExpectPurchase:fireClient(p4, v3)
        end

        local v13 = v3

        local function v14() -- line: 95
            -- upvalues: p4 (copy), v7 (ref), v13 (copy), MarketplaceService (copy)
            if v7 == Enum.InfoType.Asset then
                return MarketplaceService:PromptPurchase(p4, v13)
            end

            if v7 == Enum.InfoType.Bundle then
                return MarketplaceService:PromptBundlePurchase(p4, v13)
            end

            if v7 == Enum.InfoType.Product then
                return MarketplaceService:PromptProductPurchase(p4, v13)
            end

            return MarketplaceService:PromptGamePassPurchase(p4, v13)
        end

        local ok, result = pcall(v14)

        return ok, (tostring(result))
    end

    return require(Modules.AssetUtil.promptBulkPurchaseAsync)(v3, p4, if v12 then Enum.MarketplaceProductType.AvatarBundle else Enum.MarketplaceProductType.AvatarAsset)
end
