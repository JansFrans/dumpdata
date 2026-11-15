-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local UI = Modules.Parent.Controllers.UI
local VERSION = require(UI.Config.VERSION)
local CosmeticMarket = require(UI.Util.CosmeticMarket)
local clientUser = require(Modules.References.clientUser)
local v1 = false

return {
    warm = function() -- warm | line: 16
        -- upvalues: VERSION (copy), CosmeticMarket (copy), clientUser (copy), v1 (ref)
        if v1 then
            return
        end

        v1 = true
        task.spawn(function() -- line: 21
            -- upvalues: VERSION (copy)
            VERSION.getLatestVersion()
        end)
        task.spawn(function() -- line: 24
            -- upvalues: CosmeticMarket (copy), clientUser (copy)
            local SpecialAccessories, SpecialAccessories2 = clientUser.everyone:fetchAsync("SpecialAccessories")

            if not SpecialAccessories or typeof(SpecialAccessories2) ~= "table" then
                return
            end

            local t2 = {}

            for _, v2 in SpecialAccessories2 do
                if typeof(v2) == "table" and v2.id then
                    table.insert(t2, v2)
                end
            end

            table.sort(t2, function(p1, p2) -- line: 36
                local v3 = p1.order or 1e999
                local v4 = p2.order or 1e999

                if v3 ~= v4 then
                    return v3 < v4
                end

                return tostring(p1.name) < tostring(p2.name)
            end)

            for i = 1, math.min(2, #t2) do
                local v7 = t2[i]

                if v7.comingSoon ~= true then
                    CosmeticMarket.seedPrice(v7.id)
                    CosmeticMarket.seedFavourite(v7.id)
                end
            end
        end)
    end
}
