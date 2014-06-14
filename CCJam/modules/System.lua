local gu = require("../GraphicsUtils.lua")

local function getUsedSpace(path)
	local total = 0
	for i,v in ipairs(fs.list(path)) do
		local full = fs.combine(path, v)
		if fs.isDir(full) then
			total = total + getUsedSpace(full)
		else
			total = total + fs.getSize(full)
		end
	end
	return total
end

return @class:require("../Module.lua")
	function (loadModule)
		self.name = "System"
	end

	function (drawInWindow:win)
		local freeSpace = fs.getFreeSpace("")
		local usedSpace = getUsedSpace("")
		local totalSpace = usedSpace + freeSpace

		win.setBackgroundColor(colors.black)
		win.clear()
		win.setCursorPos(1,2)
		gu.drawBarInWindow(
			win,
			string.format("HDD %d / %d", usedSpace, totalSpace),
			usedSpace / totalSpace,
			colors.lightGray,
			colors.gray,
			colors.white
		)
	end
end