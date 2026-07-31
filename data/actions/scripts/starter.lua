local starterpokes = {
["Totodile"] = {x = 53, y = 70, z = 7},
["Chikorita"] = {x = 51, y = 70, z = 7},
["Cyndaquil"] = {x = 49, y = 70, z = 7},
["Charmander"] = {x = 43, y = 70, z = 7},
["Bulbasaur"] = {x = 45, y = 70, z = 7},
["Squirtle"] = {x = 47, y = 70, z = 7},
}

local btype = "normal"

function onUse(cid, item, frompos, item2, topos)

    if getPlayerLevel(cid) > 15 then   
    return true
    end

    local pokemon = ""

    for a, b in pairs (starterpokes) do
        if isPosEqualPos(topos, b) then
            pokemon = a
        end
    end
    if pokemon == "" then return true end
    

    doPlayerSendTextMessage(cid, 27, "¡Obtuviste tu primer Pokémon! También recibiste algunas Poké Balls para ayudarte en tu aventura.")
    doPlayerSendTextMessage(cid, 27, "¡No olvides usar tu Pokédex en cada Pokémon no descubierto!")

    addPokeToPlayer(cid, pokemon, 0, nil, btype, true)
    doPlayerAddItem(cid, 2394, 20)
    doPlayerAddItem(cid, 2160, 1)
    doPlayerAddLevel(cid, 19)

    doSendMagicEffect(getThingPos(cid), 29)
    doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
    doSendMagicEffect(getThingPos(cid), 27)
    doSendMagicEffect(getThingPos(cid), 29)
    

return TRUE
end