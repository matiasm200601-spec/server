local a = {
[13193] = {balltype = "ultra", ballid = 11829,
        pokemons = {"Regirock", "Registeel", "Regice"}}
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
  
         doPlayerSendTextMessage(cid, 27, "Voce Abriu Pokemon Egg"..item.itemid - (11637).."!")
	     doPlayerSendTextMessage(cid, 27, "Ooh Nasceu o Pokemon "..pokemon..", Parabens!")
	     
	     if sendToDepot then
	           doPlayerSendMailByName(getCreatureName(cid), ball, 1)  --alterado v1.3
		       doPlayerSendTextMessage(cid, 27, "Voce Ja Tem 6 Pokemons, O Seu Novo Pokemon Foi Mandado Ao DEPOT.")
               doRemoveItem(item.uid)
         else
               doTransformItem(ball, pokeballs[btype].on)
	     end
	     
	     doSendMagicEffect(getThingPos(cid), 29)
return true
end