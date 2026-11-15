-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local runEmoteId = require(Modules.CommandUtil.runEmoteId)
local getTorso = require(Modules.PlayerUtil.getTorso)
local getHRP = require(Modules.PlayerUtil.getHRP)

require(Modules.Prompt)
require(Modules.Objects.Task)

local Event = require(Modules.Objects.Remote).new("PlaySoundInstance", "Event")

local function createTorsoSound(p1, p2, p3, _) -- line: 14
    -- upvalues: Modules (copy), getHRP (copy), Event (copy)
    p3 = p3 or {}

    local v2 = getHRP(p1)
    local v3 = p3.Volume or 0.25
    local v4 = p3.LoopedSound ~= false
    local Command = require(Modules.AssetUtil.registerSound)(Instance.new("Sound"), "Command")

    Command.Name = "HDTorsoSound"
    Command.Volume = v3
    Command.Looped = v4
    Command.RollOffMaxDistance = 30
    Command.RollOffMinDistance = 5
    Command.SoundId = "rbxassetid://" .. p2
    Command.Parent = v2
    Instance.new("EqualizerSoundEffect", Command)

    local StartTime = p3.StartTime

    if StartTime then
        Command.TimePosition = StartTime
    end

    if p3.LocalSoundId then
        Event:fireClient(p1, Command)
    else
        Command:Play()
    end

    return Command
end

return function(p5, p6, p7) -- line: 41
    -- upvalues: Modules (copy), runEmoteId (copy), getTorso (copy), getHRP (copy), Event (copy), createTorsoSound (copy)
    local v5 = p7 or {}
    local Aliases = v5.Aliases
    local v6 = p5:lower()
    local v7, v8

    if not v5.IsDance or v6:match("dance") then
        v8 = Aliases
    else
        v7 = Aliases or {}
        v8 = v7
        table.insert(v7, p5 .. "Dance")
    end

    return {
        name = p5,
        aliases = v8,
        groups = { "Emote" },
        args = { "Player", "AnimationSpeed" },
        run = function(p8) -- run | line: 56
            -- upvalues: p5 (copy), p6 (copy), v5 (copy), Modules (copy), runEmoteId (copy), getTorso (copy), getHRP (copy), Event (copy), createTorsoSound (copy)
            local v10 = p6
            local v11 = v5
            local v12 = p5

            if typeof(p6) == "function" then
                v12, v10, v11 = p6()
            end

            local target = p8.target
            local AnimationSpeed = p8:getArg("AnimationSpeed")
            local emoteSpeed = p8.extra.emoteSpeed
            local v13, v14

            if emoteSpeed then
                v13 = emoteSpeed
                v14 = true
            elseif AnimationSpeed == 1 then
                v14 = false
            elseif AnimationSpeed then
                v13 = AnimationSpeed
                v14 = true
            else
                v14 = false
            end

            if not v14 then
                v13 = v11.Speed or 1
            end

            local janitor = p8.janitor
            local LocalSoundId = v11.LocalSoundId
            local v15 = v11.SoundId or LocalSoundId
            local v16 = tonumber(v11.BundleId)
            local v17 = v11.Looped == true

            if v11.GroupExclusive == true then
                local checkWithinHDGroupAsync = require(Modules.VerifyUtil.checkWithinHDGroupAsync)
                local caller = p8.caller

                if caller and checkWithinHDGroupAsync(caller) == false then
                    return
                end
            end

            if typeof(v15) == "table" then
                v15 = v15[math.random(1, #v15)]
            end

            if typeof(v15) == "table" then
                for v19, v20 in v15 do
                    if v19 == "Id" then
                        v15 = v15.Id
                    else
                        v11[v19] = v20
                    end
                end
            end

            local Particles = v11.Particles

            if Particles and not p8.extra.emoteParticlesAdded then
                p8.extra.emoteParticlesAdded = true

                local v21 = getTorso(target)

                if v21 then
                    for _, child in Particles:GetChildren() do
                        if child:IsA("Attachment") and child.Name:match("HD_") then
                            janitor:add(child:Clone()).Parent = v21
                        end
                    end
                end
            end

            local v22 = target and target.Character
            local v23 = getHRP(target)

            if v11.Anchor and v23 then
                v23.Anchored = true
                p8:onEnded(function() -- line: 109
                    -- upvalues: v23 (copy)
                    if v23.Parent then
                        v23.Anchored = false
                    end
                end)
            end

            local BundleProperties = v11.BundleProperties
            local outfitBuff = require(Modules.OutfitUtil.outfitBuff)

            if v11.ClearAccessories then
                p8:buff(target, "Outfit", outfitBuff(target, {
                    _ClearAccessories = true
                }))
            end

            if v16 and v22 then
                require(Modules.OutfitUtil.runBundleId)(p8, v16, v11)
            end

            if BundleProperties then
                p8:buff(target, "Outfit", outfitBuff(target, BundleProperties))
            end

            if v11.PlayVoice == true then
                require(Modules.CommandUtil.playTextToSpeech)(target, v12)
            end

            if v15 then
                local emoteTorsoSound = p8.extra.emoteTorsoSound

                if emoteTorsoSound and emoteTorsoSound.Parent and emoteTorsoSound.SoundId == "rbxassetid://" .. v15 then
                    emoteTorsoSound.TimePosition = v11.StartTime or 0

                    if LocalSoundId then
                        Event:fireClient(target, emoteTorsoSound)
                    else
                        emoteTorsoSound:Play()
                    end
                else
                    if emoteTorsoSound then
                        emoteTorsoSound:Destroy()
                    end

                    p8.extra.emoteTorsoSound = janitor:add((createTorsoSound(target, v15, v11)))
                end
            end

            if runEmoteId(p8, v10, v13, v17) then
                require(Modules.CommandUtil.bindEmotePrompt)(p8, target, v10, v12, v17)
            end
        end
    }
end
