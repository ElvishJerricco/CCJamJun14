local mu = require("MonitorUtils.lua")
local eu = require("EventUtils.lua")
local NetworkedMonitor = require("NetworkedMonitor.lua")

return @class:LuaObject
	function (initWithConfig:config)
		|super init|
		for i,v in ipairs(config.modems) do
			rednet.open(v)
		end
		rednet.host("elvishjerricco.ccjam.jun14", config.hostname)
		return self
	end

	function (update)
	end

	function (respondToEvent:event)
		local eventType, senderId, msg, protocol = eu.select(event, 1)
		if eventType == "rednet_message" and protocol == "elvishjerricco.ccjam.jun14" and type(msg) == "table" then
			if msg.type == "connect" then
				local window = mu.createNetworkedWindow(senderId, msg.termWidth, msg.termHeight)
				|event.manager addEventHandler:mu.newWithClass(NetworkedMonitor, window, true, "remote_click", senderId)|
				return true
			elseif msg.type == "click" then
				os.queueEvent("remote_click", senderId, msg.x, msg.y)
				return false -- the respondToEvent: call resulting from this event will cause an update
			end

		end
		return false
	end
end