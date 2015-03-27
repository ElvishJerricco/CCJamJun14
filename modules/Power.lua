local gu = require("GraphicsUtils.lua")

local function find(type)
	local found = {}
	for i,v in ipairs(peripheral.getNames()) do
		if peripheral.getType(v):find("^"..type) then
			table.insert(found, peripheral.wrap(v))
		end
	end
	return unpack(found)
end

return @class:require("Module.lua")
	local function determineDisabled()
		if #({find("solid_fueled_boiler_firebox")})
		+  #({find("liquid_fueled_boiler_firebox")})
		+  #({find("tile_thermalexpansion_cell")})
		== 0 then
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
		local solidBoilers = {find("solid_fueled_boiler_firebox")}
		local liquidBoilers = {find("liquid_fueled_boiler_firebox")}
		local energyCells = {find("tile_thermalexpansion_cell")}

		-- do all calculations before any drawing
		local bars = {}

		for i,v in ipairs(solidBoilers) do
			table.insert(bars, {name="Solid Boiler "..i.." Temp",val=v.getTemperature() / 1000})
			for i2,v2 in ipairs(v.getTankInfo("north")) do
				if v2.rawName then
					table.insert(bars, {name="Solid Boiler "..i.." "..v2.rawName,val=v2.amount/v2.capacity})
				end
			end
		end
		for i,v in ipairs(liquidBoilers) do
			table.insert(bars, {name="Liquid Boiler "..i.." Temp",val=v.getTemperature() / 1000})
			for i2,v2 in ipairs(v.getTankInfo("north")) do
				if v2.rawName then
					table.insert(bars, {name="Liquid Boiler "..i.." "..v2.rawName,val=v2.amount/v2.capacity})
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