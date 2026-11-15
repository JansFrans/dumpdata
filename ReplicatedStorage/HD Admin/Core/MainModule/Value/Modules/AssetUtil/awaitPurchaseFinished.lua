-- https://lua.expert

local MarketplaceService = game:GetService("MarketplaceService")
local t1 = { "PromptPurchaseFinished", "PromptGamePassPurchaseFinished", "PromptProductPurchaseFinished", "PromptBundlePurchaseFinished", "PromptBulkPurchaseFinished" }

return function(p1) -- line: 14
    -- upvalues: MarketplaceService (copy), t1 (copy)
    local thread = coroutine.running()
    local t2 = {}
    local v1 = false

    local function done() -- line: 18
        -- upvalues: thread (copy), t2 (copy), v1 (ref)
        if v1 then
            return
        end

        v1 = true

        for _, v2 in t2 do
            v2:Disconnect()
        end

        task.spawn(thread)
    end

    for _, v3 in t1 do
        table.insert(t2, MarketplaceService[v3]:Connect(done))
    end

    task.delay(p1 or 60, done)
    coroutine.yield()
end
