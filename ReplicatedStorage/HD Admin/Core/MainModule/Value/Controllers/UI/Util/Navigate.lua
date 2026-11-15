-- https://lua.expert

game:GetService("RunService")

local CollectionService = game:GetService("CollectionService")
local t1 = {}
local Log = require(script:FindFirstAncestor("MainModule").Value.Modules.Log)
local v1, v2
local self = setmetatable({}, {
    __mode = "k"
})

local function activateLocal(p1) -- line: 56
    -- upvalues: Log (copy), self (copy)
    local v4 = self[p1]

    if v4 then
        local ok, result = pcall(v4)

        if ok then
            return true
        end

        Log.debug("Navigate.activate error: " .. tostring(result))
    end

    return false
end

local function getBridge() -- line: 67
    -- upvalues: CollectionService (copy)
    for _, v5 in CollectionService:GetTagged("_HDNavigateBridge") do
        if v5:IsA("BindableFunction") and v5.Parent then
            return v5
        end
    end

    return nil
end

local function invoke(p2, ...) -- line: 76
    -- upvalues: v1 (ref), v2 (ref), getBridge (copy)
    if v1 then
        if p2 == "currentPage" then
            return v1.currentPage()
        end

        if p2 == "pageHistory" then
            return v1.pageHistory()
        end

        if p2 == "navigateTo" then
            v1.navigateTo(...)

            return nil
        end

        if p2 == "goBack" then
            v1.goBack()

            return nil
        end

        if p2 == "panelRoot" then
            return v1.panelRoot()
        end
    end

    if v2 then
        if p2 == "setPanelVisible" then
            v2.setVisible(...)

            return nil
        end

        if p2 == "isPanelOpen" then
            return v2.isVisible()
        end
    end

    local v6 = getBridge()

    if not v6 then
        error("HD Admin UI Navigate: menu has not mounted (register was never called)")
    end

    return v6:Invoke(p2, ...)
end

function t1.register(p3) -- line: 98
    -- upvalues: CollectionService (copy), t1 (copy), Log (copy), v1 (ref), v2 (ref), self (copy)
    v1 = p3

    local v7 = p3.panelRoot()

    if not v7 then
        return
    end

    for _, v8 in CollectionService:GetTagged("_HDNavigateBridge") do
        v8:Destroy()
    end

    local BindableFunction = Instance.new("BindableFunction")

    BindableFunction.Name = "HDNavigateBridge"
    BindableFunction.Parent = v7

    BindableFunction.OnInvoke = function(p4, ...) -- line: 111
        -- upvalues: p3 (copy), t1 (copy), Log (copy), v2 (ref), self (copy)
        if p4 == "currentPage" then
            return p3.currentPage()
        end

        if p4 == "pageHistory" then
            return p3.pageHistory()
        end

        if p4 == "navigateTo" then
            p3.navigateTo(...)
        elseif p4 == "goBack" then
            p3.goBack()
        elseif p4 == "setPanelVisible" then
            if v2 then
                v2.setVisible(...)
            end
        else
            if p4 == "isPanelOpen" then
                if v2 then
                    return (v2.isVisible())
                end

                return false
            end

            if p4 == "activate" then
                local v9, v10 = ...

                if typeof(v10) == "string" then
                    local v11 = string.split(v10, ".")
                    local v12 = game:GetService(v11[1])

                    for i = 2, #v11 do
                        if not v12 then
                            break
                        end

                        v12 = v12:FindFirstChild(v11[i])
                    end

                    if v12 and v12:IsA("GuiButton") and self[v12] then
                        local v13 = self[v12]

                        if v13 then
                            local ok, result = pcall(v13)

                            if ok then
                                return true
                            end

                            Log.debug("Navigate.activate error: " .. tostring(result))
                        end

                        return false
                    end
                end

                local v14 = typeof(v9) == "string"
                local v15

                if v14 then
                    v15 = t1.findButton(v9)

                    if not v15 then
                        local v16 = p3.panelRoot()

                        if v16 then
                            for _, descendant in v16:GetDescendants() do
                                if descendant:IsA("GuiButton") and descendant.Name == v9 then
                                    v15 = descendant
                                    break
                                end
                            end
                        end
                    end
                end

                if v14 and v15 then
                    local v17 = self[v15]

                    if v17 then
                        local ok, result = pcall(v17)

                        if ok then
                            return true
                        end

                        Log.debug("Navigate.activate error: " .. tostring(result))
                    end
                end

                return false
            end

            if p4 == "isReady" then
                return true
            end
        end

        return nil
    end

    CollectionService:AddTag(BindableFunction, "_HDNavigateBridge")
end

function t1.bindPanelVisibility(p5) -- line: 160
    -- upvalues: v2 (ref)
    v2 = p5
end

function t1.unregister() -- line: 164
    -- upvalues: CollectionService (copy), v1 (ref)
    v1 = nil

    for _, v18 in CollectionService:GetTagged("_HDNavigateBridge") do
        v18:Destroy()
    end
end

function t1.isReady() -- line: 171
    -- upvalues: v1 (ref), getBridge (copy)
    if v1 == nil then
        return getBridge() ~= nil
    end

    return true
end

function t1.awaitReady(p6) -- line: 176
    -- upvalues: t1 (copy)
    local v19 = os.clock() + (p6 or 5)

    while not t1.isReady() and os.clock() < v19 do
        task.wait(0.1)
    end

    if not t1.isReady() then
        error("HD Admin UI Navigate: timed out waiting for menu to mount")
    end
end

function t1.toPage(p7) -- line: 188
    -- upvalues: t1 (copy), invoke (copy)
    t1.awaitReady()
    invoke("navigateTo", p7)
end

function t1.goBack() -- line: 193
    -- upvalues: invoke (copy)
    invoke("goBack")
end

function t1.currentPage() -- line: 197
    -- upvalues: invoke (copy)
    return invoke("currentPage")
end

function t1.pageHistory() -- line: 201
    -- upvalues: invoke (copy)
    return invoke("pageHistory")
end

function t1.openPanel() -- line: 207
    -- upvalues: t1 (copy), invoke (copy)
    t1.awaitReady()
    invoke("setPanelVisible", true)
end

function t1.closePanel() -- line: 212
    -- upvalues: invoke (copy)
    invoke("setPanelVisible", false)
end

function t1.isPanelOpen() -- line: 216
    -- upvalues: invoke (copy)
    return invoke("isPanelOpen")
end

local function getPanelRoot() -- line: 222
    -- upvalues: v1 (ref), getBridge (copy)
    if v1 then
        return v1.panelRoot()
    end

    local v20 = getBridge()

    return v20 and v20.Parent or nil
end

function t1.findByLabel(p8, p9) -- line: 228
    -- upvalues: v1 (ref), getBridge (copy)
    local Parent

    if v1 then
        Parent = v1.panelRoot()
    else
        local v21 = getBridge()

        if v21 then
            Parent = v21.Parent
        end

        if not v21 or not Parent then
            Parent = nil
        end
    end

    if not Parent then
        return {}
    end

    local v22 = p9 ~= false
    local t4 = {}

    local function walk(p10) -- line: 234
        -- upvalues: p8 (copy), t4 (copy), v22 (copy), walk (copy)
        if p10:IsA("TextLabel") or p10:IsA("TextButton") or p10:IsA("TextBox") then
            local v23 = p10.ContentText or p10.Text

            if if v22 then v23 == p8 else string.find(v23, p8, 1, true) ~= nil then
                table.insert(t4, {
                    path = p10:GetFullName(),
                    absPos = p10.AbsolutePosition,
                    absSize = p10.AbsoluteSize,
                    visible = p10.Visible,
                    instance = p10
                })
            end
        end

        for _, child in p10:GetChildren() do
            walk(child)
        end
    end

    walk(Parent)

    return t4
end

function t1.scrollIntoView(p11, p12) -- line: 258
    p12 = p12 or 10

    local Parent = p11.Parent

    while true do
        if Parent then
            if Parent:IsA("ScrollingFrame") then
                break
            end

            Parent = Parent.Parent
            continue
        end

        Parent = nil
        break
    end

    if not Parent then
        return
    end

    local Y = Parent.AbsolutePosition.Y
    local v25 = p11.AbsolutePosition.Y - Y + Parent.CanvasPosition.Y

    Parent.CanvasPosition = Vector2.new(Parent.CanvasPosition.X, (math.max(v25 - p12, 0)))
end

function t1.snapshot() -- line: 277
    -- upvalues: t1 (copy), v1 (ref), getBridge (copy)
    local t6 = {
        currentPage = t1.currentPage(),
        visibleButtons = {}
    }
    local Parent

    if v1 then
        Parent = v1.panelRoot()
    else
        local v27 = getBridge()

        if v27 then
            Parent = v27.Parent
        end

        if not v27 or not Parent then
            Parent = nil
        end
    end

    if Parent then
        local function walk(p13) -- line: 285
            -- upvalues: t6 (copy), walk (copy)
            if p13:IsA("GuiButton") and p13.Visible and p13.Interactable then
                local Label = p13:FindFirstChild("Label")
                local ContentText = if Label and (Label:IsA("TextLabel") or Label:IsA("TextButton")) then Label.ContentText or Label.Text elseif p13:IsA("TextButton") then p13.ContentText or p13.Text else "?"

                if ContentText ~= "" and ContentText ~= "?" then
                    table.insert(t6.visibleButtons, {
                        label = ContentText,
                        path = p13:GetFullName(),
                        absPos = p13.AbsolutePosition
                    })
                end
            end

            for _, child in p13:GetChildren() do
                walk(child)
            end
        end

        walk(Parent)
    end

    return t6
end

local function isPathUnique(p14) -- line: 313
    -- upvalues: v1 (ref), getBridge (copy)
    local Parent

    if v1 then
        Parent = v1.panelRoot()
    else
        local v28 = getBridge()

        if v28 then
            Parent = v28.Parent
        end

        if not v28 or not Parent then
            Parent = nil
        end
    end

    if not Parent then
        return false
    end

    local FullName = p14:GetFullName()
    local n1 = 0

    for _, descendant in Parent:GetDescendants() do
        if descendant:GetFullName() == FullName then
            n1 += 1

            if n1 > 1 then
                return false
            end
        end
    end

    return n1 == 1
end

local function findClickableAncestor(p15) -- line: 327
    local n2 = 0

    while true do
        if not p15 or not (n2 < 10) then
            return nil
        end

        if not (p15:IsA("GuiButton") and p15.Interactable) then
            p15 = p15.Parent
            n2 += 1
            continue
        end

        break
    end

    return p15
end

function t1.findButton(p16) -- line: 341
    -- upvalues: t1 (copy), findClickableAncestor (copy)
    for _, v30 in (t1.findByLabel(p16, true)) do
        local v31 = findClickableAncestor(v30.instance)

        if v31 then
            return v31
        end
    end

    return nil
end

function t1.waitForLabel(p17, p18) -- line: 351
    -- upvalues: t1 (copy)
    local v32 = os.clock() + (p18 or 2)
    local v33

    while true do
        if not (os.clock() < v32) then
            return nil
        end

        v33 = t1.findButton(p17)

        if v33 then
            break
        end

        task.wait(0.05)
    end

    return v33
end

function t1.scrollAndFind(p19, p20, p21) -- line: 361
    -- upvalues: t1 (copy), v1 (ref), getBridge (copy)
    local v34 = t1.findButton(p19)

    if v34 then
        return v34
    end

    local v35

    if p20 then
        v35 = p20
    else
        local v36

        if v1 then
            v36 = v1.panelRoot()
        else
            local v37 = getBridge()

            v36 = v37 and v37.Parent or nil
        end

        v35 = p20

        if v36 then
            for _, descendant in v36:GetDescendants() do
                if descendant:IsA("ScrollingFrame") and descendant.AbsoluteSize.X > 0 and descendant.Visible then
                    v35 = descendant
                    break
                end

                v35 = p20
            end
        end
    end

    if v35 then
        local v38 = v35.AbsoluteWindowSize.Y * 0.5

        for _ = 1, p21 or 40 do
            v35.CanvasPosition = Vector2.new(v35.CanvasPosition.X, v35.CanvasPosition.Y + v38)
            task.wait(0.05)

            local v39 = t1.findButton(p19)

            if v39 then
                return v39
            end

            if v35.CanvasPosition.Y + v35.AbsoluteWindowSize.Y >= v35.AbsoluteCanvasSize.Y - 1 then
                break
            end
        end
    end

    return nil
end

function t1.resolveClickPoint(p22, p23) -- line: 401
    -- upvalues: t1 (copy)
    local v40 = t1.waitForLabel(p22, p23 or 0.5) or t1.scrollAndFind(p22)

    if v40 then
        return t1.pointFor(v40)
    end

    return nil
end

function t1.pointFor(p24) -- line: 410
    -- upvalues: t1 (copy), isPathUnique (copy)
    t1.scrollIntoView(p24)
    task.wait(0.05)

    local AbsolutePosition, AbsoluteSize = p24.AbsolutePosition, p24.AbsoluteSize

    return {
        path = if isPathUnique(p24) then p24:GetFullName() else nil,
        x = AbsolutePosition.X + AbsoluteSize.X / 2,
        y = AbsolutePosition.Y + AbsoluteSize.Y / 2
    }
end

local function findPendingButton(p25) -- line: 426
    -- upvalues: v1 (ref), getBridge (copy)
    local Parent

    if v1 then
        Parent = v1.panelRoot()
    else
        local v41 = getBridge()

        if v41 then
            Parent = v41.Parent
        end

        if not v41 or not Parent then
            Parent = nil
        end
    end

    if Parent then
        for _, descendant in Parent:GetDescendants() do
            if descendant:IsA("GuiButton") and descendant.Name == p25 then
                local Parent = descendant.Parent and descendant.Parent.Parent and descendant.Parent.Parent.Parent

                if Parent and Parent.Name == "ConfirmBarWrap" and Parent.AbsoluteSize.Y > 4 then
                    return descendant
                end
            end
        end
    end

    return nil
end

function t1.confirmPending() -- line: 440
    -- upvalues: t1 (copy), findPendingButton (copy)
    local ConfirmButton = findPendingButton("ConfirmButton")

    return if ConfirmButton then t1.pointFor(ConfirmButton) else nil
end

function t1.undoPending() -- line: 445
    -- upvalues: t1 (copy), findPendingButton (copy)
    local UndoButton = findPendingButton("UndoButton")

    return if UndoButton then t1.pointFor(UndoButton) else nil
end

function t1.hasPendingChanges() -- line: 450
    -- upvalues: findPendingButton (copy)
    return findPendingButton("ConfirmButton") ~= nil
end

function t1.registerActivate(p26, p27) -- line: 458
    -- upvalues: self (copy)
    self[p26] = p27
end

function t1.makeActivatable(p28, p29) -- line: 463
    -- upvalues: self (copy)
    if typeof(p28) == "Instance" then
        self[p28] = p29
    end

    return p28
end

function t1.activate(p30) -- line: 471
    -- upvalues: t1 (copy), Log (copy), v1 (ref), self (copy), getBridge (copy)
    local v42 = if typeof(p30) == "Instance" then p30 else nil

    if v42 and self[v42] then
        local v43 = self[v42]

        if v43 then
            local ok, result = pcall(v43)

            if ok then
                return true
            end

            Log.debug("Navigate.activate error: " .. tostring(result))
        end

        return false
    end

    local v44 = getBridge()

    if v44 then
        return v44:Invoke("activate", p30, if v42 then v42:GetFullName() else nil)
    end

    local v45, v46, v47

    if v42 then
        v47 = v42
    else
        v45 = t1.findButton(p30)

        if v45 then
            v47 = v45
        else
            if v1 then
                v46 = v1.panelRoot()
            else
                local v48 = getBridge()

                v46 = v48 and v48.Parent or nil
            end

            v47 = v45

            if v46 then
                for _, descendant in v46:GetDescendants() do
                    if descendant:IsA("GuiButton") and descendant.Name == p30 then
                        v47 = descendant
                        break
                    end

                    v47 = v45
                end
            end
        end
    end

    if v47 then
        local v49 = self[v47]

        if v49 then
            local ok, result = pcall(v49)

            if ok then
                return true
            end

            Log.debug("Navigate.activate error: " .. tostring(result))
        end
    end

    return false
end

function t1.confirm() -- line: 504
    -- upvalues: t1 (copy), findPendingButton (copy)
    local ConfirmButton = findPendingButton("ConfirmButton")

    if ConfirmButton then
        return (t1.activate(ConfirmButton))
    end

    return false
end

function t1.undo() -- line: 509
    -- upvalues: t1 (copy), findPendingButton (copy)
    local UndoButton = findPendingButton("UndoButton")

    if UndoButton then
        return (t1.activate(UndoButton))
    end

    return false
end

return t1
