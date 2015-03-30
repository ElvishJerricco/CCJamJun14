local mu = require("MonitorUtils.lua")
local eu = require("EventUtils.lua")
local NetworkMonitor = require("NetworkMonitor.lua")
local NetworkClient = require("NetworkClient.lua")

return @class:require("RednetServer.lua")
	@property eventManager -- event manager will set this
	local monitors = {}

	function (initWithRednetConfig:rcfg)
		|super initWithRednetConfig:rcfg protocol:"elvishjerricco.cinnamon"|
		return self
	end

    function (newClientWithUID:uid computerId:computerId connectMessage:msg)
    	local client = |super newClientWithUID:uid computerId:computerId connectMessage:msg|

		local window = mu.createNetworkWindow(function(tLines)
			|client sendMessage:{type="screen", lines=tLines}|
		end, msg.termWidth, msg.termHeight)
		local monitor = mu.newWithClass(NetworkMonitor, window, "remote_click", id)

		monitor.client = client

		monitors[client] = monitor
		|eventManager addEventHandler:monitor|

    	return client
    end

    function (removeClient:client)
    	local monitor = monitors[client]
    	monitors[client] = nil
    	|eventManager removeEventHandler:monitor|
    	|super removeClient|
    end

    function (receiveMessage:msg)
    	if msg.type == "click" then
			os.queueEvent("remote_click", msg.id, msg.x, msg.y)
			return false -- the respondToEvent: call resulting from this event will cause an update
		end
		return false
    end
end