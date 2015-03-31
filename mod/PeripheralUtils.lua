local periph = {}

local peripheralHandlers = {}

local function split(name)
    local pat = "([^|]+)|(.+)"
    if name:match(pat) then
        local pre, post = name:gmatch(pat)()
        return post, pre
    else
        return name
    end
end

function periph.addPeripheralHandler(h, name)
    peripheralHandlers[name] = h
end

function periph.removePeripheralHandler(name)
    peripheralHandlers[name] = nil
end

function periph.isPresent(fullName)
    local name, handler = split(fullName)
    return (peripheralHandlers[handler] or peripheral).isPresent(name)
end

function periph.getType(fullName)
    local name, handler = split(fullName)
    return (peripheralHandlers[handler] or peripheral).getType(name)
end

function periph.getMethods(fullName)
    local name, handler = split(fullName)
    return (peripheralHandlers[handler] or peripheral).getMethods(name)
end

function periph.call(fullName, ...)
    local name, handler = split(fullName)
    return (peripheralHandlers[handler] or peripheral).call(name, ...)
end

function periph.getNames()
    local names = peripheral.getNames()
    for k,v in pairs(peripheralHandlers) do
        for i,name in ipairs(v.getNames()) do
            table.insert(names, name)
        end
    end
    return names
end

function periph.wrap(name)
    local p = {}
    local methods = periph.getMethods(name)
    for i,method in ipairs(methods) do
        p[method] = function(...)
            return periph.call(name, method, ...)
        end
    end
    return p
end

function periph.find(type)
    local found = {}

    for i,name in ipairs(periph.getNames()) do
        local p = periph.wrap(name)
        if periph.getType(name) == type or (p.listSources and p.listSources()[type]) then
            table.insert(found, p)
        end
    end

    return unpack(found)
end

return periph