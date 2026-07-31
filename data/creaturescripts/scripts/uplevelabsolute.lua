function onAdvance(cid, skill, oldLevel, newLevel)

local config = {
[30] = {item = 2160, count = 1},
[50] = {item = 2366, count = 1},
[70] = {item = 2160, count = 2},
[100] = {item = 13192, count = 1},
[150] = {item = 13194, count = 1},
[160] = {item = 2160, count = 5},
[180] = {item = 2366, count = 1},
[300] = {item = 10223, count = 1},
[310] = {item = 2160, count = 10},
[500] = {item = 13196, count = 1},
}

if skill == 8 then
for level, info in pairs(config) do
if newLevel >= level and (getPlayerStorageValue(cid, 30700) == -1 or not (string.find(getPlayerStorageValue(cid, 30700), "'" .. level .. "'"))) then
doPlayerAddItem(cid, info.item, info.count)
doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "Parabéns, você atingiu o level "..newLevel.." e ganhou "..info.count.." "..getItemNameById(info.item)..".")
local sat = getPlayerStorageValue(cid, 30700) == -1 and "Values: '" .. level .. "'" or getPlayerStorageValue(cid, 30700) .. ",'" .. level .. "'" 
setPlayerStorageValue(cid, 30700, sat)
end
end
end

return TRUE
end