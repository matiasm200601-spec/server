local a = {
[11638] = {balltype = "normal", ballid = 11826,
        pokemons = {"Caterpie", "Weedle", "Pidgey", "Rattata", "Metapod", "Kakuna", "Spearow",
        "Diglett", "Zubat", "Paras", "Oddish", "Poliwag", "Bellsprout", "Magnemite", "Shellder", "Krabby", "Horsea",
        "Goldeen", "Magikarp", "Exeggcute"}},
[11639] = {balltype = "great", ballid = 11832,        --alterado v1.3
        pokemons = {"Bulbasaur", "Charmander", "Squirtle", "Pidgeotto", "Raticate", "Pikachu",
        "Butterfree", "Beedrill", "Ekans", "Arbok", "Gloom", "Nidoran Female", "Nidorina", "Nidoran Male", "Nidorino",
        "Golbat", "Clefairy", "Jigglypuff", "Venonat", "Sandshrew", "Vulpix", "Meowth", "Persian", "Psyduck", "Mankey",
        "Growlithe", "Poliwhirl", "Abra", "Machop", "Weepinbell", "Tentacool", "Geodude", "Ponyta", "Slowpoke", "Doduo",
        "Seel", "Grimer", "Muk", "Gastly", "Drowzee", "Voltorb", "Cubone", "Koffing", "Weezing", "Rhyhorn", "Seaking",
        "Staryu", "Eevee", "Omanyte", "Kabuto"}},
[11640] = {balltype = "super", ballid = 11835,
        pokemons = {"Ivysaur", "Charmeleon", "Wartortle", "Raichu", "Fearow", "Vileplume", "Venomoth",
        "Parasect", "Clefable", "Wigglytuff", "Sandslash", "Dugtrio", "Golduck", "Primeape", "Kadabra", "Machoke",
        "Victreebel", "Graveler", "Rapidash", "Slowbro", "Magneton", "Farfetch'd", "Dodrio", "Cloyster", "Haunter", "Onix",
        "Hypno", "Kingler", "Electrode", "Exeggutor", "Marowak", "Hitmonlee", "Hitmonchan", "Lickitung", "Chansey",
        "Tangela", "Kangaskhan", "Seadra", "Starmie", "Mr. Mime", "Pinsir", "Tauros", "Vaporeon", "Jolteon",
        "Flareon", "Porygon"}},
[11641] = {balltype = "ultra", ballid = 11829,
        pokemons = {"Venusaur", "Charizard", "Blastoise", "Pidgeot", "Nidoqueen", "Nidoking", "Ninetales",
        "Arcanine", "Poliwrath", "Alakazam", "Machamp", "Tentacruel", "Golem", "Dewgong", "Gengar", "Rhydon", "Scyther",
        "Jynx", "Electabuzz", "Magmar", "Gyarados", "Lapras", "Omastar", "Kabutops", "Aerodactyl", "Snorlax", "Dragonair",
        "Dragonite"}}
}

local extrastrength = 1.1        

function onUse(cid, item, frompos, item2, topos)
         local b = a[item.itemid]                                    
               if not b then return true end
         local pokemon = b.pokemons[math.random(#b.pokemons)] --alterado v1.3
         local btype = b.balltype
               if not pokeballs[btype] then return true end
         local gender = getRandomGenderByName(pokemon)
         local happy = 220
         local leveltable = getPokemonExperienceTable(pokemon)
         
         local ball = 0
         local sendToDepot = false                                              --alterado v1.6          
	     if getCreatureMana(cid) >= 6 or not hasSpaceInContainer(getPlayerSlotItem(cid, 3).uid) then
               sendToDepot = true
               ball = doCreateItemEx(b.ballid)    --alterado v1.3
         else
               ball = item.uid
         end  
         
           doItemSetAttribute(ball, "poke", pokemon)
           doItemSetAttribute(ball, "hp", 1)
		   doItemSetAttribute(ball, "happy", happy)
		   doItemSetAttribute(ball, "gender", gender)
		   if pokemon == "Hitmonchan" or pokemon == "Shiny Hitmonchan" then
		      doItemSetAttribute(ball, "hands", 0)
           end
		   doItemSetAttribute(ball, "description", "Contains a "..pokemon..".")
		   doItemSetAttribute(ball, "fakedesc", "Contains a "..pokemon..".")    
  
         doPlayerSendTextMessage(cid, 27, "You opened a pokemon prize box +"..item.itemid - (11637).."!")
	     doPlayerSendTextMessage(cid, 27, "The prize pokemon was a "..pokemon..", congratulations!")
	     
	     if sendToDepot then
	           doPlayerSendMailByName(getCreatureName(cid), ball, 1)  --alterado v1.3
		       doPlayerSendTextMessage(cid, 27, "You are already holding six pokemons, so your new pokemon was sent to your depot.")
               doRemoveItem(item.uid)
         else
               doTransformItem(ball, pokeballs[btype].on)
	     end
	     
	     doSendMagicEffect(getThingPos(cid), 29)
return true
end