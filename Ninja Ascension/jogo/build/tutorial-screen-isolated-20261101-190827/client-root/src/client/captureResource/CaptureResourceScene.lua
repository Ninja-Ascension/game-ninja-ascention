
CaptureResourceScene = class("CaptureResourceSceneClass", Window)

CaptureResourceScene.__size = nil

function CaptureResourceScene:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
    self.mapIndex = 0
    self.sceneIndex = 0
    self.buildSprites = {}
end

function CaptureResourceScene:addSceneBuildGuide( searchBuild )
    if table.nums(self.buildSprites) == 0 then
        return
    end
    for k,v in pairs(self.buildSprites) do
        if v ~= nil and v.build ~= nil and tonumber(v.build.pos_x) == tonumber(searchBuild.pos_x) and 
            tonumber(v.build.pos_y) == tonumber(searchBuild.pos_y) then
            self:addSceneBuildGuideEffect(v)
            return
        end
    end
end

function CaptureResourceScene:addSceneBuildGuideEffect( buildLayerout )
    local rewardPanel = buildLayerout:getChildByName("rewardPanel")
    effect_paths = "images/ui/effice/effect_qiangduo_zhiying/effect_qiangduo_zhiying.ExportJson"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
    local armature = ccs.Armature:create("effect_qiangduo_zhiying")
    draw.initArmature(armature, nil, -1, 0, 1)
    csb.animationChangeToAction(armature, 0, 0, false)
    buildLayerout:addChild(armature)
    armature:setPosition(rewardPanel:getPositionX() + rewardPanel:getContentSize().width/2, 100)
    armature:setName("armature_guide")
end

function CaptureResourceScene:removeSceneBuildGuideEffect( ... )
    if table.nums(self.buildSprites) == 0 then
        return
    end
    for k,v in pairs(self.buildSprites) do
        if v ~= nil then
            local armature_guide = v:getChildByName("armature_guide")
            if armature_guide ~= nil then
                armature_guide:removeFromParent(true)
            end
        end
    end
end

function CaptureResourceScene:updateSceneBuildInfo( buildInfo )
    if table.nums(self.buildSprites) == 0 then
        return
    end
    for k,v in pairs(self.buildSprites) do
        if v ~= nil and v.build ~= nil and tonumber(v.build.pos_x) == tonumber(buildInfo.pos_x) and 
            tonumber(v.build.pos_y) == tonumber(buildInfo.pos_y) then
            v.build = buildInfo
            self:updateBuildInfo(v)
            return
        end
    end
end

function CaptureResourceScene:updateBuildInfo( buildLayerout )
    local isMyBuild = false
    local buildInfo = buildLayerout.build
    for k,v in pairs(_ED.captureResourceInfo) do
        if tonumber(v.map_index) == tonumber(buildInfo.map_index) and
            tonumber(v.pos_x) == tonumber(buildInfo.pos_x) and
            tonumber(v.pos_y) == tonumber(buildInfo.pos_y) then
            isMyBuild = true
        end
    end
    local buildData = dms.element(dms["grab_build_param"], buildInfo.build_id)
    local buildName = dms.atos(buildData, grab_build_param.build_name)

    local Text_lv = buildLayerout:getChildByName("Text_lv")
    local Text_level = buildLayerout:getChildByName("Text_level")
    local name_text = buildLayerout:getChildByName("name_text")
    local bgImage = buildLayerout:getChildByName("bgImage")
    local armature = buildLayerout:getChildByName("armature")
    local rewardPanel = buildLayerout:getChildByName("rewardPanel")
    local myBg = buildLayerout:getChildByName("myBg")
    if myBg ~= nil then
        myBg:setVisible(false)
    end
    -- rewardPanel:stopAllActions()
    local rewardIcon = rewardPanel:getChildByName("rewardIcon")
    local reward_icon = dms.atos(buildData, grab_build_param.reward_icon)
    rewardIcon:setBackGroundImage(string.format("images/ui/play/secret_society/secret_icon_%s.png", reward_icon))
    if armature ~= nil then
        armature:removeFromParent(true)
    end
    name_text:setColor(cc.c3b(255, 255, 255))
    if buildInfo.captureName == "" then
        bgImage:setVisible(false)
        Text_level:setVisible(false)
        Text_lv:setVisible(false)
        -- rewardPanel:setVisible(false)
        display:gray(buildLayerout:getChildByName("background"))
    else
        bgImage:setVisible(true)
        Text_level:setVisible(true)
        Text_lv:setVisible(true)
        -- rewardPanel:setVisible(true)
        -- local moveTo1 = cc.MoveTo:create(0.4, cc.p(rewardPanel:getPositionX(), rewardPanel:getPositionY() - 5))
        -- local moveTo2 = cc.MoveTo:create(0.4, cc.p(rewardPanel:getPositionX(), rewardPanel:getPositionY()))
        -- rewardPanel:runAction(cc.RepeatForever:create(cc.Sequence:create(moveTo1, moveTo2)))

        local nameLength = zstring.utfstrlen(buildInfo.captureName)
        name_text:setPositionX(name_text:getPositionX() - (nameLength - 2) * 12)
        Text_level:setPositionX(Text_level:getPositionX() - (nameLength - 2) * 12)
        Text_lv:setPositionX(Text_lv:getPositionX() - (nameLength - 2) * 12)
        bgImage:setPositionX(Text_lv:getPositionX() - 10)
        bgImage:setContentSize(105 + (nameLength - 2) * 22, 30)
        Text_level:setString(""..buildInfo.cap_level)
        display:ungray(buildLayerout:getChildByName("background"))
        if buildInfo.is_addtion == true then
            local effect_paths = "images/ui/effice/effice_arrow_up_1/effice_arrow_up_1.ExportJson"
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
            local armature = ccs.Armature:create("effice_arrow_up_1")
            draw.initArmature(armature, nil, -1, 0, 1)
            -- armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
            csb.animationChangeToAction(armature, 0, 0, false)
            buildLayerout:addChild(armature)
            armature:setPosition(rewardPanel:getPositionX() + rewardPanel:getContentSize().width + 20, rewardPanel:getPositionY() + rewardPanel:getContentSize().height/2)
            armature:setName("armature")
        end

        local reward_icon = dms.atos(buildData, grab_build_param.reward_icon)
        -- rewardIcon:setBackGroundImage(string.format("images/ui/play/secret_society/secret_icon_%s.png", reward_icon))
        if isMyBuild == true then
            name_text:setColor(cc.c3b(0, 255, 0))
            myBg:setVisible(true)
        end
    end
    name_text:setString(buildInfo.captureName)
    -- name_text:setString(buildInfo.pos_x.."-"..buildInfo.pos_y)
