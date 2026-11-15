-- https://lua.expert

local MouseMovement, MouseButton1, Touch = Enum.UserInputType.MouseMovement, Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch
local _ = {
    [Enum.KeyCode.Left] = true,
    [Enum.KeyCode.Right] = true,
    [Enum.KeyCode.Up] = true,
    [Enum.KeyCode.Down] = true
}
local t1 = {
    [Enum.KeyCode.Left] = "Left",
    [Enum.KeyCode.Right] = "Right",
    [Enum.KeyCode.Up] = "Forwards",
    [Enum.KeyCode.Down] = "Backwards",
    [Enum.KeyCode.A] = "Left",
    [Enum.KeyCode.D] = "Right",
    [Enum.KeyCode.W] = "Forwards",
    [Enum.KeyCode.S] = "Backwards",
    [Enum.KeyCode.Space] = "Up",
    [Enum.KeyCode.R] = "Up",
    [Enum.KeyCode.Q] = "Down",
    [Enum.KeyCode.LeftControl] = "Down",
    [Enum.KeyCode.F] = "Down"
}
local v1 = false
local v2 = false
local v3 = Vector3.new(0, 0, 0)
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local ChatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
local t3 = {}
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Signal = require(Modules.Objects.Signal)
local t4 = {}
local createConnection = require(Modules.AssetUtil.createConnection)
local t2 = {}

t2.pressed = Signal.new()
UserInputService.TextBoxFocused:Connect(function() -- line: 32
    -- upvalues: v1 (ref)
    v1 = true
end)
UserInputService.TextBoxFocusReleased:Connect(function() -- line: 35
    -- upvalues: v1 (ref)
    v1 = false
end)

if ChatInputBarConfiguration then
    ChatInputBarConfiguration:GetPropertyChangedSignal("IsFocused"):Connect(function() -- line: 39
        -- upvalues: v1 (ref), ChatInputBarConfiguration (copy)
        v1 = ChatInputBarConfiguration.IsFocused
    end)
end

UserInputService.InputChanged:Connect(function(p1, p2) -- line: 48
    -- upvalues: MouseMovement (copy), Touch (copy), v2 (ref), v3 (ref), UserInputService (copy)
    local v4 = p1.UserInputType == MouseMovement or p1.UserInputType == Touch

    if v4 then
        local v5 = v2 or not p2

        v5 = v5 and not ((v3 - p1.Position).Magnitude >= 150 and UserInputService.TouchEnabled)
        v4 = v5
    end

    if v4 then
        v3 = p1.Position
    end
end)
UserInputService.InputBegan:Connect(function(p3, p4) -- line: 64
    -- upvalues: MouseButton1 (copy), Touch (copy), t1 (copy), t2 (copy), v1 (ref), v2 (ref), v3 (ref), t3 (copy), t4 (copy)
    local KeyCode = p3.KeyCode

    if (p3.UserInputType == MouseButton1 or p3.UserInputType == Touch) and not p4 and not v2 then
        v2 = true
        v3 = p3.Position
        t2.pressed:Fire()
    else
        if v1 then
            return
        end

        local v7 = t1[KeyCode]

        if v7 then
            table.insert(t3, v7)
        end

        local v8 = t4[KeyCode]

        if v8 then
            for _, v9 in v8 do
                v9(p3)
            end
        end
    end
end)
UserInputService.InputEnded:Connect(function(p5, _) -- line: 83
    -- upvalues: MouseButton1 (copy), Touch (copy), t1 (copy), v2 (ref), t3 (copy)
    local v10 = t1[p5.KeyCode]

    if p5.UserInputType == MouseButton1 or p5.UserInputType == Touch then
        v2 = false
    elseif v10 then
        for v11, v12 in t3 do
            if v12 == v10 then
                table.remove(t3, v11)
            end
        end
    end
end)

function t2.isFocused() -- line: 98
    -- upvalues: v1 (ref)
    return v1
end

function t2.isPressing() -- line: 102
    -- upvalues: v2 (ref)
    return v2
end

function t2.getLastHitPosition() -- line: 106
    -- upvalues: v3 (ref)
    return v3
end

function t2.getPressedMovementKeys() -- line: 110
    -- upvalues: t3 (copy)
    return t3
end

function t2.onPressed(p7, p8) -- line: 114
    -- upvalues: t4 (copy), createConnection (copy)
    local v13 = t4[p7]

    if not v13 then
        v13 = {}
        t4[p7] = v13
    end

    table.insert(v13, p8)

    return createConnection(function() -- line: 121
        -- upvalues: p8 (copy), v13 (ref)
        local v14 = table.find(v13, p8)

        if v14 then
            table.remove(v13, v14)
        end
    end)
end

function t2.onDoubleJumped(_, p10) -- line: 129
    -- upvalues: UserInputService (copy), createConnection (copy)
    local n1 = 0
    local n2 = 0
    local connection = UserInputService.JumpRequest:Connect(function() -- line: 134
        -- upvalues: p10 (copy), n1 (ref), n2 (ref)
        local elapsed = os.clock()
        local v15 = elapsed - n1 > 0.1

        n1 = elapsed

        if v15 then
            if elapsed - n2 <= 0.5 then
                n2 = 0
                p10()
            else
                n2 = elapsed
            end
        end
    end)

    return createConnection(function() -- line: 148
        -- upvalues: connection (copy)
        connection:Disconnect()
    end)
end

function t2.getHitPoint(p11) -- line: 153
    -- upvalues: v3 (ref), Players (copy)
    local CurrentCamera = workspace.CurrentCamera
    local Character = Players.LocalPlayer.Character
    local v16 = CurrentCamera:ScreenPointToRay(v3.X, v3.Y)
    local v17 = RaycastParams.new()

    if Character then
        v17.FilterDescendantsInstances = { Character }
        v17.FilterType = Enum.RaycastFilterType.Exclude
    end

    local Origin = v16.Origin
    local v18 = v16.Direction * (p11 or 100)
    local v19 = workspace:Raycast(Origin, v18, v17)

    if v19 then
        return v19.Position, v19.Instance
    end

    return Origin + v18, nil
end

return t2
