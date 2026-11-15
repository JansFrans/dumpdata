-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local JerezRaceHUD = PlayerGui:WaitForChild("JerezRaceHUD")
local t1 = {
    IdleSeconds = 7.5,
    FadeOut = 0.45,
    FadeIn = 0.25,
    ToggleKey = Enum.KeyCode.H,
    Keep = {
        ChampionshipHUD = true,
        SpectateTimingCardsHUD = true,
        SpectateHudLogo = true,
        SpectateSpeedoHUD = true,
        CrashFeedHUD = true,
        TouchGui = true,
        FreecamHUD = true,
        Freecam = true,
        WeatherVote = true,
        LapTimesBoard = true,
        LapTimesBackdrop = true,
        SessionTimerHUD = true,
        FlagBannerHUD = true,
        ScreenDropletsHUD = true
    },
    KeepChildren = {
        JerezRaceHUD = {
            RaceMinimap = true,
            LapLeaderboard = true,
            LapTimer = true,
            LapAnchor = true,
            TimingAnchor = true
        }
    }
}
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "SpectateHudLogo"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 14
ScreenGui.Enabled = false
ScreenGui.Parent = PlayerGui

local CanvasGroup = Instance.new("CanvasGroup")

CanvasGroup.Name = "Logo"
CanvasGroup.AnchorPoint = Vector2.new(1, 1)
CanvasGroup.BackgroundColor3 = Color3.fromRGB(8, 9, 13)
CanvasGroup.BackgroundTransparency = 0.15
CanvasGroup.BorderSizePixel = 0
CanvasGroup.Size = UDim2.fromOffset(112, 40)
CanvasGroup.GroupTransparency = 1
CanvasGroup.Parent = ScreenGui

local UIScale = Instance.new("UIScale")

UIScale.Parent = CanvasGroup

local TextLabel = Instance.new("TextLabel")

TextLabel.Name = "Brand"
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.fromOffset(8, 3)
TextLabel.Size = UDim2.fromOffset(96, 18)
TextLabel.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Italic)
TextLabel.TextSize = 14
TextLabel.TextColor3 = Color3.fromRGB(245, 245, 247)
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.AutoLocalize = false
TextLabel.Text = "MotoLegends"
TextLabel.Parent = CanvasGroup

local Frame = Instance.new("Frame")

