-- -----------------------------------------------------------------------------
-- [[ DisplayLog view module
-- ---------------------------------------------------------------------------]]
DisplayLog = class("WindowClass", Window)

function DisplayLog:ctor()
    self:setContentSize(cc.size(fwin._width/2, fwin._height/2))
    self:retain()
    self._logs = {}
    self._ctime = 0
    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 120))
    layer:setContentSize(cc.size(fwin._width/2, fwin._height/2))
    self:addChild(layer)
    --self:scheduler("DisplayLog", self.onUpdate, 1, true)
end

function DisplayLog:onEnterTransitionFinish()

end

function DisplayLog:onUpdate(dt)
    self._ctime = self._ctime + dt
    for i, v in pairs(self._logs) do
        v._ctime = v._ctime + dt
    end

    local len = table.getn(self._logs)
    if len > 0 then
        local v = self._logs[1]
        if v._ctime > 500 then
            self:removeChild(self._logs[1])
            table.remove(self._logs, 1)

            if len == 1 then
                self:setVisible(false)
            end
        end
    end
end

function DisplayLog:display(log)
    local logLabel = cc.Label:createWithTTF(log, "fonts/FZYiHei-M20S.ttf", 16)
    logLabel:setAnchorPoint(cc.p(0, 0))
    math.randomseed(os.time())
    local R = math.random(0,255)
    math.randomseed(os.time())
    local G = math.random(0,255)
    math.randomseed(os.time())
    local B = math.random(0,255)
    logLabel:setColor(cc.c3b(R, 255, 255))
    self:addChild(logLabel)
    logLabel:setPosition(0, 0)
    logLabel._ctime = 0
    local s = logLabel:getContentSize()
    for i, v in pairs(self._logs) do
        v:setPositionY(v:getPositionY() + s.height)
    end
    table.insert(self._logs, logLabel)
    local len = table.getn(self._logs)
    if len > 20 then
        self:removeChild(self._logs[1])
        table.remove(self._logs, 1)
    end
    self:setVisible(true)
end

return DisplayLog:new()
-- END
-- -----------------------------------------------------------------------------