local function OnUpdateArea(event, player, oldArea, newArea)
    if newArea ~= 41 then return end

    local nearestCreature = player:GetNearestCreature(50, 90022 )
    if nearestCreature then
        player:SendNotification("|TINTERFACE/ICONS/Ability_Creature_Cursed_05:30:30:0:0|t |CFF330033Bienvenido a la tienda Halloween|R |TINTERFACE/ICONS/Ability_Creature_Cursed_05:30:30:0:0|t")
    end
end

RegisterPlayerEvent(47, OnUpdateArea)