Frame.Name = "Rule"
Frame.BorderSizePixel = 0
Frame.BackgroundColor3 = Color3.fromRGB(231, 0, 0)
Frame.Position = UDim2.fromOffset(8, 23)
Frame.Size = UDim2.fromOffset(96, 2)
Frame.Parent = CanvasGroup
TextLabel.Position = UDim2.fromOffset(8, 8)
Frame.Position = UDim2.fromOffset(8, 28)
task.spawn(function() -- line: 54
    -- upvalues: CanvasGroup (copy), TextLabel (copy), Frame (copy)
    local function v1() -- line: 55
        return require(game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends"):WaitForChild("UIArt")).Get("MotoLegendsLogo")
    end

    local ok, result = pcall(v1)

    if not ok or not result then
        return
    end

    local function art(p1, p2, p3, p4) -- line: 60
        -- upvalues: result (copy), CanvasGroup (copy)
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = p1
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.BorderSizePixel = 0
        ImageLabel.Size = UDim2.fromScale(1, 1)
        ImageLabel.Position = UDim2.fromOffset(p4, p4)
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.ImageColor3 = p2
        ImageLabel.ImageTransparency = p3
        ImageLabel.ImageContent = result
        ImageLabel.Parent = CanvasGroup

        return ImageLabel
    end

    art("LogoShadow", Color3.new(0, 0, 0), 0.45, 1.5)
    art("LogoArt", Color3.new(1, 1, 1), 0, 0)
    TextLabel.Visible = false
    Frame.Visible = false
    CanvasGroup.BackgroundTransparency = 1
end)

local function placeLogo() -- line: 70
    -- upvalues: PlayerGui (copy), CanvasGroup (copy), UIScale (copy)
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local ChampionshipHUD = PlayerGui:FindFirstChild("ChampionshipHUD")
    local HudScale = if ChampionshipHUD then ChampionshipHUD:GetAttribute("HudScale") else nil

    if not ChampionshipHUD or not HudScale then
        HudScale = math.clamp(math.min(ViewportSize.X / 960, ViewportSize.Y / 540), 0.55, 1.5)
    end

    UIScale.Scale = HudScale * 0.85
    CanvasGroup.Position = UDim2.fromOffset(ViewportSize.X - 14 * HudScale, ViewportSize.Y - 12 * HudScale)
end

local function props(p5) -- line: 81
    if p5:IsA("CanvasGroup") then
        return { "GroupTransparency" }
    end

    local t2 = {}

    if p5:IsA("GuiObject") then
        t2[#t2 + 1] = "BackgroundTransparency"
    end

    if p5:IsA("TextLabel") or p5:IsA("TextButton") or p5:IsA("TextBox") then
        t2[#t2 + 1] = "TextTransparency"
        t2[#t2 + 1] = "TextStrokeTransparency"
    end

    if p5:IsA("ImageLabel") or p5:IsA("ImageButton") or p5:IsA("ViewportFrame") then
        t2[#t2 + 1] = "ImageTransparency"
    end

    if p5:IsA("ScrollingFrame") then
        t2[#t2 + 1] = "ScrollBarImageTransparency"
    end

    if p5:IsA("UIStroke") then
        t2[#t2 + 1] = "Transparency"
    end

    if p5:IsA("Path2D") then
        t2[#t2 + 1] = "Transparency"
    end

    return t2
end

local t3 = {}

local function collect(p6) -- line: 93
    -- upvalues: t1 (copy), props (copy)
    local t4 = {}
    local v5 = t1.KeepChildren[p6.Name]

    local function walk(p7) -- line: 96
        -- upvalues: p6 (copy), t4 (copy), v5 (copy), walk (copy), props (copy)
        for _, child in p7:GetChildren() do
            if child:IsA("GuiObject") then
                if child.Visible then
                    if v5 and p7 == p6 then
                        if not v5[child.Name] then
                            for _, v6 in props(child) do
                                local function v7() -- line: 101
                                    -- upvalues: child (copy), v6 (copy)
                                    return child[v6]
                                end

                                local ok, result = pcall(v7)

                                if ok and typeof(result) == "number" then
                                    t4[#t4 + 1] = {
                                        child,
                                        v6,
                                        result
                                    }
                                end
                            end

                            if not child:IsA("CanvasGroup") then
                                walk(child)
                            end
                        end
                    else
                        for _, v8 in props(child) do
                            local function v9() -- line: 101
                                -- upvalues: child (copy), v8 (copy)
                                return child[v8]
                            end

                            local ok, result = pcall(v9)

                            if ok and typeof(result) == "number" then
                                t4[#t4 + 1] = {
                                    child,
                                    v8,
                                    result
                                }
                            end
                        end

                        if not child:IsA("CanvasGroup") then
                            walk(child)
                        end
                    end
                end
            elseif v5 and p7 == p6 then
                if not v5[child.Name] then
                    for _, v10 in props(child) do
                        local function v11() -- line: 101
                            -- upvalues: child (copy), v10 (copy)
                            return child[v10]
                        end

                        local ok, result = pcall(v11)

                        if ok and typeof(result) == "number" then
                            t4[#t4 + 1] = {
                                child,
                                v10,
                                result
                            }
                        end
                    end

                    if not child:IsA("CanvasGroup") then
                        walk(child)
                    end
                end
            else
                for _, v12 in props(child) do
                    local function v13() -- line: 101
                        -- upvalues: child (copy), v12 (copy)
                        return child[v12]
                    end

                    local ok, result = pcall(v13)

                    if ok and typeof(result) == "number" then
                        t4[#t4 + 1] = {
                            child,
                            v12,
                            result
                        }
                    end
                end

                if not child:IsA("CanvasGroup") then
                    walk(child)
                end
            end
        end
    end

    walk(p6)

    return {
        entries = t4,
        partial = v5 ~= nil,
        kids = {}
    }
end

local function hideKids(p8, p9) -- line: 111
    -- upvalues: t1 (copy)
    local v14 = t1.KeepChildren[p8.Name] or {}

    for _, child in p8:GetChildren() do
        if child:IsA("GuiObject") and not v14[child.Name] and child.Visible then
            p9.kids[child] = true
            child.Visible = false
        end
    end
end

local function restoreKids(p10) -- line: 117
    for v15 in p10.kids do
        if v15.Parent then
            v15.Visible = true
        end
    end

    table.clear(p10.kids)
end

local function setOff(p11, p12) -- line: 121
    -- upvalues: hideKids (copy)
    if p12.partial then
        hideKids(p11, p12)
    else
        p11.Enabled = false
    end
end

local function setOn(p13, p14) -- line: 122
    if not p14.partial then
        p13.Enabled = true

        return
    end

    for v16 in p14.kids do
        if v16.Parent then
            v16.Visible = true
        end
    end

    table.clear(p14.kids)
end

local n1 = 1
local v17 = false
local t5 = {}

local function apply(p15) -- line: 126
    -- upvalues: t3 (copy)
    for v18, v19 in t3 do
        if v18.Parent then
            for _, v20 in v19.entries do
                local v21 = v20[1]

                if v21.Parent then
                    local v22 = 1 - (1 - v20[3]) * p15

                    local function v23() -- line: 133
                        -- upvalues: v20 (copy), v21 (copy), v22 (copy)
                        if v21[v20[2]] ~= v22 then
                            v21[v20[2]] = v22
                        end
                    end

                    pcall(v23)
                end
            end
        end
    end
end

local function restoreAll() -- line: 139
    -- upvalues: t3 (copy), apply (copy)
    for v24, v25 in t3 do
        if v24.Parent then
            if v25.partial then
                for v26 in v25.kids do
                    if v26.Parent then
                        v26.Visible = true
                    end
                end

                table.clear(v25.kids)
            else
                v24.Enabled = true
            end
        end
    end

    apply(1)
    table.clear(t3)
end

local t6 = {}

local function setCore(p16) -- line: 147
    -- upvalues: StarterGui (copy), t5 (ref), t6 (copy)
    if p16 then
        for v27 in t5 do
            local function v28() -- line: 155
                -- upvalues: v27 (copy), StarterGui (copy)
                StarterGui:SetCoreGuiEnabled(v27, true)
            end

            pcall(v28)
        end

        t5 = {}
    else
        t5 = {}

        for _, v29 in t6 do
            local function v30() -- line: 151
                -- upvalues: v29 (copy), StarterGui (copy)
                return StarterGui:GetCoreGuiEnabled(v29)
            end

            local ok, result = pcall(v30)

            if ok and result then
                local t7 = t5

                t7[v29] = true

                local function v31() -- line: 152
                    -- upvalues: v29 (copy), StarterGui (copy)
                    StarterGui:SetCoreGuiEnabled(v29, false)
                end

                pcall(v31)
            end
        end
    end
end

local function hide() -- line: 159
    -- upvalues: PlayerGui (copy), JerezRaceHUD (copy), t1 (copy), ScreenGui (copy), placeLogo (copy), t3 (copy), collect (copy), v17 (ref), setCore (copy)
    if v17 then
        return
    end

    v17 = true
    JerezRaceHUD:SetAttribute("SpectateHudHidden", true)

    for _, child in PlayerGui:GetChildren() do
        if child:IsA("ScreenGui") and child.Enabled and not t1.Keep[child.Name] and not t3[child] then
            t3[child] = collect(child)
        end
    end

    setCore(false)
    placeLogo()
    ScreenGui.Enabled = true
end

local function show(p17) -- line: 168
    -- upvalues: StarterGui (copy), JerezRaceHUD (copy), ScreenGui (copy), CanvasGroup (copy), t3 (copy), n1 (ref), v17 (ref), t5 (ref), restoreAll (copy)
    if not (v17 or p17) then
        return
    end

    v17 = false
    JerezRaceHUD:SetAttribute("SpectateHudHidden", false)

    for v32, v33 in t3 do
        if v32.Parent then
            if v33.partial then
                for v34 in v33.kids do
                    if v34.Parent then
                        v34.Visible = true
                    end
                end

                table.clear(v33.kids)
            else
                v32.Enabled = true
            end
        end
    end

    for v35 in t5 do
        local function v36() -- line: 155
            -- upvalues: v35 (copy), StarterGui (copy)
            StarterGui:SetCoreGuiEnabled(v35, true)
        end

        pcall(v36)
    end

    t5 = {}

    if not p17 then
        return
    end

    n1 = 1
    restoreAll()
    CanvasGroup.GroupTransparency = 1
    ScreenGui.Enabled = false
end

local n2 = 0

local function spectating() -- line: 178
    -- upvalues: JerezRaceHUD (copy)
    if JerezRaceHUD:GetAttribute("LobbySpectating") == true then
        return JerezRaceHUD:GetAttribute("Freecam") ~= true
    end

    return false
end

local function cutscene() -- line: 182
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("CutscenePlaying") == true
end

LocalPlayer:GetAttributeChangedSignal("CutscenePlaying"):Connect(function() -- line: 187
    -- upvalues: LocalPlayer (copy), t3 (copy), n1 (ref), v17 (ref), show (copy), n2 (ref)
    if LocalPlayer:GetAttribute("CutscenePlaying") == true and (v17 or next(t3) or n1 < 1) then
        n2 = 0
        show(true)
    end
end)

local function overKeptHud(p18) -- line: 191
    -- upvalues: PlayerGui (copy)
    local X, Y = p18.X, p18.Y

    local function inside(p19, p20) -- line: 194
        -- upvalues: X (copy), Y (copy)
        if p19 and p19:IsA("GuiObject") and p19.Visible and p19.AbsoluteSize.X > 0 then
            local AbsolutePosition, AbsoluteSize = p19.AbsolutePosition, p19.AbsoluteSize

            if X >= AbsolutePosition.X and X <= AbsolutePosition.X + math.max(AbsoluteSize.X, p20 or 0) and Y >= AbsolutePosition.Y then
                return Y <= AbsolutePosition.Y + AbsoluteSize.Y
            end

            return false
        end

        return false
    end

    local SpectateTimingCardsHUD = PlayerGui:FindFirstChild("SpectateTimingCardsHUD")
    local TimingCards = SpectateTimingCardsHUD and SpectateTimingCardsHUD:FindFirstChild("TimingCards")

    if TimingCards then
        for _, child in TimingCards:GetChildren() do
            if inside(child) then
                return true
            end
        end
    end

    local LapTimesBoard = PlayerGui:FindFirstChild("LapTimesBoard")

    if LapTimesBoard and LapTimesBoard.Enabled then
        for _, child in LapTimesBoard:GetChildren() do
            if inside(child) then
                return true
            end
        end
    end

    return false
end

local t8 = {
    [Enum.UserInputType.MouseButton1] = true,
    [Enum.UserInputType.MouseButton2] = true,
    [Enum.UserInputType.MouseButton3] = true,
    [Enum.UserInputType.Touch] = true,
    [Enum.UserInputType.Keyboard] = true
}

UserInputService.InputBegan:Connect(function(p21) -- line: 209
    -- upvalues: UserInputService (copy), LocalPlayer (copy), JerezRaceHUD (copy), t1 (copy), v17 (ref), hide (copy), show (copy), n2 (ref), overKeptHud (copy), t8 (copy)
    if JerezRaceHUD:GetAttribute("LobbySpectating") ~= true or JerezRaceHUD:GetAttribute("Freecam") == true or LocalPlayer:GetAttribute("CutscenePlaying") == true then
        return
    end

    local UserInputType = p21.UserInputType

    if UserInputType == Enum.UserInputType.Keyboard and p21.KeyCode == t1.ToggleKey and not UserInputService:GetFocusedTextBox() then
        n2 = 0

        if v17 then
            show()
        else
            hide()
        end
    else
        local v38 = UserInputType.Name:sub(1, 7) == "Gamepad" and p21.KeyCode ~= Enum.KeyCode.Thumbstick1 and p21.KeyCode ~= Enum.KeyCode.Thumbstick2

        if t8[UserInputType] or v38 then
            n2 = 0

            if (UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch) and overKeptHud(p21.Position) then
                return
            end

            if v17 then
                show()
            end
        end
    end
end)
UserInputService.InputChanged:Connect(function(p22) -- line: 223
    -- upvalues: UserInputService (copy), GuiService (copy), LocalPlayer (copy), JerezRaceHUD (copy), v17 (ref), show (copy), n2 (ref), overKeptHud (copy)
    if p22.UserInputType == Enum.UserInputType.MouseWheel and JerezRaceHUD:GetAttribute("LobbySpectating") == true and JerezRaceHUD:GetAttribute("Freecam") ~= true and LocalPlayer:GetAttribute("CutscenePlaying") ~= true then
        n2 = 0

        if v17 and not overKeptHud(UserInputService:GetMouseLocation() - GuiService:GetGuiInset()) then
            show()
        end
    end
end)

local v39 = false

RunService.RenderStepped:Connect(function(p23) -- line: 231
    -- upvalues: LocalPlayer (copy), JerezRaceHUD (copy), t1 (copy), ScreenGui (copy), CanvasGroup (copy), placeLogo (copy), t3 (copy), hideKids (copy), n1 (ref), v17 (ref), apply (copy), restoreAll (copy), hide (copy), show (copy), n2 (ref), v39 (ref)
    local v40 = math.min(p23, 0.1)

    if LocalPlayer:GetAttribute("CutscenePlaying") == true then
        n2 = 0
    elseif JerezRaceHUD:GetAttribute("LobbySpectating") == true and JerezRaceHUD:GetAttribute("Freecam") ~= true then
        if not v39 then
            v39 = true
            n2 = 0
        end

        if JerezRaceHUD:GetAttribute("LobbySettings") == true or JerezRaceHUD:GetAttribute("ProfileOpen") == true then
            n2 = 0

            if v17 then
                show()
            end
        end

        n2 += v40

        local v41 = not v17

        v41 = v41 and n2 >= t1.IdleSeconds

        if v41 then
            hide()
        end

        local v43 = if v17 then 0 else 1

        if n1 == v43 then
            if v17 and n1 <= 0 then
                for v44, v45 in t3 do
                    if v44.Parent and v45.partial then
                        hideKids(v44, v45)
                    end
                end
            end
        else
            local v46

            if v43 < n1 then
                local v48 = n1

                v46 = math.max(0, v48 - v40 / t1.FadeOut)

                if not v46 then
                    local v49 = n1

                    v46 = math.min(1, v49 + v40 / t1.FadeIn)
                end
            else
                local v51 = n1

                v46 = math.min(1, v51 + v40 / t1.FadeIn)
            end

            n1 = v46
            apply(n1 * n1 * (3 - n1 * 2))

            if n1 <= 0 then
                for v55, v56 in t3 do
                    if v55.Parent then
                        if v56.partial then
                            hideKids(v55, v56)
                        else
                            v55.Enabled = false
                        end
                    end
                end
            end

            if n1 >= 1 then
                restoreAll()
            end
        end

        if ScreenGui.Enabled then
            placeLogo()

            local v57 = if v17 then 0 else 1
            local GroupTransparency = CanvasGroup.GroupTransparency

            if GroupTransparency ~= v57 then
                local v58

                if v57 < GroupTransparency then
                    v58 = math.max(0, GroupTransparency - v40 / t1.FadeOut)

                    if not v58 then
                        v58 = math.min(1, GroupTransparency + v40 / t1.FadeIn)
                    end
                else
                    v58 = math.min(1, GroupTransparency + v40 / t1.FadeIn)
                end

                GroupTransparency = v58
                CanvasGroup.GroupTransparency = v58
            end

            if not v17 and GroupTransparency >= 1 then
                ScreenGui.Enabled = false
            end
        end
    else
        if v39 or v17 or next(t3) then
            show(true)
        end

        v39 = false
        n2 = 0
    end
end)
