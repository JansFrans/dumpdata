-- https://lua.expert

local _ = script:FindFirstAncestor("MainModule").Value.Modules
local isStringSafe = require(script.Parent.isStringSafe)
local isNumberSafe = require(script.Parent.isNumberSafe)
local v1

local function rawNext(p1, p2) -- line: 26
    return next(p1, p2)
end

local function eachKey(p3) -- line: 30
    local v2

    return function() -- line: 32
        -- upvalues: p3 (copy), v2 (ref)
        local v3 = v2

        v2 = next(p3, v3)

        return v2
    end
end

local function checkAtomString(p4) -- line: 38
    -- upvalues: isStringSafe (copy)
    if isStringSafe(p4) then
        return true, p4
    end

    return false, "expected safe string"
end

local function checkAtomSafeNumber(p5) -- line: 45
    -- upvalues: isNumberSafe (copy)
    if isNumberSafe(p5) then
        return true, p5
    end

    return false, "expected safe number"
end

local function checkAtomPositiveInteger(p6) -- line: 52
    -- upvalues: isNumberSafe (copy)
    if not isNumberSafe(p6) or p6 <= 0 or p6 ~= math.floor(p6) then
        return false, "expected positive integer"
    end

    return true, p6
end

local function checkAtomNonNegativeInteger(p7) -- line: 62
    -- upvalues: isNumberSafe (copy)
    if not isNumberSafe(p7) or p7 < 0 or p7 ~= math.floor(p7) then
        return false, "expected non-negative integer"
    end

    return true, p7
end

local function checkAtomBoolean(p8) -- line: 72
    if typeof(p8) == "boolean" then
        return true, p8
    end

    return false, "expected boolean"
end

local function checkAtomColor3(p9) -- line: 79
    if typeof(p9) == "Color3" then
        return true, p9
    end

    return false, "expected Color3"
end

local function checkOneOf(p10, p11) -- line: 86
    if typeof(p11) ~= "table" then
        return false, "malformed shape: oneOf needs a list"
    end

    local n1 = 0

    repeat
        n1 += 1

        local v4 = rawget(p11, n1)

        if v4 == nil then
            return false, "value not in allowed list"
        end
    until p10 == v4

    return true, p10
end

local function checkArray(p12, p13, p14, p15) -- line: 100
    -- upvalues: v1 (ref)
    if typeof(p12) ~= "table" then
        return false, "expected an array"
    end

    if p15[p12] then
        return false, "cyclic reference"
    end

    p15[p12] = true

    local max = rawget(p13, "max")

    if typeof(max) ~= "number" then
        max = 1000
    end

    local array = rawget(p13, "array")
    local v5

    local function v6() -- line: 32
        -- upvalues: p12 (copy), v5 (ref)
        local v7 = v5

        v5 = next(p12, v7)

        return v5
    end

    local n2 = 0

    for _ in v6 do
        n2 += 1
    end

    if max < n2 then
        return false, (("array too long (max %*)"):format(max))
    end

    local t1 = {}

    for i = 1, n2 do
        local v8 = rawget(p12, i)

        if v8 == nil then
            return false, "array must have contiguous integer keys 1..n"
        end

        local v9, v10 = v1(v8, array, p14 + 1, p15)

        if not v9 then
            return false, (("entry %*: %*"):format(i, v10))
        end

        table.insert(t1, v10)
    end

    local v11

    for v13 in function() -- line: 32
            -- upvalues: p12 (copy), v11 (ref)
            local v12 = v11

            v11 = next(p12, v12)

            return v11
        end do
        if typeof(v13) ~= "number" or v13 ~= math.floor(v13) or v13 < 1 or n2 < v13 then
            return false, (("array has unexpected key '%*'"):format((tostring(v13))))
        end
    end

    return true, t1
end

local function checkObject(p16, p17, p18, p19) -- line: 139
    -- upvalues: v1 (ref)
    if typeof(p16) ~= "table" then
        return false, "expected an object"
    end

    if p19[p16] then
        return false, "cyclic reference"
    end

    p19[p16] = true

    local v14

    for v16 in function() -- line: 32
            -- upvalues: p16 (copy), v14 (ref)
            local v15 = v14

            v14 = next(p16, v15)

            return v14
        end do
        if typeof(v16) ~= "string" then
            return false, (("unexpected non-string key '%*'"):format((tostring(v16))))
        end

        if rawget(p17, v16) == nil then
            return false, (("unexpected key '%*'"):format(v16))
        end
    end

    local t2 = {}
    local v17

    for v19 in function() -- line: 32
            -- upvalues: p17 (copy), v17 (ref)
            local v18 = v17

            v17 = next(p17, v18)

            return v17
        end do
        if typeof(v19) ~= "string" then
            return false, (("malformed shape: non-string key '%*'"):format((tostring(v19))))
        end

        local v20 = rawget(p17, v19)
        local v21 = typeof(v20) == "table" and rawget(v20, "optional") ~= nil

        if v21 then
            v20 = rawget(v20, "optional")
        end

        local v22 = rawget(p16, v19)

        if v22 ~= nil then
            local v23, v24 = v1(v22, v20, p18 + 1, p19)

            if not v23 then
                return false, (("field '%*': %*"):format(v19, v24))
            end

            t2[v19] = v24
        elseif not v21 then
            return false, (("missing required key '%*'"):format(v19))
        end
    end

    return true, t2
end

local t3 = {
    string = checkAtomString,
    safeNumber = checkAtomSafeNumber,
    positiveInteger = checkAtomPositiveInteger,
    nonNegativeInteger = checkAtomNonNegativeInteger,
    boolean = checkAtomBoolean,
    Color3 = checkAtomColor3
}

v1 = function(p20, p21, p22, p23) -- line: 188
    -- upvalues: checkOneOf (copy), checkArray (copy), checkObject (copy), t3 (copy)
    if p22 > 8 then
        return false, "exceeded max nesting depth"
    end

    if typeof(p21) == "string" then
        local v25 = t3[p21]

        if v25 then
            return v25(p20)
        end

        return false, (("malformed shape: unknown atom '%*'"):format(p21))
    end

    if typeof(p21) ~= "table" then
        return false, (("malformed shape: expected string or table, got %*"):format((typeof(p21))))
    end

    if rawget(p21, "oneOf") ~= nil then
        return checkOneOf(p20, (rawget(p21, "oneOf")))
    end

    if rawget(p21, "array") ~= nil then
        return checkArray(p20, p21, p22, p23)
    end

    if rawget(p21, "shape") == nil then
        return checkObject(p20, p21, p22, p23)
    end

    return checkObject(p20, rawget(p21, "shape"), p22, p23)
end

return function(p24, p25) -- line: 217
    -- upvalues: v1 (ref)
    local v26 = v1
    local t4 = {}
    local v27, v28, v29 = pcall(v26, p24, p25, 0, t4)

    if v27 then
        return v28, v29
    end

    return false, "internal error during validation"
end
