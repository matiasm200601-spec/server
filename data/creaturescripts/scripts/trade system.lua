local xhelds = {
[1] = {name = "X-Defense(Tier: 1)"},
[2] = {name = "X-Defense(Tier: 2)"},
[3] = {name = "X-Defense(Tier: 3)"},
[4] = {name = "X-Defense(Tier: 4)"},
[5] = {name = "X-Defense(Tier: 5)"},
[6] = {name = "X-Defense(Tier: 6)"},
[7] = {name = "X-Defense(Tier: 7)"},
[8] = {name = "X-Attack(Tier : 1)"},
[9] = {name = "X-Attack(Tier : 2)"},
[10] = {name = "X-Attack(Tier: 3)"},
[11] = {name = "X-Attack(Tier: 4)"},
[12] = {name = "X-Attack(Tier: 5)"},
[13] = {name = "X-Attack(Tier: 6)"},
[14] = {name = "X-Attack(Tier: 7)"},
[15] = {name = "X-Return(Tier: 1)"},
[16] = {name = "X-Return(Tier: 2)"},
[17] = {name = "X-Return(Tier: 3)"},
[18] = {name = "X-Return(Tier: 4)"},
[19] = {name = "X-Return(Tier: 5)"},
[20] = {name = "X-Return(Tier: 6)"},
[21] = {name = "X-Return(Tier: 7)"},
[22] = {name = "X-Hellfire(Tier: 1)"},
[23] = {name = "X-Hellfire(Tier: 2)"},
[24] = {name = "X-Hellfire(Tier: 3)"},
[25] = {name = "X-Hellfire(Tier: 4)"},
[26] = {name = "X-Hellfire(Tier: 5)"},
[27] = {name = "X-Hellfire(Tier: 6)"},
[28] = {name = "X-Hellfire(Tier: 7)"},
[29] = {name = "X-Poison(Tier: 1)"},
[30] = {name = "X-Poison(Tier: 2)"},
[31] = {name = "X-Poison(Tier: 3)"},
[32] = {name = "X-Poison(Tier: 4)"},
[33] = {name = "X-Poison(Tier: 5)"},
[34] = {name = "X-Poison(Tier: 6)"},
[35] = {name = "X-Poison(Tier: 7)"},
[36] = {name = "X-Boost(Tier: 1)"},
[37] = {name = "X-Boost(Tier: 2)"},
[38] = {name = "X-Boost(Tier: 3)"},
[39] = {name = "X-Boost(Tier: 4)"},
[40] = {name = "X-Boost(Tier: 5)"},
[41] = {name = "X-Boost(Tier: 6)"},
[42] = {name = "X-Boost(Tier: 7)"},
[43] = {name = "X-Agility(Tier: 1)"},
[44] = {name = "X-Agility(Tier: 2)"},
[45] = {name = "X-Agility(Tier: 3)"},
[46] = {name = "X-Agility(Tier: 4)"},
[47] = {name = "X-Agility(Tier: 5)"},
[48] = {name = "X-Agility(Tier: 6)"},
[49] = {name = "X-Agility(Tier: 7)"},
[50] = {name = "X-Strafe(Tier: 1)"},
[51] = {name = "X-Strafe(Tier: 2)"},
[52] = {name = "X-Strafe(Tier: 3)"},
[53] = {name = "X-Strafe(Tier: 4)"},
[54] = {name = "X-Strafe(Tier: 5)"},
[55] = {name = "X-Strafe(Tier: 6)"},
[56] = {name = "X-Strafe(Tier: 7)"},
[57] = {name = "X-Rage(Tier: 1)"},
[58] = {name = "X-Rage(Tier: 2)"},
[59] = {name = "X-Rage(Tier: 3)"},
[60] = {name = "X-Rage(Tier: 4)"},
[61] = {name = "X-Rage(Tier: 5)"},
[62] = {name = "X-Rage(Tier: 6)"},
[63] = {name = "X-Rage(Tier: 7)"},
}

local yhelds = {
[1] = {name = "Y-Regeneration(Tier: 1)"},
[2] = {name = "Y-Regeneration(Tier: 2)"},
[3] = {name = "Y-Regeneration(Tier: 3)"},
[4] = {name = "Y-Regeneration(Tier: 4)"},
[5] = {name = "Y-Regeneration(Tier: 5)"},
[6] = {name = "Y-Regeneration(Tier: 6)"},
[7] = {name = "Y-Regeneration(Tier: 7)"},
[8] = {name = "Y-Cure(Tier: 1)"},
[9] = {name = "Y-Cure(Tier: 2)"},
[10] = {name = "Y-Cure(Tier: 3)"},
[11] = {name = "Y-Cure(Tier: 4)"},
[12] = {name = "Y-Cure(Tier: 5)"},
[13] = {name = "Y-Cure(Tier: 6)"},
[14] = {name = "Y-Cure(Tier: 7)"},
}

