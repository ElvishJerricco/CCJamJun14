local gu = require("GraphicsUtils.lua")
local periph = require("PeripheralUtils.lua")

return @class:require("Module.lua")
    local function determineDisabled()
        if #({periph.find("solid_fueled_boiler_firebox")})
        +  #({periph.find("liquid_fueled_boiler_firebox")})
        == 0 then
            self.disabled = true
        else
            self.disabled = false
        end
    end

    function (loadModule)
        self.name = "Boilers"
        determineDisabled()
    end

    function (update)
        determineDisabled()
    end

    function (drawInWindow:win)
        local solidBoilers = {periph.find("solid_fueled_boiler_firebox")}
        local liquidBoilers = {periph.find("liquid_fueled_boiler_firebox")}

        -- do all calculations before any drawing
        local bars = {}

        for i,v in ipairs(solidBoilers) do
            table.insert(bars, {name="Solid Boiler "..i.." Temp",val=v.getTemperature() / 1000})
            for i2,v2 in ipairs(v.getTankInfo()) do
                if v2.contents.rawName then
                    table.insert(bars, {name=v2.contents.rawName,val=v2.contents.amount/v2.capacity,offset=1})
                end
            end
        end
        for i,v in ipairs(liquidBoilers) do
            table.insert(bars, {name="Liquid Boiler "..i.." Temp",val=v.getTemperature() / 1000})
            for i2,v2 in ipairs(v.getTankInfo()) do
                if v2.contents.rawName then
                    table.insert(bars, {name=v2.contents.rawName,val=v2.contents.amount/v2.capacity,offset=1})
                end
            end
        end

        -- Draw

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
                thin,
                v.offset
            )
            toggleColors()
        end
    end
end