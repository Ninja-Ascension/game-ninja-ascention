--------------------------------------------------------------------------------------------------------------
--  说明：将领招募一次
--------------------------------------------------------------------------------------------------------------
LeaderRecruitOnce = class("LeaderRecruitOnceClass", Window)

--打开界面
local leader_recruit_once_window_open_terminal = {
	_name = "leader_recruit_once_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:open(LeaderRecruitOnce:new():init(params), fwin._ui)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local leader_recruit_once_window_close_terminal = {
    _name = "leader_recruit_once_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LeaderRecruitOnceClass"))
        state_machine.excute("leader_team_list_update", 0, "")
        state_machine.excute("leader_exchange_list_update", 0, "")
        _ED.show_reward_list_group = {}
        _ED.show_reward_list_group_ex = {}
        state_machine.unlock("leader_recruit_choose_recruit")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(leader_recruit_once_window_open_terminal)
state_machine.add(leader_recruit_once_window_close_terminal)
state_machine.init()

function LeaderRecruitOnce:ctor()
	self.super:ctor()
	self.roots = {}

    self._choose_type = 0

    self._text_time = nil
    self._button_recruit = nil
    self._active_count = 0

    local function init_leader_recruit_once_terminal()
        local leader_recruit_once_sure_recruit_terminal = {
            _name = "leader_recruit_once_sure_recruit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local price = countActivityHeroDiscount()
                local need_gold = price.one 
                if _ED.activity_info ~= nil and _ED.activity_info["8"] ~= nil then
                    local a_datas = zstring.split(_ED.activity_info["8"].activity_add_state ,",")
                    need_gold = math.floor(need_gold * tonumber(a_datas[5]))
                end
                state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = {need_gold, 1, 2}, m_type = 12}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local leader_recruit_once_update_draw_terminal = {
            _name = "leader_recruit_once_update_draw",
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

        state_machine.add(leader_recruit_once_sure_recruit_terminal) 
        state_machine.add(leader_recruit_once_update_draw_terminal) 
        state_machine.init()
    end
    init_leader_recruit_once_terminal()
end

function LeaderRecruitOnce:sureRecruit(sure_number)
    local function recruitCallBack( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:onUpdateDraw()
            end
            state_machine.excute("leader_recruit_update", 0, nil)
        end
    end
    if sure_number == 0 then
        protocol_command.ship_bounty.param_list = ""..2
        NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, self, recruitCallBack, false, nil)
    end
end

function LeaderRecruitOnce:onUpdateDraw(  )
    local root = self.roots[1]
    --活动
    if _ED.activity_info~=nil and _ED.activity_info["8"]~= nil then
        local a_datas = zstring.split(_ED.activity_info["8"].activity_add_state ,",")
        self._active_count = tonumber(a_datas[4])
    end
    local Panel_leader_get_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_get_icon")
    local Text_recruit_gold_n = ccui.Helper:seekWidgetByName(root, "Text_recruit_gold_n")
    local Text_ten_recruit_consume_n = ccui.Helper:seekWidgetByName(root, "Text_ten_recruit_consume_n")
    local Text_senior_recruit_free_time = ccui.Helper:seekWidgetByName(root, "Text_senior_recruit_free_time")
    local Panel_get_text_effice = ccui.Helper:seekWidgetByName(root, "Panel_get_text_effice")
    local Button_senior_recruit = ccui.Helper:seekWidgetByName(root, "Button_senior_recruit")
    local Text_free_time_t = ccui.Helper:seekWidgetByName(root, "Text_free_time_t")
    local Text_free_time_n = ccui.Helper:seekWidgetByName(root, "Text_free_time_n")

    local Text_senior_recruit_free_time = ccui.Helper:seekWidgetByName(root, "Text_senior_recruit_free_time")
    Text_senior_recruit_free_time:setString("")
    self._text_time = Text_senior_recruit_free_time

    local price = countActivityHeroDiscount()
    local percent = 1
    local Image_leader_draw_get_1 = ccui.Helper:seekWidgetByName(root, "Image_leader_draw_get_1")
    local Image_senior_get_1_delete = ccui.Helper:seekWidgetByName(root, "Image_senior_get_1_delete")
    local Text_senior_get_1_consume_discount_n = ccui.Helper:seekWidgetByName(root, "Text_senior_get_1_consume_discount_n")
    Image_leader_draw_get_1:setVisible(false)
    Image_senior_get_1_delete:setVisible(false)
    Text_senior_get_1_consume_discount_n:setString("")
    if _ED.activity_info ~= nil and _ED.activity_info["8"] ~= nil then
        local a_datas = zstring.split(_ED.activity_info["8"].activity_add_state ,",")
        percent = tonumber(a_datas[5])
        Image_leader_draw_get_1:setVisible(true)
        Image_senior_get_1_delete:setVisible(true)
        Text_senior_get_1_consume_discount_n:setString(price.one)
    end
    Text_recruit_gold_n:setString(math.floor(price.one * percent))
    if self._choose_type == 1 then
        Button_senior_recruit:setTitleText(red_alert_time_str[71])
        Button_senior_recruit:setBright(false)
        Button_senior_recruit:setTouchEnabled(false)
        ccui.Helper:seekWidgetByName(root, "Button_recruit_sure"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Image_recruit_gold_icon"):setVisible(false)
        Text_recruit_gold_n:setVisible(false)
        Text_free_time_t:setVisible(true)
        Text_free_time_n:setVisible(true)

        local free_count = dms.int(dms["partner_bounty_param"], 1, partner_bounty_param.free_count)+self._active_count
        local free_time = tonumber(_ED.free_info[1].surplus_free_number)+self._active_count or 0 
        Text_free_time_n:setString(free_time.."/"..free_count)

        Image_leader_draw_get_1:setVisible(false)
        Image_senior_get_1_delete:setVisible(false)
        Text_senior_get_1_consume_discount_n:setString("")
    else
        Button_senior_recruit:setTitleText(red_alert_time_str[72])
        Button_senior_recruit:setBright(true)
        Button_senior_recruit:setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root, "Button_recruit_sure"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Image_recruit_gold_icon"):setVisible(true)
        Text_recruit_gold_n:setVisible(true)
        Text_free_time_t:setVisible(false)
        Text_free_time_n:setVisible(false)
    end

    self._button_recruit = Button_senior_recruit

    Panel_get_text_effice:removeAllChildren(true)
    local armature1 = ccs.Armature:create("effice_recruit_get_text")
    draw.initArmature(armature1, nil, -1, 0, 1)
    armature1:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    Panel_get_text_effice:addChild(armature1)
    armature1:getAnimation():playWithIndex(0)

    function actionCallBack(sender)
        
    end
    Panel_leader_get_icon:removeBackGroundImage()
    Panel_leader_get_icon:removeAllChildren(true)
    Panel_leader_get_icon:stopAllActions()
    Panel_leader_get_icon:setScale(0.1)

    local get_prop_type = tonumber(_ED.free_info[self._choose_type].get_prop_type)
    local get_prop_id = tonumber(_ED.free_info[self._choose_type].get_prop_id)
    local get_prop_num = tonumber(_ED.free_info[self._choose_type].get_prop_num)
    local cell = nil 
    if get_prop_type == 0 then
        checkPlayEffect(57)
        cell = state_machine.excute("props_icon_create_cell",0,{9,1,get_prop_id,1,get_prop_num,true})
    elseif get_prop_type == 1 then
        checkPlayEffect(58)
        cell = state_machine.excute("props_icon_create_cell", 0, {2, 9, get_prop_id, 3, get_prop_num,true})
    else
        checkPlayEffect(57)
        cell = state_machine.excute("props_icon_create_cell",0,{9,1,get_prop_id,1,get_prop_num,true})
    end
    Panel_leader_get_icon:addChild(cell)
    -- Panel_leader_get_icon:setBackGroundImage("images/ui/props/props_3.png")
    local armature = ccs.Armature:create("effice_recruit_get_light")
    draw.initArmature(armature, nil, -1, 0, 1)
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    Panel_leader_get_icon:addChild(armature)
    armature:setPosition(cc.p(Panel_leader_get_icon:getContentSize().width/2, Panel_leader_get_icon:getContentSize().height/2))
    armature:getAnimation():playWithIndex(0)
    
    Panel_leader_get_icon:runAction(cc.Sequence:create(
        cc.ScaleTo:create(0.1, 1),
        cc.CallFunc:create(actionCallBack)
        ))
end

function LeaderRecruitOnce:onUpdate(dt)
    if self._text_time ~= nil then
        if self._choose_type == 1 then
            local free_time = tonumber(_ED.free_info[1].surplus_free_number)+self._active_count or 0 
            local normal_recruit = (tonumber(_ED.free_info[1].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[1].free_start))
            if free_time > 0 and normal_recruit < 0 then
                self._text_time:setString("")
                self._button_recruit:setTouchEnabled(true)
                self._button_recruit:setBright(true)
            else
                if free_time > 0 then
                    self._text_time:setString(exChangeTimeToString(normal_recruit)..red_alert_time_str[66])
                    if verifySupportLanguage(_lua_release_language_en) == true then
                        self._text_time:setString(red_alert_time_str[66]..exChangeTimeToString(normal_recruit))
                    end
                end
                self._button_recruit:setTouchEnabled(false)
                self._button_recruit:setBright(false)
            end
        else
            local specil_recruit = (tonumber(_ED.free_info[2].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[2].free_start))
            if tonumber(specil_recruit) < 0 then
                self._button_recruit:setTitleText(red_alert_time_str[71])
                self._text_time:setString("")
            else
                self._button_recruit:setTitleText(red_alert_time_str[72])
                self._text_time:setString(exChangeTimeToString(specil_recruit)..red_alert_time_str[66])
                if verifySupportLanguage(_lua_release_language_en) == true then
                    self._text_time:setString(red_alert_time_str[66]..exChangeTimeToString(specil_recruit))
                end
            end
        end
    end
end

function LeaderRecruitOnce:onInit(params)
    local csbItem = csb.createNode(config_csb.leader.leader_recruit_get)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_senior_recruit"), nil, 
    {
        terminal_name = "leader_recruit_once_sure_recruit", 
        terminal_state = 0, 
       	touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recruit_sure"), nil, 
    {
        terminal_name = "leader_recruit_once_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recruit_free_sure"), nil, 
    {
        terminal_name = "leader_recruit_once_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)

    self:onUpdateDraw()
end

function LeaderRecruitOnce:onEnterTransitionFinish()

end

function LeaderRecruitOnce:init(params)
    self._choose_type = params[1]
	self:onInit()
    return self
end

function LeaderRecruitOnce:onExit()
    state_machine.remove("leader_recruit_once_sure_recruit")
    state_machine.remove("leader_recruit_once_update_draw")
end