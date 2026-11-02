---------------------------------------------------------------------------------------------
-- 说明：抢红包
---------------------------------------------------------------------------------------------
HomeHornRedEnvelopes = class("HomeHornRedEnvelopesClass", Window)

local home_horn_red_envelopes_open_terminal = {
    _name = "home_horn_red_envelopes_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if dms.int(dms["fun_open_condition"], 237, fun_open_condition.level) > zstring.tonumber(_ED.user_info.user_grade)
            or missionIsOver() == false 
            or fwin:find("FightClass") ~= nil
            or fwin:find("CampPkBattleClass") ~= nil
            then
            return
        end
        _ED.redEnvelopesIsPlaying = true
       	local window = fwin:find("HomeHornRedEnvelopesClass")
        if window ~= nil then
            if window:isVisible() == false then 
        		window:setVisible(true)
        	end
        	return true
        end
        state_machine.lock("home_horn_red_envelopes_open", 0, "")

        local window = HomeHornRedEnvelopes:new():init(params)
        fwin:open(window, fwin._dialog)
        return window
    end,
    _terminal = nil,
    _terminals = nil
}

local home_horn_red_envelopes_close_terminal = {
    _name = "home_horn_red_envelopes_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	fwin:close(fwin:find("HomeHornRedEnvelopesClass"))
        state_machine.excute("red_envelopes_play",0,"red_envelopes_play.")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(home_horn_red_envelopes_open_terminal)
state_machine.add(home_horn_red_envelopes_close_terminal)
state_machine.init()

function HomeHornRedEnvelopes:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self.PlayerDt = 1
    self.isPlayPlayerInfo = false

    self._PlayerInfoLayer = nil
	self.image_view = nil

    self.send_information = _ED.current_red_envelopes_play 
    self._prop_id = 0
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeRedEnvelopesRob")
    local function init_home_horn_red_envelopes_terminal()
       -- 隐藏界面
        local home_horn_red_envelopes_hide_event_terminal = {
            _name = "home_horn_red_envelopes_hide_event",
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
        local home_horn_red_envelopes_show_event_terminal = {
            _name = "home_horn_red_envelopes_show_event",
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

        -- 抢红包
        local home_horn_red_envelopes_grab_terminal = {
            _name = "home_horn_red_envelopes_grab",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local prop_id = 0
                local str = zstring.split(instance.send_information.information_content, "|||")

                prop_id = zstring.tonumber(str[2])
                if zstring.tonumber(prop_id) <= 0 then
                    return
                end
                local oldToken = 0
                local oldGold = tonumber(_ED.user_info.user_gold)
                if _ED.activity_info["61"] ~= nil then
                    local timesData = zstring.split(_ED.activity_info["61"].activity_add_state, ",")
                    oldToken = tonumber(timesData[3])
                end
                local function responseSendMessageCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local isOne = false
                        local token = 0
                        if _ED.activity_info["61"] ~= nil then
                            local timesData = zstring.split(_ED.activity_info["61"].activity_add_state, ",")
                            token = tonumber(timesData[3])
                        end
                        if token~=oldToken or oldGold~=tonumber(_ED.user_info.user_gold) then
                            isOne = true
                            state_machine.excute("main_window_update_gold_info", 0, nil)
                            checkRewardObtainDraw()
                        end
                        if _ED.get_red_envelopes_info ~= nil 
                            or #_ED.get_red_envelopes_info > 0 then
                            for k,v in pairs(_ED.get_red_envelopes_info) do
                                if v.name == _ED.user_info.user_name then  
                                    if isOne == false then
                                        TipDlg.drawTextDailog(chat_sent_string[12])
                                    else
                                        if tonumber(_ED.red_envelopes_template_id) == 681 then
                                            TipDlg.drawTextDailog(chat_sent_string[13]..v.gold)
                                            if fwin:find("RedAlertTimeRedEnvelopesClass") ~= nil then
                                                state_machine.excute("red_alert_time_red_rnvelopes_update_window", 0, nil)
                                            end
                                        end
                                    end
                                    state_machine.excute("red_alert_time_red_rnvelopes_rob_window_open", 0, "")
                                    return
                                end
                            end
                        end

                        if _ED.red_envelopes_max_times <= _ED.red_envelopes_make_times then
                            TipDlg.drawTextDailog(chat_sent_string[11])
                            state_machine.excute("red_alert_time_red_rnvelopes_rob_window_open", 0, "")
                        else
                            state_machine.excute("main_window_update_gold_info", 0, nil)
                        end
                    end
                end
                
                protocol_command.grab_red_packet.param_list = prop_id
                NetworkManager:register(protocol_command.grab_red_packet.code, nil, nil, nil, instance, responseSendMessageCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(home_horn_red_envelopes_hide_event_terminal)
        state_machine.add(home_horn_red_envelopes_show_event_terminal)
        state_machine.add(home_horn_red_envelopes_grab_terminal)
        state_machine.init()
    end
    init_home_horn_red_envelopes_terminal()
end

function HomeHornRedEnvelopes:onHide()
	self:setVisible(false)
end

function HomeHornRedEnvelopes:onShow()
	self:setVisible(true)
end

function HomeHornRedEnvelopes:cutStringInfo(str, height, fontSize, fontname)
	local defcolor1 = cc.c3b(255, 255, 255)
	local defcolor2 = cc.c3b(255, 255, 255)
	local qualitycolor = tipStringInfo_quality_color_Type

    local mRoot = ccui.RichText:create()
    fontSize = fontSize or 10
    local l = string.len(str)
    mRoot:ignoreContentAdaptWithSize(false)
    local count = 0

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
        mRoot:setContentSize(cc.size(fontSize*count+15, height+20))
    end
    
    return mRoot, count
end

function HomeHornRedEnvelopes:onUpdateDrawPlayerInfo()
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
            state_machine.excute("home_horn_red_envelopes_close", 0, "")
        end
        local str = zstring.split(self.send_information.information_content, "|||")
        self._prop_id = str[2]
        local fontname = ccui.Helper:seekWidgetByName(root, "Label_horn_312_xx"):getFontName()
        local _richText, l = self:cutStringInfo(str[1], _rootm.height, fontSize, fontname)
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

function HomeHornRedEnvelopes:onUpdateDrawPlayerInfoDt(dt)
	if self.PlayerDt > 0 then
		self.PlayerDt = self.PlayerDt - dt
		return
	else
		self.PlayerDt = 1
	end
    if checkPushInfoOpen() == false then
        state_machine.excute("home_horn_red_envelopes_hide_event",0,"")
    else
        state_machine.excute("home_horn_red_envelopes_show_event",0,"")
    end
	if self.isPlayPlayerInfo == false then
		self:onUpdateDrawPlayerInfo()
	else
		self.isPlayPlayerInfo = true
	end
    -- if _ED.red_envelopes_max_times <= _ED.red_envelopes_make_times then
end

function HomeHornRedEnvelopes:onUpdateDraw()
	
end

function HomeHornRedEnvelopes:onUpdate(dt)
	state_machine.excute("home_horn_red_envelopes_show_event",0,"")
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:onUpdateDrawPlayerInfoDt(dt)
end

function HomeHornRedEnvelopes:init(params)
	return self
end

function HomeHornRedEnvelopes:onEnterTransitionFinish()
	local csbItem = csb.createNode(config_csb.home.home_horn_red_envelopes)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbItem)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rob_red_envelopes"), nil, 
    {
        terminal_name = "home_horn_red_envelopes_grab", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)   


	self._PlayerInfoLayer = ccui.Helper:seekWidgetByName(root, "Panel_horn_20")
    self._PlayerInfoLayer:setVisible(false)
	self.image_view = ccui.Helper:seekWidgetByName(root, "ImageView_horn_notice")
	self.image_view:setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Label_horn_312_xx"):setVisible(false)



    state_machine.unlock("home_horn_red_envelopes_open", 0, "")
end

function HomeHornRedEnvelopes:onExit()
	state_machine.remove("home_horn_red_envelopes_hide_event")
	state_machine.remove("home_horn_red_envelopes_show_event")
    state_machine.remove("home_horn_red_envelopes_grab")
end
