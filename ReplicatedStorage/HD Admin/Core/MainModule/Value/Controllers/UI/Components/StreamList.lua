-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Log = require(Modules.Log)
local Packages = Modules.Parent.Packages
local _ = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

return function(p1, p2) -- line: 41
    -- upvalues: Log (copy), Fusion (copy), Children (copy)
    local v1 = p2.batchSize or 4
    local v2 = if p2.batchInterval == nil then 0.01 else p2.batchInterval
    local v3 = if p2.deconstructInterval == nil then 0.03 else p2.deconstructInterval
    local v4 = p2.idleGrace or 1
    local parentScrollingFrame, itemKey = p2.parentScrollingFrame, p2.itemKey
    local t1 = {}
    local t2 = {}
    local n1 = 0
    local v5
    local t3 = {}
    local v6 = false
    local v7 = false

    table.insert(p1, function() -- line: 60
        -- upvalues: t1 (copy), t2 (copy), n1 (ref), t3 (copy), v7 (ref), Fusion (copy)
        v7 = true

        for i = #t1, 1, -1 do
            Fusion.doCleanup(t1[i].itemScope)
        end

        for i = #t3, 1, -1 do
            Fusion.doCleanup(t3[i])
        end

        table.clear(t1)
        table.clear(t2)
        table.clear(t3)
        n1 = 0
    end)

    local function pumpRetired() -- line: 74
        -- upvalues: t3 (copy), v6 (ref), v7 (ref), Fusion (copy)
        if not v6 and #t3 ~= 0 then
            v6 = true
            task.spawn(function() -- line: 77
                -- upvalues: t3 (copy), v6 (ref), v7 (ref), Fusion (copy)
                while not v7 and #t3 > 0 do
                    task.wait()

                    if v7 then
                        break
                    end

                    debug.profilebegin("HD_StreamRetire")

                    local elapsed = os.clock()

                    while #t3 > 0 and (os.clock() - elapsed) * 1000 < 4 do
                        local v9 = table.remove(t3)

                        Fusion.doCleanup(v9)
                    end

                    debug.profileend()
                end

                v6 = false
            end)
        end
    end

    local n2 = 0
    local v10, Parent

    local function detachForDeconstruct() -- line: 99
        -- upvalues: parentScrollingFrame (copy), v10 (ref), Parent (ref)
        if parentScrollingFrame then
            parentScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
        end

        if not v10 then
            return
        end

        Parent = v10.Parent
        v10.Parent = nil
    end

    local function reattachForConstruct() -- line: 109
        -- upvalues: parentScrollingFrame (copy), v10 (ref), Parent (ref)
        if v10 and Parent then
            v10.Parent = Parent
        end

        if parentScrollingFrame then
            parentScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        end
    end

    local t4

    local function applyFilter() -- line: 120
        -- upvalues: t1 (copy), t4 (ref)
        local t5 = t4

        debug.profilebegin("HD_ApplyFilter")

        for _, v11 in t1 do
            local instance = v11.instance

            if t5 ~= nil then
                instance.Visible = t5[v11.item] == true
            else
                instance.Visible = true
            end
        end

        debug.profileend()
    end

    if p2.visibleItems ~= nil then
        p1:Observer(p2.visibleItems):onBind(function() -- line: 130
            -- upvalues: p2 (copy), v7 (ref), t4 (ref), applyFilter (copy), Fusion (copy)
            local v12 = Fusion.peek(p2.visibleItems)

            if type(v12) == "table" then
                local t6 = {}

                for _, v13 in v12 do
                    t6[v13] = true
                end

                t4 = t6
            else
                t4 = nil
            end

            task.defer(function() -- line: 142
                -- upvalues: v7 (ref), applyFilter (copy)
                if not v7 then
                    applyFilter()
                end
            end)
        end)
    end

    local function buildOne(p3, p4, p5) -- line: 148
        -- upvalues: p2 (copy), t1 (copy), t2 (copy), v10 (ref), t4 (ref), Fusion (copy)
        local v14 = Fusion.scoped(Fusion)

        debug.profilebegin("HD_BuildItem")

        local v15 = p2.renderItem(v14, p3)

        debug.profileend()
        v15.LayoutOrder = p4
        v15.Parent = v10

        if t4 ~= nil then
            v15.Visible = t4[p3] == true
        end

        local t7 = {
            item = p3,
            key = p5,
            itemScope = v14,
            instance = v15
        }

        table.insert(t1, t7)

        if p5 ~= nil then
            t2[p5] = t7
        end
    end

    local function destroyLast() -- line: 165
        -- upvalues: t1 (copy), t2 (copy), Fusion (copy)
        local v16 = #t1

        if v16 == 0 then
            return
        end

        local v17 = t1[v16]

        t1[v16] = nil

        if v17.key ~= nil and t2[v17.key] == v17 then
            t2[v17.key] = nil
        end

        Fusion.doCleanup(v17.itemScope)
    end

    local function diffStream(p6, p7) -- line: 178
        -- upvalues: v1 (copy), itemKey (copy), t1 (copy), t2 (copy), n1 (ref), t3 (copy), v6 (ref), v7 (ref), n2 (ref), buildOne (copy), v2 (copy), Log (copy), Fusion (copy)
        local t8 = {}
        local t9 = {}
        local t10 = {}

        for v18, v19 in p6 do
            local v20 = itemKey(v19)

            if t8[v20] ~= nil then
                Log.debug((("StreamList ignored duplicate itemKey '%*'"):format(v20)))
            else
                t8[v20] = v18
                t9[v20] = v19
                table.insert(t10, v20)
            end
        end

        for i = #t1, 1, -1 do
            local v21 = t1[i]
            local key = v21.key
            local v22 = t8[key]
            local v23 = false

            if v22 ~= nil then
                if t9[key] == v21.item then
                    v23 = true
                else
                    table.remove(t1, i)

                    if t2[key] == v21 then
                        t2[key] = nil
                    end
                end
            else
                table.remove(t1, i)

                if t2[key] == v21 then
                    t2[key] = nil
                end
            end

            if v23 then
                v21.instance.LayoutOrder = v22
                t9[key] = nil
            else
                v21.instance.Parent = nil
                table.insert(t3, v21.itemScope)
            end
        end

        if not v6 and #t3 ~= 0 then
            v6 = true
            task.spawn(function() -- line: 77
                -- upvalues: t3 (copy), v6 (ref), v7 (ref), Fusion (copy)
                while not v7 and #t3 > 0 do
                    task.wait()

                    if v7 then
                        break
                    end

                    debug.profilebegin("HD_StreamRetire")

                    local elapsed = os.clock()

                    while #t3 > 0 and (os.clock() - elapsed) * 1000 < 4 do
                        local v24 = table.remove(t3)

                        Fusion.doCleanup(v24)
                    end

                    debug.profileend()
                end

                v6 = false
            end)
        end

        local t11 = {}

        for _, v25 in t10 do
            local v26 = t9[v25]

            if v26 ~= nil then
                table.insert(t11, {
                    key = v25,
                    item = v26,
                    order = t8[v25]
                })
            end
        end

        n1 = #t1

        if #t11 == 0 then
            return
        end

        local t13 = {}

        t13[1] = 0

        local function step() -- line: 222
            -- upvalues: p7 (copy), t11 (copy), t13 (copy), step (copy), v1 (copy), t1 (copy), n1 (ref), v7 (ref), n2 (ref), buildOne (copy), v2 (copy)
            if not v7 and n2 == p7 then
                debug.profilebegin("HD_StreamBatch")

                local elapsed = os.clock()
                local n3 = 0

                while t13[1] < #t11 and n3 < v1 do
                    t13[1] += 1
                    n3 += 1

                    local v27 = t11[t13[1]]

                    buildOne(v27.item, v27.order, v27.key)

                    if (os.clock() - elapsed) * 1000 >= 6 then
                        break
                    end
                end

                n1 = #t1
                debug.profileend()

                if not (t13[1] >= #t11) then
                    if v2 > 0 then
                        task.delay(v2, step)
                    else
                        task.defer(step)
                    end
                end
            end
        end

        task.defer(step)
    end

    local function startStream(p8) -- line: 248
        -- upvalues: v1 (copy), parentScrollingFrame (copy), itemKey (copy), t1 (copy), t2 (copy), n1 (ref), v5 (ref), t3 (copy), v6 (ref), v7 (ref), n2 (ref), v10 (ref), Parent (ref), buildOne (copy), diffStream (copy), v2 (copy), Fusion (copy)
        n2 += 1

        local v28 = n2
        local v29 = #p8

        if v10 and Parent then
            v10.Parent = Parent
        end

        if parentScrollingFrame then
            parentScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        end

        if itemKey ~= nil then
            v5 = p8
            diffStream(p8, v28)

            return
        end

        if p8 ~= v5 or v29 < n1 then
            debug.profilebegin("HD_StreamTeardown")

            for i = #t1, 1, -1 do
                local v30 = t1[i]

                v30.instance.Parent = nil
                table.insert(t3, v30.itemScope)
                t1[i] = nil
            end

            table.clear(t2)
            debug.profileend()

            if not v6 and #t3 ~= 0 then
                v6 = true
                task.spawn(function() -- line: 77
                    -- upvalues: t3 (copy), v6 (ref), v7 (ref), Fusion (copy)
                    while not v7 and #t3 > 0 do
                        task.wait()

                        if v7 then
                            break
                        end

                        debug.profilebegin("HD_StreamRetire")

                        local elapsed = os.clock()

                        while #t3 > 0 and (os.clock() - elapsed) * 1000 < 4 do
                            local v31 = table.remove(t3)

                            Fusion.doCleanup(v31)
                        end

                        debug.profileend()
                    end

                    v6 = false
                end)
            end

            n1 = 0
        end

        v5 = p8

        local function step() -- line: 273
            -- upvalues: p8 (copy), v28 (copy), v29 (copy), step (copy), v1 (copy), n1 (ref), v7 (ref), n2 (ref), buildOne (copy), v2 (copy)
            if not v7 and n2 == v28 and not (n1 >= v29) then
                debug.profilebegin("HD_StreamBatch")

                local elapsed = os.clock()
                local n4 = 0

                while n1 < v29 and n4 < v1 do
                    n1 += 1
                    n4 += 1
                    buildOne(p8[n1], n1)

                    if (os.clock() - elapsed) * 1000 >= 6 then
                        break
                    end
                end

                debug.profileend()

                if v2 > 0 then
                    task.delay(v2, step)
                else
                    task.defer(step)
                end
            end
        end

        task.defer(step)
    end

    local v32 = p1:Computed(function(p9) -- line: 318
        -- upvalues: p2 (copy)
        local v33 = p9(p2.items)

        if type(v33) == "table" then
            return v33
        end

        return {}
    end)
    local v34 = false

    p1:Observer(v32):onBind(function() -- line: 324
        -- upvalues: v7 (ref), startStream (copy), v32 (copy), v34 (ref), Fusion (copy)
        if not v34 then
            v34 = true
            task.defer(function() -- line: 327
                -- upvalues: v7 (ref), startStream (copy), v32 (copy), v34 (ref), Fusion (copy)
                v34 = false

                if not v7 then
                    startStream(Fusion.peek(v32))
                end
            end)
        end
    end)

    if p2.idle ~= nil then
        p1:Observer(p2.idle):onChange(function() -- line: 335
            -- upvalues: p2 (copy), v4 (copy), parentScrollingFrame (copy), t1 (copy), t2 (copy), n1 (ref), v7 (ref), n2 (ref), v10 (ref), Parent (ref), startStream (copy), v32 (copy), v3 (copy), Fusion (copy)
            if not Fusion.peek(p2.idle) then
                startStream(Fusion.peek(v32))

                return
            end

            n2 += 1

            local v36 = n2

            task.delay(v4, function() -- line: 340
                -- upvalues: v36 (copy), parentScrollingFrame (copy), t1 (copy), t2 (copy), n1 (ref), v7 (ref), n2 (ref), v10 (ref), Parent (ref), v3 (copy), Fusion (copy)
                local v37, v38

                if v7 then
                    v38 = true
                elseif n2 == v36 then
                    n2 += 1
                    v37 = n2

                    if parentScrollingFrame then
                        parentScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
                    end

                    v38 = false
                else
                    v38 = true
                end

                if v38 then
                    return
                end

                if v10 then
                    Parent = v10.Parent
                    v10.Parent = nil
                end

                local function step() -- line: 301
                    -- upvalues: v37 (ref), step (copy), t1 (copy), t2 (copy), n1 (ref), v7 (ref), n2 (ref), v3 (copy), Fusion (copy)
                    if v7 or n2 ~= v37 or n1 <= 0 then
                        return
                    end

                    local v39 = #t1

                    if v39 ~= 0 then
                        local v40 = t1[v39]

                        t1[v39] = nil

                        if v40.key ~= nil and t2[v40.key] == v40 then
                            t2[v40.key] = nil
                        end

                        Fusion.doCleanup(v40.itemScope)
                    end

                    n1 -= 1

                    if not (n1 <= 0) then
                        if v3 > 0 then
                            task.delay(v3, step)
                        else
                            task.defer(step)
                        end
                    end
                end

                if v7 or n2 ~= v37 or n1 <= 0 then
                    return
                end

                local v41 = #t1

                if v41 ~= 0 then
                    local v42 = t1[v41]

                    t1[v41] = nil

                    if v42.key ~= nil and t2[v42.key] == v42 then
                        t2[v42.key] = nil
                    end

                    Fusion.doCleanup(v42.itemScope)
                end

                n1 -= 1

                if n1 <= 0 then
                    return
                end

                if v3 > 0 then
                    task.delay(v3, step)
                else
                    task.defer(step)
                end
            end)
        end)
    end

    v10 = p1:New("Frame")({
        Name = "StreamList",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = p2.layoutOrder,
        Size = p2.size or UDim2.fromScale(1, 0),
        [Children] = {
            p1:New("UIListLayout")({
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = p2.padding or UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        }
    })

    return v10
end
