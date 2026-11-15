-- https://lua.expert

game:GetService("RunService")

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Banner = require(UI.Components.Banner)
local UpdateLog = require(UI.Config.UpdateLog)
local Remote = require(Modules.Objects.Remote)
local t1 = {
    January = 1,
    February = 2,
    March = 3,
    April = 4,
    May = 5,
    June = 6,
    July = 7,
    August = 8,
    September = 9,
    October = 10,
    November = 11,
    December = 12
}

local function readEntryTime(p1) -- line: 38
    -- upvalues: t1 (copy)
    local v1, v2, v3 = string.match(p1.Date, "^(%d+)%s+(%a+)%s+(%d+)$")
    local v4 = if v2 then t1[v2] else nil

    if v1 and v4 and v3 then
        return os.time({
            hour = 0,
            year = tonumber(v3),
            month = v4,
            day = tonumber(v1)
        })
    end

    return nil
end

return function(p2, p3) -- line: 54
    -- upvalues: Fusion (copy), Banner (copy), UpdateLog (copy), Remote (copy), readEntryTime (copy)
    local v5 = UpdateLog[1]
    local v6 = if not (v5 and v5.Banner) then nil else readEntryTime(v5)
    local v7 = v6 ~= nil and os.time() - v6 <= 2419200
    local SeenUpdateTime = p2:Fuse("perm", "SeenUpdateTime")
    local v8 = p2:Value(false)

    local function dismiss() -- line: 64
        -- upvalues: v6 (copy), v8 (copy), Fusion (copy), Remote (copy)
        if not Fusion.peek(v8) then
            v8:set(true)
            task.spawn(function() -- line: 69
                -- upvalues: v6 (copy), Remote (copy)
                local DismissUpdate = Remote.get("DismissUpdate")

                if DismissUpdate then
                    DismissUpdate:invokeServerAsync(v6)
                end
            end)
        end
    end

    local v9 = p2:Computed(function(p4) -- line: 77
        -- upvalues: p3 (copy), v6 (copy), SeenUpdateTime (copy), v8 (copy), v7 (copy)
        if v7 and not p4(v8) and p4(p3.pageVisible) then
            local v11 = p4(SeenUpdateTime)

            return typeof(v11) == "number" and v11 < v6
        end

        return false
    end)
    local visibleValue = p3.visibleValue

    if visibleValue then
        p2:Observer(v9):onChange(function() -- line: 88
            -- upvalues: v9 (copy), visibleValue (copy), Fusion (copy)
            visibleValue:set(Fusion.peek(v9))
        end)
        visibleValue:set(Fusion.peek(v9))
    end

    return Banner(p2, {
        name = "UpdateBanner",
        buttonLabel = "View",
        text = if not (v5 and v5.Banner) then "" else v5.Banner,
        onButton = function() -- onButton | line: 98
            -- upvalues: p3 (copy), v6 (copy), v8 (copy), Fusion (copy), Remote (copy)
            if not Fusion.peek(v8) then
                v8:set(true)
                task.spawn(function() -- line: 69
                    -- upvalues: v6 (copy), Remote (copy)
                    local DismissUpdate = Remote.get("DismissUpdate")

                    if DismissUpdate then
                        DismissUpdate:invokeServerAsync(v6)
                    end
                end)
            end

            p3.onView()
        end,
        onClose = dismiss,
        visible = v9,
        layoutOrder = p3.layoutOrder
    })
end
