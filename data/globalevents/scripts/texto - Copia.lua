local config = {
positions = {
["Area De"] = { x = 1059, y = 1046, z = 7 },
["Bag"] = { x = 1059, y = 1047, z = 5 },
["Pesca"] = { x = 1060, y = 1046, z = 7 },
["ARIA UP"] = { x = 1725, y = 1779, z = 6 },
["Boxs"] = { x = 1728, y = 1779, z = 6 },
["Q-Articuno"] = { x = 430, y = 605, z = 7 },
["B5"] = { x = 432, y = 605, z = 7 }, 
["B6"] = { x = 434, y = 605, z = 7 },
["B7"] = { x = 436, y = 605, z = 7 },
["B8"] = { x = 438, y = 605, z = 7 },
["B9"] = { x = 440, y = 605, z = 7 },
["B10"] = { x = 440, y = 607, z = 7 },
["Area 1"] = { x = 445, y = 605, z = 7 },
["Area 2"] = { x = 449, y = 605, z = 7 },
["Quests e Hunts"] = { x = 1047, y = 1046, z = 7 },
}
}

function onThink(cid, interval, lastExecution)
for text, pos in pairs(config.positions) do
doSendAnimatedText(pos, text, math.random(1, 255))
end

return TRUE
end 