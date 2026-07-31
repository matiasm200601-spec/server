function onStepIn(cid, item, position, lastPosition, fromPosition)
	if getTileInfo(fromPosition).itemid == 1000 then
	doTeleportThing(cid, fromPosition, false)
	end
return false
end

------------------------------------------------------------------------------
--attempt to call global 'doSetItemActionId' (a nil value)

--function onStepIn(cid, item, position, lastPosition, fromPosition)
--	local pos = fromPosition
--	pos.stackpos = 0
--	doSetItemActionId(getThingFromPos(pos).uid, 1000)
--return true
--end
------------------------------------------------------------------------------
	