-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local createConnection = require(Modules.AssetUtil.createConnection)
local Janitor = require(Modules.Objects.Janitor)
local Serializer = require(Modules.Serializer)
local Remotes
local t2 = {}
local t1 = {}

t1.__index = t1

local t3 = {
    None = nil,
    Low = {
        capacity = 60,
        refillRate = 10
    },
    Medium = {
        capacity = 20,
        refillRate = 6
    },
    High = {
        capacity = 8,
        refillRate = 2
    },
    Once = {
        capacity = 1,
        refillRate = 0
    }
}

local function consumeToken(p1, p2) -- line: 31
    local elapsed = os.clock()
    local v1 = elapsed - p1.lastRefill

    p1.lastRefill = elapsed
    p1.tokens = math.min(p2.capacity, p1.tokens + v1 * p2.refillRate)

    if p1.tokens >= 1 then
        p1.tokens -= 1

        return true
    end

    return false
end

local v3 = false

local function ensurePlayerRemovingCleanup() -- line: 45
    -- upvalues: Players (copy), t2 (copy), v3 (ref)
    if not v3 then
        v3 = true
        Players.PlayerRemoving:Connect(function(p3) -- line: 48
            -- upvalues: t2 (copy)
            local UserId = p3.UserId

            for _, v4 in t2 do
                if v4._buckets then
                    v4._buckets[UserId] = nil
                end

                if v4._rateLimitWarned then
                    v4._rateLimitWarned[UserId] = nil
                end
            end
        end)
    end
end

local function checkRateLimit(p4, p5) -- line: 62
    -- upvalues: t3 (copy)
    local v5 = t3[p4._rateLimitIntensity]

    if not v5 then
        return true
    end

    local UserId = p5.UserId
    local _buckets = p4._buckets

    if not _buckets then
        _buckets = {}
        p4._buckets = _buckets
    end

    local v6 = _buckets[UserId]

    if not v6 then
        v6 = {
            tokens = v5.capacity,
            lastRefill = os.clock()
        }
        _buckets[UserId] = v6
    end

    local elapsed = os.clock()
    local v7 = elapsed - v6.lastRefill

    v6.lastRefill = elapsed
    v6.tokens = math.min(v5.capacity, v6.tokens + v7 * v5.refillRate)

    if v6.tokens >= 1 then
        v6.tokens -= 1

        return true
    end

    local _rateLimitWarned = p4._rateLimitWarned

    if not _rateLimitWarned then
        _rateLimitWarned = {}
        p4._rateLimitWarned = _rateLimitWarned
    end

    if not _rateLimitWarned[UserId] then
        _rateLimitWarned[UserId] = true
    end

    return false
end

function t1.new(p6, p7, p8) -- line: 95
    -- upvalues: Players (copy), RunService (copy), Janitor (copy), t1 (copy), t2 (copy), v3 (ref)
    local v9 = Janitor.new()
    local t4 = {
        permitInvokeCallback = true,
        remoteInstance = nil,
        isActive = true,
        _buckets = nil,
        _rateLimitWarned = nil,
        janitor = v9,
        uniqueName = p6,
        _rateLimitIntensity = p8 or "Medium"
    }

    setmetatable(t4, t1)

    if RunService:IsServer() then
        local v10

        if p7 == "Function" then
            v10 = "RemoteFunction"
        else
            if p7 ~= "Event" and p7 ~= nil then
                error("Invalid remoteType")
            end

            v10 = "RemoteEvent"
        end

        local v11 = t4:_getContainer()

        if v11 then
            if v11:FindFirstChild(p6) then
                error((("Remote with name '%*' already exists"):format(p6)))
            end

            local v12 = v9:add(Instance.new(v10))

            v12.Name = p6
            v12.Parent = v11
            t4.remoteInstance = v12
        end
    end

    t2[p6] = t4
    v9:add(function() -- line: 136
        -- upvalues: p6 (copy), t2 (copy)
        t2[p6] = nil
    end)

    if RunService:IsServer() then
        if v3 then
            return t4
        end

        v3 = true
        Players.PlayerRemoving:Connect(function(p9) -- line: 48
            -- upvalues: t2 (copy)
            local UserId = p9.UserId

            for _, v13 in t2 do
                if v13._buckets then
                    v13._buckets[UserId] = nil
                end

                if v13._rateLimitWarned then
                    v13._rateLimitWarned[UserId] = nil
                end
            end
        end)
    end

    return t4
