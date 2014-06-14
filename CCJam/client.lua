local args = {...}
if #args < 1 then
	error("Usage: client hostname", 0)
end

rednet.open("back")
local hostname = args[1]
local serverId = rednet.lookup("elvishjerricco.ccjam.jun14", hostname)
print("server",":",serverId)

local w, h = term.getSize()
rednet.send(serverId, {type="connect", termWidth=w, termHeight=h}, "elvishjerricco.ccjam.jun14")


parallel.waitForAny(function()
	while true do

		local sender, msg = rednet.receive("elvishjerricco.ccjam.jun14")
		if sender == serverId then
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
			end
		end

	end
end, function()
	while true do
		local e, button, x, y = os.pullEvent("mouse_click")
		if button == 1 then
			rednet.send(serverId, {type="click", x=x, y=y}, "elvishjerricco.ccjam.jun14")
		end
	end
end)