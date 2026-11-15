-- https://lua.expert

local Assert = require(script.Parent.Parent.Util.Assert)
local Const = require(script.Parent.Const)
local GetContrastRatioAPCA = Assert.prepTypeOf("GetContrastRatioAPCA")
local abs = math.abs

local function ComputePower(p1) -- line: 26
    -- upvalues: Const (copy)
    return p1 ^ Const.SRGB_TRC
end

local function ComputeY(p2) -- line: 30
    -- upvalues: Const (copy)
    return p2.R ^ Const.SRGB_TRC * Const.RED_COEF + p2.G ^ Const.SRGB_TRC * Const.GREEN_COEF + p2.B ^ Const.SRGB_TRC * Const.BLUE_COEF
end

local function SoftClampBlack(p3) -- line: 36
    -- upvalues: Const (copy), abs (copy)
    if Const.BLK_THRS < p3 then
        return p3
    end

    return p3 + abs(p3 - Const.BLK_THRS) ^ Const.BLK_CLMP
end

local function GetContrastRatio(p4, p5) -- line: 48
    -- upvalues: Const (copy), GetContrastRatioAPCA (copy), abs (copy)
    GetContrastRatioAPCA("foreground", "Color3", p4)
    GetContrastRatioAPCA("background", "Color3", p5)

    local v2 = p4.R ^ Const.SRGB_TRC * Const.RED_COEF + p4.G ^ Const.SRGB_TRC * Const.GREEN_COEF + p4.B ^ Const.SRGB_TRC * Const.BLUE_COEF

    if not (Const.BLK_THRS < v2) then
        v2 += abs(v2 - Const.BLK_THRS) ^ Const.BLK_CLMP
    end

    local v4 = p5.R ^ Const.SRGB_TRC * Const.RED_COEF + p5.G ^ Const.SRGB_TRC * Const.GREEN_COEF + p5.B ^ Const.SRGB_TRC * Const.BLUE_COEF

    if not (Const.BLK_THRS < v4) then
        v4 += abs(v4 - Const.BLK_THRS) ^ Const.BLK_CLMP
    end

    if abs(v4 - v2) < Const.MIN_DELTA_Y then
        return 0
    end

    local v7

    if v2 < v4 then
        local v8 = (v4 ^ Const.NORM_BG_EXP - v2 ^ Const.NORM_FG_EXP) * Const.SCALE_BOW

        v7 = if v8 < Const.LOW_CLIP then 0 elseif v8 < Const.LOW_BOW_THRS then v8 - v8 * Const.LOW_BOW_FACT * Const.LOW_BOW_OFFS else v8 - Const.LOW_BOW_OFFS
    else
        local v9 = (v4 ^ Const.REV_BG_EXP - v2 ^ Const.REV_FG_EXP) * Const.SCALE_WOB

        v7 = if -Const.LOW_CLIP < v9 then 0 elseif -Const.LOW_WOB_THRS < v9 then v9 - v9 * Const.LOW_WOB_FACT * Const.LOW_WOB_OFFS else v9 + Const.LOW_WOB_OFFS
    end

    return v7 * 100
end

return GetContrastRatio
