-- Created by Pepeco --
local im = {
	[1] = {item = {2178, 1}, monster = {"Regirock"}},
	[2] = {item = {2327, 1}, monster = {"Registeel"}},
	[2] = {item = {4851, 1}, monster = {"Regice"}}
}
function onKill(cid, target, lastHit)
	if isPlayer(cid) and not isPlayer(target) then
		for _, all in pairs(im) do
			-- print(getCreatureName(target)) -- Caso nao funcione, tente usar isso para pegar o nome exato do seu monstro.
			if getCreatureName(target) == all.monster[1] then
				doPlayerAddItem(cid, all.item[1], all.item[2])
			end
		end
	end
	return true
end