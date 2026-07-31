function onUse(cid, item, frompos, item2, topos)

	if not isCreature(item2.uid) or not isSummon(item2.uid) then
		doPlayerSendCancel(cid, "Solo puedes dar este caramelo a Pokémon de entrenadores.")
	return true
	end

	if getCreatureHealth(item2.uid) == 0 then return true end

	local pb = getPlayerSlotItem(getCreatureMaster(item2.uid), 8)

	if getLevel(item2.uid) >= 100 then
		doPlayerSendCancel(cid, "Tu Pokémon ya está en el nivel máximo.")
	return true
	end

	if getLevel(item2.uid) == getItemAttribute(pb.uid, "rarecandy") then
		doPlayerSendCancel(cid, "Un Pokémon no puede subir dos niveles seguidos con un caramelo raro.")
	return true
	end

	doPlayerSendTextMessage(cid, 27, "Diste un caramelo raro a "..getPokeName(item2.uid)..".")

	doCreatureSay(cid, getPokeName(item2.uid)..", ¡toma este caramelo!", TALKTYPE_SAY)
	doRemoveItem(item.uid, 1)


	local level = getItemAttribute(pb.uid, "level")
	local exp = getItemAttribute(pb.uid, "exp")
	local neededexp = getItemAttribute(pb.uid, "nextlevelexp")

	if getHappiness(item2.uid) < 50 then
		doSendMagicEffect(getThingPos(item2.uid), 168)
	return true
	end

	doCreatureSay(item2.uid, "Yum.", TALKTYPE_ORANGE_1)
	doItemSetAttribute(pb.uid, "rarecandy", level + 1)
	doItemSetAttribute(pb.uid, "exp", exp + neededexp)
	doPlayerSendTextMessage(getCreatureMaster(item2.uid), 27, "Tu "..getPokeName(item2.uid).." comió un caramelo raro!")
	doSendFlareEffect(getThingPos(item2.uid))
	doSendAnimatedText(getThingPos(item2.uid), "Level up!", 215)
	adjustPokemonLevel(pb.uid, getCreatureMaster(item2.uid), pb.itemid, true)

return true
end
	