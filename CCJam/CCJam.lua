-- Import classes
local Monitor = require("Monitor.lua")
local Module = require("Module.lua")

-- Root directory
local root = fs.getDir(shell.getRunningProgram())

-- Utility; The way fs.combine SHOULD behave
local function combine(str1, str2, ...)
	if not str2 then
		return str1
	end
	return fs.combine(str1, combine(str2, ...))
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
local monitorConfig = getConfig("monitors.cfg")
local serverConfig = getConfig("server.cfg")

-- Load all the monitors requested by the config
local monitors = {}
table.insert(monitors, ||Monitor new| initWithEventParameters:"mouse_click", 1|)

for k,v in pairs(monitorConfig) do
	table.insert(monitors, ||Monitor new| initWithEventParameters:"monitor_touch", k|)
end

-- Load modules
local modules = {}
for i,v in ipairs(fs.list(combine(root, "modules"))) do
	local ModuleClass = require(fs.combine("modules", v))
	assert(ModuleClass and |ModuleClass isSubclassOf:Module|, "Modules must return a subclass of Module")
	local module = ||ModuleClass new| init|
	table.insert(modules, module)
end

for i,v in ipairs(modules) do
	|v loadModule|
end

-- Link modules and monitors