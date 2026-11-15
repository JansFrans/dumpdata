-- https://lua.expert

local t1 = {
    Blind = {
        Trichromacy = 0,
        Protanopia = 1,
        Protanomaly = 2,
        Deuteranopia = 3,
        Deuteranomaly = 4,
        Tritanopia = 5,
        Tritanomaly = 6,
        Achromatopsia = 7,
        Achromatomaly = 8
    },
    Group = {
        Trichroma = 0,
        Protan = 1,
        Deutan = 2,
        Tritan = 3,
        Achroma = 4
    }
}

t1.Blind.None = t1.Blind.Trichromacy
t1.Blind.LowRed = t1.Blind.Protanomaly
t1.Blind.LowGreen = t1.Blind.Deuteranomaly
t1.Blind.LowBlue = t1.Blind.Tritanomaly
t1.Blind.LowColor = t1.Blind.Achromatomaly
t1.Blind.NoRed = t1.Blind.Protanopia
t1.Blind.NoGreen = t1.Blind.Deuteranopia
t1.Blind.NoBlue = t1.Blind.Tritanopia
t1.Blind.NoColor = t1.Blind.Achromatopsia

return t1
