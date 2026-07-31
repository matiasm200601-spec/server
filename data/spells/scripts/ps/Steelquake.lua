function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Steelquake")

return true
end