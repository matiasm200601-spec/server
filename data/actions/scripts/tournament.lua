function onUse(cid, item)

if #getPlayersInArea(torneio.area) > 1 then
doPlayerSendTextMessage(cid, 20 ,"Termine com outros em primeiro lugar, o jovem treinador!") return true end

doTeleportThing(cid, torneio.playerTemple)
doPlayerSendTextMessage(cid, 21, "Parabéns jovem treinador, você ganhou o torneio, e ganhou um "..getItemNameById(torneio.awardTournament).." como recompensa.")
doPlayerAddItem(cid, torneio.awardTournament, torneio.awardAmount)
return true
end