return @class:LuaObject
	function (initWithConfig:config)
		|super init|
		rednet.open(config.modem)
		rednet.host("elvishjerricco.ccjam.jun14", config.hostname)
		return self
	end

	function (start)
		while true do
			local id, msg = rednet.receive("elvishjerricco.ccjam.jun14")
		end
	end
end