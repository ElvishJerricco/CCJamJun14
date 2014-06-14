-- API
local gu = {}

--remind me to implement a syntax for this in LuaLua
gu["drawBarInWindow:named:filledTo:color:backgroundColor:textColor:"] = function(window, name, val, color, backgroundColor, textColor)
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

	window.write((" "):rep(barWidth))
	window.setBackgroundColor(backgroundColor)
	window.write((" "):rep(width))
	window.setBackgroundColor(color)

	y = y + 1
	window.setCursorPos(x, y)
	window.write(" " .. name .. (" "):rep(math.max(barWidth - #name - 1, 0)))
	window.setBackgroundColor(backgroundColor)
	window.write((" "):rep(width))
	window.setBackgroundColor(color)
	
	y = y + 1
	window.setCursorPos(x, y)
	window.write((" "):rep(barWidth))
	window.setBackgroundColor(backgroundColor)
	window.write((" "):rep(width))
	window.setBackgroundColor(color)
end

return gu