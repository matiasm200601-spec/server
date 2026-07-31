local function getPokemonMove(name, number)
	local x = movestable[name]
		if not x then return {} end
	local y = {}

	if number == 1 then
		y = x.move1
	elseif number == 2 and x.move2 then
		y = x.move2
	elseif number == 3 and x.move3 then
		y = x.move3
	elseif number == 4 and x.move4 then
		y = x.move4
	elseif number == 5 and x.move5 then
		y = x.move5
	elseif number == 6 and x.move6 then
		y = x.move6
	elseif number == 7 and x.move7 then
		y = x.move7
	elseif number == 8 and x.move8 then
		y = x.move8
	elseif number == 9 and x.move9 then
		y = x.move9
	elseif number == 10 and x.move10 then
		y = x.move10
	elseif number == 11 and x.move11 then
		y = x.move11
	elseif number == 12 and x.move12 then
		y = x.move12
	elseif number == 13 and x.move13 then
		y = x.move13
	elseif number == 14 and x.move14 then
		y = x.move14
	elseif number == 15 and x.move15 then
		y = x.move15
	end

return y
end

local function doRegisterSpells()

local dir = "data/spells/scripts/ps/"
local gn = "data/spells/spells.xml"

local nb = 0

for taa, tb in pairs (movesinfo) do
	local ta = taa
		if ta == "Invisible" then
			ta = "GhostInvisible"
		end
	print("Doing move: "..ta..".")
	local a = io.open(dir..""..ta..".lua", "w")
	local b = 'function onCastSpell(cid, var)\n\n	if isSummon(cid) then return true end\n\n	docastspell(cid, "'..ta..'")\n\nreturn true\nend'
	a:write(b)
	a:close()
	--local f = '\n	<instant name="'..ta..'" words="spell'..threeNumbers(nb)..'" lvl="1000" mana="0" event="script" value="ps/'..ta..'.lua"></instant>\n'
	--local d = io.open(gn, "a+")
	--local e = d:read("*all")
	--d:close()
	--e = e..""..f..""
	--local g = io.open(gn, "w")
	--g:write(e)
	--g:close()
	--nb = nb + 1
end

end


local function doRegisterMonsterSpells()
for a = 1, 151 do
	local poke = oldpokedex[a][1]
	--print("Doing Monster: "..poke..".")
	local final = ""
	local mdir = "data/monster/pokes/"..poke..".xml"
	local b = io.open(mdir, "a+")
	local c = b:read("*all")
	b:close()
	local d, e = c:find("<attacks>(.-)</attacks>")
	if not d or not e then print("error") end
	local f1 = string.sub(c, 1, d-1)
	local f2 = string.sub(c, e+1, string.len(c))
		local rum, rdo = c:find('<flag targetdistance="(.-)"/>')
		local rang = string.sub(c, rum + 22, rdo - 3)
		local meleeatk = '        <attack name="melee" interval="2000" chance="100" range="1" min="-50" max="-100">  </attack>'
		local rangeatk = '        <attack name="physical" interval="2000" chance="100" range="'..tonumber(rang) + (1)..'" min="-50" max="-100">\n        <attribute key="shootEffect" value="eartharrow"/>\n        </attack>'
		final = rang == "1" and meleeatk or rangeatk
		final = "<attacks>\n"..final..""
	for tries = 1, 15 do
		local h = getPokemonMove(poke, tries)
			if h.name then
				
				local extradelay = 1
				local name = h.name ~= "Invisible" and h.name or "GhostInvisible"
					if movesinfo[h.name].f <= 0 then
						extradelay = 3
					end
				local chance = 12/extradelay + math.floor(22 - h.cd / 3.5)
				local delay = 2100 + 47 * h.cd * extradelay
				local range = h.target == 1 and h.dist or "6"
				if tonumber(rang) >= tonumber(range) and tonumber(range) ~= 1 then
					range = tonumber(rang) + 2
				end
				local text = '\n        <attack name="'..name..'" interval="'..delay..'" chance="'..chance..'" range="'..range..'">\n        </attack>'
				final = final..""..text..""
			end
	end
	final = final..'\n</attacks>'
	local write = f1..''..final..''..f2..''
	local i = io.open(mdir, "w")
	i:write(write)
	i:close()
end
end


for a, b in pairs (pokes) do
	local dir = "data/monster/pokes/"..a..".xml"
	print(dir)
	local file = io.open(dir, "a+")
	local text = file:read("*all")
	file:close()

	local a, b = text:find("targetchange interval")

	local wtw1 = string.sub(text, 1, b)
	wtw1 = wtw1..'="10000" chance="0"/>\n'

	local c, d = a:find("strategy attack")

	wtw1 = wtw1..''..string.sub(text, c-1, 9999999)..''

	local e, f = wtw1:find("</monster>")

	wtw1 = string.sub(wtw1, 1, e-1)..'<script>\n<event name="Exp"/>\n<event name="Experience"/>\n<event name="Wild1"/>\n<event name="Wild2"/>\n<event name="Wild3"/>\n</script>\n</monster>'

	local arq = io.open(dir, "w")
	arq:write(wtw1)
	arq:close()
end

end















