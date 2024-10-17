local SMSG_LFG_PROPOSAL_UPDATE = 0x361

local function OnPacketReceive(event, packet, player) 
    print("Received packet: " .. SMSG_LFG_PROPOSAL_UPDATE)
end

local function OnPacketSend(event, packet, player) 
    print("Sent packet: " .. SMSG_LFG_PROPOSAL_UPDATE)
end

RegisterPacketEvent(SMSG_LFG_PROPOSAL_UPDATE, 7, OnPacketSend)
RegisterPacketEvent(SMSG_LFG_PROPOSAL_UPDATE, 5, OnPacketReceive)
