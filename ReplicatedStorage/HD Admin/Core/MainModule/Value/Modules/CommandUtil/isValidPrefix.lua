-- https://lua.expert

local t1 = {}

for _, v1 in {
        "!",
        "/",
        ".",
        "?",
        "~",
        "-",
        "$",
        "%",
        "^",
        "&",
        "*",
        "+",
        "=",
        "<",
        ">",
        "|",
        ":",
        ";",
        ",",
        "@",
        "#"
    } do
    t1[v1] = true
end

return function(p1) -- line: 6
    -- upvalues: t1 (copy)
    return t1[p1] == true
end
