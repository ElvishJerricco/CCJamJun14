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
		return {
			background=colors.gray,
			labelColor=colors.white,
			buttonBackground=colors.lightGray,
			buttonColor=colors.white
		}
	end
end