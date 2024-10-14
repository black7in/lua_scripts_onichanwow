local NpcId = 90023
local MenuId = 123 -- Unique ID to recognice player gossip menu among others

-- Rango de NPCS previamente creados en la base de datos creature_template
local entryMax = 70010
local entryMin = 70000

-- CONFIGURACION DE LA ROPA
local casco = 0
local hombreras = 0
local camisa = 0
local pechera = 0
local cinturon = 0
local pantalones = 0
local botas = 0
local brazaletes = 0
local guantes = 0
local capa = 0
local tabardo = 0
local arma1 = 0
local arma2 = 0
local arma3 = 0

-- -------------------------
local personaje = ''
local nombre = ''
local subnombre = ''
local capucha = true

local emoteCasting = 173
local emoteFinishCast = 439

local estado = ''
local entry = '0'
local outfit = '0'
local guid = '0'
local errores = false

local tiempo = 0
local tiempoBuscandoPersonaje = 4000
local buscandoPersonaje = false

local tiempoPersonajeEncontrado = 2000
local personajeEncontradoDicho = false

local tiempoCreandoPersonaje = 5000
local creandoPersonajeDicho = false

local tiempoPersonajeCreado = 4000
local personajeCreadoDicho = false

local tiempoRecordatorio = 2000
local recordatorioDicho = false

local queryBuscarPersonaje = false
local queryCrearPersonaje = false

local raza = 0
local clase = 0
local genero = 0
local piel = 0
local cara = 0
local pelo = 0
local color = 0
local barba = 0

local function OnGossipHello(event, player, object)
    reset()
    if not player:IsGM() then
        player:GossipClearMenu() -- required for player gossip
        object:SendUnitSay("¡Lo siento! No tienes permisos para usarme.", 0)
        return
    end

    player:GossipClearMenu() -- required for player gossip
    player:GossipMenuAddItem(0, "Crear un NPC a partir de tu personaje.", 1, 1)
    player:GossipMenuAddItem(0, "Ver lista de NPC creados.", 7, 1)
    player:GossipSendMenu(1, object, MenuId) -- MenuId required for player gossip
end

local function OnGossipSelect(event, player, object, sender, intid, code, menuid)
    if (intid == 1) then
        personaje = player:GetName()
        player:GossipMenuAddItem(0,
                                 "Escribir el nombre del Npc.",
                                 1, 2, true, nil)
        player:GossipMenuAddItem(0, "Cancelar", 1, 3)
        player:GossipSendMenu(1, object, MenuId)
    elseif (intid == 2) then
        nombre = code
        player:GossipMenuAddItem(0, "Escribir el SubNombre del Npc.", 1, 4,
                                 true, nil)
        player:GossipMenuAddItem(0, "Cancelar", 1, 3)

        player:GossipSendMenu(1, object, MenuId)
    elseif (intid == 4) then
        subnombre = code
        estado = 'buscandoDatosPersonaje'
        obtenerRopa(player)
        player:GossipComplete()
    elseif (intid == 3) then
        reset()
        player:GossipComplete()
    elseif (intid == 7) then

    end
end

local function creatureAI(event, creature, diff)
    if (estado == 'buscandoDatosPersonaje') then
        if (buscandoPersonaje == false) then
            creature:SendUnitSay('Veamos... buscare tus datos...', 0)
            buscandoPersonaje = true
            tiempo = 0
            buscarPersonaje(creature)
        end
        if (tiempo > tiempoPersonajeEncontrado) then
            if (queryBuscarPersonaje == true) then
                estado = 'personajeEncontrado'
                tiempo = 0
            end
        end

        creature:EmoteState(emoteCasting)
    end

    if (estado == 'personajeEncontrado') then
        if (personajeEncontradoDicho == false) then
            creature:SendUnitSay('He encontrado el personaje ' .. personaje ..
                                     ' en la base de datos.', 0)
            personajeEncontradoDicho = true
            tiempo = 0
        end
        if (tiempo > tiempoBuscandoPersonaje) then
            estado = 'creandoPersonaje'
            tiempo = 0
        end

        creature:EmoteState(emoteCasting)
    end

    if (estado == 'creandoPersonaje') then
        if (creandoPersonajeDicho == false) then
            creature:SendUnitSay('Estoy creando el NPC...', 0)
            creandoPersonajeDicho = true
            tiempo = 0
            crearPersonaje(creature)
        end
        if (tiempo > tiempoCreandoPersonaje) then
            if (queryCrearPersonaje == true) then
                estado = 'personajeCreado'
                tiempo = 0
            end
        end

        creature:EmoteState(emoteFinishCast)
    end

    if (estado == 'personajeCreado') then
        if (personajeCreadoDicho == false) then
            creature:SendUnitSay(
                'Ya esta... El entry del NPC que he creado es el ' .. entry ..
                    '.', 0)
            personajeCreadoDicho = true
            tiempo = 0
        end
        if (tiempo > tiempoPersonajeCreado) then
            estado = 'recordatorio'
            tiempo = 0
        end
    end

    if (estado == 'recordatorio') then
        if (recordatorioDicho == false) then
            creature:SendUnitSay(
                'Recuerda que para ver tu NPC es necesario reiniciar el servidor.',
                0)
            recordatorioDicho = true
            tiempo = 0
        end
        if (tiempo > tiempoRecordatorio) then
            estado = ''
            tiempo = 0
            reset()
        end
    end

    tiempo = tiempo + diff
