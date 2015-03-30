return @class:LuaObject
	@property(readonly) uid = _uid
	@property(readonly) computerId = _computerId
	@property(readonly) server = _server

	function (initWithUID:uid computerId:computerId server:server)
		|super init|
		_uid = uid
		_computerId = computerId
		_server = server
		return self
	end

	function (sendMessage:msg)
		msg.id = uid
		rednet.send(computerId, msg, server.protocol)
	end

	function (remove)
	end
end