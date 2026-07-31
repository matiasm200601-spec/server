function onSay(cid,words,param)
local pokemons = getCreatureSummons(cid)
if #pokemons == 0 then
return doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Saca tu Pokémon de la Poké Ball.")
end
doCreatureSay(getCreatureSummons(cid)[1],param,TALKTYPE_SAY)
return true
end