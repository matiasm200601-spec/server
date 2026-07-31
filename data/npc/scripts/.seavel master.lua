local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function creatureSayCallback(cid, type, msg)
if(not npcHandler:isFocused(cid)) then
return false
end

local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
 
rank = {"a Seavell Drop", "a Seavell Icelake","a Seavell Waterfall","a Seavell Frost","a Seavell Master"}
       
        if msgcontains(msg, 'clan') or msgcontains(msg, 'Clan') then
           if getPlayerStorageValue(cid, 86228) == 2 then 
              selfSay("You already are of the clan seavel!", cid)
              talkState[talkUser] = 0
              return true
           elseif getPlayerStorageValue(cid, 86228) >= 1 then
              selfSay("You already are of another clan!", cid)
              talkState[talkUser] = 0
              return true    
           end
              selfSay("So you want to join in my clan... Are you sure that?", cid)
              talkState[talkUser] = 2  
        elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'Yes')) and talkState[talkUser] == 2 then
           if getPlayerLevel(cid) < 80 then
              selfSay("You are too weak yet... You need to be atleast level 80 to enter in the clan!", cid)
              talkState[talkUser] = 0
              return true
           end
           selfSay("OK then... Now you are a great member of de clan seavel!", cid)
           setPlayerStorageValue(cid, 86228, 2)
           setPlayerStorageValue(cid, 862281, 1)
           setPlayerStorageValue(cid, 181619, 1)
           talkState[talkUser] = 0
        elseif msgcontains(msg, 'rank') or msgcontains(msg, 'rank') then
           if getPlayerStorageValue(cid, 86228) == 2 then 
              selfSay("So.. you want to move up of rank?", cid)
              talkState[talkUser] = 3
           else
              selfSay("You aren't of the clan seavel! Get out of here!", cid)
              talkState[talkUser] = 0
              return true
           end
        elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'Yes')) and talkState[talkUser] == 3 then 
           level = 80
           if (getPlayerStorageValue(cid, 862281)+1) == 2 then
              level = 90
           elseif (getPlayerStorageValue(cid, 862281)+1) == 3 then
              level = 100
           elseif (getPlayerStorageValue(cid, 862281)+1) == 4 then
              level = 110
           elseif (getPlayerStorageValue(cid, 862281)+1) == 5 then
              level = 120
           end 
           
           if getPlayerLevel(cid) < level then
              selfSay("You are too weak yet... You need to be atleast level "..level.." to move up of rank!", cid)
              talkState[talkUser] = 0
              return true
           end
           if getPlayerStorageValue(cid, 862281) == 5 then
              selfSay("You are already a master of our clan!", cid)
              talkState[talkUser] = 0
              return true
           end
           setPlayerStorageValue(cid, 862281, getPlayerStorageValue(cid, 862281)+1)
           if getPlayerStorageValue(cid, 862281) == 5 then
              setPlayerStorageValue(cid, 181622, 1)
           end
           selfSay("So here we are... You are now a "..rank[getPlayerStorageValue(cid, 862281)]..", rank "..getPlayerStorageValue(cid, 862281).." of our clan!", cid)        
           talkState[talkUser] = 0
           
        elseif msgcontains(msg, 'shiny') or msgcontains(msg, 'Shiny') then
           if getPlayerStorageValue(cid, 86228) ~= 2 then
              selfSay("You aren't of the clan Seavel! Get out of here!", cid)
              return true
           else   
              selfSay("So you want to transform your Vaporeon in a Shiny Vaporeon? It will cost 500k!", cid)
              talkState[talkUser] = 4
           end
        elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'Yes')) and talkState[talkUser] == 4 then
           if getPlayerSlotItem(cid, 8).uid <= 0 then
              selfSay("Sorry, you don't have a pokemon in the main slot!", cid)
              talkState[talkUser] = 0
		      return true
	       end 
	                                                                             --alterado v1.2
	       if #getCreatureSummons(cid) >= 1 then
	          selfSay("Go back your pokemon!", cid)
              talkState[talkUser] = 0
              return true
           end
	       
	       local pb = getPlayerSlotItem(cid, 8).uid
	       
	       if getItemAttribute(pb, "poke") ~= "Vaporeon" then
	          selfSay("Put a Vaporeon's pokeball atleast +20 in main slot!", cid)
              talkState[talkUser] = 0
              return true
           end
              
           if not getItemAttribute(pb, "boost") or getItemAttribute(pb, "boost") < 20 then
              selfSay("Sorry, your Vaporeon is not boosted +20!", cid)
              talkState[talkUser] = 0
              return true
           end
                                          --100000 = 1k, 1000000 = 10k, 10000000 = 100k
           if doPlayerRemoveMoney(cid, 50000000) == true then
              selfSay("So there is it! Enjoy!", cid)
              doItemSetAttribute(pb, "hp", 1)
              doItemSetAttribute(pb, "poke", "Shiny Vaporeon")
		      doItemSetAttribute(pb, "description", "Contains a Shiny Vaporeon.")
		      doItemEraseAttribute(pb, "boost")
		      doTransformItem(getPlayerSlotItem(cid, 7).uid, fotos["Shiny Vaporeon"])
		      if useKpdoDlls then
		        doCreatureExecuteTalkAction(cid, "/pokeread")
	          end
		      talkState[talkUser] = 0
		      return true
	      else
	          selfSay("You don't have enough money!", cid)
	          talkState[talkUser] = 0
	          return true
          end
        end

return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())             