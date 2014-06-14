local ccWindow = window
local eu = require("EventUtils.lua")

return @class:LuaObject
	@property window
	@property modules
	@property eventParameters
	
	local index
	local subWindow

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

		local w, h = window.getSize()
		subWindow = ccWindow.create(window, 1, 1, w, h-2)

		return self
	end

	function (update)
		local w, h = window.getSize()
		subWindow.reposition(1,1, w, h - 2)

		local module = modules[index]
		|module drawInWindow:subWindow|

		local colors = |module navBarColors|

		window.setBackgroundColor(colors.background)
		window.setCursorPos(1, h - 1)
		window.clearLine()
		window.setCursorPos(1, h)
		window.clearLine()

		window.setTextColor(colors.labelColor)
		window.setCursorPos(math.round(w / 2) - math.round(#(module.name) / 2), h)
		window.write(module.name)
		
		window.setBackgroundColor(colors.buttonBackground)
		window.setTextColor(colors.buttonColor)

		window.setCursorPos(1, h-1)
		window.write("<<")
		window.setCursorPos(1, h)
		window.write("<<")
		window.setCursorPos(w-1, h-1)
		window.write(">>")
		window.setCursorPos(w-1, h)
		window.write(">>")
	end

	function (respondToEvent:event)
		if event[1] == "monitor_resize" or event[1] == "term_resize" then
			return true
		end
		if not eu.matchesParameters(event, eventParameters) then
			return false
		end

		local w, h = window.getSize()
		local x, y = eu.select(event, 3)
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