function onUse(cid, item, fromPosition, item2, toPosition)
 
local teleport = {x=1142, y=1042, z=8} -- Coordenadas para onde o player irá ser teleportado.
local item_id = 2092 -- ID do item que o player precisa para ser teleportado.
 
if getPlayerItemCount(cid,item_id) >= 1 then
doTeleportThing(cid, teleport)
doPlayerRemoveItem(cid, item_id, 1)
doSendMagicEffect(getPlayerPosition(cid), 10)
doPlayerSendTextMessage(cid, 22, "Bem-vindo a dungeon!")
else
doPlayerSendTextMessage(cid, 22, "Desculpe, para passar voce precisa ter uma Chave de Dungeon "..getItemNameById(item_id)..".")
end
end