-- https://lua.expert

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local v1 = require(MotoLegends:WaitForChild("ProfileMenu")).New(PlayerGui)
local v2 = MotoLegends:FindFirstChild("OpenProfile") or Instance.new("BindableEvent")

v2.Name = "OpenProfile"
v2.Parent = MotoLegends

local v3 = MotoLegends:WaitForChild("GetProfile", 60)
local n1 = 0

local function open(p1, p2) -- line: 17
    -- upvalues: Players (copy), LocalPlayer (copy), MotoLegends (copy), v1 (copy), v3 (copy), n1 (ref)
    local v4 = p1

    p1 = p1 or LocalPlayer.UserId
    v4 = p1

    if typeof(p1) ~= "number" then
        return
    end

    local PlayerByUserId = Players:GetPlayerByUserId(p1)
    local _require = require
    local Config = MotoLegends.Config
    local ok, result = pcall(_require, Config)
    local Track = ok and result.Track or nil

    n1 += 1

    local v6 = n1

    if PlayerByUserId then
        v1.Show({
            userId = PlayerByUserId.UserId,
            name = PlayerByUserId.DisplayName,
            pts = PlayerByUserId:GetAttribute("PTS") or 0,
            country = PlayerByUserId:GetAttribute("Country"),
            device = PlayerByUserId:GetAttribute("InputDevice") or "PC",
            legend = PlayerByUserId:GetAttribute("SelectedLegend") or "",
            bike = PlayerByUserId:GetAttribute("BikeName") or "",
            current = Track
        })
    else
        if typeof(p2) ~= "table" then
            return
        end

        v1.Show({
            userId = p1,
            name = p2.name or "Rider",
            pts = p2.pts or 0,
            country = p2.country,
            legend = p2.legend or "",
            bike = p2.bike or "",
            current = Track
        })
    end

    if v3 then
        task.spawn(function() -- line: 33
            -- upvalues: v4 (ref), v6 (copy), v1 (copy), v3 (copy), n1 (ref)
            for _ = 1, 3 do
                local InvokeServer = v3.InvokeServer
                local v7 = v4
                local ok, result = pcall(InvokeServer, v3, v7)

                if v6 ~= n1 or not v1.IsOpen() or v1.UserId() ~= v4 then
                    return
                end

                if ok and typeof(result) == "table" then
                    v1.Show(result, true)

                    if result.loaded then
                        return
                    end
                end

                task.wait(1.5)
            end
        end)
    end
end

v2.Event:Connect(function(p3, p4) -- line: 42
    -- upvalues: open (copy)
    open(p3, p4)
end)

local v8 = MotoLegends:FindFirstChild("CloseProfile") or Instance.new("BindableEvent")

v8.Name = "CloseProfile"
v8.Parent = MotoLegends
v8.Event:Connect(function() -- line: 45
    -- upvalues: v1 (copy)
    if v1.IsOpen() then
        v1.Close()
    end
end)

local v9 = MotoLegends:FindFirstChild("CloseMenus") or Instance.new("BindableEvent")

v9.Name = "CloseMenus"
v9.Parent = MotoLegends
v9.Event:Connect(function() -- line: 48
    -- upvalues: v1 (copy)
    if v1.IsOpen() then
        v1.Close()
    end
end)
task.spawn(function() -- line: 50
    -- upvalues: LocalPlayer (copy), v1 (copy)
    local v10 = false

    while true do
        task.wait(0.25)

        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        local v11 = Humanoid and Humanoid.SeatPart
        local v12 = v11 ~= nil and v11.Name == "RiderSeat"

        if v12 and not v10 and v1.IsOpen() then
            v1.Close()
        end

        v10 = v12
    end
end)

local function riding() -- line: 62
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local v13 = Humanoid and Humanoid.SeatPart

    return v13 ~= nil and v13.Name == "RiderSeat"
end

