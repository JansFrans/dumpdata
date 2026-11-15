-- https://lua.expert

local t1 = {
    "g",
    "h",
    "j",
    "l",
    "m",
    "n",
    "q",
    "r",
    "v",
    "w",
    "x",
    "y",
    "z",
    "G",
    "H",
    "J",
    "L",
    "M",
    "N",
    "Q",
    "R",
    "V",
    "W",
    "X",
    "Y",
    "Z"
}
local t2 = {
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "0"
}

local function getListForLimiter(p1) -- line: 13
    -- upvalues: t1 (copy), t2 (copy)
    if p1 == "Letters" then
        return t1
    end

    if p1 == "LettersAndNumbers" then
        local t3 = {}

        for _, v1 in t1 do
            table.insert(t3, v1)
        end

        for _, v2 in t2 do
            table.insert(t3, v2)
        end

        return t3
    end

    if p1 ~= nil then
        error((("Limiter '%*' does not exist!"):format(p1)))
    end

    local t4 = {}

    for _, v3 in t1 do
        table.insert(t4, v3)
    end

    for _, v4 in t2 do
        table.insert(t4, v4)
    end

    return t4
end

return function(p2, p3) -- line: 40
    -- upvalues: t1 (copy), t2 (copy)
    p2 = p2 or 8

    local t5 = {}
    local v6 = p3 ~= "Letters"

    for i = 1, p2 do
        if not v6 or i % 2 ~= 0 then
            table.insert(t5, t1[math.random(1, #t1)])
        else
            table.insert(t5, t2[math.random(1, #t2)])
        end
    end

    return table.concat(t5)
end
