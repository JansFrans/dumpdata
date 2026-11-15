-- https://lua.expert

local t1 = {}

local function scoreKey(p1, p2) -- line: 27
    local v1 = p2:lower()
    local v2 = #v1

    if v2 == 0 then
        return 0, 0
    end

    if v1 == p1 then
        return 4, 1
    end

    local v3 = v1:find(p1, 1, true)

    if v3 then
        if v3 == 1 then
            return 3, #p1 / v2
        end

        return 2, #p1 / v2 * (1 - (v3 - 1) / v2)
    end

    local n1 = 1
    local n2 = 1
    local v5

    for i = 1, #p1 do
        n2 = v1:find(p1:sub(i, i), n1, true)

        if not n2 then
            return 0, 0
        end

        v5 = v5 or n2
        n1 = n2 + 1
    end

    local v6 = n2 - (v5 or 1) + 1

    return 1, #p1 / v6 * (#p1 / v2) * 0.5
end

local function levenshtein(p3, p4) -- line: 61
    local v7 = #p3
    local v8 = #p4

    if v7 == 0 then
        return v8
    end

    if v8 == 0 then
        return v7
    end

    local t2 = {}

    for i = 0, v8 do
        t2[i] = i
    end

    for i = 1, v7 do
        local t3 = {
            [0] = i
        }
        local v9 = p3:sub(i, i)

        for j = 1, v8 do
            local v10 = if v9 == p4:sub(j, j) then 0 else 1

            t3[j] = math.min(t2[j] + 1, t3[j - 1] + 1, t2[j - 1] + v10)
        end

        t2 = t3
    end

    return t2[v8]
end

local function capList(p5, p6) -- line: 86
    if p6 and p6 < #p5 then
        local t4 = {}

        for i = 1, p6 do
            t4[i] = p5[i]
        end

        return t4
    end

    return p5
end

function t1.rank(p7, p8, p9) -- line: 99
    -- upvalues: scoreKey (copy)
    local v14 = p9 and p9.maxResults
    local v15 = (p7 or ""):gsub("^%s+", ""):gsub("%s+$", ""):lower()

    if #v15 == 0 then
        local t5 = {}

        for v16, v17 in p8 do
            table.insert(t5, {
                candidate = v17,
                order = v16
            })
        end

        table.sort(t5, function(p10, p11) -- line: 109
            local v18 = p10.candidate.isDefault == true

            if v18 ~= (p11.candidate.isDefault == true) then
                return v18
            end

            local v19 = p10.candidate.recency or 0
            local v20 = p11.candidate.recency or 0

            if v19 == v20 then
                return p10.order < p11.order
            end

            return v20 < v19
        end)

        local t7 = {}

        for _, v21 in t5 do
            table.insert(t7, v21.candidate)
        end

        local v22 = if v14 then v14 < #t7 else nil

        if not v14 or not v22 then
            return t7
        end

        local t8 = {}

        for i = 1, v14 do
            t8[i] = t7[i]
        end

        return t8
    end

    local t9 = {}

    for v23, v24 in p8 do
        local n3 = 0
        local n4 = 0
        local v25 = false

        for v26, v27 in v24.keys or { v24.text } do
            if typeof(v27) == "string" then
                local v28, v29 = scoreKey(v15, v27)

                if n3 < v28 or v28 == n3 and n4 < v29 then
                    n4 = v29
                    v25 = v26 == 1
                    n3 = v28
                end
            end
        end

        if n3 > 0 then
            table.insert(t9, {
                candidate = v24,
                tier = n3,
                score = n4,
                nameMatched = v25,
                order = v23
            })
        end
    end

    table.sort(t9, function(p12, p13) -- line: 149
        if p12.tier ~= p13.tier then
            return p12.tier > p13.tier
        end

        if p12.score ~= p13.score then
            return p12.score > p13.score
        end

        if p12.nameMatched ~= p13.nameMatched then
            return p12.nameMatched
        end

        local v30 = p12.candidate.recency or 0
        local v31 = p13.candidate.recency or 0

        if v30 == v31 then
            return p12.order < p13.order
        end

        return v31 < v30
    end)

    local t11 = {}

    for _, v32 in t9 do
        table.insert(t11, v32.candidate)
    end

    if v14 and v14 < #t11 then
        local t12 = {}

        for i = 1, v14 do
            t12[i] = t11[i]
        end

        return t12
    end

    return t11
end

function t1.didYouMean(p14, p15) -- line: 176
    -- upvalues: levenshtein (copy)
    local v33 = (p14 or ""):lower()

    if #v33 == 0 then
        return nil
    end

    local n5 = 1e999
    local v34

    for _, v35 in p15 do
        local v36 = levenshtein(v33, v35:lower())

        if v36 < n5 then
            n5 = v36
            v34 = v35
        end
    end

    local v37 = if v34 then n5 <= math.max(2, (math.floor(#v33 / 2))) else nil

    return if v34 and v37 then v34 else nil
end

function t1.aliasHit(p16, p17) -- line: 199
    -- upvalues: scoreKey (copy)
    if typeof(p17) ~= "table" or #p17 == 0 then
        return nil
    end

    local v40 = (p16 or ""):gsub("^%s+", ""):gsub("%s+$", ""):lower()

    if #v40 ~= 0 and (typeof(p17[1]) ~= "string" or not (scoreKey(v40, p17[1]) > 0)) then
        local n6 = 0
        local n7 = 0
        local v43

        for i = 2, #p17 do
            local v44 = p17[i]
            local v45, v46
            local v47 = n6
            local v48 = n7
            local v49 = v43

            if typeof(v44) == "string" then
                v45, v46 = scoreKey(v40, v44)

                if n6 < v45 or v45 == n6 and n7 < v46 then
                    v48 = v46
                    v49 = v44
                    v47 = v45
                end
            end

            n7 = v48
            v43 = v49
            n6 = v47
        end

        if n6 > 0 then
            return v43
        end
    end

    return nil
end

return t1
