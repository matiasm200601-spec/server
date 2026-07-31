function onSay(cid, words, param)
if(doPlayerRemoveItem(cid, 2366, 1) == true) then
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Parabéns! Agora você é VIP (05 dias)")
doPlayerAddPremiumDays(cid, 5)
else
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "¡Necesitas un objeto especial!")
end
return TRUE
end

