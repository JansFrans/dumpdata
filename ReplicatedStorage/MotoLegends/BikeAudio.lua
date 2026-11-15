-- https://lua.expert

local Config = require(script.Parent.Config)
local Bikes = script.Parent:WaitForChild("Bikes")
local t1 = {}

local function load(p1) -- line: 8
    -- upvalues: Bikes (copy), t1 (copy)
    local v1 = t1[p1]
    local v2

    if v1 ~= nil then
        v2 = v1

        return v2 or nil
    end

    local v3 = Bikes:FindFirstChild(p1)
    local Audio = v3 and v3:FindFirstChild("Audio")
    local v4 = if Audio then require(Audio) else nil

    v2 = not not (Audio and v4) and v4
    t1[p1] = v2

    return v2 or nil
end

local Bike = Config.Bike
local v5 = t1[Bike]
local v6

if v5 == nil then
    local v7 = Bikes:FindFirstChild(Bike)
    local Audio = v7 and v7:FindFirstChild("Audio")
    local v8 = if Audio then require(Audio) else nil

    v6 = not not (Audio and v8) and v8
    t1[Bike] = v6
else
    v6 = v5
end

local v9 = v6 or nil
local self = setmetatable({}, {
    __mode = "k"
})
local self2 = setmetatable({}, {
    __mode = "k"
})
local self3 = setmetatable({}, {
    __index = v9
})

function self3.ForBike(p2) -- line: 21
    -- upvalues: Config (copy), Bikes (copy), t1 (copy), v9 (copy), self (copy), self2 (copy)
    local v13 = self[p2]

    if v13 then
        return v13
    end

    local BikeName = p2:GetAttribute("BikeName")

    if typeof(BikeName) ~= "string" then
        local v14 = self2[p2]

        if not v14 then
            v14 = os.clock()
            self2[p2] = v14
        end

        if os.clock() - v14 < 1 then
            return nil
        end

        BikeName = Config.Bike
    end

    local v15 = t1[BikeName]
    local v16

    if v15 ~= nil then
        v16 = v15
    else
        local v17 = Bikes:FindFirstChild(BikeName)
        local Audio = v17 and v17:FindFirstChild("Audio")
        local v18 = if Audio then require(Audio) else nil

        v16 = not not (Audio and v18) and v18
        t1[BikeName] = v16
    end

    local v19 = v16 or nil or v9

    self[p2] = v19

    return v19
end

function self3.UpdateListener(p3) -- line: 35
    -- upvalues: t1 (copy)
    for _, v20 in t1 do
        if v20 and v20.UpdateListener then
            v20.UpdateListener(p3)
        end
    end
end

function self3.UpdateBike(p4, ...) -- line: 38
    -- upvalues: self3 (copy)
    local v21 = self3.ForBike(p4)

    if v21 then
        return v21.UpdateBike(p4, ...)
    end

    return nil
end

return self3
