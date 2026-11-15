-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local InputRow = require(script.Parent.InputRow)
local Pressable = require(script.Parent.Pressable)
local Icons = require(UI.Config.Icons)
local Players = game:GetService("Players")

local function resolveTargetUserId(p1) -- line: 35
    -- upvalues: Fusion (copy), Players (copy)
    if p1 == nil then
        return nil
    end

    local v1 = if typeof(p1) == "table" then Fusion.peek(p1) else p1

    if typeof(v1) == "table" then
        if #v1 ~= 1 then
            return nil
        end

        v1 = v1[1]
    end

    if typeof(v1) == "Instance" and v1:IsA("Player") then
        return v1.UserId
    end

    if typeof(v1) == "number" and v1 > 0 then
        return v1
    end

    if typeof(v1) == "string" then
        local v2 = v1
        local v3 = v1

        if v1:sub(1, 1) == "@" then
            v3 = v1:sub(2)
            v2 = v3
        end

        if #v3 == 0 then
            return nil
        end

        local v4 = tonumber(v3)

        if v4 and v4 > 0 then
            return (math.floor(v4))
        end

        local function v5() -- line: 52
            -- upvalues: v2 (ref), Players (copy)
            return Players:GetUserIdFromNameAsync(v2)
        end

        local ok, result = pcall(v5)

        if ok and typeof(result) == "number" then
            return result
        end
    end

    return nil
end

return function(p2, p3) -- line: 64
    -- upvalues: Modules (copy), Fusion (copy), Theme (copy), Children (copy), InputRow (copy), Pressable (copy), Icons (copy), Players (copy), resolveTargetUserId (copy)
    local v6 = p3.title or ""
    local v7 = p3.maxItems or 10
    local v8 = p3.filterText == true
    local t1 = {}

    local function refreshFilterStatus() -- line: 71
        -- upvalues: p3 (copy), t1 (copy)
        if p3.validationStatus then
            local v9 = false

            for _, v10 in t1 do
                if v10 == false then
                    v9 = true
                    break
                end
            end

            p3.validationStatus:set(not v9 and nil)
        end
    end

    local v11 = if p3.value then Fusion.peek(p3.value) else nil

    if typeof(v11) ~= "table" or not (#v11 > 0) then
        if typeof(p3.default) ~= "table" or not (#p3.default > 0) then
            if typeof(p3.default) ~= "string" or not (#p3.default > 0) then
                v11 = { "" }
            else
                v11 = { p3.default }
            end
        else
            v11 = p3.default
        end
    end

    local n1 = 0

    local function newId() -- line: 87
        -- upvalues: n1 (ref)
        n1 += 1

        return n1
    end

    local v12 = p2:Value({})
    local n2 = -1

    local function rebuild() -- line: 92
        -- upvalues: p3 (copy), v12 (copy), Fusion (copy)
        if p3.value then
            local t2 = {}

            for _, v13 in Fusion.peek(v12) do
                table.insert(t2, Fusion.peek(v13.textVal))
            end

            p3.value:set(t2)
        end
    end

    local function addField(p4) -- line: 102
        -- upvalues: p2 (copy), v7 (copy), n1 (ref), v12 (copy), n2 (ref), rebuild (copy), Fusion (copy)
        local v14 = Fusion.peek(v12)

        if #v14 >= v7 then
            return
        end

        local v15 = p2:Value(p4)

        p2:Observer(v15):onChange(rebuild)

        local t3 = {}

        n1 += 1
        t3.id = n1
        t3.textVal = v15

        if n2 == -1 then
            n2 = t3.id
        end

        local v16 = table.clone(v14)

        table.insert(v16, t3)
        v12:set(v16)
        rebuild()
    end

    local function removeField(p5) -- line: 115
        -- upvalues: v12 (copy), n2 (ref), rebuild (copy), Fusion (copy)
        if p5 == n2 then
            return
        end

        local t4 = {}

        for _, v17 in (Fusion.peek(v12)) do
            if v17.id ~= p5 then
                table.insert(t4, v17)
            end
        end

        v12:set(t4)
        rebuild()
    end

    for _, v18 in v11 do
        addField(v18)
    end

    local v19 = p2:Computed(function(p6) -- line: 130
        -- upvalues: v7 (copy), v12 (copy)
        return #p6(v12) < v7
    end)

    return InputRow(p2, {
        title = v6,
        name = "InputFields",
        labelSize = p3.labelSize,
        labelTextSize = p3.labelTextSize,
        autoHeight = true,
        frameTransparency = 1,
        hideStroke = true,
        framePaddingY = 0,
        framePaddingX = 0,
        labelPaddingTop = 8,
        [Children] = {
            p2:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6)
            }),
            p2:ForValues(v12, function(_, p8, p9) -- line: 154
                -- upvalues: p3 (copy), t1 (copy), n2 (ref), removeField (copy), v8 (copy), Modules (copy), Fusion (copy), Theme (copy), Children (copy), InputRow (copy), Pressable (copy), Icons (copy), Players (copy), resolveTargetUserId (copy)
                local v22 = p9.id ~= n2
                local v23 = p8:Value(false)
                local v24 = p8:Value(nil)
                local n3 = 0
                local v25 = false
                local v26 = false

                table.insert(p8, function() -- line: 161
                    -- upvalues: v25 (ref)
                    v25 = true
                end)

                if v8 then
                    p8:Observer(v24):onChange(function() -- line: 164
                        -- upvalues: p9 (copy), v24 (copy), p3 (copy), t1 (copy), Fusion (copy)
                        t1[p9.id] = Fusion.peek(v24)

                        if p3.validationStatus then
                            local v28 = false

                            for _, v29 in t1 do
                                if v29 == false then
                                    v28 = true
                                    break
                                end
                            end

                            p3.validationStatus:set(not v28 and nil)
                        end
                    end)
                    table.insert(p8, function() -- line: 168
                        -- upvalues: p9 (copy), p3 (copy), t1 (copy)
                        t1[p9.id] = nil

                        if p3.validationStatus then
                            local v31 = false

                            for _, v32 in t1 do
                                if v32 == false then
                                    v31 = true
                                    break
                                end
                            end

                            p3.validationStatus:set(not v31 and nil)
                        end
                    end)
                end

                local function runFilter() -- line: 174
                    -- upvalues: p9 (copy), v24 (copy), n3 (ref), v25 (ref), v26 (ref), p3 (copy), Modules (copy), Fusion (copy), Players (copy), resolveTargetUserId (copy)
                    local v33 = Fusion.peek(p9.textVal)

                    if #v33 == 0 then
                        v24:set(nil)
                    else
                        local filterTextAsync = require(Modules.VerifyUtil.filterTextAsync)
                        local UserId = Players.LocalPlayer and Players.LocalPlayer.UserId or 0
                        local v34 = resolveTargetUserId(p3.firstArgValue)
                        local v35 = n3

                        task.spawn(function() -- line: 181
                            -- upvalues: v33 (copy), filterTextAsync (copy), UserId (copy), v34 (copy), v35 (copy), p9 (copy), v24 (copy), n3 (ref), v25 (ref), v26 (ref)
                            local v36, v37 = filterTextAsync(v33, UserId, v34)

                            if not v25 and n3 == v35 then
                                if v36 then
                                    v26 = true
                                    p9.textVal:set(v37)
                                    v26 = false
                                    v24:set(true)
                                else
                                    v24:set(false)
                                end
                            end
                        end)
                    end
                end

                if v8 then
                    p8:Observer(p9.textVal):onChange(function() -- line: 197
                        -- upvalues: v24 (copy), n3 (ref), v25 (ref), v26 (ref), runFilter (copy)
                        if v25 or v26 then
                            return
                        end

                        v24:set(nil)
                        n3 += 1

                        local v39 = n3

                        task.delay(0.5, function() -- line: 202
                            -- upvalues: v39 (copy), n3 (ref), v25 (ref), runFilter (copy)
                            if not v25 and n3 == v39 then
                                runFilter()
                            end
                        end)
                    end)
                end

                local v47 = InputRow(p8, {
                    name = "Field_" .. p9.id,
                    strokeFocused = v23,
                    [Children] = {
                        p8:New("UIListLayout")({
                            FillDirection = Enum.FillDirection.Horizontal,
                            VerticalAlignment = Enum.VerticalAlignment.Center,
                            SortOrder = Enum.SortOrder.LayoutOrder,
                            Padding = UDim.new(0, 6)
                        }),
                        p8:New("TextBox")({
                            Name = "TextInput",
                            LayoutOrder = 1,
                            AutoLocalize = false,
                            AutomaticSize = Enum.AutomaticSize.Y,
                            BackgroundTransparency = 1,
                            ClearTextOnFocus = false,
                            ClipsDescendants = true,
                            FontFace = p8:Computed(function(p10) -- line: 229
                                -- upvalues: Theme (copy)
                                return Font.new(p10(Theme.Font.Body), p10(Theme.FontWeight.Body))
                            end),
                            PlaceholderColor3 = Theme.Color.NeutralContentDark,
                            PlaceholderText = "Enter text...",
                            Text = p9.textVal,
                            TextColor3 = Theme.Color.BaseContent,
                            TextSize = Theme.TextSize.Subtitle,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            TextYAlignment = Enum.TextYAlignment.Top,
                            [Fusion.OnEvent("Focused")] = function() -- line: 239
                                -- upvalues: v23 (copy)
                                v23:set(true)
                            end,
                            [Fusion.OnEvent("FocusLost")] = function(_) -- line: 242
                                -- upvalues: v23 (copy), n3 (ref), runFilter (copy), v8 (copy)
                                v23:set(false)

                                if v8 then
                                    n3 += 1
                                    runFilter()
                                end
                            end,
                            [Fusion.OnChange("Text")] = function(p12) -- line: 249
                                -- upvalues: p9 (copy)
                                p9.textVal:set(p12)
                            end,
                            [Children] = {
                                p8:New("UIFlexItem")({
                                    FlexMode = Enum.UIFlexMode.Fill
                                }),
                                if v8 then p8:New("UIListLayout")({
                                    FillDirection = Enum.FillDirection.Horizontal,
                                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                                    VerticalAlignment = Enum.VerticalAlignment.Center,
                                    SortOrder = Enum.SortOrder.LayoutOrder
                                }) else nil,
                                if v8 then p8:New("ImageLabel")({
                                    Name = "FilterStatus",
                                    BackgroundTransparency = 1,
                                    Image = p8:Computed(function(p13) -- line: 263
                                        -- upvalues: v24 (copy), Icons (copy)
                                        if p13(v24) == false then
                                            return Icons.ValidationFail
                                        end

                                        return Icons.ValidationSuccess
                                    end),
                                    ImageColor3 = p8:Computed(function(p14) -- line: 266
                                        -- upvalues: v24 (copy), Theme (copy)
                                        if p14(v24) == false then
                                            return (p14(Theme.Color.Error))
                                        end

                                        return (p14(Theme.Color.Success))
                                    end),
                                    Size = UDim2.fromOffset(20, 20),
                                    Visible = p8:Computed(function(p15) -- line: 272
                                        -- upvalues: v24 (copy)
                                        return p15(v24) ~= nil
                                    end)
                                }) else nil
                            }
                        }),
                        if v22 then Pressable(p8, {
                            name = "RemoveButton",
                            layoutOrder = 2,
                            iconSize = 12,
                            size = UDim2.fromOffset(20, 20),
                            iconImage = Icons.Close,
                            iconColor = Theme.Color.NeutralContentDark,
                            onActivate = function() -- onActivate | line: 286
                                -- upvalues: p9 (copy), removeField (copy)
                                removeField(p9.id)
                            end
                        }) else nil
                    }
                })

                if not v8 then
                    return p8:New("Frame")({
                        Name = "Field_" .. p9.id,
                        LayoutOrder = p9.id,
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        Size = UDim2.fromScale(1, 0),
                        [Children] = { v47 }
                    })
                end

                return p8:New("Frame")({
                    Name = "Field_" .. p9.id,
                    LayoutOrder = p9.id,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 0),
                    [Children] = {
                        p8:New("UIListLayout")({
                            FillDirection = Enum.FillDirection.Vertical,
                            HorizontalFlex = Enum.UIFlexAlignment.Fill,
                            SortOrder = Enum.SortOrder.LayoutOrder
                        }),
                        p8:New("Frame")({
                            LayoutOrder = 0,
                            AutomaticSize = Enum.AutomaticSize.Y,
                            BackgroundTransparency = 1,
                            Size = UDim2.fromScale(1, 0),
                            [Children] = { v47 }
                        }),
                        p8:New("TextLabel")({
                            Name = "FilterWarning",
                            LayoutOrder = 1,
                            AutomaticSize = Enum.AutomaticSize.Y,
                            BackgroundTransparency = 1,
                            Size = UDim2.fromScale(1, 0),
                            FontFace = p8:Computed(function(p16) -- line: 331
                                -- upvalues: Theme (copy)
                                return Font.new(p16(Theme.Font.Body), p16(Theme.FontWeight.Regular))
                            end),
                            Text = "Text may fail filter",
                            TextColor3 = Theme.Color.Error,
                            TextSize = p8:Computed(function(p17) -- line: 336
                                -- upvalues: Theme (copy)
                                return p17(Theme.TextSize.Small) * 1.5
                            end),
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Visible = p8:Computed(function(p18) -- line: 340
                                -- upvalues: v24 (copy)
                                return p18(v24) == false
                            end),
                            [Children] = {
                                p8:New("UIPadding")({
                                    PaddingLeft = UDim.new(0, 8),
                                    PaddingRight = UDim.new(0, 8),
                                    PaddingBottom = UDim.new(0, 4)
                                })
                            }
                        })
                    }
                })
            end),
            Pressable(p2, {
                name = "AddButton",
                layoutOrder = 99999,
                size = UDim2.fromOffset(34, 34),
                backgroundColor = Theme.Color.Primary,
                darken = true,
                visible = v19,
                onActivate = function() -- onActivate | line: 362
                    -- upvalues: addField (copy)
                    addField("")
                end,
                [Children] = {
                    p2:New("UICorner")({
                        CornerRadius = UDim.new(0, 6)
                    }),
                    p2:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 6)
                    }),
                    p2:New("TextLabel")({
                        Name = "Label",
                        BackgroundTransparency = 1,
                        Text = "+",
                        TextSize = 30,
                        AutomaticSize = Enum.AutomaticSize.XY,
                        FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Light, Enum.FontStyle.Normal),
                        TextColor3 = Theme.Color.PrimaryContent
                    })
                }
            })
        }
    })
end
