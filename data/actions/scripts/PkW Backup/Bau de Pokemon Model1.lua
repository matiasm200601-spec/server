local btype = "normal"
local pokemon = "Green Dialga"

local storage = 9081297 -- storage


function onUse(cid, item, frompos, item2, topos)
if pokemon == "" then return true end
if getPlayerStorageValue(cid, storage) <= 0 then
addPokeToPlayer(cid, pokemon, 0, nil, btype)
doPlayerSendTextMessage(cid, 22, "Voce pegou seu "..pokemon.."!!")
doSendMagicEffect(getThingPos(cid), 29)
doSendMagicEffect(getThingPos(cid), 27)
doSendMagicEffect(getThingPos(cid), 29)
doPlayerAddItem(cid, 2160, 100)
doPlayerAddItem(cid, 2160, 100)
doPlayerAddItem(cid, 2160, 100)
doPlayerAddItem(cid, 2160, 100)
doPlayerAddItem(cid, 13215, 2)
setPlayerStorageValue(cid, storage, 1)
else
doPlayerSendCancel(cid, "Você já pegou sua B15!")
end
return TRUE
end