-- https://lua.expert

local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Popups = require(UI.Util.Popups)
local PopupItem = require(UI.Components.PopupItem)
local LayerOrder = require(UI.Config.LayerOrder)
local Children = Fusion.Children
local t1 = {
    top = 1500,
    centre = 2000
}

local function makeBackdrop(p1) -- line: 43
    -- upvalues: ContextActionService (copy), UserInputService (copy), Fusion (copy), Popups (copy), LayerOrder (copy)
    local v1 = p1:Computed(function(p2) -- line: 44
        -- upvalues: Popups (copy)
        for _, v2 in p2(Popups.getList("centre")) do
            if not p2(v2.exiting) then
                return true
            end
        end

        return false
    end)
    local v3 = p1:Spring(p1:Computed(function(p3) -- line: 52
        -- upvalues: v1 (copy)
        if p3(v1) then
            return 0.4
        end

        return 1
    end), 28, 1)

    LayerOrder.addBlocker(function() -- line: 56
        -- upvalues: v1 (copy), Fusion (copy)
        return Fusion.peek(v1)
    end)

    local function dismissAll() -- line: 59
        -- upvalues: Fusion (copy), Popups (copy)
        local t2 = {}

        for _, v4 in Fusion.peek(Popups.getList("centre")) do
            if not Fusion.peek(v4.exiting) then
                table.insert(t2, v4)
            end
        end

        if #t2 == 1 then
            local v5 = t2[1]

            if Fusion.peek(v5.settled) and v5.options and v5.options.userOpened then
                v5.dismissRequested:set(true)
            end
        end
    end

    local v6

    local function isTapInput(p4) -- line: 79
        if p4.UserInputType == Enum.UserInputType.MouseButton1 then
            return true
        end

        return p4.UserInputType == Enum.UserInputType.Touch
    end

    local v7 = p1:New("Frame")({
        Name = "Backdrop",
        Active = false,
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BackgroundTransparency = v3,
        Selectable = false,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 0,
        [Fusion.OnEvent("InputBegan")] = function(p5) -- line: 91
            -- upvalues: v1 (copy), v6 (ref), Fusion (copy)
            if Fusion.peek(v1) and (p5.UserInputType == Enum.UserInputType.MouseButton1 or p5.UserInputType == Enum.UserInputType.Touch) then
                v6 = Vector2.new(p5.Position.X, p5.Position.Y)
            end
        end
    })

    table.insert(p1, UserInputService.InputEnded:Connect(function(p6) -- line: 97
        -- upvalues: v1 (copy), dismissAll (copy), v6 (ref), Fusion (copy)
        local v9 = v6

        if not (v9 and (p6.UserInputType == Enum.UserInputType.MouseButton1 or p6.UserInputType == Enum.UserInputType.Touch)) then
            return
        end

        v6 = nil

        if (Vector2.new(p6.Position.X, p6.Position.Y) - v9).Magnitude <= 12 and Fusion.peek(v1) then
            dismissAll()
        end
    end))

    local function bindSink() -- line: 108
        -- upvalues: ContextActionService (copy)
        ContextActionService:BindActionAtPriority("HDAdminBackdropSink", function() -- line: 109
            return Enum.ContextActionResult.Sink
        end, false, Enum.ContextActionPriority.High.Value, Enum.UserInputType.MouseButton1)
    end

    p1:Observer(v1):onChange(function() -- line: 113
        -- upvalues: v1 (copy), ContextActionService (copy), Fusion (copy)
        if Fusion.peek(v1) then
            ContextActionService:BindActionAtPriority("HDAdminBackdropSink", function() -- line: 109
                return Enum.ContextActionResult.Sink
            end, false, Enum.ContextActionPriority.High.Value, Enum.UserInputType.MouseButton1)
        else
            ContextActionService:UnbindAction("HDAdminBackdropSink")
        end
    end)

    if Fusion.peek(v1) then
        ContextActionService:BindActionAtPriority("HDAdminBackdropSink", function() -- line: 109
            return Enum.ContextActionResult.Sink
        end, false, Enum.ContextActionPriority.High.Value, Enum.UserInputType.MouseButton1)
    end

    table.insert(p1, function() -- line: 123
        -- upvalues: ContextActionService (copy)
        ContextActionService:UnbindAction("HDAdminBackdropSink")
    end)

    return v7
end

