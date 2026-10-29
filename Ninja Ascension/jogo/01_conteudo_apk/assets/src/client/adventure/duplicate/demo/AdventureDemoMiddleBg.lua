-- ----------------------------------------------------------------------------------------------------
-- 说明：冒险演示动画中层背景
-------------------------------------------------------------------------------------------------------
AdventureDemoMiddleBg = class("AdventureDemoMiddleBgClass", Window)

app.load("client.adventure.duplicate.demo.DemoRoleController")

function AdventureDemoMiddleBg:ctor()
    self.super:ctor()
    self.roots = {}

    self.size = nil
    self.layerMap1 = nil
    self.layerMap2 = nil
    self.mapWidth = 0
    self.speed = 20

    self.selectSceneId = 1
    self.selectNpcId = 1
end

function AdventureDemoMiddleBg:createMapLayer()
    local layerMap = cc.Layer:create()

    local grassSize
    for i = 1,4 do
        local grass = cc.Sprite:create("map/plot/plot_bg_1_4.png")
        grassSize = grass:getContentSize()
        grass:setAnchorPoint(cc.p(0, 0))
        grass:setScale(2)
        grass:setPosition(cc.p(grassSize.width * 2 * (i - 1), 0))

        layerMap:addChild(grass)
    end

    for i = 1,2 do
        local tree = cc.Sprite:create("map/plot/plot_bg_1_3.png")
        local treeSize = tree:getContentSize()
        tree:setAnchorPoint(cc.p(0, 0))
        tree:setScale(2)
        tree:setPosition(cc.p(treeSize.width * 2 * (i - 1), 0))

        layerMap:addChild(tree)
    end

    layerMap:setContentSize(grassSize.width*4*2, self.size.height)

    return layerMap
end

function AdventureDemoMiddleBg:onEnterTransitionFinish()
    self.layerMap1 = self:createMapLayer()
    self.layerMap2 = self:createMapLayer()

    self.mapWidth = self.layerMap1:getContentSize().width
    self.layerMap2:setPosition(cc.p(self.mapWidth, 0))

    self:addChild(self.layerMap1)
    self:addChild(self.layerMap2)

    local roleControlPanel = DemoRoleController:createCell():init(self, self.size, self.selectSceneId, self.selectNpcId)
    self:addChild(roleControlPanel)
end

function AdventureDemoMiddleBg:onUpdate(dt)
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

function AdventureDemoMiddleBg:onExit()
    
end

function AdventureDemoMiddleBg:init(parentSize, sceneId, npcId)
    self.size = parentSize
    self:setContentSize(parentSize)

    self.selectSceneId = sceneId
    self.selectNpcId = npcId
    return self
end

function AdventureDemoMiddleBg:createCell()
    local cell = AdventureDemoMiddleBg:new()
    cell:registerOnNodeEvent(cell)
    cell:registerOnNoteUpdate(cell)
    return cell
end
