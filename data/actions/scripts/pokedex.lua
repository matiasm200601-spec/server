local rate = 20

function onUse(cid, item, fromPos, item2, toPos)
 
if not isCreature(item2.uid) then
return true
end

local poke = getCreatureName(item2.uid)

	if isMonster(item2.uid) then
       local this = newpokedex[getCreatureName(item2.uid)]
	   local myball = 0
	   if isSummon(item2.uid) then
	      myball = getPlayerSlotItem(getCreatureMaster(item2.uid), 8)
       end
       if not getPlayerInfoAboutPokemon(cid, poke).dex then
	      local exp = this.level * rate
          doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Desbloqueaste a "..getCreatureName(item2.uid).." en tu Pokédex!")
	      doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Ganaste "..exp.." puntos de experiencia.")
          doSendMagicEffect(getThingPos(cid), 210)
          doPlayerAddExperience(cid, exp)
          doAddPokemonInDexList(cid, poke)
       else
          doShowPokedexRegistration(cid, item2, myball)
       end
	return true
	end

if not isPlayer(item2.uid) then return true end

	local kanto = 0
	local johto = 0
                                    --alterado v1.7 \/\/
	for i = 1, #oldpokedex do
		if getPlayerInfoAboutPokemon(item2.uid, oldpokedex[i][1]).dex then
		   if i <= 151 then
              kanto = kanto+1
           elseif i >= 209 then
              johto = johto+1
           end
		end
	end                                                      --alterado v1.6

	local player = getRecorderPlayer(toPos, cid)

	if cid == player then
	    doPlayerSendTextMessage(cid, 27, "Has desbloqueado "..kanto.." de Kanto y "..johto.." johto's pokémons until now.") 
        doPlayerSetVocation(cid, 9) --alterado v1.6
        openChannelDialog(cid)
	end

return true
end