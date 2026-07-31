function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Leafquake")

return true
end