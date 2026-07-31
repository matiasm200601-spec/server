function onThink(cid, interval)
--////////////////////////  DUEL POR PARTY //////////////////////////////////////--
if isInParty(cid) and getPlayerStorageValue(cid, 52480) <= -1 then
local party = getPartyMembers(cid)                                        
if #party >= 2 then
   setPlayerStorageValue(cid, 52480, 1)                                   --alterado v1.6 duel system
   if getPlayerStorageValue(cid, 52481) <= -1 then
      setPlayerStorageValue(cid, 52481, getPlayerStorageValue(party[2], 52481))
   end
   doSendAnimatedText(getThingPos(cid), "BATTLE", COLOR_ELECTRIC) 
   return true
end
   doPlayerSetVocation(cid, 8) 
   openChannelDialog(cid)
   setPlayerStorageValue(cid, 52480, 1)
end

return true
end