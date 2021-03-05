local cfg = require("./config")
local shell = require("shell")
shell.setWorkingDirectory('/home/GameLauncher/layers')
local auth = require("./auth")
shell.setWorkingDirectory('/home/GameLauncher/')

local main = {}

	main['auth'] = auth:init()
	main['auth']:redraw()
	main['auth']:run()