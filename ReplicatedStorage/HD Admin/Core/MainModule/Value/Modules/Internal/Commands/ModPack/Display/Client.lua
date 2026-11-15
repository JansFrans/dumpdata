-- https://lua.expert

local CommandAPI = require(script:FindFirstAncestor("HD Admin").Core.CommandAPI)
local Players = game:GetService("Players")
local getHead = CommandAPI.getHead

return {
    {
        name = "Ping",
        run = function(p1, _) -- run | line: 14
            local v1 = tick()
            local v2 = math.random(1, 1000)

            p1.server:replicate(v1, v2)
        end,
        replication = function(p3, _) -- replication | line: 19
            -- upvalues: CommandAPI (copy)
            local v3 = CommandAPI.round((tick() - p3) / 2 * 1000, 2)

            CommandAPI.prompt("info", (("Your ping is %* ms"):format(v3)))
        end
    },
    {
        name = "HideGuis",
        run = function(p5, _) -- run | line: 33
            -- upvalues: Players (copy)
            local v4 = Players.LocalPlayer:WaitForChild("PlayerGui", 3)

            if v4 then
                for _, child in v4:GetChildren() do
                    if child:IsA("ScreenGui") and child.Enabled and child.Name ~= "HDAdmin" then
                        child.Enabled = false
                        p5:onEnded(function() -- line: 50
                            -- upvalues: child (copy)
                            child.Enabled = true
                        end)
                    end
                end
            end
        end
    },
    {
        name = "NightVision",
        run = function(p7) -- run | line: 60
            -- upvalues: Players (copy), getHead (copy)
            local LocalPlayer = game:GetService("Players").LocalPlayer
            local janitor = p7.janitor

            for _, player in Players:GetPlayers() do
                local v5 = getHead(player)
                local Character = player.Character

                if Character and v5 and player.Name ~= LocalPlayer.Name then
                    for _, child in Character:GetChildren() do
                        if child:IsA("BasePart") and not child:FindFirstChild("HDNightVision") ~= nil then
                            for i = 1, 6 do
                                local v6 = janitor:add(script.NightVision:Clone())

                                v6.Parent = child
                                v6.Face = i - 1
                                v6.Name = "HDAdminNightVision"
                            end
                        end
                    end

                    local v7 = janitor:add(script.Nickname:Clone())

                    v7.TextLabel.Text = player.Name
                    v7.Parent = v5
                    v7.Name = "HDAdminNightVision"
                end
            end
        end
    },
    {
        name = "Blur",
        run = function(p8, p9) -- run | line: 91
            if p8.extra.blur then
                p8.extra.blur.Size = p9
            else
                local janitor = p8.janitor
                local CurrentCamera = workspace.CurrentCamera
                local v8 = janitor:add(Instance.new("BlurEffect", CurrentCamera))

                v8.Size = p9
                p8.extra.blur = v8
            end
        end
    },
    {
        name = "View",
        run = function(p10, p11) -- run | line: 108
            -- upvalues: CommandAPI (copy)
            if not p11 then
                return
            end

            local LocalPlayer = game:GetService("Players").LocalPlayer
            local janitor = p10.janitor
            local setCameraSubject = CommandAPI.setCameraSubject

            setCameraSubject(p11)
            janitor:add(p11.CharacterAdded:Connect(function() -- line: 114
                -- upvalues: p10 (copy), p11 (copy), setCameraSubject (copy)
                if not p11.Character then
                    p11.CharacterAdded:Wait()
                end

                p10.wait()
                setCameraSubject(p11)
            end))
            janitor:add(p11:GetPropertyChangedSignal("Parent"):Once(function() -- line: 119
                -- upvalues: LocalPlayer (copy), setCameraSubject (copy)
                setCameraSubject(LocalPlayer)
            end))
            p10:onEnded(function() -- line: 122
                -- upvalues: LocalPlayer (copy), setCameraSubject (copy)
                setCameraSubject(LocalPlayer)
            end)
        end
    }
}
