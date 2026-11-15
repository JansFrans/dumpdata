-- https://lua.expert

local HttpService = game:GetService("HttpService")

return function(p1) -- line: 2
    -- upvalues: HttpService (copy)
    local JSONEncode = HttpService.JSONEncode
    local ok, result = pcall(JSONEncode, HttpService, p1)

    if ok then
        return #result
    end

    return 1e999
end
