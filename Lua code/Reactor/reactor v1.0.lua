local c = require("component")
local t = c.transposer
local r = c.redstone
local reac = c.reactor_chamber
local counter = 0
local a = 1
local con = 0
local gpu = c.gpu
local event = require("event")
LZN = {
	2, 7, 9, 14, 21, 26, 28, 33, 40, 45, 47, 52
}
Neu = {
	4, 10, 50
}

listen_id = event.listen(0.01)("key_down", function(_, _, code1, code2) if code1 == 0 and code2 == 59 then r.setOutput(1, 0) print("Реактор отключён!") event.cancel(listen_id) os.exit() end end)
print("Реактор запущен!")
r.setOutput(1, 1)
gpu.set(3, 7, "Реактор включен?: "..tostring(reac.isActive()))
gpu.set(3, 9, "Нагрев ядра: "..tostring(reac.getHeat()))
while true do
	os.sleep()
	for b = 1, #Neu do
	local neuHealthBar = reac.getStackInSlot(Neu[b]).health_bar
	if neuHealthBar >= 0.9900 then
		t.transferItem(1, 3, 1, Neu[b])
		t.transferItem(4, 1, 1, 9, Neu[b])
		while not t.transferItem(4, 1, 1, 9, Neu[b]) do end
		print("Отражатель нейтронов загружен!")
	end
	end	
	for i = 1, #LZN do -- # - размер массива
		local healthBar = reac.getStackInSlot(LZN[i]).health_bar
		if t.getSlotStackSize(4, a) == 0 then a = a+1 
		elseif healthBar >= 0.8800  then
			   r.setOutput(1, 0)
			   os.sleep(2)
			   t.transferItem(1, 3, 1, LZN[i])
			   t.transferItem(4, 1, 1, a, LZN[i])
			   con = con + 1
			   r.setOutput(1, 15)
			   gpu.set(3, 5,"Кондентсаторов потрачено: "..con)
		end
		if a > 8 then  
			a = 1 
		end
	end
end
