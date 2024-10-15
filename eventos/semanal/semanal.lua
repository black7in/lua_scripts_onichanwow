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

local estado

local fechaInicio
local fechaFin
local horasObjetivo = 20

local data = {}

local premios = {
    { item = 38186, cantidad = 30 },
    { item = 49426, cantidad = 10 },
    { item = 47241, cantidad = 20 }
}


local archivo = "/root/server/bin/lua_scripts/eventos/semanal/estado.data"

local function OnGossipHello(event, player, creature)
    player:GossipClearMenu()
    if estado ~= "inactivo" then
        if not data[player:GetGUIDLow()] then
            local query = CharDBQuery("SELECT totaltime, premiado, totaltime_final FROM character_promo_semanal WHERE guid = " .. player:GetGUIDLow() .. ";")
            if query then
                local row = query:GetRow()
                if row then
                    data[player:GetGUIDLow()] = {
                        totaltime = row["totaltime"],
                        premiado = row["premiado"],
                        totaltime_final = row["totaltime_final"]
                    }
                end
            else -- sino hay registro entonces el jugador es nuevo y lo insertamos
                CharDBExecute("INSERT INTO character_promo_semanal (guid, totaltime, premiado) VALUES (" .. player:GetGUIDLow() .. ", 0, FALSE);")
                data[player:GetGUIDLow()] = {
                    totaltime = 0,
                    premiado = false,
                    totaltime_final = 0
                }
            end
        end
    end

    -- Descripcion del evento
    local msg = ""
    if estado ~= "inactivo" then
        msg = msg .. "Evento semanal, para ganar solo debes cumplir los siguientes objetivos:\n\n"
        msg = msg .. "Acumular " .. horasObjetivo .. " horas de juego.\n\nApartir de: ".. unixToDatetime(fechaInicio) .."\nHasta: " .. unixToDatetime(fechaFin) .. "\nCalendario del servidor.\n\n"    
        msg = msg .. "Recompesas:\n\n"
        local  itemLink = GetItemLink( premios[1].item )
        msg = msg .. "Premio 1: "..itemLink.." x10\n"
        msg = msg .. "Premio 2: Emblema de escarcha x10\n"
        msg = msg .. "Premio 3: Emblema de triunfo x20\n\n"
    end
    if estado == "inactivo" then
        msg = msg .. "El evento se encuentra inactivo, vuelve mas tarde para ver si ha comenzado."
    end
    if estado == "activo" then
        msg = msg .. "Si cumples estos requisitos, podrás reclamar tu recompensa aqui.\n\n"
        local totaltime_actual = player:GetTotalPlayedTime()
        totaltime_actual = totaltime_actual - data[player:GetGUIDLow()].totaltime
        msg = msg .. "Tus horas jugadas: " ..tiempoFormateado(totaltime_actual) .. "\n"
    end

    if estado == "expiro" then
        msg = msg .. "El evento ha finalizado, puedes reclamar tu premio aqui\n\n"
        -- Aqui tenemos un error totaltime no es una fecha es un tiempo en segundos jejeje lo que toca es hacer consulta consultando el nuevo totaltime jejeje y ahi sacar la diferencia
        if not data[player:GetGUIDLow()].totaltime_final then
            local query = CharDBQuery("SELECT totaltime_final FROM character_promo_semanal WHERE guid = " .. player:GetGUIDLow() .. ";")
            if query then
                local row = query:GetRow()
                if row then
                    data[player:GetGUIDLow()].totaltime_final = row["totaltime_final"]
                end
            else -- sino hay registro entonces el jugador es nuevo y lo insertamos
                data[player:GetGUIDLow()].totaltime_final = 0
            end
        end
        msg = msg .. "Tus horas jugadas: " ..tiempoFormateado(data[player:GetGUIDLow()].totaltime_final - data[player:GetGUIDLow()].totaltime) .. "\n"
    end

    if estado == "expiro" then
        player:GossipMenuAddItem(0, "Reclamar premio", 0, 1)
    end

    -- Solo para gms
    if player:IsGM() and estado == "inactivo" then
        player:GossipMenuAddItem(0, "Activar evento (Solo admins y encargados de eventos)", 0, 2)
    end
    if player:IsGM() and estado == "expiro" then
        player:GossipMenuAddItem(0, "Reiniciar evento (Solo admins y encargados de eventos)", 0, 4)
    end
    if player:IsGM() and estado == "activo" then
        player:GossipMenuAddItem(0, "Expirar evento (Solo admins y encargados de eventos)", 0, 5)
    end	
    -- hsata aqui fin de solo para gms
    player:GossipMenuAddItem(0, "Adios", 0, 3)
    player:SendGossipText(msg, npcEntry)
    player:GossipSendMenu(npcEntry, creature)