local function makeClearAllPill(p7) -- line: 129
    -- upvalues: UI (copy), Fusion (copy), Popups (copy), Children (copy)
    local Pressable = require(UI.Components.Pressable)
    local Theme = require(UI.Util.Theme)
    local Viewport = require(UI.Config.Viewport)
    local sidebar = Popups.getList("sidebar")
    local v11 = p7:Computed(function(p8) -- line: 134
        -- upvalues: sidebar (copy)
        local n1 = 0

        for _, v12 in p8(sidebar) do
            if not p8(v12.exiting) then
                n1 += 1
            end
        end

        return n1
    end)
    local v13 = p7:Computed(function(p9) -- line: 143
        -- upvalues: v11 (copy)
        return p9(v11) >= 5
    end)
    local v14 = p7:Computed(function(p10) -- line: 146
        -- upvalues: Viewport (copy), v13 (copy)
        if p10(v13) then
            return 30 * p10(Viewport.SidebarScale) + 8
        end

        return 0
    end)

    p7:Observer(v14):onChange(function() -- line: 149
        -- upvalues: v14 (copy), Fusion (copy), Popups (copy)
        Popups.sidebarLift:set(Fusion.peek(v14))
    end)
    Popups.sidebarLift:set(Fusion.peek(v14))
    table.insert(p7, function() -- line: 153
        -- upvalues: Popups (copy)
        Popups.sidebarLift:set(0)
    end)

    local function clearAll() -- line: 156
        -- upvalues: sidebar (copy), Fusion (copy)
        for _, v16 in Fusion.peek(sidebar) do
            if not Fusion.peek(v16.exiting) then
                v16.dismissRequested:set(true)
            end
        end
    end

    return Pressable(p7, {
        name = "ClearAllNotices",
        anchorPoint = Vector2.new(1, 1),
        position = UDim2.new(1, -16, 1, -16),
        size = UDim2.fromOffset(0, 30),
        automaticSize = Enum.AutomaticSize.X,
        backgroundColor = Theme.Color.Base,
        backgroundTransparency = 0.05,
        visible = v13,
        zIndex = 1400,
        onActivate = clearAll,
        [Children] = {
            p7:New("UIScale")({
                Scale = Viewport.SidebarScale
            }),
            p7:New("UICorner")({
                CornerRadius = UDim.new(1, 0)
            }),
            p7:New("UIStroke")({
                Thickness = 1,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.NeutralStroke
            }),
            p7:New("UIPadding")({
                PaddingLeft = UDim.new(0, 12),
                PaddingRight = UDim.new(0, 12)
            }),
            p7:New("TextLabel")({
                Name = "Label",
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.X,
                FontFace = p7:Computed(function(p11) -- line: 191
                    -- upvalues: Theme (copy)
                    return Font.new(p11(Theme.Font.Body), Enum.FontWeight.SemiBold)
                end),
                Size = UDim2.new(0, 0, 1, 0),
                Text = p7:Computed(function(p12) -- line: 195
                    -- upvalues: v11 (copy)
                    return (("Clear all notices (%*)"):format((p12(v11))))
                end),
                TextColor3 = Theme.Color.NeutralContentMain,
                TextSize = Theme.TextSize.Body
            })
        }
    })
end

return function(p13, p14) -- line: 207
    -- upvalues: Fusion (copy), Popups (copy), PopupItem (copy), LayerOrder (copy), Children (copy), t1 (copy), makeBackdrop (copy), makeClearAllPill (copy)
    local channel = p14.channel
    local v21 = channel == "sidebar"
    local t6 = {}

    if channel == "centre" then
        table.insert(t6, (makeBackdrop(p13)))
    end

    local v23

    if v21 then
        local host = p14.host

        v23 = host
        makeClearAllPill(p13).Parent = host
    else
        v23 = p13:New("Frame")({
            Name = "PopupLayer_" .. channel,
            Parent = p14.parent,
            Active = false,
            BackgroundTransparency = 1,
            Selectable = false,
            Size = UDim2.fromScale(1, 1),
            ZIndex = t1[channel],
            [Children] = t6
        })
    end

    local t7 = {}

    local function sync() -- line: 235
        -- upvalues: channel (copy), v23 (ref), t7 (copy), v21 (copy), Fusion (copy), Popups (copy), PopupItem (copy), LayerOrder (copy)
        local t8 = {}

        for _, v24 in (Fusion.peek(Popups.getList(channel))) do
            t8[v24.id] = true

            if not t7[v24.id] then
                local v25 = Fusion.scoped(Fusion)
                local v26 = if v21 then "Notice_" .. v24.id else nil
                local v27 = v24.kind == "action"
                local v28 = v24.options ~= nil and v24.options.retrieved == true
                local v29, v30

                if v27 then
                    if not v28 then
                        v30 = "MainPanel"
                    end

                    v29 = "action"
                else
                    v29 = "sidebar"
                end

                local v32 = PopupItem(v25, {
                    entry = v24,
                    zIndex = if v26 then LayerOrder.register(v25, v26, v29, v30) else nil
                })

                v32.Parent = v23

                if v26 then
                    LayerOrder.attach(v26, v32)
                end

                t7[v24.id] = {
                    scope = v25,
                    instance = v32
                }
            end
        end

        for v33, v34 in t7 do
            if not t8[v33] then
                Fusion.doCleanup(v34.scope)
                t7[v33] = nil
            end
        end
    end

    p13:Observer(Popups.getList(channel)):onChange(sync)
    sync()
    table.insert(p13, function() -- line: 267
        -- upvalues: t7 (copy), Fusion (copy)
        for v36, v37 in t7 do
            Fusion.doCleanup(v37.scope)
            t7[v36] = nil
        end
    end)

    return v23
end
