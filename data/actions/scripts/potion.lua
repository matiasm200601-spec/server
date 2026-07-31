function doHealOverTime(cid, div, turn, effect)                     --alterado v1.6 peguem o script todo!!
if not isCreature(cid) then return true end

if turn <= 0 or (getCreatureHealth(cid) == getCreatureMaxHealth(cid)) or getPlayerStorageValue(cid, 173) <= 0 then 
   setPlayerStorageValue(cid, 173, -1)
   return true 
end

local d = div / 10000
local amount = math.floor(getCreatureMaxHealth(cid) * d)
doCreatureAddHealth(cid, amount)
if math.floor(turn/10) == turn/10 then
   doSendMagicEffect(getThingPos(cid), effect)
end
if useOTClient then
   onPokeHealthChange(getCreatureMaster(cid)) --alterei aki
end
addEvent(doHealOverTime, 100, cid, div, turn - 1, effect)
end

local potions = {
[12347] = {effect = 13, div = 30}, --super potion
[12348] = {effect = 13, div = 60}, --great potion              
[12346] = {effect = 12, div = 80}, --ultra potion
[12345] = {effect = 14, div = 90}, --hyper potion
}

function onUse(cid, item, frompos, item2, topos)
local pid = getThingFromPosWithProtect(topos)

if not isCreature(pid) or not isSummon(pid) then
return doPlayerSendCancel(cid, "¡Solo puedes usar pociones en Pokémon!")
end

if getCreatureMaster(pid) ~= cid then
return doPlayerSendCancel(cid, "¡Solo puedes usar pociones en tus propios Pokémon!")
end

if getCreatureHealth(pid) == getCreatureMaxHealth(pid) then
return doPlayerSendCancel(cid, "Este Pokémon ya tiene la salud completa.")
end

if getPlayerStorageValue(pid, 173) >= 1 then
return doPlayerSendCancel(cid, "Este Pokémon ya está bajo los efectos de una poción.")
end

if getPlayerStorageValue(cid, 52481) >= 1 then
return doPlayerSendCancel(cid, "No puedes hacer eso durante un duelo.")
end
 
doCreatureSay(cid, ""..getCreatureName(pid)..", ¡toma esta poción!", TALKTYPE_SAY)
doSendMagicEffect(getThingPos(pid), 172)
setPlayerStorageValue(pid, 173, 1)
doRemoveItem(item.uid, 1)

local a = potions[item.itemid]
doHealOverTime(pid, a.div, 100, a.effect)

return true
end