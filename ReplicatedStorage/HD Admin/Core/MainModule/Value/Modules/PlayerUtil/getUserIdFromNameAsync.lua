-- https://lua.expert

return function(p1) -- line: 1
    local Players = game:GetService("Players")

    for _, player in Players:GetPlayers() do
        if player.Name:lower() == p1:lower() then
            return true, player.UserId
        end
    end

    local function v1() -- line: 8
        -- upvalues: p1 (copy), Players (copy)
        return Players:GetUserIdFromNameAsync(p1)
    end

    local ok, result = pcall(v1)

    return ok, result
end
