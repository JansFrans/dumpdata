-- https://lua.expert

local t1 = {
    SIZE = 39,
    ENTRY = 40,
    MAX_PER_PACKET = 21
}

local function q16(p1) -- line: 12
    return (math.clamp(math.round(p1), -32767, 32767))
end

function t1.Write(p2, p3, p4, p5, p6, p7) -- line: 14
    buffer.writef64(p2, p3, p4)

    local Position = p5.Position

    buffer.writef32(p2, p3 + 8, Position.X)
    buffer.writef32(p2, p3 + 12, Position.Y)
    buffer.writef32(p2, p3 + 16, Position.Z)

    local v5, v6 = p5:ToAxisAngle()
    local v8 = math.sin(v6 * 0.5)
    local t2 = {
        v5.X * v8,
        v5.Y * v8,
        v5.Z * v8,
        (math.cos(v6 * 0.5))
    }
    local v13 = math.abs(t2[1])
    local v14 = math.abs(t2[2])
    local n1 = 1

    if v13 < v14 then
        n1 = 2
    else
        v14 = v13
    end

    local v15 = math.abs(t2[3])

    if v14 < v15 then
        n1 = 3
    else
        v15 = v14
    end

    if v15 < math.abs(t2[4]) then
        n1 = 4
    end

    local v16 = if t2[n1] < 0 then -1 else 1

    buffer.writeu8(p2, p3 + 20, n1 - 1)

    local n2 = 0

    for i = 1, 4 do
        if i ~= n1 then
            local v19 = p3 + 21 + n2 * 2
            local v22 = math.clamp(math.round(t2[i] * v16 * 46339.53579827921), -32767, 32767)

            buffer.writei16(p2, v19, v22)
            n2 += 1
        end
    end

    local v23 = p3 + 27
    local v26 = math.clamp(math.round(p6.X * 50), -32767, 32767)

    buffer.writei16(p2, v23, v26)

    local v27 = p3 + 29
    local v30 = math.clamp(math.round(p6.Y * 50), -32767, 32767)

    buffer.writei16(p2, v27, v30)

    local v31 = p3 + 31
    local v34 = math.clamp(math.round(p6.Z * 50), -32767, 32767)

    buffer.writei16(p2, v31, v34)

    local v35 = p3 + 33
    local v38 = math.clamp(math.round(p7.X * 500), -32767, 32767)

    buffer.writei16(p2, v35, v38)

    local v39 = p3 + 35
    local v42 = math.clamp(math.round(p7.Y * 500), -32767, 32767)

    buffer.writei16(p2, v39, v42)

    local v43 = p3 + 37
    local v46 = math.clamp(math.round(p7.Z * 500), -32767, 32767)

    buffer.writei16(p2, v43, v46)
end

function t1.Encode(p8, p9, p10, p11) -- line: 31
    -- upvalues: t1 (copy)
    local v47 = buffer.create(t1.SIZE)

    t1.Write(v47, 0, p8, p9, p10, p11)

    return v47
end

function t1.Read(p12, p13) -- line: 36
    local v48 = buffer.readf64(p12, p13)
    local v50 = buffer.readf32(p12, p13 + 8)
    local v52 = buffer.readf32(p12, p13 + 12)
    local v54 = buffer.readf32(p12, p13 + 16)

    for _, v55 in { v48, v50, v52, v54 } do
        if v55 ~= v55 or math.abs(v55) > 1E+07 then
            return nil
        end
    end

    local v57 = buffer.readu8(p12, p13 + 20) + 1

    if v57 > 4 then
        return nil
    end

    local t3 = {}
    local n3 = 0
    local n4 = 0

    for i = 1, 4 do
        if i ~= v57 then
            local v59 = buffer.readi16(p12, p13 + 21 + n4 * 2) / 46339.53579827921

            t3[i] = v59
            n3 += v59 * v59
            n4 += 1
        end
    end

    t3[v57] = math.sqrt((math.max(0, 1 - n3)))

    return v48, CFrame.new(v50, v52, v54, t3[1], t3[2], t3[3], t3[4]), Vector3.new(buffer.readi16(p12, p13 + 27), buffer.readi16(p12, p13 + 29), (buffer.readi16(p12, p13 + 31))) / 50, Vector3.new(buffer.readi16(p12, p13 + 33), buffer.readi16(p12, p13 + 35), (buffer.readi16(p12, p13 + 37))) / 500
end

return t1
