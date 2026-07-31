function onSay(cid, words, param)
if #getCreatureSummons(cid) == 0 then
return doPlayerSendCancel(cid, "No tienes ningún Pokémon.")
end


local summons = getCreatureSummons(cid)[1]
local mon = getCreatureName(summons)

if getCreatureSpeed(summons) >= 1 then
	doChangeSpeed(summons, -getCreatureSpeed(summons))
	doCreatureSay(cid, ""..mon..", hold position!", TALKTYPE_SAY)
else
	doRegainSpeed(summons)
	doCreatureSay(cid, ""..mon..", deja de sostener!", TALKTYPE_SAY)
end
return 0
end