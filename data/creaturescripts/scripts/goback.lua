function onLogout(cid)
    
    if not isCreature(cid) then return true end
if getPlayerStorageValue(cid, 32001) == 1 then
  setPlayerStorageValue(cid, 32001, 0)
end
	local thisitem = getPlayerSlotItem(cid, 8)
	
	if thisitem.uid <= 0 then return true end
	
	local ballName = getItemAttribute(thisitem.uid, "poke")
	
	--------------------------------------------------------
    btype = getPokeballType(thisitem.itemid)
    ---------------------------------------------------------------
    if #getCreatureSummons(cid) > 1 and getPlayerStorageValue(cid, 212124) <= 0 then    --alterado v1.6
       if getPlayerStorageValue(cid, 637501) == -2 or getPlayerStorageValue(cid, 637501) >= 1 then  
          BackTeam(cid)       
       end
    end
    --////////////////////////////////////////////////////////////////////////////////////////--
    if not isCreature(cid) then return true end
    if getPlayerStorageValue(cid, 52480) >= 1 or getPlayerStorageValue(cid, 52481) >= 0 then 
       local sid = getPlayerByName(getPlayerStorageValue(cid, 52482))
       local sendLose = true
       if isCreature(sid) then
          if getPlayerStorageValue(sid, 52482) == getCreatureName(cid) then
             addEvent(doSendAnimatedText, 1000, getThingPosWithDebug(sid), "WIN", COLOR_ELECTRIC)
             setPlayerStorageValue(sid, 52480, -1)
             setPlayerStorageValue(sid, 52481, -1)
             setPlayerStorageValue(sid, 52482, -1)
             setPlayerStorageValue(sid, 52483, -1)           --alterado v1.6.1
             setPlayerStorageValue(sid, 6598754, -1)
             doCreatureSetSkullType(sid, 0)
          else
             sendLose = false
          end
       end
       if sendLose then
          addEvent(doSendAnimatedText, 1000, getThingPosWithDebug(cid), "LOSE", COLOR_BURN)
       end
       setPlayerStorageValue(cid, 52480, -1)
       setPlayerStorageValue(cid, 52481, -1)
       setPlayerStorageValue(cid, 52482, -1)
       setPlayerStorageValue(cid, 52483, -1)
       setPlayerStorageValue(cid, 6598754, -1)
       doCreatureSetSkullType(cid, 0)
    end
    --////////////////////////////////////////////////////////////////////////////////////////--
    if #getCreatureSummons(cid) == 2 and getPlayerStorageValue(cid, 212124) >= 1 then
       local cmed2 = getCreatureSummons(cid)[1]
	   local poscmed = getThingPos(cmed2)
	   local cmeddir = getCreatureLookDir(cmed2)
	   local namecmed = getCreatureName(cmed2)
	   local hp, maxHp = getCreatureHealth(getCreatureSummons(cid)[1]), getCreatureMaxHealth(getCreatureSummons(cid)[1])
	   local gender = getPokemonGender(cmed2) 
       doRemoveCreature(getCreatureSummons(cid)[1])
	   local back = doCreateMonster(namecmed, poscmed)
	   addEvent(doCreatureSetSkullType, 150, back, gender)
	   doCreatureSetLookDir(back, cmeddir)
	   addEvent(doCreatureAddHealth, 100, back, hp-maxHp)
                                                                            --alterado v1.5
       -- pokemon controlador	
       local ball2 = getPlayerSlotItem(cid, 8)
       local mynewpos = getThingPos(getCreatureSummons(cid)[1])
       doRemoveCreature(getCreatureSummons(cid)[1])
       local pk2 = doSummonCreature(getItemAttribute(ball2.uid, "poke"), mynewpos) 
       doConvinceCreature(cid, pk2)
       addEvent(doAdjustWithDelay, 100, cid, pk2, true, true, false)
       setPlayerStorageValue(cid, 888, -1)     --alterado v1.7
       cleanCMcds(ball2.uid)
       doCreatureSetLookDir(getCreatureSummons(cid)[1], 2)
       registerCreatureEvent(pk2, "SummonDeath")    --alterado v1.6
    end
    
    ----------------------------------------------------------------------
    local summon = getCreatureSummons(cid)[1]      
      
	if #getCreatureSummons(cid) >= 1 and thisitem.uid > 1 then
	    if getPlayerStorageValue(cid, 212124) <= 0 then
		   doItemSetAttribute(thisitem.uid, "hp", (getCreatureHealth(summon) / getCreatureMaxHealth(summon)))
        end                                                          --alterado v1.5
        setPlayerStorageValue(cid, 212124, 0)
        doTransformItem(thisitem.uid, pokeballs[btype].on)
		doSendMagicEffect(getThingPos(summon), pokeballs[btype].effect)
		doRemoveCreature(summon)
	end

	if getCreatureOutfit(cid).lookType == 814 then
		doPlayerStopWatching(cid)
	end

	if tonumber(getPlayerStorageValue(cid, 17000)) and getPlayerStorageValue(cid, 17000) >= 1 then  --alterado v1.6
		markFlyingPos(cid, getThingPos(cid))
	end
	
	if getPlayerStorageValue(cid, 22545) == 1 then     --alterado v1.4
	   setGlobalStorageValue(22550, getGlobalStorageValue(22550)-1)
	   if getGlobalStorageValue(22550) <= 0 then
          endGoldenArena()          --alterado v1.7
       end 
    end

return TRUE
end

local deathtexts = {"Oh no! POKENAME, come back!", "Come back, POKENAME!", "That's enough, POKENAME!", "You did well, POKENAME!",
		    "You need to rest, POKENAME!", "Nice job, POKENAME!", "POKENAME, you are too hurt!"}

function onDeath(cid, deathList)

	local owner = getCreatureMaster(cid)

        if getPlayerStorageValue(cid, 637500) >= 1 then
           doSendMagicEffect(getThingPos(cid), 211)
           doRemoveCreature(cid)
           return true
        end
        
        if getPlayerStorageValue(cid, 212123) >= 1 then
           return true
        end
        
        --////////////////////////////////////////////////////////////////////////////////////////--
        checkDuel(owner)                                                                          --alterado v1.6 duel system
        --////////////////////////////////////////////////////////////////////////////////////////--
        
	local thisball = getPlayerSlotItem(owner, 8)
	local ballName = getItemAttribute(thisball.uid, "poke")
	
    btype = getPokeballType(thisball.itemid)

        if #getCreatureSummons(owner) > 1 then
           BackTeam(owner, getCreatureSummons(owner))      
        end

		doSendMagicEffect(getThingPos(cid), pokeballs[btype].effect)
        doTransformItem(thisball.uid, pokeballs[btype].off)

		doPlayerSendTextMessage(owner, 22, "Tu Pokémon se debilitó.")

	local say = deathtexts[math.random(#deathtexts)]
		say = string.gsub(say, "POKENAME", getCreatureName(cid))

	if getPlayerStorageValue(cid, 33) <= 0 then
		doCreatureSay(owner, say, TALKTYPE_SAY)
	end

	doItemSetAttribute(thisball.uid, "hp", 0)
	if ehMonstro(deathList[1]) then
	   doItemSetAttribute(thisball.uid, "happy", getPlayerStorageValue(cid, 1008) - happyLostOnDeath)
    end
	doItemSetAttribute(thisball.uid, "hunger", getPlayerStorageValue(cid, 1009))

    if useOTClient then
       doPlayerSendCancel(owner, '12//,hide')      --alterado v1.7
    end

	doRemoveCreature(cid)

return false
end