function onLogin(cid)
if getPlayerGroupId(cid) >= 3 then
doBroadcastMessage("El miembro del staff ".. getCreatureName(cid).." acaba de entrar al servidor!")
end
return true
end