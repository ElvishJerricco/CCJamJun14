return @class:LuaObject
    @property(readonly) rednetConfig = _rcfg
    local timer

    function (initWithRednetConfig:rcfg)
        |super init|
        _rcfg = rcfg
        return self
    end

    function (open)
        rednet.host("elvishjerricco.cinnamon.worker", self.rednetConfig.hostname)
        timer = os.startTimer(self.rednetConfig.keepAlive)
    end

    function (update)
    end

    function (respondToEvent:event)
    end

    function (terminate)
        rednet.unhost("elvishjerricco.cinnamon.worker", self.rednetConfig.hostname)
    end
end