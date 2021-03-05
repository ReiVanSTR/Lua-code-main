local component = require("component")
local robot = component.robot
local ic = component.inventory_controller

--SWINGER--

function charge()
	ic.equip()
	robot.turn(false)
	robot.turn(false)
	robot.drop(3)
	os.sleep(10)
	robot.suck(3)
	robot.turn(false)
	robot.turn(false)
	ic.equip()
end

while true do
	robot.swing(3)
	if robot.durability() < 0.1 then
		os.sleep(2)
		charge()
	end	
end	