end

function reset()
    estado = ''
    entry = '0'
    outfit = '0'
    guid = '0'
    errores = false
    tiempo = 0
    personaje = ''
    nombre = ''
    subnombre = ''
    capucha = true
    buscandoPersonaje = false
    personajeEncontradoDicho = false
    creandoPersonajeDicho = false
    personajeCreadoDicho = false
    recordatorioDicho = false
    queryBuscarPersonaje = false

    raza = 0
    clase = 0
    genero = 0
    piel = 0
    cara = 0
    pelo = 0
    color = 0
    barba = 0

    casco = 0
    hombreras = 0
    camisa = 0
    pechera = 0
    cinturon = 0
    pantalones = 0
    botas = 0
    brazaletes = 0
    guantes = 0
    capa = 0
    tabardo = 0
    arma1 = 0
    arma2 = 0
    arma3 = 0
end

function buscarPersonaje(creature)
    local results = CharDBQuery(
                        "SELECT `guid` FROM `characters` WHERE  UPPER(`name`) =  UPPER('" ..
                            personaje .. "') LIMIT 1")
    if (results) then
        repeat guid = results:GetString(0) until not results:NextRow()
    end

    if (guid == '0') then
        lanzarError(creature,
                    'Oops!! No encuentro el personaje en la base de datos... ¿Lo has escrito correctamente?')

    else
        queryBuscarPersonaje = true
    end
end

function obtenerRopa(player)
    -- iterar de la posicion 0 a 18 para obtener items del personaje y guardar en las variables el entry de cada item
    for i = 0, 18 do
        local item = player:GetItemByPos(255, i)
        if (item) then
            local entry = item:GetEntry()
            if (i == 0) then
                casco = entry
            elseif (i == 2) then
                hombreras = entry
            elseif (i == 3) then
                camisa = entry
            elseif (i == 4) then
                pechera = entry
            elseif (i == 5) then
                cinturon = entry
            elseif (i == 6) then
                pantalones = entry
            elseif (i == 7) then
                botas = entry
            elseif (i == 8) then
                brazaletes = entry
            elseif (i == 9) then
                guantes = entry
            elseif (i == 14) then
                capa = entry
            elseif (i == 15) then
                arma1 = entry
            elseif (i == 16) then
                arma2 = entry
            elseif (i == 17) then
                arma3 = entry
            elseif (i == 18) then
                tabardo = entry
            end
        end
    end
end

