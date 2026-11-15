-- https://lua.expert

task.defer(function() -- line: 22
    local RunService = game:GetService("RunService")
    local VERSION = require(script.Parent.VERSION)
    local v1 = VERSION.getAppVersion()

    VERSION.getLatestVersion()

    local _ = not VERSION.isUpToDate()

    if not RunService:IsStudio() then
        print((("🍍 Running TopbarPlus %* by @ForeverHD & HD Admin"):format(v1)))
    end
end)
task.defer(function() -- line: 36
    local RunService = game:GetService("RunService")
    local LocalPlayer = game:GetService("Players").LocalPlayer

    if RunService:IsStudio() and LocalPlayer and not (LocalPlayer.UserId <= 0) then
        local BadgeService = game:GetService("BadgeService")
        local UserHasBadgeAsync = BadgeService.UserHasBadgeAsync
        local UserId = LocalPlayer.UserId

        pcall(UserHasBadgeAsync, BadgeService, UserId, 3117667999886969)
    end
end)

return {}