end

function CaptureResourceScene:updateDraw()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self.Panel_tubiao:removeAllChildren(true)
    self.buildSprites = {}
    local function layoutTouchListener( sender, eventType )
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if sender ~= nil and sender:getParent() ~= nil and sender:getParent():getParent() ~= nil then
                local build = sender:getParent():getParent().build
                if build ~= nil and math.abs(__spoint.x - __epoint.x) <= 3 and math.abs(__spoint.y - __epoint.y) <= 3 then
                    state_machine.excute("capture_resource_info_open", 0, {mapBuild = sender:getParent():getParent().build, info = nil})
                end
            end
        end
    end

    local oneLinePos = zstring.split(capture_resource[1], ",")
    local secondLinePos = zstring.split(capture_resource[2], ",")

    local width = CaptureResourceBuild.__size.width
    local height = CaptureResourceBuild.__size.height

    local mapInfoList = _ED.capture_resource_map_info[""..self.mapIndex]
    local buildList = _ED.capture_resource_build_info[""..self.mapIndex]
    local hor = math.ceil(self.sceneIndex%3)
    local ver = math.ceil(self.sceneIndex/3)
    if hor == 0 then
        hor = 3
    end
    local verTotalCount = 3
    local horTotalCount = 8
    -- if math.ceil(self.mapIndex%3) == 0 then
    --     verTotalCount = 4
    -- end
    -- if self.mapIndex + 2 >= _ED.capture_total_open_map_count then
    --     horTotalCount = 9
    -- end
    for i=1, horTotalCount do
        for j=1, verTotalCount do
            local build = buildList[((ver - 1)*8 + i).."-"..((hor - 1)*3 + j)]
            -- print("--------", self.sceneIndex, self.mapIndex, ((ver - 1)*8 + i), ((hor - 1)*3 + j), build.build_id)
            local posX = oneLinePos[1] + width * (j - 1)
            local posY = oneLinePos[2] - height * ((i + 1)/2 - 1)
            if i%2 == 0 then
                posX = secondLinePos[1] + width * (j - 1)
                posY = secondLinePos[2] - height * ((i/2) - 1)
            end

            local layout = ccui.Layout:create()
            local picIndex = 0
            if build ~= nil then
                picIndex = build.build_id
            else
                picIndex = mapInfoList[((ver - 1)*8 + i)][((hor - 1)*3 + j)]
            end
            local background = cc.Sprite:create("images/ui/play/secret_society/secret_city_"..picIndex..".png")
            background:setName("background")
            background:setAnchorPoint(cc.p(0, 0))
            layout:addChild(background, 0)

            -- background:setPosition(cc.p((width - background:getContentSize().width)/2, (height - background:getContentSize().height)/2))
            layout:setContentSize(cc.size(width, height))
            self.Panel_tubiao:addChild(layout)
            layout:setPosition(posX, posY)
            -- layout:setAnchorPoint(cc.p(0.5, 0))
            -- layout:setTouchEnabled(true)
            -- layout:setSwallowTouches(false)
            self.buildSprites[i.."-"..j] = layout

            -- layout:addTouchEventListener(layoutTouchListener)
            layout.build = build
            layout.pos = i..","..j

            if build ~= nil then
                local myBg = cc.Sprite:create("images/ui/play/secret_society/secret_city_zl.png")
                myBg:setName("myBg")
                myBg:setAnchorPoint(cc.p(0, 0))
                layout:addChild(myBg, 1)
                myBg:setPosition(0, -4)
                local fadeIn = cc.FadeTo:create(0.7, 80)
                local fadeOut = cc.FadeTo:create(0.7, 255)
                myBg:runAction(cc.RepeatForever:create(cc.Sequence:create(fadeIn, fadeOut)))

                local ttfConfig = {}
                ttfConfig.fontFilePath = "fonts/FZYiHei-M20S.ttf"
                ttfConfig.fontSize = 20
                
                local Text_lv = cc.Label:createWithTTF(ttfConfig, "", cc.TEXT_ALIGNMENT_LEFT, 0)
                Text_lv:setName("Text_lv")
                Text_lv:setString("LV")
                layout:addChild(Text_lv, 1)
                Text_lv:setAnchorPoint(0, 0.5)
                Text_lv:setPosition(cc.p(180, height/2 - 20))
                Text_lv:setColor(cc.c3b(255, 200, 0))

                local Text_level = cc.Label:createWithTTF(ttfConfig,"", cc.TEXT_ALIGNMENT_LEFT, 0)
                Text_level:setName("Text_level")
                Text_level:setString("")
                layout:addChild(Text_level, 1)
                Text_level:setAnchorPoint(0, 0.5)
                Text_level:setPosition(cc.p(205, Text_lv:getPositionY()))
                Text_level:setColor(cc.c3b(255, 200, 0))

                local name_text = cc.Label:createWithTTF(ttfConfig,"", cc.TEXT_ALIGNMENT_LEFT, 0)
                name_text:setName("name_text")
                name_text:setString("test")
                layout:addChild(name_text, 1)
                name_text:setAnchorPoint(0, 0.5)
                name_text:setPosition(cc.p(230, Text_lv:getPositionY()))
                name_text:setColor(cc.c3b(255, 255, 255))

                local bgImage = ccui.Scale9Sprite:create("images/ui/slots/slot_chat.png")
                bgImage:setName("bgImage")
                bgImage:setOpacity(200)
                bgImage:setAnchorPoint(cc.p(0, 0.5))
                bgImage:setContentSize(125, 30)
                layout:addChild(bgImage, 0)
                bgImage:setPosition(cc.p(140, Text_lv:getPositionY()))

                local rewardPanel = cc.Sprite:create("images/ui/play/secret_society/icon_bg.png")
                rewardPanel:setName("rewardPanel")
                rewardPanel:setAnchorPoint(cc.p(0, 0))
                layout:addChild(rewardPanel, 0)
                rewardPanel:setPosition(cc.p(180, 120))

                local moveTo1 = cc.MoveTo:create(0.4, cc.p(rewardPanel:getPositionX(), rewardPanel:getPositionY() - 5))
                local moveTo2 = cc.MoveTo:create(0.4, cc.p(rewardPanel:getPositionX(), rewardPanel:getPositionY()))
                rewardPanel:runAction(cc.RepeatForever:create(cc.Sequence:create(moveTo1, moveTo2)))

                local rewardIcon = ccui.Layout:create()
                rewardIcon:setName("rewardIcon")
                rewardIcon:setAnchorPoint(cc.p(0, 0))
                rewardPanel:addChild(rewardIcon, 0)
                rewardIcon:setPosition(cc.p(30, 45))

                local node = ccui.Layout:create()
                layout:addChild(node, 0)
                local touchSprite = ccui.Layout:create()
                -- touchSprite:setBackGroundImage("images/ui/bar/aaaa.png")
                touchSprite:setContentSize(cc.size(220, 220))
                touchSprite:setAnchorPoint(cc.p(0.5, 0.5))
                touchSprite:setPosition(cc.p(150, 160))
                touchSprite:setRotation(45)
                -- layout:addChild(touchSprite, 0)
                node:addChild(touchSprite, 0)
                node:setScaleY(0.7)
                node:setScaleX(1.38)
                
                touchSprite:setTouchEnabled(true)
                touchSprite:setSwallowTouches(false)
                touchSprite:addTouchEventListener(layoutTouchListener)

                self:updateBuildInfo(layout)
            end
        end
    end
end

function CaptureResourceScene:initMapBuilds( ... )
    self.Panel_tubiao:removeAllChildren(true)
    self.buildSprites = {}

    local oneLinePos = zstring.split(capture_resource[1], ",")
    local secondLinePos = zstring.split(capture_resource[2], ",")

    local mapInfoList = _ED.capture_resource_map_info[""..self.mapIndex]
    local buildList = _ED.capture_resource_build_info[""..self.mapIndex]
    local verCount = #mapInfoList
    local hor = math.ceil(self.sceneIndex%3)
    local ver = math.ceil(self.sceneIndex/3)
    if hor == 0 then
        hor = 3
    end
    local verTotalCount = 3
    local horTotalCount = 8
    -- if math.ceil(self.mapIndex%3) == 0 then
    --     verTotalCount = 4
    -- end
    -- if self.mapIndex + 2 >= _ED.capture_total_open_map_count then
    --     horTotalCount = 9
    -- end
    for i=1, horTotalCount do
        for j=1, verTotalCount do
            local build = buildList[((ver - 1)*8 + i).."-"..((hor - 1)*3 + j)]
            local layout = CaptureResourceBuild:CreateBuild():init(build, true)
            -- layout:setAnchorPoint(cc.p(0.5, 0.5))
            local posX = oneLinePos[1] + layout:getContentSize().width * (j - 1)
            local posY = oneLinePos[2] - layout:getContentSize().height * ((i + 1)/2 - 1)
            if i%2 == 0 then
                posX = secondLinePos[1] + layout:getContentSize().width * (j - 1)
                posY = secondLinePos[2] - layout:getContentSize().height * ((i/2) - 1)
            end
            layout:setPosition(posX, posY)

            self.Panel_tubiao:addChild(layout)
            self.buildSprites[i.."-"..j] = layout
        end
    end
end

function CaptureResourceScene:initDraw()
    local root = cacher.createUIRef("secret_society/secret_society_map_pingmu.csb", "root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)

    self.Panel_tubiao = ccui.Helper:seekWidgetByName(root, "Panel_tubiao")
    -- self:initMapBuilds()
    self:updateDraw()
end

function CaptureResourceScene:onEnterTransitionFinish()
end

function CaptureResourceScene:changeLoadState( unLoad, scenePosX, scenePosY )
    if unLoad == true then
        self:unload()
    else
        local mapHor = math.ceil(self.mapIndex%3)
        local mapVer = math.ceil(self.mapIndex/3)
        if mapHor == 0 then
            mapHor = 3
        end

        local hor = math.ceil(self.sceneIndex%3)
        local ver = math.ceil(self.sceneIndex/3)
        if hor == 0 then
            hor = 3
        end
        -- print("-------", self.sceneIndex, hor, ver, scenePosX, scenePosY)
        local myPosX = self:getPositionX() + (mapHor - 1) * 3 * CaptureResource._BaseWidth
        local myPosY = self:getPositionY() + (_ED.capture_total_open_hor_map_count - mapVer) * 3 * CaptureResource._BaseHeight
        -- print("-------=========", myPosX, myPosY)
        if myPosX - CaptureResourceBuild.__size.width/2 > math.abs(scenePosX) + app.screenSize.width / app.scaleFactor or myPosX + self:getContentSize().width + CaptureResourceBuild.__size.width/2 < math.abs(scenePosX) or
            myPosY - CaptureResourceBuild.__size.height/2 > math.abs(scenePosY) + app.screenSize.height / app.scaleFactor or myPosY + self:getContentSize().height + CaptureResourceBuild.__size.height/2 < math.abs(scenePosY) then
            self:unload()
        else
            self:reload()
        end
    end
end

function CaptureResourceScene:unload( ... )
    local root = self.roots[1]
    if root == nil then
        return
    end
    self.Panel_tubiao:removeAllChildren(true)
    self.buildSprites = {}
    cacher.freeRef("secret_society/secret_society_map_pingmu.csb", root)
    root:removeFromParent(false)
    root:stopAllActions()
    self.roots = {}
end

function CaptureResourceScene:reload( ... )
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:initDraw()
end

function CaptureResourceScene:init( mapIndex, sceneIndex )
    self.mapIndex = mapIndex
    self.sceneIndex = sceneIndex
    self:setContentSize(cc.size(CaptureResource._BaseWidth, CaptureResource._BaseHeight))
    -- self:initDraw()
    return self
end

function CaptureResourceScene:close( ... )
    self.Panel_tubiao:removeAllChildren(true)
end

function CaptureResourceScene:onExit()
    cacher.freeRef("secret_society/secret_society_map_pingmu.csb", self.roots[1])
end

function CaptureResourceScene:CreateScene( ... )
    local cell = CaptureResourceScene:new()
    cell:registerOnNodeEvent(cell)
    return cell
end
