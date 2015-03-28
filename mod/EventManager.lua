return @class:LuaObject
	local eventHandlers = {}

	function (addEventHandler:handler)
		table.insert(eventHandlers, handler)
	end

	function (removeEventHandler:handler)
		for i,v in ipairs(eventHandlers) do
			if v == handler then
				table.remove(eventHandlers, i)
				break
			end
		end
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
			local event = {os.pullEvent()}
			event.manager = self
			local shouldUpdate
			for i,v in ipairs(eventHandlers) do
				local thisHandlerShouldUpdate = |v respondToEvent:event|
				shouldUpdate = shouldUpdate or thisHandlerShouldUpdate
			end

			if shouldUpdate then
				|@ update|
			end
		end
	end

	function (terminate)
		for i,v in ipairs(eventHandlers) do
			|v terminate|
		end
	end
end