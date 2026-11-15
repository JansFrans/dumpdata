-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local ParserSettings = require(Modules.Parser.ParserSettings)
local isValidPrefix = require(Modules.CommandUtil.isValidPrefix)
local SpaceSeparator, Collective = ParserSettings.SpaceSeparator, ParserSettings.Collective

return {
    scan = function(p1) -- scan | line: 36
        -- upvalues: isValidPrefix (copy), SpaceSeparator (copy)
        local t2 = {}
        local t3 = {
            hasPrefix = false,
            prefixChar = nil,
            commandText = nil,
            argCount = 0,
            tokens = t2
        }
        local v1 = #p1
        local n1 = 1

        while n1 <= v1 do
            if p1:sub(n1, n1) == SpaceSeparator then
                n1 += 1
            else
                local v2 = n1

                while v2 <= v1 and p1:sub(v2, v2) ~= SpaceSeparator do
                    v2 += 1
                end

                local v3 = v2 - 1
                local v4 = p1:sub(n1, v3)

                if t3.commandText ~= nil then
                    t3.argCount += 1
                    table.insert(t2, {
                        kind = "arg",
                        text = v4,
                        start = n1,
                        finish = v3,
                        argIndex = t3.argCount
                    })
                else
                    local v5 = v4:sub(1, 1)

                    if isValidPrefix(v5) then
                        t3.hasPrefix = true
                        t3.prefixChar = v5
                        table.insert(t2, {
                            kind = "prefix",
                            text = v5,
                            start = n1,
                            finish = n1
                        })

                        local v6 = v4:sub(2)

                        table.insert(t2, {
                            kind = "command",
                            text = v6,
                            start = n1 + 1,
                            finish = v3
                        })
                        t3.commandText = v6
                    else
                        table.insert(t2, {
                            kind = "command",
                            text = v4,
                            start = n1,
                            finish = v3
                        })
                        t3.commandText = v4
                    end
                end

                n1 = v2
            end
        end

        return t3
    end,
    listItems = function(p2, p3) -- listItems | line: 74
        -- upvalues: Collective (copy)
        local t8 = {}
        local v7 = #p2
        local n2 = 1

        while n2 <= v7 do
            local v8 = p2:find(Collective, n2, true)
            local v9 = if v8 then v8 - 1 else v7

            table.insert(t8, {
                text = p2:sub(n2, v9),
                start = p3 + n2 - 1,
                finish = p3 + v9 - 1
            })

            if v8 then
                n2 = v8 + 1
                continue
            end

            break
        end

        if v7 == 0 or p2:sub(v7, v7) == Collective then
            table.insert(t8, {
                text = "",
                start = p3 + v7,
                finish = p3 + v7 - 1
            })
        end

        return t8
    end
}
