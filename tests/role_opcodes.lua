local SMSG_LFG_ROLE_CHOSEN = 0x361

local function OnPacketSend(event, packet, player) 
    print("Player: " .. player:GetName())
end

RegisterPacketEvent(SMSG_LFG_PROPOSAL_UPDATE, 7, OnPacketSend)
