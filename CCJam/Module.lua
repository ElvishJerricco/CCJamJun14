return @class:LuaObject
	@property name

	function (loadModule)	
	end

	function (drawInWindow:win)
	end

	function (update)
	end

	function (respondToEvent:event)
		return false
	end

	function (navBarColors)
		return colors.yellow, colors.black
	end
end