-- https://lua.expert

local Enum = require(script.Parent.Parent.Enum)
local t1 = {
    [Enum.Blind.Protanomaly] = true,
    [Enum.Blind.Deuteranomaly] = true,
    [Enum.Blind.Tritanomaly] = true,
    [Enum.Blind.Achromatomaly] = true
}
local t2 = {
    [Enum.Blind.Trichromacy] = Enum.Group.Trichroma,
    [Enum.Blind.Protanopia] = Enum.Group.Protan,
    [Enum.Blind.Protanomaly] = Enum.Group.Protan,
    [Enum.Blind.Deuteranopia] = Enum.Group.Deutan,
    [Enum.Blind.Deuteranomaly] = Enum.Group.Deutan,
    [Enum.Blind.Tritanopia] = Enum.Group.Tritan,
    [Enum.Blind.Tritanomaly] = Enum.Group.Tritan,
    [Enum.Blind.Achromatopsia] = Enum.Group.Achroma,
    [Enum.Blind.Achromatomaly] = Enum.Group.Achroma
}
local t3 = {
    3.241, -0.969, 0.056, -1.537, 1.876, -0.204, -0.499, 0.042,
    1.057
}
local t4 = {
    0.412, 0.213, 0.019, 0.358, 0.715, 0.119, 0.18, 0.072,
    0.95
}
local t5 = {
    [Enum.Group.Protan] = {
        X = 0.747,
        Y = 0.254,
        M = 1.273,
        YI = -0.074
    },
    [Enum.Group.Deutan] = {
        X = 1.4,
        Y = -0.4,
        M = 0.968,
        YI = 0.003
    },
    [Enum.Group.Tritan] = {
        X = 0.175,
        Y = 0,
        M = 0.063,
        YI = 0.292
    }
}

return {
    Gamma_Correct = 2.2,
    Anomalised = t1,
    Groups = t2,
    Matrix = {
        XYZ_RGB = t3,
        RGB_XYZ = t4
    },
    Blinder = t5
}
