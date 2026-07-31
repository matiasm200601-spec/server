function onSay(cid, words, param, channel)
	if getTileHouseInfo(getPlayerPosition(cid)) ~= FALSE then
		if getHouseOwner(getTileHouseInfo(getPlayerPosition(cid))) == getPlayerGUID(cid) then
			setHouseOwner(getTileHouseInfo(getPlayerPosition(cid)), 0)
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Has salido de tu casa correctamente.")
		else
			doPlayerSendCancel(cid, "No eres el dueño de esta casa.")
			doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
		end
	else
		doPlayerSendCancel(cid, "No estás dentro de una casa.")
		doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
	end

	return TRUE
end