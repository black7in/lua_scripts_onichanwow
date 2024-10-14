-- haremos un comando para escribir en un archivo de texto la posicion del jugador
local cmd = "posi"

local function OnCommand(event, player, command, chatHandler)
    if command == cmd then
        if player:IsGM() then
        local map = player:GetMapId()
        local x = string.format("%.3f", player:GetX())
        local y = string.format("%.3f", player:GetY())
        local z = string.format("%.3f", player:GetZ())
        local o = string.format("%.3f", player:GetO())

        local file = io.open("/root/server/bin/lua_scripts/posicion.txt", "a")

        -- Verificar si el archivo se abrió correctamente
        if file then
            file:write(
                "{ x = " .. x .. ", y = " .. y .. ", z = " .. z .. ", o = " .. o .. "}\n")
            file:close()

            player:SendBroadcastMessage("Posicion guardada en el archivo posicion.txt")
        else
            player:SendBroadcastMessage("Error al guardar la posicion")
        end
    end

        return false
    end
end
RegisterPlayerEvent(42, OnCommand)
