function onPrepareDeath(cid, corpse, deathlist)

	if true then
	doSendMagicEffect(getThingPos(cid), 22)
	doCreatureAddHealth(cid, getCreatureMaxHealth(cid))
	return true
	end

return false
end