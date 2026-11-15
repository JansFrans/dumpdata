-- https://lua.expert

local UI = script:FindFirstAncestor("MainModule").Value.Modules.Parent.Controllers.UI
local Segmenter = require(UI.Util.Cmdbar.Segmenter)
local t1 = {}

local function caretInSpan(p1, p2, p3) -- line: 24
    if p2 <= p1 then
        return p1 <= p3 + 1
    end

    return false
end

function t1.resolve(p4, p5, p6) -- line: 30
    -- upvalues: Segmenter (copy)
    local v1 = if p5 < 1 then #p6 + 1 else math.clamp(p5, 1, #p6 + 1)

    if p4.commandText == nil then
        return {
            kind = "command",
            query = "",
            replaceStart = v1,
            replaceFinish = v1 - 1
        }
    end

    for _, v3 in p4.tokens do
        if v3.kind == "command" then
            local start, finish = v3.start, v3.finish

            if start <= v1 and v1 <= finish + 1 then
                local v4 = v3.text:find("(", 1, true)

                if v4 then
                    local v5 = v3.start + v4 - 1

                    if v5 < v1 then
                        local v6 = v3.text:find(")", v4 + 1, true)
                        local v7 = if v6 then v3.start + v6 - 2 else v3.finish
                        local v8 = p6:sub(v5 + 1, (math.max(v7, v5)))
                        local n1 = 1
                        local v9

                        for v10, v11 in Segmenter.listItems(v8, v5 + 1) do
                            local start, finish = v11.start, v11.finish

                            if start <= v1 and v1 <= finish + 1 then
                                v9 = v11
                                n1 = v10
                                break
                            end

                            v9 = nil
                            n1 = 1
                        end

                        local v12 = v9 or {
                            text = v8,
                            start = v5 + 1,
                            finish = math.max(v7, v5)
                        }
                        local t2 = {
                            kind = "capsuleArg",
                            argIndex = n1
                        }
                        local start = v12.start
                        local v13 = v1 - 1

                        t2.query = if v13 < start then "" else p6:sub(start, v13)
                        t2.replaceStart = v12.start
                        t2.replaceFinish = v12.finish

                        return t2
                    end

                    local t3 = {
                        kind = "command"
                    }
                    local start = v3.start
                    local v14 = v1 - 1

                    t3.query = if v14 < start then "" else p6:sub(start, v14)
                    t3.replaceStart = v3.start
                    t3.replaceFinish = v5 - 1

                    return t3
                end

                local t4 = {
                    kind = "command"
                }
                local start = v3.start
                local v15 = v1 - 1

                t4.query = if v15 < start then "" else p6:sub(start, v15)
                t4.replaceStart = v3.start
                t4.replaceFinish = math.max(v3.finish, v3.start - 1)

                return t4
            end
        end
    end

    for _, v17 in p4.tokens do
        if v17.kind == "arg" then
            local start, finish = v17.start, v17.finish

            if start <= v1 and v1 <= finish + 1 then
                local v18

                for _, v19 in Segmenter.listItems(v17.text, v17.start) do
                    local start, finish = v19.start, v19.finish

                    if start <= v1 and v1 <= finish + 1 then
                        v18 = v19
                        break
                    end

                    v18 = nil
                end

                local v20 = v18 or {
                    text = v17.text,
                    start = v17.start,
                    finish = v17.finish
                }
                local t5 = {
                    kind = "arg",
                    argIndex = v17.argIndex
                }
                local start = v20.start
                local v21 = v1 - 1

                t5.query = if v21 < start then "" else p6:sub(start, v21)
                t5.replaceStart = v20.start
                t5.replaceFinish = v20.finish

                return t5
            end
        end
    end

    return {
        kind = "arg",
        query = "",
        argIndex = p4.argCount + 1,
        replaceStart = v1,
        replaceFinish = v1 - 1
    }
end

function t1.apply(p7, p8, p9, p10, p11) -- line: 125
    local v22 = p10 ~= false

    p11 = p11 or 0

    local v24 = p7:sub(1, p8.replaceStart - 1)
    local v25 = p7:sub(p8.replaceFinish + 1)
    local v26 = if v22 and v25:sub(1, 1) ~= " " then " " else ""

    return v24 .. p9 .. v26 .. v25, #v24 + #p9 + #v26 + 1 - p11
end

return t1
