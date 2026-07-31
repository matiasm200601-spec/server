function onSay(cid, words, param)
if(doPlayerRemoveItem(cid, 2159, 12) == true) then
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Parabéns! Agora você é VIP (30 dias)")
doPlayerAddPremiumDays(cid, 30)
else
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Vocé Precisa De 12 Scarab Coins.")
end
return TRUE
end

