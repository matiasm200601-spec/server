local config = {
storage = 19400, -- storage em que será salvo o tempo
cor = "green", -- de acordo com o constant.lua da lib
tempo = 30, -- em minutos
itemid = 2160,
price = 50, -- quantidade de dinheiro que irá custar
level = 100 -- level pra poder utilizar o broadcast
}


function onSay(cid, words, param, channel)
if(param == '') then
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Command param required.")
return true
end


if getPlayerLevel(cid) >= config.level then
if getPlayerStorageValue(cid, config.storage) - os.time() <= 0 then
if doPlayerRemoveItem(cid, config.itemid, config.price) then
setPlayerStorageValue(cid, config.storage, os.time() + (config.tempo*1)) 
doBroadcastMessage(""..getCreatureName(cid).." [ANUNCIO]: "..param.."", config.cor)
doPlayerSendTextMessage(cid, MESSAGE_EVENT_DEFAULT, "Vc Falo Com Sucesso " ..config.tempo.. " second(s) espere.")
else
doPlayerSendCancel(cid, "Você Prescisa " ..config.price.. " De Tds Pra Falar Novo Anuncio.")
return true
end
else
doPlayerSendCancel(cid, "Vou Falo no Anuncio " ..(getPlayerStorageValue(cid, config.storage) - os.time()).. " seconds Espere.")
return true
end
else
doPlayerSendCancel(cid, "Debes tener nivel " ..config.level.. " o más para usar anuncios.")
end
end