local gu = require("../GraphicsUtils.lua")

return @class:require("../Module.lua")
	function (loadModule)
		self.name = "Power"
	end

	function (drawInWindow:win)
		local boilers = {peripheral.find("solid_fueled_boiler_firebox")}
		local energyCells = {peripheral.find("cofh_thermalexpansion_energycell")}
		local aeControllers = {peripheral.find("appeng_me_tilecontroller")} -- getMaxMJStored -- getMJStored

		-- do all calculations before any drawing
		local bars = {}

		for i,v in ipairs(boilers) do
			table.insert(bars, {name="Boiler "..i.." Temp",val=v.getTemperature() / 1000})
			for i2,v2 in ipairs(v.getTankInfo("north")) do
				if v2.rawName then
					table.insert(bars, {name="Boiler "..i.." "..v2.rawName,val=v2.amount/v2.capacity})
				end
			end
		end

		for i,v in ipairs(energyCells) do
			table.insert(bars, {name="Energy Cell "..i,val=v.getEnergyStored("north")/v.getMaxEnergyStored("north")})
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