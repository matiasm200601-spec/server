local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)

if(not npcHandler:isFocused(cid)) then
return false
end

local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

if msgcontains(msg, 'torneio') or msgcontains(msg, 'enter') then

if getPlayerItemCount(cid, torneio.revivePoke) >= 1 then
selfSay('Você não pode entrar no torneio com {revives}, por favor, jogá-los fora.', cid)
return true
end

selfSay('Você quer participar do torneio por '..torneio.price..' gps / dollars?', cid)
talkState[talkUser] = 2


elseif talkState[talkUser] == 2 then

if msgcontains(msg, 'yes') or msgcontains(msg, 'sim') then

if os.date("%X") < torneio.startHour or os.date("%X") > torneio.endHour then
selfSay('As inscrições para o torneio terminar, volte mais tarde.', cid)
return true
end

if doPlayerRemoveMoney(cid, torneio.price) then
doTeleportThing(cid, torneio.waitPlace)
doPlayerSendTextMessage(cid, 21, "Bem-vindo, esta é a sala de espera, você espera aqui enquanto o torneio não começa. hora de início: {"..torneio.endHour.."}.")
else

selfSay('Você não tem dinheiro suficiente ('..torneio.price..').', cid)
end
else
selfSay('Claro que você não quer participar? Ok, até a próxima!', cid)
talkState[talkUser] = 0
end
end
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())