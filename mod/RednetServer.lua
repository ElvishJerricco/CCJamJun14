local eu = require("EventUtils.lua")
local NetworkClient = require("NetworkClient.lua")

return @class:LuaObject
    @property(readonly) rednetConfig = _rcfg
    @property(readonly) protocol = _protocol
    local timer
    local clients = {}
    local livingClients = {}
    local newClients = {} -- track clients not to be removed at next timer

    function (initWithRednetConfig:rcfg protocol:protocol)
        |super init|
        _rcfg = rcfg
        _protocol = protocol
        return self
    end

    function (open)
        |self.rednetConfig open|
        rednet.host(self.protocol, self.rednetConfig.hostname)
        timer = os.startTimer(self.rednetConfig.keepAlive)
    end

    function (newClientWithUID:uid computerId:computerId connectMessage:msg)
        return ||NetworkClient new| initWithUID:uid computerId:computerId server:self|
    end

    function (getClient:id)
        for i,v in ipairs(clients) do
            if v.uid == id then
                return v
            end
        end
        for i,v in ipairs(newClients) do
            if v.uid == id then
                return v
            end
        end
    end

    function (receiveMessage:msg)
        return false
    end

    function (removeClient:client)
        local function remove(client)
            |client remove|
        end

        for i,v in ipairs(clients) do
            if v == client then
                remove(client)
                table.remove(clients, i)
                break
            end
        end
        for i,v in ipairs(newClients) do
            if v == client then
                remove(client)
                table.remove(newClients, i)
                break
            end
        end
    end

    function (update)
    end

    function (respondToEvent:event)
        local eventType, senderId, msg, protocol = eu.select(event, 1)
        if eventType == "rednet_message" and protocol == self.protocol and type(msg) == "table" then
            if msg.type == "connect" then
                local id = senderId ..":".. os.time() -- should be sufficiently unique
                local client = |self newClientWithUID:id computerId:senderId connectMessage:msg|

                table.insert(newClients, client)
                |client sendMessage:{type="giveId"}|

                return true
            elseif msg.type == "keepAliveResponse" then
                livingClients[msg.id] = true
                return false
            else
                return |self receiveMessage:msg|
            end
        elseif eventType == "timer" and event[2] == timer then
            local removals = {}
            for i,v in ipairs(clients) do
                if not livingClients[v.uid] then
                    table.insert(removals, v)
                end
            end
            for i,v in ipairs(removals) do
                |self removeClient:v|
            end
            livingClients = {}

            for i,v in ipairs(newClients) do
                table.insert(clients, v)
            end
            newClients = {}

            for i,v in ipairs(clients) do
                |v sendMessage:{type="keepAlive"}|
            end
            timer = os.startTimer(self.rednetConfig.keepAlive)
        end
        return false
    end

    function (terminate)
        print("Unhosting " .. protocol .. "://" .. self.rednetConfig.hostname)
        rednet.unhost(protocol, self.rednetConfig.hostname)
    end
end