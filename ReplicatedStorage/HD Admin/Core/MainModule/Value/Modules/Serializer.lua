-- https://lua.expert

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local t1 = {}
local t2 = {}
local t3 = {}
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Log = require(Modules.Log)
local isWithinMaxSize = require(Modules.VerifyUtil.isWithinMaxSize)
local isNumberSafe = require(Modules.VerifyUtil.isNumberSafe)
local doTypesMatch = require(Modules.DataUtil.doTypesMatch)
local Compressor = require(Modules.Serializer.Compressor)
local t4 = {
    string = {
        identifier = "s",
        serialize = function(p1) -- serialize | line: 29
            if p1:match("^%l_") then
                return p1
            end

            return p1, true
        end,
        deserialize = function(p2) -- deserialize | line: 40
            return p2
        end
    },
    Color3 = {
        identifier = "c",
        serialize = function(p3) -- serialize | line: 46
            return ("%02x%02x%02x"):format(math.floor(p3.r * 255 + 0.5), math.floor(p3.g * 255 + 0.5), (math.floor(p3.b * 255 + 0.5)))
        end,
        deserialize = function(p4) -- deserialize | line: 52
            local v6, v7, v8 = p4:match("(..)(..)(..)")
            local v9 = tonumber(v6, 16)
            local v10 = tonumber(v7, 16)
            local v11 = tonumber(v8, 16)

            return Color3.fromRGB(v9, v10, v11)
        end
    },
    EnumItem = {
        identifier = "e",
        serialize = function(p5) -- serialize | line: 68
            return tostring(p5):sub(6)
        end,
        deserialize = function(p6) -- deserialize | line: 71
            local v12 = p6:split(".")

            return Enum[v12[1]][v12[2]]
        end
    },
    CFrame = {
        identifier = "f",
        serialize = function(p7) -- serialize | line: 78
            return tostring(p7):gsub(" ", "")
        end,
        deserialize = function(p8) -- deserialize | line: 81
            local v13 = p8:split(",")

            return CFrame.new(unpack(v13))
        end
    },
    Vector3 = {
        identifier = "v",
        serialize = function(p9) -- serialize | line: 88
            return tostring(p9):gsub(" ", "")
        end,
        deserialize = function(p10) -- deserialize | line: 91
            local v14 = p10:split(",")

            return (Vector3.new(v14[1], v14[2], v14[3]))
        end
    },
    table = {
        isValid = function(p11) -- isValid | line: 97
            -- upvalues: t1 (copy)
            for v18, v19 in p11 do
                if not t1.isValid(v18) or not t1.isValid(v19) then
                    return false
                end
            end

            return true
        end,
        serialize = function(p12, p13, p14) -- serialize | line: 107
            -- upvalues: t1 (copy)
            local v20 = if p13 then {} else p12
            local t6 = {}

            for v21, v22 in p12 do
                t6[v21] = v22
            end

            for v23, v24 in t6 do
                local v25 = t1.serialize(v23, p13, p14)
                local v26 = t1.serialize(v24, p13, p14)

                v20[v23] = nil

                if typeof(v25) == "number" or typeof(v25) == "string" then
                    v20[v25] = v26
                end
            end

            return v20
        end,
        deserialize = function(p15, p16, p17) -- deserialize | line: 128
            -- upvalues: t1 (copy)
            local t7 = {}

            for v27, v28 in p15 do
                t7[v27] = v28
            end

            for v29, v30 in t7 do
                local v31 = t1.deserialize(v29, p16, p17)
                local v32 = t1.deserialize(v30, p16, p17)

                p15[v29] = nil
                p15[v31] = v32
            end

            return p15
        end
    },
    Instance = {
        isValid = function(p18) -- isValid | line: 148
            -- upvalues: t3 (copy)
            return not not t3[p18.ClassName]
        end,
        serialize = function(p19) -- serialize | line: 155
            -- upvalues: t1 (copy), t3 (copy), isWithinMaxSize (copy), doTypesMatch (copy)
            local ClassName = p19.ClassName
            local v33 = t3[ClassName]

            if not v33 then
                return nil, true
            end

            local v34 = require(v33)
            local ProcessInstance = v34.ProcessInstance
            local v35 = if ProcessInstance then ProcessInstance(p19) else p19
            local t9 = {}

            for v36, v37 in v34.Template do
                local v38 = v35[v36]

                if v38 and doTypesMatch(v37, v38) and v37 ~= v38 then
                    t9[v36] = t1.serialize(v38, true)
                end
            end

            if v34.GetChildren then
                local t10 = {}
                local ChildrenAllowlist = v34.ChildrenAllowlist

                for _, child in (v35:GetChildren()) do
                    if not ChildrenAllowlist or table.find(ChildrenAllowlist, child.ClassName) then
                        table.insert(t10, (t1.serialize(child, true)))

                        if not t9._icc then
                            t9._icc = t10
                        end
                    end
                end
            end

            if not isWithinMaxSize(t9, v34.DataLimit) then
                return nil, true
            end

            t9._icn = ClassName

            return t9
        end,
        deserialize = function(p20, _) -- deserialize | line: 199
            -- upvalues: t1 (copy), t3 (copy), isWithinMaxSize (copy), doTypesMatch (copy)
            local _icn = p20._icn

            if not _icn then
                return nil, true
            end

            local v41 = t3[_icn]

            if not v41 then
                return nil, true
            end

            local v42 = require(v41)

            if not isWithinMaxSize(p20, v42.DataLimit) then
                return nil, true
            end

            local v43 = Instance.new(_icn)
            local v44 = v43
            local _icc = p20._icc

            if _icc and v42.GetChildren then
                local ChildrenAllowlist = v42.ChildrenAllowlist

                for _, v45 in _icc do
                    if typeof(v45) == "table" then
                        local _icn = v45._icn

                        if not ChildrenAllowlist or table.find(ChildrenAllowlist, _icn) then
                            local v47 = t1.deserialize(v45, true)

                            if v47 then
                                v47.Parent = v43
                            end
                        end
                    end
                end
            end

            for v48, v49 in v42.Template do
                local v50 = p20[v48]
                local v51 = t1.deserialize(v50, true)
                local v52 = v49

                if v51 and doTypesMatch(v51, v49) then
                    v52 = v51
                else
                    v51 = v49
                end

                local v53 = v44

                v53[v48] = v51
                task.defer(function() -- line: 238
                    -- upvalues: v44 (ref), v48 (copy), v52 (ref)
                    local function v54() -- line: 242
                        -- upvalues: v44 (ref), v48 (copy), v52 (ref)
                        v44[v48] = v52
                    end

                    pcall(v54)
                end)
            end

            local ProcessInstance = v42.ProcessInstance

            if ProcessInstance then
                v44 = ProcessInstance(v44)
            end

            return v44
        end
    }
}

