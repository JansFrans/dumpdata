-- https://lua.expert

local AssetService = game:GetService("AssetService")
local EncodingService = game:GetService("EncodingService")
local t1 = {}
local t2 = {}
local t3 = {}

local function build(p1) -- line: 8
    -- upvalues: AssetService (copy), EncodingService (copy)
    local v1 = script:FindFirstChild(p1)

    if not v1 then
        return nil
    end

    local W = v1:GetAttribute("W")
    local H = v1:GetAttribute("H")
    local v2 = EncodingService:DecompressBuffer(EncodingService:Base64Decode(buffer.fromstring(v1.Value)), Enum.CompressionAlgorithm.Zstd)
    local v3 = W * H
    local v4 = buffer.len(v2) - v3
    local t4 = {}

    for i = 0, v4 // 4 - 1 do
        t4[i] = buffer.readu32(v2, i * 4)
    end

    local v5 = buffer.create(v3 * 4)

    for i = 0, v3 - 1 do
        local v7 = t4[buffer.readu8(v2, v4 + i)]

        buffer.writeu32(v5, i * 4, v7)
    end

    local v8 = AssetService:CreateEditableImage({
        Size = Vector2.new(W, H)
    })

    v8:WritePixelsBuffer(Vector2.zero, Vector2.new(W, H), v5)

    return Content.fromObject(v8)
end

local function dots() -- line: 21
    -- upvalues: AssetService (copy)
    local v9 = buffer.create(1488000)

    for i = -14, 14 do
        for j = -14, 14 do
            local v10 = j * 21.43 + 300
            local v11 = i * 21.43 + 300
            local v13 = (1 - math.sqrt((v10 - 300) ^ 2 + (v11 - 300) ^ 2) / 330) * 9

            if v13 > 0.35 then
                for k = math.max(0, (math.floor(v11 - v13 - 1))), math.min(619, (math.ceil(v11 + v13 + 1))) do
                    for n = math.max(0, (math.floor(v10 - v13 - 1))), math.min(599, (math.ceil(v10 + v13 + 1))) do
                        local v26 = math.clamp(v13 - math.sqrt((n + 0.5 - v10) ^ 2 + (k + 0.5 - v11) ^ 2) + 0.5, 0, 1)

                        if v26 > 0 then
                            local v28 = math.floor(v26 * 255 + 0.5) * 16777216 + 4801086

                            buffer.writeu32(v9, (k * 600 + n) * 4, v28)
                        end
                    end
                end
            end
        end
    end

    local v29 = AssetService:CreateEditableImage({
        Size = Vector2.new(600, 620)
    })

    v29:WritePixelsBuffer(Vector2.zero, Vector2.new(600, 620), v9)

    return Content.fromObject(v29)
end

local function raster(p2, p3, p4, p5) -- line: 44
    -- upvalues: AssetService (copy)
    local v30 = buffer.create(p2 * p3 * 4)
    local v31 = p4 * p4

    for i = 0, p3 - 1 do
        for j = 0, p2 - 1 do
            local v32 = p4 - 1
            local n1 = 0
            local n2 = 0
            local n3 = 0
            local n4 = 0

            for k = 0, v32 do
                for n = 0, p4 - 1 do
                    local v33, v34, v35 = p5(j + (n + 0.5) / p4, i + (k + 0.5) / p4)

                    if v33 then
                        n1 += v33
                        n2 += v34
                        n3 += v35
                        n4 += 1
                    end
                end
            end

            if n4 > 0 then
                buffer.writeu32(v30, (i * p2 + j) * 4, math.floor(n1 / n4 + 0.5) + math.floor(n2 / n4 + 0.5) * 256 + math.floor(n3 / n4 + 0.5) * 65536 + math.floor(n4 / v31 * 255 + 0.5) * 16777216)
            end
        end
    end

    local v45 = AssetService:CreateEditableImage({
        Size = Vector2.new(p2, p3)
    })

    v45:WritePixelsBuffer(Vector2.zero, Vector2.new(p2, p3), v30)

    return Content.fromObject(v45)
end

local function rrect(p6, p7, p8, p9, p10, p11, p12) -- line: 63
    if p6 < p8 or p10 < p6 or p7 < p9 or p11 < p7 then
        return false
    end

    local v48 = math.clamp(p6, p8 + p12, p10 - p12)
    local v51 = math.clamp(p7, p9 + p12, p11 - p12)

    return (p6 - v48) ^ 2 + (p7 - v51) ^ 2 <= p12 * p12
