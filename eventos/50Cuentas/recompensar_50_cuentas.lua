require("helpers/functions")
local npcEntry = 70000

local archivo = "/root/server/bin/lua_scripts/eventos/50Cuentas/cuentas.data"
local cuentas = cargarVariablesEnv(archivo)

local function OnGossipHello(event, player, creature)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Reclamar mi recompensa", 0, 1)
    -- adios
    player:GossipMenuAddItem(0, "Adios", 2, 0)
    player:GossipSendMenu(1, creature)
end

local function OnGossipSelect(event, player, creature, sender, intid, code, menu_id)
    if intid == 1 then
        local estadoCuenta = cuentas[player:GetAccountName()]
        if estadoCuenta then
            if estadoCuenta == "reclamado" then
                player:SendUnitSay("Ya has reclamado tu recompensa.", 0)
            else
                player:SendUnitSay("Felicidades, has reclamado tu recompensa.", 0)
                player:AddItem(19429, 1)
                cuentas[player:GetAccountName()] = "reclamado"
                cambiarVariableEnv(archivo, player:GetAccountName(), "reclamado")
            end
        else
            player:SendUnitSay("Tu cuenta no esta en la lista de las primeras 50 cuentas Registradas.", 0)
        end
    end
    if intid == 2 then
        creature:SendUnitSay("Adios", 0)
    end
    player:GossipComplete()

end

RegisterCreatureGossipEvent(npcEntry, 1, OnGossipHello)
RegisterCreatureGossipEvent(npcEntry, 2, OnGossipSelect)

