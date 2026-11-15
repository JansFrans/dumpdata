-- https://lua.expert

local v1 = Vector2.new(10, -10)
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local Fusion = require(Packages.Fusion)
local t1 = {}

t1[1] = nil

local v2, v3
local n1 = 0
local t2 = {
    POPUP_OFFSET = v1,
    POPUP_PANEL_WIDTH = 320,
    POPUP_MIN_VISIBLE_HEIGHT = 80,
    init = function(p1, p2) -- init | line: 46
        -- upvalues: t1 (copy), v2 (ref), v3 (ref)
        t1[1] = p1
        v2 = p1:Value({})
        v3 = p2
    end,
    getState = function() -- getState | line: 52
        -- upvalues: v2 (ref)
        return v2
    end
}

local function peekMainDrag() -- line: 56
    -- upvalues: Fusion (copy), v3 (ref)
    if v3 then
        return (Fusion.peek(v3))
    end

    return Vector2.zero
end

local function nextCascadeMultiplier() -- line: 64
    -- upvalues: Fusion (copy), v2 (ref)
    if not v2 then
        return 1
    end

    local n2 = 0

    for _, v4 in (Fusion.peek(v2)) do
        if Fusion.peek(v4.dragOffset) == Vector2.zero and n2 < v4.cascadeMultiplier then
            n2 = v4.cascadeMultiplier
        end
    end

    return n2 + 1
end

local function toggleUnique(p3, p4) -- line: 79
    -- upvalues: Fusion (copy), v2 (ref)
    if not v2 then
        return
    end

    local v5 = Fusion.peek(v2)
    local t3 = {}
    local v6 = false

    for _, v7 in v5 do
        if p3(v7) then
            v6 = true
        else
            table.insert(t3, v7)
        end
    end

    if not v6 then
        table.insert(t3, p4())
    end

    local v8 = v2

    task.defer(function() -- line: 96
        -- upvalues: t3 (copy), v8 (copy)
        if v8 then
            v8:set(t3)
        end
    end)
end

local function newDragValue() -- line: 101
    -- upvalues: Fusion (copy), t1 (copy)
    if t1[1] then
        return t1[1]:Value(Vector2.zero)
    end

    return (Fusion.Value(Fusion.scoped({
        Value = Fusion.Value
    }), Vector2.zero))
end

local function boosterStackSpawn(p5) -- line: 110
    -- upvalues: Fusion (copy), v3 (ref), nextCascadeMultiplier (copy), newDragValue (copy)
    for _, v9 in p5 do
        if v9.kind == "booster" or v9.kind == "commands" then
            return {
                dragOffset = v9.dragOffset,
                cascadeMultiplier = v9.cascadeMultiplier,
                spawnDragSnapshot = v9.spawnDragSnapshot
            }
        end
    end

    return {
        dragOffset = newDragValue(),
        cascadeMultiplier = nextCascadeMultiplier(),
        spawnDragSnapshot = if v3 then Fusion.peek(v3) else Vector2.zero
    }
end

function t2.openProfile(p6) -- line: 127
    -- upvalues: Fusion (copy), v3 (ref), n1 (ref), nextCascadeMultiplier (copy), toggleUnique (copy), newDragValue (copy)
    toggleUnique(function(p7) -- line: 129
        -- upvalues: p6 (copy)
        if p7.userId == p6 then
            return p7.giverIdentity == nil
        end

        return false
    end, function() -- line: 132
        -- upvalues: p6 (copy), Fusion (copy), v3 (ref), n1 (ref), nextCascadeMultiplier (copy), newDragValue (copy)
        n1 += 1

        return {
            id = "profile_" .. n1,
            spawnDragSnapshot = if v3 then Fusion.peek(v3) else Vector2.zero,
            dragOffset = newDragValue(),
            cascadeMultiplier = nextCascadeMultiplier(),
            userId = p6
        }
    end)
end

function t2.openGiverProfile(p8) -- line: 145
    -- upvalues: Fusion (copy), v3 (ref), n1 (ref), nextCascadeMultiplier (copy), toggleUnique (copy), newDragValue (copy)
    toggleUnique(function(p9) -- line: 147
        -- upvalues: p8 (copy)
        local giverIdentity = p9.giverIdentity

        if typeof(giverIdentity) ~= "table" or typeof(p8) ~= "table" then
            return false
        end

        if giverIdentity.type == p8.type then
            return giverIdentity.id == p8.id
        end

        return false
    end, function() -- line: 152
        -- upvalues: p8 (copy), Fusion (copy), v3 (ref), n1 (ref), nextCascadeMultiplier (copy), newDragValue (copy)
        n1 += 1

        return {
            id = "giver_" .. n1,
            spawnDragSnapshot = if v3 then Fusion.peek(v3) else Vector2.zero,
            dragOffset = newDragValue(),
            cascadeMultiplier = nextCascadeMultiplier(),
            giverIdentity = p8
        }
    end)
end

function t2.openTask(p10, p11) -- line: 165
    -- upvalues: Fusion (copy), v3 (ref), n1 (ref), nextCascadeMultiplier (copy), toggleUnique (copy), newDragValue (copy)
    toggleUnique(function(p12) -- line: 167
        -- upvalues: p10 (copy)
        if p12.kind == "task" then
            return p12.taskUID == p10
        end

        return false
    end, function() -- line: 170
        -- upvalues: p10 (copy), p11 (copy), Fusion (copy), v3 (ref), n1 (ref), nextCascadeMultiplier (copy), newDragValue (copy)
        n1 += 1

        return {
            kind = "task",
            id = "task_" .. n1,
            spawnDragSnapshot = if v3 then Fusion.peek(v3) else Vector2.zero,
            dragOffset = newDragValue(),
            cascadeMultiplier = nextCascadeMultiplier(),
            taskUID = p10,
            taskSnapshot = p11
        }
    end)
end

function t2.openEmotes() -- line: 185
    -- upvalues: Fusion (copy), v3 (ref), n1 (ref), nextCascadeMultiplier (copy), toggleUnique (copy), newDragValue (copy)
    toggleUnique(function(p13) -- line: 187
        return p13.kind == "emotes"
    end, function() -- line: 190
        -- upvalues: Fusion (copy), v3 (ref), n1 (ref), nextCascadeMultiplier (copy), newDragValue (copy)
        n1 += 1

        return {
            kind = "emotes",
            id = "emotes_" .. n1,
            spawnDragSnapshot = if v3 then Fusion.peek(v3) else Vector2.zero,
            dragOffset = newDragValue(),
            cascadeMultiplier = nextCascadeMultiplier()
        }
    end)
end

function t2.openOutfits() -- line: 203
    -- upvalues: Fusion (copy), v2 (ref), n1 (ref), boosterStackSpawn (copy)
    if not v2 then
        return
    end

    local v10 = Fusion.peek(v2)
    local t10 = {}
    local v11 = false

    for _, v12 in v10 do
        if v12.kind == "outfits" then
            v11 = true
        else
            table.insert(t10, v12)
        end
    end

    local v13 = v2

    if not v11 then
        local v14 = boosterStackSpawn(t10)

        n1 += 1
        table.insert(t10, {
            kind = "outfits",
            id = "outfits_" .. n1,
            spawnDragSnapshot = v14.spawnDragSnapshot,
            dragOffset = v14.dragOffset,
            cascadeMultiplier = v14.cascadeMultiplier
        })
    end

    task.defer(function() -- line: 217
        -- upvalues: t10 (copy), v13 (copy)
        if v13 then
            v13:set(t10)
        end
    end)
end

function t2.openCommands(p14, p15) -- line: 237
    -- upvalues: Fusion (copy), v2 (ref), n1 (ref), boosterStackSpawn (copy)
    if not v2 then
        return
    end

    local v15 = Fusion.peek(v2)
    local t12 = {}
    local v16 = false

    for _, v17 in v15 do
        if v17.kind == "commands" then
            v16 = true
        else
            table.insert(t12, v17)
        end
    end

    local v18 = v2

    if not v16 or p15 then
        local v19 = boosterStackSpawn(t12)

        n1 += 1
        table.insert(t12, {
            kind = "commands",
            id = "commands_" .. n1,
            spawnDragSnapshot = v19.spawnDragSnapshot,
            dragOffset = v19.dragOffset,
            cascadeMultiplier = v19.cascadeMultiplier,
            commandDisplay = p14
        })
    end

    task.defer(function() -- line: 266
        -- upvalues: t12 (copy), v18 (copy)
        if v18 then
            v18:set(t12)
        end
    end)
end

local function pushPanel(p16) -- line: 271
    -- upvalues: Fusion (copy), v2 (ref)
    if not v2 then
        return
    end

    local v20 = Fusion.peek(v2)
    local v21 = table.clone(v20)

    table.insert(v21, p16)

    local v22 = v2

    task.defer(function() -- line: 277
        -- upvalues: v21 (copy), v22 (copy)
        if v22 then
            v22:set(v21)
        end
    end)
end

local v23 = false

function t2.consumeBoosterSilentClose() -- line: 285
    -- upvalues: v23 (ref)
    local v24 = v23

    v23 = false

    return v24
end

function t2.isBoosterOpen() -- line: 291
    -- upvalues: Fusion (copy), v2 (ref)
    if not v2 then
        return false
    end

    for _, v25 in Fusion.peek(v2) do
        if v25.kind == "booster" then
            return true
        end
    end

    return false
end

function t2.swapBoosterToCommands(p17) -- line: 302
    -- upvalues: Fusion (copy), v2 (ref), n1 (ref), boosterStackSpawn (copy), v23 (ref)
    if not v2 then
        return
    end

    local v26 = Fusion.peek(v2)
    local t14 = {}

    for _, v27 in v26 do
        if v27.kind ~= "booster" and v27.kind ~= "commands" then
            table.insert(t14, v27)
        end
    end

    v23 = true

    local v28 = boosterStackSpawn(t14)

    n1 += 1
    table.insert(t14, {
        kind = "commands",
        id = "commands_" .. n1,
        spawnDragSnapshot = v28.spawnDragSnapshot,
        dragOffset = v28.dragOffset,
        cascadeMultiplier = v28.cascadeMultiplier,
        commandDisplay = p17
    })

    local v29 = v2

    task.defer(function() -- line: 323
        -- upvalues: t14 (copy), v29 (copy)
        if v29 then
            v29:set(t14)
        end
    end)
end

local v30 = false

local function boosterStackOpen() -- line: 331
    -- upvalues: Fusion (copy), v2 (ref)
    if not v2 then
        return false
    end

    for _, v31 in Fusion.peek(v2) do
        if v31.kind == "booster" or v31.kind == "commands" then
            return true
        end
    end

    return false
end

local function fireBoosterOfferNotice() -- line: 341
    -- upvalues: Modules (copy)
    require(Modules.References.requestBoosterOfferRemote):fireServer()
end

function t2.notifyBoosterStackClosed(p18) -- line: 346
    -- upvalues: Modules (copy), v30 (ref), boosterStackOpen (copy)
    if p18 == "booster" then
        v30 = true
    end

    if v30 and not boosterStackOpen() then
        v30 = false
        require(Modules.References.requestBoosterOfferRemote):fireServer()
    end
end

function t2.openBooster(p19) -- line: 357
    -- upvalues: Fusion (copy), v2 (ref), n1 (ref), boosterStackSpawn (copy), v23 (ref)
    if not v2 then
        return
    end

    local v32 = Fusion.peek(v2)
    local t16 = {}
    local v33 = false

    for _, v34 in v32 do
        if v34.kind == "booster" then
            if not p19 then
                table.insert(t16, v34)
            end

            v33 = true
        else
            table.insert(t16, v34)
        end
    end

    if v33 and not p19 then
        return
    end

    if v33 then
        v23 = true
    end

    local v35 = boosterStackSpawn(t16)

    n1 += 1
    table.insert(t16, {
        kind = "booster",
        id = "booster_" .. n1,
        spawnDragSnapshot = v35.spawnDragSnapshot,
        dragOffset = v35.dragOffset,
        cascadeMultiplier = v35.cascadeMultiplier
    })

    local v36 = v2

    task.defer(function() -- line: 388
        -- upvalues: t16 (copy), v36 (copy)
        if v36 then
            v36:set(t16)
        end
    end)
end

function t2.openPreview(p20, p21, p22) -- line: 394
    -- upvalues: Fusion (copy), v3 (ref), n1 (ref), nextCascadeMultiplier (copy), newDragValue (copy), pushPanel (copy)
    n1 += 1
    pushPanel({
        kind = "preview",
        id = "preview_" .. n1,
        spawnDragSnapshot = if v3 then Fusion.peek(v3) else Vector2.zero,
        dragOffset = newDragValue(),
        cascadeMultiplier = nextCascadeMultiplier(),
        previewCommandKey = p20,
        previewArgTokens = p21,
        previewModifierTokens = p22
    })
end

function t2.close(p23) -- line: 408
    -- upvalues: Fusion (copy), v2 (ref)
    if not v2 then
        return
    end

    local v37 = Fusion.peek(v2)
    local t19 = {}

    for _, v38 in v37 do
        if v38.id ~= p23 then
            table.insert(t19, v38)
        end
    end

    local v39 = v2

    task.defer(function() -- line: 418
        -- upvalues: t19 (copy), v39 (copy)
        if v39 then
            v39:set(t19)
        end
    end)
end

function t2.closePreviews() -- line: 423
    -- upvalues: Fusion (copy), v2 (ref)
    if not v2 then
        return
    end

    local t20 = {}

    for _, v40 in Fusion.peek(v2) do
        if v40.kind ~= "preview" then
            table.insert(t20, v40)
        end
    end

    local v41 = v2

    task.defer(function() -- line: 432
        -- upvalues: t20 (copy), v41 (copy)
        if v41 then
            v41:set(t20)
        end
    end)
end

return t2
