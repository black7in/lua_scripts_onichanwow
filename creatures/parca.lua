local npcEntry = 100003

local function OnSpawn(evento, creature)
    creature:SetScale(2)
end

RegisterCreatureEvent( npcEntry, 5, OnSpawn )