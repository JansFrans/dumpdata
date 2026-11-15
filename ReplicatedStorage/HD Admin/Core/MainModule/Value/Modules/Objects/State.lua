-- https://lua.expert

local RunService = game:GetService("RunService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Log = require(Modules.Log)
local deepCopyTable = require(Modules.TableUtil.deepCopyTable)
local deepEquals = require(Modules.TableUtil.deepEquals)
local Serializer = require(Modules.Serializer)
local Janitor = require(Modules.Objects.Janitor)

require(Modules.Objects.Signal)

local Players = game:GetService("Players")
local Remote = require(Modules.Objects.Remote)
local v1
local t1 = {}

t1[1] = nil

local t2 = {}
local t3 = {}
local createConnection = require(Modules.AssetUtil.createConnection)

require(Modules.Parent.Packages.Fusion)

local t4 = {}

t4.__index = t4

function t4.getPathwayKey(p1) -- line: 46
    local v2 = ""

    for v3, v4 in p1 do
        if typeof(v4) ~= "string" then
            error("All arguments except final must be strings")
        end

        v2 ..= (if v3 == 1 then "" else "___") .. v4
    end

    return v2
end

function t4.getPathway(p2) -- line: 58
    return (string.split(p2, "___"))
end

function t4.verifyFirstFetch(p3, p4) -- line: 63
    -- upvalues: t3 (copy)
    local v5 = t3[p3]

    if p4 == nil then
        error("State.verifyFirstFetch requires a callback function")
    end

    if typeof(v5) == "boolean" then
        task.defer(function() -- line: 70
            -- upvalues: p4 (copy)
            p4()
        end)
    else
        if v5 == nil then
            v5 = {}
            t3[p3] = v5
        end

        table.insert(v5, p4)
    end
end

function t4.new(p5, p6) -- line: 85
    -- upvalues: Janitor (copy), t4 (copy)
    local v6 = Janitor.new()
    local t5 = {
        _syncingReplicationKey = nil,
        _writeSeq = 0,
        isActive = true,
        _data = {},
        _changeCallbacks = {},
        _anyChangeCallbacks = {},
        _verifyCallbacks = {},
        _activeReplications = {},
        _appliedSeq = {},
        _loaded = {},
        _subscribed = {},
        _subscribeError = {},
        janitor = v6,
        dataMustBeSerializable = p5 == true
    }

    v6:add(function() -- line: 108
        -- upvalues: t5 (copy)
        t5._data = nil
        t5._changeCallbacks = nil
    end)
    setmetatable(t5, t4)

    if p6 then
        t5:setAll(p6)
    end

    return t5
end

function t4.get(p7, ...) -- line: 129
    -- upvalues: deepCopyTable (copy), t4 (copy)
    local t6 = { ... }
    local v7 = t6
    local v8 = t6[1]

    if typeof(v8) == "table" then
        v7 = v8
    else
        v8 = t6
    end

    if p7._syncingReplicationKey then
        local v9 = t4.getPathwayKey(v8)

        if not p7._loaded[v9] and not p7._subscribed[v9] then
            task.spawn(function() -- line: 138
                -- upvalues: p7 (copy), v7 (ref)
                p7:fetchAsync(table.unpack(v7))
            end)
        end
    end

    local v11 = p7._data

    for _, v12 in v7 do
        v11 = v11[v12]

        if v11 == nil then
            return nil
        end
    end

    if typeof(v11) == "table" then
        v11 = deepCopyTable(v11)
    end

    return v11
end

function t4.getAll(p8, p9) -- line: 156
    -- upvalues: deepCopyTable (copy), Serializer (copy)
    if p9 then
        return (Serializer.serialize(p8._data, true))
    end

    return (deepCopyTable(p8._data))
end

function t4.set(p10, ...) -- line: 165
    -- upvalues: deepCopyTable (copy), Serializer (copy), t4 (copy)
    if p10.isActive ~= true then
        return
    end

    local v13 = select("#", ...)
    local v14 = select(v13, ...)
    local t7 = { ... }

    if v13 == #t7 then
        table.remove(t7, v13)
    end

    local v15 = t7[1]

    if typeof(v15) ~= "table" then
        v15 = t7
    end

    if p10.dataMustBeSerializable == true and not Serializer.isValid(v14) then
        error((("State has 'dataMustBeSerializable' enabled, but the value '%*' (type: %*) is not serializable"):format(tostring(v14), (typeof(v14)))))
    end

    local _data = p10._data
    local t8 = {}

    local function buildPathway(p11, p12, p13, p14) -- line: 187
        -- upvalues: p10 (copy), v14 (copy), t8 (copy), deepCopyTable (copy), t4 (copy)
        if typeof(p11) ~= "string" then
            error("Keys must be strings")
        end

        if string.match(p11, "___") then
            error("Keys cannot contain '___'")
        end

        local v16 = if p14 then v14 else p12[p11]

        if v16 == nil and v14 ~= nil then
            v16 = {}
        end

        if not p14 then
            if v14 == nil and typeof(v16) ~= "table" then
                return nil, nil
            end

            if typeof(v16) ~= "table" and typeof(v14) ~= "table" then
                error("Cannot set a multi-pathway-key to a non-table that already exists")
            end
        end

        p12[p11] = v16

        local v17 = if typeof(v16) == "table" then v16 else p12
        local v18 = deepCopyTable(p13)

        table.insert(v18, p11)

        local v19 = t4.getPathwayKey(v18)
        local v20 = p10._changeCallbacks[v19]

        if v20 then
            for _, v21 in v20 do
                table.insert(t8, {
                    v21,
                    v16
                })
            end
        end

        return v17, v18
    end

    local function addValueTablesToPathwayRecursive(p15, p16, p17) -- line: 221
        -- upvalues: buildPathway (copy), addValueTablesToPathwayRecursive (copy)
        if typeof(p15) ~= "table" then
            return
        end

        for v22, v23 in p15 do
            if typeof(v22) == "string" then
                local v24, v25 = buildPathway(v22, p16, p17, nil)

                addValueTablesToPathwayRecursive(v23, v24, v25)
            end
        end
    end

    local v26 = #v15
    local v27 = {}

    for v28, v29 in v15 do
        _data, v27 = buildPathway(v29, _data, v27, v28 == v26)

        if _data == nil then
            return
        end
    end

    addValueTablesToPathwayRecursive(v14, _data, v27)

    for _, v30 in t8 do
        local v31 = v30[1]
        local v32 = v30[2]

        task.spawn(v31, v32)
    end

    local v33 = t4.getPathwayKey(v15)

    p10._writeSeq += 1

    local _writeSeq = p10._writeSeq

    for _, v34 in p10._anyChangeCallbacks do
        task.spawn(v34, v33, v14, _writeSeq)
    end
end

function t4.setAll(p18, p19) -- line: 256
    local v35 = if p19 == nil then {} else p19

    if p18.isActive == true then
        for v36, v37 in v35 do
            p18:set(v36, v37)
        end

        for v38, _ in p18._data do
            if not v35[v38] then
                p18:set(v38, nil)
            end
        end
    end
end

function t4.clear(p20) -- line: 274
    p20:setAll({})
end

function t4.update(p21, ...) -- line: 278
    local v39 = select("#", ...)
    local v40 = select(v39, ...)
    local t10 = { ... }

    if v39 == #t10 then
        table.remove(t10, v39)
    end

    local v41 = t10[1]

    if typeof(v41) ~= "table" then
        v41 = t10
    end

    if typeof(v40) ~= "function" then
        error("Final argument must be a function")
    end

    p21:set(v41, (v40((p21:get(table.unpack(v41))))))
end

function t4.onAnyChange(p22, p23) -- line: 299
    -- upvalues: createConnection (copy)
    local _anyChangeCallbacks = p22._anyChangeCallbacks

    table.insert(_anyChangeCallbacks, p23)

    return createConnection(function() -- line: 302
        -- upvalues: p22 (copy), p23 (copy), _anyChangeCallbacks (copy)
        if p22.isActive == true then
            local v42 = table.find(_anyChangeCallbacks, p23)

            if v42 then
                table.remove(_anyChangeCallbacks, v42)
            end
        end
    end)
end

function t4.onChange(p24, ...) -- line: 313
    -- upvalues: createConnection (copy), t4 (copy)
    local v43 = select("#", ...)
    local v44 = select(v43, ...)
    local t11 = { ... }
    local v45 = t11

    if typeof(v44) ~= "function" then
        error("Final argument must be a function")
    end

    if v43 == #t11 then
        table.remove(t11, v43)
    end

    local v46 = t11[1]

    if typeof(v46) == "table" then
        v45 = v46
    else
        v46 = t11
    end

    local v47 = t4.getPathwayKey(v46)
    local v48 = p24._changeCallbacks[v47]

    if not v48 then
        v48 = {}
        p24._changeCallbacks[v47] = v48
    end

    table.insert(v48, v44)

    if p24._syncingReplicationKey then
        task.spawn(function() -- line: 336
            -- upvalues: p24 (copy), v45 (ref)
            p24:fetchAsync(table.unpack(v45))
        end)
    end

    return createConnection(function() -- line: 340
        -- upvalues: p24 (copy), v44 (copy), v48 (ref)
        if p24.isActive == true then
            local v50 = table.find(v48, v44)

            if v50 then
                table.remove(v48, v50)
            end
        end
    end)
end

function t4.onBind(p25, ...) -- line: 351
    local v51 = select("#", ...)
    local v52 = select(v51, ...)
    local t12 = { ... }

    if typeof(v52) ~= "function" then
        error("Final argument must be a function")
    end

    if v51 == #t12 then
        table.remove(t12, v51)
    end

    local v53 = t12[1]

    if typeof(v53) ~= "table" then
        v53 = t12
    end

    task.spawn(v52, p25:get(table.unpack(v53)))

    return p25:onChange(...)
end

local function applyVerify(p26, p27, p28, p29) -- line: 374
    -- upvalues: deepCopyTable (copy)
    if #p26._verifyCallbacks == 0 then
        return p29
    end

    local v54 = if typeof(p29) == "table" then deepCopyTable(p29) else p29

    for _, v55 in p26._verifyCallbacks do
        local v56, v57 = v55(p27, p28, v54)

        if v56 then
            v54 = v57
        end
    end

    return v54
end

function t4.replicate(p30, p31, p32, p33, p34) -- line: 388
    -- upvalues: RunService (copy), Modules (copy), Log (copy), Janitor (copy), Remote (copy), v1 (ref), t1 (copy), t2 (copy), t3 (copy), createConnection (copy), t4 (copy), applyVerify (copy)
    if RunService:IsServer() == false then
        error("State.replicate can only be called on the server")
    end

    if typeof(p31) ~= "Instance" or p31:IsA("Player") == false then
        error("First argument must be a player")
    end

    local v58 = ("%*_%*"):format(p31.UserId, p32)

    if t2[v58] then
        error((("replicationKey '%*' has already been used'"):format(v58)))
    end

    local v59 = p30.janitor:add(Janitor.new())

    v59:add(function() -- line: 403
        -- upvalues: v58 (copy), t2 (copy)
        t2[v58] = nil
    end)

    if not v1 then
        v1 = Remote.new("StateReplication", "Event")
        t1[1] = Remote.new("StateReplicationRequest", "Function", "Low")
        t1[1]:onServerInvoke(function(p35, p36, ...) -- line: 411
            -- upvalues: t2 (copy)
            if typeof(p36) ~= "string" then
                return false, "Replication name must be a string"
            end

            if string.match(p36, "^(%-?%d+)_") ~= tostring(p35.UserId) then
                return false, "Replication key does not belong to you"
            end

            local v62 = t2[p36]

            if v62 then
                return v62(p35, ...)
            end

            return false, "Replication handler does not exist"
        end)
    end

    t1[1] = t1[1]

    local t13 = {}
    local n1 = 0
    local n2 = 0

    p30._activeReplications[p31] = {
        replicationKey = v58,
        listeners = t13
    }
    v59:add(function() -- line: 438
        -- upvalues: p30 (copy), p31 (copy), t13 (copy)
        p30._activeReplications[p31] = nil

        for v63, _ in t13 do
            t13[v63] = nil
        end
    end)
    v59:add(p31.AncestryChanged:Connect(function() -- line: 444
        -- upvalues: p31 (copy), v59 (copy)
        if p31.Parent == nil and v59.destroy then
            v59:destroy()
        end
    end))

    local t14 = {}

    if p33 then
        for _, v64 in p33 do
            local v65 = t4.getPathwayKey(v64)

            if not t14[v65] then
                t14[v65] = true
            end
        end
    end

    local function replicationHandler(p37, ...) -- line: 462
        -- upvalues: p30 (copy), p33 (copy), p34 (copy), v58 (copy), t13 (copy), n1 (ref), n2 (ref), t14 (copy), Modules (copy), Log (copy), v1 (ref), t3 (copy), t4 (copy), applyVerify (copy)
        local t15 = { ... }

        for _, v66 in t15 do
            if typeof(v66) ~= "string" then
                return false, "Pathways must be strings"
            end
        end

        local v67 = t4.getPathwayKey(t15)
        local v68, v69 = require(Modules.VerifyUtil.isWithinMaxSize)(v67, 200)
        local v70 = not t13[v67]

        if p33 == nil then
            if v68 == false then
                return false, "Incoming pathway exceeded maximum bytes"
            end

            if v70 and n2 >= 256 then
                return false, "Too many active listeners"
            end

            if n1 + v69 > 10000 then
                return false, "Total active listeners exceeded maximum size"
            end
        end

        if p34 then
            local v71 = false

            task.delay(120, function() -- line: 491
                -- upvalues: v67 (copy), v71 (ref), Log (copy)
                if not v71 then
                    Log.debug((("loading '%*' has taken over %* seconds and may be stuck"):format(v67, 120)))
                end
            end)

            local ok, result = pcall(p34, p37, t15)

            v71 = true

            if not ok then
                return false, (("HD Admin: Fetch callback error: %*"):format(result))
            end
        end

        local v72 = t15[1]
        local v73 = t3[v72]

        if v73 == true then
            while t3[v72] == true do
                task.wait(0.05)
            end
        elseif typeof(v73) == "table" then
            t3[v72] = true

            for _, v74 in v73 do
                local v75 = false

                task.delay(120, function() -- line: 515
                    -- upvalues: v72 (copy), v75 (ref), Log (copy)
                    if not v75 then
                        Log.debug((("loading '%*' has taken over %* seconds and may be stuck"):format(v72, 120)))
                    end
                end)

                local ok, result = pcall(v74)

                v75 = true

                if not ok then
                    Log.debug("first fetch callback error:", result)
                end
            end

            t3[v72] = false
        end

        if not t13[v67] then
            if p33 then
                local t16 = {}
                local v76 = false

                for _, v77 in t15 do
                    table.insert(t16, v77)

                    if t14[t4.getPathwayKey(t16)] then
                        v76 = true
                        break
                    end
                end

                if not v76 then
                    return false, (("Not allowed to listen for pathway '%*'"):format(v67))
                end
            end

            n1 += v69
            n2 += 1
            t13[v67] = true
        end

        local v79 = applyVerify(p30, p37, t15, p30:get(table.unpack(t15)))

        v1:fireClient(p37, v58, t15, v79, p30._writeSeq)

        return true
    end

    t2[v58] = replicationHandler

    local v81 = v1

    v59:add(p30:onAnyChange(function(p38, p39, p40) -- line: 556
        -- upvalues: p30 (copy), p31 (copy), v58 (copy), t13 (copy), v81 (copy), t4 (copy), applyVerify (copy)
        local v82 = t13[p38]

        if not v82 then
            for v83, _ in t13 do
                if v83 == string.sub(p38, 1, #v83) then
                    v82 = true
                    break
                end
            end
        end

        if v82 then
            local v85 = t4.getPathway(p38)

            v81:fireClient(p31, v58, v85, applyVerify(p30, p31, v85, p39), p40)
        else
            local v86 = t4.getPathway(p38)

            for v87, _ in t13 do
                local v88 = #p38

                if string.sub(v87, 1, v88) == p38 and (#v87 == v88 or string.sub(v87, v88 + 1, v88 + 3) == "___") then
                    local v92 = t4.getPathway(v87)
                    local v93 = #v86 + 1
                    local v94 = #v92
                    local v95 = p39

                    for i = v93, v94 do
                        if typeof(v95) ~= "table" then
                            v95 = nil
                            break
                        end

                        v95 = v95[v92[i]]
                    end

                    v81:fireClient(p31, v58, v92, applyVerify(p30, p31, v92, v95), p40)
                end
            end
        end
    end))

    return createConnection(function() -- line: 602
        -- upvalues: v59 (copy)
        if v59.destroy then
            v59:destroy()
        end
    end)
end

function t4.resyncPlayer(p41, p42) -- line: 609
    -- upvalues: RunService (copy), v1 (ref), t4 (copy), applyVerify (copy)
    if RunService:IsServer() == false then
        error("State.resyncPlayer can only be called on the server")
    end

    local v96 = p41._activeReplications[p42]

    if not (v96 and v1) then
        return
    end

    p41._writeSeq += 1

    local _writeSeq = p41._writeSeq

    for v97, _ in v96.listeners do
        local v98 = t4.getPathway(v97)
        local v99 = applyVerify(p41, p42, v98, p41:get(table.unpack(v98)))

        v1:fireClient(p42, v96.replicationKey, v98, v99, _writeSeq)
    end
end

function t4.sync(p43, p44) -- line: 629
    -- upvalues: RunService (copy), deepEquals (copy), Players (copy), Remote (copy), v1 (ref), t4 (copy)
    if RunService:IsClient() == false then
        error("State.sync can only be called on the client")
    end

    if p43._syncingReplicationKey ~= nil then
        error("Client state tables can only sync to one server state at a time")
    end

    p43._syncingReplicationKey = ("%*_%*"):format(Players.LocalPlayer.UserId, p44)

    local janitor = p43.janitor

    if v1 == nil then
        v1 = Remote.get("StateReplication")
    end

    if v1 == nil then
        error("StateReplication remote does not exist")
    end

    local v101 = "HD_StateSet_" .. p44

    janitor:add(v1:onClientEvent(function(p45, p46, p47, p48) -- line: 649
        -- upvalues: p43 (copy), v101 (copy), deepEquals (copy), t4 (copy)
        if p45 ~= p43._syncingReplicationKey then
            return
        end

        local v103 = t4.getPathwayKey(p46)
        local v104 = p43._appliedSeq[v103]

        if typeof(p48) ~= "number" or v104 == nil or not (p48 <= v104) then
            if typeof(p48) == "number" then
                p43._appliedSeq[v103] = p48
            end

            if not deepEquals(p43:get(table.unpack(p46)), p47) then
                debug.profilebegin(v101)
                p43:set(p46, p47)
                debug.profileend()
            end
        end

        p43._loaded[v103] = true
    end))
end

function t4.fetch(p49, ...) -- line: 676
    local v105 = select("#", ...)
    local v106 = select(v105, ...)
    local t17 = { ... }
    local v107 = t17
    local v108

    if typeof(v106) == "function" then
        v108 = v106
        table.remove(t17, v105)
    end

    local v109 = t17[1]

    if typeof(v109) == "table" then
        v107 = v109
    end

    task.spawn(function() -- line: 694
        -- upvalues: p49 (copy), v107 (ref), v108 (ref)
        local v111, v112 = p49:fetchAsync(table.unpack(v107))

        if v111 and v108 then
            v108(v112)
        end
    end)
end

function t4.fetchAsync(p50, ...) -- line: 702
    -- upvalues: RunService (copy), Log (copy), Remote (copy), t1 (copy), t4 (copy)
    if RunService:IsClient() == false then
        error("State.sync can only be called on the client")
    end

    if p50._syncingReplicationKey == nil then
        error("State.fetchAsync can only be called after State.sync")
    end

    local t18 = { ... }
    local v113 = t18[1]

    if typeof(v113) ~= "table" then
        v113 = t18
    end

    local v114 = t4.getPathwayKey(v113)

    if p50._loaded[v114] then
        return true, p50:get(table.unpack(v113))
    end

    if not p50._subscribed[v114] then
        p50._subscribed[v114] = true
        p50._subscribeError[v114] = nil

        if t1[1] == nil then
            t1[1] = Remote.get("StateReplicationRequest")
        end

        if t1[1] == nil then
            error("StateReplicationRequest remote does not exist")
        end

        t1[1] = t1[1]

        local v115, v116 = t1[1]:invokeServerAsync(p50._syncingReplicationKey, table.unpack(v113))

        if not v115 then
            p50._subscribed[v114] = nil

            local _subscribeError = p50._subscribeError

            if typeof(v116) == "string" then
                _subscribeError[v114] = v116
            else
                _subscribeError[v114] = "subscribe failed"
            end

            Log.debug((("state subscribe for '%*' was rejected: %*"):format(v114, (tostring(v116)))))
        end
    end

    local elapsed = os.clock()
    local v117

    while true do
        if p50._loaded[v114] then
            return true, p50:get(table.unpack(v113))
        end

        v117 = p50._subscribeError[v114]

        if v117 then
            break
        end

        if os.clock() - elapsed > 120 then
            p50._subscribed[v114] = nil
            Log.debug((("'%*' hasn't arrived from the server after %* seconds"):format(v114, 120)))

            return false, "Timed out waiting for replication"
        end

        task.wait()
    end

    return false, v117
end

function t4.verify(p51, p52) -- line: 755
    -- upvalues: createConnection (copy)
    local _verifyCallbacks = p51._verifyCallbacks

    table.insert(_verifyCallbacks, p52)

    return createConnection(function() -- line: 758
        -- upvalues: p51 (copy), p52 (copy), _verifyCallbacks (copy)
        if p51.isActive == true then
            local v118 = table.find(_verifyCallbacks, p52)

            if v118 then
                table.remove(_verifyCallbacks, v118)
            end
        end
    end)
end

function t4.fuse(p53, p54, ...) -- line: 769
    local t19 = { ... }
    local v119 = t19[1]
    local v120

    if typeof(v119) == "table" then
        v120 = v119
    else
        v119 = t19
        v120 = t19
    end

    local t20 = {}

    t20[1] = p53

    local v121 = p54:Value(p53:get(v119))
    local v122 = v120

    local function v123(p55) -- line: 780
        -- upvalues: v121 (copy)
        v121:set(p55)
    end

    local v124 = t20[1]:onChange(v122, v123)

    local function v125() -- line: 787
        -- upvalues: v124 (ref)
        if v124 then
            v124.Disconnect()
            v124 = nil
        end
    end

    table.insert(p54, v125)

    local function disconnect() -- line: 795
        -- upvalues: p54 (copy), v125 (copy)
        v125()

        for i = #p54, 1, -1 do
            if p54[i] == v125 then
                table.remove(p54, i)

                return
            end
        end
    end

    return v121, function(...) -- refuse | line: 806
        -- upvalues: v120 (ref), t20 (copy), v121 (copy), v124 (ref)
        if v124 then
            v124.Disconnect()
            v124 = nil
        end

        local t21 = { ... }

        if #t21 == 2 then
            t20[1] = t21[1]
            v120 = t21[2]
        else
            v120 = t21[1]
        end

        local v126 = t20[1]
        local v127 = v120

        v121:set(v126:get(v127))
        v124 = t20[1]:onChange(v120, function(p56) -- line: 780
            -- upvalues: v121 (copy)
            v121:set(p56)
        end)
    end, disconnect
end

function t4.destroy(p57) -- line: 827
    if p57.isActive ~= false then
        p57.isActive = false
        p57.janitor:destroy()
    end
end

return t4
