-- https://lua.expert

local t1 = {}
local HttpService = game:GetService("HttpService")
local v1 = Random.new()

local function Copy(p1, p2) -- line: 40
    if not p2 then
        return (table.clone(p1))
    end

    local function DeepCopy(p3) -- line: 44
        -- upvalues: DeepCopy (copy)
        local v2 = table.clone(p3)

        for v3, v4 in v2 do
            if type(v4) == "table" then
                v2[v3] = DeepCopy(v4)
            end
        end

        return v2
    end

    return (DeepCopy(p1))
end

local function Sync(p4, p5) -- line: 84
    -- upvalues: Sync (copy)
    assert(type(p4) == "table", "First argument must be a table")
    assert(type(p5) == "table", "Second argument must be a table")

    local v7 = table.clone(p4)

    for v8, v9 in pairs(v7) do
        local v10 = p5[v8]

        if v10 ~= nil then
            if type(v9) == type(v10) then
                if type(v9) == "table" then
                    v7[v8] = Sync(v9, v10)
                end
            elseif type(v10) == "table" then
                local function DeepCopy(p6) -- line: 44
                    -- upvalues: DeepCopy (copy)
                    local v11 = table.clone(p6)

                    for v12, v13 in v11 do
                        if type(v13) == "table" then
                            v11[v12] = DeepCopy(v13)
                        end
                    end

                    return v11
                end

                v7[v8] = DeepCopy(v10)
            else
                v7[v8] = v10
            end
        else
            v7[v8] = nil
        end
    end

    for v14, v15 in pairs(p5) do
        if v7[v14] == nil then
            if type(v15) == "table" then
                local function DeepCopy(p7) -- line: 44
                    -- upvalues: DeepCopy (copy)
                    local v16 = table.clone(p7)

                    for v17, v18 in v16 do
                        if type(v18) == "table" then
                            v16[v17] = DeepCopy(v18)
                        end
                    end

                    return v16
                end

                v7[v14] = DeepCopy(v15)
            else
                v7[v14] = v15
            end
        end
    end

    return v7
end

local function Reconcile(p8, p9) -- line: 156
    -- upvalues: Reconcile (copy)
    assert(type(p8) == "table", "First argument must be a table")
    assert(type(p9) == "table", "Second argument must be a table")

    local v21 = table.clone(p8)

    for v22, v23 in p9 do
        local v24 = p8[v22]

        if v24 ~= nil then
            if type(v24) == "table" then
                if type(v23) == "table" then
                    v21[v22] = Reconcile(v24, v23)
                else
                    local function DeepCopy(p11) -- line: 44
                        -- upvalues: DeepCopy (copy)
                        local v28 = table.clone(p11)

                        for v29, v30 in v28 do
                            if type(v30) == "table" then
                                v28[v29] = DeepCopy(v30)
                            end
                        end

                        return v28
                    end

                    v21[v22] = DeepCopy(v24)
                end
            end
        elseif type(v23) == "table" then
            local function DeepCopy(p10) -- line: 44
                -- upvalues: DeepCopy (copy)
                local v25 = table.clone(p10)

                for v26, v27 in v25 do
                    if type(v27) == "table" then
                        v25[v26] = DeepCopy(v27)
                    end
                end

                return v25
            end

            v21[v22] = DeepCopy(v23)
        else
            v21[v22] = v23
        end
    end

    return v21
end

local function SwapRemove(p12, p13) -- line: 209
    local v31 = #p12

    p12[p13] = p12[v31]
    p12[v31] = nil
end

local function SwapRemoveFirstValue(p14, p15) -- line: 234
    local v32 = table.find(p14, p15)

    if v32 then
        local v33 = #p14

        p14[v32] = p14[v33]
        p14[v33] = nil
    end

    return v32
end

