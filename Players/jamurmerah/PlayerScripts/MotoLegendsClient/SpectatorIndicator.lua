-- https://lua.expert

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local SpectateTarget = MotoLegends:WaitForChild("SpectateTarget")
local JerezRaceHUD = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("JerezRaceHUD")
local Frame = Instance.new("Frame")

Frame.Name = "ViewerIndicator"
Frame.AnchorPoint = Vector2.new(0.5, 1)
Frame.Position = UDim2.new(0.5, 0, 1, -12)
Frame.Size = UDim2.fromOffset(74, 24)
Frame.BackgroundColor3 = Color3.fromRGB(14, 19, 24)
Frame.BackgroundTransparency = 0.25
Frame.BorderSizePixel = 0
Frame.ZIndex = 50
Frame.Parent = JerezRaceHUD
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local ImageLabel = Instance.new("ImageLabel")

ImageLabel.Name = "Eye"
ImageLabel.BackgroundTransparency = 1
ImageLabel.Position = UDim2.fromOffset(8, 0)
ImageLabel.Size = UDim2.fromOffset(26, 24)
ImageLabel.ZIndex = 51
ImageLabel.Parent = Frame

local eye = require(MotoLegends:WaitForChild("RaceIcons")).Get("eye")

if eye then
    ImageLabel.ImageContent = eye
else
    local Frame = Instance.new("Frame")

    Frame.Name = "EyeOutline"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromOffset(22, 12)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 51
    Frame.Parent = ImageLabel
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(1, 0)

    local UIStroke = Instance.new("UIStroke", Frame)

    UIStroke.Color = Color3.new(1, 1, 1)
    UIStroke.Thickness = 1.5

    local Frame2 = Instance.new("Frame")

    Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame2.Position = UDim2.fromScale(0.5, 0.5)
    Frame2.Size = UDim2.fromOffset(6, 6)
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame2.BorderSizePixel = 0
    Frame2.ZIndex = 51
    Frame2.Parent = Frame
    Instance.new("UICorner", Frame2).CornerRadius = UDim.new(1, 0)
end

local TextLabel = Instance.new("TextLabel")

TextLabel.Name = "Count"
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.fromOffset(38, 0)
TextLabel.Size = UDim2.fromOffset(28, 24)
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 14
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.ZIndex = 51
TextLabel.Parent = Frame

local function watched() -- line: 19
    -- upvalues: Players (copy), LocalPlayer (copy), JerezRaceHUD (copy)
    if not JerezRaceHUD:GetAttribute("LobbySpectating") then
        return LocalPlayer
    end

    local SpectateTargetId = JerezRaceHUD:GetAttribute("SpectateTargetId")

    return typeof(SpectateTargetId) == "number" and Players:GetPlayerByUserId(SpectateTargetId) or nil
end

local n1 = 0

local function updateCount() -- line: 25
    -- upvalues: Players (copy), LocalPlayer (copy), JerezRaceHUD (copy), Frame (copy), TextLabel (copy), n1 (ref)
    local PlayerByUserId

    if JerezRaceHUD:GetAttribute("LobbySpectating") then
        local SpectateTargetId = JerezRaceHUD:GetAttribute("SpectateTargetId")

        PlayerByUserId = typeof(SpectateTargetId) == "number" and Players:GetPlayerByUserId(SpectateTargetId) or nil
    else
        PlayerByUserId = LocalPlayer
    end

    local SpectatorCount = PlayerByUserId and PlayerByUserId:GetAttribute("SpectatorCount") or 0

    TextLabel.Text = tostring(SpectatorCount)
    Frame.Visible = SpectatorCount > 0
    n1 = SpectatorCount
end

local connection

local function rewatch() -- line: 30
    -- upvalues: Players (copy), LocalPlayer (copy), JerezRaceHUD (copy), Frame (copy), TextLabel (copy), n1 (ref), updateCount (copy), connection (ref)
    if connection then
        connection:Disconnect()
        connection = nil
    end

    local PlayerByUserId

    if JerezRaceHUD:GetAttribute("LobbySpectating") then
        local SpectateTargetId = JerezRaceHUD:GetAttribute("SpectateTargetId")

        PlayerByUserId = typeof(SpectateTargetId) == "number" and Players:GetPlayerByUserId(SpectateTargetId) or nil
    else
        PlayerByUserId = LocalPlayer
    end

    if PlayerByUserId then
        connection = PlayerByUserId:GetAttributeChangedSignal("SpectatorCount"):Connect(updateCount)
    end

    local PlayerByUserId2

    if JerezRaceHUD:GetAttribute("LobbySpectating") then
        local SpectateTargetId = JerezRaceHUD:GetAttribute("SpectateTargetId")

        PlayerByUserId2 = typeof(SpectateTargetId) == "number" and Players:GetPlayerByUserId(SpectateTargetId) or nil
    else
        PlayerByUserId2 = LocalPlayer
    end

    local SpectatorCount = PlayerByUserId2 and PlayerByUserId2:GetAttribute("SpectatorCount") or 0

    TextLabel.Text = tostring(SpectatorCount)
    Frame.Visible = SpectatorCount > 0
    n1 = SpectatorCount
end

JerezRaceHUD:GetAttributeChangedSignal("LobbySpectating"):Connect(rewatch)
JerezRaceHUD:GetAttributeChangedSignal("SpectateTargetId"):Connect(rewatch)

