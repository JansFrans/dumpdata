-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local RunService = game:GetService("RunService")
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Pressable = require(UI.Components.Pressable)
local Children = Fusion.Children
local t1 = {
    Color3.fromRGB(220, 30, 30),
    Color3.fromRGB(220, 93, 29),
    Color3.fromRGB(188, 161, 23),
    Color3.fromRGB(107, 186, 22),
    Color3.fromRGB(19, 179, 46),
    Color3.fromRGB(20, 197, 197),
    Color3.fromRGB(24, 120, 255),
    Color3.fromRGB(101, 24, 255),
    Color3.fromRGB(217, 24, 255),
    Color3.fromRGB(255, 24, 128)
}
local v1 = Color3.fromRGB(175, 175, 175)

local function quartOut(p1) -- line: 54
    local v2 = 1 - p1

    return 1 - v2 * v2 * v2 * v2
end

local function shuffledPalette(p2) -- line: 59
    -- upvalues: t1 (copy)
    local v3 = table.clone(t1)

    if p2 ~= nil then
        local n1 = 0

        for i = 1, #p2 do
            n1 = (n1 * 31 + string.byte(p2, i)) % 2147483647
        end

        local v5 = Random.new(n1)

        for i = #v3, 2, -1 do
            local v6 = v5:NextInteger(1, i)
            local v7 = v3[v6]
            local v8 = v3[i]

            v3[i] = v7
            v3[v6] = v8
        end
    end

    return v3
end

local function answerColor(p3, p4) -- line: 76
    return p3[(p4 - 1) % #p3 + 1]
end

local function makeVotingRow(p5, p6, p7, p8, p9, p10, p11) -- line: 80
    -- upvalues: Theme (copy), Pressable (copy), Children (copy)
    local v9 = p5:Computed(function(p12) -- line: 81
        -- upvalues: p6 (copy), p9 (copy)
        return p12(p9) == p6
    end)

    return Pressable(p5, {
        name = "Option_" .. p6,
        backgroundColor = Theme.Color.Neutral,
        layoutOrder = p6,
        size = UDim2.new(1, 0, 0, 38),
        interactable = p10,
        onActivate = p11,
        [Children] = {
            p5:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            p5:New("UIStroke")({
                Thickness = 2,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.Primary,
                Transparency = p5:Computed(function(p13) -- line: 98
                    -- upvalues: v9 (copy)
                    if p13(v9) then
                        return 0
                    end

                    return 1
                end)
            }),
            p5:New("UIPadding")({
                PaddingLeft = UDim.new(0, 12),
                PaddingRight = UDim.new(0, 12)
            }),
            p5:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.None,
                VerticalFlex = Enum.UIFlexAlignment.None,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10)
            }),
            p5:New("Frame")({
                Name = "Dot",
                BackgroundColor3 = p8,
                LayoutOrder = 1,
                Size = UDim2.fromOffset(14, 14),
                [Children] = {
                    p5:New("UICorner")({
                        CornerRadius = UDim.new(1, 0)
                    })
                }
            }),
            p5:New("TextLabel")({
                Name = "Label",
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                FontFace = p5:Computed(function(p14) -- line: 129
                    -- upvalues: v9 (copy), Theme (copy)
                    return Font.new(p14(Theme.Font.Body), if p14(v9) then Enum.FontWeight.Bold else p14(Theme.FontWeight.Body))
                end),
                Size = UDim2.new(1, -24, 1, 0),
                Text = p7,
                TextColor3 = Theme.Color.BaseContent,
                TextSize = Theme.TextSize.Body,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        }
    })
end

