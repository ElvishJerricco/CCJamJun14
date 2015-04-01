local periph = require("PeripheralUtils.lua")

return @class:require("Module.lua")
    local function determineDisabled()
        if #({periph.find("BigReactors-Reactor")})
        +  #({periph.find("BigReactors-Turbine")})
        == 0 then
            self.disabled = true
        else
            self.disabled = false
        end
    end

    function (loadModule)
        self.name = "Big Reactors"
        determineDisabled()
    end

    function (update)
        determineDisabled()
    end

    function (drawInWindow:win)
        local old = term.current()
        term.redirect(win)

        local reactors = {periph.find("BigReactors-Reactor")}
        local turbines = {periph.find("BigReactors-Turbine")}

        win.setBackgroundColor(colors.black)
        win.setCursorPos(1,1)
        win.clear()

        for i,react in ipairs(reactors) do
            if react.getConnected() then
                if react.isActivelyCooled() then
                    win.setBackgroundColor(colors.lightBlue)
                    win.setTextColor(colors.white)
                else
                    win.setBackgroundColor(colors.gray)
                    win.setTextColor(colors.yellow)
                end
                write("R"..i)

                local active = react.getActive()
                local fuelTemp = react.getFuelTemperature()
                local hullTemp = react.getCasingTemperature()
                local fuel = react.getFuelConsumedLastTick()
                local energy = react.getEnergyProducedLastTick()
                local fluid = react.getHotFluidProducedLastTick()

                win.setBackgroundColor(active and colors.lime or colors.red)
                win.setTextColor(active and colors.white or colors.black)
                write(" Active ")

                win.setBackgroundColor(colors.black)
                win.setTextColor(colors.orange)
                write(string.format(" Fuel Temp: %.0dC", fuelTemp))

                win.setTextColor(colors.lightGray)
                write(string.format(" Hull Temp: %.0dC", hullTemp))

                win.setTextColor(colors.yellow)
                write(string.format(" Fuel Usage: %smB/t", (""..fuel):gsub("%.(%d+)", \(w) return "."..w:sub(1,2) end)))

                win.setTextColor(colors.red)
                if react.isActivelyCooled() then
                    write(string.format(" Steam: %dmB/t", fluid))
                else
                    write(string.format(" %.0dRF/t", energy))
                end

                write"\n"
            end
        end

        for i,turb in ipairs(turbines) do
            if turb.getConnected() then
                local active = turb.getActive()
                local coils = turb.getInductorEngaged()
                local energy = turb.getEnergyProducedLastTick()
                local rotor = turb.getRotorSpeed()

                win.setBackgroundColor(colors.lightGray)
                win.setTextColor(colors.black)
                write("T"..i)

                win.setBackgroundColor(active and colors.lime or colors.red)
                win.setTextColor(active and colors.white or colors.black)
                write(" Active ")

                win.setBackgroundColor(coils and colors.lime or colors.red)
                win.setTextColor(coils and colors.white or colors.black)
                write(" Coils ")

                win.setBackgroundColor(colors.black)
                win.setTextColor(colors.yellow)
                write(string.format(" %.0dRF/t", energy))

                win.setTextColor(colors.lightBlue)
                write(string.format(" %.0drpm", rotor))

                write"\n"
            end
        end

        term.redirect(old)
    end
end