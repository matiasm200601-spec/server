local a = {
[12331] = {balltype = "ultra", ballid = 11829,
        pokemons = {"Shiny Venusaur", "Shiny Charizard", "Shiny Blastoise", "Shiny Pidgeot", "Shiny Ninetales",
        "Shiny Arcanine",  "Shiny Alakazam", "Shiny Tentacruel", "Shiny Gengar", "Shiny Rhydon", "Shiny Scyther",
        "Shiny Jynx", "Shiny Electabuzz", "Shiny Dragonair",
        "Shiny Butterfree", "Shiny Beedrill", "Shiny Rattata", "Shiny Raticate", "Shiny Raichu", "Shiny Zubat", "Shiny Golbat", "Shiny Oddish", "Shiny Paras", "Shiny Parasect", "Shiny Venonat", "Shiny Venomoth", "Shiny Growlithe", 
"Shiny Tentacool", "Shiny Farfetch'd", "Shiny Grimer", "Shiny Muk", "Shiny Krabby", "Shiny Kingler", "Shiny Voltorb", "Shiny Electrode", "Shiny Cubone", "Shiny Marowak", "Shiny Tangela", "Shiny Horsea", "Shiny Seadra", "Shiny Magikarp"}}
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