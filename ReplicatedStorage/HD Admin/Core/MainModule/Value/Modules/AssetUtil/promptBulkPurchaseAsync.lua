-- https://lua.expert

local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")

game:GetService("Players")

local v1 = RunService:IsClient()
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local v2

return function(p1, p2, p3) -- line: 8
    -- upvalues: MarketplaceService (copy), v1 (copy), Modules (copy), v2 (ref)
    if v1 then
        v2 = v2 or require(Modules.Objects.Remote).get("PromptBulkPurchase")

        local v3, v4 = v2:invokeServerAsync(p1)

        return v3, v4
    end

    if typeof(p2) ~= "Instance" and not p2:IsA("Player") then
        return false, "Player must be specified on server"
    end

    local ExpectPurchase = require(Modules.Objects.Remote).find("ExpectPurchase")

    if ExpectPurchase and typeof(p2) == "Instance" and p2:IsA("Player") then
        ExpectPurchase:fireClient(p2, p1)
    end

    local v5 = p3 or Enum.MarketplaceProductType.AvatarAsset

    local function v6() -- line: 25
        -- upvalues: p1 (copy), p2 (copy), v5 (copy), MarketplaceService (copy)
        return MarketplaceService:PromptBulkPurchase(p2, {
            {
                Type = v5,
                Id = tostring(p1)
            }
        }, {})
    end

    local ok, result = pcall(v6)

    return ok, result
end
