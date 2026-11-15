-- https://lua.expert

return function(p1, p2) -- line: 5
    local function checkIfCommand(p3) -- line: 6
        -- upvalues: p2 (copy)
        if typeof(p3.name) == "string" and typeof(p3.run) == "function" then
            p2(p3)
        end
    end

    local function walk(p4) -- line: 11
        -- upvalues: p2 (copy), walk (copy)
        if typeof(p4) ~= "table" then
            return
        end

        if #p4 > 0 then
            for _, v1 in p4 do
                if typeof(v1) == "table" and v1.name == nil then
                    walk(v1)
                elseif typeof(v1.name) == "string" and typeof(v1.run) == "function" then
                    p2(v1)
                end
            end
        elseif typeof(p4.name) == "string" and typeof(p4.run) == "function" then
            p2(p4)
        end
    end

    walk(p1)
end
