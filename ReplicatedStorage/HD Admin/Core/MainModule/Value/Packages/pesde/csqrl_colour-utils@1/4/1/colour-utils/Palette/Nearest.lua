-- https://lua.expert

local function nearest(p1, p2) -- line: 12
    assert(typeof(p1) == "Color3", (("Nearest(...): Expected \"to\" to be a Color3, got \"%*\" (%*)"):format(p1, (typeof(p1)))))

    local n1 = 1e999
    local v4 = false
    local v3

    for v5, v6 in p2 do
        if typeof(v6) == "Color3" then
            local v8 = math.sqrt((v6.R - p1.R) ^ 2 + (v6.G - p1.G) ^ 2 + (v6.B - p1.B) ^ 2)

            if v8 < n1 then
                v3 = v6
                n1 = v8
            end
        elseif v4 == false then
            v4 = true
            warn((("Nearest(...): Expected \"colors\" to be an array of Color3, got \"%*\" (%*) at index #%*"):format(v6, typeof(v6), v5)))
        end
    end

    return v3
end

return nearest
