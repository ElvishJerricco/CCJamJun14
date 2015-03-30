return @class:require("Monitor.lua")
    @property client
    
	function (update)
		|super update|
		window.sendScreen()
	end
end