function onTradeRequest(cid, target, item)

	for a, b in pairs (pokeballs) do
		if b.use == item.itemid then
			doPlayerSendCancel(cid, "No puedes intercambiar este objeto.")
		return false
		end
	end
	
	if isContainer(item.uid) then
	   local bagItems = getItensUniquesInContainer(item.uid)
	   if #bagItems >= 1 then
	      doPlayerSendCancel(cid, "Hay un objeto único en esta bolsa; no puedes intercambiarlo.")     --alterado v1.6
	      return false
       end     
	elseif getItemAttribute(item.uid, "unique") then    --alterado v1.6
	   doPlayerSendCancel(cid, "Es un objeto único; no puedes intercambiarlo.")
	   return false
	end   
	
	if isContainer(item.uid) then
	   local itens = getPokeballsInContainer(item.uid)
	   if #itens >= 1 then                             
	      for i = 1, #itens do
	          local lvl = getItemAttribute(itens[i], "level")
	          local name = getItemAttribute(itens[i], "poke")
	          if not lvl then
	             doItemSetAttribute(itens[i], "level", pokes[name].level)     --alterado v1.6
              end
           end
       end
    elseif isPokeball(item.itemid) then
	   local lvl = getItemAttribute(item.uid, "level")
	   local name = getItemAttribute(item.uid, "poke")
	   if not lvl then
	      doItemSetAttribute(item.uid, "level", pokes[name].level)
       end
    end
    
    if getPlayerStorageValue(cid, 52480) >= 1 then             --alterado v1.6.1
       doPlayerSendTextMessage(cid, 20, "No puedes hacer eso durante un duelo.")
       return false
    end
    
    if isPokeball(item.itemid) then
       local name = getItemAttribute(item.uid, "poke")            --alterado v1.8 \/
       local boost = getItemAttribute(item.uid, "boost") or 0
       local nick = getItemAttribute(item.uid, "nick") or ""
    
       local str = "Pokemon in trade: "
       str = str.."Nombre: "..name.."   Boost: "..boost.."   "
       if nick ~= "" then str = str.."Nick: "..nick.."" end
	   local heldx = getItemAttribute(item.uid, "heldx")
       local heldy = getItemAttribute(item.uid, "heldy")
	   if heldx and heldy then
str = str.."Holding: "..(xhelds[heldx].name).." and "..(yhelds[heldy].name)..". "
elseif heldx then
str = str.."Holding: "..(xhelds[heldx].name)..". "
elseif heldy then
str = str.."Holding: "..(yhelds[heldy].name)..". "
end
       sendMsgToPlayer(target, 20, str)
    end
                                                            --alterado v1.8 \/
    if isContainer(item.uid) then
	   local itens = getPokeballsInContainer(item.uid)
	   if #itens >= 1 then                             
	      for i = 1, #itens do
	          if isPokeball(getThing(itens[i]).itemid) then
	             local name = getItemAttribute(itens[i], "poke")            
                 local boost = getItemAttribute(itens[i], "boost") or 0
                 local nick = getItemAttribute(itens[i], "nick") or ""
				 	   local heldx = getItemAttribute(itens[i], "heldx")
       local heldy = getItemAttribute(itens[i], "heldy")
    
                 local str = "Pokemon in trade: "
                 str = str.."Nombre: "..name.."   Boost: "..boost.."   "
                 if nick ~= "" then str = str.."Nick: "..nick.."" end
				  if heldx and heldy then
str = str.."Holding: "..(xhelds[heldx].name).." and "..(yhelds[heldy].name)..". "
elseif heldx then
str = str.."Holding: "..(xhelds[heldx].name)..". "
elseif heldy then
str = str.."Holding: "..(yhelds[heldy].name)..". "
end
                 sendMsgToPlayer(target, 20, str)
              end
          end
	   end       
    end
    

return true
end

local function noCap(cid, sid)
	if isCreature(cid) then
		doPlayerSendCancel(cid, "No puedes llevar más de seis Pokémon; intercambio cancelado.")
	end
	if isCreature(sid) then
		doPlayerSendCancel(sid, "No puedes llevar más de seis Pokémon; intercambio cancelado.")
	end
end

function onTradeAccept(cid, target, item, targetItem)

	local pbs = #getPokeballsInContainer(item.uid)
	local cancel = false
	local p1 = 0
	local p2 = 0
	local itemPokeball = isPokeball(item.itemid) and 1 or 0
	local targetItemPokeball = isPokeball(targetItem.itemid) and 1 or 0

    if getPlayerMana(cid) + itemPokeball > 6 then  --alterado v1.6
	   cancel = true
	   p1 = cid
    end
    if getPlayerMana(target) + targetItemPokeball > 6 then  --alterado v1.6
	   cancel = true
	   p2 = target
    end
    
	if pbs > 0 and getCreatureMana(target) + pbs > 6 + targetItemPokeball then
		cancel = true	
		p1 = target
	end

	pbs = #getPokeballsInContainer(targetItem.uid)

	if pbs > 0 and getCreatureMana(cid) + pbs > 6 + itemPokeball then
		cancel = true
		p2 = cid
	end

	if cancel then
		addEvent(noCap, 20, p1, p2)
	return false
	end

	if itemPokeball == 1 and targetItemPokeball == 1 then
		setPlayerStorageValue(cid, 8900, 1)
		setPlayerStorageValue(target, 8900, 1)
	end

return true
end