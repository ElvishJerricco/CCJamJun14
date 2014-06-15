print("Loading...")

-- Import classes
local Monitor = require("Monitor.lua")
local Module = require("Module.lua")
local EventManager = require("EventManager.lua")
local Server = require("Server.lua")
local mu = require("MonitorUtils.lua")
local debug = require("debug.lua")

-- Root directory
local root = fs.getDir(shell.getRunningProgram())

-- Utility; The way fs.combine SHOULD behave
local function combine(str1, str2, ...)
	if not str2 then
		return str1
	end
	return fs.combine(str1, combine(str2, ...))
end

-- Utility; math.round really should exist
function math.round(n)
	return math.floor(n + .5)
end

-- Utility; Get the config named: name
local function getConfig(name)
	local file = assert(
		fs.open(
			combine(
				root,
				"config",
				name
			),
			"r"
		), "Failed to open config: " .. name
	)

	return textutils.unserialize(file.readAll())
end

-- Load configs
local generalConfig = getConfig("general.cfg")
local monitorConfig = getConfig("monitors.cfg")
local serverConfig = getConfig("server.cfg")
local debugConfig = getConfig("debug.cfg")

-- setup debug
local debugMon = peripheral.wrap(debugConfig.monitor)
debug.setEnabled(debugConfig.enabled and debugMon)
debug.setMonitor(debugMon)
debug.print("Debug initialized")

-- Event manager
local eventManager = ||EventManager new| init|

-- modules
local modules = {}
for i,v in ipairs(fs.list(fs.combine(root, "modules"))) do
	local ModuleClass = require(fs.combine("modules", v))
	assert(ModuleClass and |ModuleClass isSubclassOf:Module|, "Modules must return a subclass of Module: "..v)
	local module = ||ModuleClass new| init|
	table.insert(modules, module)
end

for i,v in ipairs(modules) do
	|v loadModule|
	|eventManager addEventHandler:v|
end
table.sort(modules, function(a,b) return a.name < b.name end)

-- monitors
mu.setModuleTable(modules)
mu.setDefaultModule(monitorConfig.default)
|eventManager addEventHandler:mu.new(term.current(), true, "mouse_click", 1)|

for k,v in pairs(monitorConfig) do
	local mon = peripheral.wrap(k)
	if mon then
		|eventManager addEventHandler:||Monitor new| initWithWindow:mon
			                                                modules:modules
			                                          defaultModule:v
			                                            shouldSpace:false
			                                        eventParameters:"monitor_touch", k||
	end
end

-- Server
|eventManager addEventHandler:||Server new| initWithConfig:serverConfig||

-- start parallellizing
|eventManager update|
parallel.waitForAny(eventManager.start, function()
	while true do
		sleep(generalConfig.updateTime)
		|eventManager update|
	end
end)