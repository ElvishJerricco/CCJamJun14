return @class:LuaObject
	@property eventParameters
	
	function (initWithEventParameters:...)
		|super init|
		eventParameters = {...}
		return self
	end

	function (matchParameters:...)
		local parameters = {...}
		if #parameters ~= #eventParameters then
			return false
		end

		for i,v in ipairs(parameters) do
			if v ~= eventParameters[i] then
				return false
			end
		end

		return true
	end
end