end

function t1.get(p10) -- line: 148
    -- upvalues: t1 (copy)
    return t1.new(p10, "Event")
end

function t1.find(p11) -- line: 157
    -- upvalues: t2 (copy)
    return t2[p11]
end

function t1._getContainer(p12) -- line: 170
    -- upvalues: RunService (copy), Modules (copy), Remotes (ref)
    if Remotes then
        return Remotes
    end

    local Remotes2 = Modules.Parent:FindFirstChild("Remotes")

    if not RunService:IsServer() then
        while p12.isActive do
            Remotes2 = Modules.Parent:FindFirstChild("Remotes")

            if Remotes2 then
                break
            end

            task.wait()
        end
    elseif not Remotes2 then
        Remotes2 = Instance.new("Folder")
        Remotes2.Name = "Remotes"
        Remotes2.Parent = Modules.Parent
    end

    if Remotes2 then
        Remotes = Remotes2
    end

    return Remotes2
end

function t1._waitForInstance(p13) -- line: 196
    local v14 = p13:_getContainer()

    if not v14 then
        return nil
    end

    local remoteInstance

    while true do
        if not p13.isActive then
            return nil
        end

        remoteInstance = p13.remoteInstance

        if remoteInstance == nil then
            remoteInstance = v14:FindFirstChild(p13.uniqueName)
        end

        if remoteInstance then
            break
        end

        task.wait()
    end

    p13.remoteInstance = remoteInstance

    return remoteInstance
end

function t1._onInstanceLoaded(p14, p15) -- line: 215
    local remoteInstance = p14.remoteInstance

    if remoteInstance then
        p15(remoteInstance)
    else
        task.spawn(function() -- line: 221
            -- upvalues: p14 (copy), p15 (copy)
            local v15 = p14:_getContainer()

            while v15 and p14.remoteInstance == nil and p14.isActive do
                local v16 = v15:FindFirstChild(p14.uniqueName)

                if v16 then
                    p14.remoteInstance = v16
                    break
                end

                task.wait()
            end

            if p14.remoteInstance then
                p15(p14.remoteInstance)
            end
        end)
    end
end

function t1.fireClient(p16, p17, ...) -- line: 239
    -- upvalues: RunService (copy), Serializer (copy)
    local remoteInstance = p16.remoteInstance

    if not (remoteInstance and remoteInstance:IsA("RemoteEvent")) then
        error("Can only call fireClient for remoteType 'Event'")
    elseif RunService:IsClient() then
        error("Can only call fireClient on server")
    elseif not p17:IsA("Player") then
        error("Player must be a valid Player instance")
    end

    local v17 = table.pack(...)

    remoteInstance:FireClient(p17, (Serializer.processForNetwork(v17)))
end

function t1.fireAllClients(p18, ...) -- line: 253
    -- upvalues: Players (copy)
    for _, player in Players:GetPlayers() do
        p18:fireClient(player, ...)
    end
end

function t1.fireNearbyClients(p19, p20, p21, ...) -- line: 259
    -- upvalues: Players (copy)
    for _, player in Players:GetPlayers() do
        if player:DistanceFromCharacter(p20) <= p21 then
            p19:fireClient(player, ...)
        end
    end
end

function t1.fireServer(p22, ...) -- line: 267
    -- upvalues: RunService (copy)
    if RunService:IsServer() then
        error("Can only call fireServer on client")
    end

    local v18 = table.pack(...)

    p22:_onInstanceLoaded(function(p23) -- line: 272
        -- upvalues: v18 (copy)
        if not p23:IsA("RemoteEvent") then
            error("Can only call fireServer for remoteType 'Event'")
        end

        p23:FireServer(table.unpack(v18))
    end)
end

function t1.invokeServerAsync(p24, ...) -- line: 280
    -- upvalues: RunService (copy), Serializer (copy)
    if RunService:IsServer() then
        error("Can only call invokeServer on client")
    end

    local v19 = p24:_waitForInstance()

    if not v19 then
        return false, "Remote was destroyed"
    end

    if not v19:IsA("RemoteFunction") then
        return false, "Can only call invokeServer for remoteType 'Function'"
    end

    local v20 = table.pack(...)

    local function v21() -- line: 291
        -- upvalues: v19 (copy), v20 (copy)
        return v19:InvokeServer(table.unpack(v20))
    end

    local ok, result = pcall(v21)

    if not ok then
        return false, result
    end

    local v22 = Serializer.processForNetwork(result)

    if typeof(v22[1]) == "boolean" then
        return table.unpack(v22)
    end

    return true, table.unpack(v22)
end

function t1.onClientEvent(p25, p26) -- line: 304
    -- upvalues: RunService (copy), createConnection (copy), Serializer (copy)
    if RunService:IsServer() then
        error("Can only call onClientEvent on client")
    end

    local v24

    p25:_onInstanceLoaded(function(p27) -- line: 309
        -- upvalues: p25 (copy), p26 (copy), v24 (ref), Serializer (copy)
        if not p27:IsA("RemoteEvent") then
            error("Can only call onClientEvent for remoteType 'Event'")
        end

        if v24 ~= false then
            v24 = p25.janitor:add(p27.OnClientEvent:Connect(function(p28) -- line: 316
                -- upvalues: p26 (copy), Serializer (copy)
                p26(table.unpack((Serializer.processForNetwork(p28))))
            end))
        end
    end)

    return createConnection(function() -- line: 321
        -- upvalues: v24 (ref)
        if v24 then
            v24:Disconnect()
            v24 = false
        end
    end)
end

function t1.onServerEvent(p29, p30) -- line: 330
    -- upvalues: RunService (copy), createConnection (copy), checkRateLimit (copy)
    local remoteInstance = p29.remoteInstance

    if not (remoteInstance and remoteInstance:IsA("RemoteEvent")) then
        error("Can only call onServerEvent for remoteType 'Event'")
    elseif RunService:IsClient() then
        error("Can only call onServerEvent on server")
    end

    local v26 = p29.janitor:add(remoteInstance.OnServerEvent:Connect(function(p31, ...) -- line: 337
        -- upvalues: p29 (copy), p30 (copy), checkRateLimit (copy)
        if checkRateLimit(p29, p31) then
            p30(p31, ...)
        end
    end))

    return createConnection(function() -- line: 343
        -- upvalues: v26 (copy)
        if v26 then
            v26:Disconnect()
        end
    end)
end

function t1.onServerInvoke(p32, p33) -- line: 350
    -- upvalues: RunService (copy), createConnection (copy), Serializer (copy), checkRateLimit (copy)
    local remoteInstance = p32.remoteInstance

    if not (remoteInstance and remoteInstance:IsA("RemoteFunction")) then
        error("Can only call onServerInvoke for remoteType 'Function'")
    elseif RunService:IsClient() then
        error("Can only call onServerInvoke on server")
    elseif p32.permitInvokeCallback == true then
        p32.permitInvokeCallback = false
    else
        error("Can only have one onServerInvoke callback per remote")
    end

    remoteInstance.OnServerInvoke = function(p34, ...) -- line: 361
        -- upvalues: p32 (copy), p33 (copy), Serializer (copy), checkRateLimit (copy)
        if checkRateLimit(p32, p34) then
            local v27 = table.pack(p33(p34, ...))

            return (Serializer.processForNetwork(v27))
        end

        local v28 = table.pack(false, "Rate limited")

        return (Serializer.processForNetwork(v28))
    end

    return createConnection(function() -- line: 372
        -- upvalues: remoteInstance (copy)
        remoteInstance.OnServerInvoke = nil
    end)
end

function t1.destroy(p35) -- line: 377
    if p35.isActive ~= false then
        p35.isActive = false
        p35.janitor:destroy()
    end
end

return t1
