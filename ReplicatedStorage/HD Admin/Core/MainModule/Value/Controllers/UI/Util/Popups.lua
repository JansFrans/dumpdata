-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local Fusion = require(Packages.Fusion)
local generateUID = require(Modules.DataUtil.generateUID)
local peek = Fusion.peek
local t1 = {}
local v1 = Fusion.scoped({
    Value = Fusion.Value
})
local t2 = {
    sidebar = v1:Value({}),
    top = v1:Value({}),
    centre = v1:Value({})
}

local function defaultDuration(p1, p2) -- line: 102
    if p1 == "centre" then
        return (math.clamp(#p2 * 0.1 + 6, 6, 20))
    end

    return (math.clamp(#p2 * 0.0625 + 4, 4, 10))
end

t1.sidebarLift = v1:Value(0)

function t1.value(p3) -- line: 113
    -- upvalues: v1 (copy)
    return v1:Value(p3)
end

function t1.toggle(p4) -- line: 117
    -- upvalues: peek (copy)
    p4:set(not peek(p4))
end

function t1.getList(p5) -- line: 121
    -- upvalues: t2 (copy)
    return t2[p5]
end

function t1.pull(p6, p7) -- line: 125
    -- upvalues: peek (copy), t2 (copy)
    local v4 = t2[p6]

    if v4 then
        local v5 = peek(v4)

        for v6, v7 in v5 do
            if v7.id == p7 then
                local v8 = table.clone(v5)

                table.remove(v8, v6)
                v4:set(v8)

                local v9 = v7.options and v7.options.onClosed

                if typeof(v9) == "function" then
                    task.spawn(v9)
                end

                return
            end
        end
    end
end

function t1.push(p8, p9) -- line: 143
    -- upvalues: generateUID (copy), peek (copy), v1 (copy), t2 (copy)
    local v10 = t2[p8]
    local v11 = generateUID(10)
    local options = p9.options
    local v12 = if options then options.duration else nil

    if typeof(v12) ~= "number" then
        local text = p9.text

        v12 = if p8 == "centre" then math.clamp(#text * 0.1 + 6, 6, 20) else math.clamp(#text * 0.0625 + 4, 4, 10)
    end

    local t3 = {
        id = v11,
        channel = p8,
        kind = p9.kind,
        text = p9.text,
        options = p9.options,
        duration = v12,
        dismissRequested = v1:Value(false),
        paused = v1:Value(false),
        exiting = v1:Value(false),
        settled = v1:Value(false),
        size = v1:Value(Vector2.zero)
    }
    local v15 = peek(v10)
    local v16 = table.clone(v15)

    if p9.kind ~= "action" then
        local function senderOf(p10) -- line: 169
            return if p10 then p10.fromUserId else nil
        end

        local function countdownOf(p11) -- line: 172
            return if p11 then p11.countdown else nil
        end

        for _, v17 in v15 do
            if v17.kind == p9.kind and v17.text == p9.text then
                local options2 = v17.options

                if (if options2 then options2.fromUserId else nil) == (if options then options.fromUserId else nil) then
                    local options2 = v17.options

                    if (if options2 then options2.countdown else nil) == (if options then options.countdown else nil) and not peek(v17.exiting) then
                        v17.dismissRequested:set(true)
                    end
                end
            end
        end
    end

    table.insert(v16, t3)
    v10:set(v16)

    local function requestDismiss() -- line: 189
        -- upvalues: t3 (copy)
        t3.dismissRequested:set(true)
    end

    return {
        Destroy = requestDismiss,
        Disconnect = requestDismiss,
        disconnect = requestDismiss
    }
end

return t1