function crearPersonaje(creature)
    local results = CharDBQuery(
                        "SELECT `race`, `class`, `gender`, `skin`, `face`, `hairStyle`, `hairColor`, `facialStyle` FROM `characters` WHERE  UPPER(`name`) =  UPPER('" ..
                            personaje .. "') LIMIT 1")
    if (results) then
        repeat
            raza = results:GetUInt32(0)
            clase = results:GetUInt32(1)
            genero = results:GetUInt32(2)
            piel = results:GetUInt32(3)
            cara = results:GetUInt32(4)
            pelo = results:GetUInt32(5)
            color = results:GetUInt32(6)
            barba = results:GetUInt32(7)
        until not results:NextRow()
    end

    --[[results = CharDBQuery("SELECT `slot`, `item` FROM `character_inventory` WHERE `guid` = '"..guid.."';")
    if (results) then
        repeat
            local slot = results:GetUInt32(0)
            local item = results:GetUInt32(1)
            if (slot == 0) then
                casco = item
            elseif (slot == 2) then
                hombreras = item
            elseif (slot == 3) then
                camisa = item
            elseif (slot == 4) then
                pechera = item
            elseif (slot == 5) then
                cinturon = item
            elseif (slot == 6) then
                pantalones = item
            elseif (slot == 7) then
                botas = item
            elseif (slot == 8) then
                brazaletes = item
            elseif (slot == 9) then
                guantes = item
            elseif (slot == 14) then
                capa = item
            elseif (slot == 15) then
                arma1 = item
            elseif (slot == 16) then
                arma2 = item
            elseif (slot == 17) then
                arma3 = item
            elseif (slot == 18) then
                tabardo = item
            end
        until not results:NextRow()
    end]]

    local sqlGetNextEntry =
        "SELECT `entry` FROM `creature_template` WHERE `entry` BETWEEN " ..
            entryMin .. " AND " .. entryMax ..
            " AND `name` = 'Not Spawn' ORDER BY `entry` ASC LIMIT 1;"
    local resultGetNextEntry = WorldDBQuery(sqlGetNextEntry)
    if (resultGetNextEntry) then entry = resultGetNextEntry:GetUInt32(0) end

    print('entry: ' .. entry)

    local sqlGetOutfitId =
        "SELECT IFNULL(MAX(`entry`), 50000) + 1 AS next_outfit_id FROM `creature_template_outfits`;"
    local resultGetOutfitId = WorldDBQuery(sqlGetOutfitId)
    if (resultGetOutfitId) then
        if (resultGetOutfitId:GetRowCount() > 0) then
            outfit = resultGetOutfitId:GetUInt32(0)
        else
            outfit = 50000 -- Valor predeterminado cuando no hay registros
        end
    else
        outfit = 50000 -- Valor predeterminado en caso de error de consulta
    end

    local sqlCreatureTemplateOutfits =
        "REPLACE INTO `creature_template_outfits` (`entry`, `npcsoundsid`, `race`, `class`, `gender`, `skin`, `face`, `hair`, `haircolor`, `facialhair`, `head`, `shoulders`, `body`, `chest`, `waist`, `legs`, `feet`, `wrists`, `hands`, `back`, `tabard`, `guildid`, `description`) VALUES (" ..
            outfit .. ", 0, " .. raza .. ", " .. clase .. ", " .. genero .. ", " ..
            piel .. ", " .. cara .. ", " .. pelo .. ", " .. color .. ", " ..
            barba .. ", " .. casco .. ", " .. hombreras .. ", " .. camisa ..
            ", " .. pechera .. ", " .. cinturon .. ", " .. pantalones .. ", " ..
            botas .. ", " .. brazaletes .. ", " .. guantes .. ", " .. capa ..
            ", " .. tabardo .. ", 0, '');"
    local resultCreatureTemplateOutfits = WorldDBQuery(
                                              sqlCreatureTemplateOutfits)

    local sqlCreatureTemplate =
        "REPLACE INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`, `KillCredit1`, `KillCredit2`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `speed_swim`, `speed_flight`, `detection_range`, `scale`, `rank`, `dmgschool`, `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`, `trainer_race`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`, `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `HoverHeight`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`, `RegenHealth`, `mechanic_immune_mask`, `spell_school_immune_mask`, `flags_extra`, `ScriptName`, `VerifiedBuild`) VALUES (" ..
            entry .. ",'0','0','0','0','0','" .. nombre .. "','" .. subnombre ..
            "',NULL,'0','80','80','0','35','1','1','1.14286','1','1','20','1','0','0','1','0','0','1','1','1','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','','0','1','1','1','1','1','0','0','1','0','0','0','',NULL);"
    local resultCreatureTemplate = WorldDBQuery(sqlCreatureTemplate)

    local sqlCreatureModelTemplate =
        "REPLACE INTO `creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES (" ..
            entry .. ",'0'," .. outfit .. ",'1','1','12340');"
    local resultCreatureTemplate = WorldDBQuery(sqlCreatureModelTemplate)

    local sqlCreatureEquipTemplate =
        "REPLACE INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `ItemID2`, `ItemID3`, `VerifiedBuild`) VALUES (" ..
            entry .. ", 1, " .. arma1 .. ", " .. arma2 .. ", " .. arma3 ..
            ", 0);"
    local resultCreatureEquipTemplate = WorldDBQuery(sqlCreatureEquipTemplate)

    if (entry == '0') then
        lanzarError(creature,
                    'Oops!! Ha habido un error al intentar crear el NPC...')
    else
        queryCrearPersonaje = true
    end
end

function lanzarError(creature, mensaje)
    errores = true
    creature:SendUnitSay(mensaje, 0)
    reset()
end

RegisterCreatureGossipEvent(NpcId, 1, OnGossipHello)
RegisterCreatureGossipEvent(NpcId, 2, OnGossipSelect)

RegisterCreatureEvent(NpcId, 7, creatureAI)
