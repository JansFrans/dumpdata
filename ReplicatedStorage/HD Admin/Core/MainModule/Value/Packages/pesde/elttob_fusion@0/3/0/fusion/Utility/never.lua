-- https://lua.expert

local function never() -- line: 10
    error("This codepath should not be reachable")
end

return never
