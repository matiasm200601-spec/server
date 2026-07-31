local leveis = {
[1] = {lvl = 50, item = 2160, quant = 10, sto = 88888},
[2] = {lvl = 100, item = 2160, quant = 20, sto = 88889},
[3] = {lvl = 200, item = 2160, quant = 40, sto = 88890},
[4] = {lvl = 300, item = 2160, quant = 60, sto = 88891},
[5] = {lvl = 400, item = 2160, quant = 80, sto = 88892},
[6] = {lvl = 500, item = 2160, quant = 100, sto = 88893}
}

function onAdvance(cid, skill, oldLevel, newLevel)

local level = getPlayerLevel(cid)

       for i = 1, #leveis do
          if level >= leveis[i].lvl and getPlayerStorageValue(cid, leveis[i].sto) <= 0 then
                  doPlayerAddItem(cid, leveis[i].item, leveis[i].quant)
                  setPlayerStorageValue(cid, leveis[i].sto, 1)   
                  doPlayerSendTextMessage(cid, 22, "Você upou level "..level.." o más y recibiste "..leveis[i].quant..", "..getItemNameById(leveis[i].item).."!")
          end
       end
  
 return true
end