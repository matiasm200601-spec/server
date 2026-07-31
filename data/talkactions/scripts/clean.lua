local cleanEvent = 0

function onSay(cid, words, param, channel)
	if(param == '') then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Collected " .. doCleanMap() .. " items.")
		return true
	end

	if(param == 'tile') then
		local removeLoaded, t = false, string.explode(param, ",")
		if(t[2]) then
			removeLoaded = getBooleanFromString(t[2])
		end

		doCleanTile(getCreaturePosition(cid), removeLoaded)
		return true
	end

	if(not tonumber(param)) then
		doPlayerSendCancel(cid, "Command requires numeric param.")
		return true
	end

	stopEvent(cleanEvent)
	prepareClean(tonumber(param), cid)
	return true
end

function prepareClean(minutes, cid)
	if(minutes == 0) then
		if(isPlayer(cid)) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Cleaned " .. doCleanMap() .. " items.")
		end

		doBroadcastMessage("Mapa del juego limpiado.")
	elseif(minutes > 0) then
		if(minutes == 1) then
			doBroadcastMessage("La limpieza del mapa será en " .. minutes .. " minuto; recoge todos tus objetos.")
		else
			doBroadcastMessage("La limpieza del mapa será en " .. minutes .. " minutos.")
		end

		cleanEvent = addEvent(prepareClean, 60000, minutes - 1, cid)
	end
end
