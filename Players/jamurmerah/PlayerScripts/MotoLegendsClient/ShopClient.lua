-- https://lua.expert

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local ShopCatalog = require(MotoLegends:WaitForChild("ShopCatalog"))
local v1 = require(MotoLegends:WaitForChild("ShopMenu")).New(PlayerGui)
local v2 = MotoLegends:FindFirstChild("OpenShop") or Instance.new("BindableEvent")

v2.Name = "OpenShop"
v2.Parent = MotoLegends

local function riding() -- line: 12
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local v3 = Humanoid and Humanoid.SeatPart

    return v3 ~= nil and v3.Name == "RiderSeat"
end

local function blocked() -- line: 16
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

v2.Event:Connect(function() -- line: 22
    -- upvalues: PlayerGui (copy), MotoLegends (copy), v1 (copy), blocked (copy)
    if blocked() then
        return
    end

    local ProfileHUD = PlayerGui:FindFirstChild("ProfileHUD")

    if ProfileHUD and ProfileHUD.Enabled then
        local CloseProfile = MotoLegends:FindFirstChild("CloseProfile")

        if CloseProfile then
            CloseProfile:Fire()
        end
    end

    if v1.IsOpen() then
        v1.Close()
    else
        v1.Open()
    end
end)

local v5 = MotoLegends:FindFirstChild("CloseMenus") or Instance.new("BindableEvent")

