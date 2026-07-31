function onSay(cid, words, param)

	if param ~= "" then
	return false
	end

	if string.len(words) ~= 5 then
	return false
	end

	local cd = exhaustion.get(cid, 88727)

	if not cd then
		cd = 0
	end

	if cd > 0 then
		doPlayerSendCancel(cid, "Debes esperar "..cd.." seconds.")
	return true
	end

	if #getCreatureSummons(cid) <= 0 then
		doPlayerSendCancel(cid, "Necesitas un Pokémon para usar este comando.")
	return true
	end

	doSendMagicEffect(getThingPos(cid), 180)

	local function doLovePokemon(cid)
		if not isCreature(cid) then return true end
		if #getCreatureSummons(cid) <= 0 then return true end
		if exhaustion.get(cid, 88727) and exhaustion.get(cid, 88727) > 3 then return true end
	local a = getCreatureSummons(cid)[1]
	local b = getPlayerStorageValue(a, 1008)
	if b > 250 then
       doPlayerSendCancel(cid, "Tu pokemon is already so happy.")
       return true
    end
	doSendMagicEffect(getThingPos(a), 180)
	setPlayerStorageValue(a, 1008, b + 45)
	exhaustion.set(cid, 88727, 30)
	end

	exhaustion.set(cid, 88727, 3)
	addEvent(doLovePokemon, 1150, cid)

return true
end