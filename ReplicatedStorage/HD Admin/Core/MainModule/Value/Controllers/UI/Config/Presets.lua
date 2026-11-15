-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local ownerInfo = require(Modules.References.ownerInfo)

return {
    users = {
        Creator = {
            label = "Creator",
            description = "Game/group owner",
            icon = "rbxassetid://107202584692517",
            resolveUserIds = function() -- resolveUserIds | line: 34
                -- upvalues: ownerInfo (copy)
                local t4 = {
                    ownerInfo.ownerId
                }

                if game:GetService("RunService"):IsStudio() then
                    for _, player in game:GetService("Players"):GetPlayers() do
                        if player.UserId < 0 then
                            table.insert(t4, player.UserId)
                        end
                    end
                end

                return t4
            end
        },
        FriendsOfCreator = {
            label = "Friends of Creator",
            icon = "rbxassetid://107202584692517",
            resolveUserIds = function() -- resolveUserIds | line: 52
                -- upvalues: ownerInfo (copy)
                local Players = game:GetService("Players")
                local t6 = {}

                local function v1() -- line: 55
                    -- upvalues: Players (copy), ownerInfo (copy)
                    return Players:GetFriendsAsync(ownerInfo.ownerId)
                end

                local ok, result = pcall(v1)

                if ok and result then
                    while true do
                        for _, v2 in result:GetCurrentPage() do
                            if typeof(v2) == "table" and typeof(v2.Id) == "number" then
                                table.insert(t6, v2.Id)
                            end
                        end

                        if result.IsFinished then
                            break
                        end

                        local function v3() -- line: 66
                            -- upvalues: result (copy)
                            result:AdvanceToNextPageAsync()
                        end

                        pcall(v3)
                    end

                    return t6
                end

                return t6
            end
        }
    },
    products = {}
}
