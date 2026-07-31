local a = {
[11638] = {balltype = "normal", ballid = 11826,
        pokemons = {"Slowpoke", "Magnemite", "Doduo", "Seel", "Grimer", "Gastly", "Drowzee", "Voltorb", "Cubone", "Koffing",
        "Goldeen", "Vulpix", "Tentacool", "Bulbasaur", "Charmander", "Squirtle", "Butterfree", "Beedrill", "Metapod", "Kakuna", 
        "Raticate", "Spearow", "Ekans", "Abra", "Mankey", "Psyduck", "Pikachu", "Sandshrew", "Nidoran Female", 
        "Nidoran Male", "Zubat", "Diglett", "Venonat", "Meowth", "Poliwag", "Growlithe", "Machop", "Ponyta", "Geodude"}},
[11639] = {balltype = "great", ballid = 11832,      --alterado v1.3
        pokemons = {"Pidgeotto", "Weepinbell", "Clefairy", "Omanyte", "Kabuto", "Arbok", "Raichu", "Nidorino", "Nidorina", 
        "Dodrio", "Muk", "Golbat", "Gloom", "Parasect", "Venomoth", "Dugtrio", "Persian", "Poliwhirl", "Victreebel", "Machoke", 
        "Graveler", "Slowbro", "Magneton", "Farfetch'd", "Haunter", "Kingler", "Electrode", "Weezing", "Rhyhorn", "Seadra", 
        "Jigglypuff", "Seaking", "Tauros", "Starmie", "Eevee", "Dratini", "Charmeleon", "Wartortle", "Ivysaur"}},
[11640] = {balltype = "super", ballid = 11835,
        pokemons = {"Pidgeot", "Fearow", "Sandslash", "Ninetales", "Vileplume", "Primeape", "Golduck", "Kadabra", "Rapidash", 
        "Clefable", "Wigglytuff", "Dewgong", "Onix", "Cloyster", "Hypno", "Exeggutor", "Marowak", "Hitmonchan", "Hitmonlee", 
        "Lickitung", "Chansey", "Tangela", "Mr. Mime", "Pinsir", "Vaporeon", "Jolteon", "Flareon", "Porygon", "Dragonair"}},
[11641] = {balltype = "ultra", ballid = 11829,
        pokemons = {"Shiny Hitmonchan", "Shiny Hitmonlee", "Shiny Abra", "Dragonite", "Snorlax", "Kabutops", "Omastar", 
        "Ditto", "Lapras", "Gyarados", "Magmar", "Electabuzz", "Jynx", "Scyther", "Kangaskhan", "Golem", "Venusaur", 
        "Machamp", "Poliwrath", "Arcanine", "Nidoking", "Nidoqueen", "Charizard", "Blastoise", "Tentacruel", "Alakazam", 
        "Gengar", "Rhydon"}}
}
      

function onUse(cid, item, frompos, item2, topos)
         local b = a[item.itemid]                                    
               if not b then return true end
         local pokemon = b.pokemons[math.random(#b.pokemons)]
         local btype = b.balltype
               if not pokeballs[btype] then return true end
         local gender = getRandomGenderByName(pokemon)
         local happy = 220
         
         local ball = 0
         local sendToDepot = false                                                        --alterado v1.6
	     if getCreatureMana(cid) >= 6 or not hasSpaceInContainer(getPlayerSlotItem(cid, 3).uid) then
               sendToDepot = true
               ball = doCreateItemEx(b.ballid)   --alterado v1.3
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

		   doItemSetAttribute(ball, "boost", 50)    
  
         doPlayerSendTextMessage(cid, 27, "You opened a pokemon prize box +"..item.itemid - (11637).."!")
	     doPlayerSendTextMessage(cid, 27, "The prize pokemon was a "..pokemon..", congratulations!")
	     
	     if sendToDepot then
            doPlayerSendMailByName(getCreatureName(cid), ball, 1)    --alterado v1.3
            doPlayerSendTextMessage(cid, 27, "You are already holding six pokemons, so your new pokemon was sent to your depot.")
            doRemoveItem(item.uid)
         else
             doTransformItem(ball, pokeballs[btype].on)
	     end
	     
	     doSendMagicEffect(getThingPos(cid), 29)
return true
end