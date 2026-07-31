function onUse(cid, item, frompos, item2, topos)

	if item.uid == 10520 then
 	queststatus = getPlayerStorageValue(cid,987570)
 	if queststatus == -1 then
 	doPlayerSendTextMessage(cid,22,"¡Felicidades, completaste la misión!")
 	doPlayerAddItem(cid,11453,1)
 	doTeleportThing(cid,{x=1050, y=1054, z=7})
        setPlayerStorageValue(cid,987570,1)
 	else
 	doPlayerSendTextMessage(cid,22,"Voce ja fez essa quest.")
 	end
	else
	return 0
	end

	return 1
	end 