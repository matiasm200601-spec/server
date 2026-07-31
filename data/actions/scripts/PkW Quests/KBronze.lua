function onUse(cid, item, frompos, item2, topos)

	if item.uid == 10502 then
 	queststatus = getPlayerStorageValue(cid,987570)
 	if queststatus == -1 then
 	doPlayerSendTextMessage(cid,22,"Você completou achou uma Chave de Cobre... Existem quatro no total!")
 	doPlayerAddItem(cid,2089,1)
 	doTeleportThing(cid,{x=1917, y=1305, z=7})
        setPlayerStorageValue(cid,987570,1)
 	else
 	doPlayerSendTextMessage(cid,22,"Voce ja fez essa quest.")
 	end
	else
	return 0
	end

	return 1
	end 