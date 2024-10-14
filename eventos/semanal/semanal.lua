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

local data = {}


local archivo = "/root/server/bin/lua_scripts/eventos/semanal/estado.data"

local function verificarEstado()
    local fechaActual = os.time()
    if fechaFin and fechaFin ~= "" then
        if fechaActual >= fechaFin then -- expiro el tiempo
            estado = "expiro"
        end
    end
end

local function prepararBaseDeDatos(eventid, delay, repeats, creature)
    CharDBExecute("INSERT INTO character_promo_semanal (guid, totaltime, premiado) SELECT guid, totaltime, FALSE FROM characters;")
    estado = "activo"
    creature:RemoveEvents()
end


local function OnGossipHello(event, player, creature)
    player:GossipClearMenu()
    verificarEstado()
    if estado ~= "inactivo" then
        if not data[player:GetGUIDLow()] then
            local query = CharDBQuery("SELECT totaltime, premiado FROM character_promo_semanal WHERE guid = " .. player:GetGUIDLow() .. ";")
            if query then
                local row = query:GetRow()
                if row then
                    data[player:GetGUIDLow()] = {
                        totaltime = row["totaltime"],
                        premiado = row["premiado"]
                    }
                end
            end
        end
    end

    -- Descripcion del evento
    local msg = "Evento semanal, para ganar solo debes cumplir los siguientes objetivos:\n\n"
    msg = msg .. "Acumular " .. horasObjetivo .. " horas de juego: apartir de ".. unixToDatetime(fechaInicio) ..", hasta " .. unixToDatetime(fechaFin) .. " Calendario del servidor.\n\n"
    if estado == "activo" then
        msg = msg .. "Si cumples estos requisitos, podrás reclamar tu recompensa aqui\n"
        msg = msg .. "Tus horas jugadas: " ..tiempoTranscurridoString(data[player:GetGUIDLow()].totaltime) .. "\n"
    end
    if estado == "expiro" then
        msg = msg .. "El evento ha finalizado, puedes reclamar tu premio aqui\n"
        msg = msg .. "Tus horas jugadas: " ..tiempoTranscurridoEntre(data[player:GetGUIDLow()].totaltime, fechaFin) .. "\n"
    end
    if estado == "expiro" then
        player:GossipMenuAddItem(0, "Reclamar premio", 0, 1)
    end
    if player:IsGM() and estado == "inactivo" then
        player:GossipMenuAddItem(0, "Activar evento", 0, 2)
    end
    if player:IsGM() and estado == "expiro" then
        player:GossipMenuAddItem(0, "Reiniciar evento", 0, 4)
    end
    player:GossipMenuAddItem(0, "Adios", 0, 3)
    player:SendGossipText(msg, npcEntry)
    player:GossipSendMenu(npcEntry, creature)
end

local function OnGossipSelect(event, player, creature, sender, intid, code, menuid)
    if intid == 1 then
        player:SendBroadcastMessage("Felicidades! Recompensa recibida")
    end
    if intid == 2 then
        if player:IsGM() and estado == "inactivo" then
            player:SendBroadcastMessage("Se ha activado el evento semanal")
            fechaInicio = os.time()
            fechaTabla = os.date("*t", fechaInicio)  -- convierte la fecha a una tabla
            fechaTabla.day = fechaTabla.day + 5  -- aumenta el día en 5
            fechaFin = os.time(fechaTabla)  -- convierte la tabla de nuevo a una fecha
            --guardarVariable(unixToDatetime(fechaInicio), archivo)
            cambiarVariableEnv(archivo, "FECHA_INICIO", unixToDatetime(fechaInicio))
            cambiarVariableEnv(archivo, "FECHA_FIN", unixToDatetime(fechaFin))
            local msg = "|CFF00FF00El evento semanal ha comenzado! Para ganar solo debes cumplir " .. horasObjetivo .. " horas de juego apartir de ahora. El evento finaliza el " .. unixToDatetime(fechaFin) .. ". Buena suerte!|r"
            SendWorldRaidNotification(msg)
            SaveAllPlayers()
            creature:RegisterEvent(prepararBaseDeDatos, 1000) -- tiempo para el sistema para guardar los datos de los jugadores
        end
    end
    if intid == 3 then
        player:SendUnitSay("Adios!", 0)
    end
    if intid == 4 then
        cambiarVariableEnv(archivo, "FECHA_INICIO", "")
        cambiarVariableEnv(archivo, "FECHA_FIN", "")
        estado = "inactivo"
        fechaInicio = nil
        fechaFin = nil
        CharDBExecute("DELETE FROM character_promo_semanal;")
        creature:SendUnitSay("Evento reiniciado", 0)
    end
    player:GossipComplete()
end

RegisterCreatureGossipEvent(npcEntry, 1, OnGossipHello)
RegisterCreatureGossipEvent(npcEntry, 2, OnGossipSelect)


local function load()
    local variables = cargarVariablesEnv(archivo)
    fechaFin = variables["FECHA_FIN"]
    fechaInicio = variables["FECHA_INICIO"]

    if fechaInicio and fechaInicio ~= "" then
        fechaInicio = datetimeToUnix(fechaInicio)
    end

    if fechaFin and fechaFin ~= "" then
        fechaFin = datetimeToUnix(fechaFin)
    end

    if fechaFin and fechaInicio  and fechaInicio ~= "" and fechaFin ~= "" then
        estado = "activo"
    end
end

load()