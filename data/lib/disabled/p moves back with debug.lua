const_distance_delay = 56

function getMasterTarget(cid)
	return getCreatureTarget(getCreatureMaster(cid))
end

function doAreaCombatWithDelay(cid, target, pos, area, type, effect, a, b)
	if not isCreature(cid) then return true end
	local topos = {}
		if isCreature(target) then topos = getThingPosWithDebug(target) else topos = pos end
	doAreaCombatHealth(cid, type, topos, area, -math.abs(a), -math.abs(b), effect)
end 

function doAreaCombatHealthAtDistance(cid, type, pos, area, min, max, effect)
	local delay = 0
	if isCreature(cid) and isCreature(getMasterTarget(cid)) then
		delay = getDistanceBetween(getThingPosWithDebug(cid), getThingPosWithDebug(getMasterTarget(cid))) * const_distance_delay
		addEvent(doAreaCombatWithDelay, delay, cid, getMasterTarget(cid), getThingPosWithDebug(getMasterTarget(cid)), area, type, effect, -min, -max)
	return true
	end
	doAreaCombatHealth(cid, type, pos, area, min, max, effect)
end

function docastspell(cid, spell, mina, maxa)

local getThingPositionWithDebug = getThingPosWithDebug

if not isCreature(cid) then return false end
if isSleeping(cid) then return true end
if getPlayerStorageValue(cid, 6) >= 1 then doSendAnimatedText(getThingPositionWithDebug(cid), "DISABLED", 152) return true end
if isMonster(cid) and not isSummon(cid) then
	if getCreatureCondition(cid, CONDITION_EXHAUST) then
	return true
	end
	doCreatureAddCondition(cid, wildexhaust)
end

local mydir = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)
local target = 0
local getDistDelay = 0

if isCreature(getMasterTarget(cid)) then
	target = getMasterTarget(cid)
	getDistDelay = getDistanceBetween(getThingPositionWithDebug(cid), getThingPositionWithDebug(target)) * const_distance_delay
end

local movetype = getSpecialAttack(cid)

local min = 0
local max = 0
local healMultiplier = 1

if mina and maxa then
min = math.abs(mina)
max = math.abs(maxa)
elseif not isPlayer(cid) then
	if movesinfo[spell] then
		if movesinfo[spell].t == "fighting" then
			movetype = getOffense(cid) * 1.4 + getSpecialAttack(cid) * 0.45
		elseif movesinfo[spell].t == "normal" then
			movetype = movetype * 0.6 + getOffense(cid) * 0.6
		end
	min = 5 + getPokemonLevel(cid) + (movesinfo[spell].f / 100 * movetype * specialoffenseRate)
	max = min + getPokemonLevel(cid) * levelFactor
		if not isSummon(cid) then
			doCreatureSay(cid, string.upper(spell).."!", TALKTYPE_MONSTER)
		end
		if isNpcSummon(cid) then
			local mnn = {" use ", " "}
			local use = mnn[math.random(#mnn)]
			doCreatureSay(getCreatureMaster(cid), getPlayerStorageValue(cid, 1007)..","..use..""..doCorrectString(spell).."!", 1)
		end
	else
	print("Error trying to use move "..spell..", move not specified in moves table.")
	end
	
end
--- CONFUSED -------------------------------
if getPlayerStorageValue(cid, 3891) >= 1 then
	if math.random(1,100) <= 33 then
	doSendAnimatedText(getThingPositionWithDebug(cid), "SELF HIT", 180)
	doTargetCombatHealth(cid, cid, COMBAT_PHYSICALDAMAGE, -min/3, -max/3, 3)
	return true
	end
end
--- BLIND ----------------------------------
if getPlayerStorageValue(cid, 3890) >= 1 then
	doSendAnimatedText(getThingPositionWithDebug(cid), "MISS", 215)
	setPlayerStorageValue(cid, 3890, -1)
return true
end
--- FOCUS ----------------------------------
if getPlayerStorageValue(cid, 253) >= 0 and movesinfo[spell] and movesinfo[spell].f ~= 0 then
	min = min * 3
	max = max * 3
	healMultiplier = 3
	setPlayerStorageValue(cid, 253, -1)
end
---- MIMIC ---------------------------------
setPlayerStorageValue(cid, 877, spell)
---- COUNTER -------------------------------
if isCreature(target) and getPlayerStorageValue(target, 879) >= 1 and getDistanceBetween(getThingPositionWithDebug(cid), getThingPositionWithDebug(target)) <= 2 and spell ~= "Counter" then
	if movesinfo[spell] and movesinfo[spell].t == "fighting" or movesinfo[spell].t == "normal" then
		if not isInArray({"Hyper Beam", "Hyper Voice", "Counter"}, spell) then
			docastspell(target, spell, min * 2, max * 2)
			doSendAnimatedText(getThingPositionWithDebug(target), "COUNTER", 215)
			setPlayerStorageValue(target, 879, -1)
		end
	end
end
--------------------------------------------


if spell == "Dynamic Punch" then

local dirs = {
[1] = 0,
[2] = 4,
[3] = 6,
[4] = 1,
[5] = 3,
[6] = 2
}

	doAreaCombatHealth(cid, FIGHTINGDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 112)
	local targetarea = getThingPositionWithDebug(getMasterTarget(cid))
	for effcs = 1, 6 do
	addEvent(doSendMagicEffect, 150 * effcs, getPosByDir(getThingPositionWithDebug(getMasterTarget(cid)), dirs[effcs]), 17)
	end

elseif spell == "Quick Attack" then

	doSendMagicEffect(getThingPositionWithDebug(cid), 211)
	local x = getClosestFreeTile(cid, getThingPositionWithDebug(getMasterTarget(cid)))
	doTeleportThing(cid, x, false)
	doFaceCreature(cid, getThingPositionWithDebug(getMasterTarget(cid)))
	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 3)

elseif spell == "Slam" then

	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 118)

elseif spell == "Rapid Hit" then

	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 3)

	local hitalvo = getMasterTarget(cid)

	local function sendef(cid)
		if isCreature(cid) then
		doSendMagicEffect(getThingPositionWithDebug(cid), 3)
		end
	end

	for times = 0, 3 do
	addEvent(sendef, 200*times+80, hitalvo)
	end

elseif spell == "Bite" or tonumber(spell) == 5 then

	doAreaCombatHealth(cid, DARKDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 146)

elseif spell == "Slash" or tonumber(spell) == 6 then

	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 160)

elseif spell == "Splash" or tonumber(spell) == 7 then

	doAreaCombatHealth(cid, WATERDAMAGE, getThingPositionWithDebug(cid), splash, -min, -max, 255)
	doSendMagicEffect(getThingPositionWithDebug(cid), 53)

elseif spell == "Doubleslap" then

	local slapalvo = getMasterTarget(cid)
	local summon = cid
	local function doSlap(cid, target)
		if isCreature(cid) and isCreature(target) then
		doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 3)
		end
	end

	addEvent(doSlap, 0, summon, slapalvo)
	addEvent(doSlap, 600, summon, slapalvo)

elseif spell == "Mega Punch" then

	doAreaCombatHealth(cid, FIGHTINGDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 112)

elseif spell == "Scratch" then

	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 142)

elseif spell == "Confusion" then

	doAreaCombatHealth(cid, PSYCHICDAMAGE, getThingPositionWithDebug(cid), confusion, -min, -max, 133)

elseif spell == "Psychic" then

	doAreaCombatHealth(cid, PSYCHICDAMAGE, getThingPositionWithDebug(cid), psychic, -min, -max, 136)

elseif spell == "Absorb" or spell == "Leech Life" then

	local life = getCreatureHealth(getMasterTarget(cid))

	doAreaCombatHealth(cid, GRASSDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 14)

	local newlife = life - getCreatureHealth(getMasterTarget(cid))

	doSendMagicEffect(getThingPositionWithDebug(cid), 14)
	if newlife >= 1 then
	doCreatureAddHealth(cid, newlife)
	doSendAnimatedText(getThingPositionWithDebug(cid), "+"..newlife.."", 32)
	end

elseif spell == "Mud Shot" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 1)

	local function doEffect(cid, target)
		if not isCreature(cid) or not isCreature(target) then return true end
	doAreaCombatHealth(cid, GROUNDDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 34)
		if math.random(1, 100) >= 78 then
			local rounds = math.random(6, 10)
			rounds = rounds + math.floor(getPokemonLevel(cid) / 20)
			doAdvancedBlind(target, rounds, getPlayerStorageValue(target, 3890), 34)
		end
	end

	addEvent(doEffect, getDistDelay, cid, target)

elseif spell == "Bubbles" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 2)
	doAreaCombatHealthAtDistance(cid, WATERDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 25)

elseif spell == "Water Spout" then

		doSendDistanceShoot(getThingPositionWithDebug(cid), {x=getThingPositionWithDebug(cid).x, y=getThingPositionWithDebug(cid).y-5, z=getThingPositionWithDebug(cid).z}, 2)

		local function spout(params)
		if isCreature(params.cid) then
		for x = -2,2 do
			for y = -2,2 do
		local newpos = getThingPositionWithDebug(params.cid)
		newpos.x = newpos.x+x
		newpos.y = newpos.y+y
		doSendDistanceShoot({x=getThingPositionWithDebug(params.cid).x, y=getThingPositionWithDebug(params.cid).y-5, z=getThingPositionWithDebug(params.cid).z}, newpos, 2)
		end
		end
		end
		end
		

		local function spdmg(params)
		if isCreature(params.cid) then
		doAreaCombatHealth(params.cid, WATERDAMAGE, getThingPositionWithDebug(params.cid), waterspout, -min, -max, 68)
		end
		end

		addEvent(spout, 300, {cid = cid})
		addEvent(spdmg, 450, {cid = cid})

elseif spell == "Horn Attack" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 15)
	--doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 3)
	addEvent(doAreaCombatWithDelay, getDistDelay, cid, target, getThingPositionWithDebug(target), 0, NORMALDAMAGE, 3, -min, -max)

elseif spell == "Rock Throw" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 11)
	doAreaCombatHealthAtDistance(cid, ROCKDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 3)

elseif spell == "Headbutt" or spell == "Pound" or spell == "Tackle" then

		doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 3)

elseif spell == "Super Sonic" or spell == "Confuse Ray" then

	local target = getMasterTarget(cid)
	local rounds = math.random(4, 7)
	rounds = rounds + math.floor(getPokemonLevel(cid) / 35)

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 32)
	doAdvancedConfuse(target, rounds, getPlayerStorageValue(target, 3891))

elseif spell == "Fury Attack" then

	local alvo = getMasterTarget(cid)

	local function doFuryAttack(cid, target, round, rounds)
		if not isCreature(cid) then return true end
		if round > rounds then
		doSendAnimatedText(getThingPositionWithDebug(cid), ""..rounds.." HITS", 35)
		return true
		end
		if isCreature(getMasterTarget(cid)) and getMasterTarget(cid) ~= target then
		doSendAnimatedText(getThingPositionWithDebug(cid), ""..rounds.." HITS", 35)
		return true
		end
		if not isCreature(getMasterTarget(cid)) then
		doSendAnimatedText(getThingPositionWithDebug(cid), ""..rounds.." HITS", 35)
		return true
		end
		doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 15)
		doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 3)
		addEvent(doFuryAttack, 700, cid, target, round + 1, rounds)
	end
		
	local ther = math.random(1, 200)
		if ther <= 75 then
			maxr = 2
		elseif ther >= 76 and ther <= 100 then
			maxr = 4
		elseif ther >= 101 and ther <= 175 then
			maxr = 3
		elseif ther >= 176 then
			maxr = 5
		end

	doFuryAttack(cid, alvo, 1, maxr)

elseif spell == "Water Gun" then

	if mydir == 0 then
		doAreaCombatHealth(cid, WATERDAMAGE, getThingPositionWithDebug(cid), wg1n, -min, -max, 74)
		doAreaCombatHealth(cid, WATERDAMAGE, getThingPositionWithDebug(cid), wg2n, -min, -max, 75)
		doAreaCombatHealth(cid, WATERDAMAGE, getThingPositionWithDebug(cid), wg3n, -min, -max, 76)
	elseif mydir == 2 then
		doAreaCombatHealth(cid, WATERDAMAGE, getThingPositionWithDebug(cid), wg1s, -min, -max, 77)
		doAreaCombatHealth(cid, WATERDAMAGE, getThingPositionWithDebug(cid), wg2s, -min, -max, 75)
		doAreaCombatHealth(cid, WATERDAMAGE, getThingPositionWithDebug(cid), wg3s, -min, -max, 78)
	elseif mydir == 1 then
		doAreaCombatHealth(cid, WATERDAMAGE, getThingPositionWithDebug(cid), wg1e, -min, -max, 69)
		doAreaCombatHealth(cid, WATERDAMAGE, getThingPositionWithDebug(cid), wg2e, -min, -max, 70)
		doAreaCombatHealth(cid, WATERDAMAGE, getThingPositionWithDebug(cid), wg3e, -min, -max, 71)
	elseif mydir == 3 then
		doAreaCombatHealth(cid, WATERDAMAGE, getThingPositionWithDebug(cid), wg1w, -min, -max, 72)
		doAreaCombatHealth(cid, WATERDAMAGE, getThingPositionWithDebug(cid), wg2w, -min, -max, 70)
		doAreaCombatHealth(cid, WATERDAMAGE, getThingPositionWithDebug(cid), wg3w, -min, -max, 73)
	end

elseif spell == "Peck" then

		doAreaCombatHealth(cid, FLYINGDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 3)

elseif spell == "Pluck" then

	doAreaCombatHealth(cid, FLYINGDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), pluck, -min, -max, 2)

elseif spell == "Sand Attack" then

		local posicao = getThingPositionWithDebug(cid)

		local function sandattack(params)
			if isCreature(params.cid) and isSightClear(posicao, params.ar, false) then
			doAreaCombatHealth(params.cid, GROUNDDAMAGE, params.ar, sand1, -min, -max, params.ef)
			end
		end

		if mydir == 0 then
			addEvent(sandattack, 0, {cid = cid, ar = {x=posicao.x, y=posicao.y-1, z=posicao.z}, ef = 120})
			addEvent(sandattack, 400, {cid = cid, ar = {x=posicao.x, y=posicao.y-2, z=posicao.z}, ef = 120})
			addEvent(sandattack, 800, {cid = cid, ar = {x=posicao.x, y=posicao.y-3, z=posicao.z}, ef = 120})
		elseif mydir == 2 then
			addEvent(sandattack, 0, {cid = cid, ar = {x=posicao.x, y=posicao.y+1, z=posicao.z}, ef = 122})
			addEvent(sandattack, 400, {cid = cid, ar = {x=posicao.x, y=posicao.y+2, z=posicao.z}, ef = 122})
			addEvent(sandattack, 800, {cid = cid, ar = {x=posicao.x, y=posicao.y+3, z=posicao.z}, ef = 122})
		elseif mydir == 1 then
			addEvent(sandattack, 0, {cid = cid, ar = {x=posicao.x+1, y=posicao.y, z=posicao.z}, ef = 121})
			addEvent(sandattack, 400, {cid = cid, ar = {x=posicao.x+2, y=posicao.y, z=posicao.z}, ef = 121})
			addEvent(sandattack, 800, {cid = cid, ar = {x=posicao.x+3, y=posicao.y, z=posicao.z}, ef = 121})
		elseif mydir == 3 then
			addEvent(sandattack, 0, {cid = cid, ar = {x=posicao.x-1, y=posicao.y, z=posicao.z}, ef = 119})
			addEvent(sandattack, 400, {cid = cid, ar = {x=posicao.x-2, y=posicao.y, z=posicao.z}, ef = 119})
			addEvent(sandattack, 800, {cid = cid, ar = {x=posicao.x-3, y=posicao.y, z=posicao.z}, ef = 119})
		end

elseif spell == "Spark" then

				local function spark(params)
				if isCreature(params.cid) then
				doSendDistanceShoot(getThingPositionWithDebug(params.cid), params.cidpos, 40)
				doAreaCombatHealth(cid, ELECTRICDAMAGE, params.cidpos, 0, -min, -max, 48)
				end
				end
		for a = -1, 1 do
			for b = -1, 1 do
			cidpos = getThingPositionWithDebug(cid)
			cidpos.x = cidpos.x+a
			cidpos.y = cidpos.y+b
			addEvent(spark, math.abs(a)*350 + math.abs(b)*650, {cid = cid, cidpos = cidpos})
			end
		end

elseif spell == "Razor Leaf" then

	local alvo = getMasterTarget(cid)

			local function throw(cid, target)
			if isCreature(cid) then
			if isCreature(target) then
			doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(target), 8)
			addEvent(doAreaCombatWithDelay, getDistanceBetween(getThingPositionWithDebug(cid), getThingPositionWithDebug(target)) * 60, cid, target, getThingPositionWithDebug(target), 0, GRASSDAMAGE, 3, -min, -max)
			end
			end
			end

		addEvent(throw, 0, cid, alvo)
		addEvent(throw, 550, cid, alvo)

elseif spell == "Waterball" then

		local function throw(params)
		if isCreature(params.cid) then
		if isCreature(getMasterTarget(params.cid)) then
		doSendDistanceShoot(getThingPositionWithDebug(params.cid), getThingPositionWithDebug(getMasterTarget(params.cid)), 2)
		addEvent(doAreaCombatWithDelay, getDistDelay, cid, target, getThingPositionWithDebug(target), waba, WATERDAMAGE, 68, -min, -max)
		end
		end
		end

		addEvent(throw, 0, {cid = cid})

elseif spell == "Restore" or spell == "Selfheal" or spell == "Recover" then

	local amount = getSpecialAttack(cid) * 2 * healMultiplier
	doSendMagicEffect(getThingPositionWithDebug(cid), 14)
	doCreatureAddHealth(cid, amount)
	doSendAnimatedText(getThingPositionWithDebug(cid), "+"..amount.."", 35)

elseif spell == "Acid" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 14)
	doAreaCombatHealthAtDistance(cid, POISONDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 20)

elseif spell == "Thundershock" or spell == "Thunder Shock" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 40)
	doAreaCombatHealthAtDistance(cid, ELECTRICDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 48)

elseif spell == "Water Pulse" then

		local function throw(params)
			if isCreature(params.cid) then
			if isCreature(getMasterTarget(params.cid)) then
			doSendDistanceShoot(getThingPositionWithDebug(params.cid), getThingPositionWithDebug(getMasterTarget(params.cid)), 33)
			addEvent(doAreaCombatWithDelay, getDistDelay, cid, target, getThingPositionWithDebug(target), 0, WATERDAMAGE, 68, -min, -max)
			end
			end
		end

		addEvent(throw, 0, {cid = cid})

elseif spell == "String Shot" then

		local target = getMasterTarget(cid)
		local rounds = math.random(6, 10)
		rounds = rounds + math.floor(getPokemonLevel(cid) / 20)
		doAdvancedBlind(target, rounds, getPlayerStorageValue(target, 3890), 137)
		doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 23)

elseif spell == "Thunder Wave" then

	if mydir == 0 then
		doAreaCombatHealth(cid, THUNDERWAVEDAMAGE, getThingPositionWithDebug(cid), tsn, -min, -max, 48)
	elseif mydir == 1 then
		doAreaCombatHealth(cid, THUNDERWAVEDAMAGE, getThingPositionWithDebug(cid), tse, -min, -max, 48)
	elseif mydir == 2 then
		doAreaCombatHealth(cid, THUNDERWAVEDAMAGE, getThingPositionWithDebug(cid), tss, -min, -max, 48)
	elseif mydir == 3 then
		doAreaCombatHealth(cid, THUNDERWAVEDAMAGE, getThingPositionWithDebug(cid), tsw, -min, -max, 48)
	end

elseif spell == "Leech Seed" then

	local leecher = cid
	local leeched = getMasterTarget(cid)
	local dmg = 1.5 * getPokemonLevel(cid)

		local function drain(cid, target)
		if isCreature(cid) and isCreature(target) then
		local life = getCreatureHealth(target)
		doAreaCombatHealth(cid, GRASSDAMAGE, getThingPositionWithDebug(target), 0, -dmg, -dmg, 45)
		local newlife = life - getCreatureHealth(leeched)
		if newlife >= 1 then
		doSendMagicEffect(getThingPositionWithDebug(leecher), 14)
		doCreatureAddHealth(leecher, newlife)
		doSendAnimatedText(getThingPositionWithDebug(leecher), "+"..newlife.."", 32)
		end
		end
		end

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 1)
	for rounds = 1, 5 do
	addEvent(drain, 2000 * rounds, leecher, leeched)
	end

elseif spell == "Sludge" then     

		doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 6)
		doAreaCombatHealthAtDistance(cid, POISONDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 116)

elseif spell == "Poison Sting" then

		doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 15)
		doAreaCombatHealthAtDistance(cid, POISONDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 8)

elseif spell == "Bug Bite" then

		doAreaCombatHealth(cid, BUGDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 3)

elseif spell == "Pin Missile" then

		doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 13)
		doAreaCombatHealthAtDistance(cid, POISONDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 3)

elseif spell == "Rock Slide" then

		local function doRockHurt(cid, target)
			if not isCreature(target) or not isCreature(cid) then return true end
		doAreaCombatHealth(cid, ROCKDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 44)
		end

		local function doFallRock(cid, target)
			if not isCreature(target) or not isCreature(cid) then return true end
		local pos = getThingPositionWithDebug(target)
		pos.x = pos.x + math.random(-3, 1)
		local ry = math.random(5, 7)
		pos.y = pos.y - ry
		doSendDistanceShoot(pos, getThingPositionWithDebug(target), 11)
		addEvent(doRockHurt, ry * 52, cid, target)
		end		

	local alvo = getMasterTarget(cid)

	for rocks = 0, 4 do
		addEvent(doFallRock, rocks * 65, cid, alvo)
	end

elseif spell == "Gust" then

	local posicao = getThingPositionWithDebug(cid)

	local function gust(params)
	if isCreature(params.cid) and isSightClear(posicao, params.ar, false) then
	doAreaCombatHealth(cid, FLYINGDAMAGE, params.ar, sand1, -min, -max, 42)
	end
	end

	if mydir == 0 then
		for b = 0, 3 do
			addEvent(gust, 350 * b, {cid = cid, ar = {x=posicao.x, y=posicao.y-(b+1), z=posicao.z}})
		end
	elseif mydir == 2 then
		for b = 0, 3 do
			addEvent(gust, 350 * b, {cid = cid, ar = {x=posicao.x, y=posicao.y+(b+1), z=posicao.z}})
		end
	elseif mydir == 1 then
		for b = 0, 3 do
			addEvent(gust, 350 * b, {cid = cid, ar = {x=posicao.x+(1+b), y=posicao.y, z=posicao.z}})
		end
	elseif mydir == 3 then
		for b = 0, 3 do
			addEvent(gust, 350 * b, {cid = cid, ar = {x=posicao.x-(1+b), y=posicao.y, z=posicao.z}})
		end
	end

