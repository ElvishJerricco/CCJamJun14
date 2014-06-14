return @class:LuaObject
	@property manager

	local parameters

	function (initWithParameters:params)
		|super init|
		parameters = params
		return self
	end

	function (matchesParameters:params)
		for i,v in ipairs(params) do
			if v ~= parameters[i] then
				return false
			end
		end
		return true
	end

	function (select:n)
		return select(n or 1, unpack(parameters))
	end
end