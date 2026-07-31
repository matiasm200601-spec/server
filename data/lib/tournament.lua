torneio = {
awardTournament = 13100,
awardAmount = 1,
playerTemple = {x = 1054, y = 1049, z = 7},
tournamentFight = {x = 513, y = 679, z = 7},
area = {fromx = 513, fromy = 679, fromz = 7, tox = 521, toy = 679, toz= 7},
waitPlace = {x = 545, y = 678, z = 7},  
waitArea = {fromx = 543, fromy = 678, fromz = 7, tox = 547, toy = 678, toz= 7},
startHour = "22:40:00",
endHour = "22:50:00",
price = 5000000,
revivePoke = 12344,
}

function getPlayersInArea(area)

local players = {}

for x = area.fromx,area.tox do
for y = area.fromy,area.toy do
for z = area.fromz,area.toz do

local m = getTopCreature({x=x, y=y, z=z}).uid

if m ~= 0 and isPlayer(m) then
table.insert(players, m)
end
end
end
end
return players
end