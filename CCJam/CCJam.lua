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