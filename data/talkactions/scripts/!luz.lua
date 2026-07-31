local minutes = 10 -- Minutes

function onSay(cid, words, param)
if isPlayer(cid) then
doSetCreatureLight(cid, 8, 215, minutes*60*1000)
doSendAnimatedText(getCreaturePosition(cid), "Luz!", math.random(1, 255))
end
return true
end