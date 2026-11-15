-- https://lua.expert

local t1 = {
    perm = true,
    permloop = true,
    permdelay = true,
    permschedule = true
}
local t2 = {
    global = true,
    perm = true,
    join = true,
    permjoin = true,
    permspawn = true,
    permschedule = true,
    permloop = true,
    permdelay = true
}
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Permissions = require(script.Parent.Parent.Permissions)
local t3 = {}
local result, result2, v1
local t4 = {}
local t5 = {
    firstPlayerArg = function(p1) -- firstPlayerArg | line: 42
        -- upvalues: result2 (ref)
        local v2 = p1[1]
        local v3 = v2 ~= nil and result2 and result2.get(v2)

        if v3 and v3.playerArg and v3.runForEachPlayer then
            return { v2 }
        end

        return {}
    end
}

local function safeRequire(p2) -- line: 54
    local _require = require
    local ok, result = pcall(_require, p2)

    if not ok or not result then
        result = nil
    end

    return result
end

local function ensureLoaded() -- line: 59
    -- upvalues: Modules (copy), result (ref), result2 (ref), v1 (ref), t4 (copy)
    if v1 then
        return
    end

    local Modifiers = Modules.Parser.Modifiers
    local _require = require
    local ok, result3 = pcall(_require, Modifiers)

    if not ok or not result3 then
        result3 = nil
    end

    result = result3

    local Args = Modules.Parser.Args
    local _require2 = require
    local ok2, result4 = pcall(_require2, Args)

    if not ok2 or not result4 then
        result4 = nil
    end

    result2 = result4
    v1 = {}

    if result then
        v1 = result.getSortedNameAndAliasLengthArray()

        for _, v4 in v1 do
            local v5 = result.get(v4)

            if v5 and typeof(v5.description) == "string" then
                t4[v4:lower()] = v5.description
            end
        end
    end
end

local function shortDescription(p3) -- line: 79
    if typeof(p3) ~= "string" or p3 == "" then
        return nil
    end

    local v6 = p3:match("^(.-)%. ") or p3

    if #v6 > 60 then
        return v6:sub(1, 57) .. "..."
    end

    return v6
end

local function stripCapsule(p4) -- line: 90
    local v7 = p4:sub(1, 1) == "("
    local v8 = if v7 then p4:find(")", 1, true) else nil

    if not v7 or not v8 then
        return p4
    end

    return p4:sub(v8 + 1)
end

function t3.runsForEachPlayer(p5) -- line: 102
    -- upvalues: result2 (ref), ensureLoaded (copy)
    ensureLoaded()

    local v9 = typeof(p5) == "table"
    local v10 = if v9 then typeof(p5.args) == "table" else nil
    local v11 = if not v9 or not v10 then {} else p5.args
    local v12 = result2 and result2.get(v11[1])

    if v12 ~= nil and v12.playerArg == true then
        return v12.runForEachPlayer == true
    end

    return false
end

function t3.isRejectedOn(p6, p7) -- line: 108
    -- upvalues: t1 (copy), t2 (copy), t3 (copy)
    local v13 = tostring(p6):lower()

    if typeof(p7) == "table" and (p7.disableModifiers == true or p7.disableGlobalModifiers == true and t2[v13]) then
        return true
    end

    if t1[v13] then
        return t3.runsForEachPlayer(p7)
    end

    return false
end

function t3.resolve(p8, p9) -- line: 125
    -- upvalues: v1 (ref), ensureLoaded (copy)
    ensureLoaded()

    local v14 = v1
    local t6 = {}
    local v15 = p8:lower()

    local function lookup(p10) -- line: 131
        -- upvalues: p9 (copy)
        local v16 = p9[p10]

        if v16 then
            return v16
        end

        return p9[p10:gsub("%b()", ""):gsub("%(.*$", "")]
    end

    while not p9[v15] and not p9[v15:gsub("%b()", ""):gsub("%(.*$", "")] do
        local v18 = false

        for _, v19 in v14 do
            local v20 = v19:lower()

            if #v15 > #v20 and v15:sub(1, #v20) == v20 then
                table.insert(t6, v20)
                v15 = v15:sub(#v20 + 1)

                if v15:sub(1, 1) == "(" then
                    local v21 = v15:find(")", 1, true)

                    if v21 then
                        v15 = v15:sub(v21 + 1)
                    end
                end

                v18 = true
                break
            end
        end

        if not v18 then
            return nil, t6
        end
    end

    return p9[v15] or p9[v15:gsub("%b()", ""):gsub("%(.*$", "")], t6
end

local function isCapsuleArg(p11) -- line: 157
    -- upvalues: result2 (ref)
    local v22 = result2 and result2.get(p11)

    if v22 ~= nil and v22.hidden == true then
        return not v22.playerArg
    end

    return false
end

function t3.effectiveArgs(p12, p13) -- line: 162
    -- upvalues: result (ref), result2 (ref), t5 (copy), ensureLoaded (copy)
    ensureLoaded()

    local v23 = typeof(p12) == "table"
    local v24 = if v23 then typeof(p12.args) == "table" else nil
    local v25 = if not v23 or not v24 then {} else p12.args

    if result then
        for _, v26 in p13 do
            local v27 = result.get(v26)
            local v28 = v27 and v27.affectsArgs
            local v29 = if typeof(v28) == "string" then t5[v28] else nil

            if v29 then
                v25 = v29(v25)
                break
            end
        end
    end

    local t7 = {}

    for _, v30 in v25 do
        local v31 = result2 and result2.get(v30)

        if v31 == nil or v31.hidden ~= true or v31.playerArg then
            table.insert(t7, v30)
        end
    end

    return t7
end

function t3.capsuleArgs(p14) -- line: 187
    -- upvalues: result2 (ref), ensureLoaded (copy)
    ensureLoaded()

    local t8 = {}
    local v32 = typeof(p14) == "table"
    local v33 = if v32 then typeof(p14.args) == "table" else nil
    local v34 = if not v32 or not v33 then {} else p14.args

    for _, v35 in v34 do
        local v36 = result2 and result2.get(v35)

        if v36 ~= nil and v36.hidden == true and not v36.playerArg then
            table.insert(t8, v35)
        end
    end

    return t8
end

function t3.modifierCandidates(p15) -- line: 200
    -- upvalues: Permissions (copy), result (ref), v1 (ref), t4 (copy), ensureLoaded (copy)
    ensureLoaded()

    local t9 = {}

    if result and p15 ~= "" then
        local v37 = p15:lower()

        for _, v38 in v1 do
            local v39 = v38:lower()

            if #v39 >= #v37 and v39:sub(1, #v37) == v37 then
                local v40 = result.get(v39)

                if v40 and Permissions.canUseModifierNow(v40) then
                    local v41 = v40.requiresCapsule == true
                    local v42 = t4[v39]
                    local v43

                    if typeof(v42) == "string" and v42 ~= "" then
                        v43 = v42:match("^(.-)%. ") or v42

                        if #v43 > 60 then
                            v43 = v43:sub(1, 57) .. "..."
                        end
                    end

                    local v44 = if v43 then ("Modifier (%*)"):format(v43) else "Modifier"
                    local t10 = {
                        advance = false,
                        kind = "modifier",
                        keys = { v39 },
                        text = v39,
                        display = v40.key or v38
                    }

                    if v41 then
                        v39 ..= "()"
                    end

                    t10.insert = v39
                    t10.caretBack = v41 and 1 or 0
                    t10.description = v44
                    table.insert(t9, t10)
                end
            end
        end
    end

    return t9
end

function t3.expand(p16, p17) -- line: 235
    -- upvalues: Permissions (copy), t3 (copy), result (ref), v1 (ref), t4 (copy), ensureLoaded (copy)
    ensureLoaded()

    local t11 = {}
    local v45 = p16:lower()

    for _, v46 in v1 do
        local v47 = v46:lower()

        if #v45 > #v47 and v45:sub(1, #v47) == v47 then
            local v48 = result and result.get(v47)

            if v48 and not Permissions.canUseModifierNow(v48) then
                break
            end

            local v49 = v45:sub(#v47 + 1)

            if v49 == "" then
                break
            end

            for _, v50 in p17 do
                local text = v50.text

                if typeof(text) == "string" and text:sub(1, #v49) == v49 and not t3.isRejectedOn(v47, v50.command) then
                    local v51 = v47 .. text
                    local t12 = {
                        kind = "command",
                        keys = { v51 },
                        text = v51,
                        insert = v51,
                        display = v47 .. (v50.display or text),
                        command = v50.command,
                        locked = v50.locked,
                        runState = v50.runState
                    }
                    local v52 = t4[v47]
                    local v53

                    if typeof(v52) == "string" and v52 ~= "" then
                        v53 = v52:match("^(.-)%. ") or v52

                        if #v53 > 60 then
                            v53 = v53:sub(1, 57) .. "..."
                        end
                    end

                    t12.description = v53 or v50.description
                    table.insert(t11, t12)
                end
            end

            return t11
        end
    end

    return t11
end

return t3
