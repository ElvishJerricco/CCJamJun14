return @class:require("Monitor.lua")
	function (update)
		|super update|
		window.sendScreen()
	end
end