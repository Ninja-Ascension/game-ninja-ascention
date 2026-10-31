--------------------------------------------------------------------------------------------------------------
--  皇城
--------------------------------------------------------------------------------------------------------------
Tourneyfield = class("TourneyfieldClass", Window)

--打开界面
local tourneyfield_window_open_terminal = {
	_name = "tourneyfield_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        -- cacher.removeAllTextures()
        -- fwin:freeAllMemeryPool()
        -- local function responseCallback(response)
        --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("TourneyfieldClass") == nil then
                    state_machine.excute("home_select_action_window_close",0,"")
                    local index = nil 
                    if params ~= nil and params ~= "" then
                        index = params[1]
                    end
                    fwin:open(Tourneyfield:new():init(index),fwin._view)
                end
                state_machine.excute("main_window_hide", 0, "")
                state_machine.excute("player_resource_window_hide", 0, "")     
                state_machine.excute("home_button_for_action_window_hide",0,"")
                state_machine.excute("chat_view_window_hide",0,"")  
        --     end
        -- end
        -- protocol_command.arena_init.param_list = "0"
        -- NetworkManager:register(protocol_command.arena_init.code, nil, nil, nil, nil, responseCallback, false, nil)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local tourneyfield_window_close_terminal = {
	_name = "tourneyfield_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TourneyfieldClass"))
        if fwin:find("TaskClass") ~= nil then
            state_machine.excute("task_window_show",0,"") 
            state_machine.excute("player_resource_window_hide",0,"") 
            state_machine.excute("home_button_for_action_window_hide",0,"") 
            state_machine.excute("chat_view_window_hide",0,"")
            state_machine.excute("seven_star_map_ui_window_hide",0,"")
        elseif fwin:find("HeroMainClass") ~= nil then
            state_machine.excute("hero_main_window_show",0,"") 
            state_machine.excute("player_resource_window_hide",0,"") 
            state_machine.excute("home_button_for_action_window_hide",0,"") 
            state_machine.excute("chat_view_window_hide",0,"")
        else
            state_machine.excute("main_window_open",0,"")
            state_machine.excute("player_resource_window_show",0,"")   
            state_machine.excute("home_button_for_action_window_show",0,"")  
            state_machine.excute("chat_view_window_show",0,"")
            state_machine.excute("duplicate_title_window_show",0,"")    
        end   
        -- clear cacher
        cacher.clearWindowCacher()
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(tourneyfield_window_open_terminal)
state_machine.add(tourneyfield_window_close_terminal)
state_machine.init()

