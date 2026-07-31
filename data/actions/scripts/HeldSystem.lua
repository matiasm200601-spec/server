local heldTable = {
-- X --
[12340] = {attribute = "heldx", ident = 1}, -- Defense 1
[12339] = {attribute = "heldx", ident = 8}, -- Attack 1
[12338] = {attribute = "heldx", ident = 15}, -- Return 1
--[ID] = {attribute = "heldx", ident = 22}, -- Hellfire 1
--[ID2] = {attribute = "heldx", ident = 23}, -- Hellfire 2 
--[ID3] = {attribute = "heldx", ident = 24}, -- Hellfire 3
--[ID4] = {attribute = "heldx", ident = 25}, -- Hellfire 4 
--[ID5] = {attribute = "heldx", ident = 26}, -- Hellfire 5
--[ID6] = {attribute = "heldx", ident = 27}, -- Hellfire 6
--[ID7] = {attribute = "heldx", ident = 28}, -- Hellfire 7
--[ID] = {attribute = "heldx", ident = 29}, -- Poison 1
--[ID2] = {attribute = "heldx", ident = 30}, -- Poison 2
--[ID3] = {attribute = "heldx", ident = 31}, -- Poison 3
--[ID4] = {attribute = "heldx", ident = 32}, -- Poison 4
--[ID5] = {attribute = "heldx", ident = 33}, -- Poison 5
--[ID6] = {attribute = "heldx", ident = 34}, -- Poison 6
--[ID7] = {attribute = "heldx", ident = 35}, -- Poison 7
[13123] = {attribute = "heldx", ident = 36}, -- Boost 1
[13124] = {attribute = "heldx", ident = 71}, -- Experience 1
[13125] = {attribute = "heldx", ident = 92}, -- Vitality 1
[13126] = {attribute = "heldx", ident = 99}, -- Haste 1
[13127] = {attribute = "heldx", ident = 113}, -- Cooldown 3
-- Y -- 
[12342] = {attribute = "heldy", ident = 1}, -- Regeneration 1
--[ID] = {attribute = "heldy", ident = 8}, -- Cure 1 
--[ID2] = {attribute = "heldy", ident = 9}, -- Cure 2
--[ID3] = {attribute = "heldy", ident = 10}, -- Cure 3
--[ID4] = {attribute = "heldy", ident = 11}, -- Cure 4
--[ID5] = {attribute = "heldy", ident = 12}, -- Cure 5
--[ID6] = {attribute = "heldy", ident = 13}, -- Cure 6
--[ID7] = {attribute = "heldy", ident = 14}, -- Cure 7
}

function onUse(cid, item, frompos, item2, topos)

if not isPokeball(item2.itemid) or #getCreatureSummons(cid) > 0 then return false end
if not heldTable[item.itemid] then return false end

held = heldTable[item.itemid]
pokename = getItemAttribute(item2.uid, "poke")
heldname = getItemInfo(item.itemid).name

doSetItemAttribute(item2.uid, held.attribute, held.ident)
doRemoveItem(item.uid, 1)
doSendMagicEffect(getThingPos(cid), 14)
sendMsgToPlayer(cid, 27, "Seu "..pokename.." Ganhou Uma "..heldname..".")
return true
end