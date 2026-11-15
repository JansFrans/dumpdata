-- https://lua.expert

local MarketplaceService = game:GetService("MarketplaceService")
local AvatarEditorService = game:GetService("AvatarEditorService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local Fusion = require(Packages.Fusion)
local Prompt = require(Modules.Prompt)
local promptPurchaseAsync = require(Modules.AssetUtil.promptPurchaseAsync)
local promptSetFavoriteAsync = require(Modules.AssetUtil.promptSetFavoriteAsync)
local t1 = {}
local t2 = {}

return {
    peekPrice = function(p1) -- peekPrice | line: 21
        -- upvalues: t1 (copy)
        return t1[p1] or 0
    end,
    peekFavourite = function(p2) -- peekFavourite | line: 25
        -- upvalues: t2 (copy)
        return t2[p2] or false
    end,
    buy = function(p3) -- buy | line: 29
        -- upvalues: Prompt (copy), promptPurchaseAsync (copy)
        task.spawn(function() -- line: 30
            -- upvalues: p3 (copy), Prompt (copy), promptPurchaseAsync (copy)
            local v1, v2 = promptPurchaseAsync(p3)

            if not v1 and typeof(v2) == "string" and v2 ~= "" then
                Prompt.warn(v2)
            end
        end)
    end,
    notifyComingSoon = function() -- notifyComingSoon | line: 38
        -- upvalues: Prompt (copy)
        Prompt.info("Coming soon. Please try again later.")
    end,
    seedFavourite = function(p4, p5) -- seedFavourite | line: 42
        -- upvalues: AvatarEditorService (copy), t2 (copy)
        if t2[p4] ~= nil then
            if p5 then
                p5:set(t2[p4])
            end
        else
            task.spawn(function() -- line: 49
                -- upvalues: p4 (copy), p5 (copy), AvatarEditorService (copy), t2 (copy)
                local function v3() -- line: 50
                    -- upvalues: p4 (copy), AvatarEditorService (copy)
                    return AvatarEditorService:GetFavorite(p4, Enum.AvatarItemType.Asset)
                end

                local ok, result = pcall(v3)

                if ok and t2[p4] == nil then
                    t2[p4] = result == true

                    if p5 then
                        p5:set(result == true)
                    end
                end
            end)
        end
    end,
    toggleFavourite = function(p6, p7) -- toggleFavourite | line: 64
        -- upvalues: Fusion (copy), promptSetFavoriteAsync (copy), t2 (copy)
        local v6 = not Fusion.peek(p7)

        if promptSetFavoriteAsync(p6, v6) then
            t2[p6] = v6
            p7:set(v6)
        end
    end,
    seedPrice = function(p8, p9) -- seedPrice | line: 73
        -- upvalues: MarketplaceService (copy), t1 (copy)
        if t1[p8] ~= nil then
            if p9 then
                p9:set(t1[p8])
            end
        else
            task.spawn(function() -- line: 80
                -- upvalues: p8 (copy), p9 (copy), MarketplaceService (copy), t1 (copy)
                local function v7() -- line: 81
                    -- upvalues: p8 (copy), MarketplaceService (copy)
                    return MarketplaceService:GetProductInfo(p8, Enum.InfoType.Asset)
                end

                local ok, result = pcall(v7)

                if ok and typeof(result) == "table" then
                    local v8 = result.PriceInRobux or 0

                    t1[p8] = v8

                    if p9 then
                        p9:set(v8)
                    end
                end
            end)
        end
    end
}
