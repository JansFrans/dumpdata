-- https://lua.expert

local t1 = {
    PhonePortrait = 0.95,
    PhoneLandscape = 0.8,
    TabletPortrait = 1.15,
    TabletLandscape = 1.05,
    Medium = 1,
    Large = 1.6
}
local t2 = {
    PhonePortrait = 0.95,
    PhoneLandscape = 0.8,
    TabletPortrait = 1,
    TabletLandscape = 1,
    Medium = 1,
    Large = 1
}
local t3 = {
    PhonePortrait = 0.5,
    PhoneLandscape = 0.75,
    TabletPortrait = 0.5,
    TabletLandscape = 0.75,
    Medium = 0.725,
    Large = 0.725
}
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local GuiService = game:GetService("GuiService")
local Workspace = game:GetService("Workspace")
local CurrentCamera = Workspace.CurrentCamera
local connection
local Fusion = require(Packages.Fusion)
local fuseState = require(Modules.DataUtil.fuseState)
local v1 = Fusion.scoped({
    Value = Fusion.Value,
    Computed = Fusion.Computed,
    Fuse = fuseState
})
local t4 = {}

t4.MinScreenEdgeGap = 4

local function menuHeightToPixels(p1, p2) -- line: 62
    local v2 = math.clamp(p1, 5, 15)
    local v3 = math.max(p2, 270)
    local v6 = math.max(math.min(416.4, v3 - 60), 210)

    if v2 <= 10 then
        return (v2 - 5) / 5 * (v6 - 200) + 200
    end

    return v6 + (v2 - 10) / 5 * (v3 - v6)
end

local function getTopbarHeight() -- line: 77
    -- upvalues: GuiService (copy)
    return GuiService.TopbarInset.Height
end

local function getViewportInfo() -- line: 81
    -- upvalues: GuiService (copy), Workspace (copy)
    local ViewportSize = Workspace.CurrentCamera.ViewportSize
    local v7 = ViewportSize.X > ViewportSize.Y
    local v8 = math.min(ViewportSize.X, ViewportSize.Y)

    return {
        displaySize = GuiService.ViewportDisplaySize,
        landscape = v7,
        shortAxis = v8,
        rawHeight = ViewportSize.Y,
        availableHeight = ViewportSize.Y - GuiService.TopbarInset.Height
    }
end

local v9 = v1:Value((getViewportInfo()))

local function updateViewport() -- line: 95
    -- upvalues: getViewportInfo (copy), v9 (copy)
    v9:set((getViewportInfo()))
end

local function connectCamera() -- line: 99
    -- upvalues: Workspace (copy), CurrentCamera (ref), connection (ref), getViewportInfo (copy), v9 (copy), updateViewport (copy)
    if connection then
        connection:Disconnect()
    end

    CurrentCamera = Workspace.CurrentCamera
    connection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateViewport)
    v9:set((getViewportInfo()))
end

local function getDisplayKey(p3) -- line: 106
    local displaySize = p3.displaySize
    local DisplaySize = Enum.DisplaySize

    if displaySize == DisplaySize.Small then
        if p3.shortAxis <= 500 then
            if p3.landscape then
                return "PhoneLandscape"
            end

            return "PhonePortrait"
        end

        if p3.landscape then
            return "TabletLandscape"
        end

        return "TabletPortrait"
    end

    if displaySize == DisplaySize.Medium then
        return "Medium"
    end

    return "Large"
end

if connection then
    connection:Disconnect()
end

CurrentCamera = Workspace.CurrentCamera
connection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateViewport)
v9:set((getViewportInfo()))
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(connectCamera)
GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(updateViewport)
t4.ViewportSize = v1:Computed(function(p4) -- line: 131
    -- upvalues: Workspace (copy), v9 (copy)
    local v10 = p4(v9)

    return Vector2.new(Workspace.CurrentCamera.ViewportSize.X, v10.rawHeight)
end)
t4.TopbarHeight = v1:Computed(function(p5) -- line: 136
    -- upvalues: v9 (copy)
    local v11 = p5(v9)

    return v11.rawHeight - v11.availableHeight
end)
t4.Scale = v1:Computed(function(p6) -- line: 141
    -- upvalues: t1 (copy), v9 (copy)
    local v12 = p6(v9)
    local displaySize = v12.displaySize
    local DisplaySize = Enum.DisplaySize

    return t1[if displaySize == DisplaySize.Small then if v12.shortAxis <= 500 then if v12.landscape then "PhoneLandscape" else "PhonePortrait" elseif v12.landscape then "TabletLandscape" else "TabletPortrait" elseif displaySize == DisplaySize.Medium then "Medium" else "Large"]
end)
t4.SidebarScale = v1:Computed(function(p7) -- line: 146
    -- upvalues: t2 (copy), v9 (copy)
    local v14 = p7(v9)
    local displaySize = v14.displaySize
    local DisplaySize = Enum.DisplaySize

    return t2[if displaySize == DisplaySize.Small then if v14.shortAxis <= 500 then if v14.landscape then "PhoneLandscape" else "PhonePortrait" elseif v14.landscape then "TabletLandscape" else "TabletPortrait" elseif displaySize == DisplaySize.Medium then "Medium" else "Large"]
end)
t4.DragMaxHeight = v1:Computed(function(p8) -- line: 152
    -- upvalues: t4 (copy), v9 (copy)
    local v16 = p8(v9)
    local v17 = p8(t4.Scale)

    return (math.floor(v16.rawHeight * 0.88 / v17))
end)
t4.PanelFitHeight = v1:Computed(function(p9) -- line: 160
    -- upvalues: t4 (copy), v9 (copy)
    local v19 = p9(v9)
    local v20 = p9(t4.Scale)

    return (v19.availableHeight - 8) / v20 - 45
end)

local v21 = v1:Fuse("perm", { "YouSettings", "Display", "MenuHeight" })

t4.MenuHeightPixels = v1:Computed(function(p10) -- line: 168
    -- upvalues: t4 (copy), v21 (copy)
    local v22 = p10(t4.DragMaxHeight)
    local v23 = p10(v21)

    if typeof(v23) ~= "number" then
        v23 = 10
    end

    local v24 = math.clamp(v23, 5, 15)
    local v25 = math.max(v22, 270)
    local v28 = math.max(math.min(416.4, v25 - 60), 210)

    if v24 <= 10 then
        return (v24 - 5) / 5 * (v28 - 200) + 200
    end

    return v28 + (v24 - 10) / 5 * (v25 - v28)
end)
t4.MaxContentHeight = v1:Computed(function(p11) -- line: 178
    -- upvalues: t4 (copy)
    return (math.floor((math.min(p11(t4.MenuHeightPixels), p11(t4.DragMaxHeight), p11(t4.PanelFitHeight)))))
end)
t4.MenuDefaultPosition = v1:Computed(function(p12) -- line: 182
    -- upvalues: t3 (copy), t4 (copy), v9 (copy)
    local v32 = p12(v9)
    local v33 = v32.rawHeight - v32.availableHeight
    local displaySize = v32.displaySize
    local DisplaySize = Enum.DisplaySize
    local v35 = t3[if displaySize == DisplaySize.Small then if v32.shortAxis <= 500 then if v32.landscape then "PhoneLandscape" else "PhonePortrait" elseif v32.landscape then "TabletLandscape" else "TabletPortrait" elseif displaySize == DisplaySize.Medium then "Medium" else "Large"]
    local v36 = (45 + p12(t4.MaxContentHeight)) * p12(t4.Scale)

    return UDim2.new(v35, 0, 0.5, (math.round(v33 / 2 - v36 / 2)))
end)

return t4
