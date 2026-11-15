-- https://lua.expert

local forEveryCommand = require(script.Parent.forEveryCommand)
local Log = require(script.Parent.Parent.Log)

return function(p1) -- line: 5
    -- upvalues: forEveryCommand (copy), Log (copy)
    return function(p2) -- line: 6
        -- upvalues: p1 (copy), forEveryCommand (copy), Log (copy)
        local v1 = p1:FindFirstChild(p2)

        if not (v1 and v1:IsA("ModuleScript")) then
            Log.debug((("'%*' has no child command module '%*'"):format(p1.Name, p2)))
        else
            local _require = require
            local ok, result = pcall(_require, v1)

            if ok then
                forEveryCommand(result, function(p3) -- line: 19
                    -- upvalues: p2 (copy)
                    if p3.sourceModule == nil then
                        p3.sourceModule = p2
                    end
                end)

                return result
            end

            Log.debug((("command module '%*.%*' failed to load: %*"):format(p1.Name, p2, result)))
        end

        return {}
    end
end
