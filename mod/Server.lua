local mu = require("MonitorUtils.lua")
local eu = require("EventUtils.lua")
local NetworkMonitor = require("NetworkMonitor.lua")
local NetworkClient = require("NetworkClient.lua")

return @class:LuaObject
	@property keepAlive

	local timer
	local clients = {}
	local livingClients = {}
	local newClients = {} -- track clients not to be removed at next timer

	function (initWithConfig:config)
		|super init|
		for i,v in ipairs(config.modems) do
			rednet.open(v)
		end
		rednet.host("elvishjerricco.cinnamon", config.hostname)

		self.keepAlive = config.keepAlive
		timer = os.startTimer(self.keepAlive)

		return self
	end

	function (update)
	end

	function (sendMessage:msg client:id)
		local c
		for i,v in ipairs(clients) do
			if v.uid == id then
				c = v
			end
		end
		for i,v in ipairs(newClients) do
			if v.uid == id then
				c = v
			end
		end

		msg.id = c.uid
		rednet.send(c.computerId, msg, "elvishjerricco.cinnamon")
	end

	function (respondToEvent:event)
		local eventType, senderId, msg, protocol = eu.select(event, 1)
		if eventType == "rednet_message" and protocol == "elvishjerricco.cinnamon" and type(msg) == "table" then
			if msg.type == "connect" then
				local id = senderId ..":".. os.time() -- should be sufficiently unique

				local window = mu.createNetworkWindow(function(tLines)
					|@ sendMessage:{type="screen", lines=tLines} client:id|
				end, msg.termWidth, msg.termHeight)
				local client = ||NetworkClient new| initWithMonitor:mu.newWithClass(NetworkMonitor, window, "remote_click", id)
				                                                uid:id
				                                         computerId:senderId|
				|event.manager addEventHandler:client|

				table.insert(newClients, client)
				|@ sendMessage:{type="giveId"} client:id|

				return true
			elseif msg.type == "click" then
				os.queueEvent("remote_click", msg.id, msg.x, msg.y)
				return false -- the respondToEvent: call resulting from this event will cause an update
			elseif msg.type == "keepAliveResponse" then
				livingClients[msg.id] = true
				return false
			end
		elseif eventType == "timer" and event[2] == timer then
			local removals = {}
			for i,v in ipairs(clients) do
				if not livingClients[v.uid] then
					table.insert(removals, i)
				end
			end
			for i=#removals,1,-1 do
				|event.manager removeEventHandler:table.remove(clients, removals[i])|
			end
			livingClients = {}

			for i,v in ipairs(newClients) do
				table.insert(clients, v)
			end
			newClients = {}

			for i,v in ipairs(clients) do
				|@ sendMessage:{type="keepAlive"} client:v.uid|
			end
			timer = os.startTimer(keepAlive)
		end
		return false
	end
end