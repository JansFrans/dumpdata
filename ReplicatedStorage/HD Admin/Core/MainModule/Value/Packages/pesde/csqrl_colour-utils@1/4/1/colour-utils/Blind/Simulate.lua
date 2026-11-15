-- https://lua.expert

local Configs = require(script.Configs)
local Enum = require(script.Parent.Enum)

local function RGBtoXYZ(p1) -- line: 20
    -- upvalues: Configs (copy)
    local RGB_XYZ = Configs.Matrix.RGB_XYZ
    local R, G, B = p1.R, p1.G, p1.B
    local v1 = if R > 0.04 then ((R + 0.055) / 1.055) ^ 2.4 else R / 12.92
    local v2 = if G > 0.04 then ((G + 0.055) / 1.055) ^ 2.4 else G / 12.92
    local v3 = if B > 0.04 then ((B + 0.055) / 1.055) ^ 2.4 else B / 12.92

    return (Vector3.new(v1 * RGB_XYZ[1] + v2 * RGB_XYZ[4] + v3 * RGB_XYZ[7], v1 * RGB_XYZ[2] + v2 * RGB_XYZ[5] + v3 * RGB_XYZ[8], v1 * RGB_XYZ[3] + v2 * RGB_XYZ[6] + v3 * RGB_XYZ[9]))
end

local function XYZtoXyY(p2) -- line: 34
    local v7 = p2.X + p2.Y + p2.Z

    if v7 == 0 then
        return {
            X = 0,
            y = 0,
            Y = p2.Y
        }
    end

    return {
        X = p2.X / v7,
        y = p2.Y / v7,
        Y = p2.Y
    }
end

local function Anomalise(p3, p4, p5) -- line: 52
    local v8 = if type(p5) == "number" then p5 else 1.75
    local v9 = v8 + 1

    return Color3.new((v8 * p4.R + p3.R) / v9, (v8 * p4.G + p3.G) / v9, (v8 * p4.B + p3.B) / v9)
end

local function SimulateBlinder(p6, p7) -- line: 72
    -- upvalues: Configs (copy), Enum (copy), RGBtoXYZ (copy), XYZtoXyY (copy), Anomalise (copy)
    assert(typeof(p6) == "Color3", "Color must be a Color3")
    assert(typeof(p7) == "number", "Blinder must be a number (see Enums.Blind)")

    local v12 = Configs.Groups[p7]
    local v13 = Configs.Anomalised[p7]

    if v12 == Enum.Group.Trichroma then
        return p6
    end

    if v12 == Enum.Group.Achroma then
        local v14 = p6.R * 0.213 + p6.G * 0.715 + p6.B * 0.072
        local v15 = Color3.new(v14, v14, v14)

        if v13 then
            return Anomalise(p6, v15)
        end

        return v15
    end

    local v16 = Configs.Blinder[v12]
    local v17 = XYZtoXyY((RGBtoXYZ(p6)))
    local v18 = (v17.y - v16.Y) / (v17.X - v16.X)
    local v19 = v17.y - v17.X * v18
    local v20 = (v16.YI - v19) / (v18 - v16.M)
    local v21 = v18 * v20 + v19
    local t1 = {
        X = v20 * v17.Y / v21,
        Y = v17.Y,
        Z = (1 - (v20 + v21)) * v17.Y / v21
    }
    local v22 = v17.Y * 0.313 / 0.329
    local v23 = v17.Y * 0.358 / 0.329 - t1.Z
    local v24 = v22 - t1.X
    local XYZ_RGB = Configs.Matrix.XYZ_RGB
    local v25 = v24 * XYZ_RGB[1] + 0 * XYZ_RGB[4] + v23 * XYZ_RGB[7]
    local v26 = v24 * XYZ_RGB[2] + 0 * XYZ_RGB[5] + v23 * XYZ_RGB[8]
    local v27 = v24 * XYZ_RGB[3] + 0 * XYZ_RGB[6] + v23 * XYZ_RGB[9]

    t1.R = t1.X * XYZ_RGB[1] + t1.Y * XYZ_RGB[4] + t1.Z * XYZ_RGB[7]
    t1.G = t1.X * XYZ_RGB[2] + t1.Y * XYZ_RGB[5] + t1.Z * XYZ_RGB[8]
    t1.B = t1.X * XYZ_RGB[3] + t1.Y * XYZ_RGB[6] + t1.Z * XYZ_RGB[9]

    local v28 = ((if t1.R < 0 then 0 else 1) - t1.R) / v25
    local v29 = ((if t1.G < 0 then 0 else 1) - t1.G) / v26
    local v30 = ((if t1.B < 0 then 0 else 1) - t1.B) / v27

    if v28 > 1 or v28 < 0 then
        v28 = 0
    end

    if v29 > 1 or v29 < 0 then
        v29 = 0
    end

    if v30 > 1 or v30 < 0 then
        v30 = 0
    end

    if not (v29 < v28) then
        v28 = v29
    end

    if not (v28 < v30) then
        v30 = v28
    end

    t1.R += v30 * v25
    t1.G += v30 * v26
    t1.B += v30 * v27
    t1.R = 255 * (if t1.R <= 0 then 0 elseif t1.R >= 1 then 1 else t1.R ^ (1 / Configs.Gamma_Correct))
    t1.G = 255 * (if t1.G <= 0 then 0 elseif t1.G >= 1 then 1 else t1.G ^ (1 / Configs.Gamma_Correct))
    t1.B = 255 * (if t1.B <= 0 then 0 elseif t1.B >= 1 then 1 else t1.B ^ (1 / Configs.Gamma_Correct))

    local v31 = Color3.fromRGB(t1.R or 0, t1.G or 0, t1.B or 0)

    if v13 then
        return Anomalise(p6, v31)
    end

    return v31
end

return SimulateBlinder
