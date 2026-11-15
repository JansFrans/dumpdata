-- https://lua.expert

local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

require(script.Types)

local _script = script
local Reference = require(_script.Reference)
local v1 = Reference.getObject()
local v2 = v1 and v1.Value

if v2 and v2 ~= _script then
    return require(v2)
end

if not v1 then
    Reference.addToReplicatedStorage()
end

local GoodSignal = require(_script.Packages.GoodSignal)
local Janitor = require(_script.Packages.Janitor)
local Utility = require(_script.Utility)
local Themes = require(_script.Features.Themes)
local Gamepad = require(_script.Features.Gamepad)
local Overflow = require(_script.Features.Overflow)
local t1 = {}

t1.__index = t1

local LocalPlayer = Players.LocalPlayer
local Themes2 = _script.Features.Themes
local t2 = {}
local v3 = GoodSignal.new()
local Elements = _script.Elements
local n1 = 0
local t3 = {
    mobile = Enum.PreferredInput.Touch,
    desktop = Enum.PreferredInput.KeyboardAndMouse,
    console = Enum.PreferredInput.Gamepad
}

t1.baseDisplayOrderChanged = GoodSignal.new()
t1.baseDisplayOrder = 10
t1.baseTheme = require(Themes2.Default)
t1.isOldTopbar = false
t1.iconsDictionary = t2
t1.insetHeightChanged = GoodSignal.new()
t1.container = require(Elements.Container)(t1)
t1.topbarEnabled = true
t1.iconAdded = GoodSignal.new()
t1.iconRemoved = GoodSignal.new()
t1.iconChanged = GoodSignal.new()

function t1.getIcons() -- line: 110
    -- upvalues: t1 (copy)
    return t1.iconsDictionary
end

function t1.getIconByUID(p1) -- line: 114
    -- upvalues: t1 (copy)
    return t1.iconsDictionary[p1] or nil
end

function t1.getIcon(p2) -- line: 122
    -- upvalues: t1 (copy), t2 (copy)
    local v4 = t1.getIconByUID(p2)

    if v4 then
        return v4
    end

    for _, v5 in pairs(t2) do
        if v5.name == p2 then
            return v5
        end
    end

    return nil
end

function t1.setTopbarEnabled(p3, p4) -- line: 135
    -- upvalues: t1 (copy)
    local v6 = if typeof(p3) == "boolean" then p3 else t1.topbarEnabled

    if not p4 then
        t1.topbarEnabled = v6
    end

    for _, v7 in pairs(t1.container) do
        v7.Enabled = v6
    end
end

function t1.modifyBaseTheme(p5) -- line: 147
    -- upvalues: Themes (copy), t1 (copy), t2 (copy)
    Themes.checkModifications(p5)

    local v8 = Themes.getModifications(p5)

    for _, v9 in pairs(v8) do
        for _, v10 in pairs(t1.baseTheme) do
            Themes.merge(v10, v9)
        end
    end

    for _, v11 in pairs(t2) do
        v11:setTheme(t1.baseTheme)
    end
end

function t1.setDisplayOrder(p6) -- line: 160
    -- upvalues: t1 (copy)
    t1.baseDisplayOrder = p6
    t1.baseDisplayOrderChanged:Fire(p6)
end

task.defer(Gamepad.start, t1)
task.defer(Overflow.start, t1)
UserInputService.InputBegan:Connect(function(p7) -- line: 172
    -- upvalues: t2 (copy)
    local UserInputType = p7.UserInputType

    if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local v12 = Vector2.new(p7.Position.X, p7.Position.Y)

    local function isInside(p8) -- line: 178
        -- upvalues: v12 (copy)
        local AbsolutePosition, AbsoluteSize = p8.AbsolutePosition, p8.AbsoluteSize

        if v12.X >= AbsolutePosition.X and v12.X <= AbsolutePosition.X + AbsoluteSize.X and v12.Y >= AbsolutePosition.Y then
            return v12.Y <= AbsolutePosition.Y + AbsoluteSize.Y
        end

        return false
    end

    for _, v13 in pairs(t2) do
        local dropdown = v13.dropdown

        if v13.isSelected and dropdown and #v13.dropdownIcons > 0 and v13.closeOnOutsideClick and not v13.locked then
            local widget = v13.widget
            local AbsolutePosition, AbsoluteSize = widget.AbsolutePosition, widget.AbsoluteSize

            if not (v12.X >= AbsolutePosition.X and v12.X <= AbsolutePosition.X + AbsoluteSize.X and v12.Y >= AbsolutePosition.Y and v12.Y <= AbsolutePosition.Y + AbsoluteSize.Y) then
                local AbsolutePosition, AbsoluteSize = dropdown.AbsolutePosition, dropdown.AbsoluteSize

                if not (v12.X >= AbsolutePosition.X and v12.X <= AbsolutePosition.X + AbsoluteSize.X and v12.Y >= AbsolutePosition.Y and v12.Y <= AbsolutePosition.Y + AbsoluteSize.Y) then
                    v13:deselect("OutsideClick", v13)
                end
            end
        end
    end
end)
task.defer(function() -- line: 193
    -- upvalues: _script (copy), t1 (copy), LocalPlayer (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    for _, v14 in pairs(t1.container) do
        v14.Parent = PlayerGui
    end

    require(_script.Attribute)
end)

function t1.new() -- line: 204
    -- upvalues: UserInputService (copy), StarterGui (copy), _script (copy), GoodSignal (copy), Janitor (copy), Utility (copy), t1 (copy), t2 (copy), v3 (copy), Elements (copy), n1 (ref), t3 (copy)
    local t4 = {}

    setmetatable(t4, t1)

    local v15 = Janitor.new()

    t4.janitor = v15
    t4.themesJanitor = v15:add(Janitor.new())
    t4.singleClickJanitor = v15:add(Janitor.new())
    t4.captionJanitor = v15:add(Janitor.new())
    t4.joinJanitor = v15:add(Janitor.new())
    t4.menuJanitor = v15:add(Janitor.new())
    t4.dropdownJanitor = v15:add(Janitor.new())

    local v16 = Utility.generateUID()

    t2[v16] = t4
    v15:add(function() -- line: 221
        -- upvalues: v16 (copy), t2 (copy)
        t2[v16] = nil
    end)
    t4.selected = v15:add(GoodSignal.new())
    t4.deselected = v15:add(GoodSignal.new())
    t4.toggled = v15:add(GoodSignal.new())
    t4.viewingStarted = v15:add(GoodSignal.new())
    t4.viewingEnded = v15:add(GoodSignal.new())
    t4.stateChanged = v15:add(GoodSignal.new())
    t4.notified = v15:add(GoodSignal.new())
    t4.noticeStarted = v15:add(GoodSignal.new())
    t4.noticeChanged = v15:add(GoodSignal.new())
    t4.endNotices = v15:add(GoodSignal.new())
    t4.toggleKeyAdded = v15:add(GoodSignal.new())
    t4.fakeToggleKeyChanged = v15:add(GoodSignal.new())
    t4.alignmentChanged = v15:add(GoodSignal.new())
    t4.updateSize = v15:add(GoodSignal.new())
    t4.resizingComplete = v15:add(GoodSignal.new())
    t4.joinedParent = v15:add(GoodSignal.new())
    t4.menuSet = v15:add(GoodSignal.new())
    t4.dropdownSet = v15:add(GoodSignal.new())
    t4.updateMenu = v15:add(GoodSignal.new())
    t4.startMenuUpdate = v15:add(GoodSignal.new())
    t4.childThemeModified = v15:add(GoodSignal.new())
    t4.indicatorSet = v15:add(GoodSignal.new())
    t4.dropdownChildAdded = v15:add(GoodSignal.new())
    t4.menuChildAdded = v15:add(GoodSignal.new())
    t4.iconModule = _script
    t4.UID = v16
    t4.isEnabled = true
    t4.enabled = t4.isEnabled
    t4.isSelected = false
    t4.isViewing = false
    t4.joinedFrame = false
    t4.parentIconUID = false
    t4.deselectWhenOtherIconSelected = true
    t4.closeOnOutsideClick = true
    t4.destroyOnRespawn = true
    t4.totalNotices = 0
    t4.activeState = "Deselected"
    t4.alignment = ""
    t4.originalAlignment = ""
    t4.appliedTheme = {}
    t4.appearance = {}
    t4.cachedInstances = {}
    t4.cachedNamesToInstances = {}
    t4.cachedCollectives = {}
    t4.bindedToggleKeys = {}
    t4.customBehaviours = {}
    t4.toggleItems = {}
    t4.bindedEvents = {}
    t4.notices = {}
    t4.menuIcons = {}
    t4.dropdownIcons = {}
    t4.childIconsDict = {}
    t4.creationTime = os.clock()
    t4.widget = v15:add(require(Elements.Widget)(t4, t1))
    t4:setAlignment()
    n1 += 1

    local v17 = n1 * 0.01 + 1

    t4:setOrder(v17, "deselected")
    t4:setOrder(v17, "selected")
    t4:setTheme(t1.baseTheme)

    local ClickRegion = t4:getInstance("ClickRegion")
    local v18 = false
    local n2 = 0

    local function handleToggle() -- line: 303
        -- upvalues: t4 (copy), n2 (ref)
        if not t4.locked then
            local v19 = tick()

            if not (v19 - n2 < 0.1) then
                n2 = v19

                if t4.isSelected then
                    t4:deselect("User", t4)
                else
                    t4:select("User", t4)
                end
            end
        end
    end

    ClickRegion.MouseButton1Click:Connect(function() -- line: 322
        -- upvalues: t4 (copy), v18 (ref), n2 (ref)
        v18 = true

        if not t4.locked then
            local v20 = tick()

            if not (v20 - n2 < 0.1) then
                n2 = v20

                if t4.isSelected then
                    t4:deselect("User", t4)
                else
                    t4:select("User", t4)
                end
            end
        end
    end)
    ClickRegion.TouchTap:Connect(function() -- line: 327
        -- upvalues: t4 (copy), v18 (ref), n2 (ref)
        if v18 or t4.locked then
            return
        end

        local v21 = tick()

        if v21 - n2 < 0.1 then
            return
        end

        n2 = v21

        if t4.isSelected then
            t4:deselect("User", t4)
        else
            t4:select("User", t4)
        end
    end)
    v15:add(UserInputService.InputBegan:Connect(function(p9, p10) -- line: 340
        -- upvalues: t4 (copy), n2 (ref)
        if t4.locked or not t4.bindedToggleKeys[p9.KeyCode] or p10 or t4.locked then
            return
        end

        local v22 = tick()

        if v22 - n2 < 0.1 then
            return
        end

        n2 = v22

        if t4.isSelected then
            t4:deselect("User", t4)
        else
            t4:select("User", t4)
        end
    end))

    local function viewingStarted(p11) -- line: 352
        -- upvalues: t4 (copy)
        if t4.locked then
            return
        end

        t4.isViewing = true
        t4.viewingStarted:Fire(true)

        if not p11 then
            t4:setState("Viewing", "User", t4)
        end
    end

    local function viewingEnded() -- line: 362
        -- upvalues: t4 (copy)
        if t4.locked then
            return
        end

        t4.isViewing = false
        t4.viewingEnded:Fire(true)
        t4:setState(nil, "User", t4)
    end

    t4.joinedParent:Connect(function() -- line: 370
        -- upvalues: t4 (copy)
        if t4.isViewing then
            if t4.locked then
                return
            end

            t4.isViewing = false
            t4.viewingEnded:Fire(true)
            t4:setState(nil, "User", t4)
        end
    end)
    ClickRegion.MouseEnter:Connect(function() -- line: 375
        -- upvalues: t4 (copy), UserInputService (copy), t3 (copy)
        local v23 = UserInputService.PreferredInput ~= t3.desktop

        if t4.locked then
            return
        end

        t4.isViewing = true
        t4.viewingStarted:Fire(true)

        if not v23 then
            t4:setState("Viewing", "User", t4)
        end
    end)

    local n3 = 0

    v15:add(UserInputService.TouchEnded:Connect(viewingEnded))
    ClickRegion.MouseLeave:Connect(viewingEnded)
    ClickRegion.SelectionGained:Connect(viewingStarted)
    ClickRegion.SelectionLost:Connect(viewingEnded)
    ClickRegion.MouseButton1Down:Connect(function() -- line: 384
        -- upvalues: t4 (copy), n3 (ref), UserInputService (copy), t3 (copy)
        if t4.locked or UserInputService.PreferredInput ~= t3.mobile then
            return
        end

        n3 += 1

        local v24 = n3

        task.delay(0.2, function() -- line: 388
            -- upvalues: v24 (copy), t4 (copy), n3 (ref)
            if v24 ~= n3 or t4.locked then
                return
            end

            t4.isViewing = true
            t4.viewingStarted:Fire(true)
            t4:setState("Viewing", "User", t4)
        end)
    end)
    ClickRegion.MouseButton1Up:Connect(function() -- line: 395
        -- upvalues: n3 (ref)
        n3 += 1
    end)

    local IconOverlay = t4:getInstance("IconOverlay")

    t4.viewingStarted:Connect(function() -- line: 401
        -- upvalues: t4 (copy), IconOverlay (copy)
        IconOverlay.Visible = not t4.overlayDisabled
    end)
    t4.viewingEnded:Connect(function() -- line: 404
        -- upvalues: IconOverlay (copy)
        IconOverlay.Visible = false
    end)
    v15:add(v3:Connect(function(p12) -- line: 409
        -- upvalues: t4 (copy)
        if p12 ~= t4 and t4.deselectWhenOtherIconSelected and p12.deselectWhenOtherIconSelected then
            t4:deselect("AutoDeselect", p12)
        end
    end))

    local s = debug.info(2, "s")
    local v25 = string.split(s, ".")
    local _game = game
    local v26 = _game
    local v27

    for _, v28 in pairs(v25) do
        v26 = v26:FindFirstChild(v28)

        if not v26 then
            _game = v26
            break
        end

        _game = v26

        if v26:IsA("ScreenGui") then
            v27 = v26
        end
    end

    if _game and v27 and v27.ResetOnSpawn == true then
        t4.originsScreenGui = v27
        v15:add(Utility.localPlayerRespawned(function() -- line: 435
            -- upvalues: t4 (copy)
            if t4.destroyOnRespawn then
                t4:destroy()
            end
        end))
    end

    t4.toggled:Connect(function(p13) -- line: 443
        -- upvalues: t4 (copy), t1 (copy)
        t4.noticeChanged:Fire(t4.totalNotices)

        for v29, _ in pairs(t4.childIconsDict) do
            local v30 = t1.getIconByUID(v29)

            v30.noticeChanged:Fire(v30.totalNotices)

            if not p13 and v30.isSelected then
                for _, _ in pairs(v30.childIconsDict) do
                    v30:deselect("HideParentFeature", t4)
                end
            end
        end
    end)
    t4.selected:Connect(function() -- line: 466
        -- upvalues: t4 (copy), StarterGui (copy)
        if #t4.dropdownIcons > 0 then
            if StarterGui:GetCore("ChatActive") and t4.alignment ~= "Right" then
                t4.chatWasPreviouslyActive = true
                StarterGui:SetCore("ChatActive", false)
            end

            if StarterGui:GetCoreGuiEnabled("PlayerList") and t4.alignment ~= "Left" then
                t4.playerlistWasPreviouslyActive = true
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
            end
        end
    end)
    t4.deselected:Connect(function() -- line: 479
        -- upvalues: t4 (copy), StarterGui (copy)
        if t4.chatWasPreviouslyActive then
            t4.chatWasPreviouslyActive = nil
            StarterGui:SetCore("ChatActive", true)
        end

        if t4.playerlistWasPreviouslyActive then
            t4.playerlistWasPreviouslyActive = nil
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
        end
    end)
    task.delay(0.1, function() -- line: 493
        -- upvalues: t4 (copy)
        if t4.activeState == "Deselected" then
            t4.stateChanged:Fire("Deselected")
            t4:refresh()
        end
    end)
    t1.iconAdded:Fire(t4)

    return t4
end

function t1.setName(p14, p15) -- line: 509
    p14.widget.Name = p15
    p14.name = p15

    return p14
end

function t1.setState(p16, p17, p18, p19) -- line: 515
    -- upvalues: Utility (copy), v3 (copy)
    p17 = p17 or (if p16.isSelected then "Selected" else "Deselected")

    local v32 = Utility.formatStateName(p17)

    if p16.activeState == v32 then
        return
    end

    local isSelected = p16.isSelected

    p16.activeState = v32

    if v32 == "Deselected" then
        p16.isSelected = false

        if isSelected then
            p16.toggled:Fire(false, p18, p19)
            p16.deselected:Fire(p18, p19)
        end

        p16:_setToggleItemsVisible(false, p18, p19)
    elseif v32 == "Selected" then
        p16.isSelected = true

        if not isSelected then
            p16.toggled:Fire(true, p18, p19)
            p16.selected:Fire(p18, p19)
            v3:Fire(p16, p18, p19)
        end

        p16:_setToggleItemsVisible(true, p18, p19)
    end

    p16.stateChanged:Fire(v32, p18, p19)
end

function t1.getInstance(p20, p21) -- line: 548
    -- upvalues: Themes (copy)
    local v33 = p20.cachedNamesToInstances[p21]

    if v33 then
        return v33
    end

    local function cacheInstance(p22, p23) -- line: 556
        -- upvalues: p20 (copy)
        if p20.cachedInstances[p23] then
            return
        end

        local Collective = p23:GetAttribute("Collective")
        local v34 = Collective and p20.cachedCollectives[Collective]

        if v34 then
            table.insert(v34, p23)
        end

        p20.cachedNamesToInstances[p22] = p23
        p20.cachedInstances[p23] = true
        p23.Destroying:Once(function() -- line: 566
            -- upvalues: p22 (copy), p23 (copy), p20 (copy)
            p20.cachedNamesToInstances[p22] = nil
            p20.cachedInstances[p23] = nil
        end)
    end

    local widget = p20.widget

    cacheInstance("Widget", widget)

    if p21 == "Widget" then
        return widget
    end

    local v35, scanChildren

    local function scanChildren2(p24) -- line: 579
        -- upvalues: p20 (copy), p21 (copy), cacheInstance (copy), v35 (ref), scanChildren (ref), Themes (copy)
        for _, child in pairs(p24:GetChildren()) do
            local WidgetUID = child:GetAttribute("WidgetUID")

            if not WidgetUID or WidgetUID == p20.UID then
                local v37 = Themes.getRealInstance(child) or child
                local scanChildren2 = scanChildren

                scanChildren2(v37)

                if v37:IsA("GuiBase") or v37:IsA("UIBase") or v37:IsA("ValueBase") then
                    local Name = v37.Name

                    cacheInstance(Name, v37)

                    if Name == p21 then
                        v35 = v37
                    end
                end
            end
        end
    end

    scanChildren = scanChildren2
    scanChildren2(widget)

    return v35
end

function t1.getCollective(p25, p26) -- line: 608
    local v38 = p25.cachedCollectives[p26]

    if v38 then
        return v38
    end

    local t5 = {}

    for v39, _ in pairs(p25.cachedInstances) do
        if v39:GetAttribute("Collective") == p26 then
            table.insert(t5, v39)
        end
    end

    p25.cachedCollectives[p26] = t5

    return t5
end

function t1.getInstanceOrCollective(p27, p28) -- line: 629
    local v40 = {}
    local v41 = p27:getInstance(p28)

    if v41 then
        table.insert(v40, v41)
    end

    if #v40 == 0 then
        v40 = p27:getCollective(p28)
    end

    return v40
end

function t1.getStateGroup(p29, p30) -- line: 643
    p30 = p30 or p29.activeState

    local v43 = p29.appearance[p30]

    if not v43 then
        v43 = {}
        p29.appearance[p30] = v43
    end

    return v43
end

function t1.refreshAppearance(p31, p32, p33) -- line: 653
    -- upvalues: Themes (copy)
    Themes.refresh(p31, p32, p33)

    return p31
end

function t1.refresh(p34) -- line: 658
    p34:refreshAppearance(p34.widget)
    p34.updateSize:Fire()

    return p34
end

function t1.updateParent(p35) -- line: 664
    -- upvalues: t1 (copy)
    local v44 = t1.getIconByUID(p35.parentIconUID)

    if v44 then
        v44.updateSize:Fire()
    end
end

function t1.setBehaviour(p36, p37, p38, p39, p40) -- line: 671
    local v45 = p37 .. "-" .. p38

    p36.customBehaviours[v45] = p39

    if p40 then
        local v46 = p36:getInstanceOrCollective(p37)

        for _, v47 in pairs(v46) do
            p36:refreshAppearance(v47, p38)
        end
    end
end

function t1.modifyTheme(p41, p42, p43) -- line: 684
    -- upvalues: Themes (copy)
    return p41, (Themes.modify(p41, p42, p43))
end

function t1.modifyChildTheme(p44, p45, p46) -- line: 689
    -- upvalues: t1 (copy)
    p44.childModifications = p45
    p44.childModificationsUID = p46

    for v48, _ in pairs(p44.childIconsDict) do
        t1.getIconByUID(v48):modifyTheme(p45, p46)
    end

    p44.childThemeModified:Fire()

    return p44
end

function t1.removeModification(p47, p48) -- line: 702
    -- upvalues: Themes (copy)
    Themes.remove(p47, p48)

    return p47
end

function t1.removeModificationWith(p49, p50, p51, p52) -- line: 707
    -- upvalues: Themes (copy)
    Themes.removeWith(p49, p50, p51, p52)

    return p49
end

function t1.setTheme(p53, p54) -- line: 712
    -- upvalues: Themes (copy)
    Themes.set(p53, p54)

    return p53
end

function t1.setEnabled(p55, p56) -- line: 717
    p55.isEnabled = p56
    p55.enabled = p55.isEnabled
    p55.widget.Visible = p56
    p55:updateParent()

    return p55
end

function t1.select(p57, p58, p59) -- line: 725
    p57:setState("Selected", p58, p59)

    return p57
end

function t1.deselect(p60, p61, p62) -- line: 730
    p60:setState("Deselected", p61, p62)

    return p60
end

function t1.notify(p63, p64, p65) -- line: 735
    -- upvalues: t1 (copy), Elements (copy)
    if p63.isDestroyed then
        warn("TopbarPlus: notify was called on an icon that has already been destroyed")
    else
        if not p63.notice then
            p63.notice = require(Elements.Notice)(p63, t1)
        end

        p63.noticeStarted:Fire(p64, p65)
    end

    return p63
end

function t1.clearNotices(p66) -- line: 753
    p66.endNotices:Fire()

    return p66
end

function t1.disableOverlay(p67, p68) -- line: 758
    p67.overlayDisabled = p68

    return p67
end

t1.disableStateOverlay = t1.disableOverlay

function t1.setImage(p69, p70, p71) -- line: 764
    -- upvalues: ContentProvider (copy)
    p69:modifyTheme({
        "IconImage",
        "Image",
        p70,
        p71
    })
    task.spawn(function() -- line: 768
        -- upvalues: p70 (copy), ContentProvider (copy)
        local v49 = if typeof(p70) == "Content" then p70.Uri elseif tonumber(p70) then ("rbxassetid://%*"):format(p70) else p70

        if typeof(v49) == "string" and v49 ~= "" and ContentProvider:GetAssetFetchStatus(v49) ~= Enum.AssetFetchStatus.Success then
            local PreloadAsync = ContentProvider.PreloadAsync
            local t6 = {
                v49
            }

            pcall(PreloadAsync, ContentProvider, t6)
        end
    end)

    return p69
end

function t1.setLabel(p72, p73, p74) -- line: 783
    p72:modifyTheme({
        "IconLabel",
        "Text",
        p73,
        p74
    })

    return p72
end

function t1.setOrder(p75, p76, p77) -- line: 788
    local v50 = p76 * 100

    p75:modifyTheme({
        "IconSpot",
        "LayoutOrder",
        v50,
        p77
    })
    p75:modifyTheme({
        "Widget",
        "LayoutOrder",
        v50,
        p77
    })

    return p75
end

function t1.setCornerRadius(p78, p79, p80) -- line: 797
    p78:modifyTheme({
        "IconCorners",
        "CornerRadius",
        p79,
        p80
    })

    return p78
end

function t1.align(p81, p82, p83) -- line: 802
    -- upvalues: t1 (copy)
    local v51 = tostring(p82):lower()

    if v51 == "mid" or v51 == "centre" then
        v51 = "center"
    end

    if v51 ~= "left" and v51 ~= "center" and v51 ~= "right" then
        v51 = "left"
    end

    local TopbarCentered = v51 == "center" and t1.container.TopbarCentered or t1.container.TopbarStandard
    local Holders = TopbarCentered.Holders
    local v52 = string.upper((string.sub(v51, 1, 1))) .. string.sub(v51, 2)

    if not p83 then
        p81.originalAlignment = v52
    end

    local joinedFrame = p81.joinedFrame
    local v53 = Holders[v52]

    p81.screenGui = TopbarCentered
    p81.alignmentHolder = v53

    if not p81.isDestroyed then
        p81.widget.Parent = joinedFrame or v53
    end

    p81.alignment = v52
    p81.alignmentChanged:Fire(v52)
    t1.iconChanged:Fire(p81)

    return p81
end

t1.setAlignment = t1.align

function t1.setLeft(p84) -- line: 831
    p84:setAlignment("Left")

    return p84
end

function t1.setMid(p85) -- line: 836
    p85:setAlignment("Center")

    return p85
end

function t1.setRight(p86) -- line: 841
    p86:setAlignment("Right")

    return p86
end

function t1.setWidth(p87, p88, p89) -- line: 846
    p87:modifyTheme({
        "Widget",
        "DesiredWidth",
        p88,
        p89
    })

    return p87
end

function t1.setImageScale(p90, p91, p92) -- line: 854
    p90:modifyTheme({
        "IconImageScale",
        "Value",
        p91,
        p92
    })

    return p90
end

function t1.setImageRatio(p93, p94, p95) -- line: 859
    p93:modifyTheme({
        "IconImageRatio",
        "AspectRatio",
        p94,
        p95
    })

    return p93
end

function t1.setTextSize(p96, p97, p98) -- line: 864
    p96:modifyTheme({
        "IconLabel",
        "TextSize",
        p97,
        p98
    })

    return p96
end

function t1.setTextFont(p99, p100, p101, p102, p103) -- line: 869
    p101 = p101 or Enum.FontWeight.Regular
    p102 = p102 or Enum.FontStyle.Normal

    local v56 = typeof(p100)
    local v57 = if v56 == "number" then Font.fromId(p100, p101, p102)
        elseif v56 == "EnumItem" then Font.fromEnum(p100)
        elseif v56 == "string" and not p100:match("rbxasset") then Font.fromName(p100, p101, p102)
        else nil

    p99:modifyTheme({
        "IconLabel",
        "FontFace",
        v57 or Font.new(p100, p101, p102),
        p103
    })

    return p99
end

function t1.setTextColor(p104, p105, p106) -- line: 890
    local v58, v59

    if p105 == nil or p105 == "" then
        v59 = false
    elseif type(p105) == "userdata" and typeof(p105) == "Color3" then
        v58 = p105
        v59 = true
    else
        v59 = false
    end

    if not v59 then
        if p105 ~= nil and p105 ~= "" then
            warn("setTextColor item must be a Color3 value! Changed the color to white.")
        end

        v58 = Color3.fromRGB(255, 255, 255)
    end

    p104:modifyTheme({
        "IconLabel",
        "TextColor3",
        v58,
        p106
    })

    return p104
end

function t1.bindToggleItem(p107, p108) -- line: 902
    if not p108:IsA("GuiObject") and not p108:IsA("LayerCollector") then
        error("Toggle item must be a GuiObject or LayerCollector!")
    end

    p107.toggleItems[p108] = true
    p107:_updateSelectionInstances()

    return p107
end

function t1.unbindToggleItem(p109, p110) -- line: 911
    p109.toggleItems[p110] = nil
    p109:_updateSelectionInstances()

    return p109
end

function t1._updateSelectionInstances(p111) -- line: 917
    for v60, _ in pairs(p111.toggleItems) do
        local t7 = {}

        for _, descendant in pairs(v60:GetDescendants()) do
            if (descendant:IsA("TextButton") or descendant:IsA("ImageButton")) and descendant.Active then
                table.insert(t7, descendant)
            end
        end

        p111.toggleItems[v60] = t7
    end
end

function t1._setToggleItemsVisible(p112, p113, _, p115) -- line: 931
    for v61, _ in pairs(p112.toggleItems) do
        if not p115 or p115 == p112 or p115.toggleItems[v61] == nil then
            v61[v61:IsA("LayerCollector") and "Enabled" or "Visible"] = p113
        end
    end
end

function t1.bindEvent(p116, p117, p118) -- line: 943
    local v62 = p116[p117]

    assert(v62 and typeof(v62) == "table" and v62.Connect, "argument[1] must be a valid topbarplus icon event name!")
    assert(typeof(p118) == "function", "argument[2] must be a function!")
    p116.bindedEvents[p117] = v62:Connect(function(...) -- line: 947
        -- upvalues: p116 (copy), p118 (copy)
        p118(p116, ...)
    end)

    return p116
end

function t1.unbindEvent(p119, p120) -- line: 953
    local v65 = p119.bindedEvents[p120]

    if v65 then
        v65:Disconnect()
        p119.bindedEvents[p120] = nil
    end

    return p119
end

function t1.bindToggleKey(p121, p122) -- line: 962
    assert(typeof(p122) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
    p121.bindedToggleKeys[p122] = true
    p121.toggleKeyAdded:Fire(p122)
    p121:setCaption("_hotkey_")

    return p121
end

function t1.unbindToggleKey(p123, p124) -- line: 970
    assert(typeof(p124) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
    p123.bindedToggleKeys[p124] = nil

    return p123
end

function t1.call(p125, p126, ...) -- line: 976
    local v68 = table.pack(...)

    task.spawn(function() -- line: 978
        -- upvalues: p125 (copy), p126 (copy), v68 (copy)
        p126(p125, table.unpack(v68))
    end)

    return p125
end

function t1.addToJanitor(p127, p128, p129, p130) -- line: 984
    p127.janitor:add(p128, p129, p130)

    return p127
end

function t1.lock(p131) -- line: 989
    p131:getInstance("ClickRegion").Visible = false
    p131.locked = true

    return p131
end

function t1.unlock(p132) -- line: 997
    p132:getInstance("ClickRegion").Visible = true
    p132.locked = false

    return p132
end

function t1.debounce(p133, p134) -- line: 1004
    p133:lock()
    task.wait(p134)
    p133:unlock()

    return p133
end

function t1.autoDeselect(p135, p136) -- line: 1011
    if p136 ~= nil then
        p135.deselectWhenOtherIconSelected = p136
    else
        p135.deselectWhenOtherIconSelected = true
    end

    return p135
end

function t1.oneClick(p137, p138) -- line: 1021
    local singleClickJanitor = p137.singleClickJanitor

    singleClickJanitor:clean()

    if p138 or p138 == nil then
        singleClickJanitor:add(p137.selected:Connect(function() -- line: 1027
            -- upvalues: p137 (copy)
            p137:deselect("OneClick", p137)
        end))
    end

    p137.oneClickEnabled = true

    return p137
end

function t1.setCloseOnOutsideClick(p139, p140) -- line: 1035
    p139.closeOnOutsideClick = p140 ~= false

    return p139
end

function t1.setDestroyOnRespawn(p141, p142) -- line: 1041
    p141.destroyOnRespawn = p142 ~= false

    return p141
end

function t1.setNoticeLabel(p143, p144) -- line: 1048
    p143.noticeLabelText = p144
    p143.noticeChanged:Fire(p143.totalNotices)

    return p143
end

function t1.addInstance(p145, p146, p147) -- line: 1055
    assert(typeof(p146) == "Instance" and p146:IsA("GuiObject"), "argument[1] must be a GuiObject!")
    p147 = p147 or "Right"
    assert(p147 == "Left" or p147 == "Right", "argument[2] must be \"Left\" or \"Right\"!")
    p146.LayoutOrder = p147 == "Left" and 1 or 6
    p146.Parent = p145:getInstance("Contents")
    p145.janitor:add(p146)

    local function resize() -- line: 1064
        -- upvalues: p145 (copy)
        p145.updateSize:Fire()
    end

    p145.janitor:add(p146:GetPropertyChangedSignal("AbsoluteSize"):Connect(resize))
    p145.janitor:add(p146:GetPropertyChangedSignal("Visible"):Connect(resize))
    p145:refreshAppearance(p146)
    p145.updateSize:Fire()

    return p145
end

function t1.setCaption(p148, p149) -- line: 1074
    -- upvalues: Elements (copy)
    if p148.isDestroyed then
        warn("TopbarPlus: setCaption was called on an icon that has already been destroyed")
    elseif p149 ~= "_hotkey_" or not p148.captionText then
        local captionJanitor = p148.captionJanitor

        p148.captionJanitor:clean()

        local v72 = if p149 then p149 == "" else nil

        if not p149 or v72 then
            p148.caption = nil
            p148.captionText = nil
        else
            local v73 = captionJanitor:add(require(Elements.Caption)(p148))

            v73:SetAttribute("CaptionText", p149)
            p148.caption = v73
            p148.captionText = p149
        end
    end

    return p148
end

function t1.setCaptionHint(p150, p151) -- line: 1096
    assert(typeof(p151) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
    p150.fakeToggleKey = p151
    p150.fakeToggleKeyChanged:Fire(p151)
    p150:setCaption("_hotkey_")

    return p150
end

function t1.leave(p152) -- line: 1104
    p152.joinJanitor:clean()

    return p152
end

function t1.joinMenu(p153, p154) -- line: 1110
    -- upvalues: Utility (copy)
    Utility.joinFeature(p153, p154, p154.menuIcons, p154:getInstance("Menu"))
    p154.menuChildAdded:Fire(p153)

    return p153
end

function t1.setMenu(p155, p156) -- line: 1116
    p155.menuSet:Fire(p156)

    return p155
end

function t1.setFixedMenu(p157, p158) -- line: 1121
    p157:freezeMenu(p158)
    p157:setMenu(p158)
end

t1.setFrozenMenu = t1.setFixedMenu

function t1.freezeMenu(p159) -- line: 1127
    p159:select("FrozenMenu", p159)
    p159:bindEvent("deselected", function(p160) -- line: 1131
        -- upvalues: p159 (copy)
        p160:select("FrozenMenu", p159)
    end)
    p159:modifyTheme({
        "IconSpot",
        "Visible",
        false
    })
end

function t1.joinDropdown(p161, p162) -- line: 1137
    -- upvalues: Utility (copy)
    p162:getDropdown()
    Utility.joinFeature(p161, p162, p162.dropdownIcons, p162:getInstance("DropdownScroller"))
    p162.dropdownChildAdded:Fire(p161)

    return p161
end

function t1.getDropdown(p163) -- line: 1144
    -- upvalues: Elements (copy)
    local dropdown = p163.dropdown

    if not dropdown then
        dropdown = require(Elements.Dropdown)(p163)
        p163.dropdown = dropdown
        p163:clipOutside(dropdown)
    end

    return dropdown
end

function t1.setDropdown(p164, p165) -- line: 1154
    p164:getDropdown()
    p164.dropdownSet:Fire(p165)

    return p164
end

function t1.clipOutside(p166, p167) -- line: 1160
    -- upvalues: Utility (copy)
    local v75 = Utility.clipOutside(p166, p167)

    p166:refreshAppearance(p167)

    return p166, v75
end

function t1.setIndicator(p168, p169) -- line: 1171
    -- upvalues: t1 (copy), Elements (copy)
    if not p168.indicator then
        p168.indicator = p168.janitor:add(require(Elements.Indicator)(p168, t1))
    end

    p168.indicatorSet:Fire(p169)
end

function t1.convertLabelToNumberSpinner(p170, p171, p172) -- line: 1183
    task.defer(function() -- line: 1184
        -- upvalues: p170 (copy), p171 (copy), p172 (copy)
        local IconLabel = p170:getInstance("IconLabel")

        IconLabel.Transparency = 1
        p171.Parent = IconLabel.Parent
        p171.Size = UDim2.fromScale(1, 1)
        p171.AnchorPoint = Vector2.new(0.5, 0.5)
        p171.Position = UDim2.new(0.5, 0, 0.5, 0)
        p171.TextXAlignment = Enum.TextXAlignment.Center
        p171.ClipsDescendants = false

        local t8 = {
            "FontFace",
            "BorderSizePixel",
            "BorderColor3",
            "Rotation",
            "TextStrokeTransparency",
            "TextStrokeColor3",
            "TextStrokeTransparency",
            "TextColor3"
        }

        for _, v76 in ipairs(t8) do
            p171[v76] = IconLabel[v76]
            p170:addToJanitor(IconLabel:GetPropertyChangedSignal(v76):Connect(function() -- line: 1207
                -- upvalues: IconLabel (copy), v76 (copy), p171 (copy)
                p171[v76] = IconLabel[v76]
            end))
        end

        local function getSpinnerSizeAndDigitCount() -- line: 1214
            -- upvalues: p171 (copy)
            local n4 = 0
            local n5 = 0

            for _, child in p171.Frame:GetChildren() do
                local v77 = string.lower(child.Name)

                if v77 == "digit" or (v77 == "prefix" or v77 == "suffix" or v77 == "comma") and child.Text ~= "" then
                    n4 += child.AbsoluteSize.X
                    n5 += 1
                end
            end

            return n4, n5
        end

        local function getLabelParentContainerXSize() -- line: 1232
            -- upvalues: IconLabel (copy), p171 (copy)
            local IconLabelParent = IconLabel.Parent
            local v78 = IconLabelParent and IconLabelParent.Parent

            if v78 == nil then
                return 0
            end

            if v78.IconImage.Visible == true then
                return p171.Frame.AbsoluteSize.X + IconLabel.Parent.Parent.IconImage.AbsoluteSize.X
            end

            return v78.AbsoluteSize.X
        end

        local function getNumberSpinnerXSize() -- line: 1244
            -- upvalues: p171 (copy)
            return p171.Frame.AbsoluteSize.X
        end

        local function adjustSize() -- line: 1248
            -- upvalues: IconLabel (copy), getSpinnerSizeAndDigitCount (copy), p170 (copy), p171 (copy)
            local v79, v80 = getSpinnerSizeAndDigitCount()

            if v80 < 18 then
                p170:setLabel(p171.Value)
            end

            local X = p171.Frame.AbsoluteSize.X

            while v79 < X do
                if p170.isDestroyed ~= true then
                    task.wait(0.05)

                    if not (v80 > 0 and v80 < 8) then
                        p171.TextSize += 1
                        X = p171.Frame.AbsoluteSize.X
                        v79, v80 = getSpinnerSizeAndDigitCount()
                        continue
                    end

                    p171.TextSize = IconLabel.TextSize
                end

                break
            end

            local IconLabelParent = IconLabel.Parent
            local v81 = IconLabelParent and IconLabelParent.Parent
            local v82 = if v81 == nil then 0 elseif v81.IconImage.Visible == true then p171.Frame.AbsoluteSize.X + IconLabel.Parent.Parent.IconImage.AbsoluteSize.X else v81.AbsoluteSize.X

            while true do
                if v82 < v79 then
                    if p170.isDestroyed == true then
                        return
                    end

                    task.wait(0.05)

                    if v80 < 8 and v80 > 0 then
                        break
                    end

                    p171.TextSize -= 1

                    local IconLabelParent = IconLabel.Parent

                    IconLabelParent = IconLabelParent and IconLabelParent.Parent
                    v82 = if IconLabelParent == nil then 0 elseif IconLabelParent.IconImage.Visible == true then p171.Frame.AbsoluteSize.X + IconLabel.Parent.Parent.IconImage.AbsoluteSize.X else IconLabelParent.AbsoluteSize.X
                    v79, v80 = getSpinnerSizeAndDigitCount()
                    continue
                end

                return
            end

            p171.TextSize = IconLabel.TextSize
        end

        p170:addToJanitor(p171.Frame.ChildAdded:Connect(adjustSize))
        p170:addToJanitor(p171.Frame.ChildRemoved:Connect(adjustSize))
        p170:addToJanitor(p170.iconAdded:Connect(function() -- line: 1286
            -- upvalues: adjustSize (copy)
            task.wait(1)
            adjustSize()
        end))
        p170:updateParent()
        p171.Name = "LabelSpinner"
        p171.Prefix = "$"
        p171.Commas = true
        p171.Decimals = 0
        p171.Duration = 0.25
        p171.Value = 10
        task.wait(0.2)

        if typeof(p172) == "function" then
            p172()
        end
    end)

    return p170
end

function t1.destroy(p173) -- line: 1313
    -- upvalues: t1 (copy)
    if p173.isDestroyed then
        return
    end

    p173:clearNotices()

    if p173.parentIconUID then
        p173:leave()
    end

    p173.isDestroyed = true
    p173.janitor:clean()
    t1.iconRemoved:Fire(p173)
end

t1.Destroy = t1.destroy

return t1
