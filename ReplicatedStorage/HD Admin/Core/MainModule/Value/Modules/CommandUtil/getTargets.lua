-- https://lua.expert

local Players = game:GetService("Players")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules

return function(p1, p2, p3) -- line: 5
    -- upvalues: Players (copy), Modules (copy)
    local t1 = {}

    if p1 == "All" then
        return (Players:GetPlayers())
    end

    if p1 == "Nearby" or p1 == "OthersNearby" then
        local v1 = p3 or 50
        local v2 = require(Modules.PlayerUtil.getHRP)(p2)
        local v3 = v2 and v2.Position

        if v3 then
            for _, player in Players:GetPlayers() do
                if (p1 ~= "OthersNearby" or player ~= p2) and player:DistanceFromCharacter(v3) <= v1 then
                    table.insert(t1, player)
                end
            end

            return t1
        end
    elseif p1 == "Others" then
        for _, player in Players:GetPlayers() do
            if player ~= p2 then
                table.insert(t1, player)
            end
        end
    end

    return t1
end
