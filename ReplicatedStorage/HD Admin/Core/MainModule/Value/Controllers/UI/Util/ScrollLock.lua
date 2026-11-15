-- https://lua.expert

local Parent, ScrollingEnabled

return {
    lock = function(p1) -- lock | line: 6
        -- upvalues: Parent (ref), ScrollingEnabled (ref)
        if Parent or not p1 then
            return
        end

        local Parent2 = p1.Parent

        while true do
            if Parent2 then
                if Parent2:IsA("ScrollingFrame") then
                    break
                end

                Parent2 = Parent2.Parent
                continue
            end

            return
        end

        Parent = Parent2
        ScrollingEnabled = Parent2.ScrollingEnabled
        Parent2.ScrollingEnabled = false
    end,
    unlock = function() -- unlock | line: 21
        -- upvalues: Parent (ref), ScrollingEnabled (ref)
        local Parent2 = Parent
        local ScrollingEnabled2 = ScrollingEnabled

        Parent = nil
        ScrollingEnabled = nil

        if Parent2 and Parent2.Parent then
            if ScrollingEnabled2 ~= nil then
                Parent2.ScrollingEnabled = ScrollingEnabled2
            else
                Parent2.ScrollingEnabled = true
            end
        end
    end
}
