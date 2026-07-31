local evo = {
["Phione"] = {"Manaphy", 1},
["Shiny Phione"] = {"Shiny Manaphy", 1},
["Dialga"] = {"Primal Dialga", 1},
["Raikou"] = {"Shiny Raikou", 1},
["Entei"] = {"Shiny Entei", 1},
["Suicune"] = {"Shiny Suicune", 1},
["Mesprit"] = {"Shiny Mesprit", 1},
["Uxie"] = {"Shiny Uxie", 1},
}
local balls = {
[11826] = {newBall = 11737},
[11832] = {newBall = 11740},
[11835] = {newBall = 11743},
[11829] = {newBall = 11746},
[10975] = {newBall = 12621},
}
 
function onUse(cid, item, fromPosition, itemEx, toPosition)
   if isMonster(itemEx.uid) and getCreatureMaster(itemEx.uid) == cid then
          local monster = getCreatureName(itemEx.uid)
          if evo[monster] then  
                 if getPlayerItemCount(cid, item.itemid) >= evo[monster][2] then
                    doPlayerSendTextMessage(cid, 27, "Parabens! Seu "..getPokeName(itemEx.uid).." evoluiu para "..evo[monster][1].."!")
                    local health, maxHealth = getCreatureHealth(itemEx.uid), getCreatureMaxHealth(itemEx.uid)
                    doSendMagicEffect(getThingPos(itemEx.uid), 18)
                    doRemoveCreature(itemEx.uid)
                    doPlayerRemoveItem(cid, item.itemid, evo[monster][2]-1)
                    doRemoveItem(item.uid, 1)
                    doSummonMonster(cid,evo[monster][1])
                    local pokeball = getPlayerSlotItem(cid, 8)
                    doItemSetAttribute(pokeball.uid, "poke", evo[monster][1])
                    doItemSetAttribute(pokeball.uid, "level", pokes[evo[monster][1]].level)
                    doItemSetAttribute(ball, "hp", 1)
                    doItemSetAttribute(ball, "happy", 110)
                    local pk = getCreatureSummons(cid)[1]
                    local getShinyPokeballs = balls[getPlayerSlotItem(cid, 8).itemid]
                    doTransformItem(getPlayerSlotItem(cid, 8).uid, getShinyPokeballs.newBall)
                    adjustStatus(pk, pokeball.uid, true, false, true)
                    return TRUE
                 else
                    return doPlayerSendTextMessage(cid, 27, "You need atleast ".. evo[monster][2] .." stones to do it!")
                 end
          end
end
return FALSE
end