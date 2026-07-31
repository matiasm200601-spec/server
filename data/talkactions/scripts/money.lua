function onSay(cid, words, param, channel)
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Tienes " .. getPlayerMoney(cid) .. " de oro.")
	return true
end
