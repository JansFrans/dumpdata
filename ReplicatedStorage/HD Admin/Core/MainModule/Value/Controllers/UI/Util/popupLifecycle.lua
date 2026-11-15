-- https://lua.expert

local RunService = game:GetService("RunService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Popups = require(UI.Util.Popups)

return function(p1, p2, p3) -- line: 38
    -- upvalues: RunService (copy), Fusion (copy), Popups (copy)
    local v1 = false

    table.insert(p1, function() -- line: 40
        -- upvalues: v1 (ref)
        v1 = true
    end)

    local v3 = p1:Value(false)
    local v4 = p1:Value(1)
    local n1 = 0
    local duration = p2.duration

    task.defer(function() -- line: 49
        -- upvalues: p3 (copy), v1 (ref), v3 (copy)
        if not v1 then
            v3:set(true)

            if p3 then
                p3()
            end
        end
    end)

    local function requestDismiss() -- line: 55
        -- upvalues: p2 (copy), v1 (ref), v3 (copy), Fusion (copy), Popups (copy)
        if v1 or Fusion.peek(p2.exiting) then
            return
        end

        p2.exiting:set(true)
        v3:set(false)
        task.delay(0.4, function() -- line: 62
            -- upvalues: p2 (copy), v1 (ref), Popups (copy)
            if not v1 then
                Popups.pull(p2.channel, p2.id)
            end
        end)
    end

    local function togglePause() -- line: 68
        -- upvalues: p2 (copy), v1 (ref), Fusion (copy)
        if not v1 then
            p2.paused:set(not Fusion.peek(p2.paused))
        end
    end

    p1:Observer(p2.dismissRequested):onChange(function() -- line: 73
        -- upvalues: p2 (copy), requestDismiss (copy), Fusion (copy)
        if Fusion.peek(p2.dismissRequested) then
            requestDismiss()
        end
    end)

    if duration > 0 then
        local connection = RunService.Heartbeat:Connect(function(p4) -- line: 80
            -- upvalues: p2 (copy), v1 (ref), v4 (copy), n1 (ref), duration (copy), requestDismiss (copy), Fusion (copy)
            if v1 or Fusion.peek(p2.exiting) or Fusion.peek(p2.paused) then
                return
            end

            n1 += p4
            v4:set((math.clamp(1 - n1 / duration, 0, 1)))

            if n1 >= duration then
                requestDismiss()
            end
        end)

        table.insert(p1, function() -- line: 89
            -- upvalues: connection (copy)
            connection:Disconnect()
        end)
    end

    return {
        visible = v3,
        progress = v4,
        offset = p1:Computed(function(p5) -- line: 95
            -- upvalues: p2 (copy), Popups (copy)
            local v7 = p5(Popups.getList(p2.channel))
            local v8

            for v9, v10 in v7 do
                if v10.id == p2.id then
                    v8 = v9
                    break
                end
            end

            if v8 == nil then
                return 0
            end

            if p2.channel == "centre" then
                local n2 = 0
                local n3 = 0
                local n4 = 120
                local n5 = 0

                for v11, v12 in v7 do
                    if not p5(v12.exiting) then
                        local Y = p5(v12.size).Y

                        if not (Y > 0) then
                            Y = 120
                        end

                        n5 += 1

                        if v11 < v8 then
                            n2 += Y + 12
                        end

                        if v12.id == p2.id then
                            n4 = Y
                        end

                        n3 += Y
                    end
                end

                local v14 = n3 + math.max(0, n5 - 1) * 12

                return n2 + n4 / 2 - v14 / 2
            end

            local v15 = v8 + 1
            local v16 = #v7
            local n6 = 0

            for i = v15, v16 do
                local v17 = v7[i]

                if not p5(v17.exiting) then
                    local Y = p5(v17.size).Y

                    if not (Y > 0) then
                        Y = 80
                    end

                    n6 += Y + 8
                end
            end

            return n6
        end),
        requestDismiss = requestDismiss,
        togglePause = togglePause
    }
end
