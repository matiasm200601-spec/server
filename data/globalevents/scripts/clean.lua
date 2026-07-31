function executeClean()
	doCleanMap()
	doBroadcastMessage("O chao foi limpo, proxima limpeza em 2 horas.")
	return true
end

function onThink(interval, lastExecution, thinkInterval)
	doBroadcastMessage("O mapa sera limpo em 30 segundos, cuidado com seus itens!")
	addEvent(executeClean, 30000)
	return true
end
