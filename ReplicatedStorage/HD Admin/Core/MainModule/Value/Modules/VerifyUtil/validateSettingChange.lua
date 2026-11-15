-- https://lua.expert

local t1 = {}
local t2 = {
    ActionButton = true
}

local function pathsMatch(p1, p2) -- line: 25
    if #p1 ~= #p2 then
        return false
    end

    for v1, v2 in p1 do
        if p2[v1] ~= v2 then
            return false
        end
    end

    return true
end

function t1.findRowByPath(p3, p4) -- line: 35
    if typeof(p3) ~= "table" or typeof(p4) ~= "table" then
        return nil
    end

    for _, v3 in p3 do
        if typeof(v3) == "table" then
            local objects = v3.objects

            if typeof(objects) == "table" then
                for _, v4 in objects do
                    if typeof(v4) == "table" and typeof(v4.settingPath) == "table" then
                        local settingPath = v4.settingPath
                        local v5

                        if #settingPath == #p4 then
                            local v6 = false

                            for v7, v8 in settingPath do
                                if p4[v7] ~= v8 then
                                    v5 = false
                                    v6 = true
                                    break
                                end
                            end

                            if not v6 then
                                v5 = true
                            end
                        else
                            v5 = false
                        end

                        if v5 then
                            return v4
                        end
                    end
                end
            end
        end
    end

    return nil
end

function t1.findRowByHeadingTitle(p5, p6, p7) -- line: 51
    if typeof(p5) ~= "table" then
        return nil
    end

    for _, v9 in p5 do
        if typeof(v9) == "table" and v9.heading == p6 then
            local objects = v9.objects

            if typeof(objects) == "table" then
                for _, v10 in objects do
                    if typeof(v10) == "table" and v10.title == p7 then
                        return v10
                    end
                end
            end
        end
    end

    return nil
end

function t1.findRowByFieldName(p8, p9) -- line: 66
    if typeof(p8) ~= "table" then
        return nil
    end

    for _, v11 in p8 do
        if typeof(v11) == "table" then
            local objects = v11.objects

            if typeof(objects) == "table" then
                for _, v12 in objects do
                    if typeof(v12) == "table" and v12.title == p9 then
                        return v12
                    end
                end
            end
        end
    end

    return nil
end

function t1.run(p10, p11, p12) -- line: 83
    -- upvalues: t2 (copy)
    if p10 == nil then
        return false, "Unknown setting"
    end

    if typeof(p10) ~= "table" then
        return false, "Malformed setting row"
    end

    if p10.immutable == true then
        return false, (("Field '%*' is immutable"):format((tostring(p10.title))))
    end

    if t2[tostring(p10.inputType)] then
        return false, (("Field '%*' is not settable"):format((tostring(p10.title))))
    end

    local verifier = p10.verifier

    if typeof(verifier) == "function" then
        local v13 = p10.inputObject or p10
        local v14, v15, v16 = pcall(verifier, v13, p11, p12)

        if not v14 then
            return false, "Internal error during verification"
        end

        if v15 == true then
            if v16 == nil then
                return true, p11
            end

            return true, v16
        end

        if typeof(v16) == "string" then
            return false, v16
        end

        return false, (("Invalid value for '%*'"):format((tostring(p10.title))))
    end

    return false, (("No verifier defined for '%*'"):format((tostring(p10.title))))
end

return t1
