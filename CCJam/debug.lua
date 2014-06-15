local debug = {}
local mon
local enabled

function debug.print(...)
	if enabled then
		local t = {}
		for i,v in ipairs({...}) do
			table.insert(t, tostring(v))
		end
		local str = table.concat(t)

		local w,h = mon.getSize()
		local lines = math.ceil(#str / w)

		local x,y = mon.getCursorPos()
		mon.setCursorPos(1,y)
		for i=1,lines do
			local start = (i-1)*w + 1
			mon.write( str:sub(start, start + w - 1) )
			y = y + 1
			if y > h then
				mon.scroll(1)
				y = y - 1
			end
			mon.setCursorPos(1, y)
		end
	end
end

function debug.setMonitor(m)
	mon = m
	if enabled then
		mon.setTextColor(colors.white)
		mon.setBackgroundColor(colors.black)
		mon.setCursorPos(1,1)
		mon.clear()
	end
end

function debug.setEnabled(bool)
	enabled = bool
end

return debug