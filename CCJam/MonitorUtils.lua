local mu = {}
local modules
local default

local Monitor = require("Monitor.lua")

function mu.setModuleTable(tbl)
	modules = tbl
end

function mu.setDefaultModule(str)
	default = str
end

function mu.newWithClass(Class, window, shouldSpace, ...)
	return ||Class new| initWithWindow:window
	                           modules:modules
	                     defaultModule:default
	                       shouldSpace:shouldSpace
	                   eventParameters:...|
end

function mu.new(window, shouldSpace, ...)
	return mu.newWithClass(Monitor, window, shouldSpace, ...)
end

function mu.createNetworkedWindow(senderId, w, h)
	local window = {}
	local cx, cy = 1,1
	local bg, fg = colors.black, colors.white

	local tLines = {}
	for i=1,h do
		tLines[i] = {}
	end

	function window.write(text)
		for c=1, #text do
			tLines[cy][cx] = {bg=bg,fg=fg,c=text:sub(c,c)}
			cx = cx + 1
		end
	end

	function window.clear()
		for x=1,w do
			for y=1,h do
				tLines[y][x] = {bg=bg, fg=fg, c=" "}
			end
		end
	end

	function window.clearLine()
		for x=1, w do
			tLines[cy][x] = {bg=bg, fg=fg, c=" "}
		end
	end

	function window.getCursorPos()
		return cx, cy
	end

	function window.setCursorPos(x, y)
		cx, cy = x, y
	end

	function window.setCursorBlink(bool) end
	
	function window.isColor()
		return true
	end

	function window.getSize()
		return w, h
	end

	function window.scroll(n)
		for y=1, h - 1 do
			tLines[y] = tLines[y + 1]
		end
		tLines[h] = {}
	end

	function window.setTextColor(color)
		fg = color
	end

	function window.setBackgroundColor(color)
		bg = color
	end

	function window.sendScreen()
		rednet.send(senderId, {type="screen", lines=tLines}, "elvishjerricco.ccjam.jun14")
	end

	return window
end

return mu