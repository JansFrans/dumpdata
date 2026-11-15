-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local whichLivesLonger = require(ParentParent.Memory.whichLivesLonger)
local nameOf = require(ParentParent.Utility.nameOf)
local t1 = {
    formatters = {}
}

function t1.formatters.useFunction(p1, p2) -- line: 22
    -- upvalues: nameOf (copy)
    local object = nameOf(p1, "object")

    return ("The use()-d %*"):format((nameOf(p2, "object"))), (("the %*"):format(object))
end

function t1.formatters.boundProperty(p3, p4, p5) -- line: 31
    -- upvalues: nameOf (copy)
    local Name = p3.Name

    return ("The %* (bound to the %* property)"):format(nameOf(p4, "value"), p5), (("the %* instance"):format(Name))
end

function t1.formatters.boundAttribute(p6, p7, p8) -- line: 41
    -- upvalues: nameOf (copy)
    local Name = p6.Name

    return ("The %* (bound to the %* attribute)"):format(nameOf(p7, "value"), p8), (("the %* instance"):format(Name))
end

function t1.formatters.propertyOutputsTo(p9, p10, p11) -- line: 51
    -- upvalues: nameOf (copy)
    local Name = p9.Name

    return ("The %* (which the %* property outputs to)"):format(nameOf(p10, "object"), p11), (("the %* instance"):format(Name))
end

function t1.formatters.attributeOutputsTo(p12, p13, p14) -- line: 61
    -- upvalues: nameOf (copy)
    local Name = p12.Name

    return ("The %* (which the %* attribute outputs to)"):format(nameOf(p13, "object"), p14), (("the %* instance"):format(Name))
end

function t1.formatters.refOutputsTo(p15, p16) -- line: 71
    -- upvalues: nameOf (copy)
    local Name = p15.Name

    return ("The %* (which the Ref key outputs to)"):format((nameOf(p16, "object"))), (("the %* instance"):format(Name))
end

function t1.formatters.animationGoal(p17, p18) -- line: 80
    -- upvalues: nameOf (copy)
    local object = nameOf(p17, "object")

    return ("The goal %*"):format((nameOf(p18, "object"))), (("the %* that is following it"):format(object))
end

function t1.formatters.parameter(p19, p20, p21) -- line: 89
    -- upvalues: nameOf (copy)
    local object = nameOf(p19, "object")
    local object2 = nameOf(p20, "object")

    if p21 == false then
        return ("The %* parameter"):format(object2), (("the %* that it was used for"):format(object))
    end

    return ("The %* representing the %* parameter"):format(object2, p21), (("the %* that it was used for"):format(object))
end

function t1.formatters.observer(p22, p23) -- line: 103
    -- upvalues: nameOf (copy)
    local object = nameOf(p22, "object")

    return ("The watched %*"):format((nameOf(p23, "object"))), (("the %* that's observing it for changes"):format(object))
end

function t1.bOutlivesA(p24, p25, p26, p27, p28, ...) -- line: 112
    -- upvalues: External (copy), whichLivesLonger (copy)
    if p26 ~= nil then
        if whichLivesLonger(p24, p25, p26, p27) == "definitely-a" then
            local v1, v2 = p28(p25, p27, ...)

            External.logWarn("possiblyOutlives", v1, v2, p24 == p26 and "they're in the same scope, but the latter is destroyed too quickly" or "the latter is in a different scope that gets destroyed too quickly")
        end
    else
        External.logError("useAfterDestroy", nil, p28(p25, p27, ...))
    end
end

return t1
