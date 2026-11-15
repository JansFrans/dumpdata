-- https://lua.expert

local t1 = {}
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Remote = require(Modules.Objects.Remote)

require(Modules.AssetUtil.registerSound)
Remote.get("PlaySoundInstance"):onClientEvent(function(p1) -- line: 13
    if p1 then
        p1:Play()
    end
end)

local Folder, AudioDeviceOutput
local t2 = {}

local function getVoiceOutput() -- line: 24
    -- upvalues: Folder (ref), AudioDeviceOutput (ref), t2 (ref)
    if AudioDeviceOutput and AudioDeviceOutput.Parent then
        return AudioDeviceOutput
    end

    local Folder2 = Instance.new("Folder")

    Folder2.Name = "HDVoices"
    Folder2.Parent = game:GetService("SoundService")
    Folder = Folder2
    t2 = {}

    local AudioDeviceOutput2 = Instance.new("AudioDeviceOutput")

    AudioDeviceOutput2.Name = "Output"
    AudioDeviceOutput2.Parent = Folder2
    AudioDeviceOutput = AudioDeviceOutput2

    return AudioDeviceOutput2
end

Remote.get("PlayTextToSpeech"):onClientEvent(function(p2, p3) -- line: 39
    -- upvalues: Folder (ref), t2 (ref), getVoiceOutput (copy)
    if typeof(p2) == "string" and p2 ~= "" then
        local v2 = getVoiceOutput()
        local v3 = ("%*|%*"):format(p3, p2)
        local v1 = t2[v3]

        if not v1 or not v1.Parent then
            v1 = Instance.new("AudioTextToSpeech")
            v1.Name = p2
            v1.Text = p2

            if typeof(p3) == "string" then
                v1.VoiceId = p3
            else
                v1.VoiceId = "9"
            end

            v1.Speed = 1.25
            v1.PlaybackSpeed = 1.25
            v1.Parent = Folder

            local Wire = Instance.new("Wire")

            Wire.Name = "HDWire"
            Wire.SourceInstance = v1
            Wire.TargetInstance = v2
            Wire.Parent = v1
            t2[v3] = v1
        end

        v1:Play()
    end
end)

return t1
