local waters = {11756, 4614, 4615, 4616, 4617, 4618, 4619, 4608, 4609, 4610, 4611, 4612, 4613, 7236, 4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622, 4623, 4624, 4625, 4665, 4666, 4820, 4821, 4822, 4823, 4824, 4825}
--------------------------------------------------------------------------------
paralizeArea = createConditionObject(CONDITION_PARALYZE)
setConditionParam(paralizeArea, CONDITION_PARAM_TICKS, 50000)    --alterado v1.4
setConditionFormula(paralizeArea, -0.75, -0.75, -0.75, -0.75)
---------------------------------------------------------------------------------
function hasWithReflect(target)    --verifica se o poke target esta com reflect...
if not isCreature(target) then return true end
if getPlayerStorageValue(target, 21099) >= 1 then
   return true
end
return false
end
--------------------------------------------------------------------------------
function sendEffWithProtect(cid, pos, eff)  --Manda algum magic effect com proteçoes 
if not isCreature(cid) then return true end
if isSleeping(cid) then return true end
if getPlayerStorageValue(cid, 3894) >= 1 then return true end
local checkpos = pos
		checkpos.stackpos = 0
if not hasTile(checkpos) then
return true
end
if not canWalkOnPos(pos, false, true, false, true, false) then
return true
end

   doSendMagicEffect(pos, eff)
end
---------------------------------------------------------------------------------
function doDanoWithProtect(cid, element, pos, area, min, max, eff)  --Da dano com proteçoes
if not isCreature(cid) then return true end
if isSleeping(cid) then return true end
if getPlayerStorageValue(cid, 3894) >= 1 then return true end
   doAreaCombatHealth(cid, element, pos, area, min, max, eff)
end
---------------------------------------------------------------------------------
function sendDistanceShootWithProtect(cid, frompos, topos, eff)    --Manda um efeito de distancia com proteçoes
if not isCreature(cid) then return true end
if isSleeping(cid) then return true end
if getPlayerStorageValue(cid, 3894) >= 1 then return true end
   doSendDistanceShoot(frompos, topos, eff)
end
---------------------------------------------------------------------------------
function notHasMimicWall(cid, pos)        --Verifica se tem mimic wall na pos
if not hasTile(pos) then return true end

local p = getThingPos(cid)
local tileP = getTileThingByPos({x=p.x,y=p.y,z=p.z,stackpos=0}).actionid
local tile = getTileThingByPos(pos).actionid
if tileP == 88070 and tile == 88071 then
   return false
elseif tileP == 88071 and tile == 88070 then
   return false
elseif tile == 88072 then
   return false
end

return true
end
---------------------------------------------------------------------------------
function sendMoveBack(cid, pos, eff, min, max)     --Manda o Atk do farfetchd de volta...
local m = #pos+1
for i = 1, #pos do
    if not isCreature(cid) then return true end
    if isSleeping(cid) then return true end
    ---
    m = m-1
    thing = {x=pos[m].x,y=pos[m].y,z=pos[m].z,stackpos=253}
    local pid = getThingFromPosWithProtect(thing)
    addEvent(doMoveDano, i*200, cid, pid, "Stick Throw", FLYINGDAMAGE, min/4, max/4, 0, 0)  
    addEvent(sendEffWithProtect, i*200, cid, pos[m], eff)   --alterado v1.3
    -- 
end
end  
---------------------------------------------------------------------------------
function upEffect(cid, effDis)
pos = getThingPos(cid)
frompos = {x = pos.x+1, y = pos.y, z = pos.z}
frompos.x = pos.x - math.random(4, 7)                     --alterado v1.4
frompos.y = pos.y - math.random(5, 8)
doSendDistanceShoot(getThingPos(cid), frompos, effDis)
end
---------------------------------------------------------------------------------
function fall(cid, master, element, effDis, effArea)   --Function pra jogar efeitos pra cima e cair depois... tpw falling rocks e blizzard
if isCreature(cid) then
if getPlayerStorageValue(cid, 3894) >= 1 then return true end
if isSleeping(cid) then return true end
   pos = getThingPos(cid)
   pos.x = pos.x + math.random(-4,4)
   pos.y = pos.y + math.random(-4,4)
   if isMonster(cid) or isPlayer(cid) then
      frompos = {x = pos.x+1, y = pos.y, z = pos.z}
   elseif isSummon(cid) then
      frompos = getThingPos(master)
   end
   frompos.x = pos.x - 7
   frompos.y = pos.y - 6
   if effDis ~= -1 then                --alterado v1.4
      doSendDistanceShoot(frompos, pos, effDis)
   end
   doAreaCombatHealth(cid, element, pos, 0, 0, 0, effArea)
end
end
---------------------------------------------------------------------------------
function doMissSyst(target, rounds, effect, check, condution)     --Sistem de 'MISS'
if not isCreature(target) then return true end
if getPlayerStorageValue(target, 21099) >= 1 then return true end --reflect
if getPlayerStorageValue(target, 32659) >= 1 and rounds ~= -1 then return true end

if check and check ~= getPlayerStorageValue(target, 32659) then return true end

	if not check and getPlayerStorageValue(target, 32659) >= 1 then
		setPlayerStorageValue(target, 32659, getPlayerStorageValue(target, 32659) + rounds - 1)
	else
		setPlayerStorageValue(target, 32659, getPlayerStorageValue(target, 32659) + rounds)
	end

	local a = getPlayerStorageValue(target, 32659)
                                                                                        --alterado!!
	if isSummon(target) then
		local item = getPlayerSlotItem(getCreatureMaster(target), 8)
		doItemSetAttribute(item.uid, "missSyst", a)
		doItemSetAttribute(item.uid, "missEff", effect)
		doItemSetAttribute(item.uid, "missCond", condution)
	end

	if a <= -1 then 
       doRemoveCondition(target, CONDITION_PARALYZE)
       addEvent(doRegainSpeed, 50, target)
       setPlayerStorageValue(target, 32659, -1)   --alterado v1.4
       return true 
    end
	
	if condution == 1 and getCreatureCondition(target, CONDITION_PARALYZE) == false and rounds ~= -1 then
       doAddCondition(target, paralizeArea)        --alterado v1.4
    end
	doSendMagicEffect(getThingPos(target), effect)

    addEvent(doMissSyst, 1000, target, -1, effect, a, condution)
end
---------------------------------------------------------------------------------
function canDoMiss(cid, nameAtk)        --Verifica se pode da o efeito de 'MISS' no pokemon alvo
local atkTerra = {"Sand Attack", "Mud Shot", "Mud Bomb", "Sludge", "Sludge Rain", "Stomp", "Crusher Stomp", "Mud Slap", "Muddy Water"} --alterado v1.3
local atkElectric = {"Electric Storm", "Thunder Wave", "Thunder"}
if not isCreature(cid) then return false end
if isPlayer(cid) then return true end
if not pokes[getCreatureName(cid)] then return true end

if isInArray(atkTerra, nameAtk) then
   if (pokes[getCreatureName(cid)].type == "flying") or (pokes[getCreatureName(cid)].type2 == "flying")  then
      return false      
   end
elseif isInArray(atkElectric, nameAtk) then
   if (pokes[getCreatureName(cid)].type == "ground") or (pokes[getCreatureName(cid)].type2 == "ground") then
      return false      
   end
end

return true
end
---------------------------------------------------------------------------------
function doMoveInAreaWithMiss(cid, area, eff, cd, nameAtk, cond, element, min, max)  --Da um atk q deixa os pokes alvos com efeito de 'MISS'
if not isCreature(cid) then return true end
if nameAtk and nameAtk == "Mud Bomb" then
   pos = getPosfromArea(getMasterTarget(cid), area)
else
  pos = getPosfromArea(cid, area) 
end
n = 0
eff2 = eff

while n < #pos do
if not isCreature(cid) then return true end
if isSleeping(cid) then return true end
if getPlayerStorageValue(cid, 3894) >= 1 then return true end

n = n+1
thing = {x=pos[n].x,y=pos[n].y,z=pos[n].z,stackpos=253}

local pid = getThingFromPosWithProtect(thing)

if nameAtk == "Sand Attack" then
   addEvent(sendEffWithProtect, n*200, cid, pos[n], eff)
   eff2 = 34
elseif nameAtk == "Thunder Wave" then
   sendEffWithProtect(cid, pos[n], eff)
elseif nameAtk == "Poison Gas" then
   sendEffWithProtect(cid, pos[n], eff)
   eff2 = 34
elseif nameAtk == "Thunder" then
   sendEffWithProtect(cid, pos[n], eff)
elseif nameAtk == "Hyper Voice" then
   sendEffWithProtect(cid, pos[n], eff)
elseif nameAtk == "Mud Bomb" then
   sendEffWithProtect(cid, pos[n], eff)
   eff2 = 34
elseif nameAtk == "Aurora Beam" then
   eff2 = 43                              --alterado v1.4
elseif nameAtk == "SmokeScreen" then      --alterado v1.4
   sendEffWithProtect(cid, pos[n], eff)
elseif nameAtk == "Stomp" or nameAtk == "Crusher Stomp" then
   sendEffWithProtect(cid, pos[n], 118)
elseif nameAtk == "Icy Wind" then
   sendEffWithProtect(cid, pos[n], 17)
elseif nameAtk == "Muddy Water" or nameAtk == "Venom Motion" then
   eff2 = 34
local arr = {
[1] = 0, [2] = 0, [3] = 0, [4] = 200, [5] = 200, [6] = 200, [7] = 400, [8] = 400, [9] = 400, [10] = 600, [11] = 600,
[12] = 600, [13] = 800, [14] = 800, [15] = 800
}

local time = {0, 200, 400, 600, 800}
             
 addEvent(sendEffWithProtect, arr[n], cid, pos[n], eff)
 addEvent(doMoveDano, arr[n], cid, pid, nameAtk, element, min, max, 0, cd, eff2, cond)
 
elseif nameAtk == "Squisky Licking" or nameAtk == "Lick" then
   eff2 = 2
   sendEffWithProtect(cid, pos[n], eff)
elseif nameAtk == "Stun Spore" then
   eff2 = 2
   sendEffWithProtect(cid, pos[n], eff)
elseif nameAtk == "Cotton Spore" then   --alterado v1.4
   eff2 = 2
   sendEffWithProtect(cid, pos[n], eff)
end 

if nameAtk ~= "Muddy Water" and nameAtk ~= "Venom Motion" then
   doMoveDano(cid, pid, nameAtk, element, min, max, 0, cd, eff2, cond)
end
end
end    
---------------------------------------------------------------------------------
function doMoveInArea(cid, rounds, eff, area, min, max, element, spell)    --Da um atk 'normal' e tb pode da um atk q deixa os pokes alvos com efeito de 'Confuso'
if not isCreature(cid) then return true end
local skills = {"Skull Bash", "Gust", "Ground Chop", "Water Pulse", "Stick Throw", "Overheat", "Toxic", "Take Down"}
                                                                                                            --alterado v1.4
local pos = getPosfromArea(cid, area)
local n = 0
local l = 0

while n < #pos do
if not isCreature(cid) then return true end 
if isSleeping(cid) then return true end
if getPlayerStorageValue(cid, 3894) >= 1 then return true end

n = n+1
if notHasMimicWall(cid, {x=pos[n].x,y=pos[n].y,z=pos[n].z,stackpos=0}) then
thing = {x=pos[n].x,y=pos[n].y,z=pos[n].z,stackpos=253}

local pid = getThingFromPosWithProtect(thing)

   if spell and isInArray(skills, spell) then
      if spell == "Stick Throw" then
         addEvent(sendEffWithProtect, l*300, cid, pos[n], eff)
         addEvent(sendMoveBack, 1200, cid, pos, eff, min, max)
         addEvent(doMoveDano, l*300, cid, pid, spell, element, min, max, rounds, 0)   
      else
         addEvent(sendEffWithProtect, l*200, cid, pos[n], eff)
         addEvent(doMoveDano, l*200, cid, pid, spell, element, min, max, rounds, 0)   
      end
   elseif spell and spell == "Epicenter" then
      local random = math.random(50, 500)   
      addEvent(sendEffWithProtect, random, cid, pos[n], eff)
      addEvent(doDanoWithProtect, random, cid, GROUNDDAMAGE, pos[n], crusher, -min, -max, 255)
   elseif spell and spell == "Shadowave" then
      posi = {x=pos[n].x, y=pos[n].y+1, z=pos[n].z}
      sendEffWithProtect(cid, posi, eff)                  --alterado v1.4
      doMoveDano(cid, pid, spell, element, min, max, rounds, 0) 
   elseif spell and spell == "Surf" then
      addEvent(sendEffWithProtect, math.random(50, 500), cid, pos[n], eff)  --alterado v1.4
   else
      sendEffWithProtect(cid, pos[n], eff)
      doMoveDano(cid, pid, spell, element, min, max, rounds, 0) 
   end
l = l+1
end
end 
end 
---------------------------------------------------------------------------------
function doMoveInAreaMulti(cid, effDis, effMagic, areaEff, areaDano, element, min, max)
if not isCreature(cid) then return true end                     --Da um atk com efeito tpw Multi-Kick e Bullet Seed
local pos = getPosfromArea(cid, areaEff)
local pos2 = getPosfromArea(cid, areaDano)
local n = 0

while n < #pos2 do
if not isCreature(cid) then return true end
if isSleeping(cid) then return true end
if getPlayerStorageValue(cid, 3894) >= 1 then return true end

n = n+1
thing = {x=pos2[n].x,y=pos2[n].y,z=pos2[n].z,stackpos=253}
      if n < #pos then
         addEvent(sendDistanceShootWithProtect, n*50, cid, getThingPos(cid), pos[n], effDis) --39
         addEvent(sendEffWithProtect, n*50, cid, pos[n], effMagic)  -- 112
      end   
      local pid = getThingFromPosWithProtect(thing)
      if isCreature(pid) then
         doMoveDano(cid, pid, "", element, min, max, 0, 0)
      end
end 
end 
---------------------------------------------------------------------------------
function doSilenceInArea(cid, area, cd, eff)
if not isCreature(cid) then return true end
local pos = getPosfromArea(cid, area)
local n = 0
                                                          --alterado v1.4
while n < #pos do
if not isCreature(cid) then return true end
if isSleeping(cid) then return true end
if getPlayerStorageValue(cid, 3894) >= 1 then return true end
   n = n+1
   thing = {x=pos[n].x,y=pos[n].y,z=pos[n].z,stackpos=253}
   local pid = getThingFromPosWithProtect(thing)
   
   if isCreature(pid) then 
   if isSummon(cid) and (isMonster(pid) or (isSummon(pid) and canAttackOther(cid, pid) == "Can") or (isPlayer(pid) and canAttackOther(cid, pid) == "Can" and #getCreatureSummons(pid) <= 0)) and pid ~= cid then
      doSilence(pid, cd, eff, getPlayerStorageValue(pid, 32698))
   elseif isMonster(cid) and (isSummon(pid) or (isPlayer(pid) and #getCreatureSummons(pid) <= 0)) and pid ~= cid then
      doSilence(pid, cd, eff, getPlayerStorageValue(pid, 32698))
   elseif isPlayer(cid) and ehMonstro(pid) and pid ~= cid then
      doSilence(pid, cd, eff, getPlayerStorageValue(pid, 32698))
   end
   end
end
end
---------------------------------------------------------------------------------
function doMoveDano(cid, pid, nameAtk, element, min, max, rounds, cd, eff2, cond)     --Function pra da dano nas spells
if isCreature(pid) and isCreature(cid) then
local str = getPlayerStorageValue(pid, 21099)
if isSleeping(cid) then return true end
if getPlayerStorageValue(cid, 3894) >= 1 then return true end
   if isSummon(cid) and (isMonster(pid) or isSummon(pid) or isPlayer(pid)) and pid ~= cid then 
      if isSummon(pid) then
         if rounds ~= 0 and str <= 0 and canAttackOther(cid, pid) == "Can" then
            addEvent(doAdvancedConfuse, 100, pid, rounds, getPlayerStorageValue(pid, 3891), cid)
         end
         if cd ~= 0 and canDoMiss(pid, nameAtk) and canAttackOther(cid, pid) == "Can" then
            doMissSyst(pid, cd, eff2, getPlayerStorageValue(pid, 32659), cond)
         end
         doTargetCombatHealth(cid, pid, element, -min, -max, 255)
      elseif isMonster(pid) then
         if rounds ~= 0 and str <= 0 then
            addEvent(doAdvancedConfuse, 100, pid, rounds, getPlayerStorageValue(pid, 3891))
         end
         if cd ~= 0 and canDoMiss(pid, nameAtk) then
            doMissSyst(pid, cd, eff2, getPlayerStorageValue(pid, 32659), cond)
         end
         doTargetCombatHealth(cid, pid, element, -min, -max, 255)
      elseif isPlayer(pid) and #getCreatureSummons(pid) <= 0 then
         if canAttackOther(cid, pid) == "Cant" then return true end  --edited
         if rounds ~= 0 and str <= 0 and canAttackOther(cid, pid) == "Can" then
            addEvent(doAdvancedConfuse, 100, pid, rounds, getPlayerStorageValue(pid, 3891), cid)
         end
         if cd ~= 0 and canAttackOther(cid, pid) == "Can" then
            doMissSyst(pid, cd, eff2, getPlayerStorageValue(pid, 32659), cond)
         end
         doTargetCombatHealth(cid, pid, element, -min, -max, 255)
      end
   elseif isMonster(cid) and (isSummon(pid) or isPlayer(pid)) and pid ~= cid then
      if isPlayer(pid) and #getCreatureSummons(pid) <= 0 then
         if rounds ~= 0 and str <= 0 then
            addEvent(doAdvancedConfuse, 100, pid, rounds, getPlayerStorageValue(pid, 3891))
         end
         if cd ~= 0 then
            doMissSyst(pid, cd, eff2, getPlayerStorageValue(pid, 32659), cond)
         end
         doTargetCombatHealth(cid, pid, element, -min, -max, 255) 
      elseif isSummon(pid) then
         if rounds ~= 0 and str <= 0 then
            addEvent(doAdvancedConfuse, 100, pid, rounds, getPlayerStorageValue(pid, 3891))
         end
         if cd ~= 0 and canDoMiss(pid, nameAtk) then
            doMissSyst(pid, cd, eff2, getPlayerStorageValue(pid, 32659), cond)
         end
         doTargetCombatHealth(cid, pid, element, -min, -max, 255) 
      end 
   elseif isPlayer(cid) and isMonster(pid) then
      if rounds ~= 0 and str <= 0 then
         addEvent(doAdvancedConfuse, 100, pid, rounds, getPlayerStorageValue(pid, 3891))
      end
      if cd ~= 0 and canDoMiss(pid, nameAtk) then
        doMissSyst(pid, cd, eff2, getPlayerStorageValue(pid, 32659), cond)
      end
      doTargetCombatHealth(cid, pid, element, -min, -max, 255)      
   end
end 
end