local gu = require("../GraphicsUtils.lua")

local function getUsedSpace(path)
	local total = 0
	for i,v in ipairs(fs.list(path)) do
		local full = fs.combine(path, v)
		if fs.isDir(full) then
			if fs.getDrive(full) == fs.getDrive(path) then
				total = total + getUsedSpace(full)
			end
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
		local drives = {{name="HDD",used=getUsedSpace(""),free=fs.getFreeSpace("")}}
		for i,v in ipairs(fs.list("")) do
			if fs.getDrive(v) ~= fs.getDrive("") and not fs.isReadOnly(v) then
				table.insert(drives, {name=v:sub(1,1):upper()..v:sub(2),used=getUsedSpace(v),free=fs.getFreeSpace(v)})
			end
		end

		local w,h = win.getSize()
		local thin = #drives * 3 > h

		local fg, bg, tc = colors.yellow, colors.gray, colors.black
		local function toggleColors()
			if fg == colors.yellow then
				fg, bg, tc = colors.lightGray, colors.gray, colors.white
			else
				fg, bg, tc = colors.yellow, colors.gray, colors.black
			end
		end

		win.setBackgroundColor(colors.black)
		win.setCursorPos(1,1)
		win.clear()
		for i,v in ipairs(drives) do
			gu.drawBarInWindow(
				win,
				v.name,
				v.used / (v.used + v.free),
				fg, bg, tc,
				thin
			)
			toggleColors()
		end
	end
end