function Tourneyfield:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    self._effect_owner = nil
    -- 从主界面打开为1，否则为空
    self._index = nil 
    -- load lua file
    app.load("client.red_alert.campaign.tourneyfield.TourneyfieldGrand")
    app.load("client.red_alert.campaign.tourneyfield.TourneyfieldRanking")
    app.load("client.red_alert.campaign.tourneyfield.TourneyfieldOfficer")
    app.load("client.red_alert.campaign.tourneyfield.TourneyfieldUp")
    app.load("client.utils.ConfirmTip")
    app.load("client.red_alert.cells.campaign.tourneyfield.tourneyfield_officer_top_cell")
    
	-- Initialize tourneyfield state machine.
    local function init_tourneyfield_terminal()
        --购买次数
        local tourneyfield_buy_arena_launch_count_terminal = {
            _name = "tourneyfield_buy_arena_launch_count",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --请求购买
                
                if _ED.arena_info.buy_attack_count == 0 then
                    TipDlg.drawTextDailog(red_alert_all_str[147])
                    return
                end

                local arena_config_count_cost = dms.string(dms["arena_config"],4,arena_config.param)
                arena_config_count_cost = zstring.split(arena_config_count_cost,",")

                local need_gem = tonumber(arena_config_count_cost[#arena_config_count_cost - _ED.arena_info.buy_attack_count + 1])
                if tonumber(_ED.user_info.user_gold) <= need_gem then
                    TipDlg.drawTextDailog(red_alert_all_str[79])
                    return
                end
                
                local tip = ConfirmTip:new()
                local info = string.format(red_alert_all_str[148],need_gem)
                
                tip:init(instance, instance.buyCount, info)
                fwin:open(tip,fwin._windows)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 播放光效
        local tourneyfield_play_head_effic_terminal = {
            _name = "tourneyfield_play_head_effic",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:PlayUserHeadEffic()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }      
 
        -- 位移至指定坐标区域  
        local tourneyfield_scroll_to_position_terminal = {
            _name = "tourneyfield_scroll_to_position",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local pos_x = params[1]
                local pos_y = params[2]
                instance:scrollToPosition(pos_x,pos_y)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local tourneyfield_update_draw_terminal = {
            _name = "tourneyfield_update_draw",
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

        state_machine.add(tourneyfield_buy_arena_launch_count_terminal)
        state_machine.add(tourneyfield_play_head_effic_terminal)
        state_machine.add(tourneyfield_scroll_to_position_terminal)
        state_machine.add(tourneyfield_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func tourneyfield create state machine.
    init_tourneyfield_terminal()

end

--购买次数
function Tourneyfield:buyCount(sure_number)

    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.onUpdateDrawAttackCount ~= nil then
                response.node:onUpdateDrawAttackCount()
            end
        end
    end

    if sure_number == 0 then
        protocol_command.buy_arena_launch_count.param_list = "0"
        NetworkManager:register(protocol_command.buy_arena_launch_count.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

-- 位移至指定坐标区域
function Tourneyfield:scrollToPosition(x,y)
    local root = self.roots[1]
    local ScrollView_grade = ccui.Helper:seekWidgetByName(root,"ScrollView_grade")
    ScrollView_grade:getInnerContainer():setPosition(cc.p(x, y))
end

--初始化界面
function Tourneyfield:onInit()
    local csbItem = csb.createNode(config_csb.campaign.tourneyfield.tourneyfield)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    
    if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
    	for i=1,5 do
			local Panel_bg = ccui.Helper:seekWidgetByName(root,"Panel_bg_"..i)
			if i==1 then
				Panel_bg:setBackGroundImage("images/ui/play/tourneyfield/imperial_bg_2.png")
			else
				Panel_bg:setBackGroundImage("images/ui/play/tourneyfield/imperial_bg_1.png")
			end
		end
    end
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "tourneyfield_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)   
      
    -- 战报
    local Button_grand = ccui.Helper:seekWidgetByName(root, "Button_grand")
    Button_grand:setVisible(false)
    if funOpenDrawTip(75,false) == false then
        Button_grand:setVisible(true)
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_grand"), nil, 
    {
        terminal_name = "tourneyfield_grand_window_open",
        -- func_string = [[funOpenDrawTip(75)]],
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)  

    -- 购买次数
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add"), nil, 
    {
        terminal_name = "tourneyfield_buy_arena_launch_count",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 
    
    -- 排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rank"), nil, 
    {
        terminal_name = "tourneyfield_ranking_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 
    
    for i = 1,dms.count(dms["arena_reward_param"]) do
        if i > 34 then 
            i = 34
        end
        local Panel_grade = ccui.Helper:seekWidgetByName(root,"Panel_role_"..i)
        fwin:addTouchEventListener(Panel_grade, nil, 
        {
            terminal_name = "tourneyfield_officer_window_open", 
            terminal_state = 0, 
            arena_id = i, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0)
        local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name_"..i)
        local arena_name = dms.string(dms["arena_reward_param"],i,arena_reward_param.arena_name)
        arena_name = zstring.split(arena_name,",")
        arena_name = arena_name[tonumber(_ED.user_info.user_force)]
        Text_name:setString(arena_name)
    end
    if self._index == nil then
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil then
                    response.node:onUpdateDraw()
                end
            end
        end
        protocol_command.arena_init.param_list = "0"
        NetworkManager:register(protocol_command.arena_init.code, nil, nil, nil, self, responseCallback, false, nil)
    else
        self:onUpdateDraw()
    end
end

--判断官职是否进阶
function Tourneyfield:onEnterTransitionFinish()
    local function checkPlayUpAnimation()
        if _ED.arena_info.last_user_arena_id ~= nil then
            if _ED.arena_info.arena_id >= _ED.arena_info.last_user_arena_id then--如果当前官阶更低或者没变，不播放动画
                return false
            else 
                return true
            end
        end
    end
    local arena_id = _ED.arena_info.arena_id
    if arena_id == 35 then      --35表示没有阶位
        return
    end
    if checkPlayUpAnimation() == true then
        self:PlayUpAnimation()
        if self._effect_owner ~= nil then
            self._effect_owner:setVisible(false)
        end
    else
        if self._effect_owner ~= nil then
            self._effect_owner:setVisible(true)
        end
    end
    _ED.arena_info.last_user_arena_id = _ED.arena_info.arena_id
end

function Tourneyfield:PlayUpAnimation()
    state_machine.excute("tourneyfield_up_window_open",0,"")
end

--官职进阶播放
function Tourneyfield:PlayUserHeadEffic()
    local root = self.roots[1] 
    if self._effect_owner ~= nil and self._effect_owner.parent ~= nil then
        self._effect_owner:removeFromParent(true)
        self._effect_owner = nil
    end
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_jingshengli_light/effice_jingshengli_light.ExportJson")
    local armature = ccs.Armature:create("effice_jingshengli_light")
    armature:getAnimation():playWithIndex(0)

    local arena_official = dms.int(dms["arena_reward_param"],_ED.arena_info.arena_id,arena_reward_param.arena_official)
    local panel_grade = ccui.Helper:seekWidgetByName(root,"Panel_grade_".._ED.arena_info.arena_id)
    local Panel_role = ccui.Helper:seekWidgetByName(root,"Panel_role_".._ED.arena_info.arena_id)
    armature:setPosition(cc.p(panel_grade:getContentSize().width/2,Panel_role:getContentSize().height + 100))

    local function deleteEffectFile(armatureBack)
        if armatureBack.removeFromParent ~= nil then
            armatureBack:removeFromParent(true)
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_jingshengli_changtai/effice_jingshengli_changtai.ExportJson")
            self._effect_owner = ccs.Armature:create("effice_jingshengli_changtai")
            self._effect_owner:setPosition(cc.p(panel_grade:getContentSize().width/2,Panel_role:getContentSize().height + 100))
            panel_grade:addChild(self._effect_owner)   
            self._effect_owner:getAnimation():playWithIndex(0)
        end
    end
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    armature._invoke = deleteEffectFile
    panel_grade:addChild(armature) 
end

function Tourneyfield:close()

end

function Tourneyfield:onUpdateDraw()
    local root = self.roots[1]   
    local arena_id = _ED.arena_info.arena_id    --官阶
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")--名字
    local Text_level = ccui.Helper:seekWidgetByName(root,"Text_level")--等级
    local Text_salary_number_0 = ccui.Helper:seekWidgetByName(root,"Text_salary_number_0")--俸禄
    local Text_salary_number = ccui.Helper:seekWidgetByName(root,"Text_salary_number")--收益
    local Text_office_call = ccui.Helper:seekWidgetByName(root,"Text_office_call") -- 官职
    local Text_lasting_number = ccui.Helper:seekWidgetByName(root,"Text_lasting_number") -- 剩余次数

    --阵营背景
    local Panel_camp_bg = ccui.Helper:seekWidgetByName(root,"Panel_camp_bg")
    Panel_camp_bg:setBackGroundImage("images/ui/bg/shared_bg_".._ED.user_info.user_force..".png")
    
    local arena_official = dms.int(dms["arena_reward_param"],arena_id,arena_reward_param.arena_official)
    local arena_name = dms.string(dms["arena_reward_param"],arena_id,arena_reward_param.arena_name)
    local arena_salary = dms.string(dms["arena_reward_param"],arena_id,arena_reward_param.arena_salary)
    arena_name = zstring.split(arena_name,",")
    arena_name = arena_name[tonumber(_ED.user_info.user_force)]
    arena_salary = zstring.split(arena_salary,",")
    arena_salary = tonumber(arena_salary[3])
    local official = red_alert_officer[arena_official] .. arena_name
    local arena_salary = arena_salary -- 俸禄
    local now_hour_time = tonumber(os.date("%H",zstring.exchangeFrom(os.time())))
    local pass_hour = 0
    pass_hour = now_hour_time - 3 
    if pass_hour < 0 then
        pass_hour = 24 - pass_hour
    end
    local arena_get_all_salary = pass_hour*arena_salary--收益

    Text_name:setString(_ED.user_info.user_name)
    Text_level:setString(string.format(red_alert_all_str[13],_ED.user_info.user_grade))
    Text_salary_number_0:setString(string.format(red_alert_all_str[146],arena_salary))
    Text_salary_number:setString(arena_get_all_salary)
    Text_office_call:setString(official)
    local max_times = dms.int(dms["arena_config"],1,arena_config.param)
    Text_lasting_number:setString(_ED.arena_info.leave_attack_count.."/".. max_times)

    if self._effect_owner ~= nil and self._effect_owner.parent ~= nil then
        self._effect_owner:removeFromParent(true)
        self._effect_owner = nil
    end

    local ScrollView_grade = ccui.Helper:seekWidgetByName(root,"ScrollView_grade")
    if arena_id == 35 then      --33表示没有阶位
        return
    end
    for i,v in pairs(_ED.all_rank.my_info) do
		local function showCell()
			local Panel_role = ccui.Helper:seekWidgetByName(root,"Panel_role_"..v.user_arena_id) 
			Panel_role:removeAllChildren(true)
			local cell = state_machine.excute("tourneyfield_officer_top_create_cell",0,{v})
			Panel_role:addChild(cell)
		end
		if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
			local run_action2  = cc.Sequence:create(cc.DelayTime:create(0.01*i),cc.CallFunc:create(showCell))
			self:runAction(run_action2)
		else
			showCell()
		end
    end

    local arena_official = dms.int(dms["arena_reward_param"],_ED.arena_info.arena_id,arena_reward_param.arena_official)
    local panel_grade = ccui.Helper:seekWidgetByName(root,"Panel_grade_".._ED.arena_info.arena_id)
    local Panel_role = ccui.Helper:seekWidgetByName(root,"Panel_role_".._ED.arena_info.arena_id)
	local function onUpdateArmature()
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_jingshengli_light/effice_jingshengli_light.ExportJson")
		local armature = ccs.Armature:create("effice_jingshengli_light")
		armature:getAnimation():playWithIndex(0)
		armature:setPosition(cc.p(panel_grade:getContentSize().width/2,Panel_role:getContentSize().height + 100))
		local function deleteEffectFile(armatureBack)
			if armatureBack.removeFromParent ~= nil then
				armatureBack:removeFromParent(true)
				ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_jingshengli_changtai/effice_jingshengli_changtai.ExportJson")
				self._effect_owner = ccs.Armature:create("effice_jingshengli_changtai")
				self._effect_owner:setPosition(cc.p(panel_grade:getContentSize().width/2,Panel_role:getContentSize().height + 100))
				panel_grade:addChild(self._effect_owner)   
				self._effect_owner:getAnimation():playWithIndex(0)
			end
		end
		armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
		armature._invoke = deleteEffectFile
		panel_grade:addChild(armature)
		local pos_list = {-1850, -1850, -1800, -1560, -1300, -1000, -800, -600, -250, -100}
		local pos_y = pos_list[tonumber(arena_official)]
		self:scrollToPosition(0, pos_y)
	end
	if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
		local run_action  = cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(onUpdateArmature))
		self:runAction(run_action)
	else
		onUpdateArmature()
	end
end

function Tourneyfield:onUpdateDrawAttackCount()
    local root = self.roots[1]
    local Text_lasting_number = ccui.Helper:seekWidgetByName(root,"Text_lasting_number") -- 剩余次数
    local max_times = dms.int(dms["arena_config"],1,arena_config.param)
    Text_lasting_number:setString(_ED.arena_info.leave_attack_count .. "/".. max_times)
end

--初始化
function Tourneyfield:init(index)
    self._index = index
	self:onInit()
    return self
end

--移除状态机
function Tourneyfield:onExit()
    state_machine.remove("tourneyfield_buy_arena_launch_count")
    state_machine.remove("tourneyfield_play_head_effic")
    state_machine.remove("tourneyfield_update_draw")
end