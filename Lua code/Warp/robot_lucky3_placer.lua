local component = require("component")
local robot = component.robot

--PLACER--
invSlot = 1
while true do
	robot.select(invSlot)
	robot.place(3)
	if robot.count(invSlot) == 0 then
		invSlot = invSlot + 1
	end
	if invSlot > 16 then
		invSlot = 1
	end	
end