local function blocked() -- line: 66
    -- upvalues: LocalPlayer (copy), PlayerGui (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local v14 = Humanoid and Humanoid.SeatPart

    if v14 ~= nil and v14.Name == "RiderSeat" then
        return true
    end

    local Character2 = LocalPlayer.Character

    if Character2 and Character2:GetAttribute("RaceCrashActive") == true then
        return true
    end

    local JerezRaceHUD = PlayerGui:FindFirstChild("JerezRaceHUD")

    if JerezRaceHUD and (JerezRaceHUD:GetAttribute("BikesPreviewOpen") == true or JerezRaceHUD:GetAttribute("LegendsOpen") == true or JerezRaceHUD:GetAttribute("Freecam") == true or JerezRaceHUD:GetAttribute("ShopOpen") == true) then
        return true
    end

    local LapTimesBoard = PlayerGui:FindFirstChild("LapTimesBoard")

    return LapTimesBoard and LapTimesBoard.Enabled
end

local function tagAt(p5) -- line: 75
    -- upvalues: Players (copy), LocalPlayer (copy)
    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return nil
    end

    local v15, Z, v16

    for _, player in Players:GetPlayers() do
        if player ~= LocalPlayer then
            local v17 = player.Character and player.Character:FindFirstChild("Head")

            if v17 then
                for _, child in v17:GetChildren() do
                    if child.Name == "RaceNametag" and child:IsA("BillboardGui") and child.Enabled and child.PlayerToHideFrom ~= LocalPlayer then
                        local Panel = child:FindFirstChild("Panel")

                        if Panel and Panel.Visible and Panel.BackgroundTransparency < 0.9 then
                            local Adornee = child.Adornee
                            local v20, v21 = CurrentCamera:WorldToViewportPoint((Adornee and Adornee:IsA("BasePart") and Adornee.Position or v17.Position) + child.StudsOffsetWorldSpace)

                            if v21 and v20.Z > 0 then
                                local Offset = child.Size.X.Offset
                                local Offset2 = child.Size.Y.Offset
                                local v22 = v20.X + child.SizeOffset.X * Offset
                                local v23 = v20.Y - child.SizeOffset.Y * Offset2

                                if math.abs(p5.X - v22) <= Offset / 2 + 4 and math.abs(p5.Y - v23) <= Offset2 / 2 + 4 and (not Z or v20.Z < Z) then
                                    v16 = child
                                    Z = v20.Z
                                    v15 = player
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return v15, v16
end

local function viewportPoint(p6) -- line: 102
    -- upvalues: UserInputService (copy), GuiService (copy)
    if p6.UserInputType ~= Enum.UserInputType.Touch then
        return UserInputService:GetMouseLocation()
    end

    local GuiInset = GuiService:GetGuiInset()

    return Vector2.new(p6.Position.X, p6.Position.Y) + GuiInset
end

local t1

UserInputService.InputBegan:Connect(function(p7, p8) -- line: 109
    -- upvalues: UserInputService (copy), GuiService (copy), t1 (ref)
    if p8 or p7.UserInputType ~= Enum.UserInputType.MouseButton1 and p7.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local t2 = {
        input = p7,
        at = os.clock()
    }

    if p7.UserInputType == Enum.UserInputType.Touch then
        local GuiInset = GuiService:GetGuiInset()

        t2.pos = Vector2.new(p7.Position.X, p7.Position.Y) + GuiInset
    else
        t2.pos = UserInputService:GetMouseLocation()
    end

    t1 = t2
end)
UserInputService.InputEnded:Connect(function(p9) -- line: 114
    -- upvalues: UserInputService (copy), GuiService (copy), open (copy), blocked (copy), tagAt (copy), t1 (ref)
    if not (t1 and (t1.input == p9 or p9.UserInputType == Enum.UserInputType.MouseButton1 and t1.input.UserInputType == Enum.UserInputType.MouseButton1)) then
        return
    end

    local t3 = t1

    t1 = nil

    local v26

    if p9.UserInputType == Enum.UserInputType.Touch then
        local GuiInset = GuiService:GetGuiInset()

        v26 = Vector2.new(p9.Position.X, p9.Position.Y) + GuiInset
    else
        v26 = UserInputService:GetMouseLocation()
    end

    if not (os.clock() - t3.at > 0.45 or (v26 - t3.pos).Magnitude > 14) and not blocked() then
        local v27 = tagAt(v26)

        if v27 then
            open(v27.UserId)
        end
    end
end)

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local v28 = Color3.fromRGB(220, 35, 45)
local v29

local function styleTag(p10, p11) -- line: 132
    -- upvalues: TweenService (copy), v28 (copy)
    local v30 = p10 and p10.Parent and p10:FindFirstChild("Panel")

    if not v30 then
        return
    end

    if v30:GetAttribute("HoverIdleColor") == nil then
        v30:SetAttribute("HoverIdleColor", v30.BackgroundColor3)
    end

    local HoverIdleT = v30:GetAttribute("HoverIdleT")

    if HoverIdleT == nil then
        HoverIdleT = v30:GetAttribute("FadeBase_BackgroundTransparency") or v30.BackgroundTransparency
        v30:SetAttribute("HoverIdleT", HoverIdleT)
    end

    local v32 = if p11 then math.min(HoverIdleT, 0.15) else nil

    if p11 and v32 then
        HoverIdleT = v32
    end

    v30:SetAttribute("FadeBase_BackgroundTransparency", HoverIdleT)
    TweenService:Create(v30, TweenInfo.new(0.15), {
        BackgroundColor3 = p11 and v28 or v30:GetAttribute("HoverIdleColor"),
        BackgroundTransparency = HoverIdleT
    }):Play()

    local PressScale = v30:FindFirstChild("PressScale")

    if PressScale and not p11 then
        TweenService:Create(PressScale, TweenInfo.new(0.12), {
            Scale = v30:GetAttribute("BaseScale") or 1
        }):Play()
    end
end

local function setHover(p12) -- line: 143
    -- upvalues: UserInputService (copy), v29 (ref), styleTag (copy)
    if p12 == v29 then
        return
    end

    if v29 then
        styleTag(v29, false)
    end

    v29 = p12

    if p12 then
        styleTag(p12, true)
    end

    UserInputService.MouseIcon = p12 and "rbxasset://SystemCursors/PointingHand" or ""
end

RunService.RenderStepped:Connect(function() -- line: 151
    -- upvalues: UserInputService (copy), blocked (copy), tagAt (copy), v29 (ref), styleTag (copy)
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        return
    end

    local v34

    if not blocked() then
        local v35

        v35, v34 = tagAt(UserInputService:GetMouseLocation())
    end

    if v34 ~= v29 then
        if v29 then
            styleTag(v29, false)
        end

        v29 = v34

        if v34 then
            styleTag(v34, true)
        end

        UserInputService.MouseIcon = v34 and "rbxasset://SystemCursors/PointingHand" or ""
    end
end)

local function pressScale(p13) -- line: 158
    local Panel = p13 and p13:FindFirstChild("Panel")

    if not Panel then
        return
    end

    if Panel.AnchorPoint ~= Vector2.new(0.5, 0.5) then
        Panel.AnchorPoint = Vector2.new(0.5, 0.5)
        Panel.Position = UDim2.fromScale(0.5, 0.5)
    end

    local v36 = Panel:FindFirstChild("PressScale") or Instance.new("UIScale")

    v36.Name = "PressScale"
    v36.Parent = Panel

    return v36
end

local v37

UserInputService.InputBegan:Connect(function(p14, p15) -- line: 168
    -- upvalues: blocked (copy), tagAt (copy), viewportPoint (copy), TweenService (copy), v29 (ref), styleTag (copy), pressScale (copy), v37 (ref)
    if p15 then
        return
    end

    local UserInputType = p14.UserInputType

    if UserInputType ~= Enum.UserInputType.MouseButton1 or not v29 then
        if UserInputType == Enum.UserInputType.Touch and not blocked() then
            local _, v38 = tagAt(viewportPoint(p14))

            if v38 then
                v37 = v38
                styleTag(v38, true)

                local v39 = pressScale(v38)

                if v39 then
                    TweenService:Create(v39, TweenInfo.new(0.08), {
                        Scale = (v39.Parent:GetAttribute("BaseScale") or 1) * 0.94
                    }):Play()
                end
            end
        end
    else
        local v40 = pressScale(v29)

        if v40 then
            TweenService:Create(v40, TweenInfo.new(0.08), {
                Scale = (v40.Parent:GetAttribute("BaseScale") or 1) * 0.94
            }):Play()
        end
    end
end)
UserInputService.InputEnded:Connect(function(p16) -- line: 181
    -- upvalues: TweenService (copy), v29 (ref), styleTag (copy), pressScale (copy), v37 (ref)
    local UserInputType = p16.UserInputType

    if UserInputType ~= Enum.UserInputType.MouseButton1 or not v29 then
        if UserInputType == Enum.UserInputType.Touch and v37 then
            local v41 = v37

            v37 = nil

            local v42 = pressScale(v41)

            if v42 then
                TweenService:Create(v42, TweenInfo.new(0.16, Enum.EasingStyle.Back), {
                    Scale = v42.Parent:GetAttribute("BaseScale") or 1
                }):Play()
            end

            task.delay(0.15, function() -- line: 188
                -- upvalues: v41 (copy), v29 (ref), styleTag (copy), v37 (ref)
                if v41 ~= v29 and v41 ~= v37 then
                    styleTag(v41, false)
                end
            end)
        end
    else
        local v43 = pressScale(v29)

        if v43 then
            TweenService:Create(v43, TweenInfo.new(0.16, Enum.EasingStyle.Back), {
                Scale = v43.Parent:GetAttribute("BaseScale") or 1
            }):Play()
        end
    end
end)
