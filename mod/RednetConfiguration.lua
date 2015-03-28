return @class:LuaObject
    @property(readonly) isOpen = _isOpen
    @property(readonly) hostname = _hostname
    @property keepAlive
    local modems

    function (initWithConfig:config)
        |super init|
        _isOpen = false
        _hostname = config.hostname
        self.keepAlive = config.keepAlive
        modems = config.modems
        return self
    end

    function (open)
        if not _isOpen then
            for i,v in ipairs(modems) do
                rednet.open(v)
            end
            _isOpen = true
        end
    end
end