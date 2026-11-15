-- https://lua.expert

local GroupService = game:GetService("GroupService")
local t1 = {}

local function getRoleNames(p1) -- line: 6
    -- upvalues: GroupService (copy), t1 (copy)
    local v1 = t1[p1]

    if v1 and os.clock() - v1.at < 600 then
        return v1.names
    end

    local function v2() -- line: 11
        -- upvalues: p1 (copy), GroupService (copy)
        return GroupService:GetGroupInfoAsync(p1)
    end

    local ok, result = pcall(v2)

    if ok and typeof(result) == "table" and typeof(result.Roles) == "table" then
        local t2 = {}

        for _, v3 in result.Roles do
            if typeof(v3) == "table" and typeof(v3.Rank) == "number" and typeof(v3.Name) == "string" then
                t2[v3.Rank] = v3.Name
            end
        end

        t1[p1] = {
            at = os.clock(),
            names = t2
        }

        return t2
    end

    return nil
end

return function(p2) -- line: 27
    -- upvalues: getRoleNames (copy)
    if typeof(p2) ~= "table" then
        return true, p2
    end

    local t3 = {}

    for _, v4 in p2 do
        if typeof(v4) == "table" and v4.type == "SpecificRoles" then
            if typeof(v4.roles) == "table" then
                local groupId = v4.groupId
                local v5 = if typeof(groupId) == "number" then getRoleNames(groupId) else nil

                if not v5 then
                    return false, (("Couldn't verify group %* right now. Try again in a moment"):format((tostring(groupId))))
                end

                local t4 = {}

                for _, v6 in v4.roles do
                    if typeof(v6) == "table" and typeof(v6.rank) == "number" then
                        local v7 = v5[v6.rank]

                        if v7 then
                            table.insert(t4, {
                                rank = v6.rank,
                                name = v7
                            })
                        end
                    end
                end

                local v8 = table.clone(v4)

                v8.roles = t4
                table.insert(t3, v8)
            else
                table.insert(t3, v4)
            end
        else
            table.insert(t3, v4)
        end
    end

    return true, t3
end
