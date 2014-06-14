-- API
local gu = {}

--remind me to implement a syntax for this in LuaLua
function gu.drawBarInWindow(window, name, val, color, backgroundColor, textColor, thin)
	if val > 1 then
		val = 1
	elseif val < 0 then
		val = 0
	end

	local width, height = window.getSize()
	local x, y = window.getCursorPos()
	x = 1
	window.setCursorPos(x, y)

	local barWidth = math.round(width * val)

	window.setBackgroundColor(color)
	window.setTextColor(textColor)

	if not thin then
		window.write((" "):rep(barWidth))
		window.setBackgroundColor(backgroundColor)
		window.write((" "):rep(width))
		window.setBackgroundColor(color)
		y = y + 1
	end

	window.setCursorPos(x, y)
	name = " " .. name
	local name1 = name:sub(1, barWidth)
	local name2 = name:sub(barWidth + 1)
	window.write(name1 .. (" "):rep(math.max(barWidth - #name1, 0)))
	window.setBackgroundColor(backgroundColor)
	window.write(name2..(" "):rep(width))
	window.setBackgroundColor(color)
	
	if not thin then
		y = y + 1
		window.setCursorPos(x, y)
		window.write((" "):rep(barWidth))
		window.setBackgroundColor(backgroundColor)
		window.write((" "):rep(width))
		window.setBackgroundColor(color)
	end

	y = y + 1
	window.setCursorPos(x,y)
end

return gu