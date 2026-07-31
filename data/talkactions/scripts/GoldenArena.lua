function onSay(cid, words, param, channel)

if param and (param == "register" or param == "Register") then

if getGlobalStorageValue(22549) ~= -1 then
   s = string.explode(getGlobalStorageValue(22549), ",")
   for i = 1, #s do
       if getCreatureName(cid) == s[i] then
          doPlayerSendTextMessage(cid, 20, "¡Ya estás registrado en la Arena Dorada!")
          return true
       end                                                               --alterado!!
   end
   if #s > 15 then
      doPlayerSendTextMessage(cid, 20, "Lo sentimos, se alcanzó el límite de jugadores para la Arena Dorada.")
      return true
   end
end
                           --alterado v1.3
   doPlayerSendTextMessage(cid, 20, "¡Te registraste en la Arena Dorada!")
   if getGlobalStorageValue(22549) == -1 then
      setGlobalStorageValue(22549, getCreatureName(cid)..",")
   else                                                                            --alterado!!
      setGlobalStorageValue(22549, getGlobalStorageValue(22549)..""..getCreatureName(cid)..",")
   end
   
elseif param and (param == "horarios" or param == "Horarios") then

   local hours = ""
   local c = 0
   for i = 1, #hours do
       hours = hours..((i == #hours and c ~= 0) and " and " or i ~= 1 and ", " or "")..hours[i]  --alterado v1.7
       c = c+1
   end
   hours = hours.." horas."
   doPlayerSendTextMessage(cid, 20, "La Arena Dorada se realiza a las "..hours)
   timeDiff = showTimeDiff(nextHorario(cid))                                                         
   doPlayerSendTextMessage(cid, 20, "Próximo evento en "..timeDiff..".")   --alterado v1.3 
end

return true
end