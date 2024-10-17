local SMSG_LFG_ROLE_CHOSEN = 0x2BB

local function OnPacketSend(event, packet, player) 
    print("Player: " .. player:GetName())
    local value = packet:ReadGUID()
    --print("Read GUID: " .. packet:ReadGUID())
    print("Read UByte: " .. packet:ReadUByte())
    print("Read ULong: " .. packet:ReadULong())
    print("----------------------")

end

RegisterPacketEvent(SMSG_LFG_ROLE_CHOSEN, 7, OnPacketSend)
