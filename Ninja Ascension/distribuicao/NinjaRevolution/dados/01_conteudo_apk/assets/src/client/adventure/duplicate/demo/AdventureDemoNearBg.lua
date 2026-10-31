-- ----------------------------------------------------------------------------------------------------
-- 说明：冒险演示动画前景层
-------------------------------------------------------------------------------------------------------
AdventureDemoNearBg = class("AdventureDemoNearBgClass", Window)

function AdventureDemoNearBg:ctor()
    self.super:ctor()
    self.roots = {}

    self.size = nil
    self.layerMap1 = nil
    self.layerMap2 = nil
    self.mapWidth = 0
    self.speed = 50
end

function AdventureDemoNearBg:createMapLayer()
    local layerMap = cc.Layer:create()

    local treeSize
    for i = 1,3 do
        local tree = cc.Sprite:create("map/plot/plot_bg_1_1.png")
        treeSize = tree:getContentSize()
        tree:setAnchorPoint(cc.p(0, 0))
        tree:setPosition(cc.p((treeSize.width + 150) * (i - 1), 0))

        layerMap:addChild(tree)
    end

    layerMap:setContentSize(treeSize.width*3 + 150 * 2, self.size.height)

    return layerMap
end

function AdventureDemoNearBg:onEnterTransitionFinish()
    self.layerMap1 = self:createMapLayer()
    self.layerMap2 = self:createMapLayer()

    self.mapWidth = self.layerMap1:getContentSize().width
    self.layerMap2:setPosition(cc.p(self.mapWidth, 0))

    self:addChild(self.layerMap1)
    self:addChild(self.layerMap2)
end

function AdventureDemoNearBg:onUpdate(dt)
    local x1, y1 = self.layerMap1:getPosition()
    local x2, y2 = self.layerMap2:getPosition()

    x1 = x1 - self.speed * dt
    x2 = x2 - self.speed * dt

    self.layerMap1:setPosition(cc.p(x1, y1))
    self.layerMap2:setPosition(cc.p(x2, y2))

    if x1 < -self.mapWidth then
        self.layerMap1:setPosition(cc.p(x2 + self.mapWidth, y1))
    end
    if x2 < -self.mapWidth then
        self.layerMap2:setPosition(cc.p(x1 + self.mapWidth, y2))
    end
end

function AdventureDemoNearBg:onExit()
    
end

function AdventureDemoNearBg:init(parentSize)
    self.size = parentSize
    self:setContentSize(parentSize)
end

function AdventureDemoNearBg:createCell()
    local cell = AdventureDemoNearBg:new()
    cell:registerOnNodeEvent(cell)
    cell:registerOnNoteUpdate(cell)
    return cell
end
