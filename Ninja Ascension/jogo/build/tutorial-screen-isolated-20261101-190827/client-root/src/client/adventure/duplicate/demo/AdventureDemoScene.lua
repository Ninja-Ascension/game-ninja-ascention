-- ----------------------------------------------------------------------------------------------------
-- 说明：冒险演示动画场景
-------------------------------------------------------------------------------------------------------
AdventureDemoScene = class("AdventureDemoSceneClass", Window)

app.load("client.adventure.duplicate.demo.AdventureDemoMiddleBg")
app.load("client.adventure.duplicate.demo.AdventureDemoNearBg")

function AdventureDemoScene:ctor()
    self.super:ctor()
    self.roots = {}

    self.size = nil

    self.selectSceneId = 1
    self.selectNpcId = 1
end

function AdventureDemoScene:onEnterTransitionFinish()
    -- self:addChild(self:createFarBg())

    -- local middleBg = AdventureDemoMiddleBg:createCell()
    -- middleBg:init(self.size, self.selectSceneId, self.selectNpcId)
    -- self:addChild(middleBg)

    -- local nearBg = AdventureDemoNearBg:createCell()
    -- nearBg:init(self.size)
    -- self:addChild(nearBg)

    local scene_map_id = dms.string(dms["pve_scene"], self.selectSceneId, pve_scene.scene_map_id)
    local sceneFile = "duplicate/map/pve_scene_".. scene_map_id ..".csb"
    local csbAdventureDemoScene = csb.createNode(sceneFile)
    local root = csbAdventureDemoScene:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureDemoScene)

    local animationName = "map_" .. scene_map_id
    local jsonFile = "images/ui/effice/map/" .. animationName .. ".json"
    local atlasFile = "images/ui/effice/map/" .. animationName .. ".atlas"
    local Panel_scene = ccui.Helper:seekWidgetByName(root, "Panel_scene")
    Panel_scene:removeAllChildren(true)
    if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, animationName, true, nil)
        Panel_scene:addChild(animation)
    end

    local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
    Panel_role:removeAllChildren(true)
    local roleControlPanel = DemoRoleController:createCell():init(self, self.size, self.selectSceneId, self.selectNpcId)
    Panel_role:addChild(roleControlPanel)

    local action = csb.createTimeline(sceneFile)
    csbAdventureDemoScene:runAction(action)
    action:gotoFrameAndPlay(0, action:getDuration(), true)
end

function AdventureDemoScene:createFarBg()
    local farBg = cc.Sprite:create("map/plot/plot_bg_1_5.png")
    farBg:setScale(self.size.width / farBg:getContentSize().width)
    farBg:setAnchorPoint(cc.p(0.5, 0))
    farBg:setPosition(cc.p(self.size.width / 2, 0))

    return farBg
end

function AdventureDemoScene:onExit()

end

function AdventureDemoScene:init(sceneId, npcId)
    self:setContentSize(640, 400)
    self.size = self:getContentSize()

    self.selectSceneId = sceneId
    self.selectNpcId = npcId
    return self
end

function AdventureDemoScene:createCell()
    local cell = AdventureDemoScene:new()
    cell:registerOnNodeEvent(cell)
    return cell
end