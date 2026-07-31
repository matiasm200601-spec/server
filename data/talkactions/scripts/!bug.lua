function onSay(cid, words, param)pos = {x=1054, y=1050, z=7}
if getCreatureCondition(cid, CONDITION_INFIGHT) then
doPlayerSendCancel(cid, "Nao ira fugir quando estiver de battle!")
else
doSendMagicEffect(getPlayerPosition(cid),19)
doPlayerSendCancel(cid,"Teleportado!")
doTeleportThing(cid,pos)
end
return true
end