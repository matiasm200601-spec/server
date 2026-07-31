local msgs = {
[1] = {go = "Go, doka!", back = "Come back, doka!"},
[2] = {go = "Let's do it, doka!", back = "Thanks for helping, doka!"},
[3] = {go = "I choose you, doka!", back = "That's enough, come back!"},
[4] = {go = "I need your help, doka!", back = "You were great, doka!"},
[5] = {go = "Let's fight, doka!", back = "Excellent work, doka!"},
[6] = {go = "It's battle time, doka!", back = "Well done, doka!"}
}

function onUse(cid, item, frompos, item2, topos)

if getCreatureCondition(cid, CONDITION_OUTFIT) == true then
return true
end

if item.itemid == 2222 or item.itemid == 2223 then
gobackeff = 10
elseif item.itemid == 2220 or item.itemid == 2221 then
gobackeff = 191
elseif item.itemid == 11362 or item.itemid == 11363 then
gobackeff = 189
elseif item.itemid == 11365 or item.itemid == 11366 then
gobackeff = 190
end
local effect = gobackeff

if item.itemid == 2223 or item.itemid == 2221 or item.itemid == 11363 or item.itemid == 11366 then

for a, b in pairs(ginasios) do
if getPlayerStorageValue(cid, b.storage) == 1 then -- GYM
doPlayerSendCancel(cid, "You can't return your pokemon during gym battles.")
return true
end
end

if #getCreatureSummons(cid) <= 0 then
doTransformItem(item.uid, item.itemid-1)
doItemSetAttribute(item.uid, "hp", 0)
return true
end

local z = getCreatureSummons(cid)[1]
local pokename = getCreatureName(z)
local mbk = msgs[math.random(1, 6)].back:gsub("doka", pokename)

doTransformItem(item.uid, item.itemid-1)
doCreatureSay(cid, mbk, TALKTYPE_SAY)

local pokelife = (getCreatureHealth(z) / getCreatureMaxHealth(z))
doItemSetAttribute(item.uid, "hp", pokelife)

setPlayerStorageValue(cid, 61204, 0)
setPlayerStorageValue(cid, 2, 0)

doSendMagicEffect(getCreaturePosition(z), effect)
doRemoveCreature(z)

elseif item.itemid == 2222 or item.itemid == 2220 or item.itemid == 11362 or item.itemid == 11365 then

if item.uid ~= getPlayerSlotItem(cid, CONST_SLOT_FEET).uid then
doPlayerSendCancel(cid, "You must put your pokeball in the correct place!")
return TRUE
end

local pokemon = getItemAttribute(item.uid, "poke")

if not pokes[pokemon] then
return true
end

local x = pokes[pokemon]

if getPlayerLevel(cid) < x.level then
doPlayerSendCancel(cid, "You need level "..x.level.." or higher to use this pokemon.")
return true
end


if getItemAttribute(item.uid, "nick") ~= "?" then
doSummonMonster(cid, getItemAttribute(item.uid, "nick"))
else
doSummonMonster(cid, pokemon)
end

local pk = getCreatureSummons(cid)[1]
doTeleportThing(pk, getClosestFreeTile(pk, getThingPos(cid)), false)

if getItemAttribute(item.uid, "nick") ~= "?" then
setPlayerStorageValue(pk, 333, "")
setPlayerStorageValue(pk, 333, ""..pokemon.."")
end

doCreatureSetLookDir(pk, 2)

local mh = (getCreatureMaxHealth(pk) + (x.cons * getPlayerLevel(cid)))
local rd = 1 - (tonumber(getItemAttribute(item.uid, "hp")))

setCreatureMaxHealth(pk, mh)
doCreatureAddHealth(pk, getCreatureMaxHealth(pk))
doCreatureAddHealth(pk, -(getCreatureMaxHealth(pk) * rd))

doTransformItem(item.uid, item.itemid+1)

local pokename = getCreatureName(getCreatureSummons(cid)[1])
local mgo = msgs[math.random(1, 6)].go:gsub("doka", pokename)
doCreatureSay(cid, mgo, TALKTYPE_SAY)

doSendMagicEffect(getCreaturePosition(pk), effect)

registerCreatureEvent(pk, "DiePoke")
registerCreatureEvent(pk, "Exp")

if getItemAttribute(item.uid, "burn") ~= nil and getItemAttribute(item.uid, "burn") >= 1 then
addEvent(doBurn, 3700, pk, pk, getItemAttribute(item.uid, "burn"), getItemAttribute(item.uid, "burndmg"))
end

if getItemAttribute(item.uid, "poison") ~= nil and getItemAttribute(item.uid, "poison") >= 1 then
addEvent(doPoison, 1200, pk, pk, getItemAttribute(item.uid, "poison"), getItemAttribute(item.uid, "poisondmg"))
end

if getItemAttribute(item.uid, "confuse") ~= nil and getItemAttribute(item.uid, "confuse") >= 1 then
addEvent(doConfuse, 1200, pk, getItemAttribute(item.uid, "confuse"))
end

if getItemAttribute(item.uid, "blind") ~= nil and getItemAttribute(item.uid, "blind") >= 1 then
addEvent(doBlind, 300, pk, getItemAttribute(item.uid, "blind"), getItemAttribute(item.uid, "blindef"))
end

end
return TRUE
end