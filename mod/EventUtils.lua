local eu = {}

function eu.matchesParameters(event, params)
	for i,v in ipairs(params) do
		if v ~= event[i] then
			return false
		end
	end
	return true
end

function eu.select(event, n)
	return select(n or 1, unpack(event))
end

return eu