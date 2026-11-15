-- https://lua.expert

local t1 = {
    TextSize = true,
    Layout = true
}
local t2 = {
    ContentScale = true
}
local t3 = {}
local t4 = {
    Color = {
        Primary = "LockPrimaryColor"
    },
    Font = {
        Body = "LockFont",
        Heading = "LockFont"
    },
    Layout = {
        ContentScale = "LockContentScale"
    }
}
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local _ = Modules.Parent.Controllers.UI

require(Modules.TableUtil.deepCopyTable)

local Fusion = require(Packages.Fusion)
local _ = Fusion.Contextual
local BaseTheme = require(script.BaseTheme)
local fuseState = require(Modules.DataUtil.fuseState)
local v1 = Fusion.scoped({
    Value = Fusion.Value,
    Fuse = fuseState,
    Observer = Fusion.Observer
})
local v2 = Fusion.scoped({
    Value = Fusion.Value,
    Computed = Fusion.Computed,
    Fuse = fuseState
})
local peek = Fusion.peek
local Themes = script:FindFirstAncestor("HD Admin").Config.Themes
local t5 = {}

local function resolveFallbackTheme() -- line: 32
    -- upvalues: t3 (copy), Themes (copy)
    local n1 = 1e999
    local Name

    for _, child in Themes:GetChildren() do
        if child:IsA("ModuleScript") and not t3[child.Name] then
            local _require = require
            local ok, result = pcall(_require, child)

            if ok and typeof(result) == "table" then
                local Settings = result.Settings

                if not Settings or Settings.ShowInYouSettings == nil or Settings.ShowInYouSettings then
                    local v3 = if not Settings then 1e999 elseif typeof(Settings.LayoutOrder) == "number" then Settings.LayoutOrder else 1e999

                    if v3 < n1 then
                        n1 = v3
                        Name = child.Name
                    end
                end
            end
        end
    end

    return Name or "Dark"
end

local v4 = v1:Value((resolveFallbackTheme()))
local t6 = {}
local t7 = {}
local t8 = {}
local t9 = {}

local function getSlot(p1, p2) -- line: 61
    -- upvalues: v1 (copy), t6 (copy)
    local v5 = p1 .. "." .. p2

    if not t6[v5] then
        t6[v5] = v1:Value(nil)
    end

    return t6[v5]
end

local function getGameValueSlot(p3, p4) -- line: 69
    -- upvalues: v1 (copy), t7 (copy)
    local v6 = p3 .. "." .. p4

    if not t7[v6] then
        t7[v6] = v1:Value(nil)
    end

    return t7[v6]
end

local function getGameDefaultSlot(p5, p6) -- line: 77
    -- upvalues: v1 (copy), t8 (copy)
    local v7 = p5 .. "." .. p6

    if not t8[v7] then
        t8[v7] = v1:Value(nil)
    end

    return t8[v7]
end

local function getGameLockSlot(p7, p8) -- line: 85
    -- upvalues: v1 (copy), t9 (copy)
    local v8 = p7 .. "." .. p8

    if not t9[v8] then
        t9[v8] = v1:Value(nil)
    end

    return t9[v8]
end

local function getBaseThemeValue(p9, p10, p11) -- line: 95
    -- upvalues: BaseTheme (copy), Themes (copy), v4 (copy)
    local v10 = Themes:FindFirstChild((p9(v4)))

    if v10 == nil then
        return BaseTheme[p10][p11]
    end

    local v11 = require(v10)[p10]

    if v11 == nil or v11[p11] == nil then
        return BaseTheme[p10][p11]
    end

    return v11[p11]
end

local function isLocked(p12, p13, p14) -- line: 110
    -- upvalues: t4 (copy), BaseTheme (copy), Themes (copy), v4 (copy)
    local v12 = t4[p13]

    if not v12 then
        return false
    end

    local v13 = v12[p14]

    if not v13 then
        return false
    end

    local v15 = Themes:FindFirstChild((p12(v4)))
    local v16

    if v15 ~= nil then
        local Settings = require(v15).Settings

        v16 = if Settings == nil or Settings[v13] == nil then BaseTheme.Settings[v13] else Settings[v13]
    else
        v16 = BaseTheme.Settings[v13]
    end

    return v16 == true
end

local function isGameLocked(p15, p16, p17) -- line: 118
    -- upvalues: v1 (copy), t9 (copy)
    local v17 = p16 .. "." .. p17

    if not t9[v17] then
        t9[v17] = v1:Value(nil)
    end

    local v18 = p15(t9[v17])

    return v18 ~= nil and p15(v18) == false
end

local function readGameValue(p18, p19, p20) -- line: 125
    -- upvalues: v1 (copy), t7 (copy)
    local v19 = p19 .. "." .. p20

    if not t7[v19] then
        t7[v19] = v1:Value(nil)
    end

    local v20 = p18(t7[v19])

    if v20 == nil then
        return nil
    end

    return p18(v20)
end

local function readGameDefault(p21, p22, p23) -- line: 132
    -- upvalues: v1 (copy), t8 (copy)
    local v21 = p22 .. "." .. p23

    if not t8[v21] then
        t8[v21] = v1:Value(nil)
    end

    local v22 = p21(t8[v21])

    if v22 == nil then
        return nil
    end

    return p21(v22)
end

local function areValuesEqual(p24, p25) -- line: 139
    if p24 == p25 then
        return true
    end

    if typeof(p24) ~= typeof(p25) or typeof(p24) ~= "Color3" then
        return false
    end

    if p24.R == p25.R and p24.G == p25.G then
        return p24.B == p25.B
    end

    return false
end

local function computeValue(p26, p27) -- line: 148
    -- upvalues: t1 (copy), t2 (copy), t4 (copy), BaseTheme (copy), v1 (copy), v2 (copy), Themes (copy), v4 (copy), t6 (copy), t7 (copy), t8 (copy), t9 (copy)
    local v23 = p26 .. "." .. p27

    if not t6[v23] then
        t6[v23] = v1:Value(nil)
    end

    local v24 = t6[v23]
    local v25 = t1[p26] == true

    return v2:Computed(function(p28) -- line: 151
        -- upvalues: p26 (copy), p27 (copy), v24 (copy), v25 (copy), t2 (copy), t4 (copy), BaseTheme (copy), v1 (copy), Themes (copy), v4 (copy), t6 (copy), t7 (copy), t8 (copy), t9 (copy)
        local v27 = Themes:FindFirstChild((p28(v4)))
        local v28

        if v27 ~= nil then
            local v29 = require(v27)[p26]

            v28 = if v29 == nil or v29[p27] == nil then BaseTheme[p26][p27] else v29[p27]
        else
            v28 = BaseTheme[p26][p27]
        end

        local v30 = t4[p26]
        local v31 = false

        if v30 then
            local v32 = v30[p27]

            if v32 then
                local v34 = Themes:FindFirstChild((p28(v4)))
                local v35

                if v34 ~= nil then
                    local Settings = require(v34).Settings

                    v35 = if Settings == nil or Settings[v32] == nil then BaseTheme.Settings[v32] else Settings[v32]
                else
                    v35 = BaseTheme.Settings[v32]
                end

                v31 = v35 == true
            end
        end

        local v36

        if v31 then
            v36 = v28
        else
            local v37 = p26 .. "." .. p27

            if not t7[v37] then
                t7[v37] = v1:Value(nil)
            end

            local v38 = p28(t7[v37])

            if v38 ~= nil then
                v36 = p28(v38)
            end

            local v39 = p26 .. "." .. p27

            if not t8[v39] then
                t8[v39] = v1:Value(nil)
            end

            local v40 = p28(t8[v39])
            local v41 = if v40 == nil then nil else p28(v40)
            local v42 = v36 ~= nil and not (v36 == v41 or typeof(v36) == typeof(v41) and typeof(v36) == "Color3" and v36.R == v41.R and v36.G == v41.G and v36.B == v41.B)
            local v43 = p26 .. "." .. p27

            if not t9[v43] then
                t9[v43] = v1:Value(nil)
            end

            local v44 = p28(t9[v43])

            if v44 ~= nil and p28(v44) == false then
                if not v42 then
                    v36 = v28
                end
            else
                local v45 = p28(v24)
                local v46 = if v45 == nil then nil else p28(v45)

                if v46 ~= nil then
                    v36 = v46
                elseif not v42 then
                    v36 = v28
                end
            end
        end

        if typeof(v36) ~= typeof(v28) then
            v36 = v28
        end

        local v47

        if not v25 then
            v47 = v36

            return v47
        end

        if typeof(v36) ~= "number" then
            v47 = v36

            return v47
        end

        local ContentScale

        if t2[p27] then
            v47 = v36
        else
            local v49 = Themes:FindFirstChild((p28(v4)))

            if v49 ~= nil then
                local Layout = require(v49).Layout

                ContentScale = if Layout == nil or Layout.ContentScale == nil then BaseTheme.Layout.ContentScale else Layout.ContentScale
            else
                ContentScale = BaseTheme.Layout.ContentScale
            end

            local Layout = t4.Layout
            local v50 = false

            if Layout then
                local ContentScale = Layout.ContentScale

                if ContentScale then
                    local v52 = Themes:FindFirstChild((p28(v4)))
                    local v53

                    if v52 ~= nil then
                        local Settings = require(v52).Settings

                        v53 = if Settings == nil or Settings[ContentScale] == nil then BaseTheme.Settings[ContentScale] else Settings[ContentScale]
                    else
                        v53 = BaseTheme.Settings[ContentScale]
                    end

                    v50 = v53 == true
                end
            end

            local v54

            if v50 then
                v54 = ContentScale
            else
                if not t7["Layout.ContentScale"] then
                    t7["Layout.ContentScale"] = v1:Value(nil)
                end

                local v55 = p28(t7["Layout.ContentScale"])

                if v55 ~= nil then
                    v54 = p28(v55)
                end

                if not t8["Layout.ContentScale"] then
                    t8["Layout.ContentScale"] = v1:Value(nil)
                end

                local v56 = p28(t8["Layout.ContentScale"])
                local v57 = if v56 == nil then nil else p28(v56)
                local v58 = v54 ~= nil and not (v54 == v57 or typeof(v54) == typeof(v57) and typeof(v54) == "Color3" and v54.R == v57.R and v54.G == v57.G and v54.B == v57.B)

                if not t9["Layout.ContentScale"] then
                    t9["Layout.ContentScale"] = v1:Value(nil)
                end

                local v59 = p28(t9["Layout.ContentScale"])

                if v59 ~= nil and p28(v59) == false then
                    if not v58 then
                        v54 = ContentScale
                    end
                else
                    if not t6["Layout.ContentScale"] then
                        t6["Layout.ContentScale"] = v1:Value(nil)
                    end

                    local v60 = p28(t6["Layout.ContentScale"])
                    local v61 = if v60 == nil then nil else p28(v60)

                    if v61 ~= nil then
                        v54 = v61
                    elseif not v58 then
                        v54 = ContentScale
                    end
                end
            end

            v47 = math.round(v36 * v54)
        end

        return v47
    end)
end

for v63, v64 in BaseTheme do
    local t10 = {}

    t5[v63] = t10

    for v65, _ in v64 do
        local v66 = v63 .. "." .. v65

        if not t6[v66] then
            t6[v66] = v1:Value(nil)
        end

        local v67 = t6[v66]
        local v68 = t1[v63] == true

        t10[v65] = v2:Computed(function(p29) -- line: 151
            -- upvalues: t2 (copy), t4 (copy), BaseTheme (copy), v1 (copy), Themes (copy), v4 (copy), t6 (copy), t7 (copy), t8 (copy), t9 (copy), v63 (copy), v65 (copy), v67 (copy), v68 (copy)
            local v70 = Themes:FindFirstChild((p29(v4)))
            local v71

            if v70 ~= nil then
                local v72 = require(v70)[v63]

                v71 = if v72 == nil or v72[v65] == nil then BaseTheme[v63][v65] else v72[v65]
            else
                v71 = BaseTheme[v63][v65]
            end

            local v73 = t4[v63]
            local v74 = false

            if v73 then
                local v75 = v73[v65]

                if v75 then
                    local v77 = Themes:FindFirstChild((p29(v4)))
                    local v78

                    if v77 ~= nil then
                        local Settings = require(v77).Settings

                        v78 = if Settings == nil or Settings[v75] == nil then BaseTheme.Settings[v75] else Settings[v75]
                    else
                        v78 = BaseTheme.Settings[v75]
                    end

                    v74 = v78 == true
                end
            end

            local v79

            if v74 then
                v79 = v71
            else
                local v80 = v63 .. "." .. v65

                if not t7[v80] then
                    t7[v80] = v1:Value(nil)
                end

                local v81 = p29(t7[v80])

                if v81 ~= nil then
                    v79 = p29(v81)
                end

                local v82 = v63 .. "." .. v65

                if not t8[v82] then
                    t8[v82] = v1:Value(nil)
                end

                local v83 = p29(t8[v82])
                local v84 = if v83 == nil then nil else p29(v83)
                local v85 = v79 ~= nil and not (v79 == v84 or typeof(v79) == typeof(v84) and typeof(v79) == "Color3" and v79.R == v84.R and v79.G == v84.G and v79.B == v84.B)
                local v86 = v63 .. "." .. v65

                if not t9[v86] then
                    t9[v86] = v1:Value(nil)
                end

                local v87 = p29(t9[v86])

                if v87 ~= nil and p29(v87) == false then
                    if not v85 then
                        v79 = v71
                    end
                else
                    local v88 = p29(v67)
                    local v89 = if v88 == nil then nil else p29(v88)

                    if v89 ~= nil then
                        v79 = v89
                    elseif not v85 then
                        v79 = v71
                    end

                    if v63 == "Color" and v65 == "Primary" then
                    end
                end
            end

            if typeof(v79) ~= typeof(v71) then
                v79 = v71
            end

            local v90

            if not v68 then
                v90 = v79

                return v90
            end

            if typeof(v79) ~= "number" then
                v90 = v79

                return v90
            end

            local ContentScale

            if t2[v65] then
                v90 = v79
            else
                local v92 = Themes:FindFirstChild((p29(v4)))

                if v92 ~= nil then
                    local Layout = require(v92).Layout

                    ContentScale = if Layout == nil or Layout.ContentScale == nil then BaseTheme.Layout.ContentScale else Layout.ContentScale
                else
                    ContentScale = BaseTheme.Layout.ContentScale
                end

                local Layout = t4.Layout
                local v93 = false

                if Layout then
                    local ContentScale = Layout.ContentScale

                    if ContentScale then
                        local v95 = Themes:FindFirstChild((p29(v4)))
                        local v96

                        if v95 ~= nil then
                            local Settings = require(v95).Settings

                            v96 = if Settings == nil or Settings[ContentScale] == nil then BaseTheme.Settings[ContentScale] else Settings[ContentScale]
                        else
                            v96 = BaseTheme.Settings[ContentScale]
                        end

                        v93 = v96 == true
                    end
                end

                local v97

                if v93 then
                    v97 = ContentScale
                else
                    if not t7["Layout.ContentScale"] then
                        t7["Layout.ContentScale"] = v1:Value(nil)
                    end

                    local v98 = p29(t7["Layout.ContentScale"])

                    if v98 ~= nil then
                        v97 = p29(v98)
                    end

                    if not t8["Layout.ContentScale"] then
                        t8["Layout.ContentScale"] = v1:Value(nil)
                    end

                    local v99 = p29(t8["Layout.ContentScale"])
                    local v100 = if v99 == nil then nil else p29(v99)
                    local v101 = v97 ~= nil and not (v97 == v100 or typeof(v97) == typeof(v100) and typeof(v97) == "Color3" and v97.R == v100.R and v97.G == v100.G and v97.B == v100.B)

                    if not t9["Layout.ContentScale"] then
                        t9["Layout.ContentScale"] = v1:Value(nil)
                    end

                    local v102 = p29(t9["Layout.ContentScale"])

                    if v102 ~= nil and p29(v102) == false then
                        if not v101 then
                            v97 = ContentScale
                        end
                    else
                        if not t6["Layout.ContentScale"] then
                            t6["Layout.ContentScale"] = v1:Value(nil)
                        end

                        local v103 = p29(t6["Layout.ContentScale"])
                        local v104 = if v103 == nil then nil else p29(v103)

                        if v104 ~= nil then
                            v97 = v104
                        elseif not v101 then
                            v97 = ContentScale
                        end
                    end
                end

                v90 = math.round(v79 * v97)
            end

            return v90
        end)
    end
end

local ColorUtil = require(Modules.ColorUtil)
local v106 = Color3.new(1, 1, 1)
local v107 = Color3.new(0, 0, 0)

t5.Color.PrimaryContent = v2:Computed(function(p30) -- line: 230
    -- upvalues: t5 (copy), ColorUtil (copy), v106 (copy), v107 (copy)
    local v108 = p30(t5.Color.Primary)

    if ColorUtil.getLuminance(v108) > 0.4 then
        return v107
    end

    return v106
end)

function t5.isThemeSelectable(p31) -- line: 238
    -- upvalues: t3 (copy), Themes (copy)
    local v109 = Themes:FindFirstChild(p31)

    if v109 == nil or not v109:IsA("ModuleScript") or t3[p31] then
        return false
    end

    local _require = require
    local ok, result = pcall(_require, v109)

    if not ok or typeof(result) ~= "table" then
        return false
    end

    local Settings = result.Settings

    return not (Settings and Settings.ShowInYouSettings == false)
end

function t5.resolveTheme(p32) -- line: 251
    -- upvalues: t5 (copy), resolveFallbackTheme (copy)
    if p32 ~= nil and t5.isThemeSelectable(p32) then
        return p32
    end

    return (resolveFallbackTheme())
end

function t5.setTheme(p33) -- line: 257
    -- upvalues: t5 (copy), v4 (copy)
    v4:set((t5.resolveTheme(p33)))
end

function t5.getTheme() -- line: 262
    -- upvalues: peek (copy), v4 (copy)
    return peek(v4)
end

function t5.bindSetting(p34, p35, p36, p37) -- line: 269
    -- upvalues: v1 (copy), peek (copy), t6 (copy), t7 (copy), t8 (copy), t9 (copy)
    local v111 = p34 .. "." .. p35

    if not t6[v111] then
        t6[v111] = v1:Value(nil)
    end

    local v112 = t6[v111]

    if peek(v112) == nil then
        v112:set((v1:Fuse("perm", p36)))
    end

    if not p37 then
        return
    end

    local v113 = p34 .. "." .. p35

    if not t7[v113] then
        t7[v113] = v1:Value(nil)
    end

    local v114 = t7[v113]

    if peek(v114) == nil then
        local v115 = v1:Fuse("everyone", p37.gamePath)

        v114:set(v115)
        v1:Observer(v115):onChange(function() -- line: 280
            -- upvalues: p34 (copy), p35 (copy), v112 (copy), v1 (copy), peek (copy), t8 (copy), t9 (copy)
            peek(v112)

            local v116 = p34 .. "." .. p35

            if not t9[v116] then
                t9[v116] = v1:Value(nil)
            end

            peek(t9[v116])

            local v117 = p34 .. "." .. p35

            if not t8[v117] then
                t8[v117] = v1:Value(nil)
            end

            peek(t8[v117])
        end)
    end

    local v118 = p34 .. "." .. p35

    if not t8[v118] then
        t8[v118] = v1:Value(nil)
    end

    local v119 = t8[v118]

    if peek(v119) == nil then
        local v120 = table.clone(p37.gamePath)

        v120[1] = "DefaultGameSettings"
        v119:set(v1:Fuse("everyone", v120))
    end

    local v121 = p34 .. "." .. p35

    if not t9[v121] then
        t9[v121] = v1:Value(nil)
    end

    local v122 = t9[v121]

    if peek(v122) == nil then
        v122:set(v1:Fuse("everyone", p37.gameLockPath))
    end
end

function t5.bindThemeName(p38, p39, p40) -- line: 302
    -- upvalues: v1 (copy), peek (copy), t5 (copy)
    local v123 = v1:Fuse("perm", p38)
    local v124 = v1:Fuse("everyone", p39)
    local v125 = v1:Fuse("everyone", p40)

    local function unwrap(p41) -- line: 307
        local v126 = if typeof(p41) == "table" and #p41 == 1 then p41[1] else p41

        return if typeof(v126) == "string" then v126 else nil
    end

    local function apply() -- line: 315
        -- upvalues: v123 (copy), v124 (copy), v125 (copy), peek (copy), t5 (copy)
        local v127 = peek(v124)

        if typeof(v127) == "table" and #v127 == 1 then
            v127 = v127[1]
        end

        if typeof(v127) ~= "string" then
            v127 = nil
        end

        local v128 = peek(v123)

        if typeof(v128) == "table" and #v128 == 1 then
            v128 = v128[1]
        end

        if typeof(v128) ~= "string" then
            v128 = nil
        end

        if peek(v125) ~= false then
            v127 = v128 or v127
        end

        if v127 ~= nil then
            t5.setTheme(v127)
        end
    end

    v1:Observer(v123):onBind(apply)
    v1:Observer(v124):onBind(apply)
    v1:Observer(v125):onBind(apply)
end

return t5
