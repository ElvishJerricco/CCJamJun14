local root = fs.getDir(shell.getRunningProgram())

local function combine(str1, str2, ...)
	if not str2 then
		return str1
	end
	return fs.combine(str1, combine(str2, ...))
end

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

local monitorConfig = getConfig("monitors.cfg")
local serverConfig = getConfig("server.cfg")


local Monitor = require("Monitor.lua")
local monitors = {}
table.insert(monitors, ||Monitor new| initWithEventParameters:"mouse_click", 1|)

for k,v in pairs(monitorConfig) do
	table.insert(monitors, ||Monitor new| initWithEventParameters:"monitor_touch", k|)
end