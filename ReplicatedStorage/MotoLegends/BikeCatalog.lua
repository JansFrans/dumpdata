-- https://lua.expert

local t1 = {
    Order = {
        "Ducati",
        "Aprilia",
        "KTM",
        "Trackhouse",
        "Yamaha",
        "VR46",
        "Gresini",
        "Pramac",
        "Honda",
        "LCR",
        "Tech3"
    },
    Price = 1E+05,
    Teams = {
        Ducati = {
            Name = "Ducati Lenovo Team",
            Title = "DUCATI\nLENOVO TEAM",
            Logo = "DucatiLogo",
            Color = Color3.fromRGB(231, 1, 31),
            Bar = {
                Logo = "LogoDucati",
                X = 115,
                Y = 18,
                W = 151,
                H = 92
            }
        },
        Aprilia = {
            Name = "Aprilia Racing Team",
            Title = "APRILIA\nRACING TEAM",
            Logo = "ApriliaLogo",
            Color = Color3.fromRGB(122, 51, 185),
            Bar = {
                Logo = "LogoAprilia",
                X = 127,
                Y = 41,
                W = 126,
                H = 41
            }
        },
        KTM = {
            Name = "KTM Racing Team",
            Title = "KTM\nRACING TEAM",
            Logo = "KTMLogo",
            Color = Color3.fromRGB(255, 119, 20),
            Bar = {
                Logo = "LogoKTM",
                X = 152,
                Y = 17,
                W = 77,
                H = 95
            }
        },
        Trackhouse = {
            Name = "Trackhouse Racing Team",
            Title = "TRACKHOUSE\nRACING TEAM",
            Logo = "TrackhouseLogo",
            Color = Color3.fromRGB(185, 216, 234),
            Bar = {
                Logo = "LogoTrackhouse",
                X = 127,
                Y = 23,
                W = 128,
                H = 76
            }
        },
        Yamaha = {
            Name = "Yamaha Factory Racing",
            Title = "YAMAHA\nFACTORY RACING",
            Logo = "YamahaLogo",
            Color = Color3.fromRGB(10, 28, 139),
            Bar = {
                Logo = "LogoYamaha",
                X = 144,
                Y = 16,
                W = 92,
                H = 96
            }
        },
        VR46 = {
            Name = "Pertamina Enduro VR46 Racing Team",
            Title = "VR46\nRACING TEAM",
            Logo = "VR46Logo",
            Color = Color3.fromRGB(227, 255, 59),
            Bar = {
                Logo = "LogoVR46",
                X = 90,
                Y = 20,
                W = 201,
                H = 88
            }
        },
        Gresini = {
            Name = "Gresini Racing MotoGP",
            Title = "GRESINI\nRACING",
            Logo = "GresiniLogo",
            Color = Color3.fromRGB(147, 174, 230),
            Bar = {
                Logo = "LogoGresini",
                X = 131,
                Y = 14,
                W = 118,
                H = 98
            }
        },
        Pramac = {
            Name = "Prima Pramac Yamaha MotoGP",
            Title = "PRAMAC\nYAMAHA",
            Logo = "PramacLogo",
            Color = Color3.fromRGB(12, 28, 140),
            Bar = {
                Logo = "LogoPramac",
                X = 143,
                Y = 13,
                W = 97,
                H = 100
            }
        },
        Honda = {
            Name = "Honda HRC Castrol",
            Title = "HONDA HRC\nCASTROL",
            Logo = "HondaLogo",
            Color = Color3.fromRGB(236, 39, 49),
            Bar = {
                Logo = "LogoHonda",
                X = 116,
                Y = 13,
                W = 149,
                H = 100
            }
        },
        LCR = {
            Name = "Castrol Honda LCR",
            Title = "CASTROL HONDA\nLCR",
            Logo = "LCRLogo",
            Color = Color3.fromRGB(0, 133, 62),
            Bar = {
                Logo = "LogoLCR",
                X = 93,
                Y = 28,
                W = 192,
                H = 70
            }
        },
        Tech3 = {
            Name = "Red Bull KTM Tech3",
            Title = "RED BULL KTM\nTECH3",
            Logo = "Tech3Logo",
            Color = Color3.fromRGB(25, 33, 63),
            Bar = {
                Logo = "LogoTech3",
                X = 152,
                Y = 13,
                W = 78,
                H = 100
            }
        }
    }
}

function t1.ColorFor(p1) -- line: 22
    -- upvalues: t1 (copy)
    if typeof(p1) ~= "string" then
        return nil
    end

    for v1, v2 in t1.Teams do
        if v1:upper() == p1:upper() then
            return v2.Color
        end
    end

    return nil
end

function t1.ValidAssists(p2) -- line: 27
    if typeof(p2) ~= "table" then
        return false
    end

    for _, v3 in { "tcs", "aw", "ebs" } do
        local v4 = p2[v3]

        if typeof(v4) ~= "number" or v4 ~= v4 or v4 % 1 ~= 0 or v4 < 1 or v4 > 5 then
            return false
        end
    end

    return true
end

return t1
