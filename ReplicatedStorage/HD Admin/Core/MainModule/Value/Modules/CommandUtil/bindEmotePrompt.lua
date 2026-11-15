-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Prompt = require(Modules.Prompt)

require(Modules.Objects.Task)

return function(p1, p2, p3, p4, p5) -- line: 12
    -- upvalues: Modules (copy), Prompt (copy)
    local Emotes = require(Modules.Parent.Services.Emotes)
    local Assets = require(Modules.Parent.Services.Assets)
    local v1 = require(Modules.Objects.User).getUser(p2)

    Assets.permitAsset(p3)

    local emoteAnimation = p1.extra.emoteAnimation
    local v2 = emoteAnimation and emoteAnimation.AnimationId
    local v3 = if typeof(v2) == "string" then tonumber(v2:match("%d+")) else nil
    local v4 = p5 == true

    p1:bindPrompt({
        deactivate = v4,
        rerun = not v4,
        args = { "AnimationSpeed" },
        onChange = function(_, p7) -- onChange | line: 28
            -- upvalues: p1 (copy)
            p1.extra.emoteSpeed = p7

            local emoteAnimation = p1.extra.emoteAnimation

            if emoteAnimation and emoteAnimation.Parent then
                emoteAnimation:SetAttribute("HDSpeed", p7)
            end
        end,
        iconButtons = {
            {
                component = "Favourite",
                assetId = p3,
                active = Emotes.isFavorited(v1, p3),
                onAction = function(p8) -- onAction | line: 41
                    -- upvalues: p2 (copy), p3 (copy), p4 (copy), Emotes (copy), v1 (copy), Prompt (copy)
                    if p8 and p4 and not Emotes.getEmoteById(p3) then
                        Emotes.addEmoteAsync({
                            emoteId = p3,
                            originalName = p4
                        })
                    end

                    local v5, v6 = Emotes.setFavorite(v1, p3, p8)

                    if not v5 then
                        Prompt.warn(p2, (tostring(v6)))
                    end
                end
            },
            {
                component = "Unlock",
                assetId = p3,
                emoteName = p4,
                animationId = v3
            }
        }
    })
end
