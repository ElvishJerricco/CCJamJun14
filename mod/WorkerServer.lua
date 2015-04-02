local pu = require("PeripheralUtils.lua")

return @class:require("RednetServer.lua")
    function (initWithRednetConfig:rcfg)
        |super initWithRednetConfig:rcfg protocol:"team_cc_corp.cinnamon.worker"|
        return self
    end

    local cache = {}

    function (newClientWithUID:uid computerId:computerId connectMessage:msg)
        local client = |super newClientWithUID:uid computerId:computerId connectMessage:msg|

        local p = {}
        for i,method in ipairs{"isPresent", "getType", "getMethods", "call", "getNames"} do
            p[method] = function(...)
                local callID = math.random()
                |client sendMessage:{type="peripheral_call", method=method, parameters={...}, callID=callID}|
                local sender, msg
                repeat
                    sender, msg = rednet.receive(self.protocol)
                until msg.callID == callID
                return unpack(msg.returnValues)
            end
        end

        -- add caching to functinos with a 'name' first parameter
        for i,method in ipairs{"isPresent", "getType", "getMethods"} do
            local old = p[method]
            p[method] = function(name)
                if not cache[client] then
                    cache[client] = {}
                end
                if not cache[client][name] then
                    cache[client][name] = {}
                end

                if cache[client][name][method] then
                    return unpack(cache[client][name][method])
                end
                local ret = {old(name)}
                cache[client][name][method] = ret
                return unpack(ret)
            end
        end

        local oldGetNames = p.getNames
        function p.getNames()
            if not cache[client] then
                cache[client] = {}
            end

            if cache[client].getNames then
                return unpack(cache[client].getNames)
            end

            local ret = {oldGetNames(name)}
            cache[client].getNames = ret
            return unpack(ret)
        end

        local oldCall = p.call
        function p.call(name, method, ...)
            if method == "listSources" then
                cache[client].call = cache[client].call or {}
                if not cache[client].call.listSources then
                    cache[client].call.listSources = {oldCall(name, method, ...)}
                end
                return unpack(cache[client].call.listSources)
            end
            return oldCall(name, method, ...)
        end

        pu.addPeripheralHandler(p, client.uid)

        return client
    end

    function (receiveMessage:msg client:client)
        if msg.type == "clear_peripheral" then
            if not cache[client] then
                cache[client] = {}
            end
            cache[client][msg.peripheral_name] = nil
            cache[client].getNames = nil
        end
        return false
    end

    function (removeClient:client)
        pu.removePeripheralHandler(client.uid)
        |super removeClient:client|
    end
end