local args = {...}
if #args < 1 then
	error("Usage: client hostname", 0)
end

rednet.open("back")
local hostname = args[1]
local serverId = rednet.lookup("elvishjerricco.cinnamon", hostname)
assert(serverId, "No server found")
print("server",":",serverId)

local w, h = term.getSize()
rednet.send(serverId, {type="connect", termWidth=w, termHeight=h}, "elvishjerricco.cinnamon")

local id
repeat
	local sender, msg = rednet.receive("elvishjerricco.cinnamon")
	if sender == serverId and msg.type == "giveId" then
		id = msg.id
	end
until id
print("Acquired id: ", id)



parallel.waitForAny(function()
	while true do

		local sender, msg = rednet.receive("elvishjerricco.cinnamon")
		if sender == serverId and msg.id == id then
			if msg.type == "screen" then
				for y=1, #(msg.lines) do
					for x=1, #(msg.lines[y]) do
						p = msg.lines[y][x]
						term.setCursorPos(x,y)
						term.setBackgroundColor(p.bg)
						term.setTextColor(p.fg)
						term.write(p.c)
					end
				end
			elseif msg.type == "keepAlive" then
				rednet.send(serverId, {type="keepAliveResponse",id=id}, "elvishjerricco.cinnamon")
			end
		end

	end
end, function()
	while true do
		local e, button, x, y = os.pullEvent("mouse_click")
		if button == 1 then
			rednet.send(serverId, {type="click", id=id, x=x, y=y}, "elvishjerricco.cinnamon")
		end
	end
end)