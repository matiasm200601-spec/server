local config = {
	loginMessage = getConfigValue('loginMessage'),
	useFragHandler = getBooleanFromString(getConfigValue('useFragHandler'))
}

local MINIMUM_PLAYER_LEVEL = 20

function onLogin(cid)

    if getPlayerLevel(cid) < MINIMUM_PLAYER_LEVEL then
       doPlayerAddExperience(cid, getExperienceForLevel(MINIMUM_PLAYER_LEVEL) - getPlayerExperience(cid))
    end

    local level = getPlayerLevel(cid)
    local normalLoss = level >= 200 and 100 or math.floor(level / 2)
    local protectedExperience = getExperienceForLevel(MINIMUM_PLAYER_LEVEL)
    local maximumLoss = math.floor(((getPlayerExperience(cid) - protectedExperience) * 100) / getPlayerExperience(cid))
    doPlayerSetLossPercent(cid, PLAYERLOSS_EXPERIENCE, math.max(0, math.min(normalLoss, maximumLoss)))
	doCreatureSetDropLoot(cid, false)

	local accountManager = getPlayerAccountManager(cid)

	if(accountManager == MANAGER_NONE) then
		local lastLogin, str = getPlayerLastLoginSaved(cid), config.loginMessage
		if(lastLogin > 0) then
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT, str)
    str = "Tu Ãºltima visita fue el " .. os.date("%d/%m/%Y a las %H:%M:%S", lastLogin) .. "."
    else
    str = "Bienvenido! Esperamos que disfrutes tu aventura."
    end


		doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT, str)

	elseif(accountManager == MANAGER_NAMELOCK) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Hola, parece que tu personaje tiene el nombre bloqueado. ¿Qué nombre nuevo deseas?")
	elseif(accountManager == MANAGER_ACCOUNT) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Hola, escribe 'account' para administrar tu cuenta o 'cancel' para empezar de nuevo.")
	else
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Hola, escribe 'account' para crear una cuenta o 'recover' para recuperarla.")
	end

	if getCreatureName(cid) == "Account Manager" then
		local outfit = {}
		if accountManagerRandomPokemonOutfit then
			outfit = {lookType = getPokemonXMLOutfit(oldpokedex[math.random(151)][1])}
		else
			outfit = accountManagerOutfit
		end
	
		doSetCreatureOutfit(cid, outfit, -1)
	return true
	end

	if(not isPlayerGhost(cid)) then
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_TELEPORT)
	end

	local outfit = {}

	if getPlayerVocation(cid) == 0 then
		doPlayerSetMaxCapacity(cid, 0)
		doPlayerSetVocation(cid, 1)
		setCreatureMaxMana(cid, 6)
		doPlayerAddSoul(cid, -getPlayerSoul(cid))
		setPlayerStorageValue(cid, 19898, 0)
			if getCreatureOutfit(cid).lookType == 128 then
				outfit = {lookType = 510, lookHead = math.random(0, 132), lookBody = math.random(0, 132), lookLegs = math.random(0, 132), lookFeet = math.random(0, 132)}
			elseif getCreatureOutfit(cid).lookType == 136 then
				outfit = {lookType = 511, lookHead = math.random(0, 132), lookBody = math.random(0, 132), lookLegs = math.random(0, 132), lookFeet = math.random(0, 132)}
			end
		doCreatureChangeOutfit(cid, outfit)
	end

    registerCreatureEvent(cid, "dropStone")  
    registerCreatureEvent(cid, "ShowPokedex") 
    registerCreatureEvent(cid, "ClosePokedex") 
	registerCreatureEvent(cid, "WatchTv")
	registerCreatureEvent(cid, "StopWatchingTv")
	registerCreatureEvent(cid, "WalkTv")
	registerCreatureEvent(cid, "RecordTv")
	registerCreatureEvent(cid, "PlayerLogout")
	registerCreatureEvent(cid, "WildAttack")
	registerCreatureEvent(cid, "Idle")
	registerCreatureEvent(cid, "EffectOnAdvance")
	registerCreatureEvent(cid, "GeneralConfiguration")
	registerCreatureEvent(cid, "SaveReportBug")   
	registerCreatureEvent(cid, "LookSystem")
	registerCreatureEvent(cid, "Monsteritem")
              registerCreatureEvent(cid, "Xregen")
	registerCreatureEvent(cid, "T1")
	registerCreatureEvent(cid, "T2")
	registerCreatureEvent(cid, "task_count")
              registerCreatureEvent(cid, "premio")
	registerCreatureEvent(cid, "UpAbsolute")

	

	if getPlayerStorageValue(cid, 99284) == 1 then
		setPlayerStorageValue(cid, 99284, -1)
	end

    if getPlayerStorageValue(cid, 6598754) >= 1 or getPlayerStorageValue(cid, 6598755) >= 1 then
       setPlayerStorageValue(cid, 6598754, -1)
       setPlayerStorageValue(cid, 6598755, -1)
       doRemoveCondition(cid, CONDITION_OUTFIT)             --alterado v1.9 \/
       doTeleportThing(cid, posBackPVP, false)
       doCreatureAddHealth(cid, getCreatureMaxHealth(cid))
    end
    
	doChangeSpeed(cid, -(getCreatureSpeed(cid)))
	
	--///////////////////////////////////////////////////////////////////////////--
    local storages = {17000, 63215, 17001, 13008, 5700}
    for s = 1, #storages do
        if not tonumber(getPlayerStorageValue(cid, storages[s])) then
           if s == 3 then
              setPlayerStorageValue(cid, storages[s], 1)
           elseif s == 4 then
              setPlayerStorageValue(cid, storages[s], -1)
           else   
              if isBeingUsed(getPlayerSlotItem(cid, 8).itemid) then
                 setPlayerStorageValue(cid, storages[s], 1)                 
              else
                 setPlayerStorageValue(cid, storages[s], -1) 
              end
           end
           doPlayerSendTextMessage(cid, 27, "Lo sentimos, ocurrió un problema en el servidor, pero ya está solucionado.")
        end
    end
    --/////////////////////////////////////////////////////////////////////////--
	if getPlayerStorageValue(cid, 17000) >= 1 then -- fly
        
		local item = getPlayerSlotItem(cid, 8)
		local poke = getItemAttribute(item.uid, "poke")
		doChangeSpeed(cid, getPlayerStorageValue(cid, 54844))
		doRemoveCondition(cid, CONDITION_OUTFIT)
		doSetCreatureOutfit(cid, {lookType = flys[poke][1] + 351}, -1)

	local apos = getFlyingMarkedPos(cid)
    apos.stackpos = 0
		
			if getTileThingByPos(apos).itemid <= 2 then
				doCombatAreaHealth(cid, FIREDAMAGE, getFlyingMarkedPos(cid), 0, 0, 0, CONST_ME_NONE)
				doCreateItem(460, 1, getFlyingMarkedPos(cid))
			end 

	doTeleportThing(cid, apos, false)
	if getItemAttribute(item.uid, "boost") and getItemAttribute(item.uid, "boost") >= 50 and getPlayerStorageValue(cid, 42368) >= 1 then   
       sendAuraEffect(cid, auraSyst[getItemAttribute(item.uid, "aura")])                     --alterado v1.8
    end  
 
    local posicao = getTownTemplePosition(getPlayerTown(cid))
    markFlyingPos(cid, posicao)
    
	elseif getPlayerStorageValue(cid, 63215) >= 1 then -- surf

		local item = getPlayerSlotItem(cid, 8)
		local poke = getItemAttribute(item.uid, "poke")
		doSetCreatureOutfit(cid, {lookType = surfs[poke].lookType + 351}, -1) --alterado v1.6
		doChangeSpeed(cid, getPlayerStorageValue(cid, 54844))
		if getItemAttribute(item.uid, "boost") and getItemAttribute(item.uid, "boost") >= 50 and getPlayerStorageValue(cid, 42368) >= 1 then   
           sendAuraEffect(cid, auraSyst[getItemAttribute(item.uid, "aura")])                     --alterado v1.8
        end 

	elseif getPlayerStorageValue(cid, 17001) >= 1 then -- ride
        
		local item = getPlayerSlotItem(cid, 8)
		local poke = getItemAttribute(item.uid, "poke")
		
		
		if rides[poke] then
		   doChangeSpeed(cid, getPlayerStorageValue(cid, 54844))
		   doRemoveCondition(cid, CONDITION_OUTFIT)
		   doSetCreatureOutfit(cid, {lookType = rides[poke][1] + 351}, -1)
		   if getItemAttribute(item.uid, "boost") and getItemAttribute(item.uid, "boost") >= 50 and getPlayerStorageValue(cid, 42368) >= 1 then   
              sendAuraEffect(cid, auraSyst[getItemAttribute(item.uid, "aura")])                     --alterado v1.8
           end 
		else
		   setPlayerStorageValue(cid, 17001, -1)
		   doRegainSpeed(cid)   
		end
	
	    local posicao2 = getTownTemplePosition(getPlayerTown(cid))
        markFlyingPos(cid, posicao2)
        
	elseif getPlayerStorageValue(cid, 13008) >= 1 then -- dive
       if not isInArray({5405, 5406, 5407, 5408, 5409, 5410}, getTileInfo(getThingPos(cid)).itemid) then
			setPlayerStorageValue(cid, 13008, 0)
			doRegainSpeed(cid)              
			doRemoveCondition(cid, CONDITION_OUTFIT)
		return true
		end   
          
       if getPlayerSex(cid) == 1 then
          doSetCreatureOutfit(cid, {lookType = 1034, lookHead = getCreatureOutfit(cid).lookHead, lookBody = getCreatureOutfit(cid).lookBody, lookLegs = getCreatureOutfit(cid).lookLegs, lookFeet = getCreatureOutfit(cid).lookFeet}, -1)
       else
          doSetCreatureOutfit(cid, {lookType = 1035, lookHead = getCreatureOutfit(cid).lookHead, lookBody = getCreatureOutfit(cid).lookBody, lookLegs = getCreatureOutfit(cid).lookLegs, lookFeet = getCreatureOutfit(cid).lookFeet}, -1)
       end
       doChangeSpeed(cid, 800)

     elseif getPlayerStorageValue(cid, 5700) > 0 then   --bike
        doChangeSpeed(cid, -getCreatureSpeed(cid))
        doChangeSpeed(cid, 500)
        if getPlayerSex(cid) == 1 then
           doSetCreatureOutfit(cid, {lookType = 1394}, -1)
        else
           doSetCreatureOutfit(cid, {lookType = 1393}, -1)
        end
     
     elseif getPlayerStorageValue(cid, 75846) >= 1 then     --alterado v1.9 \/
        doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)), false)  
        setPlayerStorageValue(cid, 75846, -1)
        sendMsgToPlayer(cid, 20, "Tienes been moved to your town!")
	 else
		doRegainSpeed(cid)  
	 end
	
	if getPlayerStorageValue(cid, 22545) >= 1 then
	   setPlayerStorageValue(cid, 22545, -1)              
	   doTeleportThing(cid, getClosestFreeTile(cid, posBackGolden), false)
       setPlayerRecordWaves(cid)     
    end
    
	if useKpdoDlls then
		doUpdateMoves(cid)
		doUpdatePokemonsBar(cid)
	end
	return true
end