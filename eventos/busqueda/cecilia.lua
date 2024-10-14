local npcEntry = 70001

local spellOpenPortal = 67864

local estado = "inactivo" -- activo -- inactivo -- cargando


local function OnGossipHello(event, player, creature)
    player:GossipClearMenu()

    if player:IsGM() then
        player:GossipMenuAddItem(0, "Activar Evento", 0, 1)
    end
    if estado == "activo" then
        player:GossipMenuAddItem(0, "Hola! Recibir recompensa", 0, 2)
    end

    if estado == "cargando" then
        player:GossipMenuAddItem(0, "Adios! nos vemos en la siguiente parada", 0, 3)
    end
    player:GossipSendMenu(1, creature, 0)
end

local function OnGossipSelect(event, player, creature, sender, intid, code, menuid)
    if (intid == 1) then
        creature:CastSpell(creature, spellOpenPortal, false)
        player:GossipComplete()
    end
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
        SendWorldMessage("Se ha activado el evento de Cecilia")
        return false
    end
end RegisterPlayerEvent( 42, OnCommand )