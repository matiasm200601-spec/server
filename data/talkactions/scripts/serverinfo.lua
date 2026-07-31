local config = {
	rateExperience = getConfigInfo('rateExperience'),
	rateSkill = getConfigInfo('rateSkill'),
	rateLoot = getConfigInfo('rateLoot'),
	rateMagic = getConfigInfo('rateMagic'),
	rateSpawn = getConfigInfo('rateSpawn'),
	protectionLevel = getConfigInfo('protectionLevel'),
	stages = getBooleanFromString(getConfigInfo('experienceStages'))
}

function onSay(cid, words, param, channel)
	local exp = config.rateExperience
	if(config.stages) then
		exp = getExperienceStage(getPlayerLevel(cid), getVocationInfo(getPlayerVocation(cid)).experienceMultiplier)
	end

	doPlayerPopupFYI(cid, "Información del servidor:\n\nRate de experiencia: x" .. exp .. "\nRate de habilidades: x" .. config.rateSkill .. "\nRate de botín: x" .. config.rateLoot .. "\nRate de magia: x" .. config.rateMagic .. "\nRate de apariciones: x" .. config.rateSpawn .. "\nNivel de protección: " .. config.protectionLevel)
	return true
end
