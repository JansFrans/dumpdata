-- https://lua.expert

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local GroupService = game:GetService("GroupService")
local Parent = script.Parent
local RaceIcons = require(Parent:WaitForChild("RaceIcons"))
local UIArt = require(Parent:WaitForChild("UIArt"))
local ShopCatalog = require(Parent:WaitForChild("ShopCatalog"))
local ShopMenu = require(Parent:WaitForChild("ShopMenu"))
local v1 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)
local v2 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
local v3 = Color3.new(1, 1, 1)
local v4 = Color3.new(0, 0, 0)
local v5 = Color3.fromRGB(231, 0, 0)
local v6 = Color3.fromRGB(150, 154, 162)
local v7 = Color3.fromRGB(24, 24, 28)
local v8 = Color3.fromRGB(10, 10, 12)
local v9 = Color3.fromRGB(60, 62, 70)
local v10 = Color3.fromRGB(44, 46, 54)
local Center = Enum.TextXAlignment.Center
local t1 = {}

t1.BlurSize = 20

function t1.New(p1) -- line: 32
    -- upvalues: TweenService (copy), RunService (copy), UserInputService (copy), Players (copy), GroupService (copy), Parent (copy), RaceIcons (copy), UIArt (copy), ShopCatalog (copy), ShopMenu (copy), t1 (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy), v10 (copy), Center (copy)
    local t2 = {}
    local LocalPlayer = Players.LocalPlayer
    local ClaimCommunityReward = Parent:WaitForChild("ClaimCommunityReward")
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "FreeGiftHUD"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 36
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Enabled = false
    ScreenGui.Archivable = false
    ScreenGui.Parent = p1

    local Frame = Instance.new("Frame")

    Frame.Name = "Root"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.Parent = ScreenGui

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "ReferenceCanvas"
    Frame2.BackgroundTransparency = 1
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame2.Position = UDim2.fromScale(0.5, 0.5)
    Frame2.Size = UDim2.fromOffset(2000, 1125)
    Frame2.Parent = Frame

    local UIScale = Instance.new("UIScale", Frame2)

    local function fit() -- line: 42
        -- upvalues: Frame (copy), UIScale (copy)
        local AbsoluteSize = Frame.AbsoluteSize

        if AbsoluteSize.X < 1 or AbsoluteSize.Y < 1 then
            AbsoluteSize = workspace.CurrentCamera.ViewportSize
        end

        UIScale.Scale = math.min(AbsoluteSize.X / 2000, AbsoluteSize.Y / 1125)
    end

    Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)

    local function text(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11) -- line: 47
        -- upvalues: v1 (copy), v3 (copy)
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = p3
        TextLabel.Text = p4
        TextLabel.BackgroundTransparency = 1
        TextLabel.Position = UDim2.fromOffset(p5, p6)
        TextLabel.Size = UDim2.fromOffset(p7, p8)
        TextLabel.TextColor3 = p10 or v3
        TextLabel.FontFace = p11 or v1
        TextLabel.TextSize = p9
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.ZIndex = 5
        TextLabel.AutoLocalize = false
        TextLabel.Parent = p2

        return TextLabel
    end

    local function frame(p12, p13, p14, p15, p16, p17, p18, p19) -- line: 51
        -- upvalues: v3 (copy)
        local Frame = Instance.new("Frame")

        Frame.Name = p13
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = p18 or v3
        Frame.Position = UDim2.fromOffset(p14, p15)
        Frame.Size = UDim2.fromOffset(p16, p17)
        Frame.ZIndex = p19 or 5
        Frame.Parent = p12

        return Frame
    end

    local function round(p20, p21) -- line: 54
        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0, p21)
        UICorner.Parent = p20

        return UICorner
    end

    local function pressable(p22, p23) -- line: 56
        -- upvalues: TweenService (copy)
        p22:SetAttribute("NoHover", true)
        p22.AutoButtonColor = false

        local v13 = p22:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", p22)

        local function set(p24) -- line: 59
            -- upvalues: p23 (copy)
            if p23 then
                p23(p24)
            end
        end

        p22.MouseEnter:Connect(function() -- line: 60
            -- upvalues: p23 (copy)
            if p23 then
                p23(true)
            end
        end)
        p22.MouseLeave:Connect(function() -- line: 61
            -- upvalues: p23 (copy), v13 (copy), TweenService (copy)
            if p23 then
                p23(false)
            end

            TweenService:Create(v13, TweenInfo.new(0.12), {
                Scale = 1
            }):Play()
        end)
        p22.SelectionGained:Connect(function() -- line: 62
            -- upvalues: p23 (copy)
            if p23 then
                p23(true)
            end
        end)
        p22.SelectionLost:Connect(function() -- line: 62
            -- upvalues: p23 (copy)
            if p23 then
                p23(false)
            end
        end)
        p22.MouseButton1Down:Connect(function() -- line: 63
            -- upvalues: v13 (copy), TweenService (copy)
            TweenService:Create(v13, TweenInfo.new(0.08), {
                Scale = 0.95
            }):Play()
        end)
        p22.MouseButton1Up:Connect(function() -- line: 64
            -- upvalues: v13 (copy), TweenService (copy)
            TweenService:Create(v13, TweenInfo.new(0.16, Enum.EasingStyle.Back), {
                Scale = 1
            }):Play()
        end)

        return p22, v13
    end

    local function closeButton(p25, p26, p27, p28, p29, p30, p31) -- line: 68
        -- upvalues: text (copy), pressable (copy), TweenService (copy), RaceIcons (copy), v3 (copy), v4 (copy), v5 (copy), Center (copy)
        local TextButton = Instance.new("TextButton")

        TextButton.Name = "Close"
        TextButton.Text = ""
        TextButton.BackgroundTransparency = 1
        TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
        TextButton.Position = UDim2.fromOffset(p26, p27)
        TextButton.Size = UDim2.fromOffset(p28, p29)
        TextButton.ZIndex = p31
        TextButton.Parent = p25

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "ClosePlate"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Size = UDim2.fromScale(1, 1)
        ImageLabel.ImageColor3 = v3
        ImageLabel.ZIndex = p31
        ImageLabel.Parent = TextButton

        local ref_top_plate = RaceIcons.Get("ref_top_plate")

        if ref_top_plate then
            ImageLabel.ImageContent = ref_top_plate
        else
            ImageLabel.BackgroundTransparency = 0
            ImageLabel.BackgroundColor3 = v3
        end

        local v14 = text(TextButton, "X", "X", 0, 0, p28, p29, p30, v4)

        v14.TextXAlignment = Center
        v14.ZIndex = p31 + 1

        local function hover(p32) -- line: 74
            -- upvalues: ImageLabel (copy), v14 (copy), TweenService (copy), v3 (copy), v4 (copy), v5 (copy)
            TweenService:Create(ImageLabel, TweenInfo.new(0.18), {
                ImageColor3 = p32 and v5 or v3,
                BackgroundColor3 = p32 and v5 or v3
            }):Play()
            TweenService:Create(v14, TweenInfo.new(0.18), {
                TextColor3 = p32 and v3 or v4
            }):Play()
        end

        pressable(TextButton, hover)

        return TextButton, function() -- reset | line: 79
            -- upvalues: ImageLabel (copy), v14 (copy), v3 (copy), v4 (copy)
            ImageLabel.ImageColor3 = v3

            if ImageLabel.BackgroundTransparency < 1 then
                ImageLabel.BackgroundColor3 = v3
            end

            v14.TextColor3 = v4
        end
    end

    local Frame3 = Instance.new("Frame")

    Frame3.Name = "FreeGiftPanel"
    Frame3.BorderSizePixel = 0
    Frame3.BackgroundColor3 = v4 or v3
    Frame3.Position = UDim2.fromOffset(280, 152.5)
    Frame3.Size = UDim2.fromOffset(1440, 820)
    Frame3.ZIndex = 1
    Frame3.Parent = Frame2
    Frame3.Active = true
    Frame3.ClipsDescendants = true

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, 26)
    UICorner.Parent = Frame3
    UICorner = Instance.new("ImageLabel")
    UICorner.Name = "Halftone"
    UICorner.BackgroundTransparency = 1
    UICorner.AnchorPoint = Vector2.new(0.5, 0)
    UICorner.Position = UDim2.fromOffset(720, 10)
    UICorner.Size = UDim2.fromOffset(780, 805)
    UICorner.ZIndex = 1
    UICorner.Parent = Frame3
    UIArt.Apply(UICorner, "LegendsDots")
    text(Frame3, "Title", "FREE GIFT", 60, 38, 600, 58, 46).ZIndex = 6

    local Frame4 = Instance.new("Frame")

    Frame4.Name = "Divider"
    Frame4.BorderSizePixel = 0
    Frame4.BackgroundColor3 = v3 or v3
    Frame4.Position = UDim2.fromOffset(60, 104)
    Frame4.Size = UDim2.fromOffset(240, 4)
    Frame4.ZIndex = 6
    Frame4.Parent = Frame3

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.8, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Parent = Frame4

    local v17

    UIGradient, v17 = closeButton(Frame3, 1359, 62, 94, 50, 31, 20)
    UICorner = ShopMenu.CardSize

    local v18 = 600 / UICorner.Y
    local Frame5 = Instance.new("Frame")

    Frame5.Name = "GiftCard"
    Frame5.BackgroundTransparency = 1
    Frame5.Position = UDim2.fromOffset(60, 150)
    Frame5.Size = UDim2.fromOffset(UICorner.X, UICorner.Y)
    Frame5.ZIndex = 5
    Frame5.Parent = Frame3

    local UIScale2 = Instance.new("UIScale")

    UIScale2.Scale = v18
    UIScale2.Parent = Frame5

    local v19 = ShopMenu.BottleCard(Frame5, ShopCatalog.Community.Bottle)

    v19.button.Selectable = false
    v19.button.Active = false

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "MoneyIcon"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://91281390931284"
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Size = UDim2.fromOffset(38, 38)
    ImageLabel.ZIndex = 8
    ImageLabel.LayoutOrder = 1
    ImageLabel.Parent = v19.strip
    ImageLabel = text(v19.strip, "Value", "+" .. ShopCatalog.Money(ShopCatalog.Community.Money):sub(2), 0, 0, 0, 48, 34, v4)
    ImageLabel.AutomaticSize = Enum.AutomaticSize.X
    ImageLabel.ZIndex = 8
    ImageLabel.LayoutOrder = 2
    ImageLabel = Instance.new("TextLabel")
    ImageLabel.Name = "FreeTag"
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.fromOffset(UICorner.X - 48, 30)
    ImageLabel.Size = UDim2.fromOffset(84, 34)
    ImageLabel.Rotation = -6
    ImageLabel.BackgroundColor3 = v5
    ImageLabel.BorderSizePixel = 0
    ImageLabel.Text = "FREE"
    ImageLabel.TextColor3 = v3
    ImageLabel.FontFace = v1
    ImageLabel.TextSize = 20
    ImageLabel.ZIndex = 12
    ImageLabel.AutoLocalize = false
    ImageLabel.Parent = v19.button

    local UICorner2 = Instance.new("UICorner")

    UICorner2.CornerRadius = UDim.new(0, 8)
    UICorner2.Parent = ImageLabel
    UICorner2 = Instance.new("UIStroke")
    UICorner2.Color = v3
    UICorner2.Thickness = 2
    UICorner2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UICorner2.Parent = ImageLabel
    ImageLabel = math.floor(UICorner.X * v18 + 0.5) + 60 + 48
    UICorner = 1440 - ImageLabel - 60
    UICorner2 = text(Frame3, "Subtitle", "JOIN THE COMMUNITY AND GET THE COMMUNITY BOTTLE + " .. ShopCatalog.Money(ShopCatalog.Community.Money) .. "!", ImageLabel, 150, UICorner, 30, 23, v3, v1)
    UICorner2.TextWrapped = true
    UICorner2.ZIndex = 6
    UICorner2 = math.floor((UICorner - 44) / 3)

    local v21 = {
        art = "ThumbUp",
        title = "LIKE THE\nGAME",
        desc = "Hit the thumbs up on the MotoLegends page. It really helps the game grow!",
        size = Vector2.new(112, 112)
    }
    local v20 = {
        art = "Star",
        title = "FAVORITE THE\nGAME",
        desc = "Press the star on the MotoLegends page to add it to your favorites.",
        size = Vector2.new(112, 112)
    }
    local v22 = {
        art = "MotoLegendsLogo",
        offset = 12,
        title = "JOIN THE\nCOMMUNITY",
        desc = "Tap here to join the MotoLegends community. Needed for the gift!",
        join = true,
        size = Vector2.new(UICorner2 - 110, 74)
    }
    local t5 = {}
    local v23

    for v24, v25 in { v21, v20, v22 } do
        local v26 = ImageLabel + (v24 - 1) * (UICorner2 + 22)
        local TextButton

        if v25.join then
            TextButton = Instance.new("TextButton")
            TextButton.Text = ""
            TextButton.AutoButtonColor = false
        else
            TextButton = Instance.new("Frame")
        end

        TextButton.Name = "Step" .. v24
        TextButton.BorderSizePixel = 0
        TextButton.BackgroundColor3 = v7
        TextButton.Position = UDim2.fromOffset(v26, 200)
        TextButton.Size = UDim2.fromOffset(UICorner2, 408)
        TextButton.ZIndex = 5
        TextButton.Parent = Frame3

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0, 18)
        UICorner.Parent = TextButton

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Color = v10
        UIStroke.Thickness = 3
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.Parent = TextButton

        local v27 = UICorner2 - 24
        local Frame = Instance.new("Frame")

        Frame.Name = "IconBox"
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = v8 or v3
        Frame.Position = UDim2.fromOffset(12, 12)
        Frame.Size = UDim2.fromOffset(v27, 172)
        Frame.ZIndex = 6
        Frame.Parent = TextButton

        local UICorner3 = Instance.new("UICorner")

        UICorner3.CornerRadius = UDim.new(0, 12)
        UICorner3.Parent = Frame
        UICorner3 = Instance.new("ImageLabel")
        UICorner3.Name = "Icon"
        UICorner3.BackgroundTransparency = 1
        UICorner3.AnchorPoint = Vector2.new(0.5, 0.5)
        UICorner3.Position = UDim2.new(0.5, 0, 0.5, v25.offset or 0)
        UICorner3.Size = UDim2.fromOffset(v25.size.X, v25.size.Y)
        UICorner3.ScaleType = Enum.ScaleType.Fit
        UICorner3.ZIndex = 7
        UICorner3.Parent = Frame
        UIArt.Apply(UICorner3, v25.art)
        Frame = Instance.new("Frame")
        Frame.Name = "Number"
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = v3 or v3
        Frame.Position = UDim2.fromOffset(24, 24)
        Frame.Size = UDim2.fromOffset(46, 46)
        Frame.ZIndex = 8
        Frame.Parent = TextButton
        v27 = Instance.new("UICorner")
        v27.CornerRadius = UDim.new(0, 23)
        v27.Parent = Frame
        v27 = text(Frame, "N", tostring(v24), 0, 0, 46, 46, 26, v4)
        v27.TextXAlignment = Center
        v27.ZIndex = 9
        v27 = text(TextButton, "Title", v25.title, 10, 196, UICorner2 - 20, 66, 25)
        v27.TextXAlignment = Center
        v27.LineHeight = 1
        v27.ZIndex = 7
        v27 = text(TextButton, "Desc", v25.desc, 18, 268, UICorner2 - 36, 80, 17, v6, v2)
        v27.TextXAlignment = Center
        v27.TextYAlignment = Enum.TextYAlignment.Top
        v27.TextWrapped = true
        v27.ZIndex = 7

        local Frame2

        if v25.join then
            local v28 = (UICorner2 - 150) / 2

            Frame2 = Instance.new("Frame")
            Frame2.Name = "Status"
            Frame2.BorderSizePixel = 0
            Frame2.BackgroundColor3 = v9 or v3
            Frame2.Position = UDim2.fromOffset(v28, 354)
            Frame2.Size = UDim2.fromOffset(150, 36)
            Frame2.ZIndex = 7
            Frame2.Parent = TextButton
            v28 = Instance.new("UICorner")
            v28.CornerRadius = UDim.new(0, 18)
            v28.Parent = Frame2
            v23 = text(Frame2, "Text", "MISSING", 0, 0, 150, 36, 17, v6)
            v23.TextXAlignment = Center
            v23.ZIndex = 8
        else
            v23 = nil
        end

        t5[v24] = {
            frame = TextButton,
            edge = UIStroke,
            pill = Frame2,
            pillText = v23
        }
    end

    local v29 = t5[3]
    local v30 = text(Frame3, "Hint", "Complete the steps, then press CLAIM GIFT!", ImageLabel, 622, UICorner, 26, 18, v6, v2)

    v30.TextXAlignment = Enum.TextXAlignment.Right
    v30.ZIndex = 6

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "ClaimGift"
    TextButton.AnchorPoint = Vector2.new(1, 0)
    TextButton.Position = UDim2.fromOffset(1380, 662)
    TextButton.Size = UDim2.fromOffset(440, 100)
    TextButton.BackgroundColor3 = v5
    TextButton.BorderSizePixel = 0
    TextButton.Text = "CLAIM GIFT"
    TextButton.TextColor3 = v3
    TextButton.FontFace = v1
    TextButton.TextSize = 44
    TextButton.ZIndex = 6
    TextButton.AutoLocalize = false
    TextButton.ClipsDescendants = true
    TextButton.Parent = Frame3
    v20 = Instance.new("UICorner")
    v20.CornerRadius = UDim.new(0, 18)
    v20.Parent = TextButton

    local v31 = ShopMenu.AddShine(TextButton, 7)

    v20 = v31.Parent
    v22 = Instance.new("UICorner")
    v22.CornerRadius = UDim.new(0, 18)
    v22.Parent = v20

    local v32
    local v33 = false
    local n1 = 0
    local n2 = 0
    local v34 = false

    local function claimed() -- line: 155
        -- upvalues: LocalPlayer (copy)
        return LocalPlayer:GetAttribute("Community_Claimed") == true
    end

    local function serverBusy() -- line: 156
        -- upvalues: LocalPlayer (copy)
        if LocalPlayer:GetAttribute("Community_Pending") == true then
            return true
        end

        return LocalPlayer:GetAttribute("Community_Checking") == true
    end

    local function refresh() -- line: 157
        -- upvalues: LocalPlayer (copy), v29 (copy), TextButton (copy), v31 (copy), v32 (ref), v33 (ref), v34 (ref), v3 (copy), v5 (copy), v6 (copy), v9 (copy)
        local v35 = LocalPlayer:GetAttribute("Community_Claimed") == true
        local v36 = v35 or v32 == true

        v29.pill.BackgroundColor3 = v36 and v5 or v9
        v29.pillText.Text = v36 and "JOINED" or "MISSING"
        v29.pillText.TextColor3 = v36 and v3 or v6

        local v37 = v33

        if not v37 then
            v37 = LocalPlayer:GetAttribute("Community_Pending") == true or LocalPlayer:GetAttribute("Community_Checking") == true
        end

        TextButton.Text = if v35 then "CLAIMED" elseif v37 then "CHECKING..." else "CLAIM GIFT"

        local v39 = not v35 and not v37
        local v40, v41

        if v39 then
            if v34 and v3 then
                v40 = v3
                v41 = true
            else
                v41 = false
            end
        elseif v9 then
            v40 = v9
            v41 = true
        elseif v34 and v3 then
            v40 = v3
            v41 = true
        else
            v41 = false
        end

        TextButton.BackgroundColor3 = if not v41 then v5 else v40

        local v42, v43

        if v39 then
            if v34 and v5 then
                v42 = v5
                v43 = true
            else
                v43 = false
            end
        elseif v6 then
            v42 = v6
            v43 = true
        elseif v34 and v5 then
            v42 = v5
            v43 = true
        else
            v43 = false
        end

        TextButton.TextColor3 = if not v43 then v3 else v42
        v31.Parent.Visible = v39
    end

    local function setHint(p33, p34) -- line: 169
        -- upvalues: v30 (copy), v3 (copy), v6 (copy)
        v30.Text = p33 or "Complete the steps, then press CLAIM GIFT!"
        v30.TextColor3 = p34 and v3 or v6
    end

    local function checkMember() -- line: 170
        -- upvalues: LocalPlayer (copy), v32 (ref), refresh (copy), GroupService (copy), ShopCatalog (copy)
        task.spawn(function() -- line: 171
            -- upvalues: LocalPlayer (copy), v32 (ref), refresh (copy), GroupService (copy), ShopCatalog (copy)
            local GetGroupsAsync = GroupService.GetGroupsAsync
            local UserId = LocalPlayer.UserId
            local ok, result = pcall(GetGroupsAsync, GroupService, UserId)

            if ok and typeof(result) == "table" then
                local v45 = false

                for _, v46 in result do
                    if v46.Id == ShopCatalog.Community.GroupId then
                        v45 = true
                    end
                end

                v32 = v45
                refresh()
            end
        end)
    end

    local function join() -- line: 181
        -- upvalues: LocalPlayer (copy), v32 (ref), refresh (copy), GroupService (copy), ShopCatalog (copy)
        if LocalPlayer:GetAttribute("Community_Claimed") ~= true then
            task.spawn(function() -- line: 171
                -- upvalues: LocalPlayer (copy), v32 (ref), refresh (copy), GroupService (copy), ShopCatalog (copy)
                local GetGroupsAsync = GroupService.GetGroupsAsync
                local UserId = LocalPlayer.UserId
                local ok, result = pcall(GetGroupsAsync, GroupService, UserId)

                if ok and typeof(result) == "table" then
                    local v47 = false

                    for _, v48 in result do
                        if v48.Id == ShopCatalog.Community.GroupId then
                            v47 = true
                        end
                    end

                    v32 = v47
                    refresh()
                end
            end)
        end
    end

    local function doClaim() -- line: 185
        -- upvalues: LocalPlayer (copy), ClaimCommunityReward (copy), v30 (copy), v33 (ref), n1 (ref), refresh (copy), v3 (copy), v6 (copy)
        if LocalPlayer:GetAttribute("Community_Claimed") == true or v33 or LocalPlayer:GetAttribute("Community_Pending") == true or LocalPlayer:GetAttribute("Community_Checking") == true then
            return
        end

        v33 = true
        n1 += 1

        local v49 = n1

        v30.Text = "Complete the steps, then press CLAIM GIFT!"
        v30.TextColor3 = v6
        refresh()
        ClaimCommunityReward:FireServer()
        task.delay(8, function() -- line: 189
            -- upvalues: v49 (copy), v30 (copy), v33 (ref), n1 (ref), refresh (copy), v3 (copy), v6 (copy)
            if n1 ~= v49 or not v33 then
                return
            end

            v33 = false
            v30.Text = "No answer from the server. Please try again."
            v30.TextColor3 = v3 or v6
            refresh()
        end)
    end

    ClaimCommunityReward.OnClientEvent:Connect(function(p35) -- line: 191
        -- upvalues: v30 (copy), v32 (ref), v33 (ref), n1 (ref), n2 (ref), refresh (copy), v3 (copy), v6 (copy)
        v33 = false
        n1 += 1

        if p35 == "Saving" or p35 == "Claimed" then
            v32 = true
            v30.Text = "Gift unlocked!"
            v30.TextColor3 = v3 or v6
        elseif p35 == "NotMember" then
            v32 = false
            n2 = os.clock() + 1.6
            v30.Text = "Join the community first, then press CLAIM GIFT again."
            v30.TextColor3 = v3 or v6
        elseif p35 == "Wait" then
            v30.Text = "Please wait a moment and try again."
            v30.TextColor3 = v3 or v6
        elseif p35 == "NotLoaded" then
            v30.Text = "Your data is still loading. Try again in a moment."
            v30.TextColor3 = v3 or v6
        elseif p35 == "Busy" then
            v30.Text = "Checking your membership..."
            v30.TextColor3 = v6
        end

        refresh()
    end)
    pressable(TextButton, function(p36) -- line: 200
        -- upvalues: v34 (ref), refresh (copy)
        v34 = p36
        refresh()
    end)
    TextButton.Activated:Connect(doClaim)
    pressable(v29.frame, function(p37) -- line: 202
        -- upvalues: v29 (copy), TweenService (copy), v5 (copy), v10 (copy)
        TweenService:Create(v29.edge, TweenInfo.new(0.15), {
            Color = p37 and v5 or v10
        }):Play()
    end)
    v29.frame.Activated:Connect(join)

    local ScreenGui2 = Instance.new("ScreenGui")

    ScreenGui2.Name = "FreeGiftToast"
    ScreenGui2.IgnoreGuiInset = true
    ScreenGui2.ResetOnSpawn = false
    ScreenGui2.DisplayOrder = 60
    ScreenGui2.Parent = p1

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Toast"
    TextLabel.AnchorPoint = Vector2.new(0.5, 1)
    TextLabel.Position = UDim2.new(0.5, 0, 1, -90)
    TextLabel.Size = UDim2.fromOffset(0, 40)
    TextLabel.AutomaticSize = Enum.AutomaticSize.X
    TextLabel.BackgroundColor3 = v4
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextColor3 = v3
    TextLabel.TextTransparency = 1
    TextLabel.FontFace = v1
    TextLabel.TextSize = 18
    TextLabel.Text = ""
    TextLabel.AutoLocalize = false
    TextLabel.Parent = ScreenGui2
    ScreenGui2 = Instance.new("UICorner")
    ScreenGui2.CornerRadius = UDim.new(0, 20)
    ScreenGui2.Parent = TextLabel
    v23 = Instance.new("UIPadding")
    v23.PaddingLeft = UDim.new(0, 22)
    v23.PaddingRight = UDim.new(0, 22)
    v23.Parent = TextLabel

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = v3
    UIStroke.Thickness = 2
    UIStroke.Transparency = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = TextLabel

    local n3 = 0

    function t2.Toast(p38) -- line: 217
        -- upvalues: TextLabel (copy), UIStroke (copy), n3 (ref), TweenService (copy)
        n3 += 1

        local v56 = n3

        TextLabel.Text = string.upper(p38)
        TweenService:Create(TextLabel, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.1,
            TextTransparency = 0
        }):Play()
        TweenService:Create(UIStroke, TweenInfo.new(0.2), {
            Transparency = 0.2
        }):Play()
        task.delay(3, function() -- line: 221
            -- upvalues: v56 (copy), TextLabel (copy), UIStroke (copy), n3 (ref), TweenService (copy)
            if v56 == n3 then
                TweenService:Create(TextLabel, TweenInfo.new(0.35), {
                    BackgroundTransparency = 1,
                    TextTransparency = 1
                }):Play()
                TweenService:Create(UIStroke, TweenInfo.new(0.35), {
                    Transparency = 1
                }):Play()
            end
        end)
    end

    RunService.RenderStepped:Connect(function() -- line: 228
        -- upvalues: LocalPlayer (copy), ScreenGui (copy), v19 (copy), t5 (copy), v31 (copy), n2 (ref), v5 (copy), v10 (copy)
        if ScreenGui.Enabled then
            local elapsed = os.clock()

            v19.step(elapsed, LocalPlayer:GetAttribute("GfxEffects") ~= false)

            local v58 = math.clamp(elapsed % 3 / 1.8, 0, 1)
            local v59 = v58 * v58 * (3 - v58 * 2)

            v31.Offset = Vector2.new(v59 * 2.4 + -1.2, 0)

            if elapsed < n2 then
                local v61 = math.floor(elapsed * 6) % 2 == 0

                for _, v62 in t5 do
                    v62.edge.Color = v61 and v5 or v10
                end
            elseif n2 > 0 then
                n2 = 0

                for _, v63 in t5 do
                    v63.edge.Color = v10
                end
            end
        end
    end)

    local t7 = {
        FreeGiftHUD = true,
        FreeGiftToast = true,
        ShopToast = true,
        TouchGui = true,
        ExitTeleportCover = true,
        WeatherVote = true
    }
    local t8 = {}
    local v64

    local function hideGui(p39) -- line: 247
        -- upvalues: ScreenGui (copy), t7 (copy), t8 (copy)
        if p39 == ScreenGui or not p39:IsA("ScreenGui") or t7[p39.Name] or t8[p39] then
            return
        end

        local t9 = {
            own = 0,
            wanted = p39.Enabled
        }

        t8[p39] = t9

        local function off() -- line: 251
            -- upvalues: p39 (copy), t9 (copy)
            if p39.Enabled then
                t9.own += 1
                p39.Enabled = false
            end
        end

        t9.conn = p39:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 252
            -- upvalues: p39 (copy), t9 (copy)
            local Enabled = p39.Enabled
            local Enabled2

            if Enabled then
                t9.wanted = true
                Enabled2 = p39.Enabled
            else
                if t9.own > 0 then
                    t9.own -= 1

                    return
                end

                t9.wanted = false
            end

            if (not Enabled or Enabled2) and Enabled then
                t9.own += 1
                p39.Enabled = false
            end
        end)

        if p39.Enabled then
            t9.own += 1
            p39.Enabled = false
        end
    end

    local function hideGuis() -- line: 259
        -- upvalues: p1 (copy), v64 (ref), hideGui (copy)
        for _, child in p1:GetChildren() do
            hideGui(child)
        end

        v64 = v64 or p1.ChildAdded:Connect(hideGui)
    end

    local function restoreGuis() -- line: 263
        -- upvalues: t8 (copy), v64 (ref)
        if v64 then
            v64:Disconnect()
            v64 = nil
        end

        for v65, v66 in t8 do
            v66.conn:Disconnect()

            if v65.Parent and v66.wanted then
                v65.Enabled = true
            end
        end

        table.clear(t8)
    end

    local BlurEffect

    local function setBlur(p40) -- line: 269
        -- upvalues: BlurEffect (ref), TweenService (copy), t1 (copy)
        if p40 then
            local CurrentCamera = workspace.CurrentCamera

            if not (BlurEffect and BlurEffect.Parent) then
                BlurEffect = Instance.new("BlurEffect")
                BlurEffect.Name = "FreeGiftBlur"
                BlurEffect.Size = 0
                BlurEffect.Parent = CurrentCamera
            end

            TweenService:Create(BlurEffect, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = t1.BlurSize
            }):Play()
        elseif BlurEffect then
            local BlurEffect2 = BlurEffect

            BlurEffect = nil

            local tween = TweenService:Create(BlurEffect2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = 0
            })

            tween.Completed:Connect(function() -- line: 277
                -- upvalues: BlurEffect2 (copy)
                BlurEffect2:Destroy()
            end)
            tween:Play()
        end
    end

    local function flagOpen(p41) -- line: 280
        -- upvalues: p1 (copy)
        local JerezRaceHUD = p1:FindFirstChild("JerezRaceHUD")

        if JerezRaceHUD then
            JerezRaceHUD:SetAttribute("FreeGiftOpen", p41)
        end
    end

    function t2.Open() -- line: 283
        -- upvalues: p1 (copy), LocalPlayer (copy), ScreenGui (copy), Frame (copy), UIScale (copy), v17 (ref), t5 (copy), v30 (copy), v32 (ref), n2 (ref), v34 (ref), refresh (copy), v64 (ref), hideGui (copy), BlurEffect (ref), TweenService (copy), GroupService (copy), ShopCatalog (copy), t1 (copy), v6 (copy), v10 (copy)
        local AbsoluteSize = Frame.AbsoluteSize

        if AbsoluteSize.X < 1 or AbsoluteSize.Y < 1 then
            AbsoluteSize = workspace.CurrentCamera.ViewportSize
        end

        UIScale.Scale = math.min(AbsoluteSize.X / 2000, AbsoluteSize.Y / 1125)
        v17()
        v30.Text = "Complete the steps, then press CLAIM GIFT!"
        v30.TextColor3 = v6
        n2 = 0

        for _, v69 in t5 do
            v69.edge.Color = v10
        end

        v34 = false
        task.spawn(function() -- line: 171
            -- upvalues: LocalPlayer (copy), v32 (ref), refresh (copy), GroupService (copy), ShopCatalog (copy)
            local GetGroupsAsync = GroupService.GetGroupsAsync
            local UserId = LocalPlayer.UserId
            local ok, result = pcall(GetGroupsAsync, GroupService, UserId)

            if ok and typeof(result) == "table" then
                local v70 = false

                for _, v71 in result do
                    if v71.Id == ShopCatalog.Community.GroupId then
                        v70 = true
                    end
                end

                v32 = v70
                refresh()
            end
        end)
        refresh()

        if ScreenGui.Enabled then
            return
        end

        for _, child in p1:GetChildren() do
            hideGui(child)
        end

        v64 = v64 or p1.ChildAdded:Connect(hideGui)

        local CurrentCamera = workspace.CurrentCamera

        if not (BlurEffect and BlurEffect.Parent) then
            BlurEffect = Instance.new("BlurEffect")
            BlurEffect.Name = "FreeGiftBlur"
            BlurEffect.Size = 0
            BlurEffect.Parent = CurrentCamera
        end

        TweenService:Create(BlurEffect, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = t1.BlurSize
        }):Play()

        local JerezRaceHUD = p1:FindFirstChild("JerezRaceHUD")

        if JerezRaceHUD then
            JerezRaceHUD:SetAttribute("FreeGiftOpen", true)
        end

        ScreenGui.Enabled = true
    end

    function t2.Close() -- line: 288
        -- upvalues: p1 (copy), ScreenGui (copy), v17 (ref), restoreGuis (copy), BlurEffect (ref), TweenService (copy)
        if ScreenGui.Enabled then
            if BlurEffect then
                local BlurEffect2 = BlurEffect

                BlurEffect = nil

                local tween = TweenService:Create(BlurEffect2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Size = 0
                })

                tween.Completed:Connect(function() -- line: 277
                    -- upvalues: BlurEffect2 (copy)
                    BlurEffect2:Destroy()
                end)
                tween:Play()
            end

            local JerezRaceHUD = p1:FindFirstChild("JerezRaceHUD")

            if JerezRaceHUD then
                JerezRaceHUD:SetAttribute("FreeGiftOpen", false)
            end

            ScreenGui.Enabled = false
            v17()
            restoreGuis()
        end
    end

    function t2.IsOpen() -- line: 293
        -- upvalues: ScreenGui (copy)
        return ScreenGui.Enabled
    end

    UIGradient.Activated:Connect(function() -- line: 294
        -- upvalues: t2 (copy)
        t2.Close()
    end)
    UserInputService.InputBegan:Connect(function(p42) -- line: 295
        -- upvalues: t2 (copy), ScreenGui (copy)
        if ScreenGui.Enabled and p42.KeyCode == Enum.KeyCode.ButtonB then
            t2.Close()
        end
    end)

    local v72 = false

    for _, v73 in { "Community_Claimed", "Community_Pending", "Community_Checking" } do
        LocalPlayer:GetAttributeChangedSignal(v73):Connect(function() -- line: 302
            -- upvalues: t2 (copy), LocalPlayer (copy), ScreenGui (copy), refresh (copy), v72 (ref), v73 (copy), ShopCatalog (copy)
            refresh()

            if v73 == "Community_Pending" and (LocalPlayer:GetAttribute("Community_Pending") == true or LocalPlayer:GetAttribute("Community_Checking") == true) then
                v72 = true
            end

            if v73 == "Community_Claimed" and LocalPlayer:GetAttribute("Community_Claimed") == true and v72 then
                v72 = false
                t2.Toast("COMMUNITY BOTTLE + " .. ShopCatalog.Money(ShopCatalog.Community.Money) .. " UNLOCKED")

                if ScreenGui.Enabled then
                    task.delay(1.4, function() -- line: 308
                        -- upvalues: t2 (copy)
                        t2.Close()
                    end)
                end
            end
        end)
    end

    t2.Gui = ScreenGui
    UIGradient = Frame.AbsoluteSize

    if UIGradient.X < 1 or UIGradient.Y < 1 then
        UIGradient = workspace.CurrentCamera.ViewportSize
    end

    UIScale.Scale = math.min(UIGradient.X / 2000, UIGradient.Y / 1125)
    refresh()

    return t2
end

return t1
