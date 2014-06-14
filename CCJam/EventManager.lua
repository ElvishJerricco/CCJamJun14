local Event = require("Event.lua")

return @class:LuaObject
	local eventHandlers = {}

	function (addEventHandler:handler)
		table.insert(eventHandlers, handler)
	end

	function (addHandlersFromArray:handlers)
		for i,v in ipairs(handlers) do
			table.insert(eventHandlers, v)
		end
	end

	function (update)
		for i,v in ipairs(eventHandlers) do
			|v update|
		end
	end

	function (start)
		while true do
			local event = ||Event new| initWithParameters:{os.pullEvent()}|
			event.manager = self
			local shouldUpdate
			for i,v in ipairs(eventHandlers) do
				shouldUpdate = shouldUpdate or |v respondToEvent:event|
			end

			if shouldUpdate then
				|@ update|
			end
		end
	end
end