local npcEntry = 70001

local spellOpenPortal = 67864
local spellTeleport = 51347

local estado = "inactivo" -- activo -- inactivo -- cargando

local data = {
    [1] = {
        posicion = {x = -10914.74, y = -1663.81, z = 184.1033, o = 3.0385},
        pista = "La primera pista es: 'El que no tiene boca, tiene que comer'",
        premio = "El premio es: 100 monedas de oro"
        idPremio = 123;
    },
    [2] = {
        posicion = {x = -10914.74, y = -1663.81, z = 184.1033, o = 3.0385},
        pista = "La primera pista es: 'El que no tiene boca, tiene que comer'",
        premio = "El premio es: 100 monedas de oro"
        idPremio = 123;
    },
    [3] = {
        posicion = {x = -10914.74, y = -1663.81, z = 184.1033, o = 3.0385},
        pista = "La primera pista es: 'El que no tiene boca, tiene que comer'",
        premio = "El premio es: 100 monedas de oro"
        idPremio = 123;
    },
    [4] = {
        posicion = {x = -10914.74, y = -1663.81, z = 184.1033, o = 3.0385},
        pista = "La primera pista es: 'El que no tiene boca, tiene que comer'",
        premio = "El premio es: 100 monedas de oro"
        idPremio = 123;
    },
    [5] = {
        posicion = {x = -10914.74, y = -1663.81, z = 184.1033, o = 3.0385},
        pista = "La primera pista es: 'El que no tiene boca, tiene que comer'",
        premio = "El premio es: 100 monedas de oro"
        idPremio = 123;
    }
}


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
        end
        return false
    end
end RegisterPlayerEvent( 42, OnCommand )