elseif spell == "Whirlwind" then

	local posicao = getThingPositionWithDebug(cid)
		
	local function wwind(params)
	if isCreature(cid) and isSightClear(posicao, params.ar, false) then
	doAreaCombatHealth(cid, FLYINGDAMAGE, params.ar, params.br, -min, -max, 42)
	end
	end

	if mydir == 0 then
		addEvent(wwind, 0, {cid = cid, ar = {x=posicao.x, y=posicao.y-1, z=posicao.z}, br = sand1})
		addEvent(wwind, 350, {cid = cid, ar = {x=posicao.x, y=posicao.y-2, z=posicao.z}, br = whirl3})
		addEvent(wwind, 700, {cid = cid, ar = {x=posicao.x, y=posicao.y-3, z=posicao.z}, br = whirl5})
		addEvent(wwind, 1050, {cid = cid, ar = {x=posicao.x, y=posicao.y-4, z=posicao.z}, br = whirl5})
	elseif mydir == 2 then
		addEvent(wwind, 0, {cid = cid, ar = {x=posicao.x, y=posicao.y+1, z=posicao.z}, br = sand1})
		addEvent(wwind, 350, {cid = cid, ar = {x=posicao.x, y=posicao.y+2, z=posicao.z}, br = whirl3})
		addEvent(wwind, 700, {cid = cid, ar = {x=posicao.x, y=posicao.y+3, z=posicao.z}, br = whirl5})
		addEvent(wwind, 1050, {cid = cid, ar = {x=posicao.x, y=posicao.y+4, z=posicao.z}, br = whirl5})
	elseif mydir == 1 then
		addEvent(wwind, 0, {cid = cid, ar = {x=posicao.x+1, y=posicao.y, z=posicao.z}, br = sand1})
		addEvent(wwind, 350, {cid = cid, ar = {x=posicao.x+2, y=posicao.y, z=posicao.z}, br = whirl32})
		addEvent(wwind, 700, {cid = cid, ar = {x=posicao.x+3, y=posicao.y, z=posicao.z}, br = whirl52})
		addEvent(wwind, 1050, {cid = cid, ar = {x=posicao.x+4, y=posicao.y, z=posicao.z}, br = whirl52})
	elseif mydir == 3 then
		addEvent(wwind, 0, {cid = cid, ar = {x=posicao.x-1, y=posicao.y, z=posicao.z}, br = sand1})
		addEvent(wwind, 350, {cid = cid, ar = {x=posicao.x-2, y=posicao.y, z=posicao.z}, br = whirl32})
		addEvent(wwind, 700, {cid = cid, ar = {x=posicao.x-3, y=posicao.y, z=posicao.z}, br = whirl52})
		addEvent(wwind, 1050, {cid = cid, ar = {x=posicao.x-4, y=posicao.y, z=posicao.z}, br = whirl52})
	end

elseif spell == "Hyper Fang" then

	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 159)

elseif spell == "Rollout" then


	if getCreatureName(cid) == "Voltorb" then
		doSetCreatureOutfit(cid, voltorb, 8300)
	elseif getCreatureName(cid) == "Electrode" then
		doSetCreatureOutfit(cid, electrode, 8300)
	elseif getCreatureName(cid) == "Sandshrew" then
		doSetCreatureOutfit(cid, sandshrew, 8300)
	elseif getCreatureName(cid) == "Sandslash" then
		doSetCreatureOutfit(cid, sandslash, 8300)
	elseif getCreatureName(cid) == "Phanpy" then
		doSetCreatureOutfit(cid, phanpy, 8300)
	elseif getCreatureName(cid) == "Dolphan" then
		doSetCreatureOutfit(cid, dolphan, 8300)
	elseif getCreatureName(cid) == "Miltank" then
		doSetCreatureOutfit(cid, miltank, 8300)
	elseif getCreatureName(cid) == "Golem" then
		doSetCreatureOutfit(cid, golem, 8300)
	end

	doCreatureAddCondition(cid, rollspeedcondition)

	local outfit = getCreatureOutfit(cid).lookType

			local function roll(cid, outfit)
			if not isCreature(cid) then return true end
			if getCreatureOutfit(cid).lookType ~= outfit then return true end
			doAreaCombatHealth(cid, GROUNDDAMAGE, getThingPositionWithDebug(cid), splash, -min, -max, 255)
			end

		for r = 1, 8 do
		addEvent(roll, 750 * r, cid, outfit)
		end

elseif spell == "Vine Whip" then

local area = getThingPositionWithDebug(cid)
local dano = {}
local effect = 255

	if mydir == 0 then
		area.x = area.x + 1
		area.y = area.y - 1
		dano = whipn
		effect = 80
	elseif mydir == 1 then
		area.x = area.x + 2
		area.y = area.y + 1
		dano = whipe
		effect = 83
	elseif mydir == 2 then
		area.x = area.x + 1
		area.y = area.y + 2		
		dano = whips
		effect = 81
	elseif mydir == 3 then
		area.x = area.x - 1
		area.y = area.y + 1
		dano = whipw
		effect = 82
	end

		doSendMagicEffect(area, effect)
		doAreaCombatHealth(cid, GRASSDAMAGE, getThingPositionWithDebug(cid), dano, -min, -max, 255)

elseif spell == "Psycho Shift" then

		doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(target), 39)
		doAreaCombatHealthAtDistance(cid, PSYCHOSHIFTDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 134)

elseif spell == "Poison Bomb" then

		doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 14)
		doAreaCombatHealthAtDistance(cid, POISONDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), bomb, -min, -max, 114)

elseif spell == "Toxic Needle" then

		doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 15)
		doAreaCombatHealthAtDistance(cid, POISONDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 8)

elseif spell == "Harden" then

		local function effect(params)
			if isCreature(params.cid) then
			doSendMagicEffect(getThingPositionWithDebug(params.cid), 144)
			end
		end

	local function doReduceDefense(cid, qnt)
		if not isCreature(cid) then return true end
		local a = getDefense(cid)
		setPlayerStorageValue(cid, 1002, a - qnt)
	end
	
	local function doDoubleDefense(cid)
		if not isCreature(cid) then return true end
		local a = getDefense(cid)
		setPlayerStorageValue(cid, 1002, a * 2)
		local b = getDefense(cid)
		local c = b - a
	addEvent(doReduceDefense, 11 * 1500 + 40, cid, c)
	end

	doDoubleDefense(cid)

	for times = 0, 11 do
		addEvent(effect, 1500 * times + 40, {cid = cid})
	end

elseif spell == "Fireball" then

	doSendMoveEffect(cid, getMasterTarget(cid), 3)

	local function damage(cid, target)
		if not isCreature(cid) or not isCreature(target) then return true end
		doAreaCombatHealth(cid, FIREDAMAGE, getThingPositionWithDebug(target), waba, -min, -max, 5)
	end

	addEvent(damage, 100, cid, getMasterTarget(cid))

elseif spell == "Toxic" then

	if mydir == 0 then
		areaa = toxicn
	elseif mydir == 1 then
		areaa = toxice
	elseif mydir == 2 then
		areaa = toxics
	elseif mydir == 3 then
		areaa = toxicw
	end

		doAreaCombatHealth(cid, POISONDAMAGE, getThingPositionWithDebug(cid), areaa, -min, -max, 114)
	
elseif spell == "Aqua Tail" then

	local function rebackSpd(cid, sss)
		if not isCreature(cid) then return true end
		doChangeSpeed(cid, sss)
		setPlayerStorageValue(cid, 446, -1)
	end

	local x = getCreatureSpeed(cid)
	doFaceOpposite(cid)
	doChangeSpeed(cid, -x)
	addEvent(rebackSpd, 400, cid, x)
	setPlayerStorageValue(cid, 446, 1)
	doAreaCombatHealth(cid, WATERDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 68)

elseif spell == "Fire Fang" then

	local target = getMasterTarget(cid)

	doSendMagicEffect(getThingPositionWithDebug(getMasterTarget(cid)), 146)

		local function doBite(cid, target)
			if not isCreature(cid) or not isCreature(target) then return true end
		doAreaCombatHealth(cid, FIREDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 15)
		end

	addEvent(doBite, 200, cid, target)

elseif spell == "Psy Pulse" then

		doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 24)
		doAreaCombatHealthAtDistance(cid, PSYCHICDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 136)

elseif spell == "Ember" then

		doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 3)
		doAreaCombatHealthAtDistance(cid, FIREDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 15)

elseif spell == "Wing Attack" then

local damagearea = {}
local effectpos = getThingPositionWithDebug(cid)
local effect = 255
local a = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)

	if a == 0 then
		effect = 128
		effectpos.x = effectpos.x + 1
		effectpos.y = effectpos.y - 1
		damagearea = wingdn
	elseif a == 1 then
		effectpos.x = effectpos.x + 1
		effectpos.y = effectpos.y + 1
		effect = 129
		damagearea = wingde
	elseif a == 2 then
		effectpos.x = effectpos.x + 1
		effectpos.y = effectpos.y + 1
		effect = 131
		damagearea = wingds
	elseif a == 3 then
		effectpos.x = effectpos.x - 1
		effectpos.y = effectpos.y + 1
		effect = 130
		damagearea = wingdw
	end

		doSendMagicEffect(effectpos, effect)
		doAreaCombatHealth(cid, FLYINGDAMAGE, getThingPositionWithDebug(cid), damagearea, -min, -max, CONST_ME_NONE)

elseif spell == "Poisonous Wing" then

local damagearea = {}
local effectpos = getThingPositionWithDebug(cid)
local effect = 255
local a = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)

	if a == 0 then
		effect = 128
		effectpos.x = effectpos.x + 1
		effectpos.y = effectpos.y - 1
		damagearea = wingdn
	elseif a == 1 then
		effectpos.x = effectpos.x + 1
		effectpos.y = effectpos.y + 1
		effect = 129
		damagearea = wingde
	elseif a == 2 then
		effectpos.x = effectpos.x + 1
		effectpos.y = effectpos.y + 1
		effect = 131
		damagearea = wingds
	elseif a == 3 then
		effectpos.x = effectpos.x - 1
		effectpos.y = effectpos.y + 1
		effect = 130
		damagearea = wingdw
	end

		doSendMagicEffect(effectpos, effect)
		doAreaCombatHealth(cid, POISONDAMAGE, getThingPositionWithDebug(cid), damagearea, -min, -max, 114)

elseif spell == "Mud Bomb" then

		doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 38)

		local function doDamageWithDelay(cid, target)
		if not isCreature(cid) or not isCreature(target) then return true end
		doAreaCombatHealth(cid, GROUNDDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), bomb, -min, -max, 116)
		doAreaCombatHealth(cid, null, getThingPositionWithDebug(getMasterTarget(cid)), bomb, 0, 0, 34)

		if math.random(1, 100) >= 50 then
			local rounds = math.random(6, 10)
			rounds = rounds + math.floor(getPokemonLevel(cid) / 20)
			doAdvancedBlind(target, rounds, getPlayerStorageValue(target, 3890), 34)
		end
		end

		addEvent(doDamageWithDelay, getDistDelay, cid, target)

elseif spell == "Sonicboom" then

		doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 33)
		doAreaCombatHealthAtDistance(cid, NORMALDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 1)

elseif spell == "Flamethrower" then

local flamepos = getThingPositionWithDebug(cid)
local effect = 255
local a = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)

	if a == 0 then
		flamepos.x = flamepos.x+1
		flamepos.y = flamepos.y-1
		effect = 106
		doAreaCombatHealth(cid, FIREDAMAGE, getThingPositionWithDebug(cid), flamen, -min, -max, 255)
	elseif a == 1 then
		flamepos.x = flamepos.x+3
		flamepos.y = flamepos.y+1
		effect = 109
		doAreaCombatHealth(cid, FIREDAMAGE, getThingPositionWithDebug(cid), flamee, -min, -max, 255)
	elseif a == 2 then
		flamepos.x = flamepos.x+1
		flamepos.y = flamepos.y+3
		effect = 107
		doAreaCombatHealth(cid, FIREDAMAGE, getThingPositionWithDebug(cid), flames, -min, -max, 255)
	elseif a == 3 then
		flamepos.x = flamepos.x-1
		flamepos.y = flamepos.y+1
		effect = 108
		doAreaCombatHealth(cid, FIREDAMAGE, getThingPositionWithDebug(cid), flamew, -min, -max, 255)
	end

		doSendMagicEffect(flamepos, effect)

elseif spell == "Selfdestruct" then

		setPlayerStorageValue(cid, 33, 1)

		local function death(params)
			if isCreature(params.cid) then
			doCreatureAddHealth(params.cid, -getCreatureHealth(cid))
			end
		end

		doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(cid), destruct1, -min, -max, 5)
		addEvent(doAreaCombatHealth, 150, cid, NORMALDAMAGE, getThingPositionWithDebug(cid), destruct2, -(min*0.7), -(max*0.8), 5)
		addEvent(doAreaCombatHealth, 250, cid, NORMALDAMAGE, getThingPositionWithDebug(cid), destruct3, -(min*0.4), -(max*0.5), 5)
		addEvent(death, 250, {cid = cid})

elseif spell == "Drill Peck" then

		doAreaCombatHealth(cid, FLYDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 110)

		local hitalvo = getMasterTarget(cid)

		local function hit(cid, target)
			if isCreature(cid) and isCreature(target) then
				if getMasterTarget(cid) == target then
				doAreaCombatHealth(cid, FLYDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 110)
				end
			end
		end

		addEvent(hit, 480, cid, hitalvo)
		addEvent(hit, 880, cid, hitalvo)

elseif spell == "Dizzy Punch" then

		doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 26)
		doAreaCombatHealth(cid, FIGHTINGDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 3)
		local rounds = getPokemonLevel(cid) / 12
			rounds = rounds + 2
		doAdvancedConfuse(target, rounds, getPlayerStorageValue(target, 3891))

elseif spell == "Poison Gas" then

	local function gas(params)
		if not isCreature(params.cid) then return true end
		doAreaCombatHealth(params.cid, POISONDAMAGE, getThingPositionWithDebug(cid), bomb2, -min, -max, 114)
	end

	addEvent(gas, 000, {cid = cid, cb = cb})
	addEvent(gas, 500, {cid = cid, cb = cb})
	addEvent(gas, 1000, {cid = cid, cb = cb})
	addEvent(gas, 1500, {cid = cid, cb = cb})
	addEvent(gas, 2300, {cid = cid, cb = cb})
	addEvent(gas, 2800, {cid = cid, cb = cb})
	addEvent(gas, 3300, {cid = cid, cb = cb})
	addEvent(gas, 3800, {cid = cid, cb = cb})
	addEvent(gas, 4600, {cid = cid, cb = cb})
	addEvent(gas, 5100, {cid = cid, cb = cb})

elseif spell == "Twister" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 36)
	doAreaCombatHealthAtDistance(cid, DRAGONDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 42)

elseif spell == "Rock Tomb" then

local rock1 = {}
local rock2 = {}
local rock3 = {}
local a = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)

	if a == 0 then
		rock1 = {x=getThingPositionWithDebug(cid).x+1, y=getThingPositionWithDebug(cid).y-1, z=getThingPositionWithDebug(cid).z}
		rock2 = {x=getThingPositionWithDebug(cid).x+0, y=getThingPositionWithDebug(cid).y-1, z=getThingPositionWithDebug(cid).z}
		rock3 = {x=getThingPositionWithDebug(cid).x-1, y=getThingPositionWithDebug(cid).y-1, z=getThingPositionWithDebug(cid).z}
		doAreaCombatHealth(cid, ROCKDAMAGE, getThingPositionWithDebug(cid), tombn, -min, -max, 118)
	elseif a == 2 then
		rock1 = {x=getThingPositionWithDebug(cid).x+1, y=getThingPositionWithDebug(cid).y+1, z=getThingPositionWithDebug(cid).z}
		rock2 = {x=getThingPositionWithDebug(cid).x+0, y=getThingPositionWithDebug(cid).y+1, z=getThingPositionWithDebug(cid).z}
		rock3 = {x=getThingPositionWithDebug(cid).x-1, y=getThingPositionWithDebug(cid).y+1, z=getThingPositionWithDebug(cid).z}
		doAreaCombatHealth(cid, ROCKDAMAGE, getThingPositionWithDebug(cid), tombs, -min, -max, 118)
	elseif a == 3 then
		rock1 = {x=getThingPositionWithDebug(cid).x-1, y=getThingPositionWithDebug(cid).y+1, z=getThingPositionWithDebug(cid).z}
		rock2 = {x=getThingPositionWithDebug(cid).x-1, y=getThingPositionWithDebug(cid).y+0, z=getThingPositionWithDebug(cid).z}
		rock3 = {x=getThingPositionWithDebug(cid).x-1, y=getThingPositionWithDebug(cid).y-1, z=getThingPositionWithDebug(cid).z}
		doAreaCombatHealth(cid, ROCKDAMAGE, getThingPositionWithDebug(cid), tombw, -min, -max, 118)
	elseif a == 1 then
		rock1 = {x=getThingPositionWithDebug(cid).x+1, y=getThingPositionWithDebug(cid).y+1, z=getThingPositionWithDebug(cid).z}
		rock2 = {x=getThingPositionWithDebug(cid).x+1, y=getThingPositionWithDebug(cid).y+0, z=getThingPositionWithDebug(cid).z}
		rock3 = {x=getThingPositionWithDebug(cid).x+1, y=getThingPositionWithDebug(cid).y-1, z=getThingPositionWithDebug(cid).z}
		doAreaCombatHealth(cid, ROCKDAMAGE, getThingPositionWithDebug(cid), tombe, -min, -max, 118)
	end

	doSendDistanceShoot(getThingPositionWithDebug(cid), rock1, 11)
	doSendDistanceShoot(getThingPositionWithDebug(cid), rock2, 11)
	doSendDistanceShoot(getThingPositionWithDebug(cid), rock3, 11)

elseif spell == "Discharge" then

		local function discharge(cid, time)
			if not isCreature(cid) then
			return true
			end

			if time == 0 then
			doSendAnimatedText(getThingPositionWithDebug(cid), "CHARGING", 210)
			doSendMagicEffect(getThingPositionWithDebug(cid), 48)
			addEvent(discharge, 1000, cid, time + 1)
			return true
			end

			if math.random(1, 100) >= 78 then
			doCreatureSay(cid, "DISCHARGE!", TALKTYPE_MONSTER)
			doAreaCombatHealth(cid, ELECTRICDAMAGE, getThingPositionWithDebug(cid), charge, -(min*(time)), -(max*(time)), 48)
			else
				if time >= 6 then
				doSendAnimatedText(getThingPositionWithDebug(cid), "FAIL", 215)
				return true
				end

				doSendAnimatedText(getThingPositionWithDebug(cid), "CHARGING", 210)
				doSendMagicEffect(getThingPositionWithDebug(cid), 48)
				addEvent(discharge, 1000, cid, time + 1)
			return true
			end
			end

	discharge(cid, 0)

elseif spell == "Mega Prick" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 25)
	doAreaCombatHealthAtDistance(cid, BUGDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 3)
				
elseif spell == "Gunk Shot" then

	local target = getMasterTarget(cid)

	local function rocksdown(cid, target, pos)
		if not isCreature(cid) then return true end
		if not isCreature(target) then return true end

		doSendDistanceShoot(pos, getThingPositionWithDebug(target), 6)
		doAreaCombatHealth(cid, POISONDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), tresportres, -min, -max, 116)
	end

	local function rocksup(cid, target)
		if not isCreature(cid) or not isCreature(target) then return true end

		local posa = getThingPositionWithDebug(cid)
		local posb = getThingPositionWithDebug(target)
		local xx = 0
			if posb.x < posa.x then
			xx = -1
			end
		local posc = posa
		posc.x = posc.x + xx
		posc.y = posc.y - 3

		doSendDistanceShoot(getThingPositionWithDebug(cid), posc, 6)
	addEvent(rocksdown, 300, cid, target, posc)
	end
	
	rocksup(cid, target)

elseif spell == "Tornado" then

	local pos = getThingPositionWithDebug(cid)

	local function tornado(cid, area, effect, type)
	if not isCreature(cid) then return true end
	doAreaCombatHealth(cid, type, pos, area, -min, -max, effect)
	end

		addEvent(tornado, 0, cid, tor1, CONST_ME_POFF, null)
		addEvent(tornado, 200, cid, tor1, 42, FLYDAMAGE)
		addEvent(tornado, 500, cid, tor2, CONST_ME_POFF, null)
		addEvent(tornado, 700, cid, tor2, 42, FLYDAMAGE)
		addEvent(tornado, 1000, cid, tor3, CONST_ME_POFF, null)
		addEvent(tornado, 1200, cid, tor3, 42, FLYDAMAGE)
		addEvent(tornado, 750, cid, tor1, CONST_ME_POFF, null)
		addEvent(tornado, 1250, cid, tor2, CONST_ME_POFF, null)
		addEvent(tornado, 1550, cid, tor3, CONST_ME_POFF, null)

elseif spell == "Psybeam" then

	local a = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid), true) or getCreatureLookDir(cid)

	if a == 0 then
		doAreaCombatHealth(cid, PSYDAMAGE, getThingPositionWithDebug(cid), bmn, -min, -max, 57)
	elseif a == 2 then
		doAreaCombatHealth(cid, PSYDAMAGE, getThingPositionWithDebug(cid), bms, -min, -max, 58)
	elseif a == 1 then
		doAreaCombatHealth(cid, PSYDAMAGE, getThingPositionWithDebug(cid), bme, -min, -max, 234)
	elseif a == 3 then
		doAreaCombatHealth(cid, PSYDAMAGE, getThingPositionWithDebug(cid), bmw, -min, -max, 209)
	end

elseif spell == "Leaf Storm" or tonumber(spell) == 73 then

	doAreaCombatHealth(cid, GRASSDAMAGE, getThingPositionWithDebug(cid), grassarea, -min, -max, 255)

	local pos = getThingPositionWithDebug(cid)

	local function doSendLeafStorm(cid, pos)
		if not isCreature(cid) then return true end
	doSendDistanceShoot(getThingPositionWithDebug(cid), pos, 8)
	end

	for a = 1, 250 do
		local lugar = {x = pos.x + math.random(-9, 9), y = pos.y + math.random(-8, 8), z = pos.z}
		addEvent(doSendLeafStorm, a * 2, cid, lugar)
	end

elseif spell == "Ranging Blast" then

	doAreaCombatHealth(cid, FIREDAMAGE, getThingPositionWithDebug(cid), rageblast1, -min, -max, 6)

	local function damage(cid, area)
		if not isCreature(cid) then return true end
	doAreaCombatHealth(cid, FIREDAMAGE, getThingPositionWithDebug(cid), area, -min, -max, 6)
	end

	addEvent(damage, 200, cid, rageblast2)
	addEvent(damage, 400, cid, rageblast3)
	addEvent(damage, 600, cid, rageblast4)
	addEvent(damage, 800, cid, rageblast5)

elseif spell == "Tri Attack" or spell == "Tri-attack" then

	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 226)

elseif spell == "Petal Dance" or tonumber(spell) == 76 then

doAreaCombatHealth(cid, GRASSDAMAGE, getThingPositionWithDebug(cid), grassarea, -min, -max, 255)

	local lugar = getThingPositionWithDebug(cid)
		for x= -7,7 do
			for y= -6,6 do
			local topos = {x=lugar.x+x, y=lugar.y+y, z=lugar.z}
			doSendDistanceShoot(getThingPositionWithDebug(cid), topos, 21)
			end
		end

elseif spell == "Dragon Pulse" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 24)
	doAreaCombatHealthAtDistance(cid, DRAGONDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 136)

elseif spell == "Zap Cannon" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 34)
	doAreaCombatHealthAtDistance(cid, ELECTRICDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), zap, -min, -max, 11)

elseif spell == "Charge Beam" then

	for pa = -2, 2 do
		for pb = -2, 2 do
			local pos = getThingPositionWithDebug(cid)
			pos.x = pos.x+pa
			pos.y = pos.y+pb
			doSendDistanceShoot(pos, getThingPositionWithDebug(cid), 40)
		end
	end
		local function dmgbeam(cid)
		if not isCreature(cid) then return true end
		local a = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)
			if a == 0 then
				doAreaCombatHealth(cid, ELECTRICDAMAGE, getThingPositionWithDebug(cid), beamn, -min, -max, 48)
			elseif a == 1 then
				doAreaCombatHealth(cid, ELECTRICDAMAGE, getThingPositionWithDebug(cid), beame, -min, -max, 48)
			elseif a == 2 then
				doAreaCombatHealth(cid, ELECTRICDAMAGE, getThingPositionWithDebug(cid), beams, -min, -max, 48)
			elseif a == 3 then
				doAreaCombatHealth(cid, ELECTRICDAMAGE, getThingPositionWithDebug(cid), beamw, -min, -max, 48)
			end
		end

		addEvent(dmgbeam, 700, cid)

elseif spell == "Slime Wave" then

	local function slime(cid, area)
		if not isCreature(cid) then return true end
		doAreaCombatHealth(cid, POISONDAMAGE, area, wave, -min, -max, 116)
		doAreaCombatHealth(cid, null, area, wave, -min, -max, 114)
	end

	local a = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)
	local posicao = getThingPositionWithDebug(cid)

	if a == 0 then
		addEvent(slime, 0, cid, {x=posicao.x, y=posicao.y-1, z=posicao.z})
		addEvent(slime, 150, cid, {x=posicao.x, y=posicao.y-2, z=posicao.z})
		addEvent(slime, 300, cid, {x=posicao.x, y=posicao.y-3, z=posicao.z})
		addEvent(slime, 450, cid, {x=posicao.x, y=posicao.y-4, z=posicao.z})
	elseif a == 1 then
		addEvent(slime, 0, cid, {x=posicao.x+1, y=posicao.y, z=posicao.z})
		addEvent(slime, 150, cid, {x=posicao.x+2, y=posicao.y, z=posicao.z})
		addEvent(slime, 300, cid, {x=posicao.x+3, y=posicao.y, z=posicao.z})
		addEvent(slime, 450, cid, {x=posicao.x+4, y=posicao.y, z=posicao.z})
	elseif a == 2 then
		addEvent(slime, 0, cid, {x=posicao.x, y=posicao.y+1, z=posicao.z})
		addEvent(slime, 150, cid, {x=posicao.x, y=posicao.y+2, z=posicao.z})
		addEvent(slime, 300, cid, {x=posicao.x, y=posicao.y+3, z=posicao.z})
		addEvent(slime, 450, cid, {x=posicao.x, y=posicao.y+4, z=posicao.z})
	elseif a == 3 then
		addEvent(slime, 0, cid, {x=posicao.x-1, y=posicao.y, z=posicao.z})
		addEvent(slime, 150, cid, {x=posicao.x-2, y=posicao.y, z=posicao.z})
		addEvent(slime, 300, cid, {x=posicao.x-3, y=posicao.y, z=posicao.z})
		addEvent(slime, 450, cid, {x=posicao.x-4, y=posicao.y, z=posicao.z})
	end

elseif spell == "Earthshock" then

	doAreaCombatHealth(cid, GROUNDDAMAGE, getThingPositionWithDebug(cid), eshock, -min, -max, 255)

	local sps = getThingPositionWithDebug(cid)
	sps.x = sps.x+1
	sps.y = sps.y+1
	doSendMagicEffect(sps, 127)

elseif spell == "Solar Beam" then

	local function useSolarBeam(cid)
		if not isCreature(cid) then
		return true
		end
		if isSleeping(cid) then
		return true
		end
			local effect1 = 255
			local effect2 = 255
			local effect3 = 255
			local effect4 = 255
			local effect5 = 255
			local area = {}
			local pos1 = getThingPositionWithDebug(cid)
			local pos2 = getThingPositionWithDebug(cid)
			local pos3 = getThingPositionWithDebug(cid)
			local pos4 = getThingPositionWithDebug(cid)
			local pos5 = getThingPositionWithDebug(cid)
		if getCreatureLookDir(cid) == 1 then
			effect1 = 4
			effect2 = 10
			effect3 = 10
			effect4 = 10
			effect5 = 26
			pos1.x = pos1.x + 2
			pos1.y = pos1.y + 1
			pos2.x = pos2.x + 3
			pos2.y = pos2.y + 1
			pos3.x = pos3.x + 4
			pos3.y = pos3.y + 1
			pos4.x = pos4.x + 5
			pos4.y = pos4.y + 1
			pos5.x = pos5.x + 6
			pos5.y = pos5.y + 1
			area = solare
		elseif getCreatureLookDir(cid) == 0 then
			effect1 = 36
			effect2 = 37
			effect3 = 37
			effect4 = 38
			pos1.x = pos1.x + 1
			pos1.y = pos1.y - 1
			pos2.x = pos2.x + 1
			pos2.y = pos2.y - 3
			pos3.x = pos3.x + 1
			pos3.y = pos3.y - 4
			pos4.x = pos4.x + 1
			pos4.y = pos4.y - 5
			area = solarn
		elseif getCreatureLookDir(cid) == 2 then
			effect1 = 46
			effect2 = 50
			effect3 = 50
			effect4 = 59
			pos1.x = pos1.x + 1
			pos1.y = pos1.y + 2
			pos2.x = pos2.x + 1
			pos2.y = pos2.y + 3
			pos3.x = pos3.x + 1
			pos3.y = pos3.y + 4
			pos4.x = pos4.x + 1
			pos4.y = pos4.y + 5
			area = solars
		elseif getCreatureLookDir(cid) == 3 then
			effect1 = 115
			effect2 = 162
			effect3 = 162
			effect4 = 162
			effect5 = 163
			pos1.x = pos1.x - 1
			pos1.y = pos1.y + 1
			pos2.x = pos2.x - 3
			pos2.y = pos2.y + 1
			pos3.x = pos3.x - 4
			pos3.y = pos3.y + 1
			pos4.x = pos4.x - 5
			pos4.y = pos4.y + 1
			pos5.x = pos5.x - 6
			pos5.y = pos5.y + 1
			area = solarw
		end

		if effect1 ~= 255 then
			doSendMagicEffect(pos1, effect1)
		end
		if effect2 ~= 255 then
			doSendMagicEffect(pos2, effect2)
		end
		if effect3 ~= 255 then
			doSendMagicEffect(pos3, effect3)
		end
		if effect4 ~= 255 then
			doSendMagicEffect(pos4, effect4)
		end
		if effect5 ~= 255 then
			doSendMagicEffect(pos5, effect5)
		end
	
		doAreaCombatHealth(cid, GRASSDAMAGE, getThingPositionWithDebug(cid), area, -min, -max, 255)	
		doRegainSpeed(cid)
	end

	local function ChargingBeam(cid)
		if not isCreature(cid) then
		return true
		end
		if isSleeping(cid) then
		return true
		end
		local tab = {}

		for x = -2, 2 do
			for y = -2, 2 do
				local pos = getThingPositionWithDebug(cid)
				pos.x = pos.x + x
				pos.y = pos.y + y
					if pos.x ~= getThingPositionWithDebug(cid).x and pos.y ~= getThingPositionWithDebug(cid).y then
					table.insert(tab, pos)
					end
			end
		end
	doSendDistanceShoot(tab[math.random(#tab)], getThingPositionWithDebug(cid), 37)
	end

doChangeSpeed(cid, -getCreatureSpeed(cid))

for r = 1, 270 do
	addEvent(ChargingBeam, r*9, cid)
end

addEvent(useSolarBeam, 2800, cid)

elseif spell == "Sleep Powder" then

	local calc = math.floor(getPokemonLevel(cid) / 20)
	local v1 = 6
	local v2 = v1 + calc
	doAreaCombatHealth(cid, SLEEP_POWDERDAMAGE, getThingPositionWithDebug(cid), powders, -v1, -v2, 27)

elseif spell == "Stun Spore" then

	local area = powders

	doAreaCombatCondition(cid, getThingPositionWithDebug(cid), area, stunsporecondition, 85)

elseif spell == "Poison Powder" then

	local v1 = (10 + getPokemonLevel(cid)) * 2
		setPlayerStorageValue(cid, 919231, v1)
	local v3 = getPokemonLevel(cid) / 10 + 5

	doAreaCombatHealth(cid, POISON_POWDERDAMAGE, getThingPositionWithDebug(cid), powders, -v3, -v3, 84)

elseif spell == "Body Slam" then
	
	doBodyPush(cid, target, true)
	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 3)

elseif spell == "Bullet Seed" then

	local function doShootBulletSeed(cid, target, shoot, effect)
		if not isCreature(cid) or not isCreature(target) then return true end
		if getCreatureHealth(target) <= 0 then return true end
		if shoot then
		doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(target), 1)
		end
		if effect then
		doSendMagicEffect(getThingPositionWithDebug(target), effect)
		end

		doAreaCombatHealth(cid, GRASSDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 3)
	end

	for a = 1, 9 do
		if a == 3 or a == 6 or a == 9 then
			addEvent(doShootBulletSeed, a * 65, cid, getMasterTarget(cid), true, 45)
		else
			addEvent(doShootBulletSeed, a * 65, cid, getMasterTarget(cid), true, 3)
		end
	end


elseif spell == "Fire Spin" then

	local function sendFireEff(cid, dir)
		if not isCreature(cid) then return true end
		doAreaCombatHealth(cid, FIREDAMAGE, getPosByDir(getThingPositionWithDebug(cid), dir), 0, -min, -max, 15)
	end

	local function doSpinFire(cid)
		if not isCreature(cid) then return true end
		local t = {
			[1] = SOUTHWEST,
			[2] = SOUTH,
			[3] = SOUTHEAST,
			[4] = EAST,
			[5] = NORTHEAST,
			[6] = NORTH,
			[7] = NORTHWEST,
			[8] = WEST,
			[17] = SOUTHWEST,
			}
		for a = 1, 17 do
			if not t[a] then
			addEvent(sendFireEff, a * 140, cid, t[a-8])
			else
			addEvent(sendFireEff, a * 140, cid, t[a])
			end
		end
	end

	doSpinFire(cid, false, cid)

elseif spell == "Burning Skin" then

	local function doBurnSkin(cid)
		if not isCreature(cid) then return true end
		doSendMagicEffect(getThingPositionWithDebug(cid), 15)
		for a = 0, 7 do
			local pos = getPosByDir(getThingPositionWithDebug(cid), a)
			local man = getThingFromPos({x=pos.x,y=pos.y,z=pos.z,stackpos=253}).uid
			if isCreature(man) and isMonster(man) then
				doAreaCombatHealth(cid, FIREDAMAGE, pos, 0, -min, -max, 15)
			end
		end
	end

	for b = 1, 10 do
		addEvent(doBurnSkin, b * 650, cid)
	end

elseif spell == "Fire Blast" then

	local posicao = getThingPositionWithDebug(cid)

	local function fireBlast(cid, area1, area2, effect, area3)
		if not isCreature(cid) then return true end
		if not isSightClear(posicao, area1, false) then return true end
		doAreaCombatHealth(cid, null, area1, 0, -min, -max, effect)
			if area2.x ~= getThingPositionWithDebug(cid).x or area2.y ~= getThingPositionWithDebug(cid).y then
				doAreaCombatHealth(cid, null, area2, area3, -min, -max, 35)
			end
		doAreaCombatHealth(cid, FIREDAMAGE, area1, area3, -min, -max, 35)
	end

	local m = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)

	if m == 0 then
		for a = 0, 5 do
			addEvent(fireBlast, 300 * a, cid, {x = posicao.x, y = posicao.y - (a + 1), z = posicao.z}, {x = posicao.x, y = posicao.y - a, z = posicao.z}, 60, whirl3)
		end
	elseif m == 2 then
		for a = 0, 5 do
			addEvent(fireBlast, 300 * a, cid, {x = posicao.x, y = posicao.y + (a + 1), z = posicao.z}, {x = posicao.x, y = posicao.y + a, z = posicao.z}, 62, whirl3)
		end
	elseif m == 1 then
		for a = 0, 5 do
			addEvent(fireBlast, 300 * a, cid, {x = posicao.x + a + 1, y = posicao.y, z = posicao.z}, {x = posicao.x + a, y = posicao.y, z = posicao.z}, 61, whirl3)
		end
	elseif m == 3 then
		for a = 0, 5 do
			addEvent(fireBlast, 300 * a, cid, {x = posicao.x - (a + 1), y = posicao.y, z = posicao.z}, {x = posicao.x - a, y = posicao.y, z = posicao.z}, 63, whirl3)
		end
	end

elseif spell == "Bubble Blast" then

	local pos = getThingPositionWithDebug(cid)

	local function doSendBubble(cid, pos)
		if not isCreature(cid) then return true end
		doSendDistanceShoot(getThingPositionWithDebug(cid), pos, 2)
		doSendMagicEffect(pos, 53)
		doAreaCombatHealth(cid, WATERDAMAGE, pos, 0, -min, -max, 1)
	end

	for b = 1, 3 do
		for a = 1, 20 do
			local lugar = {x = pos.x + math.random(-4, 4), y = pos.y + math.random(-3, 3), z = pos.z}
			addEvent(doSendBubble, a * 75, cid, lugar)
		end
	end


elseif spell == "Jet Cannons" then

	local function doWaterGun(cid, pos, effectlist, arealist)
		if not isCreature(cid) then return true end
		doAreaCombatHealth(cid, WATERDAMAGE, pos, arealist[1], -min, -max, effectlist[1])
		doAreaCombatHealth(cid, WATERDAMAGE, pos, arealist[2], -min, -max, effectlist[2])
		doAreaCombatHealth(cid, WATERDAMAGE, pos, arealist[3], -min, -max, effectlist[3])
	end

	local pos = getThingPositionWithDebug(cid)
	local a = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)

	if a == 0 then

		local list = {74, 75, 76}
		local lisx = {jg1n, jg2n, jg3n}
		doWaterGun(cid, pos, list, lisx)

	elseif a == 2 then

		local list = {77, 75, 78}
		local lisx = {jg1s, jg2s, jg3s}
		doWaterGun(cid, pos, list, lisx)

	elseif a == 1 then

		local list = {69, 70, 71}
		local lisx = {jg1e, jg2e, jg3e}
		doWaterGun(cid, pos, list, lisx)

	elseif a == 3 then

		local list = {72, 70, 73}
		local lisx = {jg1w, jg2w, jg3w}
		doWaterGun(cid, pos, list, lisx)
	end

elseif spell == "Surf" then

	local posicao = getThingPositionWithDebug(cid)

	local function doSurf(cid, area1, area2, effect)
		if not isCreature(cid) then return true end
		if not isSightClear(posicao, area1, false) then return true end
		doAreaCombatHealth(cid, null, area1, whirl3, -min, -max, effect)
			if area2.x ~= getThingPositionWithDebug(cid).x or area2.y ~= getThingPositionWithDebug(cid).y then
				doAreaCombatHealth(cid, null, area2, whirl3, -min, -max, 68)
			end
		doAreaCombatHealth(cid, WATERDAMAGE, area1, whirl3, -min, -max, 68)
	end

	local n = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)

	if n == 0 then
		for a = 0, 5 do
			addEvent(doSurf, 300 * a, cid, {x = posicao.x, y = posicao.y - (a + 1), z = posicao.z}, {x = posicao.x, y = posicao.y - a, z = posicao.z}, 66)
		end
	elseif n == 2 then
		for a = 0, 5 do
			addEvent(doSurf, 300 * a, cid, {x = posicao.x, y = posicao.y + (a + 1), z = posicao.z}, {x = posicao.x, y = posicao.y + a, z = posicao.z}, 64)
		end
	elseif n == 1 then
		for a = 0, 5 do
			addEvent(doSurf, 300 * a, cid, {x = posicao.x + a + 1, y = posicao.y, z = posicao.z}, {x = posicao.x + a, y = posicao.y, z = posicao.z}, 67)
		end
	elseif n == 3 then
		for a = 0, 5 do
			addEvent(doSurf, 300 * a, cid, {x = posicao.x - (a + 1), y = posicao.y, z = posicao.z}, {x = posicao.x - a, y = posicao.y, z = posicao.z}, 65)
		end
	end

elseif spell == "Hydro Pump" then

	local function doUpdateHydroPumpPos(cid, pos)
		if isCreature(cid) then
		return getThingPositionWithDebug(cid)
		else
		return pos
		end
	end
		

	local function doSendHydroPump(pos, base)
	if base then
	doSendMagicEffect(pos, 53)
	end
		local topos = {x = pos.x, y = pos.y, z = pos.z}
		topos.x = topos.x + math.random(-1, 1)
		local random = math.random(-6, -4)
		topos.y = topos.y + random
	doSendDistanceShoot(pos, topos, 2)
	addEvent(doSendMagicEffect, math.abs(random) * 50, topos, 1)
	end

	local target = getMasterTarget(cid)
	local pos = getThingPositionWithDebug(target)

	for a = 1, 18 do
		local backup = pos
		pos = doUpdateHydroPumpPos(target, backup)
		if a == 3 or a == 6 or a == 9 or a == 12 or a == 15 or a == 18 then
			addEvent(doSendHydroPump, a * 55, pos, true)
		else
			addEvent(doSendHydroPump, a * 55, pos, false)
		end
	end

	doAreaCombatHealth(cid, WATERDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 255)

elseif spell == "Skull Bash" then

	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 118)

elseif spell == "Sing" then

	doAreaCombatHealth(cid, SLEEP_POWDERDAMAGE, getThingPositionWithDebug(cid), powders, -6, -10, 33)
	local pos = getThingPositionWithDebug(cid)

	local function doSing(cid, effect, pos)
		if not isCreature(cid) then return true end
		doAreaCombatHealth(cid, null, pos, powders, 0, 0, effect)
	end

elseif spell == "Invisible" or spell == "GhostInvisible" then

	if getPokemonLevel(cid) <= 40 then
		doCreatureAddCondition(cid, weakinvisible)
	else
		doCreatureAddCondition(cid, stronginvisible)
	end
		doSendMagicEffect(getThingPositionWithDebug(cid), 134)

elseif spell == "Mach Punch" then

	doSendMagicEffect(getThingPositionWithDebug(cid), 211)
	local x = getClosestFreeTile(cid, getThingPositionWithDebug(getMasterTarget(cid)))
	doTeleportThing(cid, x, false)
	doFaceCreature(cid, getThingPositionWithDebug(getMasterTarget(cid)))
	doAreaCombatHealth(cid, FIGHTDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 112)

elseif spell == "Hypnosis" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 24)
	doAreaCombatHealthAtDistance(cid, SLEEP_POWDERDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -5, -9, 255)

elseif spell == "Extreme Speed" or tonumber(spell) == 102 then

	doCreatureAddCondition(cid, permanentinvisible)
	local x = getCreatureSpeed(cid)
	local target = getMasterTarget(cid)
	doChangeSpeed(cid, -x)
	doSendMagicEffect(getThingPositionWithDebug(cid), 211)

		local function doFinishExtremeSpeed(cid, target, x)
			if not isCreature(cid) then return true end
			if not isCreature(target) then doRemoveCondition(cid, CONDITION_INVISIBLE) return true end
			doTeleportThing(cid, getClosestFreeTile(cid, getThingPositionWithDebug(target)), false)
			doRemoveCondition(cid, CONDITION_INVISIBLE)
			doSendMagicEffect(getThingPositionWithDebug(cid), 211)
			doFaceCreature(cid, getThingPositionWithDebug(target))
			doChangeSpeed(cid, x)
			doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 3)
		end

		local function doExtremeSpeed(cid, target, x)
			if not isCreature(cid) then return true end
			if not isCreature(target) then
			doRemoveCondition(cid, CONDITION_INVISIBLE)
			doChangeSpeed(cid, x)
			doSendMagicEffect(getThingPositionWithDebug(cid), 211)
			return true
			end
			if getDistanceBetween(getThingPositionWithDebug(cid), getThingPositionWithDebug(target)) <= 1 then
				doSendMagicEffect(getPosByDir(getThingPositionWithDebug(target), math.random(0, 7)), 211)
			else
				local dir = getDirectionTo(getThingPositionWithDebug(cid), getThingPositionWithDebug(target))
				doSendMagicEffect(getPosByDir(getThingPositionWithDebug(cid), dir), 211)
				doTeleportThing(cid, getPosByDir(getThingPositionWithDebug(cid), dir), false)
			end
		end

	for a = 1, 6 do
		addEvent(doExtremeSpeed, 60 * a, cid, target, x)
	end
		addEvent(doFinishExtremeSpeed, 60 * 6, cid, target, x)	
	
elseif spell == "Zen Headbutt" then

	doSendMagicEffect(getThingPositionWithDebug(getMasterTarget(cid)), 136)
	doAreaCombatHealth(cid, PSYDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 3)

elseif spell == "Mega Kick" or spell == "Low Kick" then

	doAreaCombatHealth(cid, FIGHTINGDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 113)

elseif spell == "Double Punch" then

	local target = getMasterTarget(cid)

	local function doPunch(cid, target)
		if isCreature(cid) and isCreature(target) then
		doAreaCombatHealth(cid, FIGHTDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 112)
		end
	end

	addEvent(doPunch, 0, cid, target)
	addEvent(doPunch, 600, cid, target)

elseif spell == "Triple Punch" then

	local target = getMasterTarget(cid)

	local function doPunch(cid, target)
		if isCreature(cid) and isCreature(target) then
		doAreaCombatHealth(cid, FIGHTDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 112)
		end
	end

	addEvent(doPunch, 0, cid, target)
	addEvent(doPunch, 600, cid, target)
	addEvent(doPunch, 1200, cid, target)

elseif spell == "Double Kick" then

	local target = getMasterTarget(cid)

	local function doKick(cid, target)
		if isCreature(cid) and isCreature(target) then
		doAreaCombatHealth(cid, FIGHTDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 113)
		end
	end

	addEvent(doKick, 0, cid, target)
	addEvent(doKick, 600, cid, target)

elseif spell == "Triple Kick" then

	local target = getMasterTarget(cid)

	local function doKick(cid, target)
		if isCreature(cid) and isCreature(target) then
		doAreaCombatHealth(cid, FIGHTDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 113)
		end
	end

	addEvent(doKick, 0, cid, target)
	addEvent(doKick, 600, cid, target)
	addEvent(doKick, 1200, cid, target)

elseif spell == "Hi Jump Kick" then

	doSendMagicEffect(getThingPositionWithDebug(cid), 211)
	local x = getClosestFreeTile(cid, getThingPositionWithDebug(getMasterTarget(cid)))
	doTeleportThing(cid, x, false)
	doFaceCreature(cid, getThingPositionWithDebug(getMasterTarget(cid)))
	doAreaCombatHealth(cid, FIGHTDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 113)

elseif spell == "Focus Punch" then

	local function doFocusPunch(cid)
		if not isCreature(cid) then return true end
		doSendMagicEffect(getThingPositionWithDebug(cid), 247)
	end

	local function useFocusPunch(cid, target)
		if not isCreature(cid) or not isCreature(target) then return true end
		doAreaCombatHealth(cid, FIGHTDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 249)
	end

	local target = getMasterTarget(cid)

	for a = 1, 8 do
		addEvent(doFocusPunch, a * 160, cid)
	end
		addEvent(useFocusPunch, 160 * 8 + 1000, cid, target)

elseif spell == "Omnikick" then

	doCreatureAddCondition(cid, permanentinvisible)
	doSendMagicEffect(getThingPositionWithDebug(cid), 211)

	local t = {NORTHWEST, NORTHEAST, SOUTHWEST, SOUTHEAST, SOUTH, WEST, EAST, NORTH}

	local function doRandomDK(cid, target, t, damage)
		if not isCreature(cid) or not isCreature(target) then return true end
			local a = t[math.random(1, 8)]
			local pos = getPosByDir(getThingPositionWithDebug(target), a)
		doSendMagicEffect(pos, 211)
		doSendDistanceShoot(pos, getThingPositionWithDebug(target), 19)
	if damage then
		doTeleportThing(cid, pos, false)
		doFaceCreature(cid, getThingPositionWithDebug(target))
		doAreaCombatHealth(cid, FIGHTDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 3)
	end
	end

	local target = getMasterTarget(cid)

	local function doEndDK(cid)
		if not isCreature(cid) then return true end
		doRemoveCondition(cid, CONDITION_INVISIBLE)
		doSendMagicEffect(getThingPositionWithDebug(cid), 211)
	end

	for a = 1, 24 do
		if a == 8 or a == 16 or a == 24 then
			addEvent(doRandomDK, a * 75, cid, target, t, true)
		else
			addEvent(doRandomDK, a * 75, cid, target, t, false)
		end
	end

		addEvent(doEndDK, 24 * 75, cid)

elseif spell == "Crunch" then

	doAreaCombatHealth(cid, DARKDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 138)

elseif spell == "Thunder Fang" then

	local target = getMasterTarget(cid)

	doSendMagicEffect(getThingPositionWithDebug(getMasterTarget(cid)), 146)

		local function doBite(cid, target)
			if not isCreature(cid) or not isCreature(target) then return true end
		doAreaCombatHealth(cid, ELECTRICDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 48)
		end

	addEvent(doBite, 200, cid, target)

elseif spell == "Poison Fang" then

	local target = getMasterTarget(cid)

	doSendMagicEffect(getThingPositionWithDebug(getMasterTarget(cid)), 146)

		local function doBite(cid, target)
			if not isCreature(cid) or not isCreature(target) then return true end
		doAreaCombatHealth(cid, POISONDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 114)
		end

	addEvent(doBite, 200, cid, target)

elseif spell == "Ice Fang" then

	local target = getMasterTarget(cid)

	doSendMagicEffect(getThingPositionWithDebug(getMasterTarget(cid)), 146)

		local function doBite(cid, target)
			if not isCreature(cid) or not isCreature(target) then return true end
		doAreaCombatHealth(cid, ICEDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 43)
		end

	addEvent(doBite, 200, cid, target)

elseif spell == "Aqua Jet" then

	for a = -7, 7 do
		for b = -6, 6 do
		local pos = getThingPositionWithDebug(cid)
		local place = {x=pos.x+a,y=pos.y+b,z=pos.z}
		doSendDistanceShoot(getThingPositionWithDebug(cid), place, 2)
		end
	end

	doAreaCombatHealth(cid, WATERDAMAGE, getThingPositionWithDebug(cid), grassarea, -min, -max, 255)


elseif spell == "Hyper Cut" then

	local target = getMasterTarget(cid)
	local apos = getThingPositionWithDebug(target)
	local bpos = getThingPositionWithDebug(cid)

		local function doCut(cid, pos)
			if not isCreature(cid) then doSendMagicEffect(pos, 160) return true end
		doAreaCombatHealth(cid, NORMALDAMAGE, pos, 0, -min, -max, 160)
		end

	local t = {
	[1] = {x = apos.x + 1, y = apos.y - 1, z = apos.z},
	[2] = {x = apos.x - 1, y = apos.y + 1, z = apos.z},
	[3] = {x = apos.x - 1, y = apos.y - 1, z = apos.z},
	[4] = {x = apos.x + 1, y = apos.y + 1, z = apos.z}}

	local delay = 0

	if (bpos.x == apos.x + 1 and bpos.y == apos.y + 1) or (bpos.x == apos.x - 1 and bpos.y == apos.y - 1) then
		doCut(cid, t[1])
		addEvent(doCut, 200, cid, apos)
		addEvent(doCut, 400, cid, t[2])
	else
		doCut(cid, t[3])
		addEvent(doCut, 200, cid, apos)
		addEvent(doCut, 400, cid, t[4])
	end		

elseif spell == "Psyshock" then

	local a = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid), true) or getCreatureLookDir(cid)

	if a == 0 then
		doAreaCombatHealth(cid, PSYDAMAGE, getThingPositionWithDebug(cid), tsn, -min, -max, 47)
	elseif a == 1 then
		doAreaCombatHealth(cid, PSYDAMAGE, getThingPositionWithDebug(cid), tse, -min, -max, 47)
	elseif a == 2 then
		doAreaCombatHealth(cid, PSYDAMAGE, getThingPositionWithDebug(cid), tss, -min, -max, 47)
	elseif a == 3 then
		doAreaCombatHealth(cid, PSYDAMAGE, getThingPositionWithDebug(cid), tsw, -min, -max, 47)
	end

elseif spell == "Psywave" then

	local mydir = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid), true) or getCreatureLookDir(cid)

	if mydir == 0 then
		doAreaCombatHealth(cid, PSYDAMAGE, getThingPositionWithDebug(cid), tsn, -min, -max, 136)
	elseif mydir == 1 then
		doAreaCombatHealth(cid, PSYDAMAGE, getThingPositionWithDebug(cid), tse, -min, -max, 136)
	elseif mydir == 2 then
		doAreaCombatHealth(cid, PSYDAMAGE, getThingPositionWithDebug(cid), tss, -min, -max, 136)
	elseif mydir == 3 then
		doAreaCombatHealth(cid, PSYDAMAGE, getThingPositionWithDebug(cid), tsw, -min, -max, 136)
	end

elseif spell == "Mega Drain" then

	local life = getCreatureHealth(getMasterTarget(cid))

	doAreaCombatHealth(cid, GRASSDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 14)

	local newlife = (life - getCreatureHealth(getMasterTarget(cid)))

	doSendMagicEffect(getThingPositionWithDebug(cid), 239)
	if newlife >= 1 then
	doCreatureAddHealth(cid, newlife)
	doSendAnimatedText(getThingPositionWithDebug(cid), "+"..newlife.."", 35)
	end

elseif spell == "Multislap" then

	local slapalvo = getMasterTarget(cid)
	local random = math.random(1, 4)

	local function doSlap(cid, target)
		if isCreature(cid) and isCreature(target) then
		doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 148)
		end
	end

	local function doSayTimes(cid, target, time, say)
		if not isCreature(cid) then return true end
		if not isCreature(target) or say then
		doSendAnimatedText(getThingPositionWithDebug(cid), ""..time.." SLAPS", 215)
		return true
		end
	end
			

	for a = 0, random do
		if a == random then
			addEvent(doSayTimes, a * 700, cid, slapalvo, a + 1, true)
		else
			addEvent(doSayTimes, a * 700, cid, slapalvo, a + 1, false)
		end
		addEvent(doSlap, a * 700, cid, slapalvo)
	end

elseif spell == "Disable" then

	local function doEnable(cid, what)
		if not isCreature(cid) then return true end
		local a = getPlayerStorageValue(cid, 6)
		if a ~= what then return true end
		if getPlayerStorageValue(cid, 6) <= 0 then
			doSendAnimatedText(getThingPositionWithDebug(cid), "ENABLED", COLOR_GRASS)
		return true
		end
		setPlayerStorageValue(cid, 6, a - 1)
		doSendMagicEffect(getThingPositionWithDebug(cid), 13)
		addEvent(doEnable, 500, cid, what - 1)
	end


	local target = getMasterTarget(cid)

	if isPlayer(target) then return true end

	doSendMagicEffect(getThingPositionWithDebug(target), 13)
	local time = math.random(6, 12) + math.floor(getPokemonLevel(cid) / 7.5)

	if getPlayerStorageValue(target, 6) > 0 then
		setPlayerStorageValue(target, 6, getPlayerStorageValue(target, 6) + time)
		local b = getPlayerStorageValue(target, 6)
		doEnable(target, b)
		return true
	end

	doSendAnimatedText(getThingPositionWithDebug(target), "DISABLED", 152)
	setPlayerStorageValue(target, 6, time)
	local b = getPlayerStorageValue(target, 6)
	doEnable(target, b)
	

elseif spell == "Reversal" then

	local health = math.floor(getCreatureHealth(cid) / getCreatureMaxHealth(cid) * 100)
	local increase = (100 - health) * 0.03
	local rate = 1 + increase

	doAreaCombatHealth(cid, FIGHTDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min * rate, -max * rate, 231)

elseif spell == "Demon Kicker" then

	local sp = getCreatureSpeed(cid)
	doChangeSpeed(cid, -sp)
	local b = getMasterTarget(cid)
	local pos = getThingPositionWithDebug(b)

	local function doShootKick(cid, pos, speed)
		if not isCreature(cid) then return true end
		doSendDistanceShoot(getThingPositionWithDebug(cid), pos, 19)
		if speed > 0 then
		doChangeSpeed(cid, speed)
		end
	end

	for a = 0, 45 do
		if a == 30 then
			addEvent(doShootKick, a * 10, cid, pos, sp)
		else
			addEvent(doShootKick, a * 10, cid, pos, -1)
		end
	end


	doAreaCombatHealth(cid, FIGHTDAMAGE, getThingPositionWithDebug(b), 0, -min, -max, 3)

elseif spell == "Furious Legs" then

	local outfit = {}
	      outfit.lookType = 652

	if isCreature(getMasterTarget(cid)) then
		doFaceCreature(cid, getThingPositionWithDebug(getMasterTarget(cid)))
	end

	local b = mydir
	local p = getThingPositionWithDebug(cid)

	local t = {}

	if b == NORTH then
		for k = -1, 1 do
			local pos = {x = p.x - k, y = p.y - 1, z = p.z}
			table.insert(t, pos)
		end
	elseif b == SOUTH then
		for k = -1, 1 do
			local pos = {x = p.x - k, y = p.y + 1, z = p.z}
			table.insert(t, pos)
		end
	elseif b == EAST then
		for k = -1, 1 do
			local pos = {x = p.x + 1, y = p.y + k, z = p.z}
			table.insert(t, pos)
		end
	elseif b == WEST then
		for k = -1, 1 do
			local pos = {x = p.x - 1, y = p.y + k, z = p.z}
			table.insert(t, pos)
		end
	end

	local a = getCreatureSpeed(cid)
		doChangeSpeed(cid, -a)

	doSetCreatureOutfit(cid, outfit, -1)

	local function doKickPos(cid, pos)
		if not isCreature(cid) then return true end
		doAreaCombatHealth(cid, FIGHTDAMAGE, pos, 0, -min, -max, 113)
	end

	local function doReturn(cid, speed)
		if not isCreature(cid) then return true end
		doRemoveCondition(cid, CONDITION_OUTFIT)
		doChangeSpeed(cid, speed)
	end

	for times = 0, 2 do
		for kicks = 1, 3 do
			addEvent(doKickPos, kicks * 140 + times * 400, cid, t[kicks])
		end
	end

		addEvent(doReturn, 1480, cid, a)

elseif spell == "Hyper Beam" then

	local a = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)

	if a == 0 then
		doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(cid), wg1n, -min, -max, 152)
		doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(cid), wg2n, -min, -max, 158)
		doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(cid), wg3n, -min, -max, 156)
	elseif a == 2 then
		doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(cid), wg1s, -min, -max, 151)
		doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(cid), wg2s, -min, -max, 158)
		doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(cid), wg3s, -min, -max, 155)
	elseif a == 1 then
		doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(cid), wg1e, -min, -max, 149)
		doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(cid), wg2e, -min, -max, 157)
		doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(cid), wg3e, -min, -max, 153)
	elseif a == 3 then
		doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(cid), wg1w, -min, -max, 150)
		doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(cid), wg2w, -min, -max, 157)
		doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(cid), wg3w, -min, -max, 154)
	end

elseif spell == "Fire Punch" then

	local target = getMasterTarget(cid)

	doSendMagicEffect(getThingPositionWithDebug(getMasterTarget(cid)), 112)

		local function doPunch(cid, target)
			if not isCreature(cid) or not isCreature(target) then return true end
		doAreaCombatHealth(cid, FIREDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 15)
		end

	addEvent(doPunch, 200, cid, target)

elseif spell == "Thunder Punch" then

	local target = getMasterTarget(cid)

	doSendMagicEffect(getThingPositionWithDebug(getMasterTarget(cid)), 112)

		local function doPunch(cid, target)
			if not isCreature(cid) or not isCreature(target) then return true end
		doAreaCombatHealth(cid, ELECTRICDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 48)
		end

	addEvent(doPunch, 200, cid, target)

elseif spell == "Ice Punch" then

	local target = getMasterTarget(cid)

	doSendMagicEffect(getThingPositionWithDebug(getMasterTarget(cid)), 112)

		local function doPunch(cid, target)
			if not isCreature(cid) or not isCreature(target) then return true end
		doAreaCombatHealth(cid, ICEDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 43)
		end

	addEvent(doPunch, 200, cid, target)

elseif spell == "Mud Slap" or spell == "Mud-slap" then

	local target = getMasterTarget(cid)

	local function jogarLama(cid, target, damage)
		if not isCreature(target) then return true end
		if not isCreature(cid) then return true end
		doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(target), 38)
		if damage then
		doAreaCombatHealth(cid, GROUNDDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 3)
		end
	end

	for a = 1, 23 do
		if a == 4 or a == 15 or a == 22 then
			addEvent(jogarLama, a * 32, cid, target, true)
		else
			addEvent(jogarLama, a * 32, cid, target, false)
		end
	end

elseif spell == "Fire Mark" then

	local target = getMasterTarget(cid)

	local function markFire(cid, target, damage)
		if not isCreature(target) then return true end
		if not isCreature(cid) then return true end
		doSendMagicEffect(getThingPositionWithDebug(target), 15)
		if damage then
		doAreaCombatHealth(cid, FIREDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 3)
		end
	end

	for a = 1, 23 do
		if a == 4 or a == 15 or a == 22 then
			addEvent(markFire, a * 32, cid, target, true)
		else
			addEvent(markFire, a * 32, cid, target, false)
		end
	end

elseif spell == "Horn Drill" then

	local target = getMasterTarget(cid)
	local a = getThingPositionWithDebug(cid)
	local b = getThingPositionWithDebug(target)
	local c = getDirectionTo(a, b)

	for distance = 1, 3 do
		b = getPosByDir(b, c)
	end

	doSendDistanceShoot(a, b, 25)
	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 3)

elseif spell == "Giga Impact" then

	local target = getMasterTarget(cid)
	local a = getThingPositionWithDebug(cid)
	local b = getThingPositionWithDebug(target)
	local c = getDirectionTo(a, b)

	doCreatureAddCondition(cid, permanentinvisible)
	doTeleportThing(cid, b)

	local function doAppear(cid)
		if not isCreature(cid) then return true end
		doRemoveCondition(cid, CONDITION_INVISIBLE)
	end

	doSendDistanceShoot(a, b, 10)
	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 3)
	addEvent(doAppear, 250, cid)

elseif spell == "Dig" then

	doCreatureAddCondition(cid, permanentinvisible)
	doSendMagicEffect(getThingPositionWithDebug(cid), 3)

	local function backtoground(cid)
		if not isCreature(cid) then return true end
		doRemoveCondition(cid, CONDITION_INVISIBLE)
		local pos = getThingPositionWithDebug(cid)
		doSendMagicEffect(pos, 219)
		doSendMagicEffect(pos, 224)
		doAreaCombatHealth(cid, GROUNDDAMAGE, getThingPositionWithDebug(cid), splash, -min, -max, 255)
	return true
	end

	addEvent(backtoground, 6 * 450 + 150, cid)

elseif spell == "X-Scissor" then

	local a = getThingPositionWithDebug(target)
	a.x = a.x + 1
	a.y = a.y + 1

	for b = 1, 3 do
		addEvent(doSendMagicEffect, b * 70, a, 16)
	end

	doAreaCombatHealth(cid, BUGDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 255)

elseif spell == "Iron Tail" then

	local function rebackSpd(cid, sss)
		if not isCreature(cid) then return true end
		doChangeSpeed(cid, sss)
		setPlayerStorageValue(cid, 446, -1)
	end

	local x = getCreatureSpeed(cid)
	doFaceOpposite(cid)
	doChangeSpeed(cid, -x)
	addEvent(rebackSpd, 400, cid, x)
	setPlayerStorageValue(cid, 446, 1)
	doAreaCombatHealth(cid, STEELDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 160)

elseif spell == "Dragon Tail" then

	local function rebackSpd(cid, sss)
		if not isCreature(cid) then return true end
		doChangeSpeed(cid, sss)
		setPlayerStorageValue(cid, 446, -1)
	end

	local x = getCreatureSpeed(cid)
	doFaceOpposite(cid)
	doChangeSpeed(cid, -x)
	addEvent(rebackSpd, 400, cid, x)
	setPlayerStorageValue(cid, 446, 1)
	doAreaCombatHealth(cid, DRAGONDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 136)

elseif spell == "Swift" then

	local target = getMasterTarget(cid)
	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(target), 32)
	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 3)

elseif spell == "Crabhammer" then

	local target = getMasterTarget(cid)
	doAreaCombatHealth(cid, WATERDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 225)

elseif spell == "Dream Eater" then

	local target = getMasterTarget(cid)

	if not isSleeping(target) then
		doSendMagicEffect(getThingPositionWithDebug(target), 3)
		doSendAnimatedText(getThingPositionWithDebug(target), "FAIL", 155)
	return true
	end

	local function nightmare(target)
		if not isCreature(target) then return true end
		doSendMagicEffect(getThingPositionWithDebug(target), 139)
	end

	local a = getCreatureHealth(target)
	
	for j = 0, 1 do
		addEvent(nightmare, j * 150, target)
	end

	doAreaCombatHealth(cid, PSYCHICDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 138)
	local b = getCreatureHealth(target)
	local c = a - b
	doCreatureAddHealth(cid, math.ceil(c / 2))
	doSendMagicEffect(getThingPositionWithDebug(cid), 12)
	doSendAnimatedText(getThingPositionWithDebug(cid), "+"..math.ceil(c/2).."", 155)

elseif spell == "Stomp" then

	local target = getMasterTarget(cid)
	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 248)

elseif spell == "Giga Drain" then

	local life = getCreatureHealth(getMasterTarget(cid))
	local target = getMasterTarget(cid)

	doAreaCombatHealth(cid, GRASSDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 14)

	local newlife = (life - getCreatureHealth(getMasterTarget(cid)))

	local function doEffect(cid, target)
		if not isCreature(cid) or not isCreature(target) then return true end
		local t = {37, 30}
		doSendDistanceShoot(getThingPositionWithDebug(target), getThingPositionWithDebug(cid), t[math.random(1, 2)])
	end

	for a = 1, 7 do
		addEvent(doEffect, a * 65, cid, target)
	end

	doSendMagicEffect(getThingPositionWithDebug(cid), 239)
	if newlife >= 1 then
	doCreatureAddHealth(cid, newlife)
	doSendAnimatedText(getThingPositionWithDebug(cid), "+"..newlife.."", 35)
	end

elseif spell == "Nature Ball" then

	local target = getMasterTarget(cid)
	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(target),  30)
	doAreaCombatHealthAtDistance(cid, GRASSDAMAGE, getThingPositionWithDebug(target), splash, -min, -max, 45)

elseif spell == "Shockwave" or spell == "Shock Wave" then

	local posicao = getThingPositionWithDebug(cid)
		
	local function doShockWave(cid, pos, varx, vary, effect)
	if isCreature(cid) and isSightClear(posicao, pos, false) then
	doAreaCombatHealth(cid, GROUNDDAMAGE, pos, whirl3, -min, -max, 255)
	doSendMagicEffect({x = pos.x + varx, y = pos.y + vary, z = pos.z}, effect)
	end
	end

	local effect = 255
	local a = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)

	if a == 0 then
		effect = 126
		for sw = 0, 5 do
			addEvent(doShockWave, 325 * sw, cid, {x = posicao.x, y = posicao.y - (sw + 1), z = posicao.z}, 1, 1, effect)
		end
	elseif a == 2 then
		effect = 125
		for sw = 0, 5 do
			addEvent(doShockWave, 325 * sw, cid, {x = posicao.x, y = posicao.y + (sw + 1), z = posicao.z}, 1, 1, effect)
		end
	elseif a == 1 then
		effect = 124
		for sw = 0, 5 do
			addEvent(doShockWave, 325 * sw, cid, {x = posicao.x + (sw + 1), y = posicao.y, z = posicao.z}, 1, 1, effect)
		end
	elseif a == 3 then
		effect = 123
		for sw = 0, 5 do
			addEvent(doShockWave, 325 * sw, cid, {x = posicao.x - (sw + 1), y = posicao.y, z = posicao.z}, 1, 1, effect)
		end
	end

elseif spell == "Windstorm" then

	local t = {}
	local m = getThingPositionWithDebug(cid)
		for x = -5, 5 do
			for y = -5, 5 do
			local pos = {x = m.x + x, y = m.y + y, z = m.z}
			table.insert(t, pos)
			end
		end

	local function doWindStorm(cid, pos)
		if not isCreature(cid) then return true end
		doAreaCombatHealth(cid, FLYDAMAGE, pos, 0, -min, -max, 42)
		doSendMagicEffect(pos, CONST_ME_POFF)
		doSendDistanceShoot(pos, {x=pos.x+math.random(-2,2),y=pos.y+math.random(-2,2),z=pos.z}, 36)
		doSendDistanceShoot(pos, {x=pos.x+math.random(-2,2),y=pos.y+math.random(-2,2),z=pos.z}, 36)
		doSendDistanceShoot(pos, {x=pos.x+math.random(-2,2),y=pos.y+math.random(-2,2),z=pos.z}, 36)
	end

	for b = 1, 3 do
	for a = 1, #t do
		if #t >= 1 then
		local random = math.random(1, #t)
		addEvent(doWindStorm, 25 * a, cid, t[random])
		t = doRemoveElementFromTable(t, t[random])
		end
	end
	end

elseif spell == "Air Slash" then

	local target = getMasterTarget(cid)

	local pos1 = getThingPositionWithDebug(target)
		pos1.x = pos1.x - 2
		pos1.y = pos1.y - 2
	local pos2 = getThingPositionWithDebug(target)
		pos2.x = pos2.x + 2
		pos2.y = pos2.y + 2

	for a = 1, 7 do
		addEvent(doSendDistanceShoot, a * 50, pos1, pos2, 36)
	end
		doAreaCombatHealth(cid, FLYDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 42)


elseif spell == "Fury Swipes" then

	local chance = {2, 3, 4, 5, 2, 3, 3, 2}

	local random = chance[math.random(1, #chance)]

	local function doFurySwipe(cid, target, round, limit)
		local ret = "S"
		if not isCreature(cid) then return true end
		if round <= 1 then ret = "" end
		if not isCreature(target) or getCreatureHealth(target) <= 0 then
		doSendAnimatedText(getThingPositionWithDebug(cid), round.." HIT"..ret.."", 215)
		return true end
		if round >= limit then doSendAnimatedText(getThingPositionWithDebug(cid), round.." HIT"..ret.."", 215) return true end
		doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 142)
		addEvent(doFurySwipe, 450, cid, target, round + 1, limit)
	end

	local target = getMasterTarget(cid)

	doFurySwipe(cid, target, 0, random)		

elseif spell == "Wind Vortex" then

	local pos = getThingPositionWithDebug(cid)
	local mainpos = getThingPositionWithDebug(cid)

	local a = {
	[1] = {x = pos.x, y = pos.y - 4, z = pos.z},
	[2] = {x = pos.x - 4, y = pos.y, z = pos.z},
	[3] = {x = pos.x, y = pos.y + 4, z = pos.z},
	[4] = {x = pos.x + 4, y = pos.y, z = pos.z},
	[5] = {x = pos.x, y = pos.y - 4, z = pos.z}}
	local b = {
	[1] = {x = pos.x - 3, y = pos.y, z = pos.z},
	[2] = {x = pos.x, y = pos.y + 3, z = pos.z},
	[3] = {x = pos.x + 3, y = pos.y, z = pos.z},
	[4] = {x = pos.x, y = pos.y + 3, z = pos.z},
	[5] = {x = pos.x - 3, y = pos.y, z = pos.z}}
	local c = {
	[1] = {x = pos.x, y = pos.y + 2, z = pos.z},
	[2] = {x = pos.x + 2, y = pos.y, z = pos.z},
	[3] = {x = pos.x, y = pos.y - 2, z = pos.z},
	[4] = {x = pos.x - 2, y = pos.y, z = pos.z},
	[5] = {x = pos.x, y = pos.y + 2, z = pos.z}}

	local function doWindVortex(cid, pos1, pos2)
		if not isCreature(cid) then return true end
		doSendDistanceShoot(pos1, pos2, 36)
		local effects = {CONST_ME_POFF, 3, 148}
		--doSendMagicEffect(pos1, effects[math.random(1, 3)])
	end

	for aaa = 0, 7 do
		for aa = 1, 4 do
			addEvent(doWindVortex, aa * 50 + aaa * 225, cid, a[aa], a[aa+1])
		end
	end

	for bbb = 0, 7 do
		for bb = 1, 4 do
			addEvent(doWindVortex, bb * 50 + bbb * 225, cid, b[bb], b[bb+1])
		end
	end

	for ccc = 0, 7 do
		for cc = 1, 4 do
			addEvent(doWindVortex, cc * 50 + ccc * 225, cid, c[cc], c[cc+1])
		end
	end


	local function doWindVortexDamage(cid, mainpos)
		if not isCreature(cid) then return true end
	doAreaCombatHealth(cid, FLYDAMAGE, mainpos, wvortex, -min, -max, 255)
	end

	for dmg = 1, 13 do
		addEvent(doWindVortexDamage, dmg * 150, cid, mainpos)
	end

elseif spell == "Wind Blow" then

	doAreaCombatHealth(cid, FLYDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 222)

elseif spell == "Hurricane" then

	local a = {
	[1] = NORTH,
	[2] = NORTHWEST,
	[3] = WEST,
	[4] = SOUTHWEST,
	[5] = SOUTH,
	[6] = SOUTHEAST,
	[7] = EAST,
	[8] = NORTHEAST}

	local pos = getThingPositionWithDebug(cid)


	local function doHurricane(cid, dir, extended)
		if not isCreature(cid) then return true end
		local pos = {}
		if extended then
			pos = getThingPositionWithDebug(cid)
		local b = {
	[1] = {x = pos.x, y = pos.y + 2, z = pos.z},
	[2] = {x = pos.x - 1, y = pos.y + 2, z = pos.z},
	[3] = {x = pos.x - 2, y = pos.y + 2, z = pos.z},
	[4] = {x = pos.x - 2, y = pos.y + 1, z = pos.z},
	[5] = {x = pos.x - 2, y = pos.y, z = pos.z},
	[6] = {x = pos.x - 2, y = pos.y - 1, z = pos.z},
	[7] = {x = pos.x - 2, y = pos.y - 2, z = pos.z},
	[8] = {x = pos.x - 1, y = pos.y - 2, z = pos.z},
	[9] = {x = pos.x, y = pos.y - 2, z = pos.z},
	[10] = {x = pos.x + 1, y = pos.y - 2, z = pos.z},
	[11] = {x = pos.x + 2, y = pos.y - 2, z = pos.z},
	[12] = {x = pos.x + 2, y = pos.y - 1, z = pos.z},
	[13] = {x = pos.x + 2, y = pos.y, z = pos.z},
	[14] = {x = pos.x + 2, y = pos.y + 1, z = pos.z},
	[15] = {x = pos.x + 2, y = pos.y + 2, z = pos.z},
	[16] = {x = pos.x + 1, y = pos.y + 2, z = pos.z},}
			pos = b[dir]
		else
			pos = getPosByDir(getThingPositionWithDebug(cid), dir)
		end
	doAreaCombatHealth(cid, FLYDAMAGE, pos, 0, -min, -max, 42)
	end

	for r = 0, 5 do
		for t = 1, 8 do
			addEvent(doHurricane, t * 150 + r * 1205, cid, a[t], false)
		end
	end

	for r = 0, 2 do
		for k = 1, 16 do
			addEvent(doHurricane, k * 130 + r * 2200, cid, k, true)
		end
	end

elseif spell == "Aeroblast" then

	local pos = getThingPositionWithDebug(cid)
	local cidpos = getThingPositionWithDebug(cid)
	local tpos = pos
	local t = {}
	

	for a = 1, 6 do
		tpos = getPosByDir(tpos, mydir)
		table.insert(t, tpos)
		doAreaCombatHealth(cid, FLYDAMAGE, tpos, 0, -min, -max, 255)
	end

	local function doAeroEffect(cid, cidpos, pos, varxa, varxb, varya, varyb)
		if not isCreature(cid) then return true end
		doSendDistanceShoot(cidpos, pos, 36)
			if math.random(1, 7) <= 3 then
				doSendDistanceShoot(cidpos, {x=cidpos.x+math.random(varxa,varxb),y=cidpos.y+math.random(varya,varyb),z=cidpos.z}, 36)
			end
	end

	local varxa = 0
	local varxb = 0
	local varya = 0
	local varyb = 0

	local function doHyperBeamEffect(cid, a, mpos)
		if not isCreature(cid) then return true end
		local pos = mpos
		local beam = {
		[NORTH] = {effect = {152, 158, 158, 158, 156}, xvar = 0, yvar = -1},
		[SOUTH] = {effect = {151, 158, 158, 158, 155}, xvar = 0, yvar = 1},
		[EAST] = {effect = {149, 157, 157, 157, 153}, xvar = 1, yvar = 0},
		[WEST] = {effect = {150, 157, 157, 157, 154}, xvar = -1, yvar = 0}}
		for bb = 1, 5 do
			local wx = beam[a].xvar
			local wy = beam[a].yvar
			local ef = beam[a].effect[bb]
			local topos = {x=pos.x+(wx*bb),y=pos.y+(wy*bb),z=pos.z}
			doSendMagicEffect(topos, ef)
		end
	end

	for a = 0, 2 do
		addEvent(doHyperBeamEffect, a * 300, cid, mydir, cidpos)
	end

	if mydir == 0 then
		varxa = -2
		varxb = 2
		varya = 1
		varyb = 3
	elseif mydir == 1 then
		varxa = -3
		varxb = -1
		varya = -2
		varyb = 2
	elseif mydir == 2 then
		varxa = -2
		varxb = 2
		varya = -3
		varyb = -1
	elseif mydir == 3 then
		varxa = 1
		varxb = 3
		varya = -2
		varyb = 2
	end

	for etc = 1, 25 do
		for b = 1, 5 do
			if etc <= 24 then
				addEvent(doAeroEffect, b * 25 + etc * 50, cid, cidpos, t[b], varxa, varxb, varya, varyb)
			else
				addEvent(doAeroEffect, b * 25 + etc * 50, cid, cidpos, t[b], varxa, varxb, varya, varyb)
			end
		end
	end


elseif spell == "Falling Rocks" then

	local t = {}
	local m = getThingPositionWithDebug(cid)
		for x = -7, 7 do
			for y = -7, 7 do
			local pos = {x = m.x + x, y = m.y + y, z = m.z, stackpos = 0}
			table.insert(t, pos)
			end
		end

	local function doCrushRock(cid, pos)
		if not isCreature(cid) then return true end
	local effect = 44
		pos.stackpos = 0
		if getTileThingByPos(pos).itemid >= 4820 and getTileThingByPos(pos).itemid <= 4825 then
		effect = 1
		end
	doAreaCombatHealth(cid, ROCKDAMAGE, pos, 0, -min, -max, effect)
	end

	local function doFallRock(cid, pos)
		if not isCreature(cid) then return true end
		local apos = pos
		local frompos = {x=apos.x-7,y=apos.y-6,z=apos.z}
		doSendDistanceShoot(frompos, pos, 11)
		addEvent(doCrushRock, 385, cid, pos)
	end

	for a = 1, #t do
		if #t >= 1 then
		local random = math.random(1, #t)
		addEvent(doFallRock, a * 24, cid, t[random])
		t = doRemoveElementFromTable(t, t[random])
		end
	end

	for randomic = 1, 128 do
		local randompos = {x=m.x+math.random(-6,6),y=m.y+math.random(-6,6),z=m.z}
		addEvent(doFallRock, randomic * math.random(25, 30), cid, randompos)
	end

elseif spell == "Blizzard" then

	local t = {}
	local m = getThingPositionWithDebug(cid)
		for x = -7, 7 do
			for y = -7, 7 do
			local pos = {x = m.x + x, y = m.y + y, z = m.z, stackpos = 0}
			table.insert(t, pos)
			end
		end

	local function doCrushIce(cid, pos)
		if not isCreature(cid) then return true end
	doAreaCombatHealth(cid, ICEDAMAGE, pos, 0, -min, -max, 52)
	end

	local function doFallIce(cid, pos)
		if not isCreature(cid) then return true end
		local apos = pos
		local frompos = {x=apos.x-7,y=apos.y-6,z=apos.z}
		doSendDistanceShoot(frompos, pos, 28)
		addEvent(doCrushIce, 385, cid, pos)
	end

	for a = 1, #t do
		if #t >= 1 then
		local random = math.random(1, #t)
		addEvent(doFallIce, a * 24, cid, t[random])
		t = doRemoveElementFromTable(t, t[random])
		end
	end

	for randomic = 1, 128 do
		local randompos = {x=m.x+math.random(-6,6),y=m.y+math.random(-6,6),z=m.z}
		addEvent(doFallIce, randomic * math.random(25, 30), cid, randompos)
	end

elseif spell == "Air Cutter" then

local damagearea = {}
local effectpos = getThingPositionWithDebug(cid)
local effect = 255

	if mydir == 0 then
		effect = 128
		effectpos.x = effectpos.x + 1
		effectpos.y = effectpos.y - 1
		damagearea = acsn
	elseif mydir == 1 then
		effectpos.x = effectpos.x + 1
		effectpos.y = effectpos.y + 1
		effect = 129
		damagearea = acsn
	elseif mydir == 2 then
		effectpos.x = effectpos.x + 1
		effectpos.y = effectpos.y + 1
		effect = 131
		damagearea = acsn
	elseif mydir == 3 then
		effectpos.x = effectpos.x - 1
		effectpos.y = effectpos.y + 1
		effect = 130
		damagearea = acsn
	end

	local this = getThingPositionWithDebug(cid)
	this = getPosByDir(this, mydir)

	local function doCutAir()
		if not isCreature(cid) then return true end
	doSendMagicEffect(effectpos, effect)
	doAreaCombatHealth(cid, FLYDAMAGE, this, damagearea, -min, -max, 42)
	this = getPosByDir(this, mydir)
	effectpos = getPosByDir(effectpos, mydir)
	end

	for range = 0, 2 do
		addEvent(doCutAir, range * 350)
	end

elseif spell == "Ice Shard" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 28)
	doAreaCombatHealthAtDistance(cid, ICEDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 43)

elseif spell == "Shadow Ball" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 18)

		local function doDamageWithDelay(cid, target)
		if not isCreature(cid) or not isCreature(target) then return true end
	doAreaCombatHealth(cid, GHOSTDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 255)
	local pos = getThingPositionWithDebug(getMasterTarget(cid))
	pos.x = pos.x + 1
	doSendMagicEffect(pos, 140)
	end

	addEvent(doDamageWithDelay, getDistDelay, cid, target)

elseif spell == "Powder Snow" then

	local posicao = getThingPositionWithDebug(cid)

	local function snowWind(params)
	if isCreature(params.cid) and isSightClear(posicao, params.ar, false) then
	doAreaCombatHealth(cid, ICEDAMAGE, params.ar, sand1, -min, -max, 41)
	end
	end

	local a = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)

	if a == 0 then
		for pw = 0, 2 do
			addEvent(snowWind, pw  * 650, {cid = cid, ar = {x=posicao.x, y=posicao.y-(pw+1), z=posicao.z}})
		end
	elseif a == 2 then
		for pw = 0, 2 do
			addEvent(snowWind, pw  * 650, {cid = cid, ar = {x=posicao.x, y=posicao.y+pw+1, z=posicao.z}})
		end
	elseif a == 1 then
		for pw = 0, 2 do
			addEvent(snowWind, pw  * 650, {cid = cid, ar = {x=posicao.x+(pw+1), y=posicao.y, z=posicao.z}})
		end
	elseif a == 3 then
		for pw = 0, 2 do
			addEvent(snowWind, pw  * 650, {cid = cid, ar = {x=posicao.x-(pw+1), y=posicao.y, z=posicao.z}})
		end
	end

elseif spell == "Ice Beam" then

	local a = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)

	if a == 0 then
		doAreaCombatHealth(cid, ICEDAMAGE, getThingPositionWithDebug(cid), wg1n, -min, -max, 99)
		doAreaCombatHealth(cid, ICEDAMAGE, getThingPositionWithDebug(cid), wg2n, -min, -max, 105)
		doAreaCombatHealth(cid, ICEDAMAGE, getThingPositionWithDebug(cid), wg3n, -min, -max, 103)
	elseif a == 2 then
		doAreaCombatHealth(cid, ICEDAMAGE, getThingPositionWithDebug(cid), wg1s, -min, -max, 98)
		doAreaCombatHealth(cid, ICEDAMAGE, getThingPositionWithDebug(cid), wg2s, -min, -max, 105)
		doAreaCombatHealth(cid, ICEDAMAGE, getThingPositionWithDebug(cid), wg3s, -min, -max, 102)
	elseif a == 1 then
		doAreaCombatHealth(cid, ICEDAMAGE, getThingPositionWithDebug(cid), wg1e, -min, -max, 96)
		doAreaCombatHealth(cid, ICEDAMAGE, getThingPositionWithDebug(cid), wg2e, -min, -max, 104)
		doAreaCombatHealth(cid, ICEDAMAGE, getThingPositionWithDebug(cid), wg3e, -min, -max, 100)
	elseif a == 3 then
		doAreaCombatHealth(cid, ICEDAMAGE, getThingPositionWithDebug(cid), wg1w, -min, -max, 97)
		doAreaCombatHealth(cid, ICEDAMAGE, getThingPositionWithDebug(cid), wg2w, -min, -max, 104)
		doAreaCombatHealth(cid, ICEDAMAGE, getThingPositionWithDebug(cid), wg3w, -min, -max, 101)
	end

elseif spell == "Icy Wind" then

	local target = getMasterTarget(cid)
	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(target), 35)
	doAreaCombatHealthAtDistance(cid, ICEDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 41)

elseif spell == "Lick" then

	local target = getMasterTarget(cid)

	doAreaCombatCondition(cid, getThingPositionWithDebug(target), 0, thunderwavecondition, 255)
	doAreaCombatHealth(cid, GHOSTDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 145)

elseif spell == "Clamp" then

	local function doClamp(cid, target, damage)
	if not isCreature(cid) or not isCreature(target) then return true end
	if damage then
		doAreaCombatHealth(cid, WATERDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 68)
	else
		doSendMagicEffect(getThingPositionWithDebug(target), 117)
	end
	end

	local target = getMasterTarget(cid)

	for a = 0, 3 do
		if a == 3 then
			addEvent(doClamp, a * 75, cid, target, true)
		else
			addEvent(doClamp, a * 75, cid, target, false)
		end
	end

elseif spell == "Aurora Beam" then

	local a = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)

	if a == 0 then
		doAreaCombatHealth(cid, ICEDAMAGE, getThingPositionWithDebug(cid), auroran, -min, -max, 57)
	elseif a == 2 then
		doAreaCombatHealth(cid, ICEDAMAGE, getThingPositionWithDebug(cid), auroras, -min, -max, 58)
	elseif a == 1 then
		doAreaCombatHealth(cid, ICEDAMAGE, getThingPositionWithDebug(cid), aurorae, -min, -max, 234)
	elseif a == 3 then
		doAreaCombatHealth(cid, ICEDAMAGE, getThingPositionWithDebug(cid), auroraw, -min, -max, 209)
	end

elseif spell == "Nightmare" then

	local target = getMasterTarget(cid)

	if not isSleeping(target) then
		doSendMagicEffect(getThingPositionWithDebug(target), 3)
		doSendAnimatedText(getThingPositionWithDebug(target), "FAIL", 155)
	return true
	end

	local function nightmare(target)
		if not isCreature(target) then return true end
		doSendMagicEffect(getThingPositionWithDebug(target), 139)
	end

	local function doNightmare(cid, target)
		if not isCreature(target) then return true end
		if not isCreature(cid) then return true end
		if not isSleeping(target) then return true end
		addEvent(nightmare, 0, target)
		addEvent(nightmare, 100, target)
		addEvent(nightmare, 200, target)
		doAreaCombatHealth(cid, NIGHTMAREDAMAGE, getThingPositionWithDebug(target), 0, -100, -100, 242)
		addEvent(doNightmare, 3000, cid, target)
	end

	nightmare(target)
	addEvent(doNightmare, 1000, cid, target)

elseif spell == "Healarea" then

	doAreaCombatHealth(cid, HEALINGDAMAGE, getThingPositionWithDebug(cid), healarea, getSpecialAttack(cid) * 4 * healMultiplier, getSpecialAttack(cid) * 4 * healMultiplier, 12)

	local function doHeal(cid, amount)
		doCreatureAddHealth(cid, amount)
		doSendMagicEffect(getThingPositionWithDebug(cid), 12)
		doSendAnimatedText(getThingPositionWithDebug(cid), "+"..amount.."", 65)
	end

	doHeal(cid, getSpecialAttack(cid) * 4 * healMultiplier)

elseif spell == "Double Edge" or spell == "Double-edge" or spell == "Take Down" then
	
	doBodyPush(cid, target, true)

	local a = getCreatureHealth(target)
	local b = 0

	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 3)

	if isCreature(target) and getCreatureHealth(target) > 0 then
		b = getCreatureHealth(target)
	end

	local hploss = math.floor((a - b) * 0.5)

	local function doRecoil(cid, hp)
		if not isCreature(cid) then return true end
		doCreatureAddHealth(cid, -hp)
		doSendAnimatedText(getThingPositionWithDebug(cid), "-"..hploss.."", 180)
		doSendMagicEffect(getThingPositionWithDebug(cid), 3)
	end

	addEvent(doRecoil, 400, cid, hploss)

elseif spell == "Sky Drop" then

	doCreatureAddCondition(cid, permanentinvisible)
	doSendMagicEffect(getThingPositionWithDebug(cid), 211)
	local mypos = getThingPositionWithDebug(cid)
	local topos = getThingPositionWithDebug(target)
	topos.y = topos.y - 7
	doSendDistanceShoot(getThingPositionWithDebug(cid), topos, 39)

		local function doReturn(cid, check, pos)
		if not isCreature(cid) then return true end
		local dmgpos = {}
			if check and isCreature(check) then
				dmgpos = getThingPositionWithDebug(check)
			else
				dmgpos = pos
			end
		doAreaCombatHealth(cid, FLYDAMAGE, dmgpos, 0, -min, -max, 42)
		doCreatureRemoveCondition(cid, CONDITION_INVISIBLE)
		doTeleportThing(cid, dmgpos, false)
		doCreatureSetLookDir(cid, 2)
		end
	
		local function dropBack(cid, target, pos)
		if not isCreature(cid) then return true end
		if not isCreature(target) then
		local bpos = pos
		bpos.y = bpos.y + 7
		doSendDistanceShoot(pos, bpos, 39)
		addEvent(doReturn, 450, cid, false, bpos)
		return true
		end
		doSendDistanceShoot(pos, getThingPositionWithDebug(target), 39)
		addEvent(doReturn, 450, cid, target, getThingPositionWithDebug(target))
		end

	addEvent(dropBack, 650, cid, target, topos)

elseif spell == "Sting Gun" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 13)
	doAreaCombatHealthAtDistance(cid, NORMALDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 3)

elseif spell == "Agility" then

	local a = getSpeed(cid)
	local b = a * 3
	local c = b - a
	setPlayerStorageValue(cid, 1003, b)
	doSendMagicEffect(getThingPositionWithDebug(cid), 254)
	doSendAnimatedText(getThingPositionWithDebug(cid), "+ SPEED", COLOR_GRASS)

	if getCreatureSpeed(cid) ~= 0 then
	doRegainSpeed(cid)
	end

		local function loseSpeed(cid, w)
			if not isCreature(cid) then return true end
		local j = getPlayerStorageValue(cid, 1003)
		setPlayerStorageValue(cid, 1003, j - w)
			if getCreatureSpeed(cid) ~= 0 then	
				doRegainSpeed(cid)
			end
		end

	addEvent(loseSpeed, 8000, cid, c)

elseif spell == "Thunderbolt" or spell == "Thunder Bolt" then

		local function doThunderHit(cid, target)
			if not isCreature(target) or not isCreature(cid) then return true end
		doAreaCombatHealth(cid, ELECTRICDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 48)
		end

		local function doThunderFall(cid, frompos, target)
			if not isCreature(target) or not isCreature(cid) then return true end
		local pos = getThingPositionWithDebug(target)
		local ry = math.abs(frompos.y - pos.y)
		doSendDistanceShoot(frompos, getThingPositionWithDebug(target), 41)
		addEvent(doThunderHit, ry * 33, cid, target)
		end

		local function doThunderUp(cid, target)
			if not isCreature(target) or not isCreature(cid) then return true end
		local pos = getThingPositionWithDebug(target)
		local mps = getThingPositionWithDebug(cid)
		local xrg = math.floor((pos.x - mps.x) / 2)
		local topos = mps
		topos.x = topos.x + xrg
		local rd =  11
		topos.y = topos.y - rd
		doSendDistanceShoot(getThingPositionWithDebug(cid), topos, 41)
		addEvent(doThunderFall, rd * 49, cid, topos, target)
		end		

	local alvo = getMasterTarget(cid)

	for thnds = 0, 2 do
		addEvent(doThunderUp, thnds * 155, cid, alvo)
	end

elseif spell == "Faint Attack" then

	local a = getThingPositionWithDebug(cid)
	local b = getClosestFreeTile(cid, getThingPositionWithDebug(target))
	local c = getCreatureLookDir(cid)
	doSendMagicEffect(a, 211)
	doTeleportThing(cid, b, false)
	doFaceCreature(cid, getThingPositionWithDebug(target))

		local function comeBack(cid, lastpos, lastld)
			if not isCreature(cid) then return true end
		doSendMagicEffect(getThingPositionWithDebug(cid), 211)
		doTeleportThing(cid, lastpos, false)
		doCreatureSetLookDir(cid, lastld)
		end

	doAreaCombatHealth(cid, DARKDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 148)
	addEvent(comeBack, 200, cid, a, c)

elseif spell == "Fissure" then

	local aa = isCreature(getMasterTarget(cid)) and getDirectionTo(getThingPositionWithDebug(cid), getThingPositionWithDebug(target)) or getCreatureLookDir(cid)
	local bb = getFaceOpposite(aa)
	local back = {}
	local front = {}
	local apos = getThingPositionWithDebug(cid)

	local aae = {
	[NORTH] = {varx = 0, vary = -1},
	[SOUTH] = {varx = 0, vary = 1},
	[EAST] = {varx = 1, vary = 0},
	[WEST] = {varx = -1, vary = 0},
	[NORTHEAST] = {varx = 1, vary = -1},
	[NORTHWEST] = {varx = -1, vary = -1},
	[SOUTHEAST] = {varx = 1, vary = 1},
	[SOUTHWEST] = {varx = -1, vary = 1}}

	local varx = aae[bb].varx
	local vary = aae[bb].vary
	local xvar = aae[aa].varx
	local yvar = aae[aa].vary

	for c = 1, 6 do
		local addpos = {x=apos.x+(varx*c),y=apos.y+(vary*c),z=apos.z}
		table.insert(back, addpos)
	end

	for d = 1, 6 do
		local addpos = {x=apos.x+(xvar*d),y=apos.y+(yvar*d),z=apos.z}
		table.insert(front, addpos)
	end

		local function doFissure(cid, pos)
		doSendMagicEffect({x=pos.x+1,y=pos.y+1,z=pos.z}, 127)
		if not isCreature(cid) then return true end
		doAreaCombatHealth(cid, GROUNDDAMAGE, pos, 0, -min, -max, 255)
		end

	for times = 0, 2 do
	for e = 1, 6 do
		addEvent(doFissure, e * 145 + times * 400, cid, front[e])
		addEvent(doFissure, e * 145 + times * 400, cid, back[e])
	end
	end

elseif spell == "Lava Plume" then

	doAreaCombatHealth(cid, FIREDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 233)

elseif spell == "Magma Storm" then

	local t = {}
	local m = getThingPositionWithDebug(cid)
		for x = -7, 7 do
			for y = -7, 7 do
			local pos = {x = m.x + x, y = m.y + y, z = m.z, stackpos = 0}
			table.insert(t, pos)
			end
		end

	local function doExplodeFire(cid, pos)
		if not isCreature(cid) then return true end
	doAreaCombatHealth(cid, FIREDAMAGE, pos, 0, -min, -max, 15)
	end

	local function doFallFire(cid, pos)
		if not isCreature(cid) then return true end
		local apos = pos
		local frompos = {x=apos.x-7,y=apos.y-6,z=apos.z}
		doSendDistanceShoot(frompos, pos, 3)
		addEvent(doExplodeFire, 385, cid, pos)
	end

	for a = 1, #t do
		if #t >= 1 then
		local random = math.random(1, #t)
		addEvent(doFallFire, a * 24, cid, t[random])
		t = doRemoveElementFromTable(t, t[random])
		end
	end

	for randomic = 1, 128 do
		local randompos = {x=m.x+math.random(-6,6),y=m.y+math.random(-6,6),z=m.z}
		addEvent(doFallFire, randomic * math.random(25, 30), cid, randompos)
	end

elseif spell == "Leaf Blade" then

	doAreaCombatHealth(cid, GRASSDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 54)

elseif spell == "Glaciate" then

	doCreatureSetNoMove(target, true)
	doAreaCombatHealth(cid, ICEDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 230)

		local function doReturn(cid)
			if not isCreature(cid) then return true end
		doCreatureSetNoMove(cid, false)
		end

	addEvent(doReturn, 2000, target)

elseif spell == "Icicle Crash" then

	local pos = getThingPositionWithDebug(target)
	pos.x = pos.x -2
	pos.y = pos.y -6

	doSendDistanceShoot(pos, getThingPositionWithDebug(target), 35)

		local function doIcicleDamage(cid, target)
			if not isCreature(cid) or not isCreature(target) then return true end
		doAreaCombatHealth(cid, ICEDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 255)
		local pos = getThingPositionWithDebug(target)
		doSendMagicEffect(pos, 241)
		end

	addEvent(doIcicleDamage, 350, cid, target)

elseif spell == "Shadow Punch" then

	local pos = getThingPositionWithDebug(target)
	doSendMagicEffect(pos, 112)

		local function doPunch(cid, target)
			if not isCreature(cid) or not isCreature(target) then return true end
		doAreaCombatHealth(cid, GHOSTDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 255)
		local pos = getThingPositionWithDebug(target)
		pos.x = pos.x + 1
		doSendMagicEffect(pos, 140)
		end

	addEvent(doPunch, 600, cid, target)

elseif spell == "Dark Pulse" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 6)
	doAreaCombatHealthAtDistance(cid, DARKDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 242)

elseif spell == "Shadow Storm" then

	local t = {}
	local m = getThingPositionWithDebug(cid)
		for x = -7, 7 do
			for y = -7, 7 do
			local pos = {x = m.x + x, y = m.y + y, z = m.z, stackpos = 0}
			table.insert(t, pos)
			end
		end

	local function doShadowDamage(cid, pos)
		if not isCreature(cid) then return true end
	doAreaCombatHealth(cid, GHOSTDAMAGE, pos, 0, -min, -max, 255)
		local mpos = pos
		mpos.x = mpos.x + 1
		doSendMagicEffect(mpos, 140)
	end

	local function doFallShadow(cid, pos)
		if not isCreature(cid) then return true end
		local apos = pos
		local frompos = {x=apos.x-7,y=apos.y-6,z=apos.z}
		doSendDistanceShoot(frompos, pos, 18)
		addEvent(doShadowDamage, 385, cid, pos)
	end

	for a = 1, #t do
		if #t >= 1 then
		local random = math.random(1, #t)
		addEvent(doFallShadow, a * 24, cid, t[random])
		t = doRemoveElementFromTable(t, t[random])
		end
	end

	for randomic = 1, 128 do
		local randompos = {x=m.x+math.random(-6,6),y=m.y+math.random(-6,6),z=m.z}
		addEvent(doFallShadow, randomic * math.random(25, 30), cid, randompos)
	end

elseif spell == "Guillotine" then

	local random = getPokemonLevel(cid) - getPokemonLevel(target)

	if math.random(1, 100) >= random or getPokemonLevel(cid) < getPokemonLevel(target) then
		doSendAnimatedText(getThingPositionWithDebug(cid), "FAIL", 215)
	return true
	end

	if getCreatureName(cid) == "Kingler" then
		doSendMagicEffect(getThingPositionWithDebug(target), 225)
	elseif getCreatureName(cid) == "Pinsir" then
		local pos1 = getThingPositionWithDebug(target)
		local pos2 = getThingPositionWithDebug(target)
		pos1.x = pos1.x - 2
		pos2.x = pos2.x + 2
		doSendDistanceShoot(pos1, pos2, 0)
		doSendDistanceShoot(pos2, pos1, 0)
	end

	doAreaCombatHealth(cid, GUILLOTINEDAMAGE, getThingPositionWithDebug(target), 0, -10, -10, 255)

elseif spell == "Volt Tackle" then

	doAreaCombatHealth(cid, ELECTRICDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 48)

elseif spell == "Hyper Voice" then

	local effect = 165

		local function doHyperVoice(cid, area)
		if not isCreature(cid) then return true end
		doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(cid), area, -min, -max, effect)
		end

	local areas = {hv1, hv2, hv3, hv4, hv5}

	for go = 0, 4 do
		addEvent(doHyperVoice, go * 220, cid, areas[go+1])
	end

elseif spell == "Amnesia" or spell == "Psychic Up" then

	if spell == "Amnesia" then
		doSendMagicEffect(getThingPositionWithDebug(cid), 179)
	else
		doSendMagicEffect(getThingPositionWithDebug(cid), 134)
	end

	doSendAnimatedText(getThingPositionWithDebug(cid), "+ SP.ATK", COLOR_PSYCHIC)

	local function doReduceSpAtk(cid, qnt)
		if not isCreature(cid) then return true end
		local a = getSpecialAttack(cid)
		setPlayerStorageValue(cid, 1005, a - qnt)
	end
	
	local function doDoubleSpAtk(cid)
		if not isCreature(cid) then return true end
		local a = getSpecialAttack(cid)
		setPlayerStorageValue(cid, 1005, a * 2)
		local b = getSpecialAttack(cid)
		local c = b - a
	addEvent(doReduceSpAtk, 7500, cid, c)
	end

	doDoubleSpAtk(cid)

elseif spell == "Karate Chop" then

	local pos = getThingPositionWithDebug(target)
	local x = getPosByDir(getThingPositionWithDebug(target), math.random(4, 7))
	doSendDistanceShoot(x, pos, 26)
	doAreaCombatHealth(cid, FIGHTINGDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 3)

elseif spell == "Ground Kick" then

	local t = {}
	local p = getThingPositionWithDebug(cid)
	local b = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)

	if b == NORTH then
		for k = -1, 1 do
			local pos = {x = p.x - k, y = p.y - 1, z = p.z}
			table.insert(t, pos)
		end
	elseif b == SOUTH then
		for k = -1, 1 do
			local pos = {x = p.x - k, y = p.y + 1, z = p.z}
			table.insert(t, pos)
		end
	elseif b == EAST then
		for k = -1, 1 do
			local pos = {x = p.x + 1, y = p.y + k, z = p.z}
			table.insert(t, pos)
		end
	elseif b == WEST then
		for k = -1, 1 do
			local pos = {x = p.x - 1, y = p.y + k, z = p.z}
			table.insert(t, pos)
		end
	end

	local function doKickPos(cid, pos)
		if not isCreature(cid) then return true end
		doAreaCombatHealth(cid, FIGHTDAMAGE, pos, 0, -min, -max, 113)
	end

	for kicks = 1, 3 do
		addEvent(doKickPos, kicks * 220, cid, t[kicks])
	end

elseif spell == "Cross Chop" then

	local t = {}
	table.insert(t, getPosByDir(getThingPositionWithDebug(target), NORTHEAST))
	table.insert(t, getPosByDir(getThingPositionWithDebug(target), SOUTHWEST))

	for a = 1, 2 do
		doSendDistanceShoot(t[a], getThingPositionWithDebug(target), 26)
	end

	doAreaCombatHealth(cid, FIGHTINGDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 249)

elseif spell == "Fist Machine" then

	local mpos = getThingPositionWithDebug(cid)
	local b = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)
	local effect = 0
	local xvar = 0
	local yvar = 0
	local area = {}

	if b == SOUTH then
		effect = 218
		yvar = 2
		area = fmn
	elseif b == NORTH then
		effect = 217
		area = fms
	elseif b == WEST then
		effect = 216
		area = fmw
	elseif b == EAST then
		effect = 215
		xvar = 2
		area = fme
	end

	mpos.x = mpos.x + xvar
	mpos.y = mpos.y + yvar

	doSendMagicEffect(mpos, effect)
	doAreaCombatHealth(cid, FIGHTINGDAMAGE, getThingPositionWithDebug(cid), area, -min, -max, 255)

elseif spell == "Grass Knot" then

	doAreaCombatHealth(cid, GRASSDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 45)

elseif spell == "Bone Club" then

	doAreaCombatHealth(cid, GROUNDDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 228)

elseif spell == "Bonemerang" then

	local pos = getThingPositionWithDebug(cid)
	local b = isCreature(getMasterTarget(cid)) and getDirectionTo(getThingPositionWithDebug(cid), getThingPositionWithDebug(target)) or getCreatureLookDir(cid)
	local t = {}

	local signal = {
	[NORTH] = {0,  -1},
	[SOUTH] = {0,  1},
	[EAST] = {1,  0},
	[WEST] = {-1,  0},
	[SOUTHEAST] = {1,  1},
	[SOUTHWEST] = {-1,  1},
	[NORTHWEST] = {-1,  -1},
	[NORTHEAST] = {1,  -1}}

	for range = 1, 5 do
		local add = getThingPositionWithDebug(cid)
		add.x = add.x + signal[b][1] * range
		add.y = add.y + signal[b][2] * range
		table.insert(t, add)
	end

		local function doBoomerang(cid, pos)
			if not isCreature(cid) then return true end
		doAreaCombatHealth(cid, GROUNDDAMAGE, pos, 0, -min, -max, 227)
		end

	for throw = 1, 5 do
		addEvent(doBoomerang, (throw - 1) * 200, cid, t[throw])
	end

	for back = -5, -1 do
		local k = -back
		addEvent(doBoomerang, math.abs(k - 5) * 200 + 1000, cid, t[k])
	end

elseif spell == "Super Vines" then

	doCreatureSetLookDir(cid, 2)
	local a = getCreatureSpeed(cid)
	doChangeSpeed(cid, -a)

	local effect = 0
	local pos = getThingPositionWithDebug(cid)
	pos.x = pos.x + 1
	pos.y = pos.y + 1

	if getCreatureOutfit(cid).lookType == 369 then
		effect = 213
	else
		effect = 229
	end

	doSendMagicEffect(pos, effect)
	doAreaCombatHealth(cid, GRASSDAMAGE, getThingPositionWithDebug(cid), splash, -min, -max, 255)

	local function nois(cid, s)
		if not isCreature(cid) then return true end
	doChangeSpeed(cid, s)
	end

	addEvent(nois, 200, cid, a)

elseif spell == "Electric Field" then

	local t = {}
	local m = getThingPositionWithDebug(cid)
		for x = -6, 6 do
			for y = -6, 6 do
			local pos = {x = m.x + x, y = m.y + y, z = m.z}
			table.insert(t, pos)
			end
		end

	local function doElectricAttack(cid, pos)
		if not isCreature(cid) then return true end
		doAreaCombatHealth(cid, ELECTRICDAMAGE, pos, 0, -min, -max, 48)
		doSendDistanceShoot(pos, {x=pos.x,y=pos.y-8,z=pos.z}, 41)
	end

	for b = 1, 3 do
	for a = 1, #t do
		if #t >= 1 then
		local random = math.random(1, #t)
		addEvent(doElectricAttack, 25 * a, cid, t[random])
		t = doRemoveElementFromTable(t, t[random])
		end
	end
	end

elseif spell == "Electric Storm" then

	local t = {}
	local m = getThingPositionWithDebug(cid)
		for x = -7, 7 do
			for y = -7, 7 do
			local pos = {x = m.x + x, y = m.y + y, z = m.z, stackpos = 0}
			table.insert(t, pos)
			end
		end

	local function doThunderAttack(cid, pos)
		if not isCreature(cid) then return true end
	doAreaCombatHealth(cid, ELECTRICDAMAGE, pos, 0, -min, -max, 48)
	end

	local function doFallThunder(cid, pos)
		if not isCreature(cid) then return true end
		local apos = pos
		local frompos = {x=apos.x-7,y=apos.y-6,z=apos.z}
		doSendDistanceShoot(frompos, pos, 41)
		addEvent(doThunderAttack, 385, cid, pos)
	end

	for a = 1, #t do
		if #t >= 1 then
		local random = math.random(1, #t)
		addEvent(doFallThunder, a * 24, cid, t[random])
		t = doRemoveElementFromTable(t, t[random])
		end
	end

	for randomic = 1, 128 do
		local randompos = {x=m.x+math.random(-6,6),y=m.y+math.random(-6,6),z=m.z}
		addEvent(doFallThunder, randomic * math.random(25, 30), cid, randompos)
	end

elseif spell == "Thunder" then

	local function doThunder(cid, area, pos)
		if not isCreature(cid) then return true end
		doAreaCombatHealth(cid, ELECTRICDAMAGE, pos, area, -min, -max, 48)
	end

	local pos = getThingPositionWithDebug(cid)
	local areas = {destruct1, destruct2, destruct3}

	for go = 0, 2 do
		addEvent(doThunder, go * 250, cid, areas[go+1], pos)
	end

elseif spell == "Strangling Tweezers" then

	local function doStrangle(cid, target, damage)
		if not isCreature(cid) or not isCreature(target) then return true end
		local pos = getThingPositionWithDebug(target)
		local oos = getThingPositionWithDebug(target)
		pos.x = pos.x + 1
		oos.x = oos.x - 1
		doSendDistanceShoot(oos, getThingPositionWithDebug(target), 0)
		doSendDistanceShoot(pos, getThingPositionWithDebug(target), 0)
		if damage then
			doAreaCombatHealth(cid, BUGDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 3)
		end
	end

	for times = 0, 23 do
		if isInArray({5, 10, 15, 20}, times) then
			addEvent(doStrangle, times * 70, cid, target, true)
		else
			addEvent(doStrangle, times * 70, cid, target, false)
		end
	end

elseif spell == "Bubblebeam" then

	local p = getThingPositionWithDebug(cid)

	local function doBubblebeam(cid, area)
		if not isCreature(cid) or not isSightClear(p, area, false) then return true end
	doSendDistanceShoot(p, area, 2)
	doAreaCombatHealth(cid, WATERDAMAGE, area, sand1, -min, -max, 25)
	end

	local a = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)

	if a == 0 then
		for b = 0, 4 do
			local pos = {x = p.x, y = p.y - (b+1), z = p.z}
			addEvent(doBubblebeam, b * 100, cid, pos)
		end
	elseif a == 2 then
		for b = 0, 4 do
			local pos = {x = p.x, y = p.y + (b+1), z = p.z}
			addEvent(doBubblebeam, b * 100, cid, pos)
		end
	elseif a == 1 then
		for b = 0, 4 do
			local pos = {x = p.x + b + 1, y = p.y, z = p.z}
			addEvent(doBubblebeam, b * 100, cid, pos)
		end
	elseif a == 3 then
		for b = 0, 4 do
			local pos = {x = p.x - (b+1), y = p.y, z = p.z}
			addEvent(doBubblebeam, b * 100, cid, pos)
		end
	end

elseif spell == "Mortal Gas" then

	local v1 = (15 + getPokemonLevel(cid)) * 5
		setPlayerStorageValue(cid, 919231, v1)
	local v3 = getPokemonLevel(cid) / 10 + 5

	doAreaCombatHealth(cid, POISONDAMAGE, getThingPositionWithDebug(cid), bomb2, -min, -max, 238)
	doAreaCombatHealth(cid, POISON_POWDERDAMAGE, getThingPositionWithDebug(cid), bomb2, -v3, -v3, 255)

elseif spell == "Fire Mark" then

	local pos = getThingPositionWithDebug(target)

	for x = -1, 1 do
		for y = -1, 1 do
		local frompos = {x = pos.x + x, y = pos.y + y, z = pos.z}
		doSendDistanceShoot(frompos, getThingPositionWithDebug(target), 3)
		end
	end

	doAreaCombatHealth(cid, FIREDAMAGE, pos, 0, -min, -max, 15)

elseif spell == "Focus" or spell == "Concentration" or spell == "Calm Mind" or spell == "Meditate" then

	local effect = 0
	local turns = getPokemonLevel(cid) / 5

	if spell == "Focus" then
		effect = 221
	elseif spell == "Concentration" then
		effect = 220
	else
		effect = 134
	end

	doFocus(cid, turns * 2, effect, getPlayerStorageValue(cid, 253))

elseif spell == "Fear" then

	local rounds  = math.random(2, 5)
		rounds = rounds + getPokemonLevel(cid) / 20
	addEvent(doAdvancedFear, 600, target, rounds, getPlayerStorageValue(target, 3894), cid)

	doSendAnimatedText(getThingPositionWithDebug(target), "SCARED", COLOR_GHOST)

elseif spell == "Poison Jab" then

	local t = {SOUTHWEST, WEST, NORTHWEST, NORTH}

	local function doJab(cid, target, dir)
		if not isCreature(cid) or not isCreature(target) then return true end
	doSendDistanceShoot(getPosByDir(getThingPositionWithDebug(target), dir), getThingPositionWithDebug(target), 20)
	doAreaCombatHealth(cid, POISONDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 252)
	end

	for a = 1, #t do
		addEvent(doJab, a * 45, cid, target, t[a])
	end

elseif spell == "Ground Shaker" then

	local function doShakeGround(cid)
		if not isCreature(cid) then return true end
	doAreaCombatHealth(cid, GROUNDDAMAGE, getThingPositionWithDebug(cid), gsarea, -min, -max, 118)
	end

	for times = 0, 27 do
		addEvent(doShakeGround, times * 300, cid)
	end

elseif spell == "Earthquake" then

	local t = {}
	local m = getThingPositionWithDebug(cid)
		for x = -7, 7 do
			for y = -7, 7 do
			local pos = {x = m.x + x, y = m.y + y, z = m.z, stackpos = 0}
			table.insert(t, pos)
			end
		end

	local function doEarthquake(cid, pos)
		if not isCreature(cid) then return true end
	if not isSightClear(getThingPositionWithDebug(cid), pos, false) then return true end
	if not canWalkOnPos(pos, false, false, false, false, true) then return true end
	doAreaCombatHealth(cid, GROUNDDAMAGE, pos, 0, -min, -max, 255)
	doSendMagicEffect({x = pos.x + 1, y = pos.y + 1, z = pos.z}, 127)
	end

	for a = 1, #t do
		if #t >= 1 then
		local random = math.random(1, #t)
		addEvent(doEarthquake, a * 24, cid, t[random])
		t = doRemoveElementFromTable(t, t[random])
		end
	end	

elseif spell == "Cross Poison" then

	local a = getThingPositionWithDebug(target)
	local b = {}
	doSendDistanceShoot(getPosByDir(getPosByDir(getThingPositionWithDebug(target), NORTHWEST), NORTHWEST), getPosByDir(getThingPositionWithDebug(target), SOUTHEAST), 20)
	doSendDistanceShoot(getPosByDir(getPosByDir(getThingPositionWithDebug(target), NORTHEAST), NORTHEAST), getPosByDir(getThingPositionWithDebug(target), SOUTHWEST), 20)
	doSendDistanceShoot(getPosByDir(getPosByDir(getThingPositionWithDebug(target), SOUTHWEST), SOUTHWEST), getPosByDir(getThingPositionWithDebug(target), NORTHEAST), 20)
	doSendDistanceShoot(getPosByDir(getPosByDir(getThingPositionWithDebug(target), SOUTHEAST), SOUTHEAST), getPosByDir(getThingPositionWithDebug(target), NORTHWEST), 20)
	doSendMagicEffect(a, 114)
	doAreaCombatHealth(cid, POISONDAMAGE, a, 0, -min, -max, 252)

elseif spell == "Seismic Clash" then

	local posicao = getThingPositionWithDebug(cid)
		
	local function clash(params)
	if isCreature(cid) and isSightClear(posicao, params.ar, false) then
	doAreaCombatHealth(cid, GROUNDDAMAGE, params.ar, whirl3, -min, -max, 255)
	doAreaCombatHealth(cid, null, params.ar, params.br, 0, 0, 127)
	end
	end

	local a = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)

	if a == 0 then
		for time = 0, 6 do
			addEvent(clash, time * 120, {cid = cid, ar = {x=posicao.x, y=posicao.y-(time+1), z=posicao.z}, br = clasheffectn})
		end
	elseif a == 2 then
		for time = 0, 6 do
			addEvent(clash, time * 120, {cid = cid, ar = {x=posicao.x, y=posicao.y+(time+1), z=posicao.z}, br = clasheffects})
		end
	elseif a == 1 then
		for time = 0, 6 do
			addEvent(clash, time * 120, {cid = cid, ar = {x=posicao.x+(time+1), y=posicao.y, z=posicao.z}, br = clasheffecte})
		end
	elseif a == 3 then
		for time = 0, 6 do
			addEvent(clash, time * 120, {cid = cid, ar = {x=posicao.x-(time+1), y=posicao.y, z=posicao.z}, br = clasheffectw})
		end
	end

elseif spell == "Lovely Kiss" then

	if getPokemonGender(cid) == getPokemonGender(target) then
		doSendMagicEffect(getThingPositionWithDebug(target), 3)
		doSendAnimatedText(getThingPositionWithDebug(target), "FAIL", COLOR_PINK)	
	return true
	end

	local v1 = math.random(4, 7)
	local v2 = v1 + getPokemonLevel(cid) / 20
	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(target), 16)
	doAreaCombatHealth(cid, SLEEP_POWDERDAMAGE, getThingPositionWithDebug(target), 0, -v1, -v2, 147)

elseif spell == "Sweet Kiss" then

	if getPokemonGender(cid) == getPokemonGender(target) then
		doSendMagicEffect(getThingPositionWithDebug(target), 3)
		doSendAnimatedText(getThingPositionWithDebug(target), "FAIL", COLOR_PINK)	
	return true
	end

	local target = getMasterTarget(cid)
	local rounds = math.random(4, 7)
	rounds = rounds + math.floor(getPokemonLevel(cid) / 35)

	doSendMagicEffect(getThingPositionWithDebug(target), 171)
	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 32)
	addEvent(doAdvancedConfuse, 700, target, rounds, getPlayerStorageValue(target, 3891))

elseif spell == "Metronome" then

	local spells = {
	'Fire Blast', 'Flamethrower', 'Ranging Blast', 'Fire Spin', 'Burning Skin', 'Magma Storm', 'Overheat', 'Heat Wave',
	'Confusion', 'Psychic', 'Psybeam', 'Psywave', 'Psyshock',
	'Water Spout', 'Water Gun', 'Bubble Blast', 'Jet Cannons', 'Surf', 'Aqua Jet', 'Bubblebeam', 'Hydro Cannon', 'Water Oath', 'Water Pledge',
	'Sand Attack', 'Earthshock', 'Shockwave', 'Fissure', 'Bonemerang', 'Ground Shaker', 'Earthquake', 'Seismic Clash', 'Magnitude', 'Earth Power',
	'Spark', 'Thunder Wave', 'Discharge', 'Charge Beam', 'Electric Field', 'Electric Storm', 'Thunder',
	'Restore', 'Recover', 'Selfheal', 'Healarea', 'Sleep Powder', 'Stun Spore', 'Poison Powder',
	'Sing', 'Harden', 'Calm Mind', 'Agility', 'Amnesia', 'Psychic Up', 'Focus', 'Mimic Wall',
	'Invisible', 'Reflect',
	'Gust', 'Whirlwind', 'Wing Attack', 'Tornado', 'Windstorm', 'Wind Vortex', 'Hurricane', 'Aeroblast',
	'Vine Whip', 'Leaf Storm', 'Petal Dance', 'Solar Beam',
	'Toxic', 'Poisonous Wing', 'Poison Gas', 'Slime Wave', 'Mortal Gas',
	'Rock Tomb', 'Falling Rocks', 'Ancient Power', 'Epicenter', 
	'Hyper Beam', 'Hyper Voice', 
	'Blizzard', 'Aurora Beam', 'Ice Beam', 'Powder Snow', 'Frost Breath',
	'Ground Kick', 'Fist Machine', 'Counter',
	'Shadow Storm',
	'Dragon Breath',
	}

	local random = math.random(1, #spells)

	local randommove = spells[random]
	local pos = getThingPositionWithDebug(cid)
	pos.y = pos.y - 1

	doSendMagicEffect(pos, 161)

		local function doUseMetronome(cid, spell)
			if not isCreature(cid) then return true end
			docastspell(cid, spell)
				if isSummon(cid) then
					doCreatureSay(cid, ""..string.upper(spell).."!", TALKTYPE_MONSTER)
				end
		end

	addEvent(doUseMetronome, 890, cid, randommove)

elseif spell == "Flame Wheel" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(target), 3)
	doAreaCombatHealth(cid, FIREDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 15)

	local function doSendEffect(target, direction)
		if not isCreature(target) then return true end
		doSendMagicEffect(getPosByDir(getThingPositionWithDebug(target), direction), 244)
	end

	local dir = {SOUTH, WEST, NORTH, EAST}

	for a = 1, 4 do
		addEvent(doSendEffect, 200 + a * 120, target, dir[a])
	end

elseif spell == "Mimic" then

	doSendMagicEffect(getThingPositionWithDebug(cid), 132)

	local function doCopyAndCast(cid, target)
		if not isCreature(cid) or not isCreature(target) then return true end
		local spell = getPlayerStorageValue(target, 877)
			if spell == -1 then doSendAnimatedText(getThingPositionWithDebug(cid), "FAIL", 215) return true end
			docastspell(cid, spell)
				if isSummon(cid) then
					doCreatureSay(cid, ""..string.upper(spell).."!", TALKTYPE_MONSTER)
				end
	end

	addEvent(doCopyAndCast, 700, cid, target)

elseif spell == "Gastro Acid" then

	local pos = getThingPositionWithDebug(target)
	local t = {}
	local function doGastro(cid, pos, main)
		if not isCreature(cid) then return true end
		if main then
			local highpos = getThingPositionWithDebug(pos)
			highpos.y = highpos.y - 3
			doSendDistanceShoot(highpos, getThingPositionWithDebug(pos), 14)
			doAreaCombatHealth(cid, POISONDAMAGE, getThingPositionWithDebug(pos), 0, -min, -max, 143)
		else
			doAreaCombatHealth(cid, POISONDAMAGE, pos, 0, -min*2, -max*2, 143)
		end
	end

	for a = 0, 3 do
		local targetpos = getPosByDir(getThingPositionWithDebug(target), a)
		local highpos = getPosByDir(getThingPositionWithDebug(target), a)
		highpos.y = highpos.y - 3
		doSendDistanceShoot(highpos, targetpos, 14)
		addEvent(doGastro, 220, cid, targetpos)
		addEvent(doGastro, a * 75, cid, target, true)
	end

elseif spell == "Fury Cutter" then

	local function doCut(cid, target, turn)
		if not isCreature(cid) or not isCreature(target) then return true end
		if getDistanceBetween(getThingPositionWithDebug(cid), getThingPositionWithDebug(target)) >= 3 then return true end
		if turn < 1 then return true end
		doAreaCombatHealth(cid, BUGDAMAGE, getThingPositionWithDebug(target), 0, -min/turn, -max/turn, 141)
		addEvent(doCut, 285, cid, target, turn - 1)
	end

	doCut(cid, target, 10)

elseif spell == "Egg Bomb" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(target), 12)
	doAreaCombatHealthAtDistance(cid, NORMALDAMAGE, getThingPositionWithDebug(target), oathzinho, -min, -max, 3)

elseif spell == "Earth Power" then

	local t = {}
	local p = getThingPositionWithDebug(cid)
	local b = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)

	if b == NORTH then
		for k = -1, 1 do
			local pos = {x = p.x - k, y = p.y - 1, z = p.z}
			table.insert(t, pos)
		end
	elseif b == SOUTH then
		for k = -1, 1 do
			local pos = {x = p.x - k, y = p.y + 1, z = p.z}
			table.insert(t, pos)
		end
	elseif b == EAST then
		for k = -1, 1 do
			local pos = {x = p.x + 1, y = p.y + k, z = p.z}
			table.insert(t, pos)
		end
	elseif b == WEST then
		for k = -1, 1 do
			local pos = {x = p.x - 1, y = p.y + k, z = p.z}
			table.insert(t, pos)
		end
	end

	local function doEarthPower(cid, pos)
		if not isCreature(cid) then return true end
		doAreaCombatHealth(cid, GROUNDDAMAGE, pos, 0, -min, -max, 255)
		local a = {x=pos.x+1,y=pos.y+1,z=pos.z}
		doSendMagicEffect(a, 127)
		--doSendDistanceShoot(pos, {x=pos.x,y=pos.y-6,z=pos.z}, 42)		
	end

	for times = 1, 3 do
		doEarthPower(cid, t[times])
	end

elseif spell == "Magnitude" then

	local t = {}
	local m = getThingPositionWithDebug(cid)
	local target = 0
		for x = -4, 4 do
			for y = -4, 4 do
			local pos = {x = m.x + x, y = m.y + y, z = m.z, stackpos = 0}
			table.insert(t, pos)
			end
		end

	local mag = {4, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 10}
	local magnitude = math.random(4, 10)--mag[math.random(#mag)]

	doSendAnimatedText(getThingPositionWithDebug(cid), magnitude, COLOR_GROUND)

	local rate = magnitude - 3

	local function doCrackGround(cid, posa, checkone, checktwo, target)
		if not isCreature(cid) then return true end
	local pos = {}
	if checkone and isCreature(target) then
		pos = getThingPositionWithDebug(target)
	else
		pos = posa
	end
		if checktwo and isCreature(target) and getTopCreature(pos).uid == target then
		return true
		end
	doAreaCombatHealth(cid, GROUNDDAMAGE, pos, 0, -min*rate, -max*rate, 255)
	local a = {x=pos.x+1,y=pos.y+1,z=pos.z}
	doSendMagicEffect(a, 127)
	end

	if isCreature(getMasterTarget(cid)) and getDistanceBetween(getThingPositionWithDebug(getMasterTarget(cid)), m) <= 7 then
		target = getMasterTarget(cid)
		local n = getThingPositionWithDebug(target)
		local npos = {x = n.x, y = n.y, z = n.z, stackpos = 0}
		magnitude = magnitude - 1
		addEvent(doCrackGround, 1050, cid, npos, true, false, target)
	end

	for this = 1, magnitude do
	local random = math.random(1, #t)
	addEvent(doCrackGround, 1050, cid, t[random], false, true, target)
	t = doRemoveElementFromTable(t, t[random])
	end

elseif spell == "Pay Day" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(target), 37)

	if isSummon(cid) then
		for a = 1, 3 do
			if math.random(1, 100) > 40 then
			local x = getPokemonLevel(cid)
			x = x * math.random(40, 160) / 100
				if x > 100 then
					x = 100
				end
			local npos = getPosByDir(getThingPositionWithDebug(target), math.random(0, 7))
			if canWalkOnPos(npos, false, false, true, true, true) then
				doCreateItem(12416, x, npos)
			end
			end
		end
	end
	

	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 3)

elseif spell == "Mimic Wall" then

	if hasMimicWall(cid) then
	local health = getSpecialAttack(cid) * 2
	setPlayerStorageValue(cid, 878, getPlayerStorageValue(cid, 878) + health)
	return true end

	local function doCreateWall(cid)
		if not isCreature(cid) then return true end
		local health = getSpecialAttack(cid) * 2
		setPlayerStorageValue(cid, 878, health)
			if getCreatureLookDir(cid) == SOUTH or getCreatureLookDir(cid) == NORTH then
				doCreateItem(11439, 1, getThingPositionWithDebug(cid))
			else
				doCreateItem(11440, 1, getThingPositionWithDebug(cid))
			end
	end

	local function doEndWallTime(cid)
		if not isCreature(cid) then return true end
		setPlayerStorageValue(cid, 878, -1)
	local b = getTileItemById(getThingPositionWithDebug(cid), 11440)
	if b.uid > 1 then doRemoveItem(b.uid, 1) end
	local c = getTileItemById(getThingPositionWithDebug(cid), 11439)
	if c.uid > 1 then doRemoveItem(c.uid, 1) end	
		doSendMagicEffect(getThingPositionWithDebug(cid), 3)
	end

	doSendMagicEffect(getThingPositionWithDebug(cid), 135)

		addEvent(doCreateWall, 650, cid)
		addEvent(doEndWallTime, 17 * 1000, cid)

elseif spell == "Counter" then

	setPlayerStorageValue(cid, 879, 1)
	doSendMagicEffect(getThingPositionWithDebug(cid), 247)

elseif spell == "Overheat" then

	for a = -7, 7 do
		for b = -6, 6 do
		local pos = getThingPositionWithDebug(cid)
		local place = {x=pos.x+a,y=pos.y+b,z=pos.z}
		doSendDistanceShoot(getThingPositionWithDebug(cid), place, 3)
		end
	end

	doAreaCombatHealth(cid, FIREDAMAGE, getThingPositionWithDebug(cid), grassarea, -min, -max, 255)

elseif spell == "Mind Blast" then

	local function doFindMind(cid, pos, target, effect, distance)
		if not isCreature(target) then return true end
		if not isCreature(cid) then return true end
		if getDistanceBetween(getThingPositionWithDebug(target), pos) == 0 then
			local bonus = distance * 0.34 + 0.76
			doAreaCombatHealth(cid, PSYCHICDAMAGE, getThingPositionWithDebug(target), 0, -min * bonus, -max * bonus, 243)
		return true
		end
	doSendMagicEffect(pos, effect)
	local dir = getDirectionTo(pos, getThingPositionWithDebug(target))
		if dir >= 4 then
			dir = randomdiagonaldir[dir][math.random(1, 2)]
		end
	local a = getPosByDir(pos, dir)
	local nextef = 133
		if effect == 133 then
			nextef = 136
		end
	addEvent(doFindMind, 175, cid, a, target, nextef, distance + 1)
	end

	doFindMind(cid, getThingPositionWithDebug(cid), getMasterTarget(cid), 133, 0)

elseif spell == "Future Sight" then

	local function doFutureSight(cid, target)
		if not isCreature(cid) or not isCreature(target) then return true end
	doAreaCombatHealth(cid, PSYCHICDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 253)
	end

	doSendMagicEffect(getThingPositionWithDebug(cid), 220)

	addEvent(doFutureSight, 2500, cid, target)

elseif spell == "Shell Smash" then
	
	doBodyPush(cid, target, true)
	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 223)

elseif spell == "Heat Wave" then

	local posicao = getThingPositionWithDebug(cid)

	local function hw(params)
	if isCreature(params.cid) and isSightClear(posicao, params.ar, false) then
	doAreaCombatHealth(cid, FIREDAMAGE, params.ar, whirl3, -min, -max, 237)
	end
	end

	local a = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)

	if a == 0 then
		for b = 0, 4 do
			addEvent(hw, 200 * b, {cid = cid, ar = {x=posicao.x, y=posicao.y-(b+1), z=posicao.z}})
		end
	elseif a == 2 then
		for b = 0, 4 do
			addEvent(hw, 200 * b, {cid = cid, ar = {x=posicao.x, y=posicao.y+(b+1), z=posicao.z}})
		end
	elseif a == 1 then
		for b = 0, 4 do
			addEvent(hw, 200 * b, {cid = cid, ar = {x=posicao.x+(1+b), y=posicao.y, z=posicao.z}})
		end
	elseif a == 3 then
		for b = 0, 4 do
			addEvent(hw, 200 * b, {cid = cid, ar = {x=posicao.x-(1+b), y=posicao.y, z=posicao.z}})
		end
	end

elseif spell == "Hydro Cannon" then

	local posicao = getThingPositionWithDebug(cid)

	local function hp(params)
	if isCreature(params.cid) and isSightClear(posicao, params.ar, false) then
	doAreaCombatHealth(cid, WATERDAMAGE, params.ar, whirl3, -min, -max, 68)
	end
	end

	local a = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)

	if a == 0 then
		for b = 0, 5 do
			addEvent(hp, 100 * b, {cid = cid, ar = {x=posicao.x, y=posicao.y-(b+1), z=posicao.z}})
		end
	elseif a == 2 then
		for b = 0, 5 do
			addEvent(hp, 100 * b, {cid = cid, ar = {x=posicao.x, y=posicao.y+(b+1), z=posicao.z}})
		end
	elseif a == 1 then
		for b = 0, 5 do
			addEvent(hp, 100 * b, {cid = cid, ar = {x=posicao.x+(1+b), y=posicao.y, z=posicao.z}})
		end
	elseif a == 3 then
		for b = 0, 5 do
			addEvent(hp, 100 * b, {cid = cid, ar = {x=posicao.x-(1+b), y=posicao.y, z=posicao.z}})
		end
	end

elseif spell == "Frost Attack" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(getMasterTarget(cid)), 28)
	doAreaCombatHealthAtDistance(cid, ICEDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), bomb, -min, -max, 43)

elseif spell == "Frost Breath" then

	local posicao = getThingPositionWithDebug(cid)

	local function fb(params)
	if isCreature(params.cid) and isSightClear(posicao, params.ar, false) then
	doAreaCombatHealth(cid, ICEDAMAGE, params.ar, sand1, -min, -max, 52)
	end
	end

	local a = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)

	if a == 0 then
		for b = 0, 5 do
			addEvent(fb, 120 * b, {cid = cid, ar = {x=posicao.x, y=posicao.y-(b+1), z=posicao.z}})
		end
	elseif a == 2 then
		for b = 0, 5 do
			addEvent(fb, 120 * b, {cid = cid, ar = {x=posicao.x, y=posicao.y+(b+1), z=posicao.z}})
		end
	elseif a == 1 then
		for b = 0, 5 do
			addEvent(fb, 120 * b, {cid = cid, ar = {x=posicao.x+(1+b), y=posicao.y, z=posicao.z}})
		end
	elseif a == 3 then
		for b = 0, 5 do
			addEvent(fb, 120 * b, {cid = cid, ar = {x=posicao.x-(1+b), y=posicao.y, z=posicao.z}})
		end
	end

elseif spell == "Psystrike" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(target), 30)
	doAreaCombatHealthAtDistance(cid, PSYCHICDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 250)

elseif spell == "Psycho Flash" then

	doAreaCombatHealth(cid, PSYCHICDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 240)
	local rounds = math.random(6, 10)
	rounds = rounds + math.floor(getPokemonLevel(cid) / 15)
	doAdvancedBlind(target, rounds, getPlayerStorageValue(target, 3890), 136)

elseif spell == "Electro Ball" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(target), 40)
	doAreaCombatHealthAtDistance(cid, ELECTRICDAMAGE, getThingPositionWithDebug(target), bomb, -min, -max, 48) 

elseif spell == "Metal Claw" then

	doAreaCombatHealth(cid, STEELDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 160)

elseif spell == "Vital Throw" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(target), 26)
	doAreaCombatHealth(cid, FIGHTDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 112)

elseif spell == "Seismic Toss" then

		local function doHit(cid, target)
			if not isCreature(target) or not isCreature(cid) then return true end
		doAreaCombatHealth(cid, SEISMICTOSSDAMAGE, getThingPositionWithDebug(target), 0, -10, -10, 3)
		end

		local function doTossFall(cid, frompos, target)
			if not isCreature(target) or not isCreature(cid) then return true end
		local pos = getThingPositionWithDebug(target)
		local ry = math.abs(frompos.y - pos.y)
		doSendDistanceShoot(frompos, getThingPositionWithDebug(target), 11)
		addEvent(doHit, ry * 40, cid, target)
		end

		local function doTossUp(cid, target)
			if not isCreature(target) or not isCreature(cid) then return true end
		local pos = getThingPositionWithDebug(target)
		local mps = getThingPositionWithDebug(cid)
		local xrg = math.floor((pos.x - mps.x) / 2)
		local topos = mps
		topos.x = topos.x + xrg
		local rd =  11
		topos.y = topos.y - rd
		doSendDistanceShoot(getThingPositionWithDebug(cid), topos, 11)
		addEvent(doTossFall, rd * 49, cid, topos, target)
		end		

	local alvo = getMasterTarget(cid)
		
	doTossUp(cid, alvo)

elseif spell == "Rock Blast" then

	doAreaCombatHealth(cid, ROCKDAMAGE, getThingPositionWithDebug(cid), rockblast, -min, -max, 255)

	local pos = getThingPositionWithDebug(cid)

	local function doSendRock(cid, pos)
		if not isCreature(cid) then return true end
	doSendDistanceShoot(getThingPositionWithDebug(cid), pos, 11)
	addEvent(doSendMagicEffect, getDistanceBetween(getThingPositionWithDebug(cid), pos) * 54, pos, 118)
	end

	for a = 1, 120 do
		local lugar = {x = pos.x + math.random(-4, 4), y = pos.y + math.random(-4, 4), z = pos.z}
		addEvent(doSendRock, a * 2, cid, lugar)
	end

elseif spell == "Submission" then

	local a = getPosByDir(getThingPositionWithDebug(target), getFaceOpposite(getCreatureLookDir(target)))
	local b = getClosestFreeTile(cid, a)
	doTeleportThing(cid, b, false)
	doSendMagicEffect(getThingPositionWithDebug(cid), 211)
	doFaceCreature(cid, getThingPositionWithDebug(target))
	doAreaCombatHealth(cid, FIGHTINGDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 112)

elseif spell == "Close Combat" then

	local a = getCreatureSpeed(target)
	local b = getCreatureSpeed(cid)
	doTeleportThing(cid, getThingPositionWithDebug(target), false)
	doSendMagicEffect(getThingPositionWithDebug(cid), 211)
	doChangeSpeed(cid, -b)
	doChangeSpeed(target, -a)

	local function reputSpeed(cid, delta)
		if not isCreature(cid) then return true end
		if getCreatureSpeed(cid) > 0 then return true end
	doChangeSpeed(cid, delta)
	end

	local function doCloseCombat(cid, target, finish)
		if not isCreature(cid) or not isCreature(target) or finish then
		reputSpeed(cid, b)
		addEvent(reputSpeed, 400, target, a)
		return true end
	doSendMagicEffect(getThingPositionWithDebug(cid), CONST_ME_POFF)
	doAreaCombatHealth(cid, FIGHTDAMAGE, getThingPositionWithDebug(cid), 0, -min, -max, math.random(112, 113))
	end

	for dk = 1, 6 do
		if dk == 6 then
			addEvent(doCloseCombat, dk * 175, cid, target, true)
		else
			addEvent(doCloseCombat, dk * 175, cid, target)
		end
	end	

elseif spell == "Squisky Licking" then


	local function doLick(cid, target)
	if not isCreature(cid) or not isCreature(target) then return true end
	doAreaCombatCondition(cid, getThingPositionWithDebug(target), 0, thunderwavecondition, 255)
	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 145)
	end

	for a = 0, 4 do
		addEvent(doLick, a * 350, cid, target)
	end

elseif spell == "Crusher Stomp" then

	doSendMagicEffect(getThingPositionWithDebug(target), 248)
	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(target), powdersc, -min, -max, 223)

elseif spell == "Ancient Power" then

	local t = {}
	local m = getThingPositionWithDebug(cid)
		for x = -5, 5 do
			for y = -5, 5 do
			local pos = {x = m.x + x, y = m.y + y, z = m.z}
			table.insert(t, pos)
			end
		end

	local function doRockDestroy(cid, pos)
		if not isCreature(cid) then return true end
	doAreaCombatHealth(cid, ROCKDAMAGE, pos, round, -min, -max, 255)
	doSendMagicEffect(pos, 235)
	end

	local function doRockDown(cid, frompos, pos)
		if not isCreature(cid) then return true end
		doSendDistanceShoot(frompos, pos, 42)
		addEvent(doRockDestroy, 300, cid, pos)
	end

	local function doRockUp(cid, pos)
		if not isCreature(cid) then return true end
		local topos = {x=pos.x-1,y=pos.y-5,z=pos.z}
		doSendDistanceShoot(pos, topos, 42)
		doSendMagicEffect(pos, 247)
		addEvent(doRockDown, 300, cid, topos, pos)
	end

	for b = 1, 3 do
	for a = 1, #t do
		if #t >= 1 then
		local random = math.random(1, #t)
		addEvent(doRockUp, 45 * a, cid, t[random])
		t = doRemoveElementFromTable(t, t[random])
		end
	end
	end

elseif spell == "Water Pledge" then

	local function doPledge(cid)
		if not isCreature(cid) then return true end
	local a = getPosByDir(getThingPositionWithDebug(cid), NORTH)
	local b = getPosByDir(getThingPositionWithDebug(cid), WEST)
	local c = getPosByDir(getThingPositionWithDebug(cid), SOUTH)
	local d = getPosByDir(getThingPositionWithDebug(cid), EAST)
		doSendDistanceShoot(a, b, 2)
		doSendDistanceShoot(b, c, 2)
		doSendDistanceShoot(c, d, 2)
		doSendDistanceShoot(d, a, 2)
	doAreaCombatHealth(cid, WATERDAMAGE, getThingPositionWithDebug(cid), splash, -min, -max, 255)
	end

	for a = 0, 3 do
		addEvent(doPledge, a * 215, cid)
	end

elseif spell == "Water Oath" then

	local t = {}

	for a = 0, 3 do
		local a = getPosByDir(getThingPositionWithDebug(target), a)
		table.insert(t, a)
	end

	local frompos = getThingPositionWithDebug(target)
		frompos.y = frompos.y - 4

	for b = 1, #t do
		doSendDistanceShoot(frompos, t[b], 2)
	end

	doSendDistanceShoot(frompos, getThingPositionWithDebug(target), 2)

	doAreaCombatHealth(cid, WATERDAMAGE, getThingPositionWithDebug(target), oathzinho, -min, -max, 68)

elseif spell == "Thrash" then

	local function doThrash(cid, target, go, turn, pos)
		if not isCreature(cid) or not isCreature(target) then
		doRegainSpeed(cid)
		doRegainSpeed(target)
		return true
		end
		if go then
			local a = getPosByDir(getThingPositionWithDebug(target), getDirectionTo(getThingPositionWithDebug(cid), getThingPositionWithDebug(target)))
			doChangeSpeed(cid, -getCreatureSpeed(cid))
			doChangeSpeed(target, -getCreatureSpeed(target))
			doChangeSpeed(cid, 800)
			doTeleportThing(cid, getThingPositionWithDebug(target))
			doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(getMasterTarget(cid)), 0, -min, -max, 3)
			doChangeSpeed(cid, -800)
			addEvent(doThrash, 175, cid, target, false, turn - 1, a)
		else
			doChangeSpeed(cid, 800)
			doTeleportThing(cid, pos)
			doRegainSpeed(cid)
			doRegainSpeed(target)
				if turn > 0 then
					addEvent(doThrash, 175, cid, target, true, turn)
				else
					doRegainSpeed(cid)
					doRegainSpeed(target)
					addEvent(doAdvancedConfuse, 350, cid, 4, getPlayerStorageValue(target, 3891))
					local b = getThingPositionWithDebug(cid)
					addEvent(doSendAnimatedText, 300, b, "CONFUSED", 210)
				end
		end
	end

	doThrash(cid, target, true, 3)	

elseif spell == "Reflect" then

	doSendMagicEffect(getThingPositionWithDebug(cid), 135)

	if getPlayerStorageValue(cid, 34) > 0 then
		setPlayerStorageValue(cid, 34, getPlayerStorageValue(cid, 34) + 9)
	return true
	end

	setPlayerStorageValue(cid, 34, 9)

	local function doEndReflect(cid)
		if not isCreature(cid) then return true end
		if getPlayerStorageValue(cid, 34) == 0 then
			doSendAnimatedText(getThingPositionWithDebug(cid), "BREAK", 180)
		return true
		end
	setPlayerStorageValue(cid, 34, getPlayerStorageValue(cid, 34) - 1)
	addEvent(doEndReflect, 500, cid)
	end

	addEvent(doEndReflect, 500, cid)

elseif spell == "Dragon Breath" then

	local posicao = getThingPositionWithDebug(cid)
		
	local function wwind(params)
	if isCreature(cid) and isSightClear(posicao, params.ar, false) then
	doAreaCombatHealth(cid, DRAGONDAMAGE, params.ar, params.br, -min, -max, 246)
	end
	end

	local a = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)

	if a == 0 then
		addEvent(wwind, 0, {cid = cid, ar = {x=posicao.x, y=posicao.y-1, z=posicao.z}, br = sand1})
		addEvent(wwind, 350, {cid = cid, ar = {x=posicao.x, y=posicao.y-2, z=posicao.z}, br = whirl3})
		addEvent(wwind, 700, {cid = cid, ar = {x=posicao.x, y=posicao.y-3, z=posicao.z}, br = whirl3})
		addEvent(wwind, 1050, {cid = cid, ar = {x=posicao.x, y=posicao.y-4, z=posicao.z}, br = whirl5})
		addEvent(wwind, 1400, {cid = cid, ar = {x=posicao.x, y=posicao.y-5, z=posicao.z}, br = whirl5})
	elseif a == 2 then
		addEvent(wwind, 0, {cid = cid, ar = {x=posicao.x, y=posicao.y+1, z=posicao.z}, br = sand1})
		addEvent(wwind, 350, {cid = cid, ar = {x=posicao.x, y=posicao.y+2, z=posicao.z}, br = whirl3})
		addEvent(wwind, 700, {cid = cid, ar = {x=posicao.x, y=posicao.y+3, z=posicao.z}, br = whirl3})
		addEvent(wwind, 1050, {cid = cid, ar = {x=posicao.x, y=posicao.y+4, z=posicao.z}, br = whirl5})
		addEvent(wwind, 1400, {cid = cid, ar = {x=posicao.x, y=posicao.y+5, z=posicao.z}, br = whirl5})
	elseif a == 1 then
		addEvent(wwind, 0, {cid = cid, ar = {x=posicao.x+1, y=posicao.y, z=posicao.z}, br = sand1})
		addEvent(wwind, 350, {cid = cid, ar = {x=posicao.x+2, y=posicao.y, z=posicao.z}, br = whirl32})
		addEvent(wwind, 700, {cid = cid, ar = {x=posicao.x+3, y=posicao.y, z=posicao.z}, br = whirl32})
		addEvent(wwind, 1050, {cid = cid, ar = {x=posicao.x+4, y=posicao.y, z=posicao.z}, br = whirl52})
		addEvent(wwind, 1400, {cid = cid, ar = {x=posicao.x+5, y=posicao.y, z=posicao.z}, br = whirl52})
	elseif a == 3 then
		addEvent(wwind, 0, {cid = cid, ar = {x=posicao.x-1, y=posicao.y, z=posicao.z}, br = sand1})
		addEvent(wwind, 350, {cid = cid, ar = {x=posicao.x-2, y=posicao.y, z=posicao.z}, br = whirl32})
		addEvent(wwind, 700, {cid = cid, ar = {x=posicao.x-3, y=posicao.y, z=posicao.z}, br = whirl32})
		addEvent(wwind, 1050, {cid = cid, ar = {x=posicao.x-4, y=posicao.y, z=posicao.z}, br = whirl52})
		addEvent(wwind, 1400, {cid = cid, ar = {x=posicao.x-5, y=posicao.y, z=posicao.z}, br = whirl52})
	end

elseif spell == "Flare Blitz" then

	doAreaCombatHealth(cid, FIREDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 232)

elseif spell == "Seed Bomb" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(target), 4)
	doAreaCombatHealthAtDistance(cid, GRASSDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 45)

elseif spell == "Magical Leaves" then

	local function doIt(cid, target, x, y)
		if not isCreature(cid) or not isCreature(target) then return true end
		local a = getThingPositionWithDebug(target)
		local pos = {x = a.x + x, y = a.y + y, z = a.z}
		doAreaCombatHealth(cid, GRASSDAMAGE, pos, 0, -min, -max, 255)
		doSendDistanceShoot({x = pos.x, y = pos.y - 1, z = pos.z}, {x = pos.x - 1, y = pos.y, z = pos.z}, 21)
		doSendDistanceShoot({x = pos.x - 1, y = pos.y, z = pos.z}, {x = pos.x, y = pos.y + 1, z = pos.z}, 21)
		doSendDistanceShoot({x = pos.x, y = pos.y + 1, z = pos.z}, {x = pos.x + 1, y = pos.y, z = pos.z}, 21)
		doSendDistanceShoot({x = pos.x + 1, y = pos.y, z = pos.z}, {x = pos.x, y = pos.y - 1, z = pos.z}, 21)
	end

	local regions = {
	[1] = {-1, 0},
	[2] = {0, -1},
	[3] = {1, 0},
	[4] = {0, 1},
	[5] = {0, 0}}

	local function doHurt(cid, target)
	doMagicalFlower(target, true)
	for tk = 1, 5 do
		for a = 0, 2 do
			addEvent(doIt, a * 185, cid, target, regions[tk][1], regions[tk][2])
			if a == 2 then
				addEvent(doMagicalFlower, a * 184, target)
			end
		end
	end
	end

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(target), 21)
	addEvent(doHurt, getDistanceBetween(getThingPositionWithDebug(cid), getThingPositionWithDebug(target)) * 60, cid, target)

elseif spell == "Tidal Wave" then

	local posicao = getThingPositionWithDebug(cid)

	local function doSurf(cid, area1, area2, effect)
		if not isCreature(cid) then return true end
		if not isSightClear(posicao, area1, false) then return true end
		doAreaCombatHealth(cid, null, area1, whirl5, -min, -max, effect)
			if area2.x ~= getThingPositionWithDebug(cid).x or area2.y ~= getThingPositionWithDebug(cid).y then
				doAreaCombatHealth(cid, null, area2, whirl5, -min, -max, 68)
			end
		doAreaCombatHealth(cid, WATERDAMAGE, area1, whirl5, -min, -max, 68)
	end

	local n = isCreature(getMasterTarget(cid)) and getCreatureDirectionToTarget(cid, getMasterTarget(cid)) or getCreatureLookDir(cid)

	if n == 0 then
		for a = 0, 6 do
			addEvent(doSurf, 300 * a, cid, {x = posicao.x, y = posicao.y - (a + 1), z = posicao.z}, {x = posicao.x, y = posicao.y - a, z = posicao.z}, 66)
		end
	elseif n == 2 then
		for a = 0, 6 do
			addEvent(doSurf, 300 * a, cid, {x = posicao.x, y = posicao.y + (a + 1), z = posicao.z}, {x = posicao.x, y = posicao.y + a, z = posicao.z}, 64)
		end
	elseif n == 1 then
		for a = 0, 6 do
			addEvent(doSurf, 300 * a, cid, {x = posicao.x + a + 1, y = posicao.y, z = posicao.z}, {x = posicao.x + a, y = posicao.y, z = posicao.z}, 67)
		end
	elseif n == 3 then
		for a = 0, 6 do
			addEvent(doSurf, 300 * a, cid, {x = posicao.x - (a + 1), y = posicao.y, z = posicao.z}, {x = posicao.x - a, y = posicao.y, z = posicao.z}, 65)
		end
	end

elseif spell == "Epicenter" then

	local function doShake(cid, pos)
		if not isCreature(cid) then return true end
		doAreaCombatHealth(cid, GROUNDDAMAGE, pos, 0, -min, -max, 255)
		doSendMagicEffect({x=pos.x+1,y=pos.y+1,z=pos.z}, 127)
	end

	local function getDifBetween(pos1, pos2)
		local a = pos1.x - pos2.x
		local b = pos1.y - pos2.y
		return math.abs(a) + math.abs(b)
	end

	local t = {}

	for x = -7, 7 do
		for y = -7, 7 do
		local a = getThingPositionWithDebug(cid)
		a.x = a.x + x
		a.y = a.y + y
		table.insert(t, a)
		end
	end


	local pos = getThingPositionWithDebug(cid)
	local delay = 0

	for go = 1, #t do
		if getDirectionTo(pos, t[go]) <= 3 then
			delay = 0
		else
			if math.abs(t[go].x - pos.x) == math.abs(t[go].y - pos.y) then
				delay = 300
			else
				delay = 450
			end
		end
		if delay >= 0  then
		addEvent(doShake, getDistanceBetween(pos, t[go]) * 120 + delay, cid, t[go])
		end
	end

elseif spell == "Stone Edge" then

	local signal = {
	[NORTH] = {1, 0},
	[SOUTH] = {1, 0},
	[EAST] = {0, 1},
	[WEST] = {0, 1},
	[NORTHEAST] = {-1, -1},
	[NORTHWEST] = {1, -1},
	[SOUTHEAST] = {-1, 1},	
	[SOUTHWEST] = {-1, -1}}

	local a = getDirectionTo(getThingPositionWithDebug(cid), getThingPositionWithDebug(target))
	local pos1 = getThingPositionWithDebug(target)
	local pos2 = getThingPositionWithDebug(target)
	pos1.x = pos1.x + signal[a][1] * 5
	pos1.y = pos1.y + signal[a][2] * 5
	pos2.x = pos2.x + signal[a][1] * -5
	pos2.y = pos2.y + signal[a][2] * -5

	doSendDistanceShoot(pos1, getThingPositionWithDebug(target), 11)
	doSendDistanceShoot(pos2, getThingPositionWithDebug(target), 11)

	local function doDamage(cid, target)
		if not isCreature(cid) or not isCreature(target) then return true end
	doAreaCombatHealth(cid, ROCKDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 44)
	end

	addEvent(doDamage, 300, cid, target)
	
elseif spell == "Night Shade" then

	doSendDistanceShoot(getThingPositionWithDebug(cid), getThingPositionWithDebug(target), 39)
	doAreaCombatHealthAtDistance(cid, GHOSTDAMAGE, getThingPositionWithDebug(target), star, -min, -max, 17)

elseif spell == "Razor Wind" then

	local signal = {
	[NORTH] = {0, -1},
	[SOUTH] = {0, 1},
	[EAST] = {1, 0},
	[WEST] = {-1, 0},
	[NORTHEAST] = {1, -1},
	[NORTHWEST] = {-1, -1},
	[SOUTHEAST] = {1, 1},	
	[SOUTHWEST] = {-1, 1}}

	local a = isCreature(target) and getDirectionTo(getThingPositionWithDebug(cid), getThingPositionWithDebug(target)) or getCreatureLookDir(cid)
	local t = {}

	for b = 1, 5 do
		local pos = getThingPositionWithDebug(cid)
		pos.x = pos.x + signal[a][1] * b
		pos.y = pos.y + signal[a][2] * b
			if canWalkOnPos(pos, false, true, true, true, false) and isSightClear(getThingPositionWithDebug(cid), pos, false) then
				table.insert(t, pos)
			end
	end

	if #t <= 0 then
		doAreaCombatHealth(cid, FLYINGDAMAGE, getPosByDir(getThingPositionWithDebug(cid), a), 0, -min, -max, 42)
	return true
	end

	local effect = 27

	if not getCreatureCondition(cid, CONDITION_OUTFIT) and getCreatureOutfit(cid).lookType ~= 366 then
		effect = 29
	end

	doSendDistanceShoot(getThingPositionWithDebug(cid), t[#t], effect)

	local function doRazorWind(cid, pos)
		if not isCreature(cid) then return true end
		if not getCreatureCondition(cid, CONDITION_INVISIBLE) then return true end
		doAreaCombatHealth(cid, FLYINGDAMAGE, pos, 0, -min, -max, 42)
	end

	local function doAppear(cid, pos)
		if not isCreature(cid) then return true end
	doRemoveCondition(cid, CONDITION_INVISIBLE)
	doTeleportThing(cid, pos, false)
	end

	doCreatureAddCondition(cid, permanentinvisible)

	for c = 1, #t do
		addEvent(doRazorWind, 65 * c, cid, t[c])
	end
		addEvent(doAppear, (90 - (#t * 6)) * #t, cid, t[#t])
	
elseif spell == "Swords Dance" then

	local function doWingAttack(cid, a, damage)
		local damagearea = {}
		local effectpos = getThingPositionWithDebug(cid)
		local effect = 255
	if a == 0 then
		effect = 128
		effectpos.x = effectpos.x + 1
		effectpos.y = effectpos.y - 1
		damagearea = wingdn
	elseif a == 1 then
		effectpos.x = effectpos.x + 2
		effectpos.y = effectpos.y + 1
		effect = 129
		damagearea = wingde
	elseif a == 2 then
		effectpos.x = effectpos.x + 1
		effectpos.y = effectpos.y + 2
		effect = 131
		damagearea = wingds
	elseif a == 3 then
		effectpos.x = effectpos.x - 1
		effectpos.y = effectpos.y + 1
		effect = 130
		damagearea = wingdw
	end
		doSendMagicEffect(effectpos, effect)
		if damage then
		doAreaCombatHealth(cid, FLYINGDAMAGE, getThingPositionWithDebug(cid), damagearea, -min, -max, CONST_ME_NONE)
		end
	end

	local dire = getCreatureLookDir(cid)
	local cpos = getThingPositionWithDebug(cid)
	local outfit = {}
		outfit.lookType = 496

	if getCreatureOutfit(cid).lookType ~= 366 then
		outfit.lookType = 849
	end

	doSetCreatureOutfit(cid, outfit, -1)

	local function doDance(cid, dir, damage)
		if not isCreature(cid) then return true end
	doCreatureSetLookDir(cid, dir)
	doWingAttack(cid, dir, damage)
	end

	for times = 0, 20 do
		for directions = 0, 3 do
			addEvent(doDance, times * 300, cid, directions, true)
		end
	end

	local function doChangeO(cid, dir, pos)
	if not isCreature(cid) then return true end
	doRemoveCondition(cid, CONDITION_OUTFIT)
		if getThingPositionWithDebug(cid).x == pos.x and getThingPositionWithDebug(cid).y == pos.y then
			doCreatureSetLookDir(cid, dir)
		end
	end

	addEvent(doChangeO, 20 * 300 + 10, cid, dire, cpos)

elseif spell == "Rest" then

	local function doRecoverOverTime(cid, turn)
		if not isCreature(cid) then return true end
		if not isSleeping(cid) then return true end
		if turn > 100 then return true end
		local percent = math.floor(getCreatureMaxHealth(cid) / 100)
		doCreatureAddHealth(cid, percent)
		addEvent(doRecoverOverTime, 100, cid, turn + 1)
	end

	doSleep(cid, 12, true)
	doRecoverOverTime(cid, 0)

elseif spell == "Stickslash" then

	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 212)

elseif spell == "Stickmerang" then

	local pos = getThingPositionWithDebug(cid)
	local b = isCreature(getMasterTarget(cid)) and getDirectionTo(getThingPositionWithDebug(cid), getThingPositionWithDebug(target)) or getCreatureLookDir(cid)
	local t = {}

	local signal = {
	[NORTH] = {0,  -1},
	[SOUTH] = {0,  1},
	[EAST] = {1,  0},
	[WEST] = {-1,  0},
	[SOUTHEAST] = {1,  1},
	[SOUTHWEST] = {-1,  1},
	[NORTHWEST] = {-1,  -1},
	[NORTHEAST] = {1,  -1}}

	for range = 1, 5 do
		local add = getThingPositionWithDebug(cid)
		add.x = add.x + signal[b][1] * range
		add.y = add.y + signal[b][2] * range
		table.insert(t, add)
	end

		local function doBoomerang(cid, pos)
			if not isCreature(cid) then return true end
		doAreaCombatHealth(cid, NORMALDAMAGE, pos, 0, -min, -max, 212)
		end

	for throw = 1, 5 do
		addEvent(doBoomerang, (throw - 1) * 200, cid, t[throw])
	end

	for back = -5, -1 do
		local k = -back
		addEvent(doBoomerang, math.abs(k - 5) * 200 + 1000, cid, t[k])
	end

elseif spell == "Comet Punch" then

	local pos = getThingPositionWithDebug(target)
	pos.y = pos.y - 5
	doSendDistanceShoot(pos, getThingPositionWithDebug(target), 26)

	local function doPunchie(cid, target)
		if not isCreature(cid) or not isCreature(target) then return true end
		doAreaCombatHealth(cid, FIGHTDAMAGE, getThingPositionWithDebug(target), 0, -min, -max, 249)
	end

	addEvent(doPunchie, const_distance_delay * 5, cid, target)

else

print("Error trying to cast move. Pokemon: ["..getCreatureName(cid).."] / Move not found: ("..spell..").")
print("Position of caster: [x: "..getThingPositionWithDebug(cid).x..", y: "..getThingPositionWithDebug(cid).y..", z: "..getThingPositionWithDebug(cid).z.."].")
	if isSummon(cid) then
	print("Player Name: "..getCreatureName(getCreatureMaster(cid)).."")
	end
end
end







