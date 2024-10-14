local npcEntry = 70001

local spellOpenPortal = 67864
local spellTeleport = 51347

local estado = "inactivo" -- activo -- inactivo -- cargando

local data = {
    [1] = {
        posicion = { x = 21.772, y = -3.893, z = -144.708, o = 1.492},
        pista = "La primera pista es: 'El que no tiene boca, tiene que comer'",
        premio = "El premio es: 100 monedas de oro",
        idPremio = 123
    },
    [2] = {
        posicion = { x = 29.576, y = -3.950, z = -144.709, o = 1.496},
        pista = "La primera pista es: 'El que no tiene boca, tiene que comer'",
        premio = "El premio es: 100 monedas de oro",
        idPremio = 123
    },
    [3] = {
        posicion = { x = 38.726, y = -4.124, z = -144.709, o = 1.590},
        pista = "La primera pista es: 'El que no tiene boca, tiene que comer'",
        premio = "El premio es: 100 monedas de oro",
        idPremio = 123
    },
    [4] = {
        posicion = { x = 48.036, y = -4.367, z = -144.709, o = 1.708},
        pista = "La primera pista es: 'El que no tiene boca, tiene que comer'",
        premio = "El premio es: 100 monedas de oro",
        idPremio = 123
    },
    [5] = {
        posicion = { x = 56.708, y = -4.392, z = -144.709, o = 1.547},
        pista = "La primera pista es: 'El que no tiene boca, tiene que comer'",
        premio = "El premio es: 100 monedas de oro",
        idPremio = 123
    }
}



local function IniciarEvento(eventid, delay, repeats, player)
    player:RemoveEvents()
    SendWorldRaidNotification("|CFF00FF00El evento de Buscando a Cecilia ha comenzado|r")
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
        player:SendBroadcastMessage("Recompensa recibida")
    end
    if intid == 3 then
        player:SendBroadcastMessage("Adios! nos vemos en la siguiente parada")
    end
    player:GossipComplete()
end

local function OnAIUpdate(event, creature, diff)
    if estado == "activo" then
        --print("estado activo")
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