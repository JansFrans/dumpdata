-- https://lua.expert

require(script.Parent.Parent.Types)

local function equalObjects(...) -- line: 20
    local v1 = select(1, ...)

    for i = 2, select("#", ...) do
        if v1 ~= select(i, ...) then
            return false
        end
    end

    return true
end

return equalObjects
