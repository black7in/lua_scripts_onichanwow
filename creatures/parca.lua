local npcEntry = 100003

local function OnSpawn(evento, creature)
    creature:SetScale(2)
end

RegisterCreatureEvent( npcEntry, 5, OnSpawn )

local mensajes = {
    "¡Ven, alma valiente! Cruza el portal de Halloween… si tienes el valor de enfrentar lo que te espera.",
    "Las sombras te llaman… el portal está abierto. ¿Te atreves a reclamar los premios o serás su próxima víctima?",
    "¡No todos sobreviven el portal de Halloween! ¿Te atreves a probar tu suerte con las misiones de la oscuridad?",
    "La noche de Halloween ha llegado. El portal te espera… pero no todos regresan con vida.",
    "Atrévete a cruzar el portal... premios te esperan, pero la oscuridad también tiene un precio."
}

local tiempo = 0
local tiempoParaMensaje = 60000 -- 1 minuto para volver a enviar el mensaje
local mensajeEnviado = false

local function OnAIUpdate(event, creature, diff)
    if mensajeEnviado == false then
        -- calcular un mensaje aleatorio
        local mensaje = mensajes[math.random(1, #mensajes)]
        creature:SendUnitSay(mensaje, 0)
        mensajeEnviado = true
    end

    if tiempo >= tiempoParaMensaje then
        mensajeEnviado = false
        tiempo = 0
    end

    tiempo = tiempo + diff
end

RegisterCreatureEvent(npcEntry, 7, OnAIUpdate)