 sides = require("sides")
 
--[[ SETTINGS ]]--
-- Сторона выдачи сигнала раздатчика
local redstoneSide = sides.down
-- Сторона экспорта в раздатчик
local exportSide = sides.down
-- Сторона сундука с билетами относительно транспозера
local chestSide = sides.up
-- Сторона me интерфейса относительно транспозера
local interfaceSide = sides.down
-- Фильтр предмета
local ticket = {name="minecraft:paper", enchantments={{level=1, name="enchantment.protect.all"}}}
 
--[[ CODE ]]--
local items = {}
local counter = 0
do
  local file = io.open("droplist.txt", "r")
  if not file then error("File droplist.txt open error (not found or read error)") end
 
  local function split(str, symb)
    local parts = {}
    for m in string.gmatch(str, "([^"..symb.."]+)") do
      if m ~= "" then
        table.insert(parts, m)
      end
    end
    return parts
  end
 
  local chance, parts, itemParts
  file = io.open("text.txt", "r")
  for line in file:lines() do
    chance = nil
    parts = split(line, " ")
    if #parts > 1 then
      chance = tonumber(parts[2])
      itemParts = split(parts[1], ":")
      if #itemParts < 2 or (not chance) then print("Item "..itemParts[1].." has a bad format")
      else
        if #itemParts > 2 then
          table.insert(items, {chance=chance, offset=counter, item={name=itemParts[1]..":"..itemParts[2], damage=tonumber(itemParts[3])}})
        else
          table.insert(items, {chance=chance, offset=counter, item={name=itemParts[1]..":"..itemParts[2]}})
        end
        counter = counter+chance
      end
    end
  end
  file:close()
end
 
local com = require("component")
local db, tr, red, mInterf, mExport = com.database, com.transposer, com.redstone, com.me_interface, com.me_exportbus
 
red.setOutput(redstoneSide, 0)
 
 
local function genItem()
  val = counter*math.random()
  prevItem = items[1].item
  for i=2, #items do
    if items[i].offset < val then
      prevItem = items[i].item
    else break end
  end
  return prevItem
end
 
local function contains(target, filter)
  local ta, tb = type(target), type(filter)
  if ta ~= tb then return false end
  if ta ~= "table" then return target == filter end
  if filter[1] then
    for i=1,#filter do
      for j=1,#target do
        if not contains(target[j], filter[i]) then return false end
      end
    end
  else
    for k,v in pairs(filter) do
      if not(target[k]) or (not contains(target[k], v)) then return false end
    end
  end
  return true
end
 
local function useTicket()
  local size = tr.getInventorySize(chestSide)
  for i=1, size do
    item = tr.getStackInSlot(chestSide, i)
    if item and contains(item, ticket) and tr.transferItem(chestSide, interfaceSide, 1, i) then
      return true
    end
  end
  return false
end
 
local function getItemName(item)
  if item.damage then return item.name..":"..item.damage
  else return item.name end
end
 
local function dropItem(item)
  db.clear(1)
  local list = mInterf.getItemsInNetwork(item)
  local hasNext = #list > 1 or (#list > 0 and list[1].size > 1)
  if #list > 0 then
    while not mInterf.store(item, db.address, 1, 1) do db.clear(1) end
    while not mExport.setExportConfiguration(exportSide, 1, db.address, 1) do end
    while not mExport.exportIntoSlot(exportSide, 1) do end
   
    print(getItemName(item))
    red.setOutput(redstoneSide, 15)
    red.setOutput(redstoneSide, 0)
   
    return hasNext
  end
  print(getItemName(item).." is not dropped")
  return false
end
 
local args = {...}
if #args > 1 and args[1] == "test" then
  local count = tonumber(args[2]) or 1000
  local drops = {}
  for i=1,count do
    local item = genItem()
    local id = item.name
    if item.damage then id=id..":"..item.damage end
    if drops[id] then drops[id] = drops[id]+1
    else drops[id] = 1 end
  end
  for k,v in pairs(drops) do print(k, v) end
else
  while true do
    if useTicket() then
      if not dropItem(genItem()) then
        print("BREAK")
        break
      end
    end
  end
end