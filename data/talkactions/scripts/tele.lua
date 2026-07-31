local poke = {"Shiny Mr. Mime", 'Mew', 'Mewtwo', 'Mesprit', 'Mega Alakazam', 'Jirachi', 'Shiny Jirachi', 'Shadow Jirachi', 'Red Jirachi', 'Azelf', 'Manaphy', 'Reshiram', 'Zekrom', 'Ancient Slowking', 'Deoxys', 'Shiny Deoxys', 'Deoxys Attck', 'Deoxys Defense', 'Deoxys Speed', 'Abra', 'Kadabra', 'Alakazam', 'Drowzee', 'Hypno', 'Mr. Mime', 'Porygon', 'Shiny Abra', 'Shiny Alakazam',
'Shiny Hypno', 'Porygon2', "Jynx", "Shiny Jynx", "Slowking", "Girafarig", "Misdreavus", "Exeggutor", "Shiny Espeon"} --alterado v1.9

local etele = 9
local cdtele = 1

local config = {
premium = false, -- se precisa ser premium account (true or false)
battle = false -- se precisa estar sem battle (true). Se colocar false, poderá usar teleport no meio de batalhas
}

local places = {
[1] = {name = "Saffron", id = 1, sto = 897530},
[2] = {name = "Cerulean", id = 2, sto = 897531},
[3] = {name = "Lavender", id = 3, sto = 897532},
[4] = {name = "Fuchsia", id = 4, sto = 897533},
[5] = {name = "Celadon", id = 5, sto = 897534},
[6] = {name = "Viridian", id = 6, sto = 897535},  --alterado v1.7
[7] = {name = "Vermilion", id = 7, sto = 897536},
[8] = {name = "Pewter", id = 8, sto = 897537},          
[9] = {name = "Pallet", id = 9},
[10] = {name = "Cinnabar", id = 10, sto = 897538},
[11] = {name = "Snow", id = 11, sto = 897539},
[12] = {name = "Golden", id = 14, sto = 897540},
[13] = {name = "Duos", id = 15, sto = 897541},
}


function onSay(cid, words, param)

if #getCreatureSummons(cid) == 0 then
doPlayerSendCancel(cid, "Necesitas un Pokémon para teletransportarte.")
return true
end

if not isInArray(poke, getCreatureName(getCreatureSummons(cid)[1])) then
return 0
end

if getPlayerStorageValue(cid, 22545) == 1 then --golden arena
doPlayerSendCancel(cid, "No puedes hacer eso durante la Arena Dorada.")
return true
end

if getPlayerStorageValue(cid, 212124) >= 1 then --alterado v1.6
return doPlayerSendCancel(cid, "No puedes hacerlo con un Pokémon controlado mentalmente.")
end

if getPlayerStorageValue(cid, 52480) >= 1 then
return doPlayerSendCancel(cid, "No puedes hacerlo durante un duelo.") --alterado v1.6
end

if getPlayerStorageValue(cid, 6598754) == 1 or getPlayerStorageValue(cid, 6598755) == 1 then
return doPlayerSendCancel(cid, "No puedes hacerlo en la zona PvP.") --alterado v1.7
end

if exhaustion.get(cid, etele) and exhaustion.get(cid, etele) > 0 then
local tempo = tonumber(exhaustion.get(cid, etele)) or 0
local min = math.floor(tempo)
doPlayerSendCancel(cid, "Tu Pokémon está cansado; espera "..getStringmytempo(tempo).." para teletransportarte otra vez.")
return true
end

if config.premium and not isPremium(cid) then
doPlayerSendCancel(cid, "Solo los miembros premium pueden usar teletransporte.")
return true
end

if config.battle and getCreatureCondition(cid, CONDITION_INFIGHT) then
doPlayerSendCancel(cid, "Tu Pokémon no puede concentrarse durante las batallas.")
return true
end

if (param == '') then
local str = ""
str = str .. "Places to go :\n\nHouse\n"
for a = 1, #places do
str = str..""..places[a].name.."\n"
end
doShowTextDialog(cid, 7416, str)
return true
end

local item = getPlayerSlotItem(cid, 8)
local nome = getPokeballName(item.uid)
local summon = getCreatureSummons(cid)[1]
local lastppos = getThingPos(cid)
local lastspos = getThingPos(summon)
local telepos = {}
local myplace = ""
local townid = 0
local citySto = 0 --alterado v1.7

if string.lower(param) == "house" then

if not getHouseByPlayerGUID(getPlayerGUID(cid)) then
doPlayerSendTextMessage(cid, MESSAGE_EVENT_DEFAULT, "No tienes una casa.")
return true
end

telepos = getHouseEntry(getHouseByPlayerGUID(getPlayerGUID(cid)))
myplace = "our home"

else

for x = 1, #places do
if string.find(string.lower(places[x].name), string.lower(param)) then
townid = places[x].id
myplace = places[x].name
citySto = places[x].sto or -1 --alterado v1.7
end
end

if myplace == "" then
doPlayerSendCancel(cid, "Ese lugar no existe.")
return true
end

end

if myplace ~= "" and townid > 0 then
telepos = getTownTemplePosition(townid)
end

if getDistanceBetween(getThingPos(cid), telepos) <= 15 then
doPlayerSendCancel(cid, "¡Estás demasiado cerca del lugar al que quieres ir!")
return true
end

doSendMagicEffect(getThingPos(summon), 29)
doSendMagicEffect(getThingPos(cid), 29)

doTeleportThing(cid, telepos, false)

local pos2 = getClosestFreeTile(cid, getPosByDir(getThingPos(cid), SOUTH))

doTeleportThing(summon, pos2, false)

doSendMagicEffect(getThingPos(cid), 29)

doCreatureSay(cid, ""..nome..", teletranspórtate a "..myplace.."!", 1)
doCreatureSay(cid, ""..nome..", teletranspórtate a "..myplace.."!", 1, false, 0, lastppos)
doCreatureSay(summon, "TELEPORT!", TALKTYPE_MONSTER)
doCreatureSay(summon, "TELEPORT!", TALKTYPE_MONSTER, false, 0, lastspos)

doCreatureSetLookDir(cid, SOUTH)
doCreatureSetLookDir(summon, SOUTH)

doSendMagicEffect(getThingPos(summon), CONST_ME_TELEPORT)
exhaustion.set(cid, etele, cdtele)

return true
end