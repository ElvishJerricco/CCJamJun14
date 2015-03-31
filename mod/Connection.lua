return @class:LuaObject
    @property(readonly) rednetConfig = _rednetConfig
    @property(readonly) protocol = _protocol
    
    function (initWithRednetConfig:rcfg protocol:protocol)
        |super init|
        _rednetConfig = rcfg
        _protocol = protocol
        return self
    end

    function (open)
        |self.rednetConfig open|
    end
end