-- https://lua.expert

local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Viewport = require(UI.Config.Viewport)
local Children = Fusion.Children
local t1 = {}
local v1 = Fusion.scoped(Fusion)
local v2 = v1:Value("")
local v3 = v1:Value(UDim2.new())
local v4 = v1:Value(Vector2.new(0.5, 1))
local v5 = v1:Value(false)
local v6, v7
local v8 = v1:Value(UDim2.fromOffset(0, 0))
local v9 = nil
local v10
local n1 = 0
local t2 = {}

local function measureText(p1) -- line: 36
    -- upvalues: TextService (copy), Fusion (copy), Theme (copy), t2 (copy)
    local v11 = Fusion.peek(Theme.TextSize.Label)
    local v12 = ("%*:%*"):format(v11, p1)
    local v13 = t2[v12]

    if v13 then
        return v13
    end

    local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

    GetTextBoundsParams.Text = p1
    GetTextBoundsParams.Font = Font.new(Fusion.peek(Theme.Font.Body), Fusion.peek(Theme.FontWeight.Body))
    GetTextBoundsParams.Size = v11
    GetTextBoundsParams.Width = 200

    local function v14() -- line: 46
        -- upvalues: GetTextBoundsParams (copy), TextService (copy)
        return TextService:GetTextBoundsAsync(GetTextBoundsParams)
    end

    local ok, result = pcall(v14)

    if not ok or typeof(result) ~= "Vector2" then
        result = Vector2.new(200, v11 + 4)
    end

    t2[v12] = result

    return result
end

local function placeBubble(p2) -- line: 56
    -- upvalues: Fusion (copy), Viewport (copy), v3 (copy), v4 (copy), v6 (ref)
    local v15 = v6

    if not v15 then
        return
    end

    local v16 = Fusion.peek(Viewport.Scale)

    if typeof(v16) ~= "number" or v16 <= 0 then
        v16 = 1
    end

    local AbsolutePosition, Parent = v15.AbsolutePosition, v15.Parent
    local v17 = if Parent then Parent.AbsolutePosition else AbsolutePosition
    local AbsolutePosition2, AbsoluteSize = p2.AbsolutePosition, p2.AbsoluteSize
    local v18 = v15.AbsoluteSize.X / v16
    local v19 = (AbsolutePosition2.X + AbsoluteSize.X / 2 - AbsolutePosition.X) / v16
    local v20 = if v18 > 228 then math.clamp(v19, 114, v18 - 114) else v18 / 2

    if (AbsolutePosition2.Y - v17.Y) / v16 < 56 then
        v4:set(Vector2.new(0.5, 0))
        v3:set(UDim2.fromOffset(v20, (AbsolutePosition2.Y + AbsoluteSize.Y - AbsolutePosition.Y) / v16 + 4))
    else
        v4:set(Vector2.new(0.5, 1))
        v3:set(UDim2.fromOffset(v20, (AbsolutePosition2.Y - AbsolutePosition.Y) / v16 - 4))
    end
end

function t1.registerHost(p3) -- line: 92
    -- upvalues: Theme (copy), Children (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (ref), v7 (ref), v8 (copy)
    if p3 == v6 then
        return
    end

    v6 = p3

    if v7 then
        v7:Destroy()
        v7 = nil
    end

    v7 = v1:New("TextLabel")({
        Name = "HintBubble",
        Parent = p3,
        AnchorPoint = v4,
        BackgroundColor3 = Theme.Color.Neutral,
        Position = v3,
        Size = v8,
        FontFace = v1:Computed(function(p4) -- line: 106
            -- upvalues: Theme (copy)
            return Font.new(p4(Theme.Font.Body), p4(Theme.FontWeight.Body))
        end),
        Text = v2,
        TextColor3 = Theme.Color.BaseContent,
        TextSize = Theme.TextSize.Label,
        TextWrapped = true,
        Visible = v5,
        ZIndex = 50,
        [Children] = {
            v1:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            v1:New("UIStroke")({
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.NeutralStroke
            }),
            v1:New("UIPadding")({
                PaddingTop = UDim.new(0, 8),
                PaddingBottom = UDim.new(0, 8),
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10)
            })
        }
    })
end

function t1.show(p5, p6, p7) -- line: 131
    -- upvalues: v2 (copy), v5 (copy), v6 (ref), v8 (copy), v9 (ref), v10 (ref), n1 (ref), measureText (copy), placeBubble (copy)
    if not v6 then
        return
    end

    v9 = p5
    v10 = p7
    n1 += 1

    local v22 = n1

    task.spawn(function() -- line: 138
        -- upvalues: p5 (copy), p6 (copy), v22 (copy), v2 (copy), v5 (copy), v8 (copy), v9 (ref), n1 (ref), measureText (copy), placeBubble (copy)
        local v23 = measureText(p6)

        if n1 ~= v22 or v9 ~= p5 then
            return
        end

        v2:set(p6)
        v8:set(UDim2.fromOffset(math.ceil(v23.X) + 20 + 2, math.ceil(v23.Y) + 16))
        placeBubble(p5)
        v5:set(true)
    end)
end

function t1.hide(p8) -- line: 152
    -- upvalues: v5 (copy), v9 (ref), v10 (ref)
    if p8 ~= nil and p8 ~= v9 then
        return
    end

    v9 = nil
    v10 = nil
    v5:set(false)
end

function t1.owner() -- line: 159
    -- upvalues: v9 (ref)
    return v9
end

function t1.via() -- line: 163
    -- upvalues: v10 (ref)
    return v10
end

UserInputService.InputBegan:Connect(function(p9) -- line: 171
    -- upvalues: Fusion (copy), t1 (copy), v5 (copy), v9 (ref)
    if not (Fusion.peek(v5) and (p9.UserInputType == Enum.UserInputType.MouseButton1 or p9.UserInputType == Enum.UserInputType.Touch)) then
        return
    end

    local v25 = v9

    if v25 then
        local AbsolutePosition, AbsoluteSize = v25.AbsolutePosition, v25.AbsoluteSize
        local X, Y = p9.Position.X, p9.Position.Y

        if AbsolutePosition.X <= X and X <= AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y <= Y and Y <= AbsolutePosition.Y + AbsoluteSize.Y then
            return
        end
    end

    t1.hide(nil)
end)

return t1
