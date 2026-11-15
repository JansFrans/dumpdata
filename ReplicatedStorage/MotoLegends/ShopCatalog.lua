-- https://lua.expert

local t1 = {
    Bottles = {
        Pink = {
            Name = "PINK BOTTLE",
            Short = "PINK",
            Price = 49,
            Product = 3723378722,
            Top = Color3.fromRGB(78, 40, 74),
            Bottom = Color3.fromRGB(226, 110, 190),
            Glass = Color3.fromRGB(236, 112, 186),
            Foil = Color3.fromRGB(250, 206, 232),
            Foam = ColorSequence.new(Color3.fromRGB(255, 214, 236), Color3.fromRGB(255, 170, 214))
        },
        Golden = {
            Name = "GOLDEN BOTTLE",
            Short = "GOLDEN",
            Price = 99,
            Product = 3723378859,
            Top = Color3.fromRGB(78, 70, 0),
            Bottom = Color3.fromRGB(214, 190, 0),
            Glass = Color3.fromRGB(222, 176, 38),
            Foil = Color3.fromRGB(255, 226, 120),
            Material = Enum.Material.Foil,
            Foam = ColorSequence.new(Color3.fromRGB(255, 246, 196), Color3.fromRGB(255, 222, 120))
        },
        Rainbow = {
            Name = "RAINBOW BOTTLE",
            Short = "RAINBOW",
            Price = 199,
            Product = 3723378908,
            Rainbow = true,
            Gradient = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(72, 10, 0)),
                ColorSequenceKeypoint.new(0.25, Color3.fromRGB(110, 90, 0)),
                ColorSequenceKeypoint.new(0.55, Color3.fromRGB(20, 135, 0)),
                ColorSequenceKeypoint.new(0.78, Color3.fromRGB(0, 180, 220)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 40, 255))
            }),
            Glass = Color3.fromRGB(255, 60, 60),
            Foil = Color3.fromRGB(255, 255, 255),
            Foam = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 90, 90)),
                ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 190, 70)),
                ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 250, 110)),
                ColorSequenceKeypoint.new(0.6, Color3.fromRGB(110, 255, 140)),
                ColorSequenceKeypoint.new(0.8, Color3.fromRGB(100, 190, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 120, 255))
            })
        }
    },
    BottleOrder = { "Pink", "Golden", "Rainbow" }
}

t1.Bottles.Community = {
    Name = "COMMUNITY BOTTLE",
    Short = "COMMUNITY",
    Exclusive = true,
    PreviewReflectance = 0,
    Top = Color3.fromRGB(10, 18, 48),
    Bottom = Color3.fromRGB(22, 48, 120),
    Glass = Color3.fromRGB(14, 26, 74),
    Foil = Color3.fromRGB(214, 174, 72),
    PreviewGlass = Color3.fromRGB(10, 34, 120),
    PreviewMaterial = Enum.Material.SmoothPlastic,
    Foam = ColorSequence.new(Color3.fromRGB(150, 200, 255), Color3.fromRGB(40, 120, 240))
}
t1.ExclusiveOrder = { "Community" }
t1.Vip = {
    Key = "VIP",
    Name = "VIP SUBSCRIPTION",
    Product = 3730299367,
    Price = 249,
    WasPrice = 999,
    Days = 30,
    MaxDays = 90,
    Instant = 50000,
    Daily = 25000,
    Bottle = "Blackhole",
    Nametag = "vip"
}
t1.Bottles.Blackhole = {
    Name = "BLACK HOLE BOTTLE",
    Short = "BLACK HOLE",
    VipOnly = true,
    Blackhole = true,
    PreviewReflectance = 0.12,
    Top = Color3.fromRGB(30, 12, 40),
    Bottom = Color3.fromRGB(120, 60, 10),
    Glass = Color3.fromRGB(8, 8, 10),
    Foil = Color3.fromRGB(255, 196, 40),
    Material = Enum.Material.SmoothPlastic,
    PreviewGlass = Color3.fromRGB(8, 8, 10),
    Foam = ColorSequence.new(Color3.fromRGB(255, 232, 130), Color3.fromRGB(255, 150, 20))
}
t1.VipOrder = { "Blackhole" }
t1.RaceDirector = {
    Tier1 = {
        Key = "RD1",
        Tier = 1,
        Name = "RACE DIRECTOR TIER 1",
        Short = "TIER 1",
        Product = 3731135650,
        Price = 149,
        Days = 30,
        MaxDays = 90,
        Role = "RaceDirector1",
        Nametag = "racedirector1"
    },
    Tier2 = {
        Key = "RD2",
        Tier = 2,
        Name = "RACE DIRECTOR TIER 2",
        Short = "TIER 2",
        Product = 3731136064,
        Price = 849,
        WasPrice = 1499,
        Permanent = true,
        Role = "RaceDirector",
        Nametag = "racedirector"
    }
}
t1.RaceDirectorOrder = { "Tier1", "Tier2" }
t1.Community = {
    GroupId = 634951404,
    Money = 1E+05,
    Bottle = "Community"
}
t1.BottleScale = 1.3
t1.DefaultBottle = "Default"

function t1.ValidBottle(p1) -- line: 62
    -- upvalues: t1 (copy)
    if p1 == t1.DefaultBottle then
        return true
    end

    if typeof(p1) == "string" then
        return t1.Bottles[p1] ~= nil
    end

    return false
end

t1.Cash = {
    {
        Key = "Cash1",
        Amount = 50000,
        Price = 49,
        Product = 3723378469
    },
    {
        Key = "Cash2",
        Amount = 2E+05,
        Price = 199,
        Product = 3723378512
    },
    {
        Key = "Cash3",
        Amount = 450000,
        Price = 499,
        Product = 3723378550
    }
}
t1.CashTop = Color3.fromRGB(12, 52, 28)
t1.CashBottom = Color3.fromRGB(8, 122, 72)

function t1.Money(p2) -- line: 72
    local v2 = tostring((math.floor(p2))):reverse():gsub("(%d%d%d)", "%1."):reverse()

    if v2:sub(1, 1) == "." then
        v2 = v2:sub(2)
    end

    return "$" .. v2
end

local t2 = {}

for v3, v4 in t1.Bottles do
    if v4.Product then
        t2[v4.Product] = {
            kind = "Bottle",
            id = v3,
            name = v4.Name,
            price = v4.Price,
            product = v4.Product
        }
    end
end

t1.Support = {
    {
        Key = "Support50",
        Amount = 50,
        Product = 3730306911
    },
    {
        Key = "Support100",
        Amount = 100,
        Product = 3730305562
    },
    {
        Key = "Support500",
        Amount = 500,
        Product = 3730305606
    },
    {
        Key = "Support1000",
        Amount = 1000,
        Product = 3730305636
    },
    {
        Key = "Support5000",
        Amount = 5000,
        Product = 3730305675
    },
    {
        Key = "Support10000",
        Amount = 10000,
        Product = 3730305731
    }
}
t1.SupportTiers = {
    {
        id = "fan",
        name = "FAN",
        robux = 500,
        color = Color3.fromRGB(200, 205, 215)
    },
    {
        id = "supporter",
        name = "SUPPORTER",
        robux = 1000,
        color = Color3.fromRGB(255, 200, 30)
    },
    {
        id = "patron",
        name = "PATRON",
        robux = 5000,
        color = Color3.fromRGB(230, 20, 40)
    },
    {
        id = "benefactor",
        name = "BENEFACTOR",
        robux = 10000,
        color = Color3.fromRGB(170, 80, 255)
    }
}

for _, v5 in t1.Support do
    t2[v5.Product] = {
        kind = "Support",
        id = v5.Key,
        name = tostring(v5.Amount) .. " ROBUX SUPPORT",
        amount = v5.Amount,
        price = v5.Amount,
        product = v5.Product
    }
end

t2[t1.Vip.Product] = {
    kind = "Vip",
    id = t1.Vip.Key,
    name = t1.Vip.Name,
    price = t1.Vip.Price,
    product = t1.Vip.Product
}

for _, v6 in t1.RaceDirectorOrder do
    local v7 = t1.RaceDirector[v6]

    t2[v7.Product] = {
        kind = "RaceDirector",
        id = v7.Key,
        tier = v7.Tier,
        name = v7.Name,
        price = v7.Price,
        product = v7.Product
    }
end

for _, v8 in t1.Cash do
    t2[v8.Product] = {
        kind = "Cash",
        id = v8.Key,
        name = t1.Money(v8.Amount) .. " CASH",
        amount = v8.Amount,
        price = v8.Price,
        product = v8.Product
    }
end

function t1.Product(p3) -- line: 104
    -- upvalues: t2 (copy)
    return t2[p3]
end

function t1.ByKey(p4) -- line: 105
    -- upvalues: t2 (copy)
    for _, v9 in t2 do
        if v9.id == p4 then
            return v9
        end
    end

    return nil
end

return t1
