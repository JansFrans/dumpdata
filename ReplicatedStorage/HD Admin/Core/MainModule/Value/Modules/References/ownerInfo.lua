-- https://lua.expert

local CreatorId = game.CreatorId
local t1 = {
    ownerName = "Unknown",
    ownerId = CreatorId
}

if game:GetService("RunService"):IsStudio() and CreatorId == 0 then
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer or Players:GetPlayers()[1] or Players.PlayerAdded:Wait()

    t1.ownerId = LocalPlayer.UserId
    t1.ownerName = LocalPlayer.Name

    return t1
end

if game.CreatorType == Enum.CreatorType.Group then
    local GroupService = game:GetService("GroupService")
    local ok, result

    while true do
        local function v1() -- line: 41
            -- upvalues: GroupService (copy)
            return GroupService:GetGroupInfoAsync(game.CreatorId).Owner
        end

        ok, result = pcall(v1)

        if ok then
            break
        end

        task.wait(1)
    end

    if ok then
        t1.ownerId = result.Id
        t1.ownerName = result.Name
    end
else
    local Players = game:GetService("Players")

    local function v2() -- line: 25
        -- upvalues: CreatorId (copy), Players (copy)
        return Players:GetNameFromUserIdAsync(CreatorId)
    end

    local ok, result = pcall(v2)

    if ok and result then
        t1.ownerName = result
    end
end

return t1
