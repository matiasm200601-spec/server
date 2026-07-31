function onUse(cid, item, frompos, item2, topos)

	if item.uid == 10001 then
 	queststatus = getPlayerStorageValue(cid,987570)
 	if queststatus == -1 then
 	doPlayerSendTextMessage(cid,22,"Você completou a box 5 Quest..")
 	doPlayerAddItem(cid,2160,200)
        doPlayerAddItem(cid,13192,1)
 	doTeleportThing(cid,{x=1054, y=1050, z=7})
        setPlayerStorageValue(cid,987570,1)
 	else
 	doPlayerSendTextMessage(cid,22,"Voce Ja Concluiu A Quest.")
 	end
	else
	return 0
	end

	return 1
	end 