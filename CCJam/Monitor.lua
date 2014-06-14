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

		local module = modules[index]
		|module drawInWindow:ccWindow.create(window, 1, 1, w, h-2)|

		local bgc, tc = |module navBarColors|
		window.setCursorPos(1, h - 1)
		window.setBackgroundColor(bgc)
		window.setTextColor(tc)
		window.write("<<"..(" "):rep(w - 4)..">>")
		window.setCursorPos(1, h)
		window.write("<<"..(" "):rep(w - 4)..">>")
		window.setCursorPos(math.round(w / 2) - math.round(#(module.name) / 2), h)
		window.write(module.name)
	end

	function (respondToEvent:event)
		if not |event matchesParameters:eventParameters| then
			return false
		end

		local w, h = window.getSize()
		local x, y = |event select:3|
		if y >= h - 2 then
			if x <= 2 then
				index = index - 1
				if index < 1 then
					index = #modules
				end
				return true
			elseif x >= w - 1 then
				index = index + 1
				if index > #modules then
					index = 1
				end
				return true
			end
		end

		return false
	end
end