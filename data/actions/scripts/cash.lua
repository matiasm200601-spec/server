                                                             --[[
   Script by Unknown
]]--

local STORAGE = 18477

function onUse(cid, item, frompos, item2, topos)
  local Items = {2160}
  local Count = {10}
  local ItemCount = 0
  if (item.actionid == 4888) then
    if (getPlayerStorageValue(cid, STORAGE) < 1) then
      local i = 0
      local Plural = ""
      local ItemName = ""
      for i in Items do
        if (type(Count[i]) == 'string') then
          ItemCount = 1
        else
          ItemCount = Count[i]
        end
        local ItemName = getItemName(items[i])
        if ((ItemCount > 1) and (string.sub(ItemName, string.len(ItemName)) ~= "s")) then
          Plural = "s"
        else
          Plural = ""
        end
        doPlayerAddItem(cid, Items[i], ItemCount)
        doPlayerSendTextMessage(cid,MessageClasses, "Voce encontrou "..Count.." "..ItemName..Plural..".")
      end
    else
      doPlayerSendTextMessage(cid, 22, "Voce ja usou isto.")
    end
  end
end