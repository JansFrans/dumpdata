-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local defaultRole = require(Modules.References.defaultRole)
local t1 = {
    ["true"] = true,
    ["false"] = true,
    ["return"] = true,
    ["nil"] = true
}
local t2 = {
    ["{"] = true,
    ["}"] = true,
    ["("] = true,
    [")"] = true,
    [","] = true,
    ["="] = true,
    ["."] = true
}

local function tokenize(p1) -- line: 30
    -- upvalues: t1 (copy), t2 (copy)
    local t3 = {}
    local v1 = #p1
    local n1 = 1

    while true do
        if not (n1 <= v1) then
            return true, t3
        end

        local v2 = p1:sub(n1, n1)

        if v2 == " " or v2 == "\t" or v2 == "\n" then
            n1 += 1
        else
            if v2 == "\r" then
                n1 += 1
                continue
            end

            if v2 == "-" and p1:sub(n1 + 1, n1 + 1) == "-" then
                while n1 <= v1 and p1:sub(n1, n1) ~= "\n" do
                    n1 += 1
                end

                continue
            end

            if t2[v2] then
                table.insert(t3, {
                    type = "punct",
                    value = v2,
                    pos = n1
                })
                n1 += 1
                continue
            end

            if v2 == "\"" or v2 == "'" then
                local t5 = {}
                local v3 = n1 + 1

                while true do
                    if v3 <= v1 then
                        local v4 = p1:sub(v3, v3)

                        if v4 == "\\" then
                            local v5 = p1:sub(v3 + 1, v3 + 1)

                            if v5 == "n" then
                                table.insert(t5, "\n")
                            elseif v5 == "t" then
                                table.insert(t5, "\t")
                            elseif v5 == "r" then
                                table.insert(t5, "\r")
                            elseif v5 == "\\" then
                                table.insert(t5, "\\")
                            elseif v5 == v2 then
                                table.insert(t5, v2)
                            elseif v5 == "0" then
                                table.insert(t5, "\000")
                            else
                                table.insert(t5, v5)
                            end

                            v3 += 2
                        else
                            if v4 == v2 then
                                local v6 = v3 + 1

                                table.insert(t3, {
                                    type = "string",
                                    value = table.concat(t5),
                                    pos = n1
                                })
                                n1 = v6
                                break
                            end

                            if v4 == "\n" then
                                return false, (("Unterminated string at position %*"):format(n1))
                            end

                            table.insert(t5, v4)
                            v3 += 1
                        end

                        continue
                    end

                    n1 = v3
                    break
                end
            elseif v2:match("[%-%d]") and (v2 ~= "-" or p1:sub(n1 + 1, n1 + 1):match("%d")) then
                local v7 = if v2 == "-" then n1 + 1 else n1

                while v7 <= v1 and p1:sub(v7, v7):match("[%d%.]") do
                    v7 += 1
                end

                local v8 = p1:sub(n1, v7 - 1)
                local v9 = tonumber(v8)

                if not v9 then
                    return false, (("Invalid number '%*' at position %*"):format(v8, n1))
                end

                local t7 = {
                    type = "number",
                    value = v9,
                    pos = n1
                }

                n1 = v7
                table.insert(t3, t7)
            else
                if not v2:match("[%a_]") then
                    return false, (("Unexpected character '%*' at position %*"):format(v2, n1))
                end

                local v10 = n1

                while v10 <= v1 and p1:sub(v10, v10):match("[%w_]") do
                    v10 += 1
                end

                local v11 = p1:sub(n1, v10 - 1)

                if t1[v11] then
                    table.insert(t3, {
                        type = "keyword",
                        value = v11,
                        pos = n1
                    })
                else
                    table.insert(t3, {
                        type = "ident",
                        value = v11,
                        pos = n1
                    })
                end

                n1 = v10
            end
        end
    end
end

local v12

local function peek(p2) -- line: 104
    return p2.tokens[p2.index]
end

local function consume(p3) -- line: 107
    local v13 = p3.tokens[p3.index]

    p3.index += 1

    return v13
end

local function expect(p4, p5, p6) -- line: 112
    local v14 = p4.tokens[p4.index]

    if v14 then
        if v14.type == p5 then
            if p6 == nil or v14.value == p6 then
                p4.index += 1

                return true, v14
            end

            return false, (("Expected '%*' at position %*, got '%*'"):format(p6, v14.pos, (tostring(v14.value))))
        end

        return false, (("Expected %* at position %*, got %* '%*'"):format(p5, v14.pos, v14.type, (tostring(v14.value))))
    end

    return false, (("Unexpected end of input (expected %*%*)"):format(p5, if p6 == nil then "" else (" '%*'"):format(p6)))
