-- https://lua.expert

local Spawn = require(script.Parent.Spawn)

local function IsComplete(p1) -- line: 20
    return p1.ValueList ~= nil
end

local function IsPending(p2) -- line: 24
    return p2.ValueList == nil
end

local function Expect(p3, p4) -- line: 28
    assert(p3.ValueList, p4)

    return table.unpack(p3.ValueList)
end

local function Unwrap(p5) -- line: 34
    return p5:Expect("Attempt to unwrap pending future!")
end

local function UnwrapOr(p6, ...) -- line: 38
    if p6.ValueList then
        return table.unpack(p6.ValueList)
    end

    return ...
end

local function UnwrapOrElse(p7, p8) -- line: 46
    if p7.ValueList then
        return table.unpack(p7.ValueList)
    end

    return p8()
end

local function After(p9, p10) -- line: 54
    -- upvalues: Spawn (copy)
    if p9.ValueList then
        Spawn(p10, table.unpack(p9.ValueList))
    else
        table.insert(p9.AfterList, p10)
    end
end

local function Await(p11) -- line: 62
    if p11.ValueList then
        return table.unpack(p11.ValueList)
    end

    table.insert(p11.YieldList, coroutine.running())

    return coroutine.yield()
end

local function Future(p12, ...) -- line: 72
    -- upvalues: Spawn (copy), IsComplete (copy), IsPending (copy), Expect (copy), Unwrap (copy), UnwrapOr (copy), UnwrapOrElse (copy), After (copy), Await (copy)
    local t1 = {
        ValueList = nil,
        AfterList = {},
        YieldList = {},
        IsComplete = IsComplete,
        IsPending = IsPending,
        Expect = Expect,
        Unwrap = Unwrap,
        UnwrapOr = UnwrapOr,
        UnwrapOrElse = UnwrapOrElse,
        After = After,
        Await = Await
    }

    Spawn(function(p13, p14, ...) -- line: 90
        -- upvalues: Spawn (copy)
        local t2 = { p14(...) }

        p13.ValueList = t2

        for _, v1 in p13.YieldList do
            task.spawn(v1, table.unpack(t2))
        end

        for _, v2 in p13.AfterList do
            Spawn(v2, table.unpack(t2))
        end
    end, t1, p12, ...)

    return t1
end

return {
    new = Future,
    Try = function(p15, ...) -- Try | line: 106
        -- upvalues: Future (copy)
        return Future(pcall, p15, ...)
    end
}