end

local function inPoly(p13, p14, p15) -- line: 68
    local v52 = #p13
    local v54 = false

    for i = 1, #p13 do
        local v55 = p13[i][1]
        local v56 = p13[i][2]
        local v57 = p13[v52][1]
        local v58 = p13[v52][2]

        v52 = i

        if p15 < v56 ~= (p15 < v58) and p14 < (v57 - v55) * (p15 - v56) / (v58 - v56) + v55 then
            v54 = not v54
        end
    end

    return v54
end

local t5 = {
    GiftTag = function() -- line: 78
        -- upvalues: raster (copy)
        return raster(180, 98, 3, function(p16, p17) -- line: 80
            local v59 = p17 / 98

            if p16 < 41.4 * v59 or 138.6 + 41.4 * v59 < p16 or p17 > 88 and p16 < 41.4 * v59 + 12 and (p16 - 47.17551020408163) ^ 2 + (p17 - 88) ^ 2 > 100 and p16 < 47.17551020408163 or p17 < 10 and p16 > 128.6 and (p16 - 128.6) ^ 2 + (p17 - 10) ^ 2 > 100 then
                return nil
            end

            local v60 = false

            for _, v61 in { 78, 104 } do
                local v62 = (p16 - v61) ^ 2 + (p17 - 29) ^ 2

                if v62 <= 182.25 and v62 >= 36 and p17 < 43 then
                    v60 = true
                end
            end

            if not (p16 < 86) and not (p16 > 96) and not (p17 < 34) and not (p17 > 45) then
                local v63 = math.clamp(p16, 88, 94)
                local v64 = math.clamp(p17, 36, 43)

                if (p16 - v63) ^ 2 + (p17 - v64) ^ 2 <= 4 then
                    v60 = true
                end
            end

            local v65 = false

            if not (p16 < 52) and not (p16 > 130) and not (p17 < 42) and not (p17 > 57) then
                local v66 = math.clamp(p16, 55, 127)
                local v67 = math.clamp(p17, 45, 54)

                v65 = (p16 - v66) ^ 2 + (p17 - v67) ^ 2 <= 9
            end

            local v68, v69

            if v65 then
                v69 = false
            elseif p16 < 59 or p16 > 123 or p17 < 55 or p17 > 87 then
                v68 = v60
                v69 = true
            else
                local v70 = math.clamp(p16, 64, 118)
                local v71 = math.clamp(p17, 60, 82)

                if (p16 - v70) ^ 2 + (p17 - v71) ^ 2 <= 25 then
                    v69 = false
                else
                    v68 = v60
                    v69 = true
                end
            end

            if not v69 then
                v68 = true
            end

            local v72 = false

            if not (p16 < 85) and not (p16 > 97) and not (p17 < 46) and not (p17 > 80) then
                local v73 = math.clamp(p16, 91, 91)
                local v74 = math.clamp(p17, 52, 74)

                v72 = (p16 - v73) ^ 2 + (p17 - v74) ^ 2 <= 36
            end

            if (not v72 or not (p17 > 44)) and v68 then
                return 0, 0, 0
            end

            return 255, 255, 255
        end)
    end,
    CashStack = function() -- line: 94
        -- upvalues: raster (copy), inPoly (copy)
        local t6 = {
            30, 150, 74
        }
        local t7 = {
            22, 120, 60
        }
        local t8 = {
            120, 230, 150
        }
        local t9 = {
            46, 190, 96
        }
        local t10 = {
            255, 214, 64
        }
        local t11 = {
            255, 140, 0
        }
        local t12 = {
            110, 225, 140
        }
        local t13 = {}

        local function add(p18, p19) -- line: 100
            -- upvalues: t13 (copy)
            table.insert(t13, {
                pts = p18,
                c = p19
            })
        end

        local function line(p20, p21, p22, p23) -- line: 101
            -- upvalues: t13 (copy)
            local v75 = p21[1] - p20[1]
            local v76 = p21[2] - p20[2]
            local v78 = math.sqrt(v75 * v75 + v76 * v76)
            local v79 = -v76 / v78 * p22 / 2
            local v80 = v75 / v78 * p22 / 2

            table.insert(t13, {
                pts = {
                    {
                        p20[1] + v79,
                        p20[2] + v80
                    },
                    {
                        p21[1] + v79,
                        p21[2] + v80
                    },
                    {
                        p21[1] - v79,
                        p21[2] - v80
                    },
                    {
                        p20[1] - v79,
                        p20[2] - v80
                    }
                },
                c = p23
            })
        end

        for i = 3, 0, -1 do
            local v81 = i * 12 + 10

            table.insert(t13, {
                pts = {
                    {
                        17,
                        v81 + 30
                    },
                    {
                        75,
                        v81 + 60
                    },
                    {
                        75,
                        v81 + 60 + 12
                    },
                    {
                        17,
                        v81 + 30 + 12
                    }
                },
                c = t6
            })
            table.insert(t13, {
                pts = {
                    {
                        75,
                        v81 + 60
                    },
                    {
                        133,
                        v81 + 30
                    },
                    {
                        133,
                        v81 + 30 + 12
                    },
                    {
                        75,
                        v81 + 60 + 12
                    }
                },
                c = t7
            })
            line({
                17,
                v81 + 30 + 12 - 1
            }, {
                75,
                v81 + 60 + 12 - 1
            }, 2, t8)
            line({
                75,
                v81 + 60 + 12 - 1
            }, {
                133,
                v81 + 30 + 12 - 1
            }, 2, t8)
        end

        local t18 = {
            75, 10
        }
        local t19 = {
            133, 40
        }
        local t20 = {
            75, 70
        }
        local t21 = {
            17, 40
        }

        table.insert(t13, {
            pts = { t18, t19, t20, t21 },
            c = t9
        })

        local function lerp(p24, p25, p26) -- line: 113
            return {
                p24[1] + (p25[1] - p24[1]) * p26,
                p24[2] + (p25[2] - p24[2]) * p26
            }
        end

        for _, v82 in { 0.2, 0.8 } do
            line({
                t21[1] + (t18[1] - t21[1]) * v82,
                t21[2] + (t18[2] - t21[2]) * v82
            }, {
                t20[1] + (t19[1] - t20[1]) * v82,
                t20[2] + (t19[2] - t20[2]) * v82
            }, 2, t12)
        end

        local t23 = {
            t21[1] + (t18[1] - t21[1]) * 0.38,
            t21[2] + (t18[2] - t21[2]) * 0.38
        }
        local t24 = {
            t21[1] + (t18[1] - t21[1]) * 0.62,
            t21[2] + (t18[2] - t21[2]) * 0.62
        }
        local t25 = {
            t20[1] + (t19[1] - t20[1]) * 0.62,
            t20[2] + (t19[2] - t20[2]) * 0.62
        }
        local t26 = {
            t20[1] + (t19[1] - t20[1]) * 0.38,
            t20[2] + (t19[2] - t20[2]) * 0.38
        }

        table.insert(t13, {
            pts = { t23, t24, t25, t26 },
            c = t10
        })
        table.insert(t13, {
            pts = {
                t26,
                t25,
                {
                    t25[1],
                    t25[2] + 48
                },
                {
                    t26[1],
                    t26[2] + 48
                }
            },
            c = t11
        })

        return raster(150, 130, 2, function(p27, p28) -- line: 119
            -- upvalues: t13 (copy), inPoly (copy)
            local c

            for _, v83 in t13 do
                if inPoly(v83.pts, p27, p28) then
                    c = v83.c
                end
            end

            if c then
                return c[1], c[2], c[3]
            end

            return nil
        end)
    end,
    BottleGlyph = function() -- line: 126
        -- upvalues: raster (copy), inPoly (copy)
        return raster(72, 72, 3, function(p29, p30) -- line: 127
            -- upvalues: inPoly (copy)
            local v84 = false

            if not (p29 < 25) and not (p29 > 47) and not (p30 < 30) and not (p30 > 67) then
                local v85 = math.clamp(p29, 31, 41)
                local v86 = math.clamp(p30, 36, 61)

                v84 = (p29 - v85) ^ 2 + (p30 - v86) ^ 2 <= 36
            end

            if not (v84 or inPoly({
                { 25, 34 },
                { 47, 34 },
                { 40, 20 },
                { 32, 20 }
            }, p29, p30)) then
                local v87

                if p29 < 31 or p29 > 41 or p30 < 7 or p30 > 23 then
                    v87 = false
                else
                    local v88 = math.clamp(p29, 33, 39)
                    local v89 = math.clamp(p30, 9, 21)

                    v87 = (p29 - v88) ^ 2 + (p30 - v89) ^ 2 <= 4
                end

                if not v87 then
                    return nil
                end
            end

            if not (p29 < 29) and not (p29 > 43) and not (p30 < 40) and not (p30 > 56) then
                local v90 = math.clamp(p29, 31, 41)
                local v91 = math.clamp(p30, 42, 54)

                if (p29 - v90) ^ 2 + (p30 - v91) ^ 2 <= 4 then
                    return nil
                end
            end

            return 255, 255, 255
        end)
    end,
    ThumbUp = function() -- line: 136
        -- upvalues: raster (copy), inPoly (copy)
        local t29 = {
            { 40, 58 },
            { 50, 30 },
            { 56, 14 },
            { 64, 10 },
            { 70, 14 },
            { 70, 30 },
            { 66, 58 }
        }

        return raster(120, 120, 3, function(p31, p32) -- line: 139
            -- upvalues: t29 (copy), inPoly (copy)
            local v92 = false

            if not (p31 < 12) and not (p31 > 32) and not (p32 < 56) and not (p32 > 108) then
                local v93 = math.clamp(p31, 16, 28)
                local v94 = math.clamp(p32, 60, 104)

                v92 = (p31 - v93) ^ 2 + (p32 - v94) ^ 2 <= 16
            end

            if not v92 then
                if p31 >= 33 and p31 <= 37 then
                    return nil
                end

                if not inPoly(t29, p31, p32) then
                    local v95

                    if p31 < 38 or p31 > 78 or p32 < 54 or p32 > 108 then
                        v95 = false
                    else
                        local v96 = math.clamp(p31, 47, 69)
                        local v97 = math.clamp(p32, 63, 99)

                        v95 = (p31 - v96) ^ 2 + (p32 - v97) ^ 2 <= 81
                    end

                    if not v95 then
                        for v98, v99 in {
                                { 56, 108 },
                                { 56, 104 },
                                { 56, 100 },
                                { 56, 94 }
                            } do
                            local v100 = 54 + (v98 - 1) * 14
                            local v101 = v99[1]
                            local v102 = v99[2]
                            local v103 = v100 + 12

                            if not (p31 < v101) and not (v102 < p31) and not (p32 < v100) and not (v103 < p32) then
                                local v106 = math.clamp(p31, v101 + 6, v102 - 6)
                                local v109 = math.clamp(p32, v100 + 6, v103 - 6)

                                if (p31 - v106) ^ 2 + (p32 - v109) ^ 2 <= 36 then
                                    return 255, 255, 255
                                end
                            end
                        end

                        return nil
                    end
                end
            end

            return 255, 255, 255
        end)
    end,
    Star = function() -- line: 151
        -- upvalues: raster (copy), inPoly (copy)
        local t30 = {}

        for i = 0, 9 do
            local v110 = -1.5707963267948966 + i * 3.141592653589793 / 5
            local v111 = if i % 2 == 0 then 56 else 23

            table.insert(t30, {
                60 + v111 * math.cos(v110),
                64 + v111 * math.sin(v110)
            })
        end

        return raster(120, 120, 3, function(p33, p34) -- line: 157
            -- upvalues: t30 (copy), inPoly (copy)
            if inPoly(t30, p33, p34) then
                return 255, 255, 255
            end

            return nil
        end)
    end
}

function t1.Get(p35) -- line: 159
    -- upvalues: t2 (copy), t3 (copy), build (copy), dots (copy), t5 (copy)
    if t2[p35] then
        return t2[p35]
    end

    if t3[p35] then
        repeat
            task.wait()
        until not t3[p35]
    else
        t3[p35] = true

        local function v112() -- line: 163
            -- upvalues: p35 (copy), build (copy), dots (copy), t5 (copy)
            if p35 == "LegendsDots" then
                return dots()
            end

            if t5[p35] then
                return t5[p35]()
            end

            return build(p35)
        end

        local ok, result = pcall(v112)

        t3[p35] = nil

        if ok then
            t2[p35] = result
        else
            warn("UIArt " .. p35 .. ": " .. tostring(result))
        end
    end

    return t2[p35]
end

function t1.Apply(p36, p37) -- line: 169
    -- upvalues: t1 (copy)
    task.spawn(function() -- line: 170
        -- upvalues: p36 (copy), p37 (copy), t1 (copy)
        local v113 = t1.Get(p37)

        if v113 and p36.Parent then
            p36.ImageContent = v113
        end
    end)
end

return t1
