function onSay(cid, words, param, channel)
	param = tonumber(param)
	if(not param or param < 0 or param > 2540) then
		doPlayerSendCancel(cid, "El parámetro numérico no puede ser menor que 0 ni mayor que " .. CONST_ME_LAST .. ".")
		return true
	end

	doSendMagicEffect(getCreaturePosition(cid), param)
	return true
end
