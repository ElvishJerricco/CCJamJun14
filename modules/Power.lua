local gu = require("GraphicsUtils.lua")
local periph = require("PeripheralUtils.lua")

return @class:require("Module.lua")
	local function determineDisabled()
		if #({periph.find("rf_provider")}) == 0 then
			self.disabled = true
		else
			self.disabled = false
		end
	end

	function (loadModule)
		self.name = "Power"
		determineDisabled()
	end

	function (update)
		determineDisabled()
	end

	function (drawInWindow:win)
		local energyCells = {periph.find("rf_provider")}

		-- do all calculations before any drawing
		local bars = {}

		for i,v in ipairs(energyCells) do
			table.insert(bars, {name="RF Provider "..i,val=v.getEnergyStored()/v.getMaxEnergyStored()})
		end

		local w,h = win.getSize()
		local thin = #bars * 3 > h

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
		for i,v in ipairs(bars) do
			gu.drawBarInWindow(
				win,
				v.name,
				v.val,
				fg, bg, tc,
				thin
			)
			toggleColors()
		end
	end
end