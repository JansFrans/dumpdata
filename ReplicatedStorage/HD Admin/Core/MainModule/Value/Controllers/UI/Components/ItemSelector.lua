-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local InputRow = require(script.Parent.InputRow)

require(UI.Components.Pressable)

local Navigate = require(UI.Util.Navigate)
local Players = game:GetService("Players")
local v1

local function getParser() -- line: 14
    -- upvalues: Modules (copy), v1 (ref)
    v1 = v1 or require(Modules.Parser)

    return v1
end

local function playerToItem(p1) -- line: 61
    return {
        category = "player",
        key = tostring(p1.UserId),
        label = p1.DisplayName .. " @" .. p1.Name,
        header = p1.DisplayName,
        body = "@" .. p1.Name,
        icon = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. p1.UserId .. "&width=48&height=48&format=png",
        rawValue = p1
    }
end

local function toolToItem(p2) -- line: 74
    local v2 = p2.TextureId or ""

    return {
        category = "qualifier",
        key = p2.Name,
        label = p2.Name,
        header = p2.Name,
        icon = if v2 == "" then nil else v2,
        rawValue = p2
    }
end

local function getQualifierItems() -- line: 86
    -- upvalues: Modules (copy)
    local _require = require
    local Qualifiers = Modules.Parser.Qualifiers
    local ok, result = pcall(_require, Qualifiers)

    if not ok then
        return {}
    end

    local t3 = {}

    for v3, v4 in (result.getAll()) do
        if not v4.isHidden then
            local v5 = tostring(v3)
            local v6 = v5:lower()
            local description = v4.description

            table.insert(t3, {
                category = "qualifier",
                key = "qualifier:" .. v6,
                label = v5 .. (if description and #description > 0 then " - " .. description else ""),
                header = v5,
                body = if not (description and #description > 0) then nil else description,
                rawValue = v6,
                configurable = v4.configurable,
                displayOrder = v4.displayOrder
            })
        end
    end

    table.sort(t3, function(p3, p4) -- line: 107
        local displayOrder = p3.displayOrder
        local displayOrder2 = p4.displayOrder

        if displayOrder and displayOrder2 then
            return displayOrder < displayOrder2
        end

        if displayOrder then
            return true
        end

        if displayOrder2 then
            return false
        end

        return p3.key < p4.key
    end)

    return t3
end

local function getServerPlayerItems() -- line: 123
    -- upvalues: Players (copy), playerToItem (copy)
    local t5 = {}

    for _, player in Players:GetPlayers() do
        table.insert(t5, (playerToItem(player)))
    end

    return t5
end

local function splitCapsule(p5) -- line: 133
    if typeof(p5) ~= "string" then
        return p5, nil
    end

    local v8, v9 = p5:match("^(.-)%((.*)%)$")

    if not (v8 and #v8 > 0) then
        return p5, nil
    end

    return v8, v9
end

return function(p6, p7) -- line: 146
    -- upvalues: Modules (copy), Fusion (copy), Theme (copy), Children (copy), InputRow (copy), Navigate (copy), Players (copy), v1 (ref), playerToItem (copy), getQualifierItems (copy), getServerPlayerItems (copy)
    local v10 = p7.canAnyUserBeAddedToPicker == true
    local title = p7.title

    if not title then
        title = if v10 then "Users" else ""
    end

    local v11 = p7.maxItems or 1e999
    local pickerGetter, presetGetter = p7.pickerGetter, p7.presetGetter
    local v12 = p7.displayServerPlayersInPicker == true
    local v13 = p7.displayQualifiersInPicker == true
    local itemToEntry, entryToKey = p7.itemToEntry, p7.entryToKey
    local v14 = itemToEntry ~= nil and entryToKey ~= nil

    local function getPresetItems() -- line: 159
        -- upvalues: presetGetter (copy)
        if not presetGetter then
            return {}
        end

        local t6 = {}

        for _, v15 in (presetGetter()) do
            if typeof(v15) == "table" and v15.key ~= nil then
                local v16 = table.clone(v15)

                v16.category = "preset"
                table.insert(t6, v16)
            end
        end

        return t6
    end

    local function appendPresets(p8) -- line: 173
        -- upvalues: presetGetter (copy), getPresetItems (copy)
        if not presetGetter then
            return
        end

        local t7 = {}

        for _, v17 in p8 do
            t7[v17.key] = true
        end

        for _, v18 in getPresetItems() do
            if not t7[v18.key] then
                table.insert(p8, v18)
            end
        end
    end

    local function buildItems() -- line: 184
        -- upvalues: p7 (copy), pickerGetter (copy), presetGetter (copy), appendPresets (copy), v10 (copy), v12 (copy), v13 (copy), Fusion (copy), playerToItem (copy), getQualifierItems (copy), getServerPlayerItems (copy)
        if pickerGetter then
            local t8 = {}

            for _, v19 in (pickerGetter()) do
                if typeof(v19) == "Instance" and v19:IsA("Player") then
                    table.insert(t8, (playerToItem(v19)))
                elseif typeof(v19) == "Instance" and v19:IsA("Tool") then
                    local v21 = v19.TextureId or ""

                    table.insert(t8, {
                        category = "qualifier",
                        key = v19.Name,
                        label = v19.Name,
                        header = v19.Name,
                        icon = if v21 == "" then nil else v21,
                        rawValue = v19
                    })
                elseif typeof(v19) == "table" then
                    if typeof(v19.name) ~= "string" or v19.textureId == nil then
                        if typeof(v19) == "string" then
                            table.insert(t8, {
                                category = "qualifier",
                                key = v19,
                                label = v19,
                                header = v19,
                                rawValue = v19
                            })
                        elseif typeof(v19) ~= "table" or v19.key == nil or v19.category == nil then
                            if typeof(v19) == "EnumItem" then
                                local Name = v19.Name

                                table.insert(t8, {
                                    category = "qualifier",
                                    key = tostring(v19),
                                    label = Name,
                                    header = Name,
                                    rawValue = v19
                                })
                            else
                                local v26 = tostring(v19)

                                table.insert(t8, {
                                    category = "qualifier",
                                    key = v26,
                                    label = v26,
                                    header = v26,
                                    rawValue = v26
                                })
                            end
                        else
                            table.insert(t8, v19)
                        end
                    else
                        local v24 = v19.textureId or ""

                        table.insert(t8, {
                            category = "qualifier",
                            key = v19.name,
                            label = v19.name,
                            header = v19.name,
                            icon = if v24 == "" then "rbxassetid://124010401308798" else v24,
                            rawValue = v19.name
                        })
                    end
                elseif typeof(v19) == "string" then
                    table.insert(t8, {
                        category = "qualifier",
                        key = v19,
                        label = v19,
                        header = v19,
                        rawValue = v19
                    })
                elseif typeof(v19) ~= "table" or v19.key == nil or v19.category == nil then
                    if typeof(v19) == "EnumItem" then
                        local Name = v19.Name

                        table.insert(t8, {
                            category = "qualifier",
                            key = tostring(v19),
                            label = Name,
                            header = Name,
                            rawValue = v19
                        })
                    else
                        local v28 = tostring(v19)

                        table.insert(t8, {
                            category = "qualifier",
                            key = v28,
                            label = v28,
                            header = v28,
                            rawValue = v28
                        })
                    end
                else
                    table.insert(t8, v19)
                end
            end

            appendPresets(t8)

            return t8
        end

        if v12 or v13 then
            local t26 = {}

            if v12 then
                for _, v29 in getServerPlayerItems() do
                    table.insert(t26, v29)
                end
            end

            if v13 then
                for _, v30 in getQualifierItems() do
                    table.insert(t26, v30)
                end
            end

            if v10 and p7.sharedCustomUsers then
                local v31 = Fusion.peek(p7.sharedCustomUsers)
                local t27 = {}

                for _, v32 in t26 do
                    t27[v32.key] = true
                end

                for v33, v34 in v31 do
                    if not t27[v33] then
                        table.insert(t26, v34)
                    end
                end
            end

            appendPresets(t26)

            return t26
        end

        if not (v10 and p7.sharedCustomUsers) then
            if not presetGetter then
                return {}
            end

            local t28 = {}

            appendPresets(t28)

            return t28
        end

        local t29 = {}

        for _, v35 in (Fusion.peek(p7.sharedCustomUsers)) do
            table.insert(t29, v35)
        end

        appendPresets(t29)

        return t29
    end

    local v36

    if p7.itemsGetter then
        local v37 = p7.itemsGetter(p6)

        if typeof(v37.set) == "function" then
            v36 = v37
        else
            v36 = p6:Value(Fusion.peek(v37))
            p6:Observer(v37):onChange(function() -- line: 268
                -- upvalues: v37 (copy), v36 (ref), Fusion (copy)
                v36:set(Fusion.peek(v37))
            end)
        end
    else
        v36 = p6:Value((buildItems()))
    end

    local v39 = p6:Value({})
    local v40 = p6:Value({})
    local v41 = p6:Value({})
    local v42 = p7.isOrderedPicker == true
    local v43 = p6:Value({})
    local v44 = p6:Value({})
    local v45 = p6:Value(false)
    local key, t30

    table.insert(p6, function() -- line: 284
        -- upvalues: t30 (ref)
        if t30 and t30.release then
            t30.release()
        end

        t30 = nil
    end)

    local v47

    if p7.value then
        v47 = Fusion.peek(p7.value)

        if type(v47) ~= "table" or next(v47) == nil then
            if v47 == nil or type(v47) == "table" then
                v47 = nil
            else
                v47 = { v47 }
            end
        end
    end

    local v48 = v47 ~= nil

    if not v47 and p7.default ~= nil then
        local default = p7.default

        if type(default) == "table" then
            v47 = p7.default
        else
            v47 = { p7.default }
        end
    end

    local hydrateEntry, ok, result, key2, v49, v50

    if v47 then
        local t31 = {}
        local t32 = {}
        local v51 = {}

        if v14 then
            local t33 = {}

            for _, v52 in v47 do
                v50 = entryToKey(v52)

                if typeof(v50) == "string" then
                    v51[v50] = true
                    t33[v50] = v52
                    table.insert(t32, v50)
                end
            end

            hydrateEntry = p7.hydrateEntry

            if hydrateEntry then
                v49 = Fusion.peek(v36)

                local t34 = {}

                for _, v53 in v49 do
                    t34[v53.key] = true
                end

                local t35 = {}

                for _, v54 in t32 do
                    if not t34[v54] then
                        local v55 = t33[v54]

                        ok, result = pcall(hydrateEntry, v55)

                        if ok and typeof(result) == "table" and result.key ~= nil then
                            table.insert(t35, result)
                            t34[result.key] = true
                        end
                    end
                end

                if #t35 > 0 then
                    local v56 = table.clone(v49)

                    for _, v57 in t35 do
                        table.insert(v56, v57)
                    end

                    v36:set(v56)
                end
            end

            for _, v58 in Fusion.peek(v36) do
                if v51[v58.key] then
                    t31[v58.key] = true
                end
            end
        else
            local v59

            for _, v60 in v47 do
                local v61 = v60

                if typeof(v60) == "string" then
                    v61, v59 = v60:match("^(.-)%((.*)%)$")

                    if not (v61 and #v61 > 0) then
                        v61 = v60
                        v59 = nil
                    end
                else
                    v59 = nil
                end

                if v59 ~= nil then
                    v51[v61] = v59
                else
                    t32[v60] = true
                end
            end

            local t36 = {}

            for _, v62 in Fusion.peek(v36) do
                if t32[v62.rawValue] then
                    t31[v62.key] = true
                elseif v51[v62.rawValue] ~= nil and v62.configurable then
                    t31[v62.key] = true
                    t36[v62.key] = v51[v62.rawValue]
                end
            end

            if next(t36) ~= nil then
                v41:set(t36)
            end

            if v42 then
                local t37 = {}

                for _, v63 in v47 do
                    v59 = v63

                    local v64

                    if typeof(v63) == "string" then
                        v59, v64 = v63:match("^(.-)%((.*)%)$")

                        if not (v59 and #v59 > 0) then
                            v59 = v63
                            v64 = nil
                        end
                    end

                    for _, v65 in Fusion.peek(v36) do
                        v51 = if v64 ~= nil then v65.rawValue == v59 and v65.configurable ~= nil else v65.rawValue == v63

                        if v51 then
                            key2 = v65.key
                            table.insert(t37, key2)
                            break
                        end
                    end
                end

                if #t37 > 0 then
                    v43:set(t37)
                end
            end
        end

        v39:set(t31)

        if not v48 and p7.value then
            local t38 = {}

            for _, v66 in Fusion.peek(v36) do
                if t31[v66.key] then
                    v50 = if v14 then itemToEntry(v66) else v66.rawValue
                    table.insert(t38, v50)
                end
            end

            p7.value:set(t38)
        end
    end

    local v67 = false

    local function resyncFromValue(p9) -- line: 408
        -- upvalues: p7 (copy), entryToKey (copy), v36 (ref), v39 (copy), v43 (copy), v67 (ref), v14 (copy), v42 (copy), Fusion (copy)
        if p7.value and not v67 then
            local v68 = Fusion.peek(p7.value)

            if type(v68) ~= "table" then
                if v68 ~= nil then
                    v68 = { v68 }
                else
                    v68 = {}
                end
            end

            local v69 = Fusion.peek(v36)

            if p9 == "external" and v14 and entryToKey then
                local t39 = {}

                for _, v70 in v68 do
                    local v71 = entryToKey(v70)

                    if typeof(v71) == "string" then
                        t39[v71] = v70
                    end
                end

                local t40

                for v72, v73 in v69 do
                    local v74 = t39[v73.key]

                    if v74 ~= nil and v73.rawValue ~= v74 then
                        local v75 = table.clone(v73)

                        v75.rawValue = v74

                        if typeof(v74) == "table" then
                            local type = v74.type

                            if type == "AnyMember" then
                                v75.roleLabel = "All Roles"
                            elseif type == "SpecificRoles" and typeof(v74.roles) == "table" then
                                local t41 = {}

                                for _, v76 in v74.roles do
                                    if typeof(v76) == "table" then
                                        local name = v76.name

                                        if typeof(name) == "string" and #name > 0 then
                                            table.insert(t41, name)
                                        elseif typeof(v76.rank) == "number" then
                                            table.insert(t41, "Rank " .. tostring(v76.rank))
                                        end
                                    end
                                end

                                if #t41 == 0 then
                                    v75.roleLabel = "All Roles"
                                else
                                    v75.roleLabel = table.concat(t41, ", ")
                                end
                            end
                        end

                        if t40 == nil then
                            t40 = {}
                        end

                        t40[v72] = v75
                    end
                end

                if t40 ~= nil then
                    local v78 = table.clone(v69)

                    for v79, v80 in t40 do
                        v78[v79] = v80
                    end

                    v67 = true
                    v36:set(v78)
                    v67 = false
                    v69 = Fusion.peek(v36)
                end
            end

            local v81 = Fusion.peek(v39)
            local t42 = {}

            if v14 then
                local hydrateEntry = p7.hydrateEntry
                local t43

                if hydrateEntry then
                    t43 = {}

                    for _, v82 in v69 do
                        t43[v82.key] = true
                    end
                end

                local t44 = {}

                for _, v83 in v68 do
                    local v84 = entryToKey(v83)

                    if typeof(v84) == "string" then
                        t42[v84] = true

                        if hydrateEntry and not t43[v84] then
                            t43[v84] = true

                            local ok, result = pcall(hydrateEntry, v83)

                            if ok and typeof(result) == "table" and result.key ~= nil then
                                table.insert(t44, result)
                            end
                        end
                    end
                end

                if #t44 > 0 then
                    local v85 = table.clone(v69)

                    for _, v86 in t44 do
                        table.insert(v85, v86)
                    end

                    v67 = true
                    v36:set(v85)
                    v67 = false
                    v69 = Fusion.peek(v36)
                end
            else
                local t45 = {}
                local t46 = {}

                for _, v87 in v68 do
                    local v89
                    local v88 = v87

                    if typeof(v87) == "string" then
                        v88, v89 = v87:match("^(.-)%((.*)%)$")

                        if not (v88 and #v88 > 0) then
                            v88 = v87
                            v89 = nil
                        end
                    end

                    if v89 ~= nil then
                        t46[v88] = v89
                    else
                        t45[v87] = true
                    end
                end

                for _, v90 in v69 do
                    if t45[v90.rawValue] or t46[v90.rawValue] ~= nil and v90.configurable then
                        t42[v90.key] = true
                    end
                end
            end

            local v91 = true

            for v92 in t42 do
                if not v81[v92] then
                    v91 = false
                    break
                end
            end

            if v91 then
                for v93 in v81 do
                    if not t42[v93] then
                        v91 = false
                        break
                    end
                end
            end

            if v91 then
                return
            end

            v67 = true
            v39:set(t42)

            if v42 then
                local t47 = {}

                if v14 then
                    for _, v94 in v68 do
                        local v95 = entryToKey(v94)

                        if typeof(v95) == "string" then
                            table.insert(t47, v95)
                        end
                    end
                else
                    local t48 = {}
                    local t49 = {}

                    for _, v96 in v69 do
                        t48[v96.rawValue] = v96.key

                        if v96.configurable then
                            t49[v96.rawValue] = v96.key
                        end
                    end

                    for _, v97 in v68 do
                        local v99
                        local v98 = v97

                        if typeof(v97) == "string" then
                            v98, v99 = v97:match("^(.-)%((.*)%)$")

                            if not (v98 and #v98 > 0) then
                                v98 = v97
                                v99 = nil
                            end
                        end

                        local v100 = if v99 == nil then t48[v97] else t49[v98]

                        if v100 then
                            table.insert(t47, v100)
                        end
                    end
                end

                v43:set(t47)
            end

            v67 = false
        end
    end

    if p7.value ~= nil then
        p6:Observer(p7.value):onChange(function() -- line: 561
            -- upvalues: resyncFromValue (copy)
            resyncFromValue("external")
        end)
        p6:Observer(v36):onChange(function() -- line: 563
            -- upvalues: resyncFromValue (copy)
            resyncFromValue("items")
        end)
    end

    if v12 then
        local connection = Players.PlayerAdded:Connect(function() -- line: 567
            -- upvalues: buildItems (copy), v36 (ref)
            v36:set((buildItems()))
        end)
        local connection2 = Players.PlayerRemoving:Connect(function() -- line: 570
            -- upvalues: buildItems (copy), v36 (ref)
            v36:set((buildItems()))
        end)

        hydrateEntry = function() -- line: 573
            -- upvalues: connection (copy), connection2 (copy)
            connection:Disconnect()
            connection2:Disconnect()
        end

        table.insert(p6, hydrateEntry)
    end

    if v10 and p7.sharedCustomUsers then
        p6:Observer(p7.sharedCustomUsers):onChange(function() -- line: 580
            -- upvalues: p7 (copy), v36 (ref), Fusion (copy)
            local v103 = Fusion.peek(p7.sharedCustomUsers)
            local v104 = Fusion.peek(v36)
            local t50 = {}

            for _, v105 in v104 do
                t50[v105.key] = true
            end

            local v106 = table.clone(v104)
            local v107 = false

            for v108, v109 in v103 do
                if not t50[v108] then
                    v107 = true
                    table.insert(v106, v109)
                end
            end

            local t51 = {}

            for _, v110 in v106 do
                if v110.category ~= "custom" or v103[v110.key] then
                    table.insert(t51, v110)
                else
                    v107 = true
                end
            end

            if v107 then
                v36:set(t51)
            end
        end)
    end

    local function writeBack() -- line: 607
        -- upvalues: p7 (copy), itemToEntry (copy), entryToKey (copy), v36 (ref), v39 (copy), v41 (copy), v43 (copy), v14 (copy), v42 (copy), Modules (copy), Fusion (copy), v1 (ref)
        if p7.value then
            local v111 = Fusion.peek(v41)
            local t52 = {}

            local function serialize(p10) -- line: 611
                -- upvalues: v111 (copy), itemToEntry (copy), v14 (copy), Modules (copy), v1 (ref)
                if v14 then
                    return itemToEntry(p10)
                end

                local rawValue = p10.rawValue
                local v112 = v111[p10.key]

                if typeof(v112) ~= "string" or not (#v112 > 0) then
                    return rawValue
                end

                v1 = v1 or require(Modules.Parser)

                return (v1.addCapsule(tostring(rawValue), v112))
            end

            if v42 then
                local v113 = Fusion.peek(v43)
                local t53 = {}

                for _, v114 in Fusion.peek(v36) do
                    t53[v114.key] = v114
                end

                for _, v115 in v113 do
                    local v116 = t53[v115]

                    if v116 then
                        table.insert(t52, serialize(v116))
                    end
                end
            else
                local v117 = Fusion.peek(v39)
                local v118 = Fusion.peek(v36)
                local t54 = {}

                for _, v119 in v118 do
                    t54[v119.key] = v119
                end

                local t55 = {}
                local v120 = Fusion.peek(p7.value)

                if typeof(v120) == "table" then
                    for _, v121 in v120 do
                        local v122

                        if v14 and entryToKey then
                            v122 = entryToKey(v121)
                        else
                            for _, v123 in v118 do
                                if v123.rawValue == v121 then
                                    v122 = v123.key
                                    break
                                end
                            end
                        end

                        if typeof(v122) == "string" and v117[v122] and not t55[v122] then
                            local v124 = t54[v122]

                            if v124 then
                                t55[v122] = true
                                table.insert(t52, serialize(v124))
                            end
                        end
                    end
                end

                for _, v125 in v118 do
                    if v117[v125.key] and not t55[v125.key] then
                        table.insert(t52, serialize(v125))
                    end
                end
            end

            p7.value:set(t52)
        end
    end

    local function onRemoveCustomUser(p11) -- line: 673
        -- upvalues: p7 (copy), v36 (ref), v39 (copy), v40 (copy), key (ref), writeBack (copy), Fusion (copy)
        if key == p11 then
            key = nil
        end

        local t56 = {}

        for _, v126 in (Fusion.peek(v36)) do
            if v126.key ~= p11 then
                table.insert(t56, v126)
            end
        end

        v36:set(t56)

        if p7.sharedCustomUsers then
            local v127 = Fusion.peek(p7.sharedCustomUsers)

            if v127[p11] then
                local v128 = table.clone(v127)

                v128[p11] = nil
                p7.sharedCustomUsers:set(v128)
            end
        end

        local v129 = Fusion.peek(v40)

        if v129[p11] then
            local v130 = table.clone(v129)

            v130[p11] = nil
            v40:set(v130)
        end

        local v131 = Fusion.peek(v39)

        if v131[p11] then
            local v132 = table.clone(v131)

            v132[p11] = nil
            v39:set(v132)
            writeBack()
        end
    end

    local function onAddItem(p12, p13) -- line: 707
        -- upvalues: p7 (copy), v36 (ref), v39 (copy), v40 (copy), writeBack (copy), Fusion (copy)
        local v133 = typeof(p12) == "table"
        local v134 = if v133 then typeof(p12.key) == "string" else nil

        if v133 and v134 then
            local v135 = Fusion.peek(v36)
            local t57 = {}
            local v136, v137, v138

            if typeof(p13) == "string" then
                local v139 = Fusion.peek(v39)
                local v140 = Fusion.peek(v40)

                v137 = v139[p13] == true
                v138 = v140[p13] == true

                local v141

                for _, v142 in v135 do
                    if v142.key == p13 then
                        v141 = p13
                    else
                        table.insert(t57, v142)
                    end

                    v136 = v141
                end
            else
                v137 = false
                v138 = false

                for _, v143 in v135 do
                    if v143.key == p12.key then
                        return
                    end

                    v137 = false
                    v138 = false
                    v136 = nil
                    table.insert(t57, v143)
                end
            end

            table.insert(t57, p12)
            v36:set(t57)

            local v144 = table.clone((Fusion.peek(v39)))
            local v145 = table.clone((Fusion.peek(v40)))

            if v136 then
                v144[v136] = nil
                v145[v136] = nil

                if v137 then
                    v144[p12.key] = true
                end

                if v138 then
                    v145[p12.key] = true
                end
            else
                v144[p12.key] = true
                v145[p12.key] = true
            end

            v39:set(v144)
            v40:set(v145)
            writeBack()

            if p7.sharedCustomUsers then
                local v146 = Fusion.peek(p7.sharedCustomUsers)
                local v147 = table.clone(v146)

                if v136 then
                    v147[v136] = nil
                end

                if not v147[p12.key] then
                    v147[p12.key] = p12
                end

                p7.sharedCustomUsers:set(v147)
            end
        end
    end

    local function setPreview(p14) -- line: 761
        -- upvalues: v36 (ref), key (ref), v67 (ref), Fusion (copy)
        local t58 = {}

        for _, v148 in (Fusion.peek(v36)) do
            if v148.key ~= key then
                table.insert(t58, v148)
            end
        end

        key = nil

        if typeof(p14) == "table" and typeof(p14.key) == "string" then
            local v149 = false

            for _, v150 in t58 do
                if v150.key == p14.key then
                    v149 = true
                    break
                end
            end

            if not v149 then
                table.insert(t58, 1, p14)
                key = p14.key
            end
        end

        v67 = true
        v36:set(t58)
        v67 = false
    end

    p6:Observer(v40):onChange(function() -- line: 784
        -- upvalues: p7 (copy), v36 (ref), v40 (copy), key (ref), Fusion (copy)
        local key2 = key

        if key2 ~= nil and Fusion.peek(v40)[key2] then
            key = nil

            if p7.sharedCustomUsers then
                for _, v151 in Fusion.peek(v36) do
                    if v151.key == key2 then
                        local v152 = Fusion.peek(p7.sharedCustomUsers)

                        if v152[key2] then
                            break
                        end

                        local v153 = table.clone(v152)

                        v153[key2] = v151
                        p7.sharedCustomUsers:set(v153)

                        return
                    end
                end
            end
        end
    end)
    v49 = p6:Computed(function(p15) -- line: 804
        -- upvalues: v36 (ref), v39 (copy), v43 (copy), v42 (copy)
        if v42 then
            local v154 = p15(v43)

            if #v154 ~= 0 then
                local t59 = {}

                for _, v155 in (p15(v36)) do
                    t59[v155.key] = v155
                end

                local t60 = {}

                for _, v156 in v154 do
                    local v157 = t59[v156]

                    if v157 then
                        table.insert(t60, v157.header)
                    end
                end

                if #t60 > 0 then
                    return (table.concat(t60, ", "))
                end
            end

            return "None"
        end

        local v158 = p15(v39)
        local t61 = {}

        for _, v159 in (p15(v36)) do
            if v158[v159.key] then
                table.insert(t61, v159.header)
            end
        end

        if #t61 == 0 then
            return "None"
        end

        return table.concat(t61, ", ")
    end)

    local v160 = p6:Computed(function(p16) -- line: 832
        -- upvalues: v39 (copy), v43 (copy), v42 (copy)
        if v42 then
            if #p16(v43) > 0 then
                return 0
            end
        else
            for _ in (p16(v39)) do
                return 0
            end
        end

        return 0.5
    end)

    v50 = {
        title = title,
        name = "ItemSelector",
        labelSize = p7.labelSize,
        labelTextSize = p7.labelTextSize,
        autoHeight = true
    }

    local function onOpenActivate() -- line: 849
        -- upvalues: p7 (copy), title (ref), v11 (copy), buildItems (copy), v36 (ref), v39 (copy), v40 (copy), v41 (copy), v43 (copy), v44 (copy), v45 (copy), key (ref), t30 (ref), v67 (ref), writeBack (copy), onRemoveCustomUser (copy), onAddItem (copy), setPreview (copy), v10 (copy), v14 (copy), v42 (copy), Fusion (copy)
        if p7.onOpen then
            if not p7.itemsGetter and not v14 and p7.pickerGetter then
                local v161 = v36

                v161:set((buildItems()))
            end

            v45:set(true)
            v40:set(table.clone((Fusion.peek(v39))))

            if v42 then
                v44:set(table.clone((Fusion.peek(v43))))
            end

            local t62 = {}

            t62.title = title ~= "" and title or "Select"
            t62.allItems = v36
            t62.pendingKeys = v40
            t62.canAddAnyUser = v10

            local v162 = v10

            if not v10 then
                v162 = p7.addFlow == "Product" or p7.addFlow == "Group"
            end

            t62.canAdd = v162
            t62.maxItems = v11
            t62.onAddItem = onAddItem
            t62.setPreview = setPreview
            t62.addFlow = p7.addFlow or "User"
            t62.onRemoveCustomUser = onRemoveCustomUser
            t62.configurableValues = v41
            t62.pendingOrderedKeys = if v42 then v44 else nil
            t62.limitPickerToOneItem = p7.limitPickerToOneItem == true
            t62.singleSelection = p7.singleSelection == true
            t62.displayServerPlayersInPicker = p7.displayServerPlayersInPicker == true

            function t62.onConfirm() -- line: 876
                -- upvalues: v36 (ref), v39 (copy), v40 (copy), v43 (copy), v44 (copy), v45 (copy), key (ref), v67 (ref), writeBack (copy), v42 (copy), Fusion (copy)
                local t63 = {}

                for _, v163 in (Fusion.peek(v36)) do
                    if v163.key ~= key then
                        table.insert(t63, v163)
                    end
                end

                key = nil
                v67 = true
                v36:set(t63)
                v67 = false
                v39:set(table.clone((Fusion.peek(v40))))

                if v42 then
                    v43:set(table.clone((Fusion.peek(v44))))
                end

                writeBack()
                v45:set(false)
            end

            t30 = t62
            p7.onOpen(t30)
        end
    end

    ok = p6:New("TextButton")
    result = {
        Name = "OpenButton",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 0),
        Text = ""
    }
    result[Fusion.OnEvent("Activated")] = onOpenActivate
    result[Children] = {
        p6:New("TextBox")({
            Name = "TextInput",
            Active = false,
            AutoLocalize = false,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            ClearTextOnFocus = false,
            ClipsDescendants = true,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, -26, 1, 0),
            FontFace = p6:Computed(function(p17) -- line: 907
                -- upvalues: Theme (copy)
                return Font.new(p17(Theme.Font.Body), p17(Theme.FontWeight.Body))
            end),
            Interactable = false,
            PlaceholderColor3 = Theme.Color.NeutralContentDark,
            PlaceholderText = "None",
            Selectable = false,
            Text = v49,
            TextColor3 = Theme.Color.BaseContent,
            TextEditable = false,
            TextSize = Theme.TextSize.Subtitle,
            TextTransparency = v160,
            TextTruncate = Enum.TextTruncate.SplitWord,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            [Children] = {
                p6:New("UIFlexItem")({
                    FlexMode = Enum.UIFlexMode.Fill
                })
            }
        }),
        p6:New("ImageLabel")({
            Name = "ChevronIcon",
            BackgroundTransparency = 1,
            Image = "rbxassetid://78914100674850",
            Rotation = 270,
            AnchorPoint = Vector2.new(1, 0.5),
            ImageColor3 = Theme.Color.NeutralContentDark,
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(20, 20)
        })
    }
    ok = ok(result)
    Navigate.registerActivate(ok, onOpenActivate)

    if p7.autoOpen ~= nil then
        local v164 = false
        local v165 = false

        key2 = function() -- line: 945
            -- upvalues: v164 (ref)
            v164 = true
        end

        table.insert(p6, key2)

        local function scheduleOpen() -- line: 947
            -- upvalues: p7 (copy), onOpenActivate (copy), v164 (ref), v165 (ref), Fusion (copy)
            if v164 or v165 or Fusion.peek(p7.autoOpen) ~= true then
                return
            end

            v165 = true
            task.defer(function() -- line: 953
                -- upvalues: p7 (copy), v164 (ref), v165 (ref)
                v165 = false

                if not v164 then
                    p7.autoOpen:set(false)
                end
            end)
            onOpenActivate()
        end

        task.defer(scheduleOpen)
        p6:Observer(p7.autoOpen):onChange(scheduleOpen)
    end

    v50[Children] = { ok }

    return InputRow(p6, v50)
end
