-- https://lua.expert

local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local t1 = {}
local v1, v2
local v3 = false
local v4 = false

local function forEveryValidWorkspaceChild(p1) -- line: 16
    -- upvalues: Players (copy)
    local t2 = {}

    for _, player in Players:GetPlayers() do
        t2[player.Name] = true
    end

    for _, child in workspace:GetChildren() do
        if not child:IsA("Terrain") and child.Archivable then
            local v5 = child.Name:lower()

            if not v5:match("hd admin") and not v5:match("hdadmin") and not child:IsA("Script") and (not child:IsA("Model") or not t2[child.Name]) then
                p1(child)
            end
        end
    end
end

function t1.hasBackup() -- line: 44
    -- upvalues: v1 (ref)
    return v1 ~= nil
end

function t1.markChanged() -- line: 50
    -- upvalues: v3 (ref)
    v3 = true
end

function t1.hasChanged() -- line: 54
    -- upvalues: v1 (ref), v3 (ref)
    return v1 ~= nil and v3
end

function t1.save() -- line: 58
    -- upvalues: ServerStorage (copy), v1 (ref), v2 (ref), v3 (ref), forEveryValidWorkspaceChild (copy)
    local v6 = v1

    if not v6 then
        v6 = Instance.new("Folder")
        v6.Name = "HDAdminMapBackup"
        v6.Parent = ServerStorage
        v1 = v6
    end

    local Terrain = workspace:FindFirstChildOfClass("Terrain")

    v2 = if Terrain then Terrain:CopyRegion(Terrain.MaxExtents) else nil
    v6:ClearAllChildren()
    forEveryValidWorkspaceChild(function(p2) -- line: 69
        -- upvalues: v6 (ref)
        p2:Clone().Parent = v6
    end)
    v3 = false
end

local function countMapInstances() -- line: 76
    -- upvalues: forEveryValidWorkspaceChild (copy)
    local n1 = 0

    forEveryValidWorkspaceChild(function(p3) -- line: 78
        -- upvalues: n1 (ref)
        local v7 = n1

        n1 = v7 + (#p3:GetDescendants() + 1)
    end)

    return n1
end

function t1.ensureSaved() -- line: 84
    -- upvalues: t1 (copy), v1 (ref), v4 (ref), forEveryValidWorkspaceChild (copy)
    if v1 or v4 then
        return false
    end

    local n2 = 0

    forEveryValidWorkspaceChild(function(p4) -- line: 78
        -- upvalues: n2 (ref)
        local v8 = n2

        n2 = v8 + (#p4:GetDescendants() + 1)
    end)

    local v9 = n2

    if v9 > 50000 then
        v4 = true
        warn((("[HD Admin] The map holds %* instances so it wasn't copied automatically. ;clearmap and ;loadmap can only restore a map saved with ;savemap"):format(v9)))

        return false
    end

    t1.save()

    return true
end

function t1.restore() -- line: 98
    -- upvalues: v1 (ref), v2 (ref), v3 (ref), forEveryValidWorkspaceChild (copy)
    local v10 = v1

    if not v10 then
        return false
    end

    forEveryValidWorkspaceChild(function(p5) -- line: 103
        p5:Destroy()
    end)

    if v2 then
        local Terrain = workspace:FindFirstChildOfClass("Terrain")

        if Terrain then
            Terrain:Clear()
            Terrain:PasteRegion(v2, Terrain.MaxExtents.Min, true)
        end
    end

    local clone = v10:Clone()

    clone.Parent = workspace

    for _, child in clone:GetChildren() do
        child.Parent = workspace
    end

    clone:Destroy()
    v3 = false

    return true
end

return t1
