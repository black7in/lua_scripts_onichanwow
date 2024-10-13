local npcEntry = 90021

local function OnGossipHello(event, player, creature)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Teleportar para a próxima plataforma", 0, 1)
    player:GossipSendMenu(1, creature, 200)
end

local function OnGossipSelect(event, player, creature, sender, intid, code, menuid)
    if (intid == 1) then
        local x, y, z = player:GetLocation()
        player:Teleport(0, x, y, z + 10)
    end
end

RegisterCreatureGossipEvent(npcEntry, 1, OnGossipHello)
RegisterCreatureGossipEvent(npcEntry, 2, OnGossipSelect)