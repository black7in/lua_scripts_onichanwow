--[[
 "Evento semanal, para ganar solo debes cumplir los siguientes objetivos:\n\n";
 "Acumular 20 horas de juego: apartir del dia Miercoles desde las 3:00 horas, hasta las 23:59 horas del dia Domingo 25/06/2023 Calendario del servidor.\n\n";

 "Si cumples estos requisitos, podrás reclamar tu recompensa aqui mismo una vez finalizado el tiempo.\n\n";
 "Progreso:\nNombre: " << player->GetName() << "\nHoras jugadas: " << GetTimePlayedString(GetTimePlayed(player))/*<< "\nTotalKills: "<< GetTotalKillPlayed(player)*/;
 "\n\nPremio 1: " << sServerSystem->GetItemIcon(38186, 20, 20, 0, -1) << sServerSystem->GetItemLink(38186) << "\nCantidad: " << 30;
 "\n\nPremio 2: " << sServerSystem->GetItemIcon(49426, 20, 20, 0, -1) << sServerSystem->GetItemLink(49426) << "\nCantidad: " << 10;
 "\n\nPremio 3: " << sServerSystem->GetItemIcon(47241, 20, 20, 0, -1) << sServerSystem->GetItemLink(47241) << "\nCantidad: " << 20;

]]
local npcEntry = 70002

local estado = "inactivo"

local fechaInicio
local fechaFin = "15/10/2023 11:59:59"



local function OnGossipHello(event, player, creature)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Reclamar premio", 0, 1)
    player:GossipSendMenu(1, creature, 0)
end

local function OnGossipSelect(event, player, creature, sender, intid, code, menuid)
    if intid == 1 then
        player:SendBroadcastMessage("Felicidades! Recompensa recibida")
        player:AddItem(38186, 30)
        player:AddItem(49426, 10)
        player:AddItem(47241, 20)
    end
    player:GossipComplete()
end

RegisterCreatureGossipEvent(npcEntry, 1, OnGossipHello)
RegisterCreatureGossipEvent(npcEntry, 2, OnGossipSelect)

local cmd = "activar semanal"

local function OnCommand(event, player, command)
    if command == cmd then
        if player:IsGM() and estado == "inactivo" then
            player:SendBroadcastMessage("Se ha activado el evento semanal")
            fechaInicio = os.time()
            print("Fecha inicio: "..unixToDatetime(fechaInicio))
            print("Fecha fin: "..datetimeToUnix(fechaFin))
            estado = "activo"
        end
        return false
    end
end RegisterPlayerEvent( 42, OnCommand )