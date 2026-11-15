-- https://lua.expert

local t1 = {}

t1.__index = t1

t1.new = function(p1) -- line: 6
    -- upvalues: t1 (copy)
    local self = setmetatable({}, t1)

    self.BUF_SIZE = p1 or 8388608
    self.buf = buffer.create(self.BUF_SIZE)
    self.strToLength = {}
    self.lengthToStr = buffer.create(94)
    self.bidirectionalDict = {}

    local lengthToStr, strToLength, bidirectionalDict = self.lengthToStr, self.strToLength, self.bidirectionalDict
    local n1 = 0

    for i = 32, 127 do
        if i ~= 34 and i ~= 92 then
            local v2 = string.char(i)

            strToLength[v2] = n1
            bidirectionalDict[n1] = v2
            bidirectionalDict[v2] = n1
            buffer.writeu8(lengthToStr, n1, i)
            n1 += 1
        end
    end

    local t3 = {}
    local t4 = {}
    local t5 = {}
    local t6 = {}
    local t7 = {
        34, 92
    }

    for i = 126, 180 do
        table.insert(t7, i)
    end

    for i = 0, #t7 + 31 do
        local v3 = t7[i - 31]
        local v4 = i + 32
        local v5 = v3 or i
        local v6 = v4 + (if v4 >= 34 then 1 else 0) + (if v4 >= 91 then 1 else 0)

        t3[v5] = v6
        t5[string.char(v6)] = string.char(v5)
    end

    for i = 1, 75 do
        local v7 = i + 180
        local v8 = i + 34
        local v9 = v8 + (if v8 >= 92 then 1 else 0)

        t4[v7] = v9
        t6[string.char(v9)] = string.char(v7)
    end

    local function escape(p2) -- line: 72
        -- upvalues: t3 (copy), t4 (copy)
        local v10 = #p2
        local v11 = buffer.fromstring(p2)
        local v12 = buffer.create(v10 * 2)
        local v13 = 1
        local v14 = string.find(p2, "[%c\"\\~-\255]")
        local v15 = 0

        while v14 do
            if v13 < v14 then
                buffer.copy(v12, v15, v11, v13 - 1, v14 - v13)
                v13, v15 = v14, v15 + (v14 - v13)
            end

            local v17 = buffer.readu8(v11, v14 - 1)

            if v17 >= 181 then
                local v18 = t4[v17]

                buffer.writeu8(v12, v15, 127)
                buffer.writeu8(v12, v15 + 1, v18)
            else
                local v20 = t3[v17]

                buffer.writeu8(v12, v15, 126)
                buffer.writeu8(v12, v15 + 1, v20)
            end

            v13 += 1
            v15 += 2
            v14 = string.find(p2, "[%c\"\\~-\255]", v14 + 1)
        end

        if v13 <= v10 then
            buffer.copy(v12, v15, v11, v13 - 1, v10 - v13 + 1)
            v15 += v10 - v13 + 1
        end

        return v12, v15
    end

    local function unescape(p3) -- line: 112
        -- upvalues: t5 (copy), t6 (copy)
        return string.gsub(string.gsub(p3, "\127(.)", function(p4) -- line: 113
            -- upvalues: t6 (copy)
            return t6[p4]
        end), "~(.)", function(p5) -- line: 115
            -- upvalues: t5 (copy)
            return t5[p5]
        end)
    end

    local t8 = {}

    local function tobase10(p6) -- line: 122
        -- upvalues: bidirectionalDict (copy), t8 (copy)
        local v22 = t8[p6]

        if v22 then
            return v22
        end

        local n2 = 0

        for i = 1, #p6 do
            n2 += math.pow(93, i - 1) * bidirectionalDict[string.sub(p6, -i, -i)]
        end

        t8[p6] = n2

        return n2
    end

    self.escape = escape
    self.unescape = unescape
    self.tobase10 = tobase10

    return self
end

function t1:compress(p8) -- line: 145
    assert(type(p8) == "string", "bad argument #1 to 'compress' (string expected, got " .. typeof(p8) .. ")")

    local v27, v28 = self.escape(p8)
    local v29 = table.clone(self.strToLength)
    local buf = self.buf
    local n3 = 1
    local t9 = {}
    local n4 = 0
    local n5 = 0
    local lengthToStr = self.lengthToStr
    local v30 = nil

    local function v31(p9) -- line: 158
        -- upvalues: buf (copy), n5 (ref), lengthToStr (copy), v30 (ref)
        local n6 = 0

        repeat
            local v33 = p9 % 93

            buffer.copy(buf, n5 + v30 - 1 - n6, lengthToStr, v33, 1)
            p9 = (p9 - v33) / 93
            n6 += 1
        until p9 == 0
    end

    local function listkey(p10) -- line: 168
        -- upvalues: v29 (copy), buf (copy), n3 (ref), t9 (copy), n4 (ref), n5 (ref), v30 (ref), v31 (copy)
        local v34 = v29[p10]

        v30 = if v34 == 0 then 1 else math.ceil((math.log(v34 + 1, 93)))

        local v38 = v30

        if v38 > n3 then
            local v39 = n3
            local v40 = v30
            local v41 = n4

            n3 = v40
            n4 = 0
            t9[v39] = v41
        end

        local v43 = n3

        for _ = 1, v43 - v30 do
            buffer.writeu8(buf, n5, 32)
            n5 += 1
        end

        v31(v34)
        n5 += v30
        n4 += 1
    end

    local n7 = 93
    local n8 = 0
    local n9 = 1
    local v45 = ""

    while n9 <= v28 do
        local v46 = buffer.readstring(v27, n8, n9 - n8)

        if v29[v46] then
            v45 = v46
            n9 += 1
        else
            listkey(v45)
            n8 = n9 - 1
            n7 += 1
            v29[v46] = n7
        end
    end

    listkey(v45)
    t9[n3] = n4

    return table.concat(t9, ",") .. "|" .. buffer.readstring(buf, 0, n5)
end

function t1:decompress(p12) -- line: 205
    assert(type(p12) == "string", "bad argument #1 to 'decompress' (string expected, got " .. typeof(p12) .. ")")

    local v49 = table.clone(self.bidirectionalDict)
    local tobase10 = self.tobase10
    local t10 = {}
    local v50, v51 = string.match(p12, "(.-)|(.*)")
    local t11 = {}
    local n10 = 1

    for match in string.gmatch(v50, "%d+") do
        local v52 = #t11 + 1

        t11[v52] = string.sub(v51, n10, n10 + match * v52 - 1)
        n10 += match * v52
    end

    local v54

    for v55, v56 in t11 do
        for match in string.gmatch(v56, string.rep(".", v55)) do
            local v58 = v49[tobase10(match)]

            if v54 then
                if v58 then
                    local v59 = v54 .. string.sub(v58, 1, 1)

                    v54 = v58
                    table.insert(v49, v59)
                else
                    v54 ..= string.sub(v54, 1, 1)
                    table.insert(v49, v54)
                end

                table.insert(t10, v54)
            else
                v54 = v58
                t10[1] = v58
            end
        end
    end

    return self.unescape(table.concat(t10))
end

return t1.new()
