-- https://lua.expert

local Players = game:GetService("Players")

game:GetService("ContentProvider")

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Log = require(Modules.Log)
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Pressable = require(UI.Components.Pressable)
local LoadingSpinner = require(UI.Components.LoadingSpinner)
local Icons = require(UI.Config.Icons)
local promptBulkPurchaseAsync = require(Modules.AssetUtil.promptBulkPurchaseAsync)
local Children = Fusion.Children
local LocalPlayer = Players.LocalPlayer
local v1
local v2 = "idle"

local function buildRigTemplate() -- line: 32
    -- upvalues: Players (copy), LocalPlayer (copy)
    local function v3() -- line: 33
        -- upvalues: Players (copy), LocalPlayer (copy)
        return Players:GetHumanoidDescriptionFromUserId(LocalPlayer.UserId)
    end

    local ok, result = pcall(v3)

    if not ok or not result then
        return nil
    end

    local function v4() -- line: 39
        -- upvalues: result (copy), Players (copy)
        return Players:CreateHumanoidModelFromDescription(result, Enum.HumanoidRigType.R15)
    end

    local ok2, result2 = pcall(v4)

    if not ok2 or not result2 then
        return nil
    end

    for _, descendant in result2:GetDescendants() do
        if descendant:IsA("BaseScript") then
            descendant:Destroy()
        end
    end

    return result2
end

local function getRigClone() -- line: 54
    -- upvalues: LocalPlayer (copy), v1 (ref), v2 (ref), buildRigTemplate (copy)
    if v2 == "building" then
        repeat
            task.wait()
        until v2 ~= "building"
    end

    if not v1 then
        v2 = "building"
        v1 = buildRigTemplate()
        v2 = "done"
    end

    if v1 then
        return v1:Clone()
    end

    local Character = LocalPlayer.Character

    if Character and Character:FindFirstChildOfClass("Humanoid") then
        local Archivable = Character.Archivable

        Character.Archivable = true

        local function v5() -- line: 70
            -- upvalues: Character (copy)
            return Character:Clone()
        end

        local ok, result = pcall(v5)

        Character.Archivable = Archivable

        if ok and result then
            return result
        end
    end

    return nil
end

local function makeCatalogChip(p1, p2) -- line: 81
    -- upvalues: Theme (copy), Children (copy)
    return p1:New("Frame")({
        Name = "CatalogChip",
        BackgroundColor3 = Theme.Color.NeutralStroke,
        LayoutOrder = 2,
        Size = UDim2.new(1, 0, 0, 30),
        [Children] = {
            p1:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            p1:New("UIPadding")({
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10)
            }),
            p1:New("TextBox")({
                Name = "Link",
                BackgroundTransparency = 1,
                ClearTextOnFocus = false,
                TextEditable = false,
                FontFace = p1:Computed(function(p3) -- line: 98
                    -- upvalues: Theme (copy)
                    return Font.new(p3(Theme.Font.Body), Enum.FontWeight.Medium)
                end),
                Size = UDim2.fromScale(1, 1),
                Text = ("roblox.com/catalog/%*"):format(p2),
                TextColor3 = Theme.Color.NeutralContentDark,
                TextSize = Theme.TextSize.Body,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextXAlignment = Enum.TextXAlignment.Center
            })
        }
    })
end

