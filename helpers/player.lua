local SMSG_MESSAGECHAT = 0x096
function Player:SendRaidNotification(message)
    local data = CreatePacket(SMSG_MESSAGECHAT, string.len(message) + 1 + 40)
    data:WriteUByte(40)
    data:WriteULong(0)
    data:WriteGUID(0)
    data:WriteULong(0)
    data:WriteGUID(0)
    data:WriteULong(string.len(message) + 1)
    data:WriteString(message)
    data:WriteUByte(0)
    self:SendPacket(data)
end