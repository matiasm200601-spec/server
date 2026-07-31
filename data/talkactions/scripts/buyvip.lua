function onSay(cid, words, param)
if(doPlayerRemoveItem(cid, 2159, 07) == true) then
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Parabéns! Agora você é VIP (15 dias)")
doPlayerAddPremiumDays(cid, 15)
else
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Vocé Precisa De 07 Scarab Coins.")
end
return TRUE
end

