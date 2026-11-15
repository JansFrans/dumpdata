-- https://lua.expert

local loadCharacterStarted = require(script.Parent.loadCharacterStarted)

local function loadCharacter(p1) -- line: 8
    -- upvalues: loadCharacterStarted (copy)
    if p1 then
        loadCharacterStarted:Fire(p1)
        p1:LoadCharacter()
    end
end

return loadCharacter
