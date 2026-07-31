function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Destruction Earth")

return true
end