local function deepCopyOnce(p22) -- line: 254
    local t11 = {}

    for v56, v57 in p22 do
        t11[v56] = v57
    end

    return t11
end

for _, v58 in t4 do
    if v58.identifier then
        t2[v58.identifier .. "_"] = v58
    end
end

for _, descendant in (script.Serializables:GetDescendants()) do
    t3[descendant.Name] = descendant
end

function t1.compress(p23) -- line: 278
    -- upvalues: HttpService (copy), Compressor (copy)
    return (Compressor:compress((HttpService:JSONEncode(p23))))
end

function t1.decompress(p24) -- line: 284
    -- upvalues: HttpService (copy), Log (copy), Compressor (copy)
    local function v60() -- line: 287
        -- upvalues: p24 (copy), HttpService (copy), Compressor (copy)
        return HttpService:JSONDecode((Compressor:decompress(p24)))
    end

    local ok, result = pcall(v60)

    if ok then
        return result
    end

    Log.debug((("Serializer decompress failed (corrupt data?): %*"):format((tostring(result)))))

    return nil
end

function t1.serialize(p25, p26) -- line: 298
    -- upvalues: t1 (copy), t4 (copy)
    if not t1.isValid(p25) then
        return
    end

    local v62 = typeof(p25)
    local v63 = t4[v62]

    if not (v63 and v63.serialize) then
        return p25
    end

    local v64 = p25

    if v62 == "table" and p26 then
        v64 = {}

        for v65, v66 in p25 do
            v64[v65] = v66
        end
    end

    local v67, v68 = v63.serialize(v64, p26)

    if not v68 and v63.identifier then
        v67 = v63.identifier .. "_" .. v67
    end

    return v67
end

function t1.deserialize(p27, p28, p29) -- line: 319
    -- upvalues: t2 (copy), t4 (copy)
    local v69 = typeof(p27)

    if p29 or v69 ~= "string" then
        if v69 ~= "table" then
            return p27
        end

        local v70 = p27

        if p28 then
            v70 = {}

            for v71, v72 in p27 do
                v70[v71] = v72
            end
        end

        return t4[if v70._icn then "Instance" else "table"].deserialize(v70, p28, p29)
    end

    local v75 = t2[p27:match("^%l_")]

    if not (v75 and v75.deserialize) then
        return p27
    end

    return v75.deserialize(p27:sub(3))
end

function t1.process(p30, p31) -- line: 341
    -- upvalues: t1 (copy)
    local v76 = t1.serialize(p30, p31)

    return (t1.compress(v76))
end

function t1.unprocess(p32, p33) -- line: 347
    -- upvalues: t1 (copy)
    local v77 = t1.decompress(p32)

    return (t1.deserialize(v77, p33))
end

function t1.processForNetwork(p34) -- line: 353
    -- upvalues: RunService (copy), t1 (copy)
    if RunService:IsServer() then
        local function scanTable(p35) -- line: 355
            -- upvalues: scanTable (copy), t1 (copy)
            for v78, v79 in p35 do
                if typeof(v79) == "table" then
                    scanTable(v79)
                elseif t1.mustSerializeOverNetwork(v79) then
                    p35[v78] = t1.serialize(v79)
                end
            end
        end

        scanTable(p34)
    else
        local deserialize = t1.deserialize
        local ok, result = pcall(deserialize, p34, false, true)

        if ok then
            return result
        end
    end

    return p34
end

function t1.mustSerializeOverNetwork(p36) -- line: 378
    -- upvalues: t4 (copy)
    local v81 = t4[typeof(p36)]

    return not not (v81 and v81.serializeOverNetwork)
end

function t1.isValid(p37) -- line: 388
    -- upvalues: isNumberSafe (copy), t4 (copy)
    local v82 = typeof(p37)
    local v83 = t4[v82]
    local v84 = v83 and v83.isValid

    if v84 and not v84(p37) then
        return false
    end

    if v82 == "number" then
        return isNumberSafe(p37)
    end

    return not (not v83 and v82 ~= "boolean" and v82 ~= "nil")
end

return t1
