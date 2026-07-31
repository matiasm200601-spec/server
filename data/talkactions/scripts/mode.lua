local config = {
	nopvp = {"1", "nopvp", "nonpvp", "no-pvp", "non-pvp", "safe"},
	pvp = {"2", "pvp", "normal"},
	pvpenforced = {"3", "pvpe", "pvpenforced", "pvp-enforced", "war"}
}

function onSay(cid, words, param, channel)
	if(param == '') then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Command param required.")
		return true
	end

	local world = getWorldType()
	param = param:lower()
	if(table.isStrIn(param, config.nopvp)) then
		setWorldType(WORLD_TYPE_NO_PVP)
		world = "No-PVP"
	elseif(table.isStrIn(param, config.pvp)) then
		setWorldType(WORLD_TYPE_PVP)
		world = "PVP"
	elseif(table.isStrIn(param, config.pvpenforced)) then
		setWorldType(WORLD_TYPE_PVP_ENFORCED)
		world = "PVP-Enforced"
	else
		doPlayerSendCancel(cid, "Tipo de mundo no válido.")
		return true
	end

	doBroadcastMessage("El tipo de mundo se estableció en: " .. world .. ".", MESSAGE_EVENT_ADVANCE)
	return true
end
