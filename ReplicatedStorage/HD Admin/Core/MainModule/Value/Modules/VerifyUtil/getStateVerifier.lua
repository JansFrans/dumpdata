-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules

return function(p1, p2, p3, p4, p5, p6, p7) -- line: 14
    -- upvalues: Modules (copy)
    local v1 = p3 or {}

    return function(p8, p9, p10) -- line: 16
        -- upvalues: v1 (copy), p1 (copy), p2 (copy), p4 (copy), p5 (copy), p6 (copy), p7 (copy), Modules (copy)
        local v2 = #p9

        if p9[1] ~= p1 then
            return false
        end

        local v3 = typeof(p8) == "Instance" and p8:IsA("Player")
        local User, Roles, v4, shouldStrip

        if not p4 and not p5 then
            local v5 = nil

            if p6 and p7 and v3 then
                User = require(Modules.Objects.User)
                Roles = require(Modules.Parent.Services.Roles)
                v4 = User.getUser(p8)

                if not v4 or not Roles.canViewPage(v4, p7) then
                    v5 = p6
                end
            end

            function shouldStrip(p11) -- line: 44
                -- upvalues: v1 (copy), p2 (copy), v5 (ref)
                if p2 == "OnlyInclude" and not table.find(v1, p11) or p2 == "Exclude" and table.find(v1, p11) then
                    return true
                end

                return v5 and table.find(v5, p11)
            end

            if v2 >= 3 then
                if shouldStrip(p9[3]) then
                    return true, nil
                end

                return false
            end

            if typeof(p10) ~= "table" then
                return false
            end

            if v2 == 2 then
                for v6, _ in p10 do
                    if shouldStrip(v6) then
                        p10[v6] = nil
                    end
                end
            elseif v2 == 1 then
                for _, v7 in p10 do
                    if typeof(v7) == "table" then
                        for v8, _ in v7 do
                            if shouldStrip(v8) then
                                v7[v8] = nil
                            end
                        end
                    end
                end
            end

            return true, p10
        end

        if v3 then
            local User = require(Modules.Objects.User)
            local Roles = require(Modules.Parent.Services.Roles)
            local v9 = User.getUser(p8)

            if not v9 or p4 and not Roles.hasPermission(v9, p4) or p5 and not Roles.canViewPage(v9, p5) then
                return true, nil
            end
        end

        local v10 = nil

        if p6 and p7 and v3 then
            User = require(Modules.Objects.User)
            Roles = require(Modules.Parent.Services.Roles)
            v4 = User.getUser(p8)

            if not v4 or not Roles.canViewPage(v4, p7) then
                v10 = p6
            end
        end

        function shouldStrip(p12) -- line: 44
            -- upvalues: v1 (copy), p2 (copy), v10 (ref)
            if p2 == "OnlyInclude" and not table.find(v1, p12) or p2 == "Exclude" and table.find(v1, p12) then
                return true
            end

            return v10 and table.find(v10, p12)
        end

        if v2 >= 3 then
            if shouldStrip(p9[3]) then
                return true, nil
            end

            return false
        end

        if typeof(p10) ~= "table" then
            return false
        end

        if v2 == 2 then
            for v11, _ in p10 do
                if shouldStrip(v11) then
                    p10[v11] = nil
                end
            end
        elseif v2 == 1 then
            for _, v12 in p10 do
                if typeof(v12) == "table" then
                    for v13, _ in v12 do
                        if shouldStrip(v13) then
                            v12[v13] = nil
                        end
                    end
                end
            end
        end

        return true, p10
    end
end
