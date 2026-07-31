local outfits = {
[1441] = {1506, 1505, 1504, 1503, 1502, 1501, 1502, 1503, 1504, 1505, 1506},
[1426] = {1514, 1513, 1512, 1511, 1510, 1509, 1510, 1509, 15010, 1509, 1508, 1507},
[1429] = {1549, 1550, 1551, 1552, 1553, 1554, 1555, 1556},
[1421] = {1557, 1558, 1559, 1560, 1561, 1562, 1563, 1562, 1561, 1560, 1559, 1558, 1557},
[1444] = {1543, 1544, 1545, 1546, 1547, 1546, 1545, 1544, 1543},
[1428] = {1577, 1578, 1579, 1580, 1581, 1580, 1579, 1578, 1577},
[1424] = {1583, 1582, 1584, 1585, 1586, 1587, 1586, 1585, 1584, 1582, 1583},
[1423] = {1592, 1591, 1590, 1589, 1588, 1589, 1590, 1591, 1592},
[1422] = {1593, 1594, 1595, 1596, 1597, 1596, 1595, 1594, 1593},
[1427] = {1598, 1599, 1600, 1601, 1602, 1603, 1602, 1601, 1600, 1599, 1598},
[1425] = {1604, 1605, 1606, 1607, 1608, 1609, 1610, 1611, 1612},
[1437] = {1624, 1625, 1626, 1627, 1628, 1629, 1630, 1631},
[1438] = {1657, 1658, 1659, 1660, 1661, 1662, 1663},
[1434] = {1656, 1655, 1654, 1653, 1652, 1651, 1650, 1649, 1648, 1647, 1646},
[1430] = {1678, 1679, 1680, 1681, 1682, 1683, 1684, 1685, 1686, 1687},
[1432] = {1664, 1665, 1667, 1668, 1669, 1670, 1671, 1672},
[1433] = {1613, 1614, 1615, 1616, 1617, 1618, 1619, 1620, 1621, 1622, 1623},
[1436] = {1632, 1633, 1634, 1635, 1636, 1635, 1634, 1633, 1632},
[1431] = {1673, 1674, 1675, 1676, 1677, 1676, 1675, 1674},
[1435] = {1637, 1638, 1639, 1640, 1641, 1642, 1643, 1644, 1645},
}
local intervalo_para_trocar_roupas = 1 * 500 -- em ms, 1 * 1000 = 1 segundo
local function doChangeOutfit(cid, id, oldLook)
if not isCreature(cid) then return true end
local n = id or 1
local newOutfit = getCreatureOutfit(cid)
newOutfit.lookType = outfits[oldLook][n]
doSetCreatureOutfit(cid, newOutfit, -1)
if n < #outfits[oldLook] then
addEvent(doChangeOutfit, intervalo_para_trocar_roupas, cid, n + 1, oldLook)
else
doCreatureSetNoMove(cid, false)
doRemoveCondition(cid, CONDITION_OUTFIT)
end
end
function onSay(cid, words, param)
if getCreatureCondition(cid, CONDITION_OUTFIT) and getCreatureNoMove(cid) then
return true
end
if not outfits[getCreatureOutfit(cid).lookType] then
doPlayerSendCancel(cid, "")
return true
end
doCreatureSetNoMove(cid, true)
doChangeOutfit(cid, 1, getCreatureOutfit(cid).lookType)
return true
end