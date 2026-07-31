function onStepIn(cid, item, position, fromPosition)
local quizofdeathNpc = getCreatureByName("Quizmaster ")
if not isPlayer(cid) then return true end
doCreatureSetNoMove(cid, true)
doAddCondition(cid, fight)
setPlayerStorageValue(quizofdeathNpc, 2, cid)
setPlayerStorageValue(quizofdeathNpc, 4, 1)
doCreatureSay(quizofdeathNpc, "Welcome "..getCreatureName(cid)..", let's play the quiz of death. Do want to know the full rules?", 1)
return true
end