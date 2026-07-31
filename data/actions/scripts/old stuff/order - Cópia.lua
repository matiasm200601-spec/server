local skills = {
["rock smash"] = {"Sandshrew", "Sandslash", "Diglett", "Dugtrio", "Primeape", "Machop", "Machoke", "Machamp", "Geodude", "Graveler", "Golem" , "Onix", "Cubone", "Marowak", "Rhyhorn", "Rhydon", "Kangaskhan", "Tauros", "Snorlax", "Poliwrath", "Hitmonlee", "Hitmonchan", "Aerodactyl", "Charizard", "Blastoise", "Typhlosion", "Feraligatr", "Furret", "Ledian", "Ampharos", "Politoed", "Quagsire", "Forretress", "Steelix", "Snubbull", "Granbull", "Sudowoodo", "Gligar", "Scizor", "Heracross", "Sneasel", "Ursaring", "Teddiursa", "Slugma", "Magcargo", "Piloswine", "Swinub", "Corsola", "Phanpy", "Donphan", "Tyrogue", "Hitmontop", "Miltank", "Blissey", "Tyranitar", "Pupitar"},
["cut"] = {"Raticate", "Bulbasaur", "Ivysaur", "Venusaur", "Charmeleon", "Sandshrew", "Sandslash", "Gloom", "Vileplume", "Paras", "Parasect", "Meowth", "Persian", "Bellsprout", "Weepinbell", "Victreebel", "Farfetchd", "Krabby", "Kingler", "Exeggutor", "Cubone", "Marowak", "Tangela", "Scyther", "Pinsir", "Chikorita", "Bayleef", "Meganium", "Croconow", "Feraligatr", "Furret", "Bellossom", "Hoppip", "Skiploom", "Jumpluff", "Sunkern", "Sunflora", "Scizor", "Heracross", "Sneasel", "Teddiursa", "Ursaring", "Gligar", "Skarmory"},
["light"] = {"Abra", "Kadabra", "Alakazam", "Magnemite", "Magneton", "Drowzee", "Hypno", "Voltorb", "Electrode", "Mrmime", "Electabuzz", "Jolteon", "Porygon", "Pikachu", "Raichu", "Chinchou", "Lanturn", "Pichu", "Natu", "Xatu", "Mareep", "Flaaffy", "Ampharos", "Espeon", "Porygon2", "Elekid"}, 
["digholes"] = {"468", "481", "483"},
["dig"] = {"Raticate", "Sandshrew", "Sandslash", "Diglett", "Dugtrio", "Primeape", "Machop", "Machoke", "Machamp", "Geodude", "Graveler", "Golem" , "Onix", "Cubone", "Marowak", "Rhyhorn", "Rhydon", "Kangaskhan", "Tauros", "Snorlax", "Eevee", "Dunsparce", "Flareon", "Jolteon", "Vaporeon", "Espeon", "Umbreon", "Vulpix", "Ninetales", "Nidorina", "Nidoqueen", "Nidorino", "Nidoking", "Persian", "Arcanine", "Typhlosion", "Feraligatr", "Furret", "Ledian", "Sudowoodo", "Politoed", "Quagsire", "Gligar", "Steelix", "Snubbull", "Granbull", "Heracross", "Sneasel", "Teddiursa", "Ursaring", "Piloswine", "Hitmontop", "Larvitar", "Pupitar", "Tyranitar"},
["blink"] = {"Abra", "Kadabra", "Alakazam", "Porygon", "Porygon2"},
["fly"] = {"Porygon", "Aerodactyl", "Dragonite", "Charizard", "Pidgeot", "Fearow", "Zapdos", "Moltres", "Articuno", "Mew", "Mewtwo", "Porygon2", "Skarmory", "Crobat"},
["ride"] = {"Crystal Onix", "Venusaur", "Ninetales", "Arcanine", "Ponyta", "Rapidash", "Doduo", "Dodrio", "Onix", "Rhyhorn", "Tauros", "Steelix", "Houndoom", "Meganium", "Bayleef", "Stantler", "Mareep", "Piloswine"},
}

local txt = {
["rock smash"] = {"break that rock!", "smash that rock!", "destroy that rock!", "smash it!", "break it!", "destroy it!"},
["cut"] = {"cut that bush!", "cut it down!", "cut it off!", "cut off that bush!", "cut down that bush!", "cut that bush down!"},
["move"] = {"move!", "move there!", "go there!", "walk there!"},
["light"] = {"flash!", "light!", "flash this place!", "light up this place!"},
["dig"] = {"open that hole!", "dig that hole!", "open it!", "dig it!"},
["blink"] = {"teleport there!", "blink there!", "blink!", "teleport!"},
["ride"] = {"let me ride you!", "let's ride!", "let me mount you!", "let me get on you!"},
["fly"] = {"let's fly!", "let me get on you!"}
}

-- NAME OUTFIT SPEED
local flys = {
["Moltres"] = {229, 2300}, -- moltres
["Articuno"] = {230, 2100}, -- artic
["Zapdos"] = {224, 2600}, -- zapdos
["Mew"] = {232, 2200}, -- 1000
["Mewtwo"] = {233, 2200},-- two
["Dragonite"] = {221, 1300},-- nite
["Pidgeot"] = {222, 900}, -- geot
["Fearow"] = {226, 800}, -- fearow
["Aerodactyl"] = {227, 1100}, -- aero
["Charizard"] = {216, 1000}, -- chari
["Porygon"] = {316, 600}, -- porygon
}

function onUse(cid, item, frompos, item2, topos)

--------END FLY/RIDE --------
if getCreatureCondition(cid, CONDITION_OUTFIT) then

	if getTileInfo(getThingPos(cid)).itemid == 460 or getTileInfo(getThingPos(cid)).itemid == 1023 or getTileInfo(getThingPos(cid)).itemid == 1022 then
        doPlayerSendCancel(cid, "You can\'t stop flying at this height!")
        return true
        end

	local item = getPlayerSlotItem(cid, 8)
	local pokemon = getItemAttribute(item.uid, "poke")
	local x = pokes[pokemon]

        if getTileInfo(getThingPos(cid)).itemid >= 4820 and getTileInfo(getThingPos(cid)).itemid <= 4825 then
        doPlayerSendCancel(cid, "You can\'t stop flying above the water!")
        return true
        end

	if getItemAttribute(item.uid, "nick") ~= "?" then
	doSummonMonster(cid, getItemAttribute(item.uid, "nick"))
	else
	doSummonMonster(cid, pokemon)
	end

	local pk = getCreatureSummons(cid)[1]
	doTeleportThing(pk, getThingPos(cid), false)
	doCreatureSetLookDir(pk, getCreatureLookDir(cid))

	if getItemAttribute(item.uid, "nick") ~= "?" then
	setPlayerStorageValue(pk, 333, "")
	setPlayerStorageValue(pk, 333, ""..pokemon.."")
	end

	local mh = (getCreatureMaxHealth(pk) + (x.cons * getPlayerLevel(cid)))
	local rd = 1 - (tonumber(getItemAttribute(item.uid, "hp")))

	setCreatureMaxHealth(pk, mh)
	doCreatureAddHealth(pk, getCreatureMaxHealth(pk))
	doCreatureAddHealth(pk, -(getCreatureMaxHealth(pk) * rd))

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

	doPlayerSay(cid, ""..getCreatureName(getCreatureSummons(cid)[1])..", let me get down!", 1)
	doChangeSpeed(cid, - getCreatureSpeed(cid))
	doChangeSpeed(cid, PlayerSpeed)
	doRemoveCondition(cid, CONDITION_OUTFIT)
	setPlayerStorageValue(cid, 17000, -1)

return true
end
-----------------------------

if #getCreatureSummons(cid) == 0 then return doPlayerSendCancel(cid, "You need a pokemon to use order!") end

-------- ROCK SMASH ---------
if item2.itemid == 1285 and isInArray(skills["rock smash"], getPokemonName(getCreatureSummons(cid)[1])) then

	if getMarkedPos(getCreatureSummons(cid)[1]).x == topos.x and getMarkedPos(getCreatureSummons(cid)[1]).y == topos.y then
	return true
	end

	markPos(getCreatureSummons(cid)[1], topos)
	markOwnerPos(getCreatureSummons(cid)[1], getThingPos(cid))
	doPlayerSay(cid, ""..getCreatureName(getCreatureSummons(cid)[1])..", "..txt["rock smash"][math.random(1, #txt["rock smash"])].."", 1)
	addEvent(goThere, 500, getCreatureSummons(cid)[1], topos, "rock smash", isCreature(getCreatureTarget(cid)))

return true
end
-----------------------------


-------- CUT ----------------
if item2.itemid == 2767 and isInArray(skills["cut"], getPokemonName(getCreatureSummons(cid)[1])) then

	if getMarkedPos(getCreatureSummons(cid)[1]).x == topos.x and getMarkedPos(getCreatureSummons(cid)[1]).y == topos.y then
	return true
	end

	markPos(getCreatureSummons(cid)[1], topos)
	markOwnerPos(getCreatureSummons(cid)[1], getThingPos(cid))
	doPlayerSay(cid, ""..getCreatureName(getCreatureSummons(cid)[1])..", "..txt["cut"][math.random(1, #txt["cut"])].."", 1)
	addEvent(goThere, 500, getCreatureSummons(cid)[1], topos, "cut", isCreature(getCreatureTarget(cid)))

return true
end
-----------------------------


-------- LIGHT --------------
if isMonster(item2.uid) and getCreatureMaster(item2.uid) == cid then

	if not isInArray(skills["light"], getPokemonName(item2.uid)) then
	doPlayerSendCancel(cid, "Your pokemon can't use flash.")
	return true
	end
	
	if ballcooldown.check(cid, "light") then
	doPlayerSendCancel(cid, "Your pokemon is too tired to use flash. cooldown: ("..ballcooldown.get(cid, "light")..")")
	return true
	end

	doPlayerSay(cid, ""..getCreatureName(getCreatureSummons(cid)[1])..", "..txt["light"][math.random(1, #txt["light"])].."", 1)
	doCreatureSay(getCreatureSummons(cid)[1], "FLASH!", TALKTYPE_MONSTER)
	doSendMagicEffect(getThingPos(getCreatureSummons(cid)[1]), 28)
	doSetCreatureLight(getCreatureSummons(cid)[1], 8, 215, 600*1000)
	ballcooldown.set(cid, "light", 15)

return true
end
-----------------------------




-------- DIG ----------------
if isInArray(skills["digholes"], item2.itemid) and isInArray(skills["dig"], getPokemonName(getCreatureSummons(cid)[1])) then

	if getMarkedPos(getCreatureSummons(cid)[1]).x == topos.x and getMarkedPos(getCreatureSummons(cid)[1]).y == topos.y then
	return true
	end

	markPos(getCreatureSummons(cid)[1], topos)
	markOwnerPos(getCreatureSummons(cid)[1], getThingPos(cid))
	doPlayerSay(cid, ""..getCreatureName(getCreatureSummons(cid)[1])..", "..txt["dig"][math.random(1, #txt["dig"])].."", 1)
	addEvent(goThere, 500, getCreatureSummons(cid)[1], topos, "dig", isCreature(getCreatureTarget(cid)))

return true
end
-----------------------------


-------- BLINK / MOVE -------
if not isCreature(item2.uid) and isInArray(skills["blink"], getPokemonName(getCreatureSummons(cid)[1])) then

	if not isWalkable(topos, cid, 0, 0) then
	
		if getMarkedPos(getCreatureSummons(cid)[1]).x == topos.x and getMarkedPos(getCreatureSummons(cid)[1]).y == topos.y then
		return true
		end

		markPos(getCreatureSummons(cid)[1], topos)
		markOwnerPos(getCreatureSummons(cid)[1], getThingPos(cid))
		doPlayerSay(cid, ""..getCreatureName(getCreatureSummons(cid)[1])..", "..txt["move"][math.random(1, #txt["move"])].."", 1)
		addEvent(goThere, 500, getCreatureSummons(cid)[1], topos, "move", isCreature(getCreatureTarget(cid)))

	return true
	end

	if ballcooldown.check(cid, "blink") then

		if getMarkedPos(getCreatureSummons(cid)[1]).x == topos.x and getMarkedPos(getCreatureSummons(cid)[1]).y == topos.y then
		return true
		end

		doPlayerSendCancel(cid, "Blink cooldown: ("..ballcooldown.get(cid, "blink")..")")
		markPos(getCreatureSummons(cid)[1], topos)
		markOwnerPos(getCreatureSummons(cid)[1], getThingPos(cid))
		doPlayerSay(cid, ""..getCreatureName(getCreatureSummons(cid)[1])..", "..txt["move"][math.random(1, #txt["move"])].."", 1)
		addEvent(goThere, 500, getCreatureSummons(cid)[1], topos, "move", isCreature(getCreatureTarget(cid)))

	return true
	end

	ballcooldown.set(cid, "blink", 60)
	markPos(getCreatureSummons(cid)[1], topos)
	markOwnerPos(getCreatureSummons(cid)[1], getThingPos(cid))
	doPlayerSay(cid, ""..getCreatureName(getCreatureSummons(cid)[1])..", "..txt["blink"][math.random(1, #txt["blink"])].."", 1)
	doSendDistanceShoot(getThingPos(getCreatureSummons(cid)[1]), topos, 39)
	doSendMagicEffect(getThingPos(getCreatureSummons(cid)[1]), 211)
	doTeleportThing(getCreatureSummons(cid)[1], topos, false)
	doSendMagicEffect(topos, 134)
	doCreatureSay(getCreatureSummons(cid)[1], "BLINK!", TALKTYPE_MONSTER)
	goThere(getCreatureSummons(cid)[1], topos, "move", isCreature(getCreatureTarget(cid)))

return true
end
-----------------------------


----START FLY/ RIDE ---------
if item2.uid == cid and (isInArray(skills["fly"], getPokemonName(getCreatureSummons(cid)[1])) or isInArray(skills["ride"], getPokemonName(getCreatureSummons(cid)[1]))) then

	--if not isPremium(cid) then
	--doPlayerSendCancel(cid, "Only premium members are allowed to fly or ride.")
	--return true
	--end

	if getMarkedPos(getCreatureSummons(cid)[1]).x == topos.x and getMarkedPos(getCreatureSummons(cid)[1]).y == topos.y then
	return true
	end

	markPos(getCreatureSummons(cid)[1], getThingPos(cid))
	markOwnerPos(getCreatureSummons(cid)[1], getThingPos(cid))
	if isInArray(skills["fly"], getPokemonName(getCreatureSummons(cid)[1])) then
	doPlayerSay(cid, ""..getCreatureName(getCreatureSummons(cid)[1])..", "..txt["fly"][math.random(1, #txt["fly"])].."", 1)
	addEvent(goThere, 500, getCreatureSummons(cid)[1], topos, "fly", isCreature(getCreatureTarget(cid)))
	setPlayerStorageValue(cid, 17000, 1)
	else
	doPlayerSay(cid, ""..getCreatureName(getCreatureSummons(cid)[1])..", "..txt["ride"][math.random(1, #txt["ride"])].."", 1)
	addEvent(goThere, 500, getCreatureSummons(cid)[1], topos, "ride", isCreature(getCreatureTarget(cid)))
	end

return true
end






-------- MOVE / END ---------
	if getMarkedPos(getCreatureSummons(cid)[1]).x == topos.x and getMarkedPos(getCreatureSummons(cid)[1]).y == topos.y then
	return true
	end

	markPos(getCreatureSummons(cid)[1], topos)
	markOwnerPos(getCreatureSummons(cid)[1], getThingPos(cid))
	doPlayerSay(cid, ""..getCreatureName(getCreatureSummons(cid)[1])..", "..txt["move"][math.random(1, #txt["move"])].."", 1)
	addEvent(goThere, 500, getCreatureSummons(cid)[1], topos, "move", isCreature(getCreatureTarget(cid)))

return true
end
-----------------------------