end

local v15

v15 = function(p7) -- line: 125
    -- upvalues: v15 (ref), v12 (ref)
    local v16 = p7.tokens[p7.index]

    if not v16 then
        return false, "Unexpected end of input while parsing value"
    end

    if v16.type == "keyword" then
        if v16.value == "true" then
            p7.index += 1

            return true, true
        end

        if v16.value == "false" then
            p7.index += 1

            return true, false
        end

        if v16.value ~= "nil" then
            return false, (("Unexpected keyword '%*' at position %*"):format(v16.value, v16.pos))
        end

        p7.index += 1

        return true, nil
    end

    if v16.type == "number" or v16.type == "string" then
        p7.index += 1

        return true, v16.value
    end

    if v16.type == "ident" and v16.value == "Color3" then
        p7.index += 1

        local v17 = p7.tokens[p7.index]
        local v18

        if v17 then
            if v17.type == "punct" then
                if v17.value == "." then
                    p7.index += 1
                    v18 = true
                else
                    v18 = false
                    v17 = ("Expected '.' at position %*, got '%*'"):format(v17.pos, (tostring(v17.value)))
                end
            else
                v18 = false
                v17 = ("Expected punct at position %*, got %* '%*'"):format(v17.pos, v17.type, (tostring(v17.value)))
            end
        else
            v18 = false
            v17 = "Unexpected end of input (expected punct '.')"
        end

        if not v18 then
            return false, v17
        end

        local v19 = p7.tokens[p7.index]

        if v19 and v19.type == "ident" and v19.value == "fromRGB" then
            p7.index += 1

            local v20 = p7.tokens[p7.index]
            local v21

            if v20 then
                if v20.type == "punct" then
                    if v20.value == "(" then
                        p7.index += 1
                        v21 = true
                    else
                        v21 = false
                        v20 = ("Expected '(' at position %*, got '%*'"):format(v20.pos, (tostring(v20.value)))
                    end
                else
                    v21 = false
                    v20 = ("Expected punct at position %*, got %* '%*'"):format(v20.pos, v20.type, (tostring(v20.value)))
                end
            else
                v21 = false
                v20 = "Unexpected end of input (expected punct '(')"
            end

            if not v21 then
                return false, v20
            end

            local v22, v23 = v15(p7)

            if not v22 then
                return false, v23
            end

            local v24 = p7.tokens[p7.index]
            local v25

            if v24 then
                if v24.type == "punct" then
                    if v24.value == "," then
                        p7.index += 1
                        v25 = true
                    else
                        v25 = false
                        v24 = ("Expected ',' at position %*, got '%*'"):format(v24.pos, (tostring(v24.value)))
                    end
                else
                    v25 = false
                    v24 = ("Expected punct at position %*, got %* '%*'"):format(v24.pos, v24.type, (tostring(v24.value)))
                end
            else
                v25 = false
                v24 = "Unexpected end of input (expected punct ',')"
            end

            if not v25 then
                return false, v24
            end

            local v26, v27 = v15(p7)

            if not v26 then
                return false, v27
            end

            local v28 = p7.tokens[p7.index]
            local v29

            if v28 then
                if v28.type == "punct" then
                    if v28.value == "," then
                        p7.index += 1
                        v29 = true
                    else
                        v29 = false
                        v28 = ("Expected ',' at position %*, got '%*'"):format(v28.pos, (tostring(v28.value)))
                    end
                else
                    v29 = false
                    v28 = ("Expected punct at position %*, got %* '%*'"):format(v28.pos, v28.type, (tostring(v28.value)))
                end
            else
                v29 = false
                v28 = "Unexpected end of input (expected punct ',')"
            end

            if not v29 then
                return false, v28
            end

            local v30, v31 = v15(p7)

            if not v30 then
                return false, v31
            end

            local v32 = p7.tokens[p7.index]
            local v33

            if v32 then
                if v32.type == "punct" then
                    if v32.value == ")" then
                        p7.index += 1
                        v33 = true
                    else
                        v33 = false
                        v32 = ("Expected ')' at position %*, got '%*'"):format(v32.pos, (tostring(v32.value)))
                    end
                else
                    v33 = false
                    v32 = ("Expected punct at position %*, got %* '%*'"):format(v32.pos, v32.type, (tostring(v32.value)))
                end
            else
                v33 = false
                v32 = "Unexpected end of input (expected punct ')')"
            end

            if not v33 then
                return false, v32
            end

            if typeof(v23) == "number" and typeof(v27) == "number" and typeof(v31) == "number" then
                return true, Color3.fromRGB(v23, v27, v31)
            end

            return false, "Color3.fromRGB arguments must be numbers"
        end

        return false, (("Expected 'fromRGB' after 'Color3.' at position %*"):format(if v19 then v19.pos else 0))
    end

    if v16.type == "punct" and v16.value == "{" then
        return v12(p7)
    end

    return false, (("Unexpected token '%*' at position %*"):format(tostring(v16.value), v16.pos))
