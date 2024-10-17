local SMSG_LFG_PROPOSAL_UPDATE = 0x361

local function OnPacketSend(event, packet, player) 
    local dugeonId = packet:ReadULong()
    local state = packet:ReadUByte()
    if state == 2 then -- esto sucede cuando el jugador acepta la propuesta y su rol, ahora solo es leer la propuesta y el rol xd
        local proposalId = packet:ReadULong()
        local proposalEncounters = packet:ReadULong()
        local silent = packet:ReadUByte()
        local size = packet:ReadUByte()
        -- hacer un for de 5 
        for i = 1, size do
            local role = packet:ReadULong()
            local esPlayer = packet:ReadUByte()

            -- unknown
            local unk1 = packet:ReadUByte()
            local unk2 = packet:ReadUByte()

            local answered = packet:ReadUByte()
            local accepted = packet:ReadUByte()

            if esPlayer == true then
                print("Player name: " .. player:GetName().. " Role: " .. role)
            end
        end
    end

end

RegisterPacketEvent(SMSG_LFG_PROPOSAL_UPDATE, 7, OnPacketSend)
