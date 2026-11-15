-- https://lua.expert

local GetContrastRatio = require(script.Parent.APCA.GetContrastRatio)
local v1 = false

local function getContrastRatioCompat(p1, p2) -- line: 4
    -- upvalues: GetContrastRatio (copy), v1 (ref)
    local v3 = math.abs((GetContrastRatio(p1, p2)))

    if not v1 then
        v1 = true
        warn("ColorUtils.GetContrastRatio is providing a compatibility layer for APCA.GetContrastRatio. To continue using the old behavior, use WCAG.GetContrastRatio instead.")
    end

    return v3 / 100 * 21
end

return getContrastRatioCompat
