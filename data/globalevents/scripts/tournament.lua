function onTimer()

if #getPlayersInArea(torneio.area) > 1 then
doBroadcastMessage("O torneio, desta vez não teve vencedor, boa sorte na próxima vez!") return true end

for _, pid in ipairs(getPlayersInArea(torneio.waitArea)) do
doTeleportThing(pid, torneio.tournamentFight)
doPlayerSendTextMessage(pid, 21, "O torneio começou, boa sorte treinadores!")
end
return true
end