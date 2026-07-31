local correrCondition = createConditionObject(CONDITION_HASTE)
local CORRER_SPEED_BONUS = 100
local CORRER_DURATION_SECONDS = 60
local CORRER_COOLDOWN_STORAGE = 873421

setConditionParam(correrCondition, CONDITION_PARAM_SPEED, CORRER_SPEED_BONUS)
setConditionParam(correrCondition, CONDITION_PARAM_TICKS, CORRER_DURATION_SECONDS * 1000)

function onSay(cid, words, param)
    local availableAt = getPlayerStorageValue(cid, CORRER_COOLDOWN_STORAGE)
    if availableAt > os.time() then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Correr estará disponible en " .. (availableAt - os.time()) .. " segundos.")
        return true
    end

    setPlayerStorageValue(cid, CORRER_COOLDOWN_STORAGE, os.time() + CORRER_DURATION_SECONDS)
    doAddCondition(cid, correrCondition)
    doSendMagicEffect(getCreaturePosition(cid), CONST_ME_MAGIC_BLUE)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Correr activado: velocidad aumentada en 100 durante 60 segundos.")
    return true
end
