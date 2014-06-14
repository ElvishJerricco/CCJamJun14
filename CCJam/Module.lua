return @class:LuaObject
	@property name

	function (initWithName:name)
		|super init|
		self.name = name
		return self
	end

	function (drawInWindow:win)
	end
end