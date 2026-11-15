-- https://lua.expert

local HttpService = game:GetService("HttpService")
local Future = require(script.Parent.Future)

local function Json(p1) -- line: 22
    -- upvalues: HttpService (copy)
    local JSONDecode = HttpService.JSONDecode
    local Body = p1.Body

    return pcall(JSONDecode, HttpService, Body)
end

return function(p2, p3) -- line: 26
    -- upvalues: HttpService (copy), Future (copy), Json (copy)
    p3 = p3 or {}

    local v2 = if type(p3.Body) == "table" then HttpService:JSONEncode(p3.Body) else p3.Body

    return Future.Try(function(p4, p5) -- line: 32
        -- upvalues: p2 (copy), HttpService (copy), Json (copy)
        local v3 = HttpService:RequestAsync({
            Url = p2,
            Method = p4.Method or "GET",
            Headers = p4.Headers or {},
            Body = p5
        })

        return {
            Body = v3.Body,
            Headers = v3.Headers,
            Status = v3.StatusCode,
            StatusText = v3.StatusMessage,
            Ok = v3.Success,
            Url = p2,
            Json = Json
        }
    end, p3, v2)
end
