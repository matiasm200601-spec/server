local level = 100   --lvl minimo pra ganhar
local sto = 40000 --storage da outfit
function onAdvance(cid, skill, oldLevel, newLevel)

if newLevel >= level then
   if getPlayerStorageValue(cid, sto) < 1 then
          setPlayerStorageValue(cid, sto, 1)
          doPlayerSendTextMessage(cid, 27, "voce ganhou uma nova outfit!")
   end
end
return true
end