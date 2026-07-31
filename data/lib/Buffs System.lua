local outFurys = {
["Shiny Charizard"] = {outFury = 1073},  
["Shiny Blastoise"] = {outFury = 1074},    
}
            
local function transBack(cid)
if isCreature(cid) then
   if getPlayerStorageValue(cid, 974848) >= 1 then
      setPlayerStorageValue(cid, 974848, 0)
      doRemoveCondition(cid, CONDITION_OUTFIT)
   end
end
end

function cleanBuffs(cid, item)
if cid ~= 0 and isCreature(cid) then
   setPlayerStorageValue(cid, 36847, -1)
end
if item ~= 0 then
   doItemEraseAttribute(item, "buffSyst")     --alterado v1.4
   doItemEraseAttribute(item, "buffEff")
   doItemEraseAttribute(item, "buffSkill")    
end
end   
   
function doBuffSyst(target, rounds, effect, check, skill, first)     --Function pra da os efeitos de "buffs" nos pokes.. tpw Rage e Strafe
if not isCreature(target) then return true end
if getPlayerStorageValue(target, 21099) >= 1 then return true end --reflect
if getPlayerStorageValue(target, 36847) >= 1 and rounds ~= -1 then return true end

if check and check ~= getPlayerStorageValue(target, 36847) then return true end

	if not check and getPlayerStorageValue(target, 36847) >= 1 then
		setPlayerStorageValue(target, 36847, getPlayerStorageValue(target, 36847) + rounds - 1)
	else
		setPlayerStorageValue(target, 36847, getPlayerStorageValue(target, 36847) + rounds)
	end

	local a = getPlayerStorageValue(target, 36847)

	if isSummon(target) then
		local item = getPlayerSlotItem(getCreatureMaster(target), 8)
		doItemSetAttribute(item.uid, "buffSyst", a)
		doItemSetAttribute(item.uid, "buffEff", effect)
		doItemSetAttribute(item.uid, "buffSkill", skill)
	end

	if a <= -1 then setPlayerStorageValue(target, 36847, -1) return true end
	
	doSendMagicEffect(getThingPos(target), effect)
	
    if first then
    if skill == "Strafe" then
       doRaiseStatus(target, false, false, true, 100, a)
    elseif skill == "Agility" then
       doRaiseStatus(target, false, false, true, 100, a)
    elseif skill == "Rage" then
       doRaiseStatus(target, true, false, false, 2, a)
    elseif skill == "Harden" then
       doRaiseStatus(target, false, true, false, 2, a)
    elseif skill == "Calm Mind" then
       doRaiseStatus(target, false, true, false, 2, a)
    elseif skill == "Ancient Fury" then
       doSetCreatureOutfit(target, {lookType = outFurys[getCreatureName(target)].outFury}, a*1000) 
       doRaiseStatus(target, true, true, false, 2, a)
    elseif skill == "War Dog" then
       doRaiseStatus(target, true, true, false, 1.5, a)
    elseif skill == "Rest" then
       doSleep(target, a, true)
	   doCreatureAddHealth(target, getCreatureMaxHealth(target))
    elseif skill == "Fighter Spirit" then                             --alterado v1.4
       setPlayerStorageValue(target, 465987, 9) --+10% chance de usar a passiva dos pokes, 9% daki + 21% da propria
       addEvent(setPlayerStorageValue, 15000, target, 465987, -1) 
    elseif skill == "Furious Legs" then
       setPlayerStorageValue(target, 465987, 9) --+10% chance de usar a passiva dos pokes, 9% daki + 21% da propria
       addEvent(setPlayerStorageValue, 15000, target, 465987, -1)                                              --passiva
    elseif skill == "Ultimate Champion" then
       setPlayerStorageValue(target, 465987, 9) --+10% chance de usar a passiva dos pokes, 9% daki + 21% da propria
       addEvent(setPlayerStorageValue, 15000, target, 465987, -1)                                              --passiva
    elseif skill == "Future Sight" then
       doSetCreatureOutfit(target, {lookType = 1446}, a*1000)
       setPlayerStorageValue(target, 9658783, 1)                         --alterado v1.4
       addEvent(setPlayerStorageValue, a*1000, target, 9658783, -1)        
    elseif skill == "Bug Fighter" then
       doRaiseStatus(target, true, true, false, 2, a)
       doRaiseStatus(target, false, false, true, 100, a)                  --alterado v1.4
       doSetCreatureOutfit(target, {lookType = 1448}, a*1000)
    end
    end 

    addEvent(doBuffSyst, 1000, target, -1, effect, a, skill, false)
end