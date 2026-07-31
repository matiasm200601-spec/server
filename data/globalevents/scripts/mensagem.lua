-- [( Script created by Doidin for XTibia.com )] --
function onThink(interval, lastExecution)
MENSAGEM = {
"Nunca abras una BOX con 6 Pokémons en el inventario. No nos responsabilizamos por pérdidas de ese tipo.",
"¡Los eventos ocurren a diario, estate atento!",
"Para evitar pérdidas, usa constantemente !save.",
"Al alcanzar los niveles 30 y 170, los entrenadores reciben una pluma rara. Con esa pluma en tu Pokebag usa el comando !vipfree",
"PokeRetro",
"¡La NPC 'Conejita' compra ítems raros por una buena cantidad, encuéntrala en el CT!",
"Sigue las novedades de PokeRetro en nuestras redes sociales.",
"¿Dudas? Envía tu pregunta al canal 'Help', los helpers responderán a la brevedad.",
"¿Encontraste un bug? ¡Contáctanos a través de nuestra página de Facebook!",
"Al alcanzar los niveles 30 y 170, los entrenadores reciben una pluma rara. Con esa pluma en tu Pokebag usa el comando !vipfree",
}
doBroadcastMessage(MENSAGEM[math.random(1,#MENSAGEM)],22)
return TRUE
end