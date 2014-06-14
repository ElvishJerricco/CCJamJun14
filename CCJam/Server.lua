return @class:LuaObject
	function (initWithConfig:config)
		rednet.open(config.modem)
		rednet.host("elvishjerricco.ccjam.jun14", config.hostname)
	end

	function (start)
		while true do
			local id, msg = rednet.receive("elvishjerricco.ccjam.jun14")
		end
	end
end