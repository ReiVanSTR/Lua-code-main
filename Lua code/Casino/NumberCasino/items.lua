local Items = {}
local component = require("component")
local computer = component.computer
local fs = require("filesystem")

function Items:createItemList(filename) -- file.txt
	local obj = {}
	obj.path = filename
	
	
	setmetatable(obj, self)
	self.__index = self;
	return obj
end

function split(str, symb)
    local parts = {}
    for part in string.gmatch(str, "([^"..symb.."]+)") do
 	   if part ~= "" then
    		table.insert(parts, part)
    	end
   	end
	return parts
end

return Items