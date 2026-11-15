-- https://lua.expert

local TableUtil = require(script.Parent.TableUtil)
local DeepEquals = require(script.DeepEquals)

local function CopyIfTable(p1) -- line: 4
    -- upvalues: TableUtil (copy)
    if typeof(p1) == "table" then
        return TableUtil.Copy(p1, true)
    end

    return p1
end

local function Equals(p2, p3) -- line: 12
    -- upvalues: DeepEquals (copy)
    if typeof(p2) ~= "table" or typeof(p3) ~= "table" then
        return p2 == p3
    end

    return DeepEquals(p2, p3)
end

local function ProcessObserver(p4, p5, p6, p7) -- line: 20
    -- upvalues: DeepEquals (copy)
    if p4.Specifier ~= nil then
        local v1 = p4.Specifier(p5)
        local v2 = p4.Specifier(p6)

        if not p7 and (if typeof(v1) == "table" and typeof(v2) == "table" then DeepEquals(v1, v2) else v1 == v2) then
            return
        end

        p4.Callback(v1, v2)
    else
        p4.Callback(p5, p6)
    end
end

local function NewStator(p8, p9) -- line: 34
    -- upvalues: CopyIfTable (copy), ProcessObserver (copy)
    local t1 = {
        Value = p8,
        Updaters = p9,
        Observers = {}
    }

    function t1.Observe(_, p11, p12) -- line: 41
        -- upvalues: t1 (copy), ProcessObserver (copy)
        local v3 = t1:Get()
        local t2 = {
            Callback = p11,
            Specifier = p12
        }

        table.insert(t1.Observers, t2)
        ProcessObserver(t2, v3, v3)

        return function() -- line: 52
            -- upvalues: t2 (copy), t1 (copy)
            local v4 = table.find(t1.Observers, t2)

            if v4 ~= nil then
                table.remove(t1.Observers, v4)
            end
        end
    end

    function t1.Update(_, p14) -- line: 60
        -- upvalues: t1 (copy), CopyIfTable (copy), ProcessObserver (copy)
        local v5 = t1:Get()
        local v6 = p14(CopyIfTable(v5))

        t1.Value = v6

        for _, v7 in ipairs(t1.Observers) do
            ProcessObserver(v7, v5, v6)
        end
    end

    function t1.Get(_) -- line: 71
        -- upvalues: t1 (copy), CopyIfTable (copy)
        return CopyIfTable(t1.Value)
    end

    return t1
end

return NewStator
