-- https://lua.expert

local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local v1 = RunService:IsClient()
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local products = require(Modules.References.products)

return function(p1, p2) -- line: 10
    -- upvalues: MarketplaceService (copy), Players (copy), v1 (copy), products (copy)
    local v2 = p2
    local v3

    if typeof(p1) == "number" then
        v3 = p1
    else
        local v4 = products[p1]

        if not v4 then
            return false, (("Invalid product name: %*"):format(p1))
        end

        v3 = v4.id
    end

    local LocalPlayer = p2

    if v1 then
        LocalPlayer = Players.LocalPlayer
        v2 = LocalPlayer
    end

    if typeof(LocalPlayer) ~= "Instance" or not LocalPlayer:IsA("Player") then
        return false, "Player must be specified on server"
    end

    local v5

    for _, v6 in products do
        if v6.id == v3 then
            v5 = v6
            break
        end
    end

    if v5 then
        if v5.infoType == Enum.InfoType.Bundle then
            local v7 = v3

            local function v8() -- line: 34
                -- upvalues: v2 (ref), v7 (copy), MarketplaceService (copy)
                return MarketplaceService:PlayerOwnsBundleAsync(v2, v7)
            end

            return pcall(v8)
        end

        if v5.infoType ~= Enum.InfoType.GamePass and v5.infoType ~= Enum.InfoType.Product then
            local v9 = v3

            local function v10() -- line: 38
                -- upvalues: v2 (ref), v9 (copy), MarketplaceService (copy)
                return MarketplaceService:PlayerOwnsAssetAsync(v2, v9)
            end

            return pcall(v10)
        end
    end

    local function v11() -- line: 43
        -- upvalues: v2 (ref), v3 (ref), MarketplaceService (copy)
        return MarketplaceService:UserOwnsGamePassAsync(v2.UserId, v3)
    end

    return pcall(v11)
end