v5.Name = "CloseMenus"
v5.Parent = MotoLegends
v5.Event:Connect(function() -- line: 30
    -- upvalues: v1 (copy)
    if v1.IsOpen() then
        v1.Close()
    end
end)
task.spawn(function() -- line: 32
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

local v7 = MotoLegends:WaitForChild("ShopEvent", 60)

if v7 then
    v7.OnClientEvent:Connect(function(p1, p2) -- line: 42
        -- upvalues: ShopCatalog (copy), v1 (copy)
        local v8 = if typeof(p2) ~= "table" or not p2 then {} else p2

        if p1 == "Purchased" then
            if v8.kind == "Vip" then
                v1.Toast("VIP ACTIVATED · +" .. ShopCatalog.Vip.Days .. " DAYS · +" .. ShopCatalog.Money(ShopCatalog.Vip.Instant))
            elseif v8.kind == "Support" then
                v1.Toast("THANK YOU FOR SUPPORTING THE GAME!")
            elseif v8.kind == "RaceDirector" then
                if v8.id == "RD2" then
                    v1.Toast("RACE DIRECTOR 2 UNLOCKED · YOURS FOREVER · SAFETY CAR + NEW NAMETAG")
                else
                    v1.Toast("RACE DIRECTOR 1 ACTIVATED · +" .. ShopCatalog.RaceDirector.Tier1.Days .. " DAYS · NEW NAMETAG")
                end
            else
                v1.Toast((v8.item or "ITEM") .. (v8.kind == "Bottle" and " UNLOCKED" or " ADDED"))
            end
        elseif p1 == "VipDaily" then
            v1.Toast("VIP DAILY REWARD · +" .. ShopCatalog.Money(tonumber(v8.amount) or ShopCatalog.Vip.Daily))
        elseif p1 == "GiftSent" then
            v1.Toast("GIFT SENT TO " .. tostring(v8.target or ""))
        elseif p1 == "GiftReceived" then
            v1.Toast(tostring(v8.from or "SOMEONE") .. " GIFTED YOU " .. tostring(v8.item or ""))
        end
    end)
end

local LocalPlayer2 = game:GetService("Players").LocalPlayer
local RobuxDonated = LocalPlayer2:GetAttribute("RobuxDonated")

LocalPlayer2:GetAttributeChangedSignal("RobuxDonated"):Connect(function() -- line: 65
    -- upvalues: ShopCatalog (copy), v1 (copy), LocalPlayer2 (copy), RobuxDonated (ref)
    local v13 = tonumber(LocalPlayer2:GetAttribute("RobuxDonated")) or 0
    local RobuxDonated2 = RobuxDonated

    RobuxDonated = v13

    if RobuxDonated2 ~= nil then
        for _, v14 in ShopCatalog.SupportTiers or {} do
            if RobuxDonated2 < v14.robux and v14.robux <= v13 then
                task.delay(3.2, function() -- line: 70
                    -- upvalues: v14 (copy), v1 (copy)
                    v1.Toast("NEW NAMETAG UNLOCKED · " .. v14.name .. " · EQUIP IT IN CUSTOMIZATION")
                end)
            end
        end
    end
end)

local function esc(p3) -- line: 76
    return (tostring(p3 or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local t1 = {}

for v16, v17 in ShopCatalog.Bottles do
    t1[v17.Name] = if v16 == "Pink" then "#FF78C8" elseif v16 == "Golden" then "#FFD23C" else "#78C8FF"
end

local function itemColor(p4) -- line: 79
    -- upvalues: t1 (copy)
    if t1[p4] then
        return t1[p4]
    end

    if tostring(p4):find("CASH") then
        return "#50E682"
    end

    if tostring(p4):find("VIP") then
        return "#C89BFF"
    end

    return "#FF4B5C"
end

local v19

local function general() -- line: 86
    -- upvalues: TextChatService (copy), v19 (ref)
    if not (v19 and v19.Parent) then
        local v20 = TextChatService:FindFirstChild("TextChannels") or TextChatService:WaitForChild("TextChannels", 10)

        v19 = v20 and (v20:FindFirstChild("RBXGeneral") or v20:WaitForChild("RBXGeneral", 10))
    end

    return v19
end

local v21
local t2 = {
    RBXGeneral = true,
    RBXSystem = true
}

local function isCandidate(p5) -- line: 101
    -- upvalues: t2 (copy)
    if p5 and p5:IsA("TextChannel") and not t2[p5.Name] then
        local v23 = p5.Name:lower()
        local v22 = v23:find("^rbxteam") or v23:find("^rbxwhisper")

        return not v22
    end

    return false
end

local function global() -- line: 106
    -- upvalues: TextChatService (copy), v21 (ref), isCandidate (copy)
    if v21 and v21.Parent then
        return v21
    end

    v21 = nil

    for _, descendant in TextChatService:GetDescendants() do
        if isCandidate(descendant) and (descendant.Name:lower():find("global") or descendant.Name:lower():find("cross")) then
            v21 = descendant
            break
        end
    end

    return v21
end

TextChatService.DescendantAdded:Connect(function(p6) -- line: 114
    -- upvalues: v21 (ref), isCandidate (copy)
    if not v21 and isCandidate(p6) and (p6.Name:lower():find("global") or p6.Name:lower():find("cross")) then
        v21 = p6
    end
end)

local function v24() -- line: 117
    -- upvalues: TextChatService (copy), v21 (ref), isCandidate (copy)
    TextChatService.MessageReceived:Connect(function(p7) -- line: 118
        -- upvalues: v21 (ref), isCandidate (copy)
        local TextChannel = p7.TextChannel

        if isCandidate(TextChannel) and p7.TextSource ~= nil then
            v21 = TextChannel
        end
    end)
end

pcall(v24)

local v25 = MotoLegends:WaitForChild("ShopAnnounce", 60)

if v25 then
    v25.OnClientEvent:Connect(function(p8) -- line: 125
        -- upvalues: general (copy), global (copy)
        if typeof(p8) ~= "table" then
            return
        end

        local function who(p9, p10) -- line: 128
            return string.format("<font color=\"#5AD2FF\">@%s</font>", (tostring(p9 or p10 or "?" or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")))
        end

        local v28 = string.format("<font color=\"#FFC93C\">%s</font>", (tostring(p8.item or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")))
        local v29 = tonumber(p8.price)
        local v30 = v29 and string.format(" for <font color=\"#00E05A\"> %d</font>", v29) or ""
        local v31

        if p8.kind == "support" then
            local format = string.format
            local user, buyer = p8.user, p8.buyer

            v31 = format("%s supported the game with <font color=\"#00E05A\"> %s</font>! Thank you! <font color=\"#FF4B5C\">❤</font>", string.format("<font color=\"#5AD2FF\">@%s</font>", (tostring(user or buyer or "?" or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))), (tostring(v29 or "?")))
        elseif p8.kind == "gift" then
            local format = string.format
            local user, buyer = p8.user, p8.buyer
            local v36 = string.format("<font color=\"#5AD2FF\">@%s</font>", (tostring(user or buyer or "?" or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")))
            local targetUser, target = p8.targetUser, p8.target

            v31 = format("%s gifted %s to %s%s", v36, v28, string.format("<font color=\"#5AD2FF\">@%s</font>", (tostring(targetUser or target or "?" or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))), v30)
        else
            local format = string.format
            local user, buyer = p8.user, p8.buyer

            v31 = format("%s just purchased %s%s", string.format("<font color=\"#5AD2FF\">@%s</font>", (tostring(user or buyer or "?" or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))), v28, v30)
        end

        local v39 = p8.job == nil or p8.job == game.JobId

        if v39 then
            local v40 = general()

            if v40 then
                local DisplaySystemMessage = v40.DisplaySystemMessage

                pcall(DisplaySystemMessage, v40, v31)
            end
        end

        local v41 = global()
        local v42 = false

        if v41 then
            local DisplaySystemMessage = v41.DisplaySystemMessage

            v42 = pcall(DisplaySystemMessage, v41, v31)
        end

        if not v42 and not v39 then
            local v43 = general()

            if v43 then
                local DisplaySystemMessage = v43.DisplaySystemMessage
                local v44 = "<font color=\"#B4BEC8\">[GLOBAL]</font> " .. v31

                pcall(DisplaySystemMessage, v43, v44)
            end
        end
    end)
end
