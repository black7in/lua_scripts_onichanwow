local npcJinete = 90032
local npcExorcista = 90033

local spellRayo = 39123

local function OnSpawnExorcista(event, creature)
    local jinete = creature:GetNearestCreature(20, npcJinete)

    if jinete then
        creature:CastSpell(jinete, spellRayo, true)
    end
end

RegisterCreatureEvent(npcExorcista, 5, OnSpawnExorcista)