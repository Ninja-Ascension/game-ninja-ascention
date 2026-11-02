
--------------------------------------------------------------------------------------------------------------
--  说明：将领招募
--------------------------------------------------------------------------------------------------------------
LeaderRecruit = class("LeaderRecruitClass", Window)

--打开界面
local leader_recruit_window_open_terminal = {
	_name = "leader_recruit_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local panel = LeaderRecruit:new():init(params)
		fwin:open(panel)
		return panel
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(leader_recruit_window_open_terminal)
state_machine.init()

function LeaderRecruit:ctor()
	self.super:ctor()
	self.roots = {}

	self._choose_type = 0
    self._specil_free_time = nil
    self._free_recruit = nil
    self._free_time = nil

    self._is_free = false

    self._active_count = 0
    self._action_one_money = 1
    self._action_ten_money = 1
    app.load("client.red_alert_time.worldMap.redAlertTimeMineWarmTips")
    local function init_leader_recruit_terminal()
        local leader_recruit_show_terminal = {
            _name = "leader_recruit_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local leader_recruit_hide_terminal = {
            _name = "leader_recruit_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local leader_recruit_choose_recruit_terminal = {
            _name = "leader_recruit_choose_recruit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("leader_recruit_choose_recruit")
            	instance._choose_type = params._datas.state
            	if instance._choose_type == 1 then
            		instance:sureRecruit(0)
                elseif instance._choose_type == 2 and instance._is_free == true then
                    instance:sureRecruit(0)
            	else
                    local price = countActivityHeroDiscount()
            		local need_gold = 0
                    local cost = 0
                    if instance._choose_type == 2 then
                        need_gold = price.one 
                        cost = 1
                        if _ED.activity_info ~= nil and _ED.activity_info["8"] ~= nil then
                            local a_datas = zstring.split(_ED.activity_info["8"].activity_add_state ,",")
                            need_gold = math.floor(need_gold * tonumber(a_datas[5]))
                        end
                    else
                        need_gold = price.ten
                        cost = 10
                        if _ED.activity_info ~= nil and _ED.activity_info["8"] ~= nil then
                            local a_datas = zstring.split(_ED.activity_info["8"].activity_add_state ,",")
                            need_gold = math.floor(need_gold * tonumber(a_datas[6]))
                        end
                    end
                    if tonumber(need_gold) > tonumber(_ED.user_info.user_gold) then
                        TipDlg.drawTextDailog(tipStringInfo_campaign_info[16])
                        state_machine.unlock("leader_recruit_choose_recruit")
                        return
                    end
                    state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = {need_gold,cost,instance._choose_type}, m_type = 12}})
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local leader_recruit_update_terminal = {
            _name = "leader_recruit_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local leader_recruit_sure_hoose_recruit_terminal = {
            _name = "leader_recruit_sure_hoose_recruit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local choose_type = params[1]
                local function recruitCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if choose_type == 3 then
                            if fwin:find("LeaderRecruitTenClass") ~= nil then
                                state_machine.excute("leader_recruit_ten_update_draw", 0, nil)
                            else
                                state_machine.excute("leader_recruit_ten_window_open", 0, nil)
                            end
                        else
                            if fwin:find("LeaderRecruitOnceClass") ~= nil then
                                state_machine.excute("leader_recruit_once_update_draw", 0, nil)
                            else
                                state_machine.excute("leader_recruit_once_window_open", 0, {choose_type})
                            end
                        end
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node._choose_type = 0
                            state_machine.excute("leader_recruit_update", 0, nil)
                        end
                    end
                end
                if choose_type == 3 then
                    protocol_command.ship_batch_bounty.param_list = ""..2
                    NetworkManager:register(protocol_command.ship_batch_bounty.code, nil, nil, nil, self, recruitCallBack, false, nil)   
                else
                    protocol_command.ship_bounty.param_list = ""..choose_type
                    NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, self, recruitCallBack, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(leader_recruit_show_terminal)	
        state_machine.add(leader_recruit_hide_terminal)
        state_machine.add(leader_recruit_choose_recruit_terminal) 
        state_machine.add(leader_recruit_update_terminal)
        state_machine.add(leader_recruit_sure_hoose_recruit_terminal)
        state_machine.init()
    end
    init_leader_recruit_terminal()
end

function LeaderRecruit:sureRecruit(sure_number)
	local choose_type = self._choose_type
    local function recruitCallBack( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
        	if choose_type == 3 then
            	state_machine.excute("leader_recruit_ten_window_open", 0, nil)
            else
            	state_machine.excute("leader_recruit_once_window_open", 0, {choose_type})
            end
            if response.node ~= nil and response.node.roots ~= nil then
                response.node._choose_type = 0
	            state_machine.excute("leader_recruit_update", 0, nil)
            end
            state_machine.excute("home_map_update_prodcution_state", 0, {7})
            state_machine.excute("notification_center_update", 0, "push_notification_leader_exhange")
        end
    end
    if sure_number == 0 then
        if choose_type == 3 then
            protocol_command.ship_batch_bounty.param_list = ""..2
            NetworkManager:register(protocol_command.ship_batch_bounty.code, nil, nil, nil, self, recruitCallBack, false, nil)   
        else
    	    protocol_command.ship_bounty.param_list = ""..choose_type
    	    NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, self, recruitCallBack, false, nil)
        end
        checkPlayEffect(21)
	end
end

function LeaderRecruit:onUpdate(dt)
    local specil_recruit = (tonumber(_ED.free_info[2].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[2].free_start))
    if tonumber(specil_recruit) < 0 then
        self._specil_free_time:setString("")
        self._is_free = true
    else
        self._specil_free_time:setString(exChangeTimeToString(specil_recruit)..red_alert_time_str[66])
        if verifySupportLanguage(_lua_release_language_en) == true then
            self._specil_free_time:setString(red_alert_time_str[66]..exChangeTimeToString(specil_recruit))
        end
        self._is_free = false
    end
    local free_time = tonumber(_ED.free_info[1].surplus_free_number)+self._active_count or 0 
    local normal_recruit = (tonumber(_ED.free_info[1].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[1].free_start))
    if free_time > 0 and normal_recruit < 0 then
        self._free_time:setString("")
        self._free_recruit:setTouchEnabled(true)
        self._free_recruit:setBright(true)
    else
        if free_time > 0 then
            self._free_time:setString(exChangeTimeToString(normal_recruit)..red_alert_time_str[66])
            if verifySupportLanguage(_lua_release_language_en) == true then
                self._free_time:setString(red_alert_time_str[66]..exChangeTimeToString(normal_recruit))
            end
        end
        self._free_recruit:setTouchEnabled(false)
        self._free_recruit:setBright(false)
    end
end

function LeaderRecruit:onUpdateDraw(  )
    local root = self.roots[1]
    --活动
    if _ED.activity_info~=nil and _ED.activity_info["8"]~= nil then
        local a_datas = zstring.split(_ED.activity_info["8"].activity_add_state ,",")
        self._active_count = tonumber(a_datas[4])
        self._action_one_money = tonumber(a_datas[5])
        self._action_ten_money = tonumber(a_datas[6])
    end

    local price = countActivityHeroDiscount()
    -- 单抽价格
    local Text_senior_recruit_consume_n = ccui.Helper:seekWidgetByName(root, "Text_senior_recruit_consume_n")
    local Text_senior_recruit_consume_discount_n = ccui.Helper:seekWidgetByName(root, "Text_senior_recruit_consume_discount_n")
    local Image_senior_recruit_delete = ccui.Helper:seekWidgetByName(root, "Image_senior_recruit_delete")
    local Image_leader_draw_1 = ccui.Helper:seekWidgetByName(root, "Image_leader_draw_1")
    Text_senior_recruit_consume_n:setString(math.floor(price.one*self._action_one_money))
    Text_senior_recruit_consume_discount_n:setString("")
    Image_senior_recruit_delete:setVisible(false)
    Image_leader_draw_1:setVisible(false)
    if self._action_one_money == 1 then
    else
        Text_senior_recruit_consume_discount_n:setString(price.one)
        Image_senior_recruit_delete:setVisible(true)
        Image_leader_draw_1:setVisible(true)
    end
    -- 十连抽价格
    local Text_ten_recruit_consume_n = ccui.Helper:seekWidgetByName(root, "Text_ten_recruit_consume_n")
    local Text_ten_recruit_consume_discount_n = ccui.Helper:seekWidgetByName(root, "Text_ten_recruit_consume_discount_n")
    local Image_ten_recruit_delete = ccui.Helper:seekWidgetByName(root, "Image_ten_recruit_delete")
    local Image_leader_draw_10 = ccui.Helper:seekWidgetByName(root, "Image_leader_draw_10")
    Text_ten_recruit_consume_n:setString(math.floor(price.ten*self._action_ten_money))
    Text_ten_recruit_consume_discount_n:setString("")
    Image_ten_recruit_delete:setVisible(false)
    Image_leader_draw_10:setVisible(false)
    if self._action_ten_money == 1 then
    else
        Text_ten_recruit_consume_discount_n:setString(price.ten)
        Image_ten_recruit_delete:setVisible(true)
        Image_leader_draw_10:setVisible(true)
    end
    -- 免费次数
    local Button_free_recruit = ccui.Helper:seekWidgetByName(root, "Button_free_recruit")
    local Text_recruit_free_time = ccui.Helper:seekWidgetByName(root, "Text_recruit_free_time")
    local Text_free_time_n = ccui.Helper:seekWidgetByName(root, "Text_free_time_n")
    local free_count = dms.int(dms["partner_bounty_param"], 1, partner_bounty_param.free_count)+self._active_count
    local free_time = tonumber(_ED.free_info[1].surplus_free_number)+self._active_count or 0 
    Text_free_time_n:setString(free_time.."/"..free_count)
    local normal_recruit = (tonumber(_ED.free_info[1].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[1].free_start))
    self._free_recruit = Button_free_recruit
    self._free_time = Text_recruit_free_time
    Text_recruit_free_time:setString("")
    if free_time > 0 and normal_recruit < 0 then
        Button_free_recruit:setTouchEnabled(true)
        Button_free_recruit:setBright(true)
    else
        Button_free_recruit:setTouchEnabled(false)
        Button_free_recruit:setBright(false)
    end


    -- 高级免费
    local Button_senior_recruit = ccui.Helper:seekWidgetByName(root, "Button_senior_recruit")
    local Button_free_senior_recruit = ccui.Helper:seekWidgetByName(root, "Button_free_senior_recruit")
    local Text_senior_recruit_free_time = ccui.Helper:seekWidgetByName(root, "Text_senior_recruit_free_time")
    local Image_senior_recruit_icon = ccui.Helper:seekWidgetByName(root, "Image_senior_recruit_icon")
    Image_senior_recruit_icon:setVisible(true)
    Button_senior_recruit:setVisible(false)
    Button_free_senior_recruit:setVisible(false)
    local specil_recruit = (tonumber(_ED.free_info[2].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[2].free_start))
    if tonumber(specil_recruit) < 0 then
        Text_senior_recruit_consume_n:setString("")
        Image_senior_recruit_icon:setVisible(false)
        Text_senior_recruit_free_time:setString("")
        self._is_free = true
        Button_free_senior_recruit:setVisible(true)
        Text_senior_recruit_consume_discount_n:setString("")
        Image_senior_recruit_delete:setVisible(false)
        Image_leader_draw_1:setVisible(false)
    else
        Text_senior_recruit_free_time:setString(exChangeTimeToString(specil_recruit)..red_alert_time_str[66])
        if verifySupportLanguage(_lua_release_language_en) == true then
            Text_senior_recruit_free_time:setString(red_alert_time_str[66]..exChangeTimeToString(specil_recruit))
        end
        self._is_free = false
        Button_senior_recruit:setVisible(true)
    end
    self._specil_free_time = Text_senior_recruit_free_time
end

function LeaderRecruit:onInit(params)
    local csbItem = csb.createNode(config_csb.leader.leader_recruit_tab)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_free_recruit"), nil, 
    {
        terminal_name = "leader_recruit_choose_recruit", 
        terminal_state = 0, 
       	touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        state = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_senior_recruit"), nil, 
    {
        terminal_name = "leader_recruit_choose_recruit", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        state = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_free_senior_recruit"), nil, 
    {
        terminal_name = "leader_recruit_choose_recruit", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        state = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ten_recruit"), nil, 
    {
        terminal_name = "leader_recruit_choose_recruit", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        state = 3,
    }, nil, 1)

    self:onUpdateDraw()

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_recruit_get_text)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_recruit_get_light)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_luck_draw)
end

function LeaderRecruit:onEnterTransitionFinish()

end

function LeaderRecruit:init(params)
	self._rootWindows = params[1]
	self:onInit()
    return self
end

function LeaderRecruit:onExit()
    state_machine.remove("leader_recruit_show")
    state_machine.remove("leader_recruit_hide")
    state_machine.remove("leader_recruit_choose_recruit")
    state_machine.remove("leader_recruit_update")
    state_machine.remove("leader_recruit_sure_hoose_recruit")
end