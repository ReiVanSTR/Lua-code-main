local com = require("component")
local cr = com.crystal
local money = 0
S = "SOUTH"
balance = 0
com.gpu.setResolution(75,50)
function check()
	x={}
	id="minecraft:diamond"
	inv = cr.getAllStacks(false)
	for k,i in pairs(inv) do
		if id == inv[k].id then
			table.insert(x, k)
			table.sort(x)
			balance = balance + inv[k].qty
		end	
	end	
	for i= 1, #x do
		print(x[i])
	end	
	print("Balance: "..balance)
end

function bet10( ... )
	bet = 10
	if bet > 
	cr.pushItem(S, )
end
check()
