
CaptureResourceBuild = class("CaptureResourceBuildClass", Window)

CaptureResourceBuild.__size = nil

function CaptureResourceBuild:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
    self.buildInfo = nil
    self.isMyBuild = false

    local function init_capture_resource_build_terminal()
        local selected_society_map_build_terminal = {
            _name = "selected_society_map_build",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local build = params.buildInfo
                if build ~= nil then
                    state_machine.excute("capture_resource_info_open", 0, {mapBuild = build, info = nil})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(selected_society_map_build_terminal)
        state_machine.init()
    end
    init_capture_resource_build_terminal()
end

function CaptureResourceBuild:onUpdate( dt )
    
end

function CaptureResourceBuild:updateDraw(buildInfo)
	local root = self.roots[1]
	if root == nil then
		return
	end
    self.isMyBuild = false
    self.buildInfo = buildInfo
    for k,v in pairs(_ED.captureResourceInfo) do
        if tonumber(v.map_index) == tonumber(self.buildInfo.map_index) and
            tonumber(v.pos_x) == tonumber(self.buildInfo.pos_x) and
            tonumber(v.pos_y) == tonumber(self.buildInfo.pos_y) then
            self.isMyBuild = true
        end
    end
    local buildData = dms.element(dms["grab_build_param"], buildInfo.build_id)
    local buildName = dms.atos(buildData, grab_build_param.build_name)
    local reward_icon = dms.atos(buildData, grab_build_param.reward_icon)
    local iconPath = "images/ui/play/secret_society/secret_city_"..buildInfo.build_id..".png"
    local sprite = root:getChildByName("Sprite_map_city")
    sprite:setTexture(iconPath)
    local name_text = ccui.Helper:seekWidgetByName(root, "Text_role_name")
    name_text:setColor(cc.c3b(255, 255, 255))
    local Text_002_0 = ccui.Helper:seekWidgetByName(root, "Text_002_0")
    local Text_lv = ccui.Helper:seekWidgetByName(root, "Text_lv")
    local image = ccui.Helper:seekWidgetByName(root, "Image_1")
    -- local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
    -- local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
    if buildInfo.captureName == "" then
        -- self.Panel_city_xx:setVisible(false)
        self.Panel_city_xx:getChildByName("ArmatureNode_1"):setVisible(false)
        Text_002_0:setVisible(false)
        image:setVisible(false)
        -- Image_2:setVisible(false)
        Text_lv:setString("")
        display:gray(sprite)
    else
        self.Panel_city_xx:setVisible(true)
        if buildInfo.is_addtion == true then
            self.Panel_city_xx:getChildByName("ArmatureNode_1"):setVisible(true)
        else
            self.Panel_city_xx:getChildByName("ArmatureNode_1"):setVisible(false)
        end
        image:setVisible(true)
        Text_002_0:setVisible(true)
        -- Image_2:setVisible(true)
        local nameLength = zstring.utfstrlen(buildInfo.captureName)
        name_text:setPositionX(name_text:getPositionX() - (nameLength - 2) * 12)
        Text_002_0:setPositionX(Text_002_0:getPositionX() - (nameLength - 2) * 12)
        Text_lv:setPositionX(Text_lv:getPositionX() - (nameLength - 2) * 12)
        image:setContentSize(102 + (nameLength - 2) * 20, image:getContentSize().height)
        Text_lv:setString(""..buildInfo.cap_level)
        display:ungray(sprite)
        -- Panel_icon:setBackGroundImage(string.format("images/ui/play/secret_society/secret_icon_%s.png", reward_icon))
        if self.isMyBuild == true then
            name_text:setColor(cc.c3b(0, 255, 0))
        end
    end
    name_text:setString(buildInfo.captureName)
end

function CaptureResourceBuild:changeInfoVisible( isShow )
    local root = self.roots[1]
    if root == nil then
        return
    end
    if self.isMyBuild == true then
        self.Panel_city_xx:setVisible(true)
    else
        self.Panel_city_xx:setVisible(isShow)
    end
end

function CaptureResourceBuild:initDraw()
    -- local root = cacher.createUIRef("secret_society/secret_map_icon.csb", "root")
    local csbBuild = csb.createNode("secret_society/secret_map_icon.csb")
    local root = csbBuild:getChildByName("root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)

    self.Panel_city_xx = ccui.Helper:seekWidgetByName(root, "Panel_city_xx")
    self:setContentSize(root:getContentSize())

    local Panel_city_xy = ccui.Helper:seekWidgetByName(root, "Panel_city_xy")
    local function panelCityMapTouchListener( sender, eventType )
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if math.abs(__spoint.x - __epoint.x) <= 3 and math.abs(__spoint.y - __epoint.y) <= 3 then
                state_machine.excute("selected_society_map_build", 0, self)
            end
        end
    end

    Panel_city_xy:setSwallowTouches(false)
    self:setSwallowTouches(false)
    if self.buildInfo == nil then
        local iconPath = "images/ui/play/secret_society/secret_city_0.png"
        local sprite = root:getChildByName("Sprite_map_city")
        sprite:setTexture(iconPath)
        local name_text = ccui.Helper:seekWidgetByName(root, "Text_role_name")
        name_text:setColor(cc.c3b(255, 255, 255))
        ccui.Helper:seekWidgetByName(root, "Text_002_0"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Text_lv"):setString("")
        ccui.Helper:seekWidgetByName(root, "Image_1"):setVisible(false)
        self.Panel_city_xx:setVisible(false)
        self.Panel_city_xx:getChildByName("ArmatureNode_1"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Image_2"):setVisible(false)
    else
        Panel_city_xy:addTouchEventListener(panelCityMapTouchListener)
        self:updateDraw(self.buildInfo)
    end
end

function CaptureResourceBuild:onEnterTransitionFinish()
	
end

function CaptureResourceBuild:unload( ... )
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef("secret_society/secret_map_icon.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function CaptureResourceBuild:reload( ... )
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:initDraw()
end

function CaptureResourceBuild:init( info, isShow )
    self.buildInfo = info
    if info ~= nil then
        self:setContentSize(CaptureResourceBuild.__size)
        if isShow == true then
            self:initDraw()
        else
            local function delayEndFuncN( _sender )
                if _sender ~= nil then
                    _sender:initDraw()
                end
            end
            local actions = {}
            table.insert(actions, cc.DelayTime:create(1))
            table.insert(actions, cc.CallFunc:create(delayEndFuncN))
            local seq = cc.Sequence:create(actions)
            self:runAction(seq)
        end
    end
    return self
end

function CaptureResourceBuild:onExit()
    self:stopAllActions()
    -- cacher.freeRef("secret_society/secret_map_icon.csb", self.roots[1])
end

function CaptureResourceBuild:CreateBuild( ... )
    local cell = CaptureResourceBuild:new()
    cell:registerOnNodeEvent(cell)
    return cell
end
