-- https://lua.expert

local Value = script:FindFirstAncestor("MainModule").Value
local Modules, Services = Value.Modules, Value.Services
local Parser = Modules.Parser

require(Parser.ParserTypes)
require(Modules.Objects.Task)

return function(p1, p2, p3) -- line: 16
    -- upvalues: Modules (copy), Services (copy), Parser (copy)
    local Commands = require(Services.Commands)
    local Args = require(Parser.Args)

    for v1, v2 in p2.commands do
        local v3 = Commands.getCommand(v1)

        if v3 and typeof(v3.args) == "table" then
            local v4 = require(Modules.CommandUtil.getEffectiveModifiers)(v3, p2.modifiers or {})
            local v5
            local v6 = v3.args[1]
            local v7 = Args.get(v6)
            local v8 = if v7 then v7.playerArg == true and v7.runForEachPlayer else false

            if v4.perm and v4.join then
                v5 = "joinPlayers"
                v8 = false
            elseif v4.perm then
                if v4.spawn and v8 then
                    v5 = "permPinned"
                    v8 = true
                else
                    v5 = "joinServer"
                    v8 = false
                end
            elseif v4.join then
                v8 = false
            end

            local v9 = v2 or {}

            if not p2.qualifiers then
            end

            local function newPotentialTask(p4) -- line: 62
                -- upvalues: p3 (copy), v3 (copy), v5 (ref), v9 (copy)
                return p3(v3, v9, p4, v5)
            end

            if v8 then
                local v10 = if v7 then v7:parse(p2.qualifiers, p1, {
                    prompt = require(Modules.CommandUtil.isPromptCommand)(v3),
                    commandKey = v3.key
                }) else {}

                for _, v11 in v10 do
                    if p3(v3, v9, v11.UserId, v5) == false then
                        break
                    end
                end
            else
                p3(v3, v9, nil, v5)
            end
        end
    end
end
