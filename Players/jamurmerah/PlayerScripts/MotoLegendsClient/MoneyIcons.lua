-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local t1 = {}

local function isMoneyLabel(p1) -- line: 10
    -- upvalues: CollectionService (copy)
    if p1:IsA("TextLabel") or p1:IsA("TextButton") then
        if p1.Name == "MoneyCounter" or p1.Name == "RewardToast" or CollectionService:HasTag(p1, "MoneyText") then
            return true
        end

        if p1.Name == "Reward" then
            return p1:FindFirstAncestorWhichIsA("ScreenGui") ~= nil
        end

        return false
    end

    return false
end

local function strip(p2) -- line: 16
    if p2:find("%$") ~= nil then
        return p2:gsub("%$", ""):gsub("^%s+", ""):gsub("%s+$", ""), true
    end

    return p2, false
end

local function track(p3) -- line: 23
    -- upvalues: t1 (copy), isMoneyLabel (copy)
    local t2, Text, v1, v2

    if t1[p3] then
        v2 = true
    elseif isMoneyLabel(p3) then
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "MoneyIcon"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = "rbxassetid://91281390931284"
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
        ImageLabel.ZIndex = p3.ZIndex + 1
        ImageLabel.Visible = false
        ImageLabel.Parent = p3
        t2 = {
            money = false,
            icon = ImageLabel
        }
        t1[p3] = t2

        local t3 = t2

        local function onText() -- line: 29
            -- upvalues: p3 (copy), t3 (copy)
            local Text = p3.Text
            local v3 = false

            if Text:find("%$") ~= nil then
                Text = Text:gsub("%$", ""):gsub("^%s+", ""):gsub("%s+$", "")
                v3 = true
            end

            local v4

            if v3 then
                t3.money = true
                v4 = p3.Text == Text
            else
                if p3.Text:match("^[%+%-]?[%d%.,]+[kKmMbBtT]?$") and t3.money then
                    return
                end

                t3.money = false
            end

            if not (v3 and v4 or not v3) then
                p3.Text = Text
            end
        end

        p3:GetPropertyChangedSignal("Text"):Connect(onText)
        Text = p3.Text
        v1 = Text:find("%$") ~= nil
        v2 = false
    else
        v2 = true
    end

    if v2 then
        return
    end

    if v1 then
        Text = Text:gsub("%$", ""):gsub("^%s+", ""):gsub("%s+$", "")
        t2.money = true

        if p3.Text ~= Text then
            p3.Text = Text
        end
    elseif not (p3.Text:match("^[%+%-]?[%d%.,]+[kKmMbBtT]?$") and t2.money) then
        t2.money = false
    end

    p3.Destroying:Connect(function() -- line: 36
        -- upvalues: p3 (copy), t1 (copy)
        t1[p3] = nil
    end)
end

local n1 = 0

RunService.RenderStepped:Connect(function(p4) -- line: 39
    -- upvalues: t1 (copy), n1 (ref)
    n1 -= p4

    if not (n1 > 0) then
        n1 = 0.06666666666666667

        for v5, v6 in t1 do
            local icon = v6.icon

            if v5.Parent then
                if icon.Visible ~= v6.money then
                    icon.Visible = v6.money
                end

                if v6.money then
                    local v7 = icon.Size.Y.Offset > 0 and icon.AbsoluteSize.Y > 0 and icon.AbsoluteSize.Y / icon.Size.Y.Offset or 1
                    local v9 = math.max(10, v5.TextBounds.Y / v7 * 1.15)
                    local v10 = v5.AbsoluteSize.X / v7
                    local v11 = v5.TextBounds.X / v7
                    local UIPadding = v5:FindFirstChildOfClass("UIPadding")
                    local v12 = UIPadding and UIPadding.PaddingLeft.Offset or 0
                    local v13 = UIPadding and UIPadding.PaddingRight.Offset or 0
                    local v14 = if v5.TextXAlignment == Enum.TextXAlignment.Left then v12 elseif v5.TextXAlignment == Enum.TextXAlignment.Right then v10 - v13 - v11 else (v10 - v11) / 2
                    local v15 = UDim2.fromOffset(v9, v9)

                    if icon.Size ~= v15 then
                        icon.Size = v15
                    end

                    local v16 = if v5.Name == "Reward" then 1 else 3
                    local v17 = UDim2.new(0, v14 - v9 - v16 - v12, 0.5, 0)

                    if icon.Position ~= v17 then
                        icon.Position = v17
                    end

                    if icon.ImageTransparency ~= v5.TextTransparency then
                        icon.ImageTransparency = v5.TextTransparency
                    end

                    if icon.ZIndex ~= v5.ZIndex + 1 then
                        icon.ZIndex = v5.ZIndex + 1
                    end
                end
            else
                t1[v5] = nil
            end
        end
    end
end)

for _, descendant in PlayerGui:GetDescendants() do
    track(descendant)
end

PlayerGui.DescendantAdded:Connect(track)
