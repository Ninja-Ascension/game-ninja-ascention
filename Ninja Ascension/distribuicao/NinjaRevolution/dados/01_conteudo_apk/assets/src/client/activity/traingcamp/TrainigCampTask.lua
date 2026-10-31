--大师训练营任务界面
TrainigCampTask = class("TrainigCampTaskClass", Window)

local training_camp_task_open_terminal = {
	_name = "training_camp_task_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("TrainigCampTaskClass") == nil then
			fwin:open(TrainigCampTask:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local training_camp_task_close_terminal = {
	_name = "training_camp_task_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TrainigCampTaskClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(training_camp_task_open_terminal)
state_machine.add(training_camp_task_close_terminal)
state_machine.init()

function TrainigCampTask:ctor()
	self.super:ctor()
	self.roots = {}
    self._cells = {}
    app.load("client.cells.activity.training_camp_task_list_cell")
    app.load("client.utils.ConfirmTip")
    local function init_training_camp_task_exp_box_terminal()
        local training_camp_task_exp_box_terminal = {
            _name = "training_camp_task_exp_box",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local info = json.decode(_ED.active_activity[157].activity_params)
                local exp = dms.int(dms["activity_config"], 43, activity_config.param)
                if  tonumber(info.userActivityInfo.expBox)  == 0 then
                    if tonumber(info.userActivityInfo.buyMaster) == 0 then
                        TipDlg.drawTextDailog(tipStringInfo_training_camp_name[10]) 
                    else
                        local function callBack( response )
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                instance:updateBox()
                                local tip = ConfirmTip:new()
                                tip:init(instance, instance.onUpdateDraw,  string.format(tipStringInfo_training_camp_name[11],exp))
                                fwin:open(tip,fwin._windows)
                            end
                        end
                        NetworkManager:register(protocol_command.activity_pokemon_master_get_exp.code, nil, nil, nil, instance, callBack, false, nil)
                    end
                else
                    TipDlg.drawTextDailog(tipStringInfo_training_camp_name[12]) 
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

           --更新状态
        local training_camp_task_update_info_terminal = {
            _name = "training_camp_task_update_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local info = json.decode(_ED.active_activity[157].activity_params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         local training_camp_task_hide_ui_terminal = {
            _name = "training_camp_task_hide_ui",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local training_camp_task_show_ui_terminal = {
            _name = "training_camp_task_show_ui",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local training_camp_task_box_finish_terminal = {
            _name = "training_camp_task_box_finish",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                TipDlg.drawTextDailog(tipStringInfo_training_camp_name[12]) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(training_camp_task_exp_box_terminal)
        state_machine.add(training_camp_task_update_info_terminal)
        state_machine.add(training_camp_task_show_ui_terminal)
        state_machine.add(training_camp_task_hide_ui_terminal)
        state_machine.add(training_camp_task_box_finish_terminal)
        state_machine.init()
    end
    init_training_camp_task_exp_box_terminal()
end

function TrainigCampTask:onUpdateDraw()
    self._cells = {}
    local ListView_trainging_task = ccui.Helper:seekWidgetByName(self.roots[1],"ListView_trainging_task")
    ListView_trainging_task:removeAllItems()
    if  not _ED.active_activity[157] then
        return
    end

    local info = json.decode(_ED.active_activity[157].activity_params)
    
    local exps = dms.int(dms["activity_config"], 39, activity_config.param)
    local BitmapFontLabel_training_lv = ccui.Helper:seekWidgetByName(self.roots[1],"BitmapFontLabel_training_lv")
    BitmapFontLabel_training_lv:setString(info.userActivityInfo.level)

    local Text_traing_exp_n = ccui.Helper:seekWidgetByName(self.roots[1],"Text_traing_exp_n")
    Text_traing_exp_n:setString(info.userActivityInfo.dailyExp)
    
    local spacing = Text_traing_exp_n:getContentSize().width
    local txtpos = Text_traing_exp_n:getPositionX()
    local Text_traing_exp_all = ccui.Helper:seekWidgetByName(self.roots[1],"Text_traing_exp_all")
    Text_traing_exp_all:setString("/"..exps)
    Text_traing_exp_all:setPositionX(txtpos+spacing)
    
    local is_finsh = false
    if tonumber(info.userActivityInfo.dailyExp) >= exps then
       is_finsh = true
    end
  
    for i, v in pairs(info.taskInfo) do
        local cell = state_machine.excute("training_camp_task_list_cell_create",0,{v,is_finsh})
        table.insert(self._cells,cell)
        ListView_trainging_task:addChild(cell)
    end
    ListView_trainging_task:requestRefreshView()
end

function TrainigCampTask:updateBox()
    local info = json.decode(_ED.active_activity[157].activity_params)
    local Button_task_exp_box = ccui.Helper:seekWidgetByName(self.roots[1],"Button_task_exp_box")
    local Button_task_exp_box_k = ccui.Helper:seekWidgetByName(self.roots[1],"Button_task_exp_box_k")
    if tonumber(info.userActivityInfo.expBox) == 1 then
        Button_task_exp_box_k:setVisible(true)
        Button_task_exp_box:setVisible(false)
    else
        Button_task_exp_box_k:setVisible(false)
        Button_task_exp_box:setVisible(true)
    end
end

function TrainigCampTask:onUpdate(dt)
  
end

function TrainigCampTask:init(params)
    self._rootWindows = params[1]
	self:onInit()
    return self
end

function TrainigCampTask:onInit()
    local csbItem = csb.createNode("activity/wonderful/training_camp_task_tab.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    -- local action = csb.createTimeline("activity/wonderful/sm_vip_chouka.csb")
   	-- action:gotoFrameAndPlay(0, action:getDuration(), false)
    -- csbItem:runAction(action)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_task_exp_box"), nil,  --经验盒子
    {
        terminal_name = "training_camp_task_exp_box", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_task_exp_box_k"), nil,  --经验盒子
    {
        terminal_name = "training_camp_task_box_finish", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self:onUpdateDraw()
    self:updateBox()
end

function TrainigCampTask:onEnterTransitionFinish()
end

function TrainigCampTask:onExit()
    self._cells = {}
    state_machine.remove("training_camp_task_exp_box")
    state_machine.remove("training_camp_task_update_info")
    state_machine.remove("training_camp_task_hide_ui")
    state_machine.remove("training_camp_task_show_ui")
end