end

local function OnGossipSelect(event, player, creature, sender, intid, code, menuid)
    if intid == 1 then
        -- a estas alturas el jugador si o si esta registrado
        local tiempojugado = data[player:GetGUIDLow()].totaltime_final - data[player:GetGUIDLow()].totaltime
        if tiempojugado >= horasObjetivo * 3600 then
            if data[player:GetGUIDLow()].premiado == false then
                player:SendNotification("Felicidades! Recompensa recibida")
                --player:AddItem(38186, 30)
                --player:AddItem(49426, 10)
                --player:AddItem(47241, 20)
                CharDBExecute("UPDATE character_promo_semanal SET premiado = TRUE WHERE guid = " .. player:GetGUIDLow() .. ";")
                data[player:GetGUIDLow()].premiado = true
            else
                player:SendNotification("Ya has reclamado tu premio")
            end
        else
            player:SendNotification("No has cumplido con el objetivo")
        end        
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
            CharDBExecute("INSERT INTO character_promo_semanal (guid, totaltime, premiado) SELECT guid, totaltime, FALSE FROM characters;")
            estado = "activo"
            cambiarVariableEnv(archivo, "ESTADO", "activo")
        end
    end
    if intid == 3 then
        creature:SendUnitSay("Adios!", 0)
    end
    if intid == 4 then
        cambiarVariableEnv(archivo, "FECHA_INICIO", "")
        cambiarVariableEnv(archivo, "FECHA_FIN", "")
        estado = "inactivo"
        cambiarVariableEnv(archivo, "ESTADO", "inactivo")
        fechaInicio = nil
        fechaFin = nil
        CharDBExecute("DELETE FROM character_promo_semanal;")
        data = {}
        creature:SendUnitSay("Evento reiniciado", 0)
    end

    if intid == 5 then
        -- guardar el tiempototal con el que finalizo entonces modificar la base de datos
        -- character_promo_semanal y agregar un campo totaltime_final
        CharDBExecute("UPDATE character_promo_semanal cps JOIN characters c ON cps.guid = c.guid SET cps.totaltime_final = c.totaltime;;")
        estado = "expiro"
        cambiarVariableEnv(archivo, "ESTADO", "expiro")
        creature:SendUnitSay("Evento expirado", 0)
    end
    player:GossipComplete()
end

RegisterCreatureGossipEvent(npcEntry, 1, OnGossipHello)
RegisterCreatureGossipEvent(npcEntry, 2, OnGossipSelect)


local function load()
    local variables = cargarVariablesEnv(archivo)
    fechaFin = variables["FECHA_FIN"]
    fechaInicio = variables["FECHA_INICIO"]
    estado = variables["ESTADO"]

    if fechaInicio and fechaInicio ~= "" then
        fechaInicio = datetimeToUnix(fechaInicio)
    end

    if fechaFin and fechaFin ~= "" then
        fechaFin = datetimeToUnix(fechaFin)
    end

    if not estado or estado == "" then
        estado = "inactivo"
    end

    --if fechaFin and fechaInicio  and fechaInicio ~= "" and fechaFin ~= "" then
    --    estado = "activo"
    --end
end

load()