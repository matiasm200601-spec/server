--//
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
msg = string.lower(msg)
--\\
 
   ----
local need = {
--item id....quantidade
{id = 12152, qt = 500},
{id = 12162, qt = 500},
}
local storage = 83497
local pokemon = "Shiny Charizard" -- nome do poke
   -----
if msgcontains(string.lower(msg), 'help') or msgcontains(string.lower(msg), 'help') then
if getPlayerStorageValue(cid, storage) == 1 then
selfSay("você já completou minha quest!", cid)
return true
end
--//
selfSay("olá, você gostaría de trocar alguns itens e em troca eu dou um pokémon? os items necessaríos são {500 Pots Of Lava, 500 Essences Of Fire}!", cid)
 talkState[talkUser] = 2
   return true
 elseif msgcontains(msg, 'yes') and talkState[talkUser] == 2 then
         for i = 1, #need do
          if getPlayerItemCount(cid, need[i].id) <need[i].qt then
            selfSay("você não tem todos itens necessaríos que eu pedi, volte aqui quando tive-los todos!", cid)
              talkState[talkUser] = 0
                return true
            end
        end     
            if not addPokeToPlayer(cid, pokemon, 0, -1, "normal", true) then
                selfSay("você esta com 6 pokemons na sua bag, volte aqui contendo espaço para o seu novo pokemon!", cid)
             talkState[talkUser] = 0
             return true
          end
             for i = 1, #need do
                doPlayerRemoveItem(cid, need[i].id, need[i].qt)
            end
 selfSay("nossa muito bom, obrigado e faça um bom proveito do seu novo pokémon!", cid)
   setPlayerStorageValue(cid, storage, 1)
   talkState[talkUser] = 0
                    return true
                end
    return true
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())