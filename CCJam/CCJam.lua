local function getConfig(name)
	local file = assert(
		fs.open(
			fs.combine(
				"CCJam/config/",
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
table.insert(monitors, ||Monitor new| initWithDefaultScreen:monitorConfig.default
                                            eventParameters:"mouse_click", 1|)

for k,v in pairs(monitorConfig) do
	table.insert(monitors, ||Monitor new| initWithDefaultScreen:v
		                                        eventParameters:"monitor_touch", k|)
end