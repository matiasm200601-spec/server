function onDeath(cid, corpse, killer)
local Ppos = {x = 683, y = 1321, z = 8} -- posicao para onde ele vai ir
local monstName = "Suicune"  -- nome do monstro				
if isMonster(cid) and string.lower(getCreatureName(cid)) == string.lower(monstName) then
if isInParty(killer[1]) == TRUE then
local players = getPartyMembers(getPartyLeader(killer[1]))
for i, k in ipairs(players) do
doTeleportThing(k, Ppos)
end
else
doTeleportThing(killer[1], Ppos)
end  
end
		return TRUE
end