-- https://lua.expert

local Packages = script:FindFirstAncestor("MainModule").Value.Modules.Parent.Packages
local Fusion = require(Packages.Fusion)
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 11
    -- upvalues: t1 (copy)
    local t2 = {
        page = p1:Value("Menu"),
        pageHistory = p1:Value({ "Menu" }),
        prevPage = p1:Value(nil),
        navDirection = p1:Value(1)
    }

    t2.canGoBack = p1:Computed(function(p2) -- line: 18
        -- upvalues: t2 (copy)
        return #p2(t2.pageHistory) > 1
    end)
    setmetatable(t2, t1)

    return t2
end

function t1.toPage(p3, p4) -- line: 31
    -- upvalues: Fusion (copy)
    local v1 = Fusion.peek(p3.pageHistory)

    if v1[#v1] == p4 then
        return
    end

    local v2 = table.clone(v1)

    table.insert(v2, p4)
    p3.prevPage:set(Fusion.peek(p3.page))
    p3.navDirection:set(1)
    p3.pageHistory:set(v2)
    p3.page:set(p4)
    task.delay(0.6, function() -- line: 43
        -- upvalues: p3 (copy), p4 (copy), Fusion (copy)
        if Fusion.peek(p3.page) == p4 then
            p3.prevPage:set(nil)
        end
    end)
end

function t1.goBack(p5) -- line: 50
    -- upvalues: Fusion (copy)
    local v3 = Fusion.peek(p5.pageHistory)

    if #v3 <= 1 then
        return
    end

    local v4 = table.clone(v3)

    table.remove(v4, #v4)
    p5.prevPage:set(Fusion.peek(p5.page))
    p5.navDirection:set(-1)
    p5.pageHistory:set(v4)
    p5.page:set(v4[#v4])

    local v5 = v4[#v4]

    task.delay(0.6, function() -- line: 62
        -- upvalues: p5 (copy), v5 (copy), Fusion (copy)
        if Fusion.peek(p5.page) == v5 then
            p5.prevPage:set(nil)
        end
    end)
end

return t1
