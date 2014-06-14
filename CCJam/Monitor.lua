return @class:LuaObject
	@property defaultScreen
	@property eventParameters
	
	function (initWithDefaultScreen:defaultScreen eventParameters:...)
		|super init|
		self.defaultScreen = defaultScreen
		eventParameters = {...}
		return self
	end

	function (matchParameters:...)
		local parameters = {...}
		if #parameters ~= #eventParameters then
			return false
		end

		for i,v in ipairs(parameters)
			if v ~= eventParameters[i] then
				return false
			end
		end

		return true
	end
end