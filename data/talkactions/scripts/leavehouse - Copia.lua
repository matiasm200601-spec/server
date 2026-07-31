function onSay(cid, words, param, channel)
	local house = getHouseFromPos(getCreaturePosition(cid))
	if(not house) then
		doPlayerSendCancel(cid, "No estás dentro de una casa.")
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_POFF)
		return false
	end

	local owner = getHouseInfo(house).owner
	if(owner ~= getPlayerGUID(cid) and (owner ~= getPlayerGuildId(cid) or getPlayerGuildLevel(cid) ~= GUILDLEVEL_LEADER)) then
		doPlayerSendCancel(cid, "No eres el dueño de esta casa.")
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_POFF)
		return false
	end

	setHouseOwner(house, 0)
	doSendMagicEffect(getCreaturePosition(cid), CONST_ME_MAGIC_BLUE)
	return false
end