end

v12 = function(p8) -- line: 162
    -- upvalues: v15 (ref)
    local v34 = p8.tokens[p8.index]
    local v35

    if v34 then
        if v34.type == "punct" then
            if v34.value == "{" then
                p8.index += 1
                v35 = true
            else
                v35 = false
                v34 = ("Expected '{' at position %*, got '%*'"):format(v34.pos, (tostring(v34.value)))
            end
        else
            v35 = false
            v34 = ("Expected punct at position %*, got %* '%*'"):format(v34.pos, v34.type, (tostring(v34.value)))
        end
    else
        v35 = false
        v34 = "Unexpected end of input (expected punct '{')"
    end

    if not v35 then
        return false, v34
    end

    local t10 = {}
    local v36 = p8.tokens[p8.index]

    if v36 and v36.type == "punct" and v36.value == "}" then
        p8.index += 1

        return true, t10
    end

    local v37 = true
    local n2 = 1

    while true do
        local v38 = p8.tokens[p8.index]

        if v38 then
            local v40, v41, v42, v43, v44

            if v38.type == "ident" and p8.tokens[p8.index + 1] and p8.tokens[p8.index + 1].type == "punct" then
                if p8.tokens[p8.index + 1].value == "=" then
                    local value = v38.value

                    p8.index += 2

                    local v45, v46 = v15(p8)

                    if not v45 then
                        return false, v46
                    end

                    v37 = false
                    t10[value] = v46
                else
                    if not v37 then
                        return false, (("Mixed array/dict syntax at position %*"):format(v38.pos))
                    end

                    v40, v41 = v15(p8)

                    if not v40 then
                        return false, v41
                    end

                    t10[n2] = v41
                    n2 += 1
                end

                v42 = p8.tokens[p8.index]

                if not v42 then
                    return false, "Unexpected end of input inside table"
                end

                local v47 = v42.type == "punct"

                if v47 then
                    v43 = v42.value == ","
                end

                if not v47 or not v43 then
                    if v42.type ~= "punct" or v42.value ~= "}" then
                        return false, (("Expected ',' or '}' at position %*"):format(v42.pos))
                    end

                    p8.index += 1

                    return true, t10
                end

                p8.index += 1
                v44 = p8.tokens[p8.index]

                if v44 and v44.type == "punct" and v44.value == "}" then
                    p8.index += 1

                    return true, t10
                end

                continue
            end

            if not v37 then
                return false, (("Mixed array/dict syntax at position %*"):format(v38.pos))
            end

            v40, v41 = v15(p8)

            if not v40 then
                return false, v41
            end

            t10[n2] = v41
            n2 += 1
            v42 = p8.tokens[p8.index]

            if not v42 then
                return false, "Unexpected end of input inside table"
            end

            if v42.type == "punct" then
                v43 = v42.value == ","

                if v43 then
                    p8.index += 1
                    v44 = p8.tokens[p8.index]

                    if v44 and v44.type == "punct" and v44.value == "}" then
                        p8.index += 1

                        return true, t10
                    end

                    continue
                end
            end

            if v42.type ~= "punct" or v42.value ~= "}" then
                return false, (("Expected ',' or '}' at position %*"):format(v42.pos))
            end

            p8.index += 1

            return true, t10
        end

        break
    end

    return false, "Unexpected end of input inside table"
end

return function(p9) -- line: 212
    -- upvalues: defaultRole (copy), tokenize (copy), v12 (ref)
    local v48, v49 = tokenize(p9)

    if not v48 then
        return false, v49
    end

    local t11 = {
        index = 1,
        tokens = v49
    }
    local v50 = t11.tokens[t11.index]

    if v50 and v50.type == "keyword" and v50.value == "return" then
        t11.index += 1
    end

    local v51, v52 = v12(t11)

    if not v51 then
        return false, v52
    end

    local v53 = t11.tokens[t11.index]

    if v53 then
        return false, (("Unexpected token '%*' after top-level table at position %*"):format(tostring(v53.value), v53.pos))
    end

    local t12 = {}
    local n3 = 0

    for v54, v55 in v52 do
        if typeof(v54) == "string" and v54 ~= "key" and v54 ~= "rank" and v54 ~= "useDefaults" and (defaultRole[v54] ~= nil or v54 == "name") then
            t12[v54] = v55
            n3 += 1
        end
    end

    return true, t12, n3
end
