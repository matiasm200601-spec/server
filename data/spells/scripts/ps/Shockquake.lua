function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Shockquake")

return true
end