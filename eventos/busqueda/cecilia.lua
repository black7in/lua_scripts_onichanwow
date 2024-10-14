local npcEntry = 70001

local spellOpenPortal = 67864
local spellTeleport = 51347

local estado = "inactivo" -- activo -- inactivo -- cargando
local lugar = 1

local tiempo = 0

local tiempoPista = 60000 -- 60 segundos
local pistaEnviada = false

local data = {
    [1] = {
        posicion = { map = 13, x = 21.772, y = -3.893, z = -144.708, o = 1.492},
        pista = "La primera pista es: 'El que no tiene boca, tiene que comer'",
        premio = "El premio es: 100 monedas de oro",
        idPremio = 123,
        cantidad = 1
    },
    [2] = {
        posicion = { map = 13, x = 29.576, y = -3.950, z = -144.709, o = 1.496},
        pista = "La primera pista es: 'El que no tiene boca, tiene que comer'",
        premio = "El premio es: 100 monedas de oro",
        idPremio = 123,
        cantidad = 1
    },
    [3] = {
        posicion = { map = 13, x = 38.726, y = -4.124, z = -144.709, o = 1.590},
        pista = "La primera pista es: 'El que no tiene boca, tiene que comer'",
        premio = "El premio es: 100 monedas de oro",
        idPremio = 123,
        cantidad = 1
    },
    [4] = {
        posicion = { map = 13, x = 48.036, y = -4.367, z = -144.709, o = 1.708},
        pista = "La primera pista es: 'El que no tiene boca, tiene que comer'",
        premio = "El premio es: 100 monedas de oro",
        idPremio = 123,
        cantidad = 1
    },
    [5] = {
        posicion = { map = 13, x = 56.708, y = -4.392, z = -144.709, o = 1.547},
        pista = "La primera pista es: 'El que no tiene boca, tiene que comer'",
        premio = "El premio es: 100 monedas de oro",
        idPremio = 123,
        cantidad = 1
    }
}

local function IniciarEvento(eventid, delay, repeats, player)
    player:RemoveEvents()
    SendWorldRaidNotification("|CFF00FF00El evento de Buscando a Cecilia ha comenzado|r")
    estado = "activo"
    local cecilia = PerformIngameSpawn( 1, npcEntry, data[lugar].posicion.map, 0, data[lugar].posicion.x, data[lugar].posicion.y, data[lugar].posicion.z, data[lugar].posicion.o )
    lugar = lugar + 1
end

local function CargarTeleportCecilia(eventid, delay, repeats, creature)
    creature:CastSpell(creature, spellOpenPortal, false)
    creature:SendUnitSay("Me has encontrado! la proxima no sera tan facil jejeje...", 0)
end

local function TeleportCecilia(eventid, delay, repeats, creature)
    creature:RemoveEvents()
    creature:CastSpell(creature, spellTeleport, false)
    creature:SendUnitSay("Hasta la proxima!", 0)
    creature:DespawnOrUnsummon(0)
    if lugar <= #data then
        estado = "activo"
        pistaEnviada = false
        tiempo = 0
        local cecilia = PerformIngameSpawn( 1, npcEntry, data[lugar].posicion.map, 0, data[lugar].posicion.x, data[lugar].posicion.y, data[lugar].posicion.z, data[lugar].posicion.o )
        lugar = lugar + 1
    end
end

local function CambiarLugarOFinalizar(eventid, delay, repeats, creature)
    if lugar > #data then
        estado = "inactivo"
        lugar = 1
        pistaEnviada = false
        tiempo = 0
        SendWorldRaidNotification("|CFF00FF00El evento de Buscando a Cecilia ha finalizado|r")
    else
        SendWorldMessage("Evento Busqueda: Cecilia se esta moviendo a otro lugar!")  
    end
end


local function OnGossipHello(event, player, creature)
    player:GossipClearMenu()
    if estado == "activo" then
        player:GossipMenuAddItem(0, "Hola! Recibir recompensa", 0, 2)
    end

    if estado == "cargando" then
        player:GossipMenuAddItem(0, "Adios! nos vemos en la siguiente parada", 0, 3)
    end
    player:GossipSendMenu(1, creature, 0)
end

local function OnGossipSelect(event, player, creature, sender, intid, code, menuid)
    if intid == 2 then
        estado = "cargando"
        creature:RemoveEvents()
        player:SendBroadcastMessage("Felicidades! Recompensa recibida")
        player:AddItem(data[lugar].idPremio, 1)
        SendWorldMessage("El jugador "..player:GetName().." ha encontrado a Cecilia y ha recibido su recompensa.")
        creature:RegisterEvent(CambiarLugarOFinalizar, 1000)
        creature:RegisterEvent(CargarTeleportCecilia, 1000)
        creature:RegisterEvent(TeleportCecilia, 6500)
    end
    if intid == 3 then
        player:SendBroadcastMessage("Adios! nos vemos en la siguiente parada")
    end
    player:GossipComplete()
end

local function OnAIUpdate(event, creature, diff)
    if estado == "activo" then
        if not pistaEnviada then
            SendWorldMessage(data[lugar].pista)
            pistaEnviada = true
        end
        if tiempo >= tiempoPista then
            tiempo = 0
            pistaEnviada = false
        end
        tiempo = tiempo + diff
    end
end

RegisterCreatureEvent(npcEntry, 7, OnAIUpdate)
RegisterCreatureGossipEvent(npcEntry, 1, OnGossipHello)
RegisterCreatureGossipEvent(npcEntry, 2, OnGossipSelect)

local cmd = "activar cecilia"

local function OnCommand(event, player, command)
    if command == cmd then
        if player:IsGM() and estado == "inactivo" then
            player:SendBroadcastMessage("Se ha activado el evento de Cecilia")
            player:RegisterEvent(IniciarEvento, 1000)
        end
        return false
    end
end RegisterPlayerEvent( 42, OnCommand )