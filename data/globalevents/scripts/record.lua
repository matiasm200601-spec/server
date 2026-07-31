function onRecord(current, old, cid)
	db.executeQuery("INSERT INTO `server_record` (`record`, `world_id`, `timestamp`) VALUES (" .. current .. ", " .. getConfigValue('worldId') .. ", " .. os.time() .. ");")
	addEvent(doBroadcastMessage, 150, "Nuevo récord: " .. current .. " jugadores están conectados.", MESSAGE_STATUS_DEFAULT)
end
