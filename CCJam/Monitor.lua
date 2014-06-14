local ccWindow = window

return @class:LuaObject
	@property window
	@property modules
	@property eventParameters
	
	local index

	function (initWithWindow:window modules:modules defaultModule:default eventParameters:...)
		|super init|
		self.window = window
		self.modules = modules
		eventParameters = {...}

		for i,v in ipairs(modules) do
			if v.name == default then
				index = i
			end
		end
		index = index or 1

		return self
	end

	function (update)
		local w, h = window.getSize()
		window.clear()

		local module = modules[index]
		|module drawInWindow:ccWindow.create(window, 1, 1, w, h-2)|

		window.setCursorPos(1, h - 1)
		window.setBackgroundColor(colors.yellow)
		window.setTextColor(colors.black)
		window.write("<<"..(" "):rep(w - 4)..">>")
		window.setCursorPos(1, h)
		window.write("<<"..(" "):rep(w - 4)..">>")
		window.setCursorPos(math.round(w / 2) - math.round(#(module.name) / 2), h)
		window.write(module.name)
	end

	function (respondToEvent:...)
		local parameters = {...}

		for i,v in ipairs(eventParameters) do
			if v ~= parameters[i] then
				return false
			end
		end



		return true
	end
end