if connection then
    connection:Disconnect()
    connection = nil
end

local PlayerByUserId

if JerezRaceHUD:GetAttribute("LobbySpectating") then
    local SpectateTargetId = JerezRaceHUD:GetAttribute("SpectateTargetId")

    PlayerByUserId = typeof(SpectateTargetId) == "number" and Players:GetPlayerByUserId(SpectateTargetId) or nil
else
    PlayerByUserId = LocalPlayer
end

if PlayerByUserId then
    connection = PlayerByUserId:GetAttributeChangedSignal("SpectatorCount"):Connect(updateCount)
end

local PlayerByUserId2

if JerezRaceHUD:GetAttribute("LobbySpectating") then
    local SpectateTargetId = JerezRaceHUD:GetAttribute("SpectateTargetId")

    PlayerByUserId2 = typeof(SpectateTargetId) == "number" and Players:GetPlayerByUserId(SpectateTargetId) or nil
else
    PlayerByUserId2 = LocalPlayer
end

local SpectatorCount = PlayerByUserId2 and PlayerByUserId2:GetAttribute("SpectatorCount") or 0

TextLabel.Text = tostring(SpectatorCount)
Frame.Visible = SpectatorCount > 0
n1 = SpectatorCount
game:GetService("RunService").RenderStepped:Connect(function() -- line: 39
    -- upvalues: LocalPlayer (copy), JerezRaceHUD (copy), Frame (copy), n1 (ref)
    if n1 <= 0 and Frame.Visible then
        Frame.Visible = false
    end

    local RaceLobbyHUD = JerezRaceHUD.Parent:FindFirstChild("RaceLobbyHUD")
    local v6 = JerezRaceHUD:GetAttribute("LobbySpectating") and RaceLobbyHUD and RaceLobbyHUD:FindFirstChild("CameraMode", true)

    if v6 and v6:IsA("GuiObject") and v6.AbsoluteSize.X > 0 then
        local v7 = v6.AbsolutePosition - JerezRaceHUD.AbsolutePosition

        Frame.Position = UDim2.fromOffset(v7.X + v6.AbsoluteSize.X / 2, v7.Y - 8)
    else
        local Character = LocalPlayer.Character
        local v8 = Character and Character:FindFirstChildOfClass("Humanoid")

        v8 = v8 and v8.SeatPart and v8.SeatPart.Name == "RiderSeat"

        local BottomNavigation = RaceLobbyHUD and RaceLobbyHUD:FindFirstChild("BottomNavigation")

        if not v8 and BottomNavigation and BottomNavigation.Visible then
            local n2 = 1e999

            for _, child in BottomNavigation:GetChildren() do
                if child:IsA("GuiButton") and child.Visible then
                    n2 = math.min(n2, child.AbsolutePosition.Y)

                    local Icon = child:FindFirstChild("Icon")

                    if Icon then
                        n2 = math.min(n2, Icon.AbsolutePosition.Y)
                    end
                end
            end

            local v9 = workspace.CurrentCamera.ViewportSize.Y / 360

            Frame.Position = n2 < 1e999 and UDim2.fromOffset(JerezRaceHUD.AbsoluteSize.X / 2, n2 - JerezRaceHUD.AbsolutePosition.Y - 10 * v9) or UDim2.new(0.5, 0, 1, -12)
        else
            Frame.Position = UDim2.new(0.5, 0, 1, -12)
        end
    end
end)

local v11 = false
local SpectateTargetId

local function report() -- line: 67
    -- upvalues: SpectateTarget (copy), JerezRaceHUD (copy), v11 (ref), SpectateTargetId (ref)
    if not v11 then
        v11 = true
        task.defer(function() -- line: 69
            -- upvalues: SpectateTarget (copy), JerezRaceHUD (copy), v11 (ref), SpectateTargetId (ref)
            v11 = false

            local SpectateTargetId2 = JerezRaceHUD:GetAttribute("LobbySpectating") and JerezRaceHUD:GetAttribute("SpectateTargetId") or 0

            if typeof(SpectateTargetId2) ~= "number" or not SpectateTargetId2 then
                SpectateTargetId2 = 0
            end

            if SpectateTargetId2 == SpectateTargetId then
                return
            end

            SpectateTargetId = SpectateTargetId2
            SpectateTarget:FireServer(SpectateTargetId2)
        end)
    end
end

JerezRaceHUD:GetAttributeChangedSignal("LobbySpectating"):Connect(report)
JerezRaceHUD:GetAttributeChangedSignal("SpectateTargetId"):Connect(report)

if not v11 then
    v11 = true
    task.defer(function() -- line: 69
        -- upvalues: SpectateTarget (copy), JerezRaceHUD (copy), v11 (ref), SpectateTargetId (ref)
        v11 = false

        local SpectateTargetId2 = JerezRaceHUD:GetAttribute("LobbySpectating") and JerezRaceHUD:GetAttribute("SpectateTargetId") or 0

        if typeof(SpectateTargetId2) ~= "number" or not SpectateTargetId2 then
            SpectateTargetId2 = 0
        end

        if SpectateTargetId2 == SpectateTargetId then
            return
        end

        SpectateTargetId = SpectateTargetId2
        SpectateTarget:FireServer(SpectateTargetId2)
    end)
end

task.defer(updateCount)