return function(p4, p5) -- line: 114
    -- upvalues: Log (copy), Fusion (copy), Theme (copy), Pressable (copy), LoadingSpinner (copy), Icons (copy), promptBulkPurchaseAsync (copy), Children (copy), getRigClone (copy), makeCatalogChip (copy)
    local emoteId = p5.emoteId
    local Emotes = p4:Fuse("everyone", "Emotes")
    local v6 = p4:Value(false)
    local v7 = p4:Computed(function(p6) -- line: 120
        -- upvalues: v6 (copy)
        return not p6(v6)
    end)
    local v8 = p4:New("WorldModel")({
        Name = "ViewportWorldModel"
    })
    local v9 = p4:New("Camera")({
        Name = "ViewportCamera"
    })
    local v10 = p4:New("ViewportFrame")({
        Name = "Preview",
        Ambient = Color3.fromRGB(200, 200, 200),
        BackgroundColor3 = Theme.Color.Neutral,
        CurrentCamera = v9,
        LightColor = Color3.fromRGB(255, 255, 255),
        LightDirection = Vector3.new(-0.4, -0.6, -1),
        LayoutOrder = 1,
        Size = UDim2.new(1, 0, 0, 220),
        [Children] = {
            p4:New("UICorner")({
                CornerRadius = UDim.new(0, 9)
            }),
            p4:New("UIStroke")({
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.NeutralStroke
            }),
            v8,
            v9
        }
    })
    local t1 = {}

    table.insert(p4, function() -- line: 147
        -- upvalues: t1 (copy)
        for _, v12 in t1 do
            pcall(v12)
        end
    end)
    task.spawn(function() -- line: 152
        -- upvalues: p5 (copy), emoteId (copy), Emotes (copy), v8 (copy), v9 (copy), t1 (copy), Log (copy), Fusion (copy), getRigClone (copy)
        local v13 = getRigClone()

        if not v13 then
            Log.debug("emote preview could not build a rig")

            return
        end

        table.insert(t1, function() -- line: 158
            -- upvalues: v13 (copy)
            v13:Destroy()
        end)
        v13:PivotTo(CFrame.new(0, 0, 0))
        v13.Parent = v8

        local HumanoidRootPart = v13:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart then
            v9.FieldOfView = 20
            v9.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, -0.1, 17.25)
        end

        local Humanoid = v13:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            local Animator = Humanoid:FindFirstChildOfClass("Animator")

            if not Animator then
                Animator = Instance.new("Animator")
                Animator.Parent = Humanoid
            end

            local animationId = p5.animationId

            if not animationId then
                for _ = 1, 30 do
                    local v15 = Fusion.peek(Emotes)
                    local v16 = if typeof(v15) == "table" then v15[tostring(emoteId)] else nil

                    animationId = v16 and v16.animationId

                    if animationId then
                        break
                    end

                    task.wait(0.1)
                end
            end

            if animationId then
                task.wait()

                local Animation = Instance.new("Animation")

                Animation.AnimationId = "rbxassetid://" .. tostring(animationId)
                Animation.Parent = Animator

                local function v17() -- line: 193
                    -- upvalues: Animator (ref), Animation (copy)
                    return Animator:LoadAnimation(Animation)
                end

                local ok, result = pcall(v17)

                if not ok or not result then
                    Log.debug((("emote preview could not load animation %*: %*"):format(animationId, result)))
                else
                    result.Looped = true
                    result.Priority = Enum.AnimationPriority.Action
                    result:Play()
                    table.insert(t1, function() -- line: 203
                        -- upvalues: result (copy)
                        result:Stop()
                        result:Destroy()
                    end)
                end
            end
        end
    end)

    local Frame = p4:New("Frame")
    local t2 = {
        Name = "EmotePreview",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = p5.layoutOrder,
        Size = UDim2.fromScale(1, 0)
    }
    local v19 = p4:New("UIListLayout")({
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local v20 = makeCatalogChip(p4, emoteId)
    local v21 = p4:New("TextLabel")({
        Name = "Pitch",
        BackgroundTransparency = 1,
        LayoutOrder = 3,
        RichText = true,
        Text = "Unlock this emote in <b><font color=\"#FFFFFF\">every</font></b> Roblox game",
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y,
        FontFace = p4:Computed(function(p7) -- line: 232
            -- upvalues: Theme (copy)
            return Font.new(p7(Theme.Font.Body), p7(Theme.FontWeight.Body))
        end),
        Size = UDim2.new(1, 0, 0, 0),
        TextColor3 = Theme.Color.NeutralContentDark,
        TextSize = Theme.TextSize.Body,
        TextXAlignment = Enum.TextXAlignment.Center
    })
    local t3 = {
        name = "UnlockButton",
        backgroundColor = Theme.Color.Primary,
        size = UDim2.new(1, 0, 0, 40),
        automaticSize = Enum.AutomaticSize.None,
        layoutOrder = 4,
        interactable = v7,
        onActivate = function() -- onActivate | line: 252
            -- upvalues: emoteId (copy), v6 (copy), Fusion (copy), promptBulkPurchaseAsync (copy)
            if Fusion.peek(v6) then
                return
            end

            v6:set(true)
            task.delay(2, function() -- line: 255
                -- upvalues: v6 (copy)
                v6:set(false)
            end)
            task.spawn(promptBulkPurchaseAsync, emoteId)
        end
    }
    local v22 = p4:New("UICorner")({
        CornerRadius = UDim.new(0, 8)
    })
    local v23 = p4:New("Frame")({
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Visible = v7,
        [Children] = {
            p4:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }),
            p4:New("ImageLabel")({
                Name = "Icon",
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                Image = Icons.Unlock,
                ImageColor3 = Theme.Color.PrimaryContent,
                Size = UDim2.fromOffset(18, 18)
            }),
            p4:New("TextLabel")({
                Name = "Label",
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                Text = "Unlock",
                AutomaticSize = Enum.AutomaticSize.X,
                FontFace = p4:Computed(function(p8) -- line: 287
                    -- upvalues: Theme (copy)
                    return Font.new(p8(Theme.Font.Body), p8(Theme.FontWeight.Bold))
                end),
                TextColor3 = Theme.Color.PrimaryContent,
                TextSize = Theme.TextSize.Subtitle
            })
        }
    })
    local v24 = LoadingSpinner(p4, {
        size = 14,
        thickness = 2,
        paddingY = 0,
        color = Theme.Color.PrimaryContent,
        visible = v6
    })

    v24.AnchorPoint = Vector2.new(0.5, 0.5)
    v24.Position = UDim2.fromScale(0.5, 0.5)
    t3[Children] = { v22, v23, v24 }
    t2[Children] = {
        v19,
        v10,
        v20,
        v21,
        Pressable(p4, t3)
    }

    return Frame(t2)
end
