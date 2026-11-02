---------------------------------------------------------------------------------------------
-- 说明：喇叭
---------------------------------------------------------------------------------------------
HomeHorn = class("HomeHornClass", Window)

local home_horn_open_terminal = {
    _name = "home_horn_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        _ED.hornIsPlaying = true
        local window = fwin:find("HomeHornClass")
        if window ~= nil then
            if window:isVisible() == false then 
        		window:setVisible(true)
        	end
        	return true
        end
        state_machine.lock("home_horn_open", 0, "")

        local window = HomeHorn:new():init(params)
        fwin:open(window, fwin._viewdialog)
        return window
    end,
    _terminal = nil,
    _terminals = nil
}

local home_horn_close_terminal = {
    _name = "home_horn_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	fwin:close(fwin:find("HomeHornClass"))
        state_machine.excute("red_horn_play",0,"red_horn_play.")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(home_horn_open_terminal)
state_machine.add(home_horn_close_terminal)
state_machine.init()

function HomeHorn:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self.PlayerDt = 1
    self.isPlayPlayerInfo = false

    self._PlayerInfoLayer = nil
	self.image_view = nil

    self.send_information = _ED.current_red_horn_play

    local function init_home_horn_terminal()
       -- 隐藏界面
        local home_horn_hide_event_terminal = {
            _name = "home_horn_hide_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 显示界面
        local home_horn_show_event_terminal = {
            _name = "home_horn_show_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(home_horn_hide_event_terminal)
        state_machine.add(home_horn_show_event_terminal)
        state_machine.init()
    end
    init_home_horn_terminal()
end

function HomeHorn:onHide()
	self:setVisible(false)
end

function HomeHorn:onShow()
	self:setVisible(true)
end

function HomeHorn:cutStringInfo(prop_icon, str, height, fontSize, fontname)
	local defcolor1 = cc.c3b(255, 255, 255)
	local defcolor2 = cc.c3b(255, 255, 255)
	local qualitycolor = tipStringInfo_quality_color_Type

    local mRoot = ccui.RichText:create()
    fontSize = fontSize or 10
    local l = string.len(str)
    mRoot:ignoreContentAdaptWithSize(false)
    local count = 0
    local notice = ccui.RichElementImage:create(1, cc.c3b(255, 255, 255), 255, string.format(config_res.images.ui.icon.horn_icon, tonumber(prop_icon)))
    mRoot:pushBackElement(notice)

    while (l > 0) do
        local f,e = string.find(str, "%%%C-%%")
        if f == nil or e == nil then
            local re = nil
            re = ccui.RichElementText:create(1, defcolor1, 255, str, fontname, fontSize)
            mRoot:pushBackElement(re)
            count = count + zstring.utfstrlen(str)
            break
        end
        if f > 1 then
            local strsub = string.sub(str, 1, f-1)
            count = count + zstring.utfstrlen(strsub)

            local re = nil
            re = ccui.RichElementText:create(1, defcolor2, 255, strsub, fontname, fontSize)
       
            mRoot:pushBackElement(re)
        end
        local name = string.sub(str, f+1, e-1)
        local f1, e1 = string.find(name, "%d+")
        if name == nil or f1 == nil or e1 == nil then
        	if mRoot.removeAllChildrenWithCleanup ~= nil then
	            mRoot:removeAllChildrenWithCleanup(true)
	        end
            break
        end
        local quality = string.sub(name, f1, e1)
        local color = tonumber(quality)+1
        name = string.sub(name, e1+2, string.len(name))
        count = count + zstring.utfstrlen(name)
        if color == nil or color <= 0 or color > 11 then
        	if mRoot.removeAllChildrenWithCleanup ~= nil then
	            mRoot:removeAllChildrenWithCleanup(true)
	        end
            break
        end
        local re1 = ccui.RichElementText:create(1, cc.c3b(qualitycolor[color][1],qualitycolor[color][2],qualitycolor[color][3]), 255, name, fontname, fontSize)

        mRoot:pushBackElement(re1)
        str = string.sub(str, e+1, l)
        l = string.len(str)
    end
    if width ~= nil and width > 0 then
        mRoot:setContentSize(cc.size(width+15, height+20))
    else
        mRoot:setContentSize(cc.size(fontSize*count+50, height+35))
    end
    
    return mRoot, count
end

function HomeHorn:onUpdateDrawPlayerInfo()
	local root = self.roots[1]
	if root == nil or self._PlayerInfoLayer == nil then
		return
	end
	local image = self._PlayerInfoLayer
	if image:getChildByTag(1) == nil then
		local fontSize = 20/CC_CONTENT_SCALE_FACTOR()
		local _rootm = image:getContentSize()
		local function playerInfoOver( sender )
			self._PlayerInfoLayer:removeChildByTag(1)
			sender:removeFromParent(true)
			state_machine.excute("home_horn_close", 0, "")
		end

        local prop_icon = zstring.split(dms.string(dms["prop_mould"], self.send_information.system_info_id, prop_mould.pic_index), ",")[1]
        local props = zstring.split(dms.string(dms["prop_config"], 19, prop_config.param), ",")
        for k,v in pairs(props) do
            if tonumber(v) == tonumber(self.send_information.system_info_id) then
                if k ~= 1 then
                    self.image_view:setVisible(false)
                    local armature = nil
                    if k == 2 then
                        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_horn_bar_2)
                        armature = ccs.Armature:create("effice_horn_bar_2")
                    else
                        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_horn_bar_1)
                        armature = ccs.Armature:create("effice_horn_bar_1")
                    end
                    armature:getAnimation():playWithIndex(0)
                    local Panel_horn_notice = ccui.Helper:seekWidgetByName(root, "Panel_horn_notice")
                    ccui.Helper:seekWidgetByName(root, "Panel_horn_notice"):addChild(armature)
                    armature:setPosition(Panel_horn_notice:getContentSize().width/2,Panel_horn_notice:getContentSize().height/2)
                else
                    self.image_view:setVisible(true)
                end
            end
        end

		local str = self.send_information.information_content
		local fontname = ccui.Helper:seekWidgetByName(root, "Label_horn_312_xx"):getFontName()
		local _richText, l = self:cutStringInfo(prop_icon, str, _rootm.height, fontSize, fontname)
		local theW = _richText:getContentSize().width
		local time = (theW + _rootm.width)*0.01
		_richText:setAnchorPoint(cc.p(0.5, 0.5))
		local _pos = cc.p(_richText:getPositionX() -  theW/2, _richText:getPositionY())
		local action  = cc.MoveTo:create(time, _pos)
		_richText:setOpacity(100)
		_richText:setTag(1)
		image:addChild(_richText, 100)
		_richText:setPosition(cc.p(_rootm.width + theW/2, _richText:getPositionY()))
		_richText:runAction( cc.Sequence:create(action,cc.CallFunc:create(playerInfoOver))) 

		self.isPlayPlayerInfo = true
		if self.isPlayPlayerInfo == true then
			self._PlayerInfoLayer:setVisible(true)
			self.image_view:setVisible(true)
		else
			self._PlayerInfoLayer:setVisible(false)
			self.image_view:setVisible(false)
		end
	else
		self.isPlayPlayerInfo = false
	end
end

function HomeHorn:onUpdateDrawPlayerInfoDt(dt)
	if self.PlayerDt > 0 then
		self.PlayerDt = self.PlayerDt - dt
		return
	else
		self.PlayerDt = 1
	end
	if self.isPlayPlayerInfo == false then
		self:onUpdateDrawPlayerInfo()
	else
		self.isPlayPlayerInfo = true
	end
end

function HomeHorn:onUpdateDraw()
	
end

function HomeHorn:onUpdate(dt)
	state_machine.excute("home_horn_show_event",0,"")
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:onUpdateDrawPlayerInfoDt(dt)
end

function HomeHorn:init(params)
	return self
end

function HomeHorn:onEnterTransitionFinish()
	local csbItem = csb.createNode(config_csb.home.home_horn)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbItem)

	self._PlayerInfoLayer = ccui.Helper:seekWidgetByName(root, "Panel_horn_20")
    self._PlayerInfoLayer:setVisible(false)
	self.image_view = ccui.Helper:seekWidgetByName(root, "ImageView_horn_notice")
	self.image_view:setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Label_horn_312_xx"):setVisible(false)

    state_machine.unlock("home_horn_open", 0, "")
end

function HomeHorn:onExit()
	state_machine.remove("home_horn_hide_event")
	state_machine.remove("home_horn_show_event")
end
