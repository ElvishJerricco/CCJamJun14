return @class:LuaObject
	@property monitor
	@property(readonly) uid = _uid
	@property(readonly) computerId = _computerId

	function (initWithMonitor:monitor uid:uid computerId:computerId)
		|super init|
		self.monitor = monitor
		_uid = uid
		_computerId = computerId
		return self
	end

	function (update)
		|monitor update|
	end

	function (respondToEvent:event)
		return |monitor respondToEvent:event|
	end
end