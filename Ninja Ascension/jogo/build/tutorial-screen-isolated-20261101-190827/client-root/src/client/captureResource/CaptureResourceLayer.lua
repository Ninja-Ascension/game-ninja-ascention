
CaptureResourceLayer = class("CaptureResourceLayerClass", Window)
CaptureResourceLayer.__size = nil

function CaptureResourceLayer:ctor()
	self.super:ctor()
	self.roots = {}
    self.buildSprites = {}
    self.parent = nil
    self.map_index = 0
    self.sceneList = {}
end

function CaptureResourceLayer:updateBuild( buildInfo )
    if table.nums(self.sceneList) == 0 then
        return
    end
    local hor = math.ceil(buildInfo.pos_x/3)
    local ver = math.ceil(buildInfo.pos_y/8)
    -- if hor == 0 then
    --     hor = 3
    -- end
    local sceneLayer = self.sceneList[ver][hor]
    if sceneLayer ~= nil then
        sceneLayer:updateSceneBuildInfo(buildInfo)
    end
end

function CaptureResourceLayer:addGuideEffect( searchBuild )
    if table.nums(self.sceneList) == 0 then
        return
    end
    local hor = math.ceil(searchBuild.pos_x/3)
    local ver = math.ceil(searchBuild.pos_y/8)
    -- if hor == 0 then
    --     hor = 3
    -- end
    local sceneLayer = self.sceneList[ver][hor]
    if sceneLayer ~= nil then
        sceneLayer:addSceneBuildGuide(searchBuild)
    end
end

function CaptureResourceLayer:removeMapGuideEffect( ... )
    if table.nums(self.sceneList) == 0 then
        return
    end
    for k,v in pairs(self.sceneList) do
        for k1,v1 in pairs(v) do
            if v1 ~= nil then
                v1:removeSceneBuildGuideEffect()
            end
        end
    end
end

function CaptureResourceLayer:onEnterTransitionFinish()
	-- local csbSocietyMap = csb.createNode("secret_society/secret_society_map.csb")
 --    local root = csbSocietyMap:getChildByName("root")
 --    root:removeFromParent(false)
 --    table.insert(self.roots, root)
 --    self:addChild(root)

 --    self.Panel_tubiao = ccui.Helper:seekWidgetByName(root, "Panel_tubiao")
 --    self:setContentSize(self.Panel_tubiao:getContentSize())

 --    self:setTouchEnabled(true)
 --    self:setSwallowTouches(false)
 --    self:updateScene()
end

function CaptureResourceLayer:initDraw( ... )
    local root = cacher.createUIRef("secret_society/secret_society_map.csb", "root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    self.Panel_tubiao = ccui.Helper:seekWidgetByName(root, "Panel_tubiao")

    self:setTouchEnabled(true)
    self:setSwallowTouches(false)

    self:updateScene()
end

function CaptureResourceLayer:init(mapIndex, parent)
    self.map_index = mapIndex
    self.parent = parent
    self:setContentSize(cc.size(CaptureResource._BaseWidth*3, 
        CaptureResource._BaseHeight*3))
    -- self:initDraw()
    return self
end

function CaptureResourceLayer:close( ... )
    self.Panel_tubiao:removeAllChildren(true)
end

function CaptureResourceLayer:onExit()
    cacher.freeRef("secret_society/secret_society_map.csb", self.roots[1])
end

function CaptureResourceLayer:CreateLayer( ... )
	local cell = CaptureResourceLayer:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function CaptureResourceLayer:updateScene( ... )
    self.Panel_tubiao:removeAllChildren(true)
    self.sceneList = {}

    local mapInfoList = _ED.capture_resource_map_info[""..self.map_index]
    local buildList = _ED.capture_resource_build_info[""..self.map_index]
    local totalWidth = 0
    local totalHeight = 0
    local sceneIndex = 0
    for i=1,3 do
        local horList = {}
        for j=1,3 do
            sceneIndex = sceneIndex + 1
            local layer = CaptureResourceScene:CreateScene():init(self.map_index, sceneIndex)
            self.Panel_tubiao:addChild(layer)
            totalWidth = layer:getContentSize().width * j
            totalHeight = layer:getContentSize().height * i
            layer:setPosition(layer:getContentSize().width*(j - 1), layer:getContentSize().height*(3 - i))
            table.insert(horList, layer)
        end
        table.insert(self.sceneList, horList)
    end
    self.Panel_tubiao:setContentSize(cc.size(totalWidth, totalHeight))
end

function CaptureResourceLayer:changeLoadState( scenePosX, scenePosY )
    local hor = math.ceil(self.map_index%3)
    local ver = math.ceil(self.map_index/3)
    if hor == 0 then
        hor = 3
    end
    local myPosX = self:getPositionX()
    local myPosY = self:getPositionY()
    local unLoad = false
    -- print("=======", self.map_index, myPosX, myPosY, scenePosX, scenePosY,self:getContentSize().width, self:getContentSize().height)
    if myPosX - CaptureResourceBuild.__size.width/2 > math.abs(scenePosX) + app.screenSize.width / app.scaleFactor or myPosX + self:getContentSize().width + CaptureResourceBuild.__size.width/2 < math.abs(scenePosX) or
        myPosY - CaptureResourceBuild.__size.height/2 > math.abs(scenePosY) + app.screenSize.height / app.scaleFactor or myPosY + self:getContentSize().height + CaptureResourceBuild.__size.height/2 < math.abs(scenePosY) then
        unLoad = true
    else
        self:reload()
    end
    for k,v in pairs(self.sceneList) do
        for k1,v1 in pairs(v) do
            v1:changeLoadState(unLoad, scenePosX, scenePosY)
        end
    end
    if unLoad == true then
        self:unload()
    end
end

function CaptureResourceLayer:reload( ... )
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:initDraw()
end

function CaptureResourceLayer:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self.Panel_tubiao:removeAllChildren(true)
    self.sceneList = {}
    cacher.freeRef("secret_society/secret_society_map.csb", root)
    root:removeFromParent(false)
    self.roots = {}
end
