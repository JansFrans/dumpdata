-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Permissions = require(UI.Util.Permissions)
local Children = Fusion.Children
local InputRow = require(script.Parent.InputRow)
local Pressable = require(script.Parent.Pressable)

return function(p1, p2) -- line: 30
    -- upvalues: Fusion (copy), Theme (copy), Permissions (copy), Children (copy), InputRow (copy), Pressable (copy)
    local v1 = p2.optionsArray or { "Yes", "No" }
    local optionsDisplayArray, optionCommands = p2.optionsDisplayArray, p2.optionCommands

    local function labelFor(p3) -- line: 35
        -- upvalues: optionsDisplayArray (copy), v1 (copy)
        if optionsDisplayArray then
            local v2 = table.find(v1, p3)

            if v2 then
                local v3 = optionsDisplayArray[v2]

                if typeof(v3) == "string" and v3 ~= "" then
                    return v3
                end
            end
        end

        return p3
    end

    local v5 = tostring(Fusion.peek(p2.value) or p2.default or v1[1] or "")
    local v6 = p1:Value(v5)

    if p2.value ~= nil and Fusion.peek(p2.value) == nil then
        p2.value:set(v5)
    end

    local t1

    if optionCommands then
        local t2 = {}

        t1 = t2

        for v7, v8 in optionCommands do
            t2[v7] = Permissions.canUseCommand(p1, string.lower(v8))
        end
    end

    p1:Observer(v6):onChange(function() -- line: 65
        -- upvalues: p2 (copy), v6 (copy), Fusion (copy)
        if p2.value then
            p2.value:set(Fusion.peek(v6))
        end
    end)

    if p2.value ~= nil then
        p1:Observer(p2.value):onChange(function() -- line: 72
            -- upvalues: p2 (copy), v6 (copy), Fusion (copy)
            local v9 = Fusion.peek(p2.value)

            if v9 ~= nil then
                local v10 = tostring(v9)

                if v10 ~= Fusion.peek(v6) then
                    v6:set(v10)
                end
            end
        end)
    end

    local v11 = p1:Value(v1)

    return InputRow(p1, {
        title = p2.title or "",
        name = "Options",
        labelSize = p2.labelSize,
        labelTextSize = p2.labelTextSize,
        framePaddingY = 1,
        framePaddingX = 0,
        frameTransparency = 1,
        hideStroke = true,
        [Children] = {
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6)
            }),
            p1:ForValues(v11, function(_, p5, p6) -- line: 102
                -- upvalues: optionsDisplayArray (copy), v1 (copy), v6 (copy), t1 (ref), Fusion (copy), Theme (copy), Children (copy), Pressable (copy)
                local v13 = p5:Computed(function(p7) -- line: 103
                    -- upvalues: p6 (copy), v6 (copy)
                    return p7(v6) == p6
                end)
                local v14 = if t1 then t1[p6] else nil
                local v15 = p5:Computed(function(p8) -- line: 109
                    -- upvalues: v14 (copy)
                    if v14 then
                        return p8(v14) == true
                    end

                    return true
                end)
                local t4 = {
                    name = p6,
                    backgroundColor = p5:Spring(p5:Computed(function(p9) -- line: 114
                        -- upvalues: v13 (copy), v15 (copy), Theme (copy)
                        if not p9(v15) then
                            return p9(Theme.Color.NeutralContent)
                        end

                        if p9(v13) then
                            return (p9(Theme.Color.Primary))
                        end

                        return (p9(Theme.Color.NeutralContent))
                    end), 60, 1),
                    size = UDim2.new(0, 0, 0, 28),
                    layoutOrder = table.find(v1, p6),
                    automaticSize = Enum.AutomaticSize.None,
                    interactable = v15,
                    onActivate = function() -- onActivate | line: 129
                        -- upvalues: p6 (copy), v14 (copy), v6 (copy), Fusion (copy)
                        if not v14 or Fusion.peek(v14) == true then
                            v6:set(p6)
                        end
                    end
                }
                local v17 = p5:New("UIFlexItem")({
                    FlexMode = Enum.UIFlexMode.Fill
                })
                local v18 = p5:New("UICorner")({
                    CornerRadius = UDim.new(0, 8)
                })
                local v19 = p5:New("UIPadding")({
                    PaddingLeft = UDim.new(0, 14),
                    PaddingRight = UDim.new(0, 14)
                })
                local TextLabel = p5:New("TextLabel")
                local t5 = {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 1),
                    FontFace = p5:Computed(function(p10) -- line: 146
                        -- upvalues: Theme (copy)
                        return Font.new(p10(Theme.Font.Body), p10(Theme.FontWeight.Body))
                    end)
                }
                local v20
                local v21 = false

                if optionsDisplayArray then
                    local v22 = table.find(v1, p6)

                    if v22 then
                        v20 = optionsDisplayArray[v22]

                        if typeof(v20) == "string" then
                            v21 = v20 ~= ""
                        end
                    end
                end

                t5.Text = if not v21 then p6 else v20
                t5.TextColor3 = p5:Computed(function(p11) -- line: 150
                    -- upvalues: v13 (copy), v15 (copy), Theme (copy)
                    if not p11(v15) then
                        return p11(Theme.Color.NeutralContentDark)
                    end

                    if p11(v13) then
                        return (p11(Theme.Color.PrimaryContent))
                    end

                    return (p11(Theme.Color.BaseContent))
                end)
                t5.TextSize = Theme.TextSize.Body
                t5.TextTransparency = p5:Computed(function(p12) -- line: 159
                    -- upvalues: v15 (copy)
                    if p12(v15) then
                        return 0
                    end

                    return 0.3
                end)
                t4[Children] = {
                    v17,
                    v18,
                    v19,
                    TextLabel(t5)
                }

                return Pressable(p5, t4)
            end)
        }
    })
end
