function onTimer(cid, interval, lastExecution) 

doBroadcastMessage("¡La Arena Dorada comenzará en 10 minutos! ¡Prepárate!")
addEvent(doBroadcastMessage, 300000, "¡La Arena Dorada comenzará en 5 minutos!\n¡Esperamos que los participantes estén preparados!") 
addEvent(puxaParticipantes, 480000)  	
addEvent(doWave, 600000, true)            --alterado v1.8       

return true
end