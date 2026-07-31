function onUse(cid, item, fromPosition, itemEx, toPosition)
                                                --script soh pra zoaçao...
if item.actionid == 24245 then
   doPlayerSendTextMessage(cid, 20, "Ahh then you think here is a reward? Sorry man...")
   doSendAnimatedText(getThingPos(cid), "Fool!!", 150)
   return true
end
end