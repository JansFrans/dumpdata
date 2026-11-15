-- https://lua.expert

local format = string.format
local t1 = {}

t1.TYPE = {
    INVALID_TYPE = "%s(...): The `%s` argument must be a %s, but you passed %q (%s)",
    INVALID_ARRAY = "%s(...): The `%s` argument must be an array of %s, but you passed %q (%s) at index #%d",
    INVALID_EVAL_ARG = "%s(...): The `%s` argument must %s, but you passed %q (%s)"
}

function t1.typeOf(p1, p2, p3, p4) -- line: 13
    -- upvalues: t1 (copy), format (copy)
    local v1 = format(t1.TYPE.INVALID_TYPE, p1, p2, p3, tostring(p4), (typeof(p4)))

    if typeof(p4) ~= p3 then
        error(v1, 3)
    end

    return p4
end

function t1.evalArg(p5, p6, p7, p8, p9) -- line: 23
    -- upvalues: t1 (copy), format (copy)
    local v2 = format(t1.TYPE.INVALID_EVAL_ARG, p5, p6, p7, tostring(p9), (typeof(p9)))

    if p8 ~= true then
        error(v2, 3)
    end

    return p9
end

function t1.arrayOf(p10, p11, p12, p13) -- line: 33
    -- upvalues: t1 (copy), format (copy)
    t1.typeOf("Assert.arrayOf", "array", "table", p13)

    for v3, v4 in ipairs(p13) do
        if typeof(v4) ~= p12 then
            local v5 = format(t1.TYPE.INVALID_ARRAY, p10, p11, p12, tostring(v4), typeof(v4), v3)

            error(v5, 3)
        end
    end

    return nil
end

function t1.prepTypeOf(p14) -- line: 47
    -- upvalues: t1 (copy)
    return function(p15, p16, p17) -- line: 48
        -- upvalues: p14 (copy), t1 (copy)
        return t1.typeOf(p14, p15, p16, p17)
    end
end

function t1.prepEvalArg(p18) -- line: 53
    -- upvalues: t1 (copy)
    return function(p19, p20, p21, p22) -- line: 54
        -- upvalues: p18 (copy), t1 (copy)
        return t1.evalArg(p18, p19, p20, p21, p22)
    end
end

function t1.prepArrayOf(p23) -- line: 59
    -- upvalues: t1 (copy)
    return function(p24, p25, p26) -- line: 60
        -- upvalues: p23 (copy), t1 (copy)
        return t1.arrayOf(p23, p24, p25, p26)
    end
end

return t1
