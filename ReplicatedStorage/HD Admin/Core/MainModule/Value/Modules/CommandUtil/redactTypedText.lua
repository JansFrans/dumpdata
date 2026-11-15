-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")

return {
    taskArgs = function(p1, p2, p3) -- redactTaskArgs | line: 9
        -- upvalues: Modules (copy)
        local Args, v1, v2

        if typeof(p2) == "table" and typeof(p1) == "table" then
            if typeof(p1.args) == "table" then
                Args = require(Modules.Parser.Args)

                local v3 = Args.get(p1.args[1])

                v1 = v3 ~= nil and v3.playerArg == true
                v2 = false
            else
                v2 = true
            end
        else
            v2 = true
        end

        if v2 then
            return p2, nil
        end

        local v4 = table.clone(p2)
        local v5 = table.clone(p2)

        for v6, v7 in p1.args do
            local v8 = Args.get(v7)
            local inputObject = if v8 then v8.inputObject else nil

            if typeof(inputObject) == "table" and inputObject.filterText == true then
                local v9 = if v1 then v6 - 1 else v6
                local v10 = v4[v9]

                if typeof(v10) == "string" and v10:match("^%s*$") == nil then
                    v4[v9] = "…"

                    local v11 = if typeof(p3) == "table" then p3[tostring(v6)] else nil

                    if typeof(v11) == "table" then
                        local t1 = {}

                        for _, v12 in v11 do
                            table.insert(t1, (tostring(v12)))
                        end

                        v11 = table.concat(t1, ", ")
                    end

                    if typeof(v11) ~= "string" then
                        v11 = "…"
                    end

                    v5[v9] = v11
                end
            end
        end

        if typeof(p3) == "table" then
            return v4, v5
        end

        return v4, nil
    end,
    group = function(p4, p5) -- redactGroup | line: 45
        -- upvalues: Modules (copy), Players (copy), Teams (copy)
        if typeof(p4) ~= "table" then
            return p4
        end

        local Qualifiers = require(Modules.Parser.Qualifiers)

        local function isKnownName(p6) -- line: 50
            -- upvalues: p5 (copy), Qualifiers (copy), Players (copy), Teams (copy)
            local v14 = p6:lower()

            if not p5 and Qualifiers.get(p6) then
                return true
            end

            for _, player in Players:GetPlayers() do
                if player.Name:lower() == v14 or player.DisplayName:lower() == v14 then
                    return true
                end
            end

            for _, v15 in Teams:GetTeams() do
                if v15.Name:lower() == v14 then
                    return true
                end
            end

            return false
        end

        local t2 = {}

        for v16, v17 in p4 do
            local v18 = if p5 or isKnownName((tostring(v16))) then v16 else "…"
            local v19 = v17

            if typeof(v17) == "table" then
                v19 = {}

                for _, v20 in v17 do
                    local v21 = tostring(v20)

                    table.insert(v19, if tonumber(v21) ~= nil or not p5 and isKnownName(v21) then v20 else "…")
                end
            end

            t2[v18] = v19
        end

        return t2
    end
}
