-- util
local function round(n)
	return math.floor(n + .5)
end

-- API
local gu = {}

--remind me to implement a syntax for this in LuaLua
gu["drawBarInWindow:named:filledTo:color:textColor:"] = function(window, name, val, color, textColor)
	if val > 1 then
		val = 1
	else if val < 0 then
		val = 0
	end

	local x, y = window.getCursorPos()
	x = 1
	y = y + 1
	window.setCursorPos(x, y)

	local barWidth = round(window.getSize() * val)

	window.setBackgroundColor(color)
	window.setTextColor(color)
	window.write((" "):rep(barWidth))
	window.write(" " .. name .. (" "):rep(barWidth - #name - 1))
	window.write((" "):rep(barWidth))
end

return gu