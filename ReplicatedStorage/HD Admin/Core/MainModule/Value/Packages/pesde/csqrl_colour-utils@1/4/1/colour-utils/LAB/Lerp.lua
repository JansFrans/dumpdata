-- https://lua.expert

local FromLAB = require(script.Parent.FromLAB)
local ToLAB = require(script.Parent.ToLAB)

local function lerp(p1, p2, p3) -- line: 16
    -- upvalues: FromLAB (copy), ToLAB (copy)
    assert(typeof(p1) == "Color3", (("Lerp(...): Expected \"from\" to be a Color3, got %*"):format((typeof(p1)))))
    assert(typeof(p2) == "Color3", (("Lerp(...): Expected \"to\" to be a Color3, got %*"):format((typeof(p2)))))
    assert(typeof(p3) == "number", (("Lerp(...): Expected \"alpha\" to be a number, got %*"):format((typeof(p3)))))

    local v7 = ToLAB(p1)
    local v8 = ToLAB(p2)

    return FromLAB({
        L = v7.L * (1 - p3) + v8.L * p3,
        A = v7.A * (1 - p3) + v8.A * p3,
        B = v7.B * (1 - p3) + v8.B * p3
    })
end

return lerp
