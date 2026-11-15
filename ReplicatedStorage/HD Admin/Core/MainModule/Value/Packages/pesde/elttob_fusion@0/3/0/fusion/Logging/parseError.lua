-- https://lua.expert

require(script.Parent.Parent.Types)

local function parseError(p1) -- line: 14
    return {
        type = "Error",
        raw = p1,
        message = p1:gsub("^.+:%d+:%s*", ""),
        trace = debug.traceback(nil, 2)
    }
end

return parseError