local function makeResultRow(p15, p16, p17, p18, p19) -- line: 144
    -- upvalues: Theme (copy), Children (copy)
    local v15 = (p16 - 1) * 0.1
    local v16 = p15:Computed(function(p20) -- line: 146
        -- upvalues: p19 (copy), v15 (copy)
        local v18 = 1 - math.clamp((p20(p19) - v15) / 2, 0, 1)

        return 1 - v18 * v18 * v18 * v18
    end)

    return p15:New("Frame")({
        Name = "Result_" .. p16,
        BackgroundColor3 = Theme.Color.Neutral,
        LayoutOrder = p16,
        Size = UDim2.new(1, 0, 0, 44),
        [Children] = {
            p15:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            p15:New("UIPadding")({
                PaddingTop = UDim.new(0, 7),
                PaddingBottom = UDim.new(0, 8),
                PaddingLeft = UDim.new(0, 12),
                PaddingRight = UDim.new(0, 12)
            }),
            p15:New("TextLabel")({
                Name = "Label",
                BackgroundTransparency = 1,
                FontFace = p15:Computed(function(p21) -- line: 168
                    -- upvalues: Theme (copy)
                    return Font.new(p21(Theme.Font.Body), p21(Theme.FontWeight.Body))
                end),
                Size = UDim2.new(1, -60, 0, 16),
                Text = p17.answer,
                TextColor3 = Theme.Color.BaseContent,
                TextSize = Theme.TextSize.Label,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            p15:New("TextLabel")({
                Name = "Votes",
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0),
                FontFace = p15:Computed(function(p22) -- line: 183
                    -- upvalues: Theme (copy)
                    return Font.new(p22(Theme.Font.Body), Enum.FontWeight.Bold)
                end),
                Position = UDim2.new(1, 0, 0, 0),
                Size = UDim2.fromOffset(56, 16),
                Text = p15:Computed(function(p23) -- line: 188
                    -- upvalues: p17 (copy), v16 (copy)
                    return (tostring((math.round(p23(v16) * p17.votes))))
                end),
                TextColor3 = Theme.Color.NeutralContentMain,
                TextSize = Theme.TextSize.Label,
                TextXAlignment = Enum.TextXAlignment.Right
            }),
            p15:New("Frame")({
                Name = "Track",
                AnchorPoint = Vector2.new(0, 1),
                BackgroundColor3 = Theme.Color.NeutralContent,
                Position = UDim2.new(0, 0, 1, 0),
                Size = UDim2.new(1, 0, 0, 6),
                [Children] = {
                    p15:New("UICorner")({
                        CornerRadius = UDim.new(1, 0)
                    }),
                    p15:New("Frame")({
                        Name = "Fill",
                        BackgroundColor3 = p18,
                        Size = p15:Computed(function(p24) -- line: 209
                            -- upvalues: p17 (copy), v16 (copy)
                            return UDim2.new(p24(v16) * p17.percentage, 0, 1, 0)
                        end),
                        [Children] = {
                            p15:New("UICorner")({
                                CornerRadius = UDim.new(1, 0)
                            })
                        }
                    })
                }
            })
        }
    })
end

return function(p25, p26) -- line: 225
    -- upvalues: RunService (copy), Theme (copy), Children (copy), v1 (copy), shuffledPalette (copy), makeVotingRow (copy), makeResultRow (copy)
    local t9 = {
        p25:New("UIListLayout")({
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalFlex = Enum.UIFlexAlignment.None,
            VerticalFlex = Enum.UIFlexAlignment.None,
            Padding = UDim.new(0, 6)
        })
    }
    local v26 = shuffledPalette(p26.colorSeed)

    if p26.mode == "voting" then
        local v27 = p26.options or {}
        local v28 = p26.votedIndex or p25:Value(nil)
        local v29 = p26.endTime or os.clock() + 20
        local v30 = p26.preview ~= true

        for v31, v32 in v27 do
            table.insert(t9, makeVotingRow(p25, v31, v32, v26[(v31 - 1) % #v26 + 1], v28, v30, function() -- line: 243
                -- upvalues: p26 (copy), v31 (copy), v29 (copy)
                if not (os.clock() >= v29) and p26.onVote then
                    p26.onVote(v31)
                end
            end))
        end

        local v37 = p25:Value((math.max(math.ceil(v29 - os.clock()), 0)))
        local connection = RunService.Heartbeat:Connect(function() -- line: 254
            -- upvalues: v37 (copy), v29 (copy)
            v37:set((math.max(math.ceil(v29 - os.clock()), 0)))
        end)

        table.insert(p25, function() -- line: 257
            -- upvalues: connection (copy)
            connection:Disconnect()
        end)
        table.insert(t9, p25:New("TextLabel")({
            Name = "Countdown",
            BackgroundTransparency = 1,
            LayoutOrder = 100,
            FontFace = p25:Computed(function(p27) -- line: 263
                -- upvalues: Theme (copy)
                return Font.new(p27(Theme.Font.Body), Enum.FontWeight.Medium)
            end),
            Size = UDim2.new(1, 0, 0, 16),
            Text = p25:Computed(function(p28) -- line: 268
                -- upvalues: v37 (copy)
                local v41 = p28(v37)

                if v41 > 0 then
                    return (("Ends in %*s"):format(v41))
                end

                return "Vote ended"
            end),
            TextColor3 = Theme.Color.NeutralContentDark,
            TextSize = Theme.TextSize.Small,
            TextXAlignment = Enum.TextXAlignment.Left
        }))
    else
        local v42 = p26.results or {}
        local v43 = p25:Value(0)
        local elapsed = os.clock()
        local v44 = #v42 * 0.1 + 2 + 0.1
        local connection

        connection = RunService.Heartbeat:Connect(function() -- line: 283
            -- upvalues: v43 (copy), elapsed (copy), v44 (copy), connection (ref)
            local v45 = os.clock() - elapsed

            v43:set(v45)

            if not (v44 < v45 and connection) then
                return
            end

            connection:Disconnect()
            connection = nil
        end)
        table.insert(p25, function() -- line: 291
            -- upvalues: connection (ref)
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end)

        for v47, v48 in v42 do
            table.insert(t9, makeResultRow(p25, v47, v48, if v47 == #v42 then v1 else v26[(v47 - 1) % #v26 + 1], v43))
        end
    end

    return p25:New("Frame")({
        Name = "VoteBody",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = p26.layoutOrder or 5,
        Size = UDim2.new(1, 0, 0, 0),
        [Children] = t9
    })
end
