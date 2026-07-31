local special = {"Poliwhirl", "Gloom", "Slowpoke", "Tyrogue"}

local heart = 2289
local leaf = 2276
local grass = 2276
local water = 2277
local venom = 2278
local thunder = 2279
local rock = 2280
local punch = 2281
local fire = 2283
local coccon = 2284
local crystal = 2285
local dark = 2286
local earth = 2287
local enigma = 2288
local ice = 2290
local king = 2192
local metal = 2193
local sun = 2194

local poevo = {
["Bulbasaur"] = {evolution = "Ivysaur", count = 1, stoneid = 2276, stoneid2 = 0},
["Ivysaur"] = {evolution = "Venusaur", count = 2, stoneid = 2276, stoneid2 = 0},
["Charmander"] = {evolution = "Charmeleon", count = 1, stoneid = 2283, stoneid2 = 0},
["Charmeleon"] = {evolution = "Charizard", count = 2, stoneid = 2283, stoneid2 = 0},
["Squirtle"] = {evolution = "Wartortle", count = 1, stoneid = 2277, stoneid2 = 0},
["Wartortle"] = {evolution = "Blastoise", count = 2, stoneid = 2277, stoneid2 = 0},
["Caterpie"] = {evolution = "Metapod", count = 1, stoneid = 2284, stoneid2 = 0},
["Metapod"] = {evolution = "Butterfree", count = 2, stoneid = 2284, stoneid2 = 0},
["Weedle"] = {evolution = "Kakuna", count = 1, stoneid = 2284, stoneid2 = 0},
["Kakuna"] = {evolution = "Beedrill", count = 2, stoneid = 2284, stoneid2 = 0},
["Pidgey"] = {evolution = "Pidgeotto", count = 1, stoneid = 2289, stoneid2 = 0},
["Pidgeotto"] = {evolution = "Pidgeot", count = 2, stoneid = 2289, stoneid2 = 0},
["Rattata"] = {evolution = "Raticate", count = 1, stoneid = 2289, stoneid2 = 0},
["Spearow"] = {evolution = "Fearow", count = 1, stoneid = heart, stoneid2 = 0},
["Ekans"] = {evolution = "Arbok", count = 1, stoneid = venom, stoneid2 = 0},
["Pikachu"] = {evolution = "Raichu", count = 1, stoneid = thunder, stoneid2 = 0},
["Sandshrew"] = {evolution = "Sandslash", count = 2, stoneid = 2287, stoneid2 = 0},
["Nidoran Female"] = {evolution = "Nidorina", count = 1, stoneid = venom, stoneid2 = 0},
["Nidorina"] = {evolution = "Nidoqueen", count = 1, stoneid = venom, stoneid2 = earth},
["Nidoran Male"] = {evolution = "Nidorino", count = 1, stoneid = venom, stoneid2 = 0},
["Nidorino"] = {evolution = "Nidoking", count = 1, stoneid = venom, stoneid2 = earth},
["Clefairy"] = {evolution = "Clefable", count = 1, stoneid = heart, stoneid2 = 0},
["Vulpix"] = {evolution = "Ninetales", count = 2, stoneid = fire, stoneid2 = 0},
["Jigglypuff"] = {evolution = "Wigglytuff", count = 1, stoneid = heart, stoneid2 = 0},
["Zubat"] = {evolution = "Golbat", count = 1, stoneid = 2278, stoneid2 = 0},
["Oddish"] = {evolution = "Gloom", count = 1, stoneid = 2276, stoneid2 = 0},
["Paras"] = {evolution = "Parasect", count = 1, stoneid = coccon, stoneid2 = 0},
["Venonat"] = {evolution = "Venomoth", count = 1, stoneid = coccon, stoneid2 = venom},
["Diglett"] = {evolution = "Dugtrio", count = 1, stoneid = earth, stoneid2 = 0},
["Meowth"] = {evolution = "Persian", count = 1, stoneid = heart, stoneid2 = 0},
["Psyduck"] = {evolution = "Golduck", count = 1, stoneid = water, stoneid2 = enigma},
["Mankey"] = {evolution = "Primeape", count = 1, stoneid = punch, stoneid2 = 0},
["Growlithe"] = {evolution = "Arcanine", count = 2, stoneid = fire, stoneid2 = 0},
["Poliwag"] = {evolution = "Poliwhirl", count = 1, stoneid = 2277, stoneid2 = 0},

["Abra"] = {evolution = "Kadabra", count = 1, stoneid = 2288, stoneid2 = 0},
["Kadabra"] = {evolution = "Alakazam", count = 2, stoneid = 2288, stoneid2 = 0},
["Machop"] = {evolution = "Machoke", count = 1, stoneid = punch, stoneid2 = 0},
["Machoke"] = {evolution = "Machamp", count = 2, stoneid = punch, stoneid2 = 0},
["Bellsprout"] = {evolution = "Weepinbell", count = 1, stoneid = 2276, stoneid2 = 0},
["Weepinbell"] = {evolution = "Victreebel", count = 2, stoneid = 2276, stoneid2 = 0},
["Tentacool"] = {evolution = "Tentacruel", count = 1, stoneid = water, stoneid2 = venom},
["Geodude"] = {evolution = "Graveler", count = 1, stoneid = 2280, stoneid2 = 0},
["Graveler"] = {evolution = "Golem", count = 2, stoneid = 2280, stoneid2 = 0},
["Ponyta"] = {evolution = "Rapidash", count = 1, stoneid = fire, stoneid2 = 0},
["Magnemite"] = {evolution = "Magneton", count = 1, stoneid = 2279, stoneid2 = 0},
["Doduo"] = {evolution = "Dodrio", count = 1, stoneid = 2289, stoneid2 = 0},
["Seel"] = {evolution = "Dewgong", count = 1, stoneid = water, stoneid2 = ice},
["Grimer"] = {evolution = "Muk", count = 1, stoneid = 2278, stoneid2 = 0},
["Shellder"] = {evolution = "Cloyster", count = 2, stoneid = ice, stoneid2 = 0},
["Gastly"] = {evolution = "Haunter", count = 1, stoneid = dark, stoneid2 = 0},
["Haunter"] = {evolution = "Gengar", count = 2, stoneid = dark, stoneid2 = 0},
["Drowzee"] = {evolution = "Hypno", count = 2, stoneid = enigma, stoneid2 = 0},
["Krabby"] = {evolution = "Kingler", count = 1, stoneid = water, stoneid2 = 0},
["Voltorb"] = {evolution = "Electrode", count = 1, stoneid = 2279, stoneid2 = 0},
["Exeggcute"] = {evolution = "Exeggutor", count = 1, stoneid = leaf, stoneid2 = enigma},
["Cubone"] = {evolution = "Marowak", count = 2, stoneid = earth, stoneid2 = 0},
["Koffing"] = {evolution = "Weezing", count = 1, stoneid = venom, stoneid2 = 0},
["Rhyhorn"] = {evolution = "Rhydon", count = 1, stoneid = rock, stoneid2 = ground},
["Horsea"] = {evolution = "Seadra", count = 1, stoneid = 2277, stoneid2 = 0},
["Goldeen"] = {evolution = "Seaking", count = 1, stoneid = water, stoneid2 = 0},
["Staryu"] = {evolution = "Starmie", count = 1, stoneid = water, stoneid2 = 0},
["Magikarp"] = {evolution = "Gyarados", count = 1, stoneid = water, stoneid2 = crystal},
["Omanyte"] = {evolution = "Omastar", count = 1, stoneid = water, stoneid2 = crystal},
["Kabuto"] = {evolution = "Kabutops", count = 1, stoneid = rock, stoneid2 = crystal},
["Dratini"] = {evolution = "Dragonair", count = 1, stoneid = crystal, stoneid2 = 0},
["Dragonair"] = {evolution = "Dragonite", count = 2, stoneid = crystal, stoneid2 = 0},
["Chikorita"] = {evolution = "Bayleef", count = 1, stoneid = leaf, stoneid2 = 0},
["Bayleef"] = {evolution = "Meganium", count = 2, stoneid = leaf, stoneid2 = 0},
["Cyndaquil"] = {evolution = "Quilava", count = 1, stoneid = fire, stoneid2 = 0},
["Quilava"] = {evolution = "Typhlosion", count = 2, stoneid = fire, stoneid2 = 0},
["Totodile"] = {evolution = "Croconow", count = 1, stoneid = water, stoneid2 = 0},
["Croconow"] = {evolution = "Feraligatr", count = 2, stoneid = water, stoneid2 = 0},
["Sentret"] = {evolution = "Furret", count = 1, stoneid = heart, stoneid2 = 0},
["Hoothoot"] = {evolution = "Noctowl", count = 1, stoneid = heart, stoneid2 = 0},
["Ledyba"] = {evolution = "Ledian", count = 2, stoneid = coccon, stoneid2 = 0},
["Spinarak"] = {evolution = "Ariados", count = 1, stoneid = coccon, stoneid2 = venom},
["Golbat"] = {evolution = "Crobat", count = 2, stoneid = venom, stoneid2 = 0},
["Chinchou"] = {evolution = "Lanturn", count = 1, stoneid = water, stoneid2 = thunder},
["Pichu"] = {evolution = "Pikachu", count = -1, stoneid = thunder, stoneid2 = 0},
["Cleffa"] = {evolution = "Clefairy", count = -1, stoneid = heart, stoneid2 = 0},
["Iglybuff"] = {evolution = "Jigglypuff", count = -1, stoneid = heart, stoneid2 = 0},
["Togepi"] = {evolution = "Togetic", count = 1, stoneid = heart, stoneid2 = 0},
["Natu"] = {evolution = "Xatu", count = 1, stoneid = enigma, stoneid2 = 0},
["Mareep"] = {evolution = "Flaaffy", count = 1, stoneid = thunder, stoneid2 = 0},
["Flaaffy"] = {evolution = "Ampharos", count = 2, stoneid = thunder, stoneid2 = 0},
["Marill"] = {evolution = "Azumarill", count = 1, stoneid = water, stoneid2 = 0},
["Hoppip"] = {evolution = "Skiploom", count = 1, stoneid = leaf, stoneid2 = 0},
["Skiploom"] = {evolution = "Jumpluff", count = 1, stoneid = leaf, stoneid2 = 0},
["Sunkern"] = {evolution = "Sunflora", count = 1, stoneid = 2276, stoneid2 = 2194},
["Wooper"] = {evolution = "Quagsire", count = 1, stoneid = water, stoneid2 = earth},
["Pineco"] = {evolution = "Forretress", count = 2, stoneid = coccon, stoneid2 = 0},
["Snubbull"] = {evolution = "Granbull", count = 1, stoneid = heart, stoneid2 = 0},
["Teddiursa"] = {evolution = "Ursaring", count = 2, stoneid = heart, stoneid2 = 0},
["Slugma"] = {evolution = "Magcargo", count = 1, stoneid = rock, stoneid2 = fire},
["Swinub"] = {evolution = "Piloswine", count = 1, stoneid = earth, stoneid2 = ice},
["Remoraid"] = {evolution = "Octillery", count = 1, stoneid = water, stoneid2 = 0},
["Houndour"] = {evolution = "Houndoom", count = 1, stoneid = dark, stoneid2 = fire},
["Phanpy"] = {evolution = "Donphan", count = 2, stoneid = earth, stoneid2 = 0},
["Smoochum"] = {evolution = "Jynx", count = 1, stoneid = ice, stoneid2 = enigma},
["Elekid"] = {evolution = "Electabuzz", count = 2, stoneid = thunder, stoneid2 = 0},
["Magby"] = {evolution = "Magmar", count = 2, stoneid = fire, stoneid2 = 0},
["Larvitar"] = {evolution = "Pupitar", count = 1, stoneid = ground, stoneid2 = 0},
["Pupitar"] = {evolution = "Tyranitar", count = 1, stoneid = dark, stoneid2 = rock},
["Porygon"] = {evolution = "Porygon2", count = 1, stoneid = heart, stoneid2 = heart},
["Seadra"] = {evolution = "Kingdra", count = 1, stoneid = water, stoneid2 = crystal},
["Chansey"] = {evolution = "Blissey", count = 2, stoneid = heart, stoneid2 = 2193},
["Scyther"] = {evolution = "Scizor", count = 1, stoneid = 2284, stoneid2 = 2193},
["Onix"] = {evolution = "Steelix", count = 1, stoneid = 2287, stoneid2 = 2193},
["Seadra"] = {evolution = "Kingdra", count = 1, stoneid = crystal, stoneid2 = water},
}

local types = {
["Leaf"] = {itemid = 2276, "Bulbasaur", "Ivysaur", "Oddish", "Gloom", "Bellsprout", "Weepinbell", "Exeggcute", "Chikorita", "Bayleef", "Hoppip", "Skiploom", "Sunkern"},
["Water"] = {itemid = 2277, "Squirtle", "Wartortle", "Horsea", "Goldeen", "Magikarp", "Psyduck", "Poliwag", "Poliwhirl", "Tentacool", "Krabby", "Staryu", "Omanyte", "Eevee", "Totodile", "Croconow", "Chinchou", "Marill", "Wooper", "Slowpoke", "Remoraid", "Seadra"},
["Venom"] = {itemid = 2278, "Zubat", "Ekans", "Nidoran male", "Nidoran female", "Nidorino", "Nidorina", "Gloom", "Venonat", "Tentacool", "Grimer", "Koffing", "Spinarak", "Golbat"},
["Thunder"] = {itemid = 2279, "Magnemite", "Pikachu", "Voltorb", "Eevee", "Chinchou", "Pichu", "Mareep", "Flaaffy", "Elekid"},
["Rock"] = {itemid = 2280, "Geodude", "Graveler", "Rhyhorn", "Kabuto", "Slugma", "Pupitar"},
["Punch"] = {itemid = 2281, "Machop", "Machoke", "Mankey", "Poliwhirl", "Tyrogue"},
["Fire"] = {itemid = 2283, "Charmander", "Charmeleon", "Vulpix", "Growlithe", "Ponyta", "Eevee", "Cyndaquil", "Quilava", "Slugma", "Houndour", "Magby"},
["Coccon"] = {itemid = 2284, "Caterpie", "Metapod", "Weedle", "Kakuna", "Paras", "Venonat", "Scyther", "Ledyba", "Spinarak", "Pineco"},
["Crystal"] = {itemid = 2285, "Dratini", "Dragonair", "Magikarp", "Omanyte", "Kabuto", "Seadra"},
["Darkness"] = {itemid = 2286, "Gastly", "Haunter", "Eevee", "Houndour", "Pupitar"},
["Earth"] = {itemid = 2287, "Cubone", "Sandshrew", "Nidorino", "Nidorina", "Diglett", "Onix", "Rhyhorn", "Wooper", "Swinub", "Phanpy", "Larvitar"},
["Enigma"] = {itemid = 2288, "Abra", "Kadabra", "Psyduck", "Slowpoke", "Drowzee", "Eevee", "Natu", "Smoochum"},
["Heart"] = {itemid = 2289, "Rattata", "Pidgey", "Pidgeotto", "Spearow", "Clefairy", "Jigglypuff", "Meowth", "Doduo", "Porygon", "Chansey", "Sentret", "Hoothoot", "Cleffa", "Igglybuff", "Togepi", "Snubull", "Teddiursa"},
["Ice"] = {itemid = 2290, "Seel", "Shellder", "Smoochum", "Swinub"},
["King"] = {itemid = 2192, "Slowpoke", "Poliwhirl"},
["Metal"] = {itemid = 2193, "Onix", "Scyther"},
["Sun"] = {itemid = 2194, "Sunkern", "Gloom"}
}

function onUse(cid, item, frompos, item2, topos)

local pokeball = getPlayerSlotItem(cid, 8)

if not isMonster(item2.uid) then
return true
end

if not isPlayer(getCreatureMaster(item2.uid)) or getCreatureMaster(item2.uid) ~= cid then
doPlayerSendCancel(cid, "You can only use stones on pokemons you own.")
return true
end

for i, x in pairs(types) do

if item.itemid == x.itemid then

if isPlayerSummon(cid, item2.uid) then

if table.find(x, getPokemonName(item2.uid)) then

if getPokemonName(item2.uid) == "Eevee" then

		if getPlayerLevel(cid) < 55 then
		return doPlayerSendCancel(cid, "Sorry, you don't have the required level to evolve this pokemon (55).")
		end

	local eevee = ""

	if item.itemid == 2279 then
	eevee = "Jolteon"
	elseif item.itemid == 2277 then
	eevee = "Vaporeon"
	elseif item.itemid == 2283 then
	eevee = "Flareon"
	elseif item.itemid == 2288 then
	eevee = "Espeon"
	elseif item.itemid == 2286 then
	eevee = "Umbreon"
	end

	doItemSetAttribute(pokeball.uid, "poke", eevee)

		if getItemAttribute(pokeball.uid, "nick") ~= "?" then
		doItemSetAttribute(pokeball.uid, "fakedesc", "Contains a "..eevee..".")
		local newdes = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "fakedesc").."\nIt's nickname is: "..getItemAttribute(getPlayerSlotItem(cid, 8).uid, "nname").."."
		doItemSetAttribute(pokeball.uid, "description", newdes)
		else
		doItemSetAttribute(pokeball.uid, "description", "Contains a "..eevee..".")
		end

		doPlayerSendTextMessage(cid, 27, "Congratulations! Your "..getCreatureName(item2.uid).." evolved into a "..eevee.."!")
		doSendMagicEffect(topos, 18)
		doTransformItem(getPlayerSlotItem(cid, 7).uid, fotos[eevee].fotopoke)
		doSendMagicEffect(getThingPos(cid), 173)
		local oldpos = getThingPos(item2.uid)
		local storage = getPlayerStorageValue(item2.uid, 333)
		doRemoveCreature(item2.uid)

		if getItemAttribute(pokeball.uid, "nick") ~= "?" then

			if getPlayerStorageValue(cid, 9912) == -1 then
			setPlayerStorageValue(cid, 9912, 0)
			end

			local newarch = ""..getCreatureName(cid)..""..getPlayerStorageValue(cid, 9912)..""
			doCopyPokemon(getItemAttribute(getPlayerSlotItem(cid, 8).uid, "poke"), newarch)
			doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "nick", newarch)
			doEditName("C:/Users/WAGNER DOS SANTOS/Desktop/ot/Pokemon Dash/data/monster/pokes/nicked/"..newarch..".xml", getItemAttribute(getPlayerSlotItem(cid, 8).uid, "nname"), getItemAttribute(getPlayerSlotItem(cid, 8).uid, "poke"))
			local newfile = ""..newarch..".xml"
			doAddMonsterInXML(newarch, newfile)
			doReloadInfo(RELOAD_MONSTERS)
			setPlayerStorageValue(cid, 9912, getPlayerStorageValue(cid, 9912)+1)
		end

		doSummonMonster(cid, eevee)
		local pk = getCreatureSummons(cid)[1]
		setPlayerStorageValue(pk, 333, storage)
		registerCreatureEvent(pk, "DiePoke")
		registerCreatureEvent(pk, "Exp")
		doTeleportThing(pk, oldpos, false)
		doCreatureSetLookDir(pk, 2)
		setCreatureMaxHealth(pk, getCreatureMaxHealth(pk) + (pokes[getPokemonName(pk)].cons * getPlayerLevel(cid)))
		doCreatureAddHealth(pk, getCreatureMaxHealth(pk))
		setPlayerStorageValue(cid, 2, 0)
		doPlayerRemoveItem(cid, item.itemid, 1)

if not string.find(getPlayerStorageValue(cid, 54842), ""..eevee..",") then
doPlayerAddSoul(cid, 1)
setPlayerStorageValue(cid, 54842, getPlayerStorageValue(cid, 54842)..""..eevee..", ")
end

return true
end


if isInArray(special, getPokemonName(item2.uid)) then

	if getPokemonName(item2.uid) == "Poliwhirl" then
	local evolution = 0
	local theevo = ""

	if item.itemid == water then

			if getPlayerLevel(cid) >= pokes["Politoed"].level and getPlayerItemCount(cid, king) >= 1 then
			evolution = king
			theevo = "Politoed"
			elseif getPlayerLevel(cid) >= pokes["Poliwrath"].level and getPlayerItemCount(cid, punch) >= 1 then
			evolution = punch
			theevo = "Poliwrath"
			end

			if getPlayerLevel(cid) <= pokes["Poliwrath"].level then
			doPlayerSendCancel(cid, "Sorry, you don't have the required level to evolve this pokemon (Poliwrath : "..pokes["Poliwrath"].level.." / Politoed : "..pokes["Politoed"].level..").")
			return true
			end

			if getPlayerItemCount(cid, punch) >= 1 and getPlayerItemCount(cid, king) >= 1 then
			doPlayerSendCancel(cid, "Please, use your Punch Stone to evolve this pokemon to a Poliwrath, or a King's Rock to a Politoed.")
			return true
			end

			if evolution == 0 then
			doPlayerSendCancel(cid, "You need at least one Water Stone, and a Punch Stone (Poliwrath) or a King's Rock (Politoed) to evolve this pokemon.")
			return true
			end

			if evolution ~= 0 then
			doEvolvePokemon(cid, item2, theevo, evolution, water)
			return true
			end

	elseif item.itemid == punch then

			if getPlayerLevel(cid) < pokes["Poliwrath"].level then
			doPlayerSendCancel(cid, "Sorry, you don't have the required level to evolve this pokemon ("..pokes["Poliwrath"].level..").")
			return true
			end

			if getPlayerItemCount(cid, water) <= 0 then
			doPlayerSendCancel(cid, "You need at least one Punch Stone and one Water Stone to evolve this pokemon.")
			return true
			end

			local theevo = "Poliwrath"
			doEvolvePokemon(cid, item2, theevo, water, punch)
	
	elseif item.itemid == king then
	
			if getPlayerLevel(cid) < pokes["Politoed"].level then
			doPlayerSendCancel(cid, "Sorry, you don't have the required level to evolve this pokemon ("..pokes["Politoed"].level..").")
			return true
			end

			if getPlayerItemCount(cid, water) <= 0 then
			doPlayerSendCancel(cid, "You need at least one Punch Stone and one King's Rock to evolve this pokemon.")
			return true
			end

			local theevo = "Politoed"
			doEvolvePokemon(cid, item2, theevo, water, king)
	end

	elseif getPokemonName(item2.uid) == "Gloom" then

		if getPlayerLevel(cid) < 50 then
		doPlayerSendCancel(cid, "Sorry, you don't have the required level to evolve this pokemon (50).")
		return true
		end

		if item.itemid == leaf then

		local theevo = ""
		local evolution = 0

			if getPlayerItemCount(cid, venom) >= 1 and getPlayerItemCount(cid, sun) >= 1 then
			doPlayerSendCancel(cid, "Please, use your Venom Stone to evolve this pokemon to a Vileplume, or a Sun Stone to a Bellossom.")
			return true
			end

			if getPlayerItemCount(cid, venom) <= 0 and getPlayerItemCount(cid, sun) <= 0 then
			doPlayerSendCancel(cid, "You need at least one Leaf Stone, and a Sun Stone (Bellossom) or a Venom Stone (Vileplume) to evolve this pokemon.")
			return true
			end

			if getPlayerItemCount(cid, venom) >= 1 then
			theevo = "Vileplume"
			evolution = venom
			elseif getPlayerItemCount(cid, sun) >= 1 then
			theevo = "Bellossom"
			evolution = sun
			end
			
			doEvolvePokemon(cid, item2, theevo, evolution, leaf)

		elseif item.itemid == venom then

			if getPlayerItemCount(cid, leaf) <= 0 then
			doPlayerSendCancel(cid, "You need at least one Leaf Stone and one Venom Stone to evolve this pokemon.")
			return true
			end

			doEvolvePokemon(cid, item2, "Vileplume", venom, leaf)

		elseif item.itemid == sun then

			if getPlayerItemCount(cid, leaf) <= 0 then
			doPlayerSendCancel(cid, "You need at least one Leaf Stone and one Sun Stone to evolve this pokemon.")
			return true
			end

			doEvolvePokemon(cid, item2, "Bellossom", sun, leaf)
		end

	elseif getPokemonName(item2.uid) == "Slowpoke" then

		if getPlayerLevel(cid) < 45 then
		doPlayerSendCancel(cid, "Sorry, you don't have the required level to evolve this pokemon (45).")
		return true
		end

		if item.itemid == enigma then

			doEvolvePokemon(cid, item2, "Slowbro", enigma, 0)

		elseif item.itemid == king then

			doEvolvePokemon(cid, item2, "Slowking", sun, 0)
		end
	end

return true
end


local count = poevo[getPokemonName(item2.uid)].count
local stnid = poevo[getPokemonName(item2.uid)].stoneid
local stnid2 = poevo[getPokemonName(item2.uid)].stoneid2
local evo = poevo[getPokemonName(item2.uid)].evolution
local levell = pokes[evo].level

if stnid2 > 1 and getPlayerItemCount(cid, stnid2) < count then
return doPlayerSendCancel(cid, "You need at least one "..getItemNameById(stnid).." and one "..getItemNameById(stnid2).." to evolve this pokemon!")
end
if stnid2 > 1 and getPlayerItemCount(cid, stnid) < count then
return doPlayerSendCancel(cid, "You need at least one "..getItemNameById(stnid).." and one "..getItemNameById(stnid2).." to evolve this pokemon!")
end
if getPlayerItemCount(cid, stnid) < count then
return doPlayerSendCancel(cid, "You need at least "..count.." "..getItemNameById(stnid).."s to evolve this pokemon!")
end
if getPlayerLevel(cid) < levell then
return doPlayerSendCancel(cid, "Sorry, you don't have the required level to evolve this pokemon ("..levell..").")
end
local owner = getCreatureMaster(item2.uid)
local pokeball = getPlayerSlotItem(cid, 8)
local description = "Contains a "..evo.."."

doItemSetAttribute(pokeball.uid, "poke", evo)

		if getItemAttribute(pokeball.uid, "nick") ~= "?" then
		doItemSetAttribute(pokeball.uid, "fakedesc", "Contains a "..evo..".")
		local newdes = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "fakedesc").."\nIt's nickname is: "..getItemAttribute(getPlayerSlotItem(cid, 8).uid, "nname").."."
		doItemSetAttribute(pokeball.uid, "description", newdes)
		else
		doItemSetAttribute(pokeball.uid, "description", "Contains a "..evo..".")
		end

		if getItemAttribute(pokeball.uid, "nick") ~= "?" then

			if getPlayerStorageValue(cid, 9912) == -1 then
			setPlayerStorageValue(cid, 9912, 0)
			end

			local newarch = ""..getCreatureName(cid)..""..getPlayerStorageValue(cid, 9912)..""
			doCopyPokemon(getItemAttribute(getPlayerSlotItem(cid, 8).uid, "poke"), newarch)
			doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "nick", newarch)
			doEditName("C:/Users/WAGNER DOS SANTOS/Desktop/ot/Pokemon Dash/data/monster/pokes/nicked/"..newarch..".xml", getItemAttribute(getPlayerSlotItem(cid, 8).uid, "nname"), getItemAttribute(getPlayerSlotItem(cid, 8).uid, "poke"))
			local newfile = ""..newarch..".xml"
			doAddMonsterInXML(newarch, newfile)
			doReloadInfo(RELOAD_MONSTERS)
			setPlayerStorageValue(cid, 9912, getPlayerStorageValue(cid, 9912)+1)
		end

doPlayerSendTextMessage(cid, 27, "Congratulations! Your "..getCreatureName(item2.uid).." evolved into a "..evo.."!")
doSendMagicEffect(topos, 18)
doTransformItem(getPlayerSlotItem(cid, 7).uid, fotos[evo].fotopoke)
doSendMagicEffect(getThingPos(cid), 173)
local oldpos = getThingPos(item2.uid)
doRemoveCreature(item2.uid)

doSummonMonster(cid, evo)
local pk = getCreatureSummons(cid)[1]
registerCreatureEvent(pk, "DiePoke")
registerCreatureEvent(pk, "Exp")
doTeleportThing(pk, oldpos, false)
doCreatureSetLookDir(pk, 2)
setCreatureMaxHealth(pk, getCreatureMaxHealth(pk) + (pokes[getPokemonName(pk)].cons * getPlayerLevel(cid)))
doCreatureAddHealth(pk, getCreatureMaxHealth(pk))
if count >= 1 then
doPlayerRemoveItem(cid, stnid, count)
doPlayerRemoveItem(cid, stnid2, count)
end
setPlayerStorageValue(cid, 2, 0)

local i = getPokemonName(getCreatureSummons(cid)[1])
doItemSetAttribute(pokeball.uid, "hp", 1)
if not string.find(getPlayerStorageValue(cid, 54842), ""..i..",") then
doPlayerAddSoul(cid, 1)
setPlayerStorageValue(cid, 54842, getPlayerStorageValue(cid, 54842)..""..i..", ")
end

break

else

return doPlayerSendCancel(cid, "Sorry, this is not the required stone to evolve this pokemon!")

end
end
end
end
return TRUE
end
