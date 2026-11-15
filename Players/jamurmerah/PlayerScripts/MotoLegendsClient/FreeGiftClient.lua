-- https://lua.expert

local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local v1 = require(MotoLegends:WaitForChild("FreeGiftMenu")).New(PlayerGui)
local v2 = MotoLegends:FindFirstChild("OpenFreeGift") or Instance.new("BindableEvent")

v2.Name = "OpenFreeGift"
v2.Parent = MotoLegends

local function riding() -- line: 11
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local v3 = Humanoid and Humanoid.SeatPart

    return v3 ~= nil and v3.Name == "RiderSeat"
end

local function blocked() -- line: 15
    -- upvalues: LocalPlayer (copy), PlayerGui (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local v4 = Humanoid and Humanoid.SeatPart

    if v4 ~= nil and v4.Name == "RiderSeat" then
        return true
    end

    local Character2 = LocalPlayer.Character

    if Character2 and Character2:GetAttribute("RaceCrashActive") == true then
        return true
    end

    local JerezRaceHUD = PlayerGui:FindFirstChild("JerezRaceHUD")

    if JerezRaceHUD == nil then
        return false
    end

    if JerezRaceHUD:GetAttribute("BikesPreviewOpen") == true or JerezRaceHUD:GetAttribute("LegendsOpen") == true then
        return true
    end

    return JerezRaceHUD:GetAttribute("Freecam") == true
end

v2.Event:Connect(function() -- line: 21
    -- upvalues: PlayerGui (copy), MotoLegends (copy), v1 (copy), blocked (copy)
    if v1.IsOpen() then
        v1.Close()
    elseif not blocked() then
        local ShopHUD = PlayerGui:FindFirstChild("ShopHUD")

        if ShopHUD and ShopHUD.Enabled then
            local OpenShop = MotoLegends:FindFirstChild("OpenShop")

            if OpenShop then
                OpenShop:Fire()
            end
        end

        local ProfileHUD = PlayerGui:FindFirstChild("ProfileHUD")

        if ProfileHUD and ProfileHUD.Enabled then
            local CloseProfile = MotoLegends:FindFirstChild("CloseProfile")

            if CloseProfile then
                CloseProfile:Fire()
            end
        end

        v1.Open()
    end
end)

local v5 = MotoLegends:FindFirstChild("CloseMenus") or Instance.new("BindableEvent")

v5.Name = "CloseMenus"
v5.Parent = MotoLegends
v5.Event:Connect(function() -- line: 31
    -- upvalues: v1 (copy)
    if v1.IsOpen() then
        v1.Close()
    end
end)
task.spawn(function() -- line: 33
    -- upvalues: LocalPlayer (copy), v1 (copy)
    while true do
        task.wait(0.25)

        if not v1.IsOpen() then
            continue
        end

        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        local v6 = Humanoid and Humanoid.SeatPart

        if v6 ~= nil and v6.Name == "RiderSeat" then
            v1.Close()
        end
    end
end)
