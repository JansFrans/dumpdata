-- https://lua.expert

local t1 = {
    Volume = function(p1, p2) -- line: 13
        p1.Volume = p2
    end,
    Pitch = function(p3, p4) -- line: 16
        local PitchShiftSoundEffect = p3:FindFirstChildWhichIsA("PitchShiftSoundEffect")

        if not PitchShiftSoundEffect then
            PitchShiftSoundEffect = Instance.new("PitchShiftSoundEffect")
            PitchShiftSoundEffect.Parent = p3
        end

        if p4 <= 0.99 then
            PitchShiftSoundEffect.Enabled = true
        else
            PitchShiftSoundEffect.Enabled = p4 >= 1.01
        end

        PitchShiftSoundEffect.Octave = p4
    end
}
local RunService = game:GetService("RunService")

game:GetService("Players")

local v1 = RunService:IsClient()
local v2 = not v1
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local CollectionService = game:GetService("CollectionService")

if v2 then
    task.spawn(function() -- line: 40
        -- upvalues: Modules (copy)
        local function createGroup(p5, p6) -- line: 41
            local v3 = p6:FindFirstChild(p5)

            if v3 then
                return v3
            end

            local SoundGroup = Instance.new("SoundGroup")

            SoundGroup.Name = p5
            SoundGroup.Parent = p6

            return SoundGroup
        end

        local Folder = Instance.new("Folder")

        Folder.Name = "Audio"
        Folder.Parent = Modules.Parent

        local Sound = require(Modules.Parent.Services.Config).getSetting("Sound")
        local Groups = Folder:FindFirstChild("Groups")

        if not Groups then
            Groups = Instance.new("SoundGroup")
            Groups.Name = "Groups"
            Groups.Parent = Folder
        end

        for _, v4 in Sound do
            for v5, _ in v4 do
                if not Groups:FindFirstChild(v5) then
                    local SoundGroup = Instance.new("SoundGroup")

                    SoundGroup.Name = v5
                    SoundGroup.Parent = Groups
                end
            end
        end
    end)
end

if v1 then
    task.spawn(function() -- line: 66
        -- upvalues: t1 (copy), Modules (copy), CollectionService (copy)
        local clientUser = require(Modules.References.clientUser)
        local perm, everyone = clientUser.perm, clientUser.everyone
        local v6 = Modules.Parent:WaitForChild("Audio", 999999):WaitForChild("Groups", 999999)

        local function bindSound(p7) -- line: 72
            -- upvalues: v6 (copy)
            if p7:IsA("Sound") then
                local HDAdminSoundType = p7:GetAttribute("HDAdminSoundType")

                if HDAdminSoundType then
                    local v7 = v6:FindFirstChild(HDAdminSoundType)

                    if v7 then
                        p7.SoundGroup = v7
                    end
                end
            end
        end

        CollectionService:GetInstanceAddedSignal("HDAdminSound"):Connect(bindSound)

        for _, v8 in CollectionService:GetTagged("HDAdminSound") do
            if v8:IsA("Sound") then
                local HDAdminSoundType = v8:GetAttribute("HDAdminSoundType")

                if HDAdminSoundType then
                    local v9 = v6:FindFirstChild(HDAdminSoundType)

                    if v9 then
                        v8.SoundGroup = v9
                    end
                end
            end
        end

        everyone:fetch("GameSettings", "PlayerSettings", "Sound", function(p8) -- line: 90
            -- upvalues: perm (copy), everyone (copy), v6 (copy), t1 (copy)
            for v10, v11 in p8 do
                local v12 = t1[v10]

                if v12 then
                    for v13, _ in v11 do
                        local v14 = v6[v13]

                        local function apply() -- line: 98
                            -- upvalues: v10 (copy), v12 (copy), v13 (copy), v14 (copy), perm (copy), everyone (copy)
                            local v15 = perm:get("YouSettings", "Sound", v10, v13)

                            if v15 ~= nil then
                                v12(v14, v15)
                            else
                                local v16 = everyone:get("GameSettings", "PlayerSettings", "Sound", v10, v13)

                                if v16 ~= nil then
                                    v12(v14, v16)
                                end
                            end
                        end

                        perm:onBind("YouSettings", "Sound", v10, v13, apply)
                        everyone:onChange("GameSettings", "PlayerSettings", "Sound", v10, v13, apply)
                    end
                end
            end
        end)
    end)
end

return function(p9, p10) -- line: 118
    -- upvalues: v1 (copy), CollectionService (copy)
    p10 = p10 or (if v1 then "Interface" else "Command")

    if typeof(p9) ~= "Instance" or not p9:IsA("Sound") then
        return error("Invalid sound provided")
    end

    p9:SetAttribute("HDAdminSoundType", p10)
    CollectionService:AddTag(p9, "HDAdminSound")

    return p9
end
