function Creature:SendAreaRaidNotification(message, range)
    local players = self:GetPlayersInRange(range)
    for i, player in ipairs(players) do player:SendRaidNotification(message) end
end