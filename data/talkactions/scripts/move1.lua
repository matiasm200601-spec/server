local msgs = {"use ", ""}

function doAlertReady(cid, id, movename, n, cd)
	if not isCreature(cid) then return true end
	local myball = getPlayerSlotItem(cid, 8)
	if myball.itemid > 0 and getItemAttribute(myball.uid, cd) == "cd:"..id.."" then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, getPokeballName(myball.uid).." - "..movename.." (m"..n..") está listo!")
	return true
	end
	local p = getPokeballsInContainer(getPlayerSlotItem(cid, 3).uid)
	if not p or #p <= 0 then return true end
	for a = 1, #p do
		if getItemAttribute(p[a], cd) == "cd:"..id.."" then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, getPokeballName(p[a]).." - "..movename.." (m"..n..") está listo!")
		return true
		end
	end
end

function onSay(cid, words, param, channel)


	if param ~= "" then return true end
	if string.len(words) > 3 then return true end

	if #getCreatureSummons(cid) == 0 then
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Necesitas un Pokémon para usar movimientos.")
	return 0
	end
                      --alterado v1.5
local mypoke = getCreatureSummons(cid)[1]

	if getCreatureCondition(cid, CONDITION_EXHAUST) then return true end
	if getCreatureName(mypoke) == "Evolution" then return true end

    if getCreatureName(mypoke) == "Ditto" or getCreatureName(mypoke) == "Shiny Ditto" then
       name = getPlayerStorageValue(mypoke, 1010)   --edited
    else
       name = getCreatureName(mypoke)
    end  
	
    --local name = getCreatureName(mypoke) == "Ditto" and getPlayerStorageValue(mypoke, 1010) or getCreatureName(mypoke)

local it = string.sub(words, 2, 3)
local move = movestable[name].move1
if getPlayerStorageValue(mypoke, 212123) >= 1 then
   cdzin = "cm_move"..it..""
else
   cdzin = "move"..it..""       --alterado v1.5
end

	if it == "2" then
		move = movestable[name].move2
	elseif it == "3" then
		move = movestable[name].move3
	elseif it == "4" then
		move = movestable[name].move4
	elseif it == "5" then
		move = movestable[name].move5
	elseif it == "6" then
		move = movestable[name].move6
	elseif it == "7" then
		move = movestable[name].move7
	elseif it == "8" then
		move = movestable[name].move8
	elseif it == "9" then
		move = movestable[name].move9
	elseif it == "10" then
		move = movestable[name].move10
	elseif it == "11" then
		move = movestable[name].move11
	elseif it == "12" then
		move = movestable[name].move12
	elseif it == "13" then
		move = movestable[name].move13
	end

	if not move then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Tu Pokémon no conoce este movimiento.")
	return true
	end
	
	if getPlayerLevel(cid) < move.level then
	   doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Necesitas ser al menos nivel "..move.level.." para usar este movimiento.")
	   return true
    end

	if getCD(getPlayerSlotItem(cid, 8).uid, cdzin) > 0 and getCD(getPlayerSlotItem(cid, 8).uid, cdzin) < (move.cd + 2) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Debes esperar "..getCD(getPlayerSlotItem(cid, 8).uid, cdzin).." segundos para usar "..move.name.." otra vez.")
	return true
	end

	if getTileInfo(getThingPos(mypoke)).protection then
		doPlayerSendCancel(cid, "Tu Pokémon no puede usar movimientos en la zona de protección.")
	return true
	end
	
	if getPlayerStorageValue(mypoke, 3894) >= 1 then
    return doPlayerSendCancel(cid, "No puedes atacar porque estás asustado.") --alterado v1.3
    end
	                              --alterado v1.6                  
	if (move.name == "Team Slice" or move.name == "Team Claw") and #getCreatureSummons(cid) < 2 then       
	    doPlayerSendCancel(cid, "Tu Pokémon debe estar en equipo para usar este movimiento.")
    return true
    end
                                                                     --alterado v1.7 \/\/\/
if isCreature(getCreatureTarget(cid)) and isInArray(specialabilities["evasion"], getCreatureName(getCreatureTarget(cid))) then 
   local target = getCreatureTarget(cid)                                                                                       
   if math.random(1, 100) <= passivesChances["Evasion"][getCreatureName(target)] then 
      if isCreature(getMasterTarget(target)) then   --alterado v1.6                                                                   
         doSendMagicEffect(getThingPos(target), 211)
         doSendAnimatedText(getThingPos(target), "TOO BAD", 215)                                
         doTeleportThing(target, getClosestFreeTile(target, getThingPos(mypoke)), false)
         doSendMagicEffect(getThingPos(target), 211)
         doFaceCreature(target, getThingPos(mypoke))    		
         return true       --alterado v1.6
      end
   end
end


if move.target == 1 then

	if not isCreature(getCreatureTarget(cid)) then
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "No tienes ningún objetivo.")
	return 0
	end

	if getCreatureCondition(getCreatureTarget(cid), CONDITION_INVISIBLE) then
	return 0
	end

	if getCreatureHealth(getCreatureTarget(cid)) <= 0 then
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Ya derrotaste a tu objetivo.")
	return 0
	end

	if not isCreature(getCreatureSummons(cid)[1]) then
	return true
	end

	if getDistanceBetween(getThingPos(getCreatureSummons(cid)[1]), getThingPos(getCreatureTarget(cid))) > move.dist then
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Acércate al objetivo para usar este movimiento.")
	return 0
	end

	if not isSightClear(getThingPos(getCreatureSummons(cid)[1]), getThingPos(getCreatureTarget(cid)), false) then
	return 0
	end
end

	local newid = 0

-- Cooldown -- 
local Tiers = {
[113] = {bonus = Cdown1},
}
local Tier = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "heldx")
local cdzao = {}
if Tier and Tier > 112 and Tier < 116 then
cdzao = math.ceil(move.cd - (move.cd * Tiers[Tier].bonus))
else
cdzao = move.cd
end
-- Cooldown -- 

        if isSleeping(mypoke) or isSilence(mypoke) then  --alterado v1.5
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "No puedes hacer eso ahora mismo.")
			return 0
		else
			newid = setCD(getPlayerSlotItem(cid, 8).uid, cdzin, cdzao) 
		end
		
	doCreatureSay(cid, ""..getPokeName(mypoke)..", "..msgs[math.random(#msgs)]..""..move.name.."!", TALKTYPE_SAY)
	
    local summons = getCreatureSummons(cid) --alterado v1.6

	addEvent(doAlertReady, move.cd * 1000, cid, newid, move.name, it, cdzin)
	
	for i = 2, #summons do
       if isCreature(summons[i]) and getPlayerStorageValue(cid, 637501) >= 1 then
          docastspell(summons[i], move.name)        --alterado v1.6
       end
    end 

    docastspell(mypoke, move.name)
	doCreatureAddCondition(cid, playerexhaust)

	if useKpdoDlls then
		doUpdateCooldowns(cid)
	end

return 0
end