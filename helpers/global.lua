function SendWorldRaidNotification(message)
    local  worldPlayers = GetPlayersInWorld( 2 )
    for k, player in pairs(worldPlayers) do
        if player then
            player:SendRaidNotification(message)
        end
    end 
end