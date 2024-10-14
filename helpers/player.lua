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

function Player:SendGossipText(text, npc_text)
    local data = CreatePacket(384, 100);
    data:WriteULong(npc_text) -- id npc_text
    for i = 1, 10 do
        data:WriteFloat(0)
        data:WriteString(text)
        data:WriteString(text)
        data:WriteULong(0)
        data:WriteULong(0)
        data:WriteULong(0)
        data:WriteULong(0)
        data:WriteULong(0)
        data:WriteULong(0)
        data:WriteULong(0)
    end
    self:SendPacket(data)
end