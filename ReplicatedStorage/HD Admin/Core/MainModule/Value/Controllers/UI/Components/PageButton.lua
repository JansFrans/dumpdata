-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Icons = require(UI.Config.Icons)
local Pages = require(UI.Config.Pages)
local Children = Fusion.Children
local Pressable = require(script.Parent.Pressable)

return function(p1, p2) -- line: 26
    -- upvalues: Theme (copy), Icons (copy), Pages (copy), Children (copy), Pressable (copy)
    local pageId, onActivate, size, dimmed = p2.pageId, p2.onActivate, p2.size, p2.dimmed
    local v1 = p1:Computed(function(p3) -- line: 32
        -- upvalues: pageId (copy), Icons (copy), Pages (copy)
        local v2 = p3(pageId)
        local v3 = Pages[v2] or {
            Id = v2
        }

        return {
            name = v3.Name or v3.Id or v2,
            icon = v3.Icon or Icons.Pages.Settings
        }
    end)

    local function dimmedTransparency(p4) -- line: 41
        -- upvalues: p1 (copy), dimmed (copy)
        return p1:Computed(function(p5) -- line: 42
            -- upvalues: p4 (copy), dimmed (copy)
            if (if typeof(dimmed) == "table" then p5(dimmed) else dimmed) == true then
                return p4 + (1 - p4) * 0.55
            end

            return p4
        end)
    end

    local t2 = {
        name = "PageButton",
        automaticSize = Enum.AutomaticSize.Y,
        backgroundColor = Theme.Color.Neutral,
        clipsDescendants = true,
        size = size or UDim2.fromScale(1, 1),
        onActivate = onActivate
    }
    local v4 = p1:New("UICorner")({
        CornerRadius = UDim.new(0, 9)
    })
    local v5 = p1:New("UIPadding")({
        PaddingTop = UDim.new(0, 16),
        PaddingBottom = UDim.new(0, 16),
        PaddingLeft = UDim.new(0, 16),
        PaddingRight = UDim.new(0, 16)
    })
    local UIStroke = p1:New("UIStroke")
    local t3 = {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Theme.Color.NeutralContent
    }
    local n1 = 0

    t3.Transparency = p1:Computed(function(p6) -- line: 42
        -- upvalues: dimmed (copy), n1 (copy)
        if (if typeof(dimmed) == "table" then p6(dimmed) else dimmed) == true then
            return n1 + (1 - n1) * 0.55
        end

        return n1
    end)

    local v6 = UIStroke(t3)
    local v7 = p1:New("UIListLayout")({
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 13)
    })
    local ImageLabel = p1:New("ImageLabel")
    local t4 = {
        Name = "Icon",
        LayoutOrder = 1,
        BackgroundTransparency = 1,
        Image = p1:Computed(function(p7) -- line: 82
            -- upvalues: v1 (copy)
            return p7(v1).icon
        end),
        ImageColor3 = Theme.Color.BaseContent
    }
    local n2 = 0

    t4.ImageTransparency = p1:Computed(function(p8) -- line: 42
        -- upvalues: dimmed (copy), n2 (copy)
        if (if typeof(dimmed) == "table" then p8(dimmed) else dimmed) == true then
            return n2 + (1 - n2) * 0.55
        end

        return n2
    end)
    t4.Size = UDim2.fromOffset(33, 33)

    local v8 = ImageLabel(t4)
    local TextLabel = p1:New("TextLabel")
    local t5 = {
        Name = "Label",
        LayoutOrder = 2,
        BackgroundTransparency = 1,
        TextWrapped = false,
        AutomaticSize = Enum.AutomaticSize.XY,
        FontFace = p1:Computed(function(p9) -- line: 93
            -- upvalues: Theme (copy)
            return Font.new(p9(Theme.Font.Body), p9(Theme.FontWeight.Body))
        end)
    }

    t5.Text = p1:Computed(function(p10) -- line: 96
        -- upvalues: v1 (copy)
        return p10(v1).name
    end)
    t5.TextColor3 = Theme.Color.BaseContent

    local n3 = 0

    t5.TextTransparency = p1:Computed(function(p11) -- line: 42
        -- upvalues: dimmed (copy), n3 (copy)
        if (if typeof(dimmed) == "table" then p11(dimmed) else dimmed) == true then
            return n3 + (1 - n3) * 0.55
        end

        return n3
    end)
    t5.TextSize = Theme.TextSize.Subtitle
    t5.TextXAlignment = Enum.TextXAlignment.Left
    t2[Children] = {
        v4,
        v5,
        v6,
        v7,
        v8,
        TextLabel(t5)
    }

    return Pressable(p1, t2)
end
