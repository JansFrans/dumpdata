-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local Pressable = require(script.Parent.Pressable)
local LoadingSpinner = require(script.Parent.LoadingSpinner)
local SplitRow = require(script.Parent.SplitRow)
local Remote = require(Modules.Objects.Remote)
local Prompt = require(Modules.Prompt)
local RunService = game:GetService("RunService")

require(Modules.References.sharedTypes)

local SendMessage = Remote.get("SendMessage")
local Icons = require(UI.Config.Icons)

return function(p1, p2) -- line: 61
    -- upvalues: Fusion (copy), Theme (copy), Children (copy), Pressable (copy), LoadingSpinner (copy), SplitRow (copy), Prompt (copy), RunService (copy), SendMessage (copy), Icons (copy)
    debug.profilebegin("HD_CommandButton")

    local v1 = p1:Computed(function(p3) -- line: 63
        -- upvalues: p2 (copy)
        local v2 = p2.text and p3(p2.text) or ""
        local v3 = p2.commandName and p3(p2.commandName) or ""
        local commandPrefix = p2.commandPrefix
        local v4, v5

        if commandPrefix then
            v4 = commandPrefix
            v5 = true
        elseif p2.customPrefix then
            local v6 = p3(p2.customPrefix)

            if v6 then
                v4 = v6
                v5 = true
            else
                v5 = false
            end
        else
            v5 = false
        end

        if not v5 then
            v4 = ";"
        end

        if type(v2) ~= "string" or not (v2:len() >= 1) then
            return (("%*%*"):format(v4, v3))
        end

        return v2
    end)
    local v7 = p1:Value(false)
    local n1 = 0
    local v8 = p1:Computed(function(p4) -- line: 77
        -- upvalues: p2 (copy)
        if p2.activeCommands then
            return p4(p2.activeCommands)[p4(p2.commandKey)] == true
        end

        return false
    end)
    local v9 = p1:Value(false)
    local v10 = p1:Value(0)
    local v11 = p1:Value(0)
    local v12 = p1:Value(Fusion.peek(v8))
    local v13 = p1:Value(0)
    local t1 = {}

    t1[1] = nil

    local v14, connection

    local function teardownAnimInfra() -- line: 95
        -- upvalues: v8 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), v13 (copy), t1 (copy), v14 (ref), connection (ref), Fusion (copy)
        if connection then
            connection:Disconnect()
            connection = nil
        end

        if t1[1] then
            Fusion.doCleanup(t1[1])
            t1[1] = nil
        end

        v14 = nil

        local v15 = Fusion.peek(v8)

        v10:set(0)
        v11:set(v15 and 1 or 0)
        v13:set(0)
        v12:set(v15)
        v9:set(false)
    end

    local function ensureAnimInfra() -- line: 113
        -- upvalues: v7 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), v13 (copy), t1 (copy), v14 (ref), connection (ref), teardownAnimInfra (copy), Fusion (copy), RunService (copy)
        if t1[1] then
            return
        end

        t1[1] = Fusion.scoped(Fusion)
        v9:set(true)

        local n2 = 0
        local v16 = t1[1]:Computed(function(p5) -- line: 120
            -- upvalues: v7 (copy)
            if p5(v7) then
                return 1
            end

            return 0
        end)
        local v17 = t1[1]:Spring(v16, 40, 1.8)
        local v18 = t1[1]:Computed(function(p6) -- line: 125
            -- upvalues: v8 (copy)
            if p6(v8) then
                return 1
            end

            return 0
        end)
        local v19 = t1[1]:Spring(v18, 40, 1.8)

        v14 = t1[1]:Value(0)

        local v20 = t1[1]:Spring(v14, 12, 1)

        connection = RunService.Heartbeat:Connect(function() -- line: 133
            -- upvalues: n2 (ref), v17 (copy), v18 (copy), v19 (copy), v20 (copy), v7 (copy), v10 (copy), v11 (copy), v12 (copy), v13 (copy), v14 (ref), teardownAnimInfra (copy), Fusion (copy)
            n2 += 1

            local v21 = Fusion.peek(v17)
            local v22 = Fusion.peek(v19)
            local v23 = Fusion.peek(v20)
            local v24 = Fusion.peek(v18)
            local v25 = Fusion.peek(v14)

            v10:set(v21)
            v11:set(v22)
            v13:set(v23 % 360)

            if v22 >= 0.7 then
                v12:set(true)
            elseif v22 <= 0.05 then
                v12:set(false)
            end

            local v26 = not Fusion.peek(v7) and v21 < 0.01 and math.abs(v22 - v24) < 0.01 and v25 ~= nil and math.abs(v23 - v25) < 0.5

            if v26 or n2 >= 600 then
                teardownAnimInfra()
            end
        end)
    end

    table.insert(p1, function() -- line: 161
        -- upvalues: teardownAnimInfra (copy)
        teardownAnimInfra()
    end)

    local v30 = p1:Computed(function(p7) -- line: 165
        -- upvalues: p2 (copy)
        local v31 = p2.text and p7(p2.text) or ""
        local v32 = p2.commandName and p7(p2.commandName) or ""
        local commandPrefix = p2.commandPrefix
        local v33, v34

        if commandPrefix then
            v33 = commandPrefix
            v34 = true
        elseif p2.customPrefix then
            local v35 = p7(p2.customPrefix)

            if v35 then
                v33 = v35
                v34 = true
            else
                v34 = false
            end
        else
            v34 = false
        end

        if not v34 then
            v33 = ";"
        end

        if type(v31) ~= "string" or not (v31:len() >= 1) then
            return (("%*Un%*"):format(v33, v32))
        end

        return (("%*Un%*"):format(v31:sub(1, 1), (v31:sub(2))))
    end)
    local v36 = p1:Value(false)
    local v37 = p1:Value(false)
    local v38 = p1:Computed(function(p8) -- line: 180
        -- upvalues: v7 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), v36 (copy), v37 (copy), Theme (copy), Pressable (copy)
        local v39 = p8(Theme.Color.Neutral)
        local v40 = p8(Theme.Color.Primary)
        local v41, v42

        if p8(v9) then
            v42 = p8(v10)
            v41 = p8(v11)
        else
            v42 = if p8(v7) then 1 else 0
            v41 = if p8(v8) then 1 else 0
        end

        local v44 = v39:Lerp(v40, (math.min(1, v41 + v42)))

        return Pressable.applyHighlight(p8, v44, v37, v36)
    end)
    local t2

    if p2.trailingButtons then
        t2 = {}

        for _, v45 in p2.trailingButtons do
            local v46 = p1:Value(false)
            local v47 = p1:Value(false)
            local backgroundColor = v45.backgroundColor

            table.insert(t2, {
                name = "TrailingButton",
                fills = false,
                backgroundColor = if backgroundColor then p1:Computed(function(p9) -- line: 206
                    -- upvalues: v46 (copy), v47 (copy), backgroundColor (copy), Pressable (copy)
                    return Pressable.applyHighlight(p9, p9(backgroundColor), v47, v46)
                end) else nil,
                isHovered = v46,
                isPressed = v47,
                onActivate = v45.onActivate,
                [Children] = {
                    p1:New("ImageLabel")({
                        Name = "Icon",
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Image = v45.icon,
                        ImageColor3 = v45.iconColor or Theme.Color.NeutralContentMain,
                        Position = UDim2.fromScale(0.5, 0.5),
                        Size = p1:Computed(function(p10) -- line: 220
                            -- upvalues: Theme (copy)
                            local v49 = math.round(17 * p10(Theme.Layout.ContentScale))

                            return UDim2.fromOffset(v49, v49)
                        end)
                    })
                }
            })
        end
    end

    local t5 = {
        name = v1,
        layoutOrder = p2.layoutOrder,
        size = p2.size or UDim2.new(1, 0, 0, 38),
        left = {
            name = "RunButton",
            fills = false,
            backgroundColor = v38,
            isHovered = v36,
            isPressed = v37,
            onActivate = function() -- onActivate | line: 241
                -- upvalues: p2 (copy), v1 (copy), v7 (copy), n1 (ref), v8 (copy), v13 (copy), v14 (ref), ensureAnimInfra (copy), v30 (copy), Fusion (copy), Prompt (copy), SendMessage (copy)
                local runGate = p2.runGate
                local v50, v51

                if runGate then
                    v50, v51 = p2.runGate()
                end

                if runGate and not v50 then
                    Prompt.warn(v51 or "Text checks failed, please review and retry")

                    return
                end

                local v52 = p2.runOnly == true
                local commandText = p2.commandText
                local commandText2, v53

                if commandText then
                    if typeof(commandText) == "table" then
                        commandText = Fusion.peek(commandText)

                        if commandText then
                            commandText2 = commandText
                            v53 = true
                        else
                            v53 = false
                        end
                    else
                        commandText2 = commandText
                        v53 = true
                    end
                else
                    v53 = false
                end

                if not v53 then
                    commandText2 = nil
                end

                local v54 = if v52 or not Fusion.peek(v8) then commandText2 or Fusion.peek(v1) else Fusion.peek(v30)
                local v55 = p2.chatSource or "ClientRun"

                n1 += 1
                v7:set(true)
                ensureAnimInfra()

                if v14 then
                    local v56 = Fusion.peek(v13) % 360

                    v14:set(v56)

                    local v57 = v14

                    v57:set(v56 + 360)
                end

                local v58 = tick()
                local unlockRole = p2.unlockRole

                if typeof(unlockRole) == "table" then
                    unlockRole = Fusion.peek(unlockRole)
                end

                local _, v59 = SendMessage:invokeServerAsync(v54, v55, if typeof(unlockRole) ~= "string" or unlockRole == "" then nil else {
                    unlockRole = unlockRole
                })

                if not p2.runOnly and v59 and p2.activeCommands then
                    local v60 = v59.activeCommands or {}

                    p2.activeCommands:set(v60)
                end

                local function finalize() -- line: 279
                    -- upvalues: v7 (copy), n1 (ref), Fusion (copy)
                    n1 -= 1

                    if n1 == 0 and Fusion.peek(v7) then
                        v7:set(false)
                    end
                end

                local v61 = 0.3 - (tick() - v58)

                if v61 > 0 then
                    task.delay(v61, finalize)
                else
                    n1 -= 1

                    if n1 == 0 and Fusion.peek(v7) then
                        v7:set(false)
                    end
                end
            end,
            [Children] = {
                p1:New("ImageLabel")({
                    Name = "Icon",
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = p1:Computed(function(p11) -- line: 300
                        -- upvalues: p2 (copy), v8 (copy), v9 (copy), v12 (copy), Icons (copy)
                        if not p2.runOnly then
                            if p11(v9) then
                                if p11(v12) then
                                    return Icons.StopFill
                                end
                            elseif p11(v8) then
                                return Icons.StopFill
                            end
                        end

                        return Icons.RunCommand
                    end),
                    ImageColor3 = p1:Computed(function(p12) -- line: 309
                        -- upvalues: v7 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), Theme (copy)
                        local v62, v63

                        if p12(v9) then
                            v63 = p12(v10)
                            v62 = p12(v11)
                        else
                            v63 = if p12(v7) then 1 else 0
                            v62 = if p12(v8) then 1 else 0
                        end

                        local v65 = math.min(1, v62 + v63)

                        return p12(Theme.Color.BaseContent):Lerp(p12(Theme.Color.PrimaryContent), v65)
                    end),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = p1:Computed(function(p13) -- line: 322
                        -- upvalues: Theme (copy)
                        local v67 = math.round(17 * p13(Theme.Layout.ContentScale))

                        return UDim2.fromOffset(v67, v67)
                    end),
                    Rotation = v13
                })
            }
        },
        center = {
            name = "CommandButton",
            fills = true,
            onActivate = function() -- onActivate | line: 334
                -- upvalues: p2 (copy)
                if p2.onCommandActivate then
                    p2.onCommandActivate()
                end
            end,
            [Children] = {
                p1:New("TextLabel")({
                    Name = "Text",
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(0, 0.5),
                    FontFace = p1:Computed(function(p14) -- line: 344
                        -- upvalues: Theme (copy)
                        return Font.new(p14(Theme.Font.Body), Enum.FontWeight.Medium)
                    end),
                    Position = UDim2.new(0, 10, 0.5, 0),
                    Size = UDim2.new(1, -15, 0.5, -1),
                    Text = v1,
                    TextColor3 = Theme.Color.BaseContent,
                    TextSize = p1:Computed(function(p15) -- line: 351
                        -- upvalues: p2 (copy), Theme (copy)
                        return (math.round((p2.textSize or 17) * p15(Theme.Layout.ContentScale)))
                    end),
                    TextTruncate = Enum.TextTruncate.SplitWord,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Center
                }),
                if p2.loading then p1:New("Frame")({
                    Name = "Loading",
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -8, 0.5, 0),
                    Size = UDim2.fromOffset(18, 18),
                    Visible = p2.loading,
                    [Children] = {
                        LoadingSpinner(p1, {
                            size = 16,
                            thickness = 2,
                            paddingY = 0,
                            visible = p2.loading
                        })
                    }
                }) else nil,
                if p2.nameTag then p1:New("Frame")({
                    Name = "NameTag",
                    AnchorPoint = Vector2.new(1, 0.5),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = p2.nameTagColor or Theme.Color.Primary,
                    Position = UDim2.new(1, -8, 0.5, 0),
                    Size = UDim2.fromOffset(0, 18),
                    [Children] = {
                        p1:New("UICorner")({
                            CornerRadius = UDim.new(1, 0)
                        }),
                        p1:New("UIPadding")({
                            PaddingLeft = UDim.new(0, 7),
                            PaddingRight = UDim.new(0, 7)
                        }),
                        p1:New("TextLabel")({
                            Name = "Label",
                            BackgroundTransparency = 1,
                            AutomaticSize = Enum.AutomaticSize.X,
                            Size = UDim2.fromScale(0, 1),
                            FontFace = p1:Computed(function(p16) -- line: 395
                                -- upvalues: Theme (copy)
                                return Font.new(p16(Theme.Font.Body), p16(Theme.FontWeight.Bold))
                            end),
                            Text = p2.nameTag,
                            TextColor3 = p2.nameTagTextColor or Theme.Color.PrimaryContent,
                            TextSize = Theme.TextSize.Small
                        })
                    }
                }) else nil
            }
        }
    }
    local t14

    if p2.onCopy then
        t14 = {
            name = "CopyButton",
            fills = false
        }

        function t14.onActivate() -- line: 410
            -- upvalues: p2 (copy)
            local onCopy = p2.onCopy

            if onCopy then
                onCopy()
            end
        end

        t14[Children] = {
            p1:New("ImageLabel")({
                Name = "Icon",
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Image = Icons.Copy,
                ImageColor3 = Theme.Color.NeutralContentMain,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = p1:Computed(function(p17) -- line: 422
                    -- upvalues: Theme (copy)
                    local v75 = math.round(17 * p17(Theme.Layout.ContentScale))

                    return UDim2.fromOffset(v75, v75)
                end)
            })
        }
    end

    t5.right = t14
    t5.rights = t2

    local v76 = SplitRow(p1, t5)

    debug.profileend()

    return v76
end
