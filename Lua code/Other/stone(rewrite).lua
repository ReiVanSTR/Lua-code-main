-------------------------------------------------------
--     Программа: генератор укрепленного камня       --
--         для роботов из мода OpenComputers         --
--          проект http://computercraft.ru           --
--              Version 0.1(basic)                   --
--                 2019, © Asior                     --
-------------------------------------------------------
--инструмент: любой бур; 1: леса железные; 2: песок; 3: распылитель
--расширения: инвентарь, контроллер инвентаря
 
local c = require("component")
local r = require('robot')
local ic = c.inventory_controller
local me = c.
print(ic.getInventorySize(1))
local function import()
  if r.count(1) <= 2 or r.count(2) <= 2 then
    r.select(1)
    for n = 1, 2 do
      if r.count(n) == 0 then
        error('Нет нужных ресурсов')
      end
      label = ic.getStackInInternalSlot(n).label
      for i=1,ic.getInventorySize(1) do
        name = ic.getStackInSlot(1,i)
        if name then
          if name.label == label then
            ic.suckFromSlot(2,i,63-r.count(n),n)
            break
          end
        end
      end
    end
  end
end
 
local function refuel()
  r.select(3)
  r.turnRight()
  ic.equip()
  r.drop()
  for i=4,16 do
    if r.count(i)>0 then
      r.select(i)
      r.dropDown(64)
    end
  end
  os.sleep(5)
  os.sleep(1)
  r.select(3)
  r.suck()
  r.turnLeft()
  r.turnLeft()
  ic.equip()
  r.drop()
  os.sleep(5)
  r.suck()
  r.turnRight()
end
 
while true do
  for i=1, 32 do  --8000/100
    r.select(1) --поставить леса
    r.place()
    r.select(3) --залить леса
    ic.equip()
    r.use()
    r.select(2) --засыпать бетон
    ic.equip()
    r.use()
    ic.equip()
    r.select(3) --снять бетон
    ic.equip()
    r.swing()
    import()
  end
  refuel()
end






component.transposer.getInventorySize()
со 2 в  5