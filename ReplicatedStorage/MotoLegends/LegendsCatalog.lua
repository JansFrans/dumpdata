-- https://lua.expert

local t1 = {
    SlotCount = 3,
    Prices = {
        RollRobux = 49,
        RollMoney = 50000,
        SlotRobux = 99
    },
    Products = {
        Roll = 3719539774
    },
    Passes = {
        Slot2 = 2039757550,
        Slot3 = 2039829576
    }
}

function t1.PassSlot(p1) -- line: 23
    -- upvalues: t1 (copy)
    for v1, v2 in t1.Passes do
        if v2 ~= 0 and v2 == p1 then
            return (tonumber(v1:match("%d+")))
        end
    end

    return nil
end

t1.Order = { "MarcMarquez", "CaseyStoner", "KuriKuriBoy", "TheDoctor", "TheRomanEmperor", "DesmoDovi" }
t1.Legends = {
    KuriKuriBoy = {
        Rider = "Casey Stoner",
        Title = "THE KURI-KURI BOY",
        Description = "Sliding gives you more speed than usual",
        Weight = 1,
        SlotArt = "LegendSlot",
        Number = "Number27",
        Rig = "KuriKuriBoy",
        Ability = "SlideMaster",
        Color = Color3.fromRGB(220, 0, 0)
    },
    CaseyStoner = {
        Rider = "Casey Stoner",
        Title = "THE LITTLE SAMURAI",
        Description = "Improves cornering ability, making you turn faster",
        Weight = 1,
        SlotArt = "LegendSlot",
        Number = "Number26",
        Rig = "CaseyStoner",
        Ability = "SharpLean",
        Color = Color3.fromRGB(255, 111, 18)
    },
    TheDoctor = {
        Rider = "Valentino Rossi",
        Title = "THE DOCTOR",
        Description = "Stoppie gives you stronger braking than usual",
        Weight = 1,
        SlotArt = "LegendSlot",
        Number = "Number46",
        Rig = "TheDoctor",
        Ability = "StoppieBrake",
        Color = Color3.fromRGB(0, 121, 220)
    },
    TheRomanEmperor = {
        Rider = "Max Biaggi",
        Title = "THE ROMAN EMPEROR",
        Description = "Wheelie gives you more acceleration than usual",
        Weight = 1,
        SlotArt = "LegendSlot",
        Number = "Number3",
        Rig = "TheRomanEmperor",
        Ability = "WheelieBoost",
        Color = Color3.fromRGB(254, 239, 36)
    },
    DesmoDovi = {
        Rider = "Andrea Dovizioso",
        Title = "DESMO DOVI",
        Description = "Riding behind another rider gives you a slipstream boost",
        Weight = 1,
        SlotArt = "LegendSlot",
        Number = "Number04",
        Rig = "DesmoDovi",
        Ability = "Slipstream",
        Color = Color3.fromRGB(200, 16, 46)
    },
    MarcMarquez = {
        Rider = "Marc Marquez",
        Title = "THE BABY ALIEN",
        Description = "Saves you from crashing once per lap",
        Weight = 1,
        Art = "MarcMarquez",
        SlotArt = "LegendSlot",
        Number = "Number93",
        Rig = "MarcMarquez",
        Ability = "CrashSave",
        SavesPerLap = 1,
        Color = Color3.fromRGB(235, 0, 20)
    }
}

function t1.Selected(p2) -- line: 41
    -- upvalues: t1 (copy)
    if typeof(p2) == "table" and typeof(p2.slots) == "table" then
        local v4 = p2.slots[p2.selected or 1]
        local v3 = typeof(v4) == "string" and t1.Legends[v4] and v4 or nil

        return v3
    end

    return nil
end

function t1.ProductKind(p3) -- line: 46
    -- upvalues: t1 (copy)
    for v5, v6 in t1.Products do
        if v6 ~= 0 and v6 == p3 then
            return v5
        end
    end

    return nil
end

function t1.Roll(p4, p5) -- line: 51
    -- upvalues: t1 (copy)
    local v7 = {}

    for _, v8 in t1.Order do
        if v8 ~= p5 then
            table.insert(v7, v8)
        end
    end

    if #v7 == 0 then
        v7 = t1.Order
    end

    local n1 = 0

    for _, v9 in v7 do
        n1 += t1.Legends[v9].Weight
    end

    local v10 = (p4 or Random.new()):NextNumber() * n1

    for _, v11 in v7 do
        v10 -= t1.Legends[v11].Weight

        if v10 <= 0 then
            return v11
        end
    end

    return v7[#v7]
end

function t1.Found(p6, p7) -- line: 63
    if typeof(p6) == "table" and typeof(p6.found) == "table" then
        return table.find(p6.found, p7) ~= nil
    end

    return false
end

function t1.Clean(p8) -- line: 66
    -- upvalues: t1 (copy)
    local v12 = if typeof(p8) ~= "table" or not p8 then {} else p8
    local t2 = {
        selected = 1,
        slots = {},
        unlocked = {}
    }

    for i = 1, t1.SlotCount do
        local v13 = typeof(v12.slots) == "table" and v12.slots[i]
        local slots2 = t2.slots

        if typeof(v13) == "string" and t1.Legends[v13] and v13 then
            slots2[i] = v13
        else
            slots2[i] = ""
        end

        local unlocked = t2.unlocked

        if i == 1 then
            unlocked[i] = true
        elseif typeof(v12.unlocked) == "table" then
            unlocked[i] = v12.unlocked[i] == true
        else
            unlocked[i] = false
        end
    end

    local t3 = {}
    local found = v12.found

    for _, v14 in typeof(found) == "table" and v12.found or {} do
        if typeof(v14) == "string" and t1.Legends[v14] and not table.find(t3, v14) then
            table.insert(t3, v14)
        end
    end

    for i = 1, t1.SlotCount do
        local v15 = t2.slots[i]

        if v15 ~= "" and not table.find(t3, v15) then
            table.insert(t3, v15)
        end
    end

    t2.found = t3

    local selected = v12.selected

    if typeof(selected) == "number" and selected % 1 == 0 and selected >= 1 and selected <= t1.SlotCount and t2.unlocked[selected] then
        t2.selected = selected
    end

    return t2
end

return t1