local function Map(p16, p17) -- line: 262
    assert(type(p16) == "table", "First argument must be a table")
    assert(type(p17) == "function", "Second argument must be a function")

    local v36 = table.create(#p16)

    for v37, v38 in p16 do
        v36[v37] = p17(v38, v37, p16)
    end

    return v36
end

local function Filter(p18, p19) -- line: 292
    assert(type(p18) == "table", "First argument must be a table")
    assert(type(p19) == "function", "Second argument must be a function")

    local v41 = table.create(#p18)

    if #p18 > 0 then
        local n1 = 0

        for v42, v43 in p18 do
            if p19(v43, v42, p18) then
                n1 += 1
                v41[n1] = v43
            end
        end
    else
        for v44, v45 in p18 do
            if p19(v45, v44, p18) then
                v41[v44] = v45
            end
        end
    end

    return v41
end

local function Reduce(p20, p21, p22) -- line: 335
    assert(type(p20) == "table", "First argument must be a table")
    assert(type(p21) == "function", "Second argument must be a function")

    local v48 = p22

    if #p20 > 0 then
        local n2 = 1

        if p22 == nil then
            v48 = p20[1]
            n2 = 2
        end

        for i = n2, #p20 do
            v48 = p21(v48, p20[i], i, p20)
        end
    else
        local v49

        if p22 == nil then
            v48 = next(p20)
            v49 = v48
        end

        for v51, v52 in next, p20, v49 do
            v48 = p21(v48, v52, v51, p20)
        end
    end

    return v48
end

local function Assign(p23, ...) -- line: 378
    local v53 = table.clone(p23)

    for _, v54 in { ... } do
        for v55, v56 in v54 do
            v53[v55] = v56
        end
    end

    return v53
end

local function Extend(p24, p25) -- line: 407
    local v57 = table.clone(p24)

    for _, v58 in p25 do
        table.insert(v57, v58)
    end

    return v57
end

local function Reverse(p26) -- line: 432
    local v59 = #p26
    local v60 = table.create(v59)

    for i = 1, v59 do
        v60[i] = p26[v59 - i + 1]
    end

    return v60
end

local function Shuffle(p27, p28) -- line: 459
    -- upvalues: v1 (copy)
    assert(type(p27) == "table", "First argument must be a table")

    local v62 = table.clone(p27)
    local v63 = if typeof(p28) == "Random" then p28 else v1

    for i = #p27, 2, -1 do
        local v64 = v63:NextInteger(1, i)
        local v65 = v62[v64]
        local v66 = v62[i]

        v62[i] = v65
        v62[v64] = v66
    end

    return v62
end

local function Sample(p29, p30, p31) -- line: 489
    -- upvalues: v1 (copy)
    assert(type(p29) == "table", "First argument must be a table")
    assert(type(p30) == "number", "Second argument must be a number")

    local v69 = #p29

    if v69 == 0 then
        return {}
    end

    local v70 = table.clone(p29)
    local v71 = table.create(p30)
    local v72 = if typeof(p31) == "Random" then p31 else v1
    local v73 = math.clamp(p30, 1, v69)

    for i = 1, v73 do
        local v74 = v72:NextInteger(i, v69)
        local v75 = v70[v74]
        local v76 = v70[i]

        v70[i] = v75
        v70[v74] = v76
    end

    table.move(v70, 1, v73, 1, v71)

    return v71
end

local function Flat(p32, p33) -- line: 537
    local v77 = if type(p33) == "number" then p33 else 1
    local v78 = table.create(#p32)

    local function Scan(p34, p35) -- line: 540
        -- upvalues: v78 (copy), v77 (copy), Scan (copy)
        for _, v79 in p34 do
            if type(v79) == "table" and p35 < v77 then
                Scan(v79, p35 + 1)
            else
                table.insert(v78, v79)
            end
        end
    end

    Scan(p32, 0)

    return v78
end

local function FlatMap(p36, p37) -- line: 574
    -- upvalues: Map (copy)
    local v80 = Map(p36, p37)
    local v81 = table.create(#v80)
    local n3 = 1

    local function Scan(p38, p39) -- line: 540
        -- upvalues: v81 (copy), n3 (copy), Scan (copy)
        for _, v82 in p38 do
            if type(v82) == "table" and p39 < n3 then
                Scan(v82, p39 + 1)
            else
                table.insert(v81, v82)
            end
        end
    end

    Scan(v80, 0)

    return v81
end

local function Keys(p40) -- line: 600
    local v83 = table.create(#p40)

    for v84 in p40 do
        table.insert(v83, v84)
    end

    return v83
end

local function Values(p41) -- line: 630
    local v85 = table.create(#p41)

    for _, v86 in p41 do
        table.insert(v85, v86)
    end

    return v85
end

local function Find(p42, p43) -- line: 669
    for v87, v88 in p42 do
        if p43(v88, v87, p42) then
            return v88, v87
        end
    end

    return nil, nil
end

local function Every(p44, p45) -- line: 698
    for v89, v90 in p44 do
        if not p45(v90, v89, p44) then
            return false
        end
    end

    return true
end

local function Some(p46, p47) -- line: 727
    for v91, v92 in p46 do
        if p47(v92, v91, p46) then
            return true
        end
    end

    return false
end

local function Truncate(p48, p49) -- line: 753
    local v93 = #p48
    local v94 = math.clamp(p49, 1, v93)

    if v94 == v93 then
        return (table.clone(p48))
    end

    return (table.move(p48, 1, v94, 1, table.create(v94)))
end

local function Zip(...) -- line: 786
    assert(select("#", ...) > 0, "Must supply at least 1 table")

    local function ZipIteratorArray(p50, p51) -- line: 788
        local v96 = p51 + 1
        local t2 = {}

        for v97, v98 in p50 do
            local v99 = v98[v96]

            if v99 == nil then
                return nil, nil
            end

            t2[v97] = v99
        end

        return v96, t2
    end

    local function ZipIteratorMap(p52, p53) -- line: 801
        local t3 = {}

        for v100, v101 in p52 do
            local v102 = next(v101, p53)

            if v102 == nil then
                return nil, nil
            end

            t3[v100] = v102
        end

        return p53, t3
    end

    local t4 = { ... }

    if #t4[1] > 0 then
        return ZipIteratorArray, t4, 0
    end

    return ZipIteratorMap, t4, nil
end

local function Lock(p54) -- line: 839
    local function Freeze(p55) -- line: 840
        -- upvalues: Freeze (copy)
        for v103, v104 in pairs(p55) do
            if type(v104) == "table" then
                p55[v103] = Freeze(v104)
            end
        end

        return table.freeze(p55)
    end

    return Freeze(p54)
end

local function IsEmpty(p56) -- line: 869
    return next(p56) == nil
end

local function EncodeJSON(p57) -- line: 881
    -- upvalues: HttpService (copy)
    return HttpService:JSONEncode(p57)
end

local function DecodeJSON(p58) -- line: 893
    -- upvalues: HttpService (copy)
    return HttpService:JSONDecode(p58)
end

t1.Copy = Copy
t1.Sync = Sync
t1.Reconcile = Reconcile
t1.SwapRemove = SwapRemove
t1.SwapRemoveFirstValue = SwapRemoveFirstValue
t1.Map = Map
t1.Filter = Filter
t1.Reduce = Reduce
t1.Assign = Assign
t1.Extend = Extend
t1.Reverse = Reverse
t1.Shuffle = Shuffle
t1.Sample = Sample
t1.Flat = Flat
t1.FlatMap = FlatMap
t1.Keys = Keys
t1.Values = Values
t1.Find = Find
t1.Every = Every
t1.Some = Some
t1.Truncate = Truncate
t1.Zip = Zip
t1.Lock = Lock
t1.IsEmpty = IsEmpty
t1.EncodeJSON = EncodeJSON
t1.DecodeJSON = DecodeJSON

return t1
