function onStepIn(cid, item, position, fromPosition)
if not isPlayer(cid) then return true end
if not isPremium(cid) then
doTeleportThing(cid, fromPosition, true)
doPlayerSendTextMessage(cid, 27, "Somente Premium Accounts. Adquira sua VIP")
doSendMagicEffect(getThingPos(cid), CONST_ME_MAGIC_BLUE)
return true
end
doPlayerSendTextMessage(cid, 27, "Bem-Vindo à Area VIP !") --Pode mudar a frase se quiser !!
return true
end