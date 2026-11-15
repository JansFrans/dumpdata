-- https://lua.expert

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local t1 = {
    ParticleEmitter = true,
    Trail = true,
    Beam = true,
    Fire = true,
    Smoke = true,
    Sparkles = true
}
local t2 = {
    SparkGlow = true,
    LuxuryGlow = true,
    PopFlash = true,
    BackfireFlash = true
}
local t3 = {
    LegendSaveFX = true,
    CrashSparkPoint = true
}
local t4 = {}

local function isEffect(p1) -- line: 15
    -- upvalues: t1 (copy), t2 (copy), t3 (copy)
    if t1[p1.ClassName] then
        return true
    end

    if not p1:IsA("Light") then
        return false
    end

    local v1 = t2[p1.Name]
    local v2, v3

    if v1 then
        v2 = v1
        v3 = true
    elseif p1.Parent ~= nil then
        local v4 = t3[p1.Parent.Name]

        if v4 then
            v2 = v4
            v3 = true
        else
            v3 = false
        end
    else
        v3 = false
    end

    if not v3 then
        v2 = false
    end

    return v2
end

local function roots() -- line: 20
    -- upvalues: Players (copy)
    local t5 = {}

    for _, v5 in { "RaceBikes", "CrashedBikes", "SprintPodium" } do
        local v6 = workspace:FindFirstChild(v5)

        if v6 then
            table.insert(t5, v6)
        end
    end

    for _, player in Players:GetPlayers() do
        if player.Character then
            table.insert(t5, player.Character)
        end
    end

    for _, child in workspace.Terrain:GetChildren() do
        if child.Name == "CrashSparkPoint" then
            table.insert(t5, child)
        end
    end

    return t5
end

local function inScope(p2) -- line: 27
    -- upvalues: Players (copy)
    if p2:IsDescendantOf(workspace.Terrain) then
        return p2.Parent and p2.Parent.Name == "CrashSparkPoint"
    end

    for _, v7 in { "RaceBikes", "CrashedBikes", "SprintPodium" } do
        local v8 = workspace:FindFirstChild(v7)

        if v8 and p2:IsDescendantOf(v8) then
            return true
        end
    end

    local v9 = p2:FindFirstAncestorOfClass("Model")

    while true do
        if not v9 then
            return false
        end

        if Players:GetPlayerFromCharacter(v9) then
            break
        end

        v9 = v9.Parent and v9.Parent:FindFirstAncestorOfClass("Model")
    end

    return true
end

local function on() -- line: 34
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("GfxEffects") ~= false
end

local function hide(p3) -- line: 35
    -- upvalues: t4 (copy)
    if not t4[p3] and p3.Parent then
        t4[p3] = p3.Parent
        p3.Parent = nil
    end
end

local function restoreAll() -- line: 39
    -- upvalues: t4 (copy)
    for v10, v11 in t4 do
        t4[v10] = nil

        if v11 and v11:IsDescendantOf(game) then
            local function v12() -- line: 42
                -- upvalues: v10 (copy), v11 (copy)
                v10.Parent = v11
            end

            pcall(v12)
        end
    end
end

local function sweep() -- line: 45
    -- upvalues: LocalPlayer (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), roots (copy), restoreAll (copy)
    if LocalPlayer:GetAttribute("GfxEffects") ~= false then
        restoreAll()
    else
        for _, v13 in roots() do
            local v14

            if t1[v13.ClassName] then
                v14 = true
            elseif v13:IsA("Light") then
                v14 = t2[v13.Name]
                v14 = v14 or v13.Parent ~= nil and t3[v13.Parent.Name] or false
            else
                v14 = false
            end

            if v14 and not t4[v13] and v13.Parent then
                t4[v13] = v13.Parent
                v13.Parent = nil
            end

            for _, descendant in v13:GetDescendants() do
                local v15

                if t1[descendant.ClassName] then
                    v15 = true
                elseif descendant:IsA("Light") then
                    v15 = t2[descendant.Name]
                    v15 = v15 or descendant.Parent ~= nil and t3[descendant.Parent.Name] or false
                else
                    v15 = false
                end

                if v15 and not t4[descendant] and descendant.Parent then
                    t4[descendant] = descendant.Parent
                    descendant.Parent = nil
                end
            end
        end
    end
end

LocalPlayer:GetAttributeChangedSignal("GfxEffects"):Connect(sweep)
workspace.DescendantAdded:Connect(function(p4) -- line: 53
    -- upvalues: LocalPlayer (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), inScope (copy)
    if LocalPlayer:GetAttribute("GfxEffects") == false and (t1[p4.ClassName] or p4:IsA("Light")) then
        task.defer(function() -- line: 55
            -- upvalues: p4 (copy), LocalPlayer (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), inScope (copy)
            local v16, v17

            if LocalPlayer:GetAttribute("GfxEffects") ~= false then
                v17 = true
            elseif p4.Parent then
                if t1[p4.ClassName] then
                    v16 = true
                elseif p4:IsA("Light") then
                    v16 = t2[p4.Name]
                    v16 = v16 or p4.Parent ~= nil and t3[p4.Parent.Name] or false
                else
                    v16 = false
                end

                v17 = false
            else
                v17 = true
            end

            if v17 or not v16 or not inScope(p4) or t4[p4] then
                return
            end

            if p4.Parent then
                t4[p4] = p4.Parent
                p4.Parent = nil
            end
        end)
    end
end)
task.spawn(function() -- line: 58
    -- upvalues: t4 (copy)
    while true do
        task.wait(10)

        for v18, v19 in t4 do
            if not v19:IsDescendantOf(game) then
                t4[v18] = nil
            end
        end
    end
end)
sweep()
