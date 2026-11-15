-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children

return function(p1, p2) -- line: 25
    -- upvalues: Theme (copy), Children (copy)
    local checked, disabled = p2.checked, p2.disabled

    local function isDisabled(p3) -- line: 29
        -- upvalues: disabled (copy)
        if disabled == nil then
            return false
        end

        if typeof(disabled) == "table" then
            return p3(disabled) == true
        end

        return disabled == true
    end

    local v1 = p1:Spring(p1:Computed(function(p4) -- line: 36
        -- upvalues: checked (copy), disabled (copy)
        if (disabled == nil or not (if typeof(disabled) == "table" then p4(disabled) == true else disabled == true)) and p4(checked) then
            return 0
        end

        return 1
    end), 20, 1)
    local v2 = p1:Spring(p1:Computed(function(p5) -- line: 44
        -- upvalues: checked (copy), disabled (copy)
        if disabled ~= nil and (if typeof(disabled) == "table" then p5(disabled) == true else disabled == true) then
            return 0.5
        end

        if p5(checked) then
            return 0
        end

        return 1
    end), 20, 1)
    local v3 = p1:Spring(p1:Computed(function(p6) -- line: 52
        -- upvalues: checked (copy)
        if p6(checked) then
            return 0
        end

        return -30
    end), 20, 1)
    local v4 = p1:Spring(p1:Computed(function(p7) -- line: 59
        -- upvalues: checked (copy), disabled (copy), Theme (copy)
        if disabled ~= nil and (if typeof(disabled) == "table" then p7(disabled) == true else disabled == true) then
            return p7(Theme.Color.NeutralStroke)
        end

        if p7(checked) then
            return (p7(Theme.Color.Primary))
        end

        return (p7(Theme.Color.NeutralContentDark))
    end), 40, 1)

    return p1:New("TextButton")({
        Name = "Checkbox",
        Active = false,
        AutoButtonColor = false,
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = Theme.Color.Primary,
        BackgroundTransparency = v1,
        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
        Interactable = false,
        LayoutOrder = p2.layoutOrder or 0,
        Text = "",
        TextColor3 = Color3.new(),
        TextSize = 1,
        Visible = p2.visible == nil or p2.visible,
        [Children] = {
            p1:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            p1:New("UIStroke")({
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = v4
            }),
            if p2.orderNumber == nil then p1:New("ImageLabel")({
                Name = "Checkmark",
                BackgroundTransparency = 1,
                Image = "rbxassetid://13858821963",
                ImageTransparency = v2,
                Rotation = v3,
                Size = UDim2.fromOffset(18, 18)
            }) else nil,
            if p2.orderNumber ~= nil then p1:New("TextLabel")({
                Name = "OrderNumber",
                BackgroundTransparency = 1,
                FontFace = p1:Computed(function(p8) -- line: 100
                    -- upvalues: Theme (copy)
                    return Font.new(p8(Theme.Font.Body), p8(Theme.FontWeight.Bold))
                end),
                Rotation = v3,
                Size = UDim2.fromOffset(18, 18),
                Text = p1:Computed(function(p9) -- line: 105
                    -- upvalues: p2 (copy)
                    local v9 = p9(p2.orderNumber)

                    if v9 then
                        return (tostring(v9))
                    end

                    return ""
                end),
                TextColor3 = Theme.Color.PrimaryContent,
                TextSize = Theme.TextSize.Body,
                TextTransparency = v2,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center
            }) else nil
        }
    })
end
