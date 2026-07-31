

function onStepOut(cid, item, position, lastPosition, fromPosition, toPosition, actor)
	doSendMagicEffect(toPosition, 14)
	doSendMagicEffect(fromPosition, 15)
	doPlayerSendCancel(cid, item.itemid)
	return true
end
