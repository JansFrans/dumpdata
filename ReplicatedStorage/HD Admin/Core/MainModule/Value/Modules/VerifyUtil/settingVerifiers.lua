-- https://lua.expert

local _ = script:FindFirstAncestor("MainModule").Value.Modules
local isStringSafe = require(script.Parent.isStringSafe)
local isNumberSafe = require(script.Parent.isNumberSafe)
local isWithinMaxSize = require(script.Parent.isWithinMaxSize)
local matchesShape = require(script.Parent.matchesShape)
local filterTextAsync = require(script.Parent.filterTextAsync)

local function unwrapSingleArray(p1) -- line: 14
    if typeof(p1) ~= "table" or #p1 ~= 1 then
        return p1
    end

    return p1[1]
end

return {
    boolean = function() -- boolean | line: 27
        return function(_, p3, _) -- line: 28
            if typeof(p3) == "boolean" then
                return true, p3
            end

            return false, "Expected a boolean"
        end
    end,
    color3 = function() -- color3 | line: 38
        return function(_, p6, _) -- line: 39
            if typeof(p6) == "Color3" then
                return true, p6
            end

            return false, "Expected a Color3"
        end
    end,
    integerRange = function(p8, p9) -- integerRange | line: 48
        -- upvalues: isNumberSafe (copy)
        return function(_, p11, _) -- line: 49
            -- upvalues: p8 (copy), p9 (copy), isNumberSafe (copy)
            if not isNumberSafe(p11) then
                return false, "Expected a number"
            end

            local v1 = math.round(p11)

            if v1 ~= p11 then
                v1 = math.floor(p11 + 0.5)
            end

            return true, (math.clamp(v1, p8, p9))
        end
    end,
    numberRange = function(p13, p14) -- numberRange | line: 64
        -- upvalues: isNumberSafe (copy)
        return function(_, p16, _) -- line: 65
            -- upvalues: p13 (copy), p14 (copy), isNumberSafe (copy)
            if isNumberSafe(p16) then
                return true, (math.clamp(p16, p13, p14))
            end

            return false, "Expected a number"
        end
    end,
    oneOfString = function(p18) -- oneOfString | line: 74
        -- upvalues: isStringSafe (copy)
        return function(_, p20, _) -- line: 75
            -- upvalues: p18 (copy), isStringSafe (copy)
            local v3 = if typeof(p20) ~= "table" or #p20 ~= 1 then p20 else p20[1]

            if not isStringSafe(v3) then
                return false, "Expected a string"
            end

            for _, v4 in p18 do
                if v3 == v4 then
                    return true, v3
                end
            end

            return false, "Value not in allowed list"
        end
    end,
    arrayOfOneOfString = function(p22, p23, p24) -- arrayOfOneOfString | line: 86
        -- upvalues: isStringSafe (copy), isWithinMaxSize (copy)
        local t2 = {}

        for _, v5 in p22 do
            t2[v5] = true
        end

        return function(_, p26, _) -- line: 89
            -- upvalues: p23 (copy), p24 (copy), t2 (copy), isStringSafe (copy), isWithinMaxSize (copy)
            if typeof(p26) ~= "table" then
                return false, "Expected an array"
            end

            if p24 and not isWithinMaxSize(p26, p24) then
                return false, "Array too large"
            end

            local t3 = {}
            local t4 = {}

            for i = 1, #p26 do
                local v6 = p26[i]

                if not isStringSafe(v6) then
                    return false, (("Entry %* is not a safe string"):format(i))
                end

                if t2[v6] and not t3[v6] then
                    t3[v6] = true
                    table.insert(t4, v6)
                end
            end

            if #t4 > p23 then
                return false, (("Too many entries (max %*)"):format(p23))
            end

            return true, t4
        end
    end,
    safeString = function(p28) -- safeString | line: 114
        -- upvalues: isStringSafe (copy), isWithinMaxSize (copy)
        return function(_, p30, _) -- line: 115
            -- upvalues: p28 (copy), isStringSafe (copy), isWithinMaxSize (copy)
            if not isStringSafe(p30) then
                return false, "Expected a safe string"
            end

            if isWithinMaxSize(p30, p28) then
                return true, p30
            end

            return false, "String too long"
        end
    end,
    filteredText = function(p32) -- filteredText | line: 123
        -- upvalues: isStringSafe (copy), isWithinMaxSize (copy), filterTextAsync (copy)
        return function(_, p34, p35) -- line: 124
            -- upvalues: p32 (copy), isStringSafe (copy), isWithinMaxSize (copy), filterTextAsync (copy)
            if not isStringSafe(p34) then
                return false, "Expected a safe string"
            end

            if not isWithinMaxSize(p34, p32) then
                return false, "Too long"
            end

            if #p34 == 0 then
                return false, "Cannot be empty"
            end

            if p35 and p35.callerUserId then
                local v7, v8 = filterTextAsync(p34, p35.callerUserId)

                if v7 then
                    return true, v8
                end

                return false, "Text was rejected by the filter"
            end

            return true, p34
        end
    end,
    taggedArray = function(p36, p37, p38, p39) -- taggedArray | line: 138
        -- upvalues: isWithinMaxSize (copy), matchesShape (copy)
        return function(_, p41, _) -- line: 144
            -- upvalues: p36 (copy), p37 (copy), p38 (copy), p39 (copy), isWithinMaxSize (copy), matchesShape (copy)
            if typeof(p41) ~= "table" then
                return false, "Expected an array"
            end

            if not isWithinMaxSize(p41, p38) then
                return false, "Array too large"
            end

            local t5 = {}
            local t6 = {}

            for i = 1, #p41 do
                local v9 = p41[i]

                if not (typeof(v9) == "table" and typeof(v9.type) == "string") then
                    return false, (("Entry %*: missing or invalid 'type'"):format(i))
                end

                local v12 = p36[v9.type]

                if not v12 then
                    return false, (("Entry %*: unknown type '%*'"):format(i, (tostring(v9.type))))
                end

                local v13, v14 = matchesShape(v9, v12)

                if not v13 then
                    return false, (("Entry %*: %*"):format(i, (tostring(v14))))
                end

                local v15 = p39(v14)

                if typeof(v15) ~= "string" then
                    return false, (("Entry %*: could not derive dedup key"):format(i))
                end

                if not t6[v15] then
                    t6[v15] = true
                    table.insert(t5, v14)
                end
            end

            if #t5 > p37 then
                return false, (("Too many entries (max %*)"):format(p37))
            end

            return true, t5
        end
    end
}
