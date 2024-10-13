local npcEntry = 90022

local plataformaBuena = 900056
local plataformaMala = 900057

local spellOpenPortal = 67864

local estadoEvento = "inactivo"

-- posicion de la primera plataforma, el resto se agrgara pro filas y luego columnas
local posicionPrimeraPlataforma = {
    x = -10914.74,
    y = -1663.81,
    z = 184.1033,
    o = 3.0385
}

-- distancia entre plataformas a la derecha y atras
local distanciaEntrePlataformas = 6
local cantidadColumnas = 3
local cantidadFilas = 21

local function invocarPlataformas(creature)
    creature:SendAreaRaidNotification("El evento ha comenzado, buena suerte!", 150)
    local xOriginal = posicionPrimeraPlataforma.x
    local yOriginal = posicionPrimeraPlataforma.y
    local zOriginal = posicionPrimeraPlataforma.z
    local oOriginal = posicionPrimeraPlataforma.o

    for fila = 1, cantidadFilas do
        local x = xOriginal
        local y = yOriginal
        local z = zOriginal
        local o = oOriginal
        local columnaMala = math.random(cantidadColumnas) -- genera un número aleatorio para la columna mala
        for columna = 1, cantidadColumnas do
            local plataforma = plataformaBuena
            if columna == columnaMala then
                plataforma = plataformaMala -- usa la plataforma mala para la columna aleatoria
            end
            if columna == 1 then
                -- invocar primera plataforma de cada fila en la coordenada correcta
                creature:SummonGameObject(plataforma, x, y, z, o, 500)
            else
                -- obtener nueva coordenada hacia derecha
                x, y, z = obtenerNuevaCoordenada(x, y, z, o,
                                                 distanciaEntrePlataformas,
                                                 "derecha")
                -- invocar plataforma
                creature:SummonGameObject(plataforma, x, y, z, o, 500)
            end
        end
        -- obtener nueva coordenada hacia atras para la primera plataforma de la próxima fila
        xOriginal, yOriginal, zOriginal =
            obtenerNuevaCoordenada(xOriginal, yOriginal, zOriginal, oOriginal,
                                   distanciaEntrePlataformas, "atras")
    end
end

local function ActivarEvento(eventid, delay, repeats, creature)
    invocarPlataformas(creature)
    estadoEvento = "activo"
end

local function DesactivarEvento(eventid, delay, repeats, creature)
    -- Eliminar todas las plataformas
    local gameObjects = creature:GetGameObjectsInRange(150, plataformaBuena)
    for i, go in ipairs(gameObjects) do
        go:Despawn()
    end

    gameObjects = creature:GetGameObjectsInRange(150, plataformaMala)
    for i, go in ipairs(gameObjects) do
        go:Despawn()
    end
    creature:SendAreaRaidNotification("Tiempo Agotado, Empezar denuevo", 150)
    estadoEvento = "inactivo"
    creature:RemoveEvents()
end

local function BuenaSuerte(eventid, delay, repeats, creature)
    creature:SendUnitSay("Te deseo buena suerte, solo tienes 5 minutos!", 0)
end

local function QuedanCuatroMinutos(eventid, delay, repeats, creature)
    creature:SendAreaRaidNotification("Quedan 4 minutos para que las plataformas caigan!", 150)
end

local function QuedanTresMinutos(eventid, delay, repeats, creature)
    creature:SendAreaRaidNotification("Quedan 3 minutos para que las plataformas caigan!", 150)
end

local function QuedanDosMinutos(eventid, delay, repeats, creature)
    creature:SendAreaRaidNotification("Quedan 2 minutos para que las plataformas caigan!", 150)
end

local function QuedaUnMinuto(eventid, delay, repeats, creature)
    creature:SendAreaRaidNotification("Queda 1 minuto para que las plataformas caigan!", 150)
end

local function QuedanTreintaSegundos(eventid, delay, repeats, creature)
    creature:SendAreaRaidNotification("Quedan 30 segundos para que las plataformas caigan!", 150)
end

local function QuedanDiezSegundos(eventid, delay, repeats, creature)
    creature:SendAreaRaidNotification("Quedan 10 segundos para que las plataformas caigan!", 150)
end


local function OnGossipHello(event, player, creature)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Revelar el camino", 0, 1)
    -- adios
    player:GossipMenuAddItem(0, "Adios", 0, 2)
    -- Test invocar plataformas
    if player:IsGM() then
        --player:GossipMenuAddItem(0, "Invocar plataformas Test Only GM No tocar", 0, 3)
    -- test eliminar paltaformas
        --player:GossipMenuAddItem(0, "Eliminar plataformas Test Only GM No tocar", 0, 4)
    end
    player:GossipSendMenu(1, creature, 200)
end

local function OnGossipSelect(event, player, creature, sender, intid, code, menuid)
    if (intid == 1) then
        if estadoEvento == "inactivo" then
            creature:CastSpell(creature, spellOpenPortal, false)
            creature:RegisterEvent(BuenaSuerte, 2000)
            creature:RegisterEvent(ActivarEvento, 4000) -- Se activa el evento en 4 segundos
            creature:RegisterEvent(QuedanCuatroMinutos, 60000) -- Quedan 4 minutos
            creature:RegisterEvent(QuedanTresMinutos, 120000) -- Quedan 3 minutos
            creature:RegisterEvent(QuedanDosMinutos, 180000) -- Quedan 2 minutos
            creature:RegisterEvent(QuedaUnMinuto, 240000) -- Queda 1 minuto
            creature:RegisterEvent(QuedanTreintaSegundos, 270000) -- Quedan 30 segundos
            creature:RegisterEvent(QuedanDiezSegundos, 290000) -- Quedan 10 segundos
            creature:RegisterEvent(DesactivarEvento, 300000) -- Se desactiva el evento en 5 minutos
        else
            creature:SendUnitSay("El evento ya ha comenzado, espera a que termine.", 0)
        end
    end
    if (intid == 2) then
        creature:SendUnitSay("Adios! hasta pronto.", 0)
    end
    if (intid == 3) then
        invocarPlataformas(creature)
    end
    if (intid == 4) then
        -- Eliminar todas las plataformas
        local gameObjects = creature:GetGameObjectsInRange(150, plataformaBuena)
        for i, go in ipairs(gameObjects) do
            go:Despawn()
        end
    
        gameObjects = creature:GetGameObjectsInRange(150, plataformaMala)
        for i, go in ipairs(gameObjects) do
            go:Despawn()
        end
    end
    player:GossipComplete()
end

RegisterCreatureGossipEvent(npcEntry, 1, OnGossipHello)
RegisterCreatureGossipEvent(npcEntry, 2, OnGossipSelect)



local function PlataformaOnAIUpdate(event, go, diff)
    if estadoEvento == "activo" then
        local playersInRange = go:GetPlayersInRange(-1)
        if #playersInRange > 0 then go:Despawn() end
    end
end

RegisterGameObjectEvent(plataformaMala, 1, PlataformaOnAIUpdate)
