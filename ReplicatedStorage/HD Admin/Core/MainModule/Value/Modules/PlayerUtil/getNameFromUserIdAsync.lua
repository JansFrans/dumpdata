-- https://lua.expert

local Players = game:GetService("Players")
local t1 = {}

return function(p1) -- line: 4
    -- upvalues: Players (copy), t1 (copy)
    local v1 = tonumber(p1)

    if not v1 then
        return false, "Invalid UserId"
    end

    for _, player in Players:GetPlayers() do
        if player.UserId == v1 then
            t1[v1] = player.Name

            return true, player.Name
        end
    end

    local v2 = t1[v1]

    if v2 then
        return true, v2
    end

    local function v3() -- line: 19
        -- upvalues: v1 (copy), Players (copy)
        return Players:GetNameFromUserIdAsync(v1)
    end

    local ok, result = pcall(v3)

    if not ok or typeof(result) ~= "string" then
        return false, (tostring(result))
    end

    t1[v1] = result

    return true, result
end
