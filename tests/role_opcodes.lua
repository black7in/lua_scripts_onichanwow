--[[
CREATE TABLE `lfg_group_reward` (
  `groupId` INT(11) NOT NULL DEFAULT '0',
  `instanceId` SMALLINT NOT NULL DEFAULT '0',
  `guidTank` TINYINT NOT NULL DEFAULT '0',
  `guidHeal` TINYINT NOT NULL DEFAULT '0',
  PRIMARY KEY (`groupId`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4;
]]

local SMSG_LFG_PROPOSAL_UPDATE = 0x361

local cache = {}

local PLAYER_ROLE_TANK = 2

local PLAYER_ROLE_HEALER = 4

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

            if esPlayer == 1 then
                --[[if role == PLAYER_ROLE_TANK then
                    local group = player:GetGroup()
                    if group then
                        local guid = group:GetGUID()
                        if cache[guid] == nil then
                            cache[guid] = {
                                tank = player:GetGUIDLow(),
                                heal = 0
                            }
                            print(guid)
                            CharDBExecute("INSERT INTO lfg_group_reward (groupId, instanceId, guidTank, guidHeal) VALUES (" .. tostring(guid) .. ", 0," .. tostring(player:GetGUIDLow()) .. ", 0)")
                        else
                            cache[guid].tank = player:GetGUIDLow()
                            CharDBExecute("UPDATE lfg_group_reward SET guidTank = " .. tostring(player:GetGUIDLow()) .. " WHERE groupId = " .. tostring(guid))
                        end
                    end
                elseif role == PLAYER_ROLE_HEALER then  
                    local group = player:GetGroup()
                    if group then
                        local guid = group:GetGUID()
                        if cache[guid] == nil then
                            cache[guid] = {
                                tank = 0,
                                heal = player:GetGUIDLow()
                            }
                            CharDBExecute("INSERT INTO lfg_group_reward (groupId, instanceId, guidTank, guidHeal) VALUES (" .. tostring(guid) .. ",0,0," .. tostring(player:GetGUIDLow()) .. ")")
                        else
                            cache[guid].heal = player:GetGUIDLow()
                            CharDBExecute("UPDATE lfg_group_reward SET guidHeal = " .. tostring(player:GetGUIDLow()) .. " WHERE groupId = " .. tostring(guid))
                        end
                    end
                end]]
                print("dugeoId: " .. dugeoId)
                print("instanceId: " .. player:GetInstanceID())
            end
        end
    end

end

RegisterPacketEvent(SMSG_LFG_PROPOSAL_UPDATE, 7, OnPacketSend)

local function OnCompleteQuest(event, player, quest)
    if quest:GetId() >= 24788 and quest:GetId() <= 24790 then -- Misiones del buscador de mazmorra
        local group = player:GetGroup()
        if group then
            local guid = group:GetGUID()
            if cache[guid] then
                local tank = cache[guid].tank
                local heal = cache[guid].heal
                if tank == player:GetGUIDLow() then
                    player:SendNotification("¡Felicidades! Has completado la mazmorra como tanque, recibirás una recompensa especial.")
                    player:AddItem(20486, 1)
                elseif heal == player:GetGUIDLow() then
                    player:SendNotification("¡Felicidades! Has completado la mazmorra como sanador, recibirás una recompensa especial.")
                    player:AddItem(20486, 1)
                end
            end
        end
    end
end

RegisterPlayerEvent(54, OnCompleteQuest)


local function OnGroupDisband(event, group)
    local guid = group:GetGUID()
    cache[guid] = nil
    CharDBExecute("DELETE FROM lfg_group_reward WHERE groupId = " .. tostring(guid)..";")
end

RegisterGroupEvent(5, OnGroupDisband)