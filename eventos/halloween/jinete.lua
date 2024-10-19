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

local tiempo = 0

local mensajeEnviado = false
local tiempoParaMensaje = 60000 -- 1 minuto para volver a enviar el mensaje

local frases_jinete = {
    "¡Monjes insignificantes! Sus cadenas no podrán contenerme por mucho tiempo...",
    "Pueden retrasar lo inevitable, pero mi poder es superior... y pronto lo sabrán.",
    "¡Su fe es débil! El momento de mi liberación está cerca, y entonces desataré mi furia.",
    "Las sombras ya susurran mi nombre... pronto estaré libre, y ninguno de ustedes estará a salvo.",
    "Nada puede detener lo que viene... mi liberación es solo cuestión de tiempo.",
    "Sus encantos no durarán... cuando quiebren, desataré la oscuridad que han tratado de contener.",
    "¡Su fin se aproxima! Los monjes caerán y yo volveré a cabalgar en busca de venganza."
}

local function OnAIUpdateJinete(event, creature, diff)
    if mensajeEnviado == false then
        -- calcular un mensaje aleatorio
        local mensaje = frases_jinete[math.random(1, #frases_jinete)]
        creature:SendUnitSay(mensaje, 0)
        mensajeEnviado = true
    end

    if tiempo >= tiempoParaMensaje then
        mensajeEnviado = false
        tiempo = 0
    end

    tiempo = tiempo + diff
end

RegisterCreatureEvent(npcJinete, 7, OnAIUpdateJinete)