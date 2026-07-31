local fishes = {
[70] = {"Magikarp s", "Poliwag s", "Horsea s", "Krabby s", "Goldeen s", "Tentacool s", "Staryu s", "Poliwhirl s", "Seaking s", "Kingler s", "Seadra s", "Starmie s", "Squirtle s"},
[65] = {"Magikarp s", "Poliwag s", "Horsea s", "Krabby s", "Goldeen s", "Tentacool s", "Staryu s", "Poliwhirl s", "Seaking s", "Kingler s", "Seadra s", "Starmie s"},

[60] = {"Magikarp s", "Poliwag s", "Horsea s", "Krabby s", "Goldeen s", "Tentacool s", "Staryu s", "Poliwhirl s", "Seaking s", "Kingler s", "Seadra s"},
[55] = {"Magikarp s", "Poliwag s", "Horsea s", "Krabby s", "Goldeen s", "Tentacool s", "Staryu s", "Poliwhirl s", "Seaking s", "Kingler s"},
[50] = {"Magikarp s", "Poliwag s", "Horsea s", "Krabby s", "Goldeen s", "Tentacool s", "Staryu s", "Poliwhirl s", "Seaking s"},
[45] = {"Magikarp s", "Poliwag s", "Horsea s", "Krabby s", "Goldeen s", "Tentacool s", "Staryu s", "Poliwhirl s"},
[40] = {"Magikarp s", "Poliwag s", "Horsea s", "Krabby s", "Goldeen s", "Tentacool s", "Staryu s"},
[35] = {"Magikarp s", "Poliwag s", "Horsea s", "Krabby s", "Goldeen s", "Tentacool s"},

[30] = {"Magikarp s", "Poliwag s", "Horsea s", "Krabby s", "Goldeen s"},
[25] = {"Magikarp s", "Poliwag s", "Horsea s", "Krabby s"},
[20] = {"Magikarp s", "Poliwag s", "Horsea s"},
[15] = {"Magikarp s", "Poliwag s"},
[10] = {"Magikarp s"}
}


function onUse(cid, item, fromPos, itemEx, toPos)

local waters = {4614, 4615, 4616, 4617, 4618, 4619, 4608, 4609, 4610, 4611, 4612, 4613, 7236, 4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622, 4623, 4624, 4625, 4665, 4666, 4820, 4821, 4822, 4823, 4824, 4825}
local skill = getPlayerSkillLevel(cid, 6)
local removed = doCreateItem(1285, 1, getThingPos(cid))
local playerpos = getClosestFreeTile(cid, getThingPos(cid))
doRemoveItem(removed, 1)

if isInArray(waters, getTileInfo(getThingPos(cid)).itemid) then
doPlayerSendCancel(cid, "No puedes pescar mientras navegas ni mientras vuelas sobre el agua.")
return true
end

doPlayerAddSkillTry(cid, 6, 1)

if(isInArray(waters, itemEx.itemid)) then
doSendMagicEffect(toPos, CONST_ME_LOSEENERGY)
end

for a, b in pairs(fishes) do
if skill >= a and math.random(1, 100) <= 20 then
doPlayerAddSkillTry(cid, 6, 5)
local peixe = doSummonCreature(b[math.random(1, #b)], playerpos)
	if #getCreatureSummons(cid) >= 1 then
	doSendMagicEffect(getThingPos(getCreatureSummons(cid)[1]), 173)
	doChallengeCreature(getCreatureSummons(cid)[1], peixe)
	else
	doSendMagicEffect(getThingPos(cid), 173)
	doChallengeCreature(cid, peixe)
	end
return true
end
end

return true
end