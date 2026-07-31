local storage = 121212 --storage da quest

function onUse(cid, item, frompos, item2, topos)

if getPlayerStorageValue(cid, storage) == 0 then
   doPlayerSendCancel(cid, "Ya usaste el límite de revivir para esta misión.")
   return true
elseif getPlayerStorageValue(cid, 990) >= 1 then
   doPlayerSendCancel(cid, "No puedes usar revivir durante batallas de gimnasio.")
   return true
elseif getPlayerStorageValue(cid, 52481) >= 1 then
   doPlayerSendCancel(cid, "No puedes hacer eso durante un duelo.") --alterado v1.6
   return true
elseif isPlayer(item2.uid) then
   doPlayerSendCancel(cid, "Usa revivir solo en Poké Balls.")
   return true
end

for a, b in pairs (pokeballs) do
    if not item2.itemid == b.on or not item2.itemid == b.off then
           doPlayerSendCancel(cid, "Usa revivir solo en Poké Balls.")
           return true
    end
end

local pokeball = getPlayerSlotItem(cid, 8)
for a, b in pairs (pokeballs) do
    if item2.itemid == b.on or item2.itemid == b.off then --edited deixei igual ao do PXG
           doTransformItem(item2.uid, b.on)
           doSetItemAttribute(item2.uid, "hp", 1)
           for c = 1, 15 do
                   local str = "move"..c
                   setCD(item2.uid, str, 0)
           end
           setCD(item2.uid, "control", 0)
           setCD(item2.uid, "blink", 0) --alterado v1.6
           doSendMagicEffect(getThingPos(cid), 13)
           doRemoveItem(item.uid, 1)
           doCureBallStatus(getPlayerSlotItem(cid, 8).uid, "all")
           doCureStatus(cid, "all", true)
           cleanBuffs2(item2.uid) --alterado v1.5
           if useOTClient then
              onPokeHealthChange(cid)   --alterei aki
           end
           if getPlayerStorageValue(cid, storage) > 0 then
                  setPlayerStorageValue(cid, storage, getPlayerStorageValue(cid, storage)-1)
           end
           return true
    end
end
return true
end