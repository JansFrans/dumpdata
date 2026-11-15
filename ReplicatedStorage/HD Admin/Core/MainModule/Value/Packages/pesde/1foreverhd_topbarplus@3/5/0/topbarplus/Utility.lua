-- https://lua.expert

local t1 = {}
local LocalPlayer = game:GetService("Players").LocalPlayer

function t1.createStagger(p1, p2, p3) -- line: 13
    local v1 = p1
    local v2 = false
    local v3 = false

    if not p1 or p1 == 0 then
        v1 = 0.01
    end

    local function staggeredCallback(...) -- line: 29
        -- upvalues: v1 (ref), p2 (copy), p3 (copy), v2 (ref), v3 (ref), staggeredCallback (copy)
        if v2 then
            v3 = true
        else
            local v4 = table.pack(...)

            v2 = true
            v3 = false
            task.spawn(function() -- line: 37
                -- upvalues: v4 (copy), v1 (ref), p2 (copy), p3 (copy)
                if p3 then
                    task.wait(v1)
                end

                p2(table.unpack(v4))
            end)
            task.delay(v1, function() -- line: 43
                -- upvalues: v4 (copy), v2 (ref), v3 (ref), staggeredCallback (copy)
                v2 = false

                if v3 then
                    staggeredCallback(table.unpack(v4))
                end
            end)
        end
    end

    return staggeredCallback
end

function t1.round(p4) -- line: 55
    return (math.floor(p4 + 0.5))
end

function t1.reverseTable(p5) -- line: 60
    for i = 1, math.floor(#p5 / 2) do
        local v7 = #p5 - i + 1
        local v8 = p5[v7]
        local v9 = p5[i]

        p5[i] = v8
        p5[v7] = v9
    end
end

function t1.copyTable(p6) -- line: 67
    -- upvalues: t1 (copy)
    assert(type(p6) == "table", "First argument must be a table")

    local v11 = table.create(#p6)

    for v12, v13 in pairs(p6) do
        if type(v13) == "table" then
            v11[v12] = t1.copyTable(v13)
        else
            v11[v12] = v13
        end
    end

    return v11
end

local t2 = {
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z",
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "0",
    "<",
    ">",
    "?",
    "@",
    "{",
    "}",
    "[",
    "]",
    "!",
    "(",
    ")",
    "=",
    "+",
    "~",
    "#"
}

function t1.generateUID(p7) -- line: 82
    -- upvalues: t2 (copy)
    p7 = p7 or 8

    local v15 = #t2
    local v16 = ""

    for _ = 1, p7 do
        v16 ..= t2[math.random(1, v15)]
    end

    return v16
end

local t3 = {}

function t1.setVisible(p8, p9, p10) -- line: 95
    -- upvalues: t3 (copy)
    local v17 = t3[p8]

    if not v17 then
        v17 = {}
        t3[p8] = v17
        p8.Destroying:Once(function() -- line: 104
            -- upvalues: p8 (copy), t3 (copy)
            t3[p8] = nil
        end)
    end

    local v18

    if p9 then
        v17[p10] = nil
        v18 = p9

        for _, _ in pairs(v17) do
            v18 = false
            break
        end
    else
        v17[p10] = true
        v18 = p9
    end

    p8.Visible = v18
end

function t1.formatStateName(p11) -- line: 123
    return string.upper((string.sub(p11, 1, 1))) .. string.lower((string.sub(p11, 2)))
end

function t1.isReducedMotion() -- line: 127
    local function v19() -- line: 128
        return game:GetService("GuiService").ReducedMotionEnabled
    end

    local ok, result = pcall(v19)

    return ok and result == true
end

function t1.getTweenInfo(p12) -- line: 134
    -- upvalues: t1 (copy)
    if t1.isReducedMotion() then
        return TweenInfo.new(0)
    end

    return p12
end

function t1.localPlayerRespawned(p13) -- line: 142
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer.CharacterRemoving:Connect(p13)
end

function t1.getClippedContainer(p14) -- line: 152
    local ClippedContainer = p14:FindFirstChild("ClippedContainer")

    if not ClippedContainer then
        ClippedContainer = Instance.new("Folder")
        ClippedContainer.Name = "ClippedContainer"
        ClippedContainer.Parent = p14
    end

    return ClippedContainer
end

local Janitor = require(script.Parent.Packages.Janitor)
local GuiService = game:GetService("GuiService")

function t1.clipOutside(p15, p16) -- line: 166
    -- upvalues: t1 (copy), Janitor (copy), GuiService (copy)
    local v20 = p15.janitor:add(Janitor.new())

    p16.Destroying:Once(function() -- line: 168
        -- upvalues: v20 (copy)
        v20:Destroy()
    end)
    p15.janitor:add(p16)

    local Parent = p16.Parent
    local v21 = v20:add(Instance.new("Frame"))

    v21:SetAttribute("IsAClippedClone", true)
    v21.Name = p16.Name
    v21.AnchorPoint = p16.AnchorPoint
    v21.Size = p16.Size
    v21.Position = p16.Position
    v21.BackgroundTransparency = 1
    v21.LayoutOrder = p16.LayoutOrder
    v21.Parent = Parent

    local ObjectValue = Instance.new("ObjectValue")

    ObjectValue.Name = "OriginalInstance"
    ObjectValue.Value = p16
    ObjectValue.Parent = v21

    local clone = ObjectValue:Clone()

    p16:SetAttribute("HasAClippedClone", true)
    clone.Name = "ClippedClone"
    clone.Value = v21
    clone.Parent = p16

    local ScreenGui
    local iconModule = require(p15.iconModule)
    local container = iconModule.container

    local function updateScreenGui() -- line: 198
        -- upvalues: p16 (copy), Parent (copy), ScreenGui (ref), container (copy), t1 (copy)
        local ScreenGui2 = Parent:FindFirstAncestorWhichIsA("ScreenGui")

        if not string.match(ScreenGui2.Name, "Clipped") then
            ScreenGui2 = container[ScreenGui2.Name .. "Clipped"]
        end

        ScreenGui = ScreenGui2
        p16.AnchorPoint = Vector2.new(0, 0)
        p16.Parent = t1.getClippedContainer(ScreenGui)
    end

    v20:add(p15.alignmentChanged:Connect(updateScreenGui))
    updateScreenGui()

    for _, child in pairs(p16:GetChildren()) do
        if child:IsA("UIAspectRatioConstraint") then
            child:Clone().Parent = v21
        end
    end

    local widget = p15.widget
    local v22 = false
    local IgnoreVisibilityUpdater = p16:GetAttribute("IgnoreVisibilityUpdater")

    local function updateVisibility() -- line: 220
        -- upvalues: p16 (copy), widget (copy), v22 (ref), IgnoreVisibilityUpdater (copy), t1 (copy)
        if IgnoreVisibilityUpdater then
            return
        end

        local Visible = widget.Visible

        if v22 then
            Visible = false
        end

        t1.setVisible(p16, Visible, "ClipHandler")
    end

    v20:add(widget:GetPropertyChangedSignal("Visible"):Connect(updateVisibility))

    local joinedFrame, checkIfOutsideParentXBounds

    local function checkIfOutsideParentXBounds2() -- line: 233
        -- upvalues: p15 (copy), p16 (copy), v20 (copy), iconModule (copy), widget (copy), v22 (ref), IgnoreVisibilityUpdater (copy), joinedFrame (ref), checkIfOutsideParentXBounds (ref), t1 (copy)
        task.defer(function() -- line: 235
            -- upvalues: p15 (copy), p16 (copy), v20 (copy), iconModule (copy), widget (copy), v22 (ref), IgnoreVisibilityUpdater (copy), joinedFrame (ref), checkIfOutsideParentXBounds (ref), t1 (copy)
            local UID = p15.UID
            local joinedFrame2

            if p16:GetAttribute("ClipToJoinedParent") then
                local v23 = UID

                for _ = 1, 10 do
                    local v24 = iconModule.getIconByUID(v23)

                    if not v24 then
                        break
                    end

                    local joinedFrame = v24.joinedFrame

                    v23 = v24.parentIconUID

                    if not joinedFrame then
                        break
                    end

                    if joinedFrame.Name == "DropdownScroller" then
                        joinedFrame2 = joinedFrame
                        break
                    end

                    joinedFrame2 = joinedFrame
                end
            end

            if joinedFrame2 then
                local AbsolutePosition = p16.AbsolutePosition
                local v25 = p16.AbsoluteSize / 2
                local AbsolutePosition2, AbsoluteSize = joinedFrame2.AbsolutePosition, joinedFrame2.AbsoluteSize
                local v26 = AbsolutePosition + v25
                local v27 = v26.X < AbsolutePosition2.X
                local v28 = v26.X > AbsolutePosition2.X + AbsoluteSize.X
                local v29 = v26.Y < AbsolutePosition2.Y
                local v30 = v26.Y > AbsolutePosition2.Y + AbsoluteSize.Y
                local v31 = v27 or v28 or v29 or v30

                if v31 ~= v22 then
                    v22 = v31

                    local Visible

                    if not IgnoreVisibilityUpdater then
                        Visible = widget.Visible

                        if v22 then
                            Visible = false
                        end

                        t1.setVisible(p16, Visible, "ClipHandler")
                    end
                end

                if joinedFrame2:IsA("ScrollingFrame") and joinedFrame ~= joinedFrame2 then
                    joinedFrame = joinedFrame2
                    v20:add(joinedFrame2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- line: 280
                        -- upvalues: checkIfOutsideParentXBounds (ref)
                        checkIfOutsideParentXBounds()
                    end), "Disconnect", "TrackUtilityScroller-" .. UID)
                end
            else
                v22 = false

                if not IgnoreVisibilityUpdater then
                    local Visible = widget.Visible

                    if v22 then
                        Visible = false
                    end

                    t1.setVisible(p16, Visible, "ClipHandler")
                end
            end
        end)
    end

    checkIfOutsideParentXBounds = checkIfOutsideParentXBounds2

    local CurrentCamera = workspace.CurrentCamera
    local v32 = p16:GetAttribute("AdditionalOffsetX") or 0

    local function trackProperty(p17) -- line: 290
        -- upvalues: p15 (copy), p16 (copy), v20 (copy), v21 (copy), ScreenGui (ref), iconModule (copy), widget (copy), v22 (ref), IgnoreVisibilityUpdater (copy), joinedFrame (ref), checkIfOutsideParentXBounds2 (copy), CurrentCamera (copy), v32 (copy), t1 (copy), GuiService (copy)
        local v33 = "Absolute" .. p17

        local function updateProperty() -- line: 292
            -- upvalues: p17 (copy), v33 (copy), p15 (copy), p16 (copy), v20 (copy), v21 (copy), ScreenGui (ref), iconModule (copy), widget (copy), v22 (ref), IgnoreVisibilityUpdater (copy), joinedFrame (ref), checkIfOutsideParentXBounds2 (copy), CurrentCamera (copy), v32 (copy), t1 (copy), GuiService (copy)
            local v34 = v21[v33]
            local v35 = UDim2.fromOffset(v34.X, v34.Y)
            local v36

            if p17 == "Position" then
                local v37 = CurrentCamera.ViewportSize.X - p16.AbsoluteSize.X - 4
                local Offset = v35.X.Offset

                if Offset < 4 then
                    v37 = 4
                elseif not (v37 < Offset) then
                    v37 = Offset
                end

                local v38 = UDim2.fromOffset(v37, v35.Y.Offset)
                local TopbarInset = GuiService.TopbarInset
                local X = workspace.CurrentCamera.ViewportSize.X
                local X2 = ScreenGui.AbsoluteSize.X
                local X3 = ScreenGui.AbsolutePosition.X

                if not iconModule.isOldTopbar then
                    X3 = X - X2 - 0
                end

                local v39 = X3 - v32

                v36 = v38 + UDim2.fromOffset(-v39, TopbarInset.Height)
                task.defer(function() -- line: 235
                    -- upvalues: p15 (copy), p16 (copy), v20 (copy), iconModule (copy), widget (copy), v22 (ref), IgnoreVisibilityUpdater (copy), joinedFrame (ref), checkIfOutsideParentXBounds2 (copy), t1 (copy)
                    local UID = p15.UID
                    local joinedFrame2

                    if p16:GetAttribute("ClipToJoinedParent") then
                        local v40 = UID

                        for _ = 1, 10 do
                            local v41 = iconModule.getIconByUID(v40)

                            if not v41 then
                                break
                            end

                            local joinedFrame = v41.joinedFrame

                            v40 = v41.parentIconUID

                            if not joinedFrame then
                                break
                            end

                            if joinedFrame.Name == "DropdownScroller" then
                                joinedFrame2 = joinedFrame
                                break
                            end

                            joinedFrame2 = joinedFrame
                        end
                    end

                    if joinedFrame2 then
                        local AbsolutePosition = p16.AbsolutePosition
                        local v42 = p16.AbsoluteSize / 2
                        local AbsolutePosition2, AbsoluteSize = joinedFrame2.AbsolutePosition, joinedFrame2.AbsoluteSize
                        local v43 = AbsolutePosition + v42
                        local v44 = v43.X < AbsolutePosition2.X
                        local v45 = v43.X > AbsolutePosition2.X + AbsoluteSize.X
                        local v46 = v43.Y < AbsolutePosition2.Y
                        local v47 = v43.Y > AbsolutePosition2.Y + AbsoluteSize.Y
                        local v48 = v44 or v45 or v46 or v47

                        if v48 ~= v22 then
                            v22 = v48

                            local Visible

                            if not IgnoreVisibilityUpdater then
                                Visible = widget.Visible

                                if v22 then
                                    Visible = false
                                end

                                t1.setVisible(p16, Visible, "ClipHandler")
                            end
                        end

                        if joinedFrame2:IsA("ScrollingFrame") and joinedFrame ~= joinedFrame2 then
                            joinedFrame = joinedFrame2
                            v20:add(joinedFrame2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- line: 280
                                -- upvalues: checkIfOutsideParentXBounds2 (copy)
                                checkIfOutsideParentXBounds2()
                            end), "Disconnect", "TrackUtilityScroller-" .. UID)
                        end
                    else
                        v22 = false

                        if not IgnoreVisibilityUpdater then
                            local Visible = widget.Visible

                            if v22 then
                                Visible = false
                            end

                            t1.setVisible(p16, Visible, "ClipHandler")
                        end
                    end
                end)
            else
                v36 = v35
            end

            p16[p17] = v36
        end

        local v49 = t1.createStagger(0.01, updateProperty)

        v20:add(v21:GetPropertyChangedSignal(v33):Connect(v49))
        v20:add(v21:GetAttributeChangedSignal("ForceUpdate"):Connect(function() -- line: 332
            -- upvalues: v49 (copy)
            v49()
        end))

        local v50 = t1.createStagger(0.5, updateProperty, true)

        v20:add(v21:GetPropertyChangedSignal(v33):Connect(v50))

        if p17 == "Position" then
            v20:add(ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 351
                -- upvalues: v49 (copy)
                v49()
            end))
        end
    end

    task.delay(0.1, checkIfOutsideParentXBounds2)
    task.defer(function() -- line: 235
        -- upvalues: p15 (copy), p16 (copy), v20 (copy), iconModule (copy), widget (copy), v22 (ref), IgnoreVisibilityUpdater (copy), joinedFrame (ref), checkIfOutsideParentXBounds2 (copy), t1 (copy)
        local UID = p15.UID
        local joinedFrame2

        if p16:GetAttribute("ClipToJoinedParent") then
            local v51 = UID

            for _ = 1, 10 do
                local v52 = iconModule.getIconByUID(v51)

                if not v52 then
                    break
                end

                local joinedFrame = v52.joinedFrame

                v51 = v52.parentIconUID

                if not joinedFrame then
                    break
                end

                if joinedFrame.Name == "DropdownScroller" then
                    joinedFrame2 = joinedFrame
                    break
                end

                joinedFrame2 = joinedFrame
            end
        end

        if joinedFrame2 then
            local AbsolutePosition = p16.AbsolutePosition
            local v53 = p16.AbsoluteSize / 2
            local AbsolutePosition2, AbsoluteSize = joinedFrame2.AbsolutePosition, joinedFrame2.AbsoluteSize
            local v54 = AbsolutePosition + v53
            local v55 = v54.X < AbsolutePosition2.X
            local v56 = v54.X > AbsolutePosition2.X + AbsoluteSize.X
            local v57 = v54.Y < AbsolutePosition2.Y
            local v58 = v54.Y > AbsolutePosition2.Y + AbsoluteSize.Y
            local v59 = v55 or v56 or v57 or v58

            if v59 ~= v22 then
                v22 = v59

                local Visible

                if not IgnoreVisibilityUpdater then
                    Visible = widget.Visible

                    if v22 then
                        Visible = false
                    end

                    t1.setVisible(p16, Visible, "ClipHandler")
                end
            end

            if joinedFrame2:IsA("ScrollingFrame") and joinedFrame ~= joinedFrame2 then
                joinedFrame = joinedFrame2
                v20:add(joinedFrame2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- line: 280
                    -- upvalues: checkIfOutsideParentXBounds2 (copy)
                    checkIfOutsideParentXBounds2()
                end), "Disconnect", "TrackUtilityScroller-" .. UID)
            end
        else
            v22 = false

            if not IgnoreVisibilityUpdater then
                local Visible = widget.Visible

                if v22 then
                    Visible = false
                end

                t1.setVisible(p16, Visible, "ClipHandler")
            end
        end
    end)

    if not IgnoreVisibilityUpdater then
        local Visible = widget.Visible

        if v22 then
            Visible = false
        end

        t1.setVisible(p16, Visible, "ClipHandler")
    end

    trackProperty("Position")
    v20:add(p16:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 363
    end))

    if p16:GetAttribute("TrackCloneSize") then
        trackProperty("Size")
    else
        v20:add(p16:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 373
            -- upvalues: p16 (copy), v21 (copy)
            local AbsoluteSize = p16.AbsoluteSize

            v21.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y)
        end))
    end

    return v21
end

function t1.joinFeature(p18, p19, p20, p21) -- line: 382
    local joinJanitor = p18.joinJanitor

    joinJanitor:clean()

    if not p21 then
        p18:leave()

        return
    end

    p18.parentIconUID = p19.UID
    p18.joinedFrame = p21

    local function updateAlignent() -- line: 393
        -- upvalues: p18 (copy), p19 (copy)
        local alignment = p19.alignment

        if alignment == "Center" then
            alignment = "Left"
        end

        p18:setAlignment(alignment, true)
    end

    joinJanitor:add(p19.alignmentChanged:Connect(updateAlignent))

    local alignment = p19.alignment

    if alignment == "Center" then
        alignment = "Left"
    end

    p18:setAlignment(alignment, true)
    p18:modifyTheme({
        "IconButton",
        "BackgroundTransparency",
        1
    }, "JoinModification")
    p18:modifyTheme({
        "ClickRegion",
        "Active",
        false
    }, "JoinModification")

    if p19.childModifications then
        task.defer(function() -- line: 408
            -- upvalues: p18 (copy), p19 (copy)
            p18:modifyTheme(p19.childModifications, p19.childModificationsUID)
        end)
    end

    local ClickRegion = p18:getInstance("ClickRegion")

    local function makeSelectable() -- line: 414
        -- upvalues: p19 (copy), ClickRegion (copy)
        ClickRegion.Selectable = p19.isSelected
    end

    joinJanitor:add(p19.toggled:Connect(makeSelectable))
    task.defer(makeSelectable)
    joinJanitor:add(function() -- line: 419
        -- upvalues: ClickRegion (copy)
        ClickRegion.Selectable = true
    end)

    local UID = p18.UID

    table.insert(p20, UID)
    p19:autoDeselect(false)
    p19.childIconsDict[UID] = true

    if not p19.isEnabled then
        p19:setEnabled(true)
    end

    p18.joinedParent:Fire(p19)
    joinJanitor:add(function() -- line: 437
        -- upvalues: p18 (copy), p19 (copy), p20 (copy), UID (copy)
        if p18.joinedFrame then
            for v60, v61 in pairs(p20) do
                if v61 == UID then
                    table.remove(p20, v60)
                    break
                end
            end

            local v62 = require(p18.iconModule).getIconByUID(p18.parentIconUID)

            if not v62 then
                return
            end

            p18:setAlignment(p18.originalAlignment)
            p18.parentIconUID = false
            p18.joinedFrame = false
            p18:removeModification("JoinModification")

            local childIconsDict = v62.childIconsDict

            childIconsDict[UID] = nil

            local v63 = true

            for _, _ in pairs(childIconsDict) do
                v63 = false
                break
            end

            if v63 and not v62.isAnOverflow then
                v62:setEnabled(false)
            end

            local alignment = p19.alignment

            if alignment == "Center" then
                alignment = "Left"
            end

            p18:setAlignment(alignment, true)
        end
    end)
end

return t1
