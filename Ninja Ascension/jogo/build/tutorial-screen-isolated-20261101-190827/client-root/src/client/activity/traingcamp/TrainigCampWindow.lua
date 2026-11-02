--宝可梦训练营
TrainigCampWindow = class("TrainigCampWindowClass", Window)

local training_camp_window_open_terminal = {
	_name = "training_camp_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("TrainigCampWindowClass") == nil then
			fwin:open(TrainigCampWindow:new():init(params), fwin._view)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local training_camp_window_close_terminal = {
	_name = "training_camp_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TrainigCampWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(training_camp_window_open_terminal)
state_machine.add(training_camp_window_close_terminal)
state_machine.init()

function TrainigCampWindow:ctor()
	self.super:ctor()
	self.roots = {}
    self._idex = 1  --1表示奖励界面
    self.loaded = true
	app.load("client.activity.traingcamp.TrainigCampReward")
    app.load("client.activity.traingcamp.TrainigCampTask")
    app.load("client.activity.traingcamp.TrainigCampBuyLv")
    app.load("client.activity.traingcamp.TrainigCampRule")
    app.load("client.reward.DrawRareReward")
    app.load("client.l_digital.union.player.smTrainingCampUserTopinfo")
    local function init_training_camp_window_terminal()
        local training_camp_window_draw_terminal = {
            _name = "training_camp_window_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._idex = params._datas.idex
	            if instance ~= nil and instance.onUpdateDraw ~= nil then instance:onUpdateDraw() end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --奖励
        local training_camp_window_reward_terminal = {
            _name = "training_camp_window_reward",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function callBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if instance ~= nil and instance.onUpdateDraw ~= nil then instance:onUpdateDraw() end
                    end
                end
                NetworkManager:register(protocol_command.activity_pokemon_master_init.code, nil, nil, nil, instance, callBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --一键领取
        local training_camp_window_all_draw_terminal = {
            _name = "training_camp_window_all_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("training_camp_reward_all_draw", 0, nil)
                instance:onUpdateAllDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
       
        --刷新活动数据
        local training_camp_window_update_actinfo_terminal = {
            _name = "training_camp_window_update_actinfo",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateTopInfo()
                instance:onUpdateAllDraw()       
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
 
        state_machine.add(training_camp_window_draw_terminal)
        state_machine.add(training_camp_window_reward_terminal)
        state_machine.add(training_camp_window_all_draw_terminal)
        state_machine.add(training_camp_window_update_actinfo_terminal)
        state_machine.init()
    end
    init_training_camp_window_terminal()
end

function TrainigCampWindow:onUpdateDraw()
    self:onUpdateBt()
    state_machine.excute("training_camp_reward_hide_ui",0,{})
    state_machine.excute("training_camp_change_hide_ui",0,{})
    state_machine.excute("training_camp_task_hide_ui",0,{})

    local Panel_training_tab = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_training_tab")
  --  Panel_training_tab:removeAllChildren(true)
    ccui.Helper:seekWidgetByName(self.roots[1],"Panel_lv_box"):setVisible(true)
    
    if self._idex == 1 then
       self:onUpdateAllDraw()
       state_machine.excute("training_camp_reward_show_ui",0,{})
       state_machine.excute("training_camp_reward_open",0,{Panel_training_tab,self})
    elseif self._idex == 2 then
       ccui.Helper:seekWidgetByName(self.roots[1],"Panel_lv_box"):setVisible(false)
       ccui.Helper:seekWidgetByName(self.roots[1],"Button_1"):setVisible(false)
       state_machine.excute("training_camp_task_show_ui",0,{})
       state_machine.excute("training_camp_task_open",0,{Panel_training_tab})
    elseif self._idex == 3 then
       ccui.Helper:seekWidgetByName(self.roots[1],"Button_1"):setVisible(false)
       state_machine.excute("training_camp_change_show_ui",0,{})
       state_machine.excute("training_camp_change_open",0,{Panel_training_tab})
    end
end

function TrainigCampWindow:onUpdateAllDraw()
    local Button_1 = ccui.Helper:seekWidgetByName(self.roots[1],"Button_1")
    Button_1:setVisible(false)
    if self._idex ~= 1 then
        return
    end
    local info =  json.decode(_ED.active_activity[157].activity_params)
    if tonumber(info.userActivityInfo.level) == 0 then
        return 
    end
    for i=1,info.userActivityInfo.level do
        local temp_one = false 
        local temp_two = false
        for k,v in pairs(info.userActivityInfo.drawFreeLevel) do
            if tonumber(v) == i then
                temp_one = true
            end
        end

        if not temp_one and (#(_ED.training_camp_reward_info.freeReward[i]) ~= 0) then
            Button_1:setVisible(true)
            return
        end

        if info.userActivityInfo.buyMaster ~= 0 then
            for k,v in pairs(info.userActivityInfo.drawMasterLevel) do
                if tonumber(v) == i then
                    temp_two = true
                end
            end
            if not temp_two then
                Button_1:setVisible(true)
                return
            end
        end
    end
end

function TrainigCampWindow:onUpdateTopInfo( ... )
    local BitmapFontLabel_training_lv =  ccui.Helper:seekWidgetByName(self.roots[1],"BitmapFontLabel_training_lv")
    local Text_training_exp_n =  ccui.Helper:seekWidgetByName(self.roots[1],"Text_training_exp_n")
    local exp = dms.int(dms["activity_config"], 37, activity_config.param)
    local info = json.decode(_ED.active_activity[157].activity_params)
    BitmapFontLabel_training_lv:setString(info.userActivityInfo.level)

    local LoadingBar_training_exp =  ccui.Helper:seekWidgetByName(self.roots[1],"LoadingBar_training_exp")  --进度条
    LoadingBar_training_exp:setPercent(info.userActivityInfo.exp/exp*100)
    Text_training_exp_n:setString(tipStringInfo_training_camp_name[9]..info.userActivityInfo.exp.."/"..exp)
end

function TrainigCampWindow:onUpdateBt()
    local button_groups = 
    {
      ccui.Helper:seekWidgetByName(self.roots[1],"Button_training_reward"),
      ccui.Helper:seekWidgetByName(self.roots[1],"Button_training_task"),
      ccui.Helper:seekWidgetByName(self.roots[1],"Button_training_change"),
    }
    for i=1,3 do
        if i == self._idex then
            button_groups[i]:setHighlighted(true)
        else
            button_groups[i]:setHighlighted(false)
        end
    end
end

function TrainigCampWindow:onUpdate(dt)
  
end

function TrainigCampWindow:init(params)
	self:onInit()
    return self
end

function TrainigCampWindow:onInit()
   
end

function TrainigCampWindow:onEnterTransitionFinish()
  
    local csbItem = csb.createNode("activity/wonderful/training_camp.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    self:setVisible(false)
    state_machine.excute("training_camp_window_reward",0,nil)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_training_reward"), nil, --奖励
    {
        terminal_name = "training_camp_window_draw", 
        terminal_state = 0, 
        idex = 1,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_training"), nil,  --关闭
    {
        terminal_name = "training_camp_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_training_task"), nil, --任务
    {
        terminal_name = "training_camp_window_draw",
        terminal_state = 0,
        idex = 2,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_training_change"), nil, --兑换
    {
        terminal_name = "training_camp_window_draw",
        terminal_state = 0,
        idex = 3,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_training_get_exp"), nil, --获取经验
    {
        terminal_name = "training_camp_window_draw",
        terminal_state = 0,
        idex = 2,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_training_buy_lv"), nil, --购买等级
    {
        terminal_name = "training_camp_buy_lv_open",
        terminal_state = 0,
    },
    nil,1)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_1"), nil, --一键领取
    {
        terminal_name = "training_camp_window_all_draw",
        terminal_state = 0,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_training_rule"), nil, --规则
    {
        terminal_name = "training_camp_rule_open",
        terminal_state = 0,
    },
    nil,1)
   
    local userinfo = smTrainingCampUserTopinfo:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)

   self:onUpdateTopInfo()
   --self:onUpdateAllDraw()
end

function TrainigCampWindow:onExit()
    fwin:close(fwin:find("smTrainingCampUserTopinfoClass"))
    state_machine.remove("training_camp_window_draw")
    state_machine.remove("training_camp_window_reward")
    state_machine.remove("training_camp_window_all_draw")
    state_machine.remove("training_camp_window_update_actinfo")
end

