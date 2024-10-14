--[[
 "Evento semanal, para ganar solo debes cumplir los siguientes objetivos:\n\n";
 "Acumular 20 horas de juego: apartir del dia Miercoles desde las 3:00 horas, hasta las 23:59 horas del dia Domingo 25/06/2023 Calendario del servidor.\n\n";

 "Si cumples estos requisitos, podrás reclamar tu recompensa aqui mismo una vez finalizado el tiempo.\n\n";
 "Progreso:\nNombre: " << player->GetName() << "\nHoras jugadas: " << GetTimePlayedString(GetTimePlayed(player))/*<< "\nTotalKills: "<< GetTotalKillPlayed(player)*/;
 "\n\nPremio 1: " << sServerSystem->GetItemIcon(38186, 20, 20, 0, -1) << sServerSystem->GetItemLink(38186) << "\nCantidad: " << 30;
 "\n\nPremio 2: " << sServerSystem->GetItemIcon(49426, 20, 20, 0, -1) << sServerSystem->GetItemLink(49426) << "\nCantidad: " << 10;
 "\n\nPremio 3: " << sServerSystem->GetItemIcon(47241, 20, 20, 0, -1) << sServerSystem->GetItemLink(47241) << "\nCantidad: " << 20;

]]
require("helpers/functions")

local npcEntry = 70002

local estado = "inactivo"

local fechaInicio
local fechaFin
local horasObjetivo = 20


local archivo = "/root/server/bin/lua_scripts/eventos/semanal/estado.data"

local function verificarEstado()
    local fechaActual = os.time()
    if fechaFin then
        if fechaActual >= fechaFin and estado == "activo" then -- expiro el tiempo
            estado = "expiro"
        end
    end
end

local function OnGossipHello(event, player, creature)
    player:GossipClearMenu()
    verificarEstado()
    if estado == "expiro" then
        player:GossipMenuAddItem(0, "Reclamar premio", 0, 1)
    end
    if player:IsGM() and estado == "inactivo" then
        player:GossipMenuAddItem(0, "Activar evento", 0, 2)
    end
    player:GossipMenuAddItem(0, "Adios", 0, 3)
    player:GossipSendMenu(1, creature, 0)
end

local function OnGossipSelect(event, player, creature, sender, intid, code, menuid)
    if intid == 1 then
        player:SendBroadcastMessage("Felicidades! Recompensa recibida")
    end
    if intid == 2 then
        if player:IsGM() and estado == "inactivo" then
            player:SendBroadcastMessage("Se ha activado el evento semanal")
            local msg = "|CFF00FF00El evento semanal ha comenzado! Para ganar solo debes cumplir " .. horasObjetivo .. " horas de juego apartir de ahora. El evento finaliza el " .. unixToDatetime(fechaFin) .. ". Buena suerte!|r"
            SendWorldRaidNotification(msg)
            fechaInicio = os.time()
            fechaTabla = os.date("*t", fechaInicio)  -- convierte la fecha a una tabla
            fechaTabla.day = fechaTabla.day + 5  -- aumenta el día en 5
            fechaFin = os.time(fechaTabla)  -- convierte la tabla de nuevo a una fecha
            --guardarVariable(unixToDatetime(fechaInicio), archivo)
            cambiarVariableEnv(archivo, "FECHA_INICIO", unixToDatetime(fechaInicio))
            cambiarVariableEnv(archivo, "FECHA_FIN", unixToDatetime(fechaFin))
            estado = "activo"
        end
    end
    if intid == 3 then
        player:SendUnitSay("Adios!", 0)
    end
    player:GossipComplete()
end

RegisterCreatureGossipEvent(npcEntry, 1, OnGossipHello)
RegisterCreatureGossipEvent(npcEntry, 2, OnGossipSelect)


local function load()
    local variables = cargarVariablesEnv(archivo)
    fechaFin = variables["FECHA_FIN"]
    fechaInicio = variables["FECHA_INICIO"]

    if fechaInicio then
        fechaInicio = datetimeToUnix(fechaInicio)
    end

    if fechaFin then
        fechaFin = datetimeToUnix(fechaFin)
    end

    if fechaFin and fechaInicio then
        estado = "activo"
    end
end

load()