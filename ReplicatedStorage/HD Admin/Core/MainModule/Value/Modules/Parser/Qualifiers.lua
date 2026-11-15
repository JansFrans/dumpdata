-- https://lua.expert

local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Services = Modules.Parent.Services
local t1 = {}
local v1 = true
local t2 = {}
local t3 = {}

local function register(p1) -- line: 26
    return p1
end

function t1.update() -- line: 32
    -- upvalues: t1 (copy), v1 (ref), t2 (ref), t3 (ref)
    if not v1 then
        return false
    end

    v1 = false

    local v2 = t1.getAll()

    t2 = {}
    t3 = {}

    for v3, v4 in v2 do
        local v5 = tostring(v3):lower()

        t3[v5] = v4

        local t5 = t2

        table.insert(t5, (tostring(v3)))
    end

    table.sort(t2, function(p2, p3) -- line: 45
        return #p2 > #p3
    end)

    return true
end

function t1.getSortedNameAndAliasLengthArray() -- line: 51
    -- upvalues: t1 (copy), t2 (ref)
    t1.update()

    return t2
end

function t1.getLowercaseDictionary() -- line: 56
    -- upvalues: t1 (copy), t3 (ref)
    t1.update()

    return t3
end

function t1.get(p4) -- line: 61
    -- upvalues: t1 (copy)
    local v7 = tostring(p4):lower()
    local v8 = t1.getLowercaseDictionary()[v7]

    if not v8 then
        return nil
    end

    local key = v8.key

    if v8.mustCreateAliasOf then
        local mustCreateAliasOf = v8.mustCreateAliasOf
        local v9 = t1.items[mustCreateAliasOf]

        if not v9 then
            error((("Qualifiers: %* can not create alias because %* is not a valid qualifier"):format(key, mustCreateAliasOf)))
        end

        for v10, v11 in v9 do
            if not v8[v10] then
                v8[v10] = v11
            end
        end

        v8.mustCreateAliasOf = nil
        v8.aliasOf = mustCreateAliasOf
    end

    return v8
end

function t1.getAll() -- line: 88
    -- upvalues: t1 (copy)
    local items = t1.items

    for v12, v13 in items do
        if not v13.key then
            v13.key = v12
        end

        t1.get(v12)
    end

    return items
end

function t1.createAliasOf(p5, p6) -- line: 100
    -- upvalues: t1 (copy)
    task.defer(function() -- line: 104
        -- upvalues: p5 (copy), t1 (copy)
        if not t1.items[p5] then
            error((("Qualifiers: %* is not a valid qualifier"):format(p5)))
        end
    end)

    local v14 = if typeof(p6) == "table" then p6 else {}

    v14.mustCreateAliasOf = p5

    return v14
end

t1.items = {
    Default = {
        isHidden = true,
        description = "Default action, returns players with matching shorthand names.",
        getTargets = function(p7, p8, _) -- getTargets | line: 124
            -- upvalues: Modules (copy)
            local ParserUtility = require(script.Parent.ParserUtility)
            local v15 = require(Modules.Objects.User).getUser(p7)

            return (ParserUtility.getPlayersFromString(p8, v15))
        end
    },
    Me = {
        description = "You!",
        displayOrder = 1,
        getTargets = function(p10) -- getTargets | line: 135
            -- upvalues: Players (copy)
            local t9 = {}
            local PlayerByUserId = Players:GetPlayerByUserId(p10)

            if PlayerByUserId then
                table.insert(t9, PlayerByUserId)
            end

            return t9
        end
    },
    All = {
        description = "Every player in server",
        displayOrder = 2,
        getTargets = function() -- getTargets | line: 148
            -- upvalues: Players (copy)
            return Players:GetPlayers()
        end
    },
    Others = {
        description = "Everyone except you",
        displayOrder = 3,
        getTargets = function(p11) -- getTargets | line: 156
            -- upvalues: Players (copy)
            local t12 = {}

            for _, player in (Players:GetPlayers()) do
                if player.UserId ~= p11 then
                    table.insert(t12, player)
                end
            end

            return t12
        end
    },
    Random = {
        description = "Selects a random player",
        isCustomizable = true,
        requiresCapsule = true,
        displayOrder = 4,
        getTargets = function(p12, ...) -- getTargets | line: 172
            -- upvalues: t1 (copy)
            local t14 = { ... }

            if #t14 == 0 then
                table.insert(t14, "all")
            end

            local t15 = {}

            for _, v16 in t14 do
                local v17 = t1.get(v16) or t1.get("Default")
                local v18 = v17 and v17.getTargets(p12, v16)

                if v18 then
                    for _, v19 in v18 do
                        table.insert(t15, v19)
                    end
                end
            end

            local t16 = {}

            if #t15 > 0 then
                t16 = { t15[math.random(1, #t15)] }
            end

            return t16
        end
    },
    Role = {
        description = "Players with these roles",
        isCustomizable = true,
        requiresCapsule = true,
        displayOrder = 5,
        configurable = "role1,role2,...",
        getTargets = function(_, ...) -- getTargets | line: 202
            -- upvalues: Modules (copy), Services (copy)
            local t18 = { ... }

            if #t18 == 0 then
                return {}
            end

            local Roles = require(Services.Roles)
            local v20 = Roles.getRoles()
            local t19 = {}
            local n1 = 0
            local n2 = 0

            for v21, v22 in t18 do
                local v23 = tostring(v22):lower()

                for _, v24 in v20 do
                    local v25 = tostring(v24.name):lower()

                    if string.sub(v25, 1, #v23) == v23 and not t19[v25] then
                        t19[v25] = true
                        n1 += 1
                    end
                end

                if v21 >= 20 then
                    n2 = n1
                    break
                end

                n2 = n1
            end

            if n2 <= 0 then
                return {}
            end

            local t20 = {}
            local Players = game:GetService("Players")
            local User = require(Modules.Objects.User)

            for _, player in Players:GetPlayers() do
                local v27 = User.getUser(player)

                for _, v28 in (Roles.getOwnedRoles(v27)) do
                    if t19[tostring(v28):lower()] then
                        table.insert(t20, player)
                        break
                    end
                end
            end

            return t20
        end
    },
    Friends = {
        description = "Players friends with you",
        displayOrder = 6,
        getTargets = function(p14) -- getTargets | line: 251
            -- upvalues: Players (copy)
            local t22 = {}

            for _, player in (Players:GetPlayers()) do
                if player:IsFriendsWith(p14) then
                    table.insert(t22, player)
                end
            end

            return t22
        end
    },
    Radius = {
        description = "Players x studs from you",
        isCustomizable = true,
        requiresCapsule = true,
        displayOrder = 7,
        configurable = "number",
        getTargets = function(p15, p16) -- getTargets | line: 268
            -- upvalues: Players (copy), Modules (copy)
            local t24 = {}
            local v29 = tonumber(p16) or 10
            local PlayerByUserId = Players:GetPlayerByUserId(p15)
            local getHeadPos = require(Modules.PlayerUtil.getHeadPos)

            if PlayerByUserId then
                local v30 = getHeadPos(PlayerByUserId) or Vector3.new(0, 0, 0)

                for _, player in (Players:GetPlayers()) do
                    if player:DistanceFromCharacter(v30) <= v29 then
                        table.insert(t24, player)
                    end
                end
            end

            return t24
        end
    },
    Amount = {
        description = "x amount of players in server",
        isCustomizable = true,
        requiresCapsule = true,
        displayOrder = 8,
        configurable = "number",
        getTargets = function(_, p18) -- getTargets | line: 291
            -- upvalues: Players (copy)
            local v31 = tonumber(p18) or 5
            local Players2 = Players:GetPlayers()
            local v33 = math.min(v31, #Players2)
            local t26 = {}

            for _ = 1, v33 do
                local v34 = math.random(1, #Players2)

                table.insert(t26, Players2[v34])
                table.remove(Players2, v34)
            end

            return t26
        end
    },
    Percent = {
        description = "x% of players in server",
        isCustomizable = true,
        requiresCapsule = true,
        displayOrder = 9,
        configurable = "number",
        getTargets = function(_, p20) -- getTargets | line: 313
            -- upvalues: Players (copy), Modules (copy)
            local v37 = math.clamp(tonumber(p20) or 50, 0, 100) / 100
            local Players2 = Players:GetPlayers()
            local v38 = #Players2
            local v39 = require(Modules.MathUtil.round)(v38 * v37)
            local t28 = {}

            for _ = 1, v39 do
                local v40 = math.random(1, #Players2)

                table.insert(t28, Players2[v40])
                table.remove(Players2, v40)
            end

            return t28
        end
    },
    Team = {
        description = "Players in these teams",
        isCustomizable = true,
        requiresCapsule = true,
        displayOrder = 10,
        configurable = "team1,team2,...",
        getTargets = function(_, ...) -- getTargets | line: 337
            -- upvalues: Players (copy), Teams (copy)
            local t30 = {}
            local t31 = { ... }
            local t32 = {}

            if #t31 == 0 then
                return {}
            end

            local v42 = false

            for _, child in (Teams:GetChildren()) do
                local v43 = string.lower(child.Name)

                for _, v45 in t31 do
                    local v46 = string.lower((tostring(v45)))

                    if string.sub(v43, 1, #v46) == v46 then
                        local TeamColor = child.TeamColor

                        v42 = true
                        t32[tostring(TeamColor)] = true
                    end
                end
            end

            if not v42 then
                return {}
            end

            for _, player in (Players:GetPlayers()) do
                if t32[tostring(player.TeamColor)] then
                    table.insert(t30, player)
                end
            end

            return t30
        end
    },
    Group = {
        description = "Players in these groups",
        isCustomizable = true,
        requiresCapsule = true,
        displayOrder = 11,
        configurable = "groupId1,groupId2,...",
        getTargets = function(_, ...) -- getTargets | line: 374
            -- upvalues: Players (copy)
            local t34 = {}
            local t35 = {}

            for _, v48 in { ... } do
                local v49 = tonumber(v48)

                if v49 then
                    table.insert(t35, v49)
                end
            end

            for _, player in (Players:GetPlayers()) do
                for _, v50 in t35 do
                    if player:IsInGroup(v50) then
                        table.insert(t34, player)
                        break
                    end
                end
            end

            return t34
        end
    },
    Premium = {
        description = "Players with Roblox Premium",
        displayOrder = 12,
        getTargets = function(_) -- getTargets | line: 398
            -- upvalues: Players (copy)
            local t37 = {}

            for _, player in (Players:GetPlayers()) do
                if player.MembershipType == Enum.MembershipType.Premium then
                    table.insert(t37, player)
                end
            end

            return t37
        end
    }
}

return t1
