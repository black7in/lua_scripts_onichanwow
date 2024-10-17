local SMSG_LFG_ROLE_CHOSEN = 0x2BB

local function OnPacketReceive(event, packet, player) 
    print("Received packet: " .. SMSG_LFG_ROLE_CHOSEN)
end

local function OnPacketSend(event, packet, player) 
    print("Sent packet: " .. SMSG_LFG_ROLE_CHOSEN)
end

RegisterPacketEvent(SMSG_LFG_ROLE_CHOSEN, 5, OnPacketReceive)
RegisterPacketEvent(SMSG_LFG_ROLE_CHOSEN, 7, OnPacketSend)
