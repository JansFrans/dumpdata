-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local InputRow = require(script.Parent.InputRow)
local Icons = require(UI.Config.Icons)
local Players = game:GetService("Players")

local function resolveTargetUserId(p1) -- line: 36
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

        local function v5() -- line: 55
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

return function(p2, p3) -- line: 67
    -- upvalues: Modules (copy), Fusion (copy), Theme (copy), Children (copy), InputRow (copy), Icons (copy), Players (copy), resolveTargetUserId (copy)
    local v6 = p3.title or "Text"
    local v7 = p3.filterText == true
    local v8 = p3.mustBeStringSafe == true
    local v9 = p3.preventWhitespaces == true
    local verifier = p3.verifier
    local v10 = v7 or v8
    local v11 = false

    table.insert(p2, function() -- line: 77
        -- upvalues: v11 (ref)
        v11 = true
    end)

    local v13 = p2:Value(false)
    local v14 = false
    local v15 = if p3.value == nil then p3.default else Fusion.peek(p3.value)
    local v16 = p2:Value(if v15 == nil then "" else tostring(v15))
    local v17 = Fusion.peek(v16)

    if p3.value ~= nil then
        p2:Observer(p3.value):onChange(function() -- line: 91
            -- upvalues: p3 (copy), v13 (copy), v16 (copy), v17 (ref), Fusion (copy)
            if Fusion.peek(v13) == true then
                return
            end

            local v18 = Fusion.peek(p3.value)

            if v18 ~= nil then
                local v19 = tostring(v18)

                v17 = v19

                if v19 ~= Fusion.peek(v16) then
                    v16:set(v19)
                end
            end
        end)
    end

    local v20 = p2:Value(nil)
    local v21 = p2:Value(nil)
    local v22 = p2:Value(nil)
    local v23 = p2:Value("")

    local function updateValidationState() -- line: 108
        -- upvalues: p3 (copy), v20 (copy), v21 (copy), v22 (copy), v23 (copy), v7 (copy), v8 (copy), Fusion (copy)
        local v24 = Fusion.peek(v20)
        local v25 = Fusion.peek(v21)

        if v24 == false then
            v22:set(false)
            v23:set("Simple characters only")
        elseif v25 == false then
            v22:set(false)
            v23:set("Text may fail filter")
        elseif (not v8 or v24 ~= true) and (not v7 or v25 ~= true) then
            v22:set(nil)
        elseif (not v8 or v24 == true) and (not v7 or v25 == true) then
            v22:set(true)
        else
            v22:set(nil)
        end

        if p3.validationStatus then
            p3.validationStatus:set(Fusion.peek(v22))
        end
    end

    local n1 = 0

    local function runFilter() -- line: 136
        -- upvalues: p3 (copy), v11 (ref), v16 (copy), v20 (copy), v21 (copy), updateValidationState (copy), n1 (ref), v7 (copy), v8 (copy), Modules (copy), Fusion (copy), Players (copy), resolveTargetUserId (copy)
        if not v7 then
            return
        end

        local v26 = Fusion.peek(v16)

        if #v26 == 0 then
            v21:set(nil)
            updateValidationState()
        elseif not v8 or Fusion.peek(v20) ~= false then
            local filterTextAsync = require(Modules.VerifyUtil.filterTextAsync)
            local UserId = Players.LocalPlayer and Players.LocalPlayer.UserId or 0
            local v27 = resolveTargetUserId(p3.firstArgValue)
            local v28 = n1

            task.spawn(function() -- line: 145
                -- upvalues: v26 (copy), filterTextAsync (copy), UserId (copy), v27 (copy), v28 (copy), p3 (copy), v11 (ref), v16 (copy), v21 (copy), updateValidationState (copy), n1 (ref)
                local v29, v30 = filterTextAsync(v26, UserId, v27)

                if not v11 and n1 == v28 then
                    if v29 then
                        v16:set(v30)
                        v21:set(true)

                        if p3.value then
                            p3.value:set(v30)
                        end
                    else
                        v21:set(false)
                    end

                    updateValidationState()
                end
            end)
        end
    end

    local function runStringSafeCheck() -- line: 159
        -- upvalues: v16 (copy), v20 (copy), updateValidationState (copy), v8 (copy), Modules (copy), Fusion (copy)
        if not v8 then
            return true
        end

        local v31 = Fusion.peek(v16)

        if #v31 == 0 then
            v20:set(nil)
            updateValidationState()

            return true
        end

        local v32 = require(Modules.VerifyUtil.isStringSafe)(v31)

        v20:set(not not v32)
        updateValidationState()

        return v32
    end

    p2:Observer(v16):onChange(function() -- line: 170
        -- upvalues: p3 (copy), verifier (copy), v11 (ref), v14 (ref), v16 (copy), v20 (copy), v21 (copy), updateValidationState (copy), n1 (ref), runFilter (copy), runStringSafeCheck (copy), v7 (copy), v9 (copy), Fusion (copy)
        if v11 then
            return
        end

        local v33 = Fusion.peek(v16)
        local v34, v35

        if v9 then
            v34 = v33:gsub("%s", "")
            v35 = v34 == v33
        end

        if not v9 or v35 then
            if p3.value and not verifier then
                p3.value:set(v33)
            end

            if v14 then
                v20:set(nil)
                v21:set(nil)
                updateValidationState()

                local v36 = runStringSafeCheck()

                if v7 and v36 then
                    n1 += 1

                    local v37 = n1

                    task.delay(0.8, function() -- line: 194
                        -- upvalues: v37 (copy), v11 (ref), n1 (ref), runFilter (copy)
                        if not v11 and n1 == v37 then
                            runFilter()
                        end
                    end)
                end
            end
        else
            local defer = task.defer
            local v39 = v34

            defer(function() -- line: 176
                -- upvalues: v39 (copy), v11 (ref), v16 (copy)
                if not v11 then
                    v16:set(v39)
                end
            end)
        end
    end)

    local function onFocusLost() -- line: 201
        -- upvalues: p3 (copy), verifier (copy), v11 (ref), v16 (copy), v17 (ref), n1 (ref), runFilter (copy), runStringSafeCheck (copy), Modules (copy), Fusion (copy)
        n1 += 1

        if runStringSafeCheck() then
            runFilter()
        end

        if not verifier then
            return
        end

        local v40 = Fusion.peek(v16)
        local v41, v42 = verifier(v40)

        if not v41 then
            require(Modules.Prompt).warn((tostring(v42)))
            task.defer(function() -- line: 213
                -- upvalues: p3 (copy), v11 (ref), v16 (copy), v17 (ref)
                if v11 then
                    return
                end

                v16:set(v17)

                if p3.value then
                    p3.value:set(v17)
                end
            end)
        else
            v17 = tostring(v42)

            local v45 = tostring(v42)

            if v45 ~= v40 then
                task.defer(function() -- line: 222
                    -- upvalues: v45 (copy), p3 (copy), v11 (ref), v16 (copy)
                    if not v11 then
                        v16:set(v45)

                        if p3.value then
                            p3.value:set(v45)
                        end
                    end
                end)
            end
        end
    end

    local v49 = InputRow(p2, {
        title = v6,
        name = "TextInput",
        labelSize = p3.labelSize,
        labelTextSize = p3.labelTextSize,
        strokeFocused = v13,
        [Children] = {
            p2:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.None,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6)
            }),
            p2:New("TextBox")({
                Name = "TextInput",
                LayoutOrder = 1,
                AutoLocalize = false,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                ClearTextOnFocus = false,
                ClipsDescendants = true,
                MaxVisibleGraphemes = p3.limitTextLength or -1,
                FontFace = p2:Computed(function(p4) -- line: 258
                    -- upvalues: Theme (copy)
                    return Font.new(p4(Theme.Font.Body), p4(Theme.FontWeight.Body))
                end),
                PlaceholderColor3 = Theme.Color.NeutralContentDark,
                PlaceholderText = v6 ~= "" and "Enter " .. v6 or "Enter text",
                Text = v16,
                TextColor3 = Theme.Color.BaseContent,
                TextSize = Theme.TextSize.Subtitle,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                [Fusion.OnEvent("Focused")] = function() -- line: 269
                    -- upvalues: p3 (copy), v13 (copy), v14 (ref), v16 (copy)
                    v14 = true
                    v13:set(true)

                    if p3.clearTextOnFocus then
                        v16:set("")
                    end
                end,
                [Fusion.OnEvent("FocusLost")] = function() -- line: 276
                    -- upvalues: v13 (copy), onFocusLost (copy)
                    v13:set(false)
                    onFocusLost()
                end,
                [Fusion.OnChange("Text")] = function(p5) -- line: 280
                    -- upvalues: v16 (copy)
                    v16:set(p5)
                end,
                [Children] = {
                    p2:New("UIFlexItem")({
                        FlexMode = Enum.UIFlexMode.Fill
                    })
                }
            }),
            if v10 then p2:New("ImageLabel")({
                Name = "ValidationStatus",
                LayoutOrder = 2,
                BackgroundTransparency = 1,
                Image = p2:Computed(function(p6) -- line: 293
                    -- upvalues: v22 (copy), Icons (copy)
                    if p6(v22) == false then
                        return Icons.ValidationFail
                    end

                    return Icons.ValidationSuccess
                end),
                ImageColor3 = p2:Computed(function(p7) -- line: 296
                    -- upvalues: v22 (copy), Theme (copy)
                    if p7(v22) == false then
                        return (p7(Theme.Color.Error))
                    end

                    return (p7(Theme.Color.Success))
                end),
                Size = UDim2.fromOffset(20, 20),
                Visible = p2:Computed(function(p8) -- line: 302
                    -- upvalues: v22 (copy)
                    return p8(v22) ~= nil
                end)
            }) else nil
        }
    })

    if not v10 then
        return v49
    end

    return p2:New("Frame")({
        Name = "TextInput",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 0),
        [Children] = {
            p2:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            v49,
            p2:New("TextLabel")({
                Name = "FilterWarning",
                LayoutOrder = 1,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                FontFace = p2:Computed(function(p9) -- line: 334
                    -- upvalues: Theme (copy)
                    return Font.new(p9(Theme.Font.Body), p9(Theme.FontWeight.Regular))
                end),
                Text = v23,
                TextColor3 = Theme.Color.Error,
                TextSize = p2:Computed(function(p10) -- line: 339
                    -- upvalues: Theme (copy)
                    return p10(Theme.TextSize.Small) * 1.5
                end),
                TextXAlignment = Enum.TextXAlignment.Left,
                Visible = p2:Computed(function(p11) -- line: 343
                    -- upvalues: v22 (copy)
                    return p11(v22) == false
                end),
                [Children] = {
                    p2:New("UIPadding")({
                        PaddingLeft = UDim.new(0, if p3.labelSize then p3.labelSize.X.Offset + 6 else 78),
                        PaddingRight = UDim.new(0, 8),
                        PaddingBottom = UDim.new(0, 4)
                    })
                }
            })
        }
    })
end
