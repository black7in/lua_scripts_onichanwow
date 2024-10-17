local SMSG_LFG_PROPOSAL_UPDATE = 0x361

local function OnPacketSend(event, packet, player) 
    local dugeonId = packet:ReadULong()
    local state = packet:ReadUByte()
    if state == 2 then
        print("Sent LFG_PROPOSAL_SUCCESS packet: " .. SMSG_LFG_PROPOSAL_UPDATE)
    end

end

RegisterPacketEvent(SMSG_LFG_PROPOSAL_UPDATE, 7, OnPacketSend)
