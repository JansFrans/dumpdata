-- https://lua.expert

local Assert = require(script.Parent.Util.Assert)
local ClampColor = require(script.Parent.Util.ClampColor)
local Transparency = require(script.Parent.Blend.Transparency)
local sub, gsub, format, rep = string.sub, string.gsub, string.format, string.rep
local split = string.split
local v1 = Color3.new()

local function FromHex(p1) -- line: 30
    -- upvalues: Assert (copy), ClampColor (copy), sub (copy), gsub (copy), format (copy), rep (copy), split (copy)
    Assert.typeOf("FromHex", "hex", "string", p1)

    local v2 = gsub(p1, "[^A-Fa-f0-9]", "")

    if #v2 == 3 then
        local v3 = split(v2, "")

        v2 = ""

        for _, v4 in ipairs(v3) do
            v2 ..= rep(v4, 2)
        end
    elseif #v2 < 6 then
        v2 = format("%s%s", v2, rep(v2, 6 - #v2))
    end

    local v6 = tonumber(sub(v2, 1, 2), 16)
    local v8 = tonumber(sub(v2, 3, 4), 16)
    local v10 = tonumber(sub(v2, 5, 6), 16)

    return ClampColor(Color3.fromRGB(v6, v8, v10))
end

local function FromHexRGBA(p2, p3) -- line: 76
    -- upvalues: Assert (copy), Transparency (copy), sub (copy), gsub (copy), v1 (copy), FromHex (copy)
    Assert.typeOf("FromHexRGBA", "hex", "string", p2)

    local v11 = gsub(p2, "[^A-Fa-f0-9]", "")

    if #v11 < 8 then
        return FromHex(v11)
    end

    local v13 = 1 - tonumber(sub(v11, -2), 16) / 255

    return Transparency(FromHex((sub(v11, 1, -3))), p3 or v1, v13)
end

return {
    fromHex = FromHex,
    fromHexRGBA = FromHexRGBA,
    toHex = function(p4) -- ToHex | line: 105
        -- upvalues: Assert (copy), format (copy)
        Assert.typeOf("ToHex", "color", "Color3", p4)

        return (format("%.2x%.2x%.2x", p4.R * 255, p4.G * 255, p4.B * 255))
    end
}
