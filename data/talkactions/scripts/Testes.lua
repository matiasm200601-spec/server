function onSay(cid, words, param, channel)

local n = string.explode(param, ",")

if param and param == "go" then
   doTeleportThing(cid, {x=1063, y=931, z=9}, false)
elseif param and param == "back" then
   doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)), false)
elseif param and ((n[1] and n[1] == "reset") or param == "reset") then
   if n[2] and tonumber(n[2]) then
      setPlayerStorageValue(cid, tonumber(n[2]), -1)   
   end
   setPlayerStorageValue(cid, 86228, -1)
   setPlayerStorageValue(cid, 862281, -1)
   
   --
   --[[for i = 181612, 181638 do
       setPlayerStorageValue(cid, i, -1)
   end ]]
else
    doPlayerSendTextMessage(cid, 20, "Storage 6598754 = "..getPlayerStorageValue(cid, 6598754).."\n------------------------------------\n")
    doPlayerSendTextMessage(cid, 20, "Storage 6598755 = "..getPlayerStorageValue(cid, 6598755).."\n------------------------------------\n")
end
 
return true
end