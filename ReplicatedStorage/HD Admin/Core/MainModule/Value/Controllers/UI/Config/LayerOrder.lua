-- https://lua.expert

local Packages = script:FindFirstAncestor("MainModule").Value.Modules.Parent.Packages
local UserInputService = game:GetService("UserInputService")
local Fusion = require(Packages.Fusion)
local v1 = Fusion.scoped({
    Value = Fusion.Value
})
local t1 = {}
local v2 = v1:Value({})
local t2 = {}
local t3 = {}
local t4 = {}
local v3 = false

local function sameOrder(p1, p2) -- line: 37
    if #p1 ~= #p2 then
        return false
    end

    for v4, v5 in p1 do
        if p2[v4] ~= v5 then
            return false
        end
    end

    return true
end

local function reorder(p3) -- line: 47
    -- upvalues: Fusion (copy), v2 (copy)
    task.defer(function() -- line: 48
        -- upvalues: p3 (copy), Fusion (copy), v2 (copy)
        local v6 = Fusion.peek(v2)
        local v7 = p3(v6)
        local v8

        if #v7 == #v6 then
            local v9 = false

            for v10, v11 in v7 do
                if v6[v10] ~= v11 then
                    v8 = false
                    v9 = true
                    break
                end
            end

            if not v9 then
                v8 = true
            end
        else
            v8 = false
        end

        if not v8 then
            v2:set(v7)
        end
    end)
end

local function moveToFront(p4) -- line: 57
    -- upvalues: Fusion (copy), v2 (copy)
    local function v12(p5) -- line: 58
        -- upvalues: p4 (copy)
        local t5 = {}
        local t6 = {}

        for _, v13 in p5 do
            if p4[v13] then
                table.insert(t6, v13)
            else
                table.insert(t5, v13)
            end
        end

        for _, v14 in t6 do
            table.insert(t5, v14)
        end

        return t5
    end

    task.defer(function() -- line: 48
        -- upvalues: v12 (copy), Fusion (copy), v2 (copy)
        local v15 = Fusion.peek(v2)
        local v16 = v12(v15)
        local v17

        if #v16 == #v15 then
            local v18 = false

            for v19, v20 in v16 do
                if v15[v19] ~= v20 then
                    v17 = false
                    v18 = true
                    break
                end
            end

            if not v18 then
                v17 = true
            end
        else
            v17 = false
        end

        if not v17 then
            v2:set(v16)
        end
    end)
end

local function layerAt(p6) -- line: 75
    -- upvalues: Fusion (copy), v2 (copy), t3 (copy)
    local v21 = Fusion.peek(v2)

    for i = #v21, 1, -1 do
        local v22 = v21[i]
        local v23 = t3[v22]

        if v23 and v23.Parent and v23.Visible then
            local AbsolutePosition, AbsoluteSize = v23.AbsolutePosition, v23.AbsoluteSize

            if p6.X >= AbsolutePosition.X and p6.X <= AbsolutePosition.X + AbsoluteSize.X and p6.Y >= AbsolutePosition.Y and p6.Y <= AbsolutePosition.Y + AbsoluteSize.Y then
                return v22
            end
        end
    end

    return nil
end

local function onInputBegan(p7) -- line: 92
    -- upvalues: t1 (copy), t4 (copy), layerAt (copy)
    if p7.UserInputType ~= Enum.UserInputType.MouseButton1 and p7.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    for _, v24 in t4 do
        if v24() then
            return
        end
    end

    local v25 = layerAt(Vector2.new(p7.Position.X, p7.Position.Y))

    if v25 then
        t1.raise(v25)
    end
end

function t1.register(p8, p9, p10, p11) -- line: 107
    -- upvalues: Fusion (copy), t1 (copy), v2 (copy), t2 (copy)
    if p10 then
        t2[p9] = p10
    end

    local function v26(p12) -- line: 111
        -- upvalues: p9 (copy), p11 (copy)
        local v27 = table.clone(p12)
        local v28 = if p11 then table.find(v27, p11) else nil

        if v28 then
            table.insert(v27, v28, p9)
        else
            table.insert(v27, p9)
        end

        return v27
    end

    task.defer(function() -- line: 48
        -- upvalues: v26 (copy), Fusion (copy), v2 (copy)
        local v29 = Fusion.peek(v2)
        local v30 = v26(v29)
        local v31

        if #v30 == #v29 then
            local v32 = false

            for v33, v34 in v30 do
                if v29[v33] ~= v34 then
                    v31 = false
                    v32 = true
                    break
                end
            end

            if not v32 then
                v31 = true
            end
        else
            v31 = false
        end

        if not v31 then
            v2:set(v30)
        end
    end)
    table.insert(p8, function() -- line: 121
        -- upvalues: p9 (copy), t1 (copy)
        t1.unregister(p9)
    end)

    return p8:Computed(function(p13) -- line: 124
        -- upvalues: p9 (copy), p11 (copy), v2 (copy)
        local v36 = p13(v2)

        for v37, v38 in v36 do
            if v38 == p9 then
                return v37
            end
        end

        if p11 then
            return 0
        end

        return #v36 + 1
    end)
end

function t1.attach(p14, p15) -- line: 137
    -- upvalues: t3 (copy)
    t3[p14] = p15
end

function t1.unregister(p16) -- line: 141
    -- upvalues: Fusion (copy), v2 (copy), t2 (copy), t3 (copy)
    t2[p16] = nil
    t3[p16] = nil

    local function v39(p17) -- line: 144
        -- upvalues: p16 (copy)
        local t7 = {}

        for _, v40 in p17 do
            if v40 ~= p16 then
                table.insert(t7, v40)
            end
        end

        return t7
    end

    task.defer(function() -- line: 48
        -- upvalues: v39 (copy), Fusion (copy), v2 (copy)
        local v41 = Fusion.peek(v2)
        local v42 = v39(v41)
        local v43

        if #v42 == #v41 then
            local v44 = false

            for v45, v46 in v42 do
                if v41[v45] ~= v46 then
                    v43 = false
                    v44 = true
                    break
                end
            end

            if not v44 then
                v43 = true
            end
        else
            v43 = false
        end

        if not v43 then
            v2:set(v42)
        end
    end)
end

function t1.raise(p18) -- line: 155
    -- upvalues: Fusion (copy), v2 (copy), t2 (copy)
    local v47 = t2[p18]
    local t8 = {}

    if v47 then
        for v48, v49 in t2 do
            if v49 == v47 then
                t8[v48] = true
            end
        end
    else
        t8[p18] = true
    end

    local function v50(p19) -- line: 58
        -- upvalues: t8 (copy)
        local t9 = {}
        local t10 = {}

        for _, v51 in p19 do
            if t8[v51] then
                table.insert(t10, v51)
            else
                table.insert(t9, v51)
            end
        end

        for _, v52 in t10 do
            table.insert(t9, v52)
        end

        return t9
    end

    task.defer(function() -- line: 48
        -- upvalues: v50 (copy), Fusion (copy), v2 (copy)
        local v53 = Fusion.peek(v2)
        local v54 = v50(v53)
        local v55

        if #v54 == #v53 then
            local v56 = false

            for v57, v58 in v54 do
                if v53[v57] ~= v58 then
                    v55 = false
                    v56 = true
                    break
                end
            end

            if not v56 then
                v55 = true
            end
        else
            v55 = false
        end

        if not v55 then
            v2:set(v54)
        end
    end)
end

function t1.addBlocker(p20) -- line: 172
    -- upvalues: t4 (copy)
    table.insert(t4, p20)
end

function t1.init(p21) -- line: 176
    -- upvalues: UserInputService (copy), v3 (ref), onInputBegan (copy)
    if v3 then
        return
    end

    v3 = true
    table.insert(p21, (UserInputService.InputBegan:Connect(onInputBegan)))
end

return t1
