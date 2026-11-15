-- https://lua.expert

local Modules = script:FindFirstAncestor("HD Admin").Core.MainModule.Value.Modules

require(Modules.Objects.Task)

local Prompt = require(Modules.Prompt)

return function(p1, p2, p3, p4) -- line: 6
    -- upvalues: Modules (copy), Prompt (copy)
    local v1 = p3
    local Name = p1.Name

    if p3 <= 0 then
        Prompt.error(p2.caller, (("Invalid %*Id"):format(Name)))
    else
        local config, caller = p2.config, p2.caller
        local isTypeAsync = require(Modules.VerifyUtil.isTypeAsync)
        local v2, v3 = require(Modules.VerifyUtil.verifyConfigLists)(caller, config, p3)

        if v2 then
            if v3 == p3 then
                v3 = p3
            else
                v1 = v3
                Prompt.info(caller, (("%*Id %* was replaced with %* by the game's developer"):format(Name, p3, v3)))
            end

            if isTypeAsync(v3, p1) then
                local v4 = p1 == Enum.AssetType.Gear
                local ok, result

                if v4 then
                    local InsertService = game:GetService("InsertService")

                    local function v5() -- line: 35
                        -- upvalues: v1 (ref), InsertService (copy)
                        return InsertService:LoadAsset(v1)
                    end

                    ok, result = pcall(v5)
                else
                    local AssetService = game:GetService("AssetService")

                    local function v6() -- line: 40
                        -- upvalues: v1 (ref), AssetService (copy)
                        return AssetService:LoadAssetAsync(v1)
                    end

                    ok, result = pcall(v6)
                end

                if not ok or typeof(result) ~= "Instance" then
                    Prompt.error(caller, (("Failed to load %* %*: %*"):format(Name, v1, result)))
                else
                    local v7 = result:GetChildren()[1]

                    if v7 then
                        local Tool = if v4 then v7:IsA("Tool") else nil

                        if not v4 or Tool then
                            p4(v7)
                        else
                            Prompt.error(caller, (("Asset %* is not a gear tool"):format(v1)))
                        end
                    else
                        Prompt.error(caller, (("No item found in %* Asset"):format(Name)))
                    end

                    result:Destroy()
                end
            else
                Prompt.error(caller, (("ID is not a %* Asset"):format(Name)))
            end
        else
            Prompt.error(caller, (tostring(v3)))
        end
    end
end
