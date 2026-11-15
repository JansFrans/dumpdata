-- https://lua.expert

local v1, result

return {
    Get = function() -- Get | line: 4
        -- upvalues: v1 (ref), result (ref)
        if result then
            return result
        end

        local function v2() -- line: 6
            -- upvalues: v1 (ref)
            v1 = game:GetService("AssetService"):CreateEditableImage({
                Size = Vector2.new(337, 234)
            })

            local v3 = buffer.create(315432)
            local t2 = {}

            for i = 1, 64 do
                t2[("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):byte(i)] = i
            end

            local n1 = 0

            for match in ("0T1o2o3o4o5o6n7o8K7A6A4A2A0P|0T1o2o3o4o5o6n7o8P5A2A0M|0T1o2o3o4o5o6n7o8R6A2A0K|0T1o2o3o4o5o6n7o8T6A1A0I|0T1o2o3o4o5o6n7o8V3A0H|0T1o2o3o4o5o6n7o8W4A0G|0T1o2o3o4o5o6n7o8X5A0F|0T1o2o3o4o5o6n7o8Y4A0E|0T1o2o3o4o5o6n7o8Z3A0D|0T1o2o3o4o5o6n7o8a1A0C|0T1o2o3o4o5o6n7o8a6A0C|0T1o2o3o4o5o6n7o8b3A0B|0T1o2o3o4o5o6n7o8b7A0B|0T1o2o3o4o5o6n7o8c3A0A|0T1o2o3o4o5o6n7o8c6A0A|0T1o2o3o4o5o6n7o8d1A|0T1o2o3o4o5o6n7o8d2A|0T1o2o3o4o5o6n7o8d3A|0T1o2o3o4o5o6n7o8d5A|0T1o2o3o4o5o6n7o8d6A|0T1o2o3o4o5o6n7o8d6A|0T1o2o3o4o5o6n7o8d6A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d7A|0T1o2o3o4o5o6n7o8d6A|0T1o2o3o4o5o6n7o8d6A|0T1o2o3o4o5o6n7o8d6A|0T1o2o3o4o5o6n7o8d4A|0T1o2o3o4o5o6n7o8d3A|0T1o2o3o4o5o6n7o8d2A|0T1o2o3o4o5o6n7o8d0A|0T1o2o3o4o5o6n7o8c5A0A|0T1o2o3o4o5o6n7o8c2A0A|0T1o2o3o4o5o6n7o8b6A0B|0T1o2o3o4o5o6n7o8b2A0B|0T1o2o3o4o5o6n7o8a6A0C|0T1o2o3o4o5o6n7o8a1A0C|0T1o2o3o4o5o6n7o8Z3A0D|0T1o2o3o4o5o6n7o8Y4A0E|0T1o2o3o4o5o6n7o8X4A0F|0T1o2o3o4o5o6n7o8W3A0G|0T1o2o3o4o5o6n7o8U7A1A0H|0T1o2o3o4o5o6n7o8T5A0J|0T1o2o3o4o5o6n7o8R5A2A0K|0T1o2o3o4o5o6n7o8O6A3A1A0M|071/1z2/203Y2B1A0P|0/0/0/0/0/0Q|0/0/0/0/0/0Q"):gmatch("[^|]+") do
                local v4 = #match - 1
                local n2 = 0

                for j = 1, v4, 2 do
                    local v6 = tonumber(match:sub(j, j), 16) * 17

                    for _ = 1, t2[match:byte(j + 1)] do
                        buffer.writeu8(v3, (n1 * 337 + n2) * 4 + 3, v6)
                        n2 += 1
                    end
                end

                n1 += 1
            end

            v1:WritePixelsBuffer(Vector2.zero, Vector2.new(337, 234), v3)

            return Content.fromObject(v1)
        end

        local ok, result2 = pcall(v2)

        if ok then
            result = result2
        end

        return result
    end
}
