local items = {{2035, 1}}
local min_level = 30    --Level mínimo para pegar os items do baú.
local time = 60     --Em minutos. 
local storage = 91838
function onUse(cid, item, frompos, item2, topos)
    if getPlayerLevel(cid) >= min_level then
        if getPlayerStorageValue(cid, storage) < os.time() then
            local it = items[math.random(#items)]
            doPlayerAddItem(cid, it[1], it[2])
            doPlayerSendTextMessage(cid, 27, "Você recebeu "..it[2].." "..getItemNameById(it[1])..". Você poderá pegar sua próxima recompensa em "..time.." minutos.")
            setPlayerStorageValue(cid, storage, os.time() + time * 60)
        else
            return doPlayerSendCancel(cid, "Voce já pegou sua recompensa recentemente.")
        end
    else
        return doPlayerSendCancel(cid, "Voce nao possui o nível adequado para pegar a recompensa ["..min_lv.."].")
    end
    return true
end