local args = {...}
if #args < 1 then
    error("Usage: cinnamon_worker hostname", 0)
end

rednet.open("back")
local hostname = args[1]
local serverId = rednet.lookup("team_cc_corp.cinnamon.worker", hostname)
assert(serverId, "No server found")
print("server",":",serverId)

local w, h = term.getSize()
rednet.send(serverId, {type="connect", termWidth=w, termHeight=h}, "team_cc_corp.cinnamon.worker")

local id
repeat
    local sender, msg = rednet.receive("team_cc_corp.cinnamon.worker")
    if sender == serverId and msg.type == "giveId" then
        id = msg.id
    end
until id
print("Acquired id: ", id)



parallel.waitForAny(function()
    while true do

        local sender, msg = rednet.receive("team_cc_corp.cinnamon.worker")
        if sender == serverId and msg.id == id then
            if msg.type == "peripheral_call" then
                local method, parameters, callID = msg.method, msg.parameters, msg.callID
                local ret = {peripheral[method](unpack(parameters))}
                rednet.send(serverId, {callID=callID, returnValues=ret, id=id}, "team_cc_corp.cinnamon.worker")
            elseif msg.type == "keepAlive" then
                rednet.send(serverId, {type="keepAliveResponse",id=id}, "team_cc_corp.cinnamon.worker")
            end
        end

    end
end, function()
    while true do
        local e, name = os.pullEvent()
        if e == "peripheral" or e == "peripheral_detach" then
            rednet.send(serverId, {type="clear_peripheral",peripheral_name=name,id=id}, "team_cc_corp.cinnamon.worker")
        end
    end
end)