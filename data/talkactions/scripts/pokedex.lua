




function onSay(cid, words, param, channel)

	if param == "" then
		doPlayerSendCancel(cid, "Escribe /dex <nombre del Pokémon> para ver su registro en la Pokédex.")
	return true
	end

	if string.lower(param) == "nidoran" then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Type either \"Nidoran Male\" or \"Nidoran Female\".")
	return true
	end

	for a = 1, 151 do
		if string.lower(param) == string.lower(oldpokedex[a][1]) then
			if getPlayerInfoAboutPokemon(cid, oldpokedex[a][1]).dex then
				doShowPokedexRegistration(cid, oldpokedex[a][1])
			else
				doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Este Pokémon aún no ha sido descubierto.")
				
			end
		return true
		end
	end

	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Nombre de Pokémon incorrecto.")

return true
end