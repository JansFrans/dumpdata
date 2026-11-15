-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules

local function onlyHashesOrWhitespace(p1) -- line: 4
    return p1:match("^[#%s]*$") ~= nil
end

return function(p2, p3, p4) -- line: 12
    -- upvalues: Modules (copy)
    local Args = require(Modules.Parser.Args)
    local v1 = typeof(p2) == "table"
    local v2 = if v1 then typeof(p2.args) == "table" else nil
    local v3 = if not v1 or not v2 then {} else p2.args
    local v4 = Args.get(v3[1])
    local v5 = v4 ~= nil and v4.playerArg == true
    local v6

    for v7, v8 in v3 do
        local v9 = Args.get(v8)

        if v9 and typeof(v9.key) == "string" then
            local inputObject = v9.inputObject

            if typeof(inputObject) == "table" and inputObject.filterText == true then
                local v10 = p3[if v5 then v7 - 1 else v7]

                if typeof(v10) == "string" and v10 ~= "" then
                    local v11 = v9:parse(v10, p4, nil)
                    local v12

                    if typeof(v11) == "string" then
                        v12 = v11
                    elseif typeof(v11) == "table" then
                        local v13 = true

                        for _, v14 in v11 do
                            if typeof(v14) ~= "string" then
                                v13 = false
                                break
                            end
                        end

                        v12 = if v13 then table.concat(v11, " ") else nil
                    end

                    if v12 == nil or v12:match("^[#%s]*$") ~= nil and v10:match("^[#%s]*$") == nil then
                        local name = p2.name or p2.key

                        return nil, (("The text for '%*' was rejected by the filter, so nothing was saved"):format((tostring(name))))
                    end

                    v6 = v6 or {}
                    v6[tostring(v7)] = v11
                end
            end
        end
    end

    return v6, nil
end
