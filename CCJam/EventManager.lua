return @class:LuaObject
	local eventHandlers = {}

	function (initWithEventHandlers:_eventHandlers)
		|super init|
		eventHandlers = _eventHandlers
		return self
	end

	function (update)
		for i,v in ipairs(eventHandlers) do
			|v update|
		end
	end

	function (start)
		while true do
			local event = {os.pullEvent()}
			local shouldUpdate
			for i,v in ipairs(eventHandlers) do
				shouldUpdate = shouldUpdate or |v respondToEvent:unpack(event)|
			end

			if shouldUpdate then
				|@ update|
			end
		end
	end
end