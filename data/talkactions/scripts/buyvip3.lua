function onSay(cid, words, param)
if(doPlayerRemoveItem(cid, 2159, 20) == true) then
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Parabéns! Agora você é VIP (30dias)")
doPlayerAddPremiumDays(cid, 60)
else
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Vocé Precisa De 20 Scarab Coins.")
end
return TRUE
end

