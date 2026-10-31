-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏免打扰设置
-------------------------------------------------------------------------------------------------------
RedAlertTimeSystemDontDisturb = class("RedAlertTimeSystemDontDisturbClass", Window)

local red_alert_time_system_dont_disturb_open_terminal = {
    _name = "red_alert_time_system_dont_disturb_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("RedAlertTimeSystemDontDisturbClass")
        if nil == _homeWindow then
    		fwin:open(RedAlertTimeSystemDontDisturb:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_system_dont_disturb_close_terminal = {
    _name = "red_alert_time_system_dont_disturb_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("RedAlertTimeSystemDontDisturbClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("RedAlertTimeSystemDontDisturbClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_system_dont_disturb_open_terminal)
state_machine.add(red_alert_time_system_dont_disturb_close_terminal)
state_machine.init()
    
function RedAlertTimeSystemDontDisturb:ctor()
    self.super:ctor()
    self.roots = {}
    self.Panel_num_input = nil
    -- 起始时间
    self._begin_time = 0
    -- 结束时间
    self._over_time = 0

    self.dont_disturb_state = 0

    app.load("client.red_alert_time.cells.player.input_digital_window")
	local function init_red_alert_time_system_dont_disturb_terminal()
		
        -- 开启关闭
        local red_alert_time_system_dont_disturb_state_terminal = {
            _name = "red_alert_time_system_dont_disturb_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("red_alert_time_system_dont_disturb_close_input_digital", 0, 0)
                if tonumber(instance.dont_disturb_state) == 1 then
                    cc.UserDefault:getInstance():setStringForKey("dont_disturb_state","0")
                    instance.team_up_state = "0"
                else
                    cc.UserDefault:getInstance():setStringForKey("dont_disturb_state","1")
                    instance.team_up_state = "1"
                end
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--坐标输入
        local red_alert_time_system_dont_disturb_open_input_digital_terminal = {
            _name = "red_alert_time_system_dont_disturb_open_input_digital",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("red_alert_time_system_dont_disturb_close_input_digital", 0, 0)
                local cell = InputDigitalWindow:createCell()
                cell:init(params._datas.coordinate_type)
                instance.Panel_num_input:addChild(cell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --清除坐标界面
        local red_alert_time_system_dont_disturb_close_input_digital_terminal = {
            _name = "red_alert_time_system_dont_disturb_close_input_digital",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.Panel_num_input:removeAllChildren(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新等级和战力需求
        local red_alert_time_system_dont_disturb_update_condition_terminal = {
            _name = "red_alert_time_system_dont_disturb_update_condition",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateCoordinate(params[1],params[2])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭界面
        local red_alert_time_system_dont_disturb_window_close_terminal = {
            _name = "red_alert_time_system_dont_disturb_window_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("red_alert_time_system_dont_disturb_close_input_digital", 0, 0)
                if tonumber(instance._begin_time) == tonumber(instance._over_time) then
                    TipDlg.drawTextDailog(_app_system_text[7])
                    return
                end
                state_machine.excute("red_alert_time_system_dont_disturb_close", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(red_alert_time_system_dont_disturb_state_terminal)
        state_machine.add(red_alert_time_system_dont_disturb_open_input_digital_terminal)
        state_machine.add(red_alert_time_system_dont_disturb_close_input_digital_terminal)
	    state_machine.add(red_alert_time_system_dont_disturb_update_condition_terminal)
        state_machine.add(red_alert_time_system_dont_disturb_window_close_terminal)
		state_machine.init()
	end
	
	init_red_alert_time_system_dont_disturb_terminal()
end

function RedAlertTimeSystemDontDisturb:init()
    self:onInit()
    return self
end
function RedAlertTimeSystemDontDisturb:updateCoordinate(coordinate_1,coordinate_2)
    local root = self.roots[1]
    local Text_input_time_1 = ccui.Helper:seekWidgetByName(root, "Text_input_time_1")
    local Text_input_time_2 = ccui.Helper:seekWidgetByName(root, "Text_input_time_2")
    local Text_dont_disturb_time_1 = ccui.Helper:seekWidgetByName(root, "Text_dont_disturb_time_1")
    
    if coordinate_1 == nil then
        Text_input_time_1:setString(self._begin_time)
    else
        Text_input_time_1:setString(coordinate_1)
        self._begin_time = coordinate_1
    end
    
    if coordinate_2 == nil then
        Text_input_time_2:setString(self._over_time)
    else
        Text_input_time_2:setString(coordinate_2)
        self._over_time = coordinate_2
    end
    Text_dont_disturb_time_1:setString(string.format(_app_system_text[5],self._begin_time,self._over_time))

    local str = self._begin_time..","..self._over_time
    cc.UserDefault:getInstance():setStringForKey("dont_disturb_time",str)
    state_machine.excute("red_alert_time_system_change_dont_disturb_time", 0, {self._begin_time,self._over_time})
end

function RedAlertTimeSystemDontDisturb:onUpdateDraw()
	local root = self.roots[1]
    local Image_input_1 = ccui.Helper:seekWidgetByName(root, "Image_input_1")
    local Image_input_2 = ccui.Helper:seekWidgetByName(root, "Image_input_2")
    local Text_input_time_1 = ccui.Helper:seekWidgetByName(root, "Text_input_time_1")
    local Text_input_time_2 = ccui.Helper:seekWidgetByName(root, "Text_input_time_2")
    local Text_dont_disturb_time_1 = ccui.Helper:seekWidgetByName(root, "Text_dont_disturb_time_1")
    local Text_dont_disturb_state = ccui.Helper:seekWidgetByName(root, "Text_dont_disturb_state")
    local Button_dont_disturb = ccui.Helper:seekWidgetByName(root, "Button_dont_disturb")
    for i=1,5 do
        local Text_dont_disturb_time = ccui.Helper:seekWidgetByName(root, "Text_dont_disturb_time_"..i)
        Text_dont_disturb_time:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    end
    Text_input_time_1:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    Text_input_time_2:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    Image_input_1:setTouchEnabled(true)
    Image_input_2:setTouchEnabled(true)
    self.dont_disturb_state = cc.UserDefault:getInstance():getStringForKey("dont_disturb_state")
    local dont_disturb_time = cc.UserDefault:getInstance():getStringForKey("dont_disturb_time")
    dont_disturb_time = zstring.split(dont_disturb_time,",")
    self._begin_time = tonumber(dont_disturb_time[1])
    self._over_time = tonumber(dont_disturb_time[2])

    if tonumber(self.dont_disturb_state) == 1 then
        Button_dont_disturb:setHighlighted(true)
        Button_dont_disturb:setTitleText(_app_system_text[2]) 
        Text_dont_disturb_state:setString(_app_system_text[3])
        Text_dont_disturb_state:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
    else
        Button_dont_disturb:setHighlighted(false)
        Button_dont_disturb:setTitleText(_app_system_text[1]) 
        Text_dont_disturb_state:setString(_app_system_text[4])
        Text_dont_disturb_state:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
        Image_input_1:setTouchEnabled(false)
        Image_input_2:setTouchEnabled(false)
        Text_input_time_1:setColor(cc.c3b(color_Type[11][1], color_Type[11][2], color_Type[11][3]))
        Text_input_time_2:setColor(cc.c3b(color_Type[11][1], color_Type[11][2], color_Type[11][3]))
        for i=1,5 do
            local Text_dont_disturb_time = ccui.Helper:seekWidgetByName(root, "Text_dont_disturb_time_"..i)
            Text_dont_disturb_time:setColor(cc.c3b(color_Type[11][1], color_Type[11][2], color_Type[11][3]))
        end
    end

    Text_input_time_1:setString(self._begin_time)
    Text_input_time_2:setString(self._over_time)
    Text_dont_disturb_time_1:setString(string.format(_app_system_text[5],self._begin_time,self._over_time))
end

function RedAlertTimeSystemDontDisturb:onInit()
    local csbRedAlertTimeSystemDontDisturb = csb.createNode(config_csb.system.set_up_dont_disturb)
    local root = csbRedAlertTimeSystemDontDisturb:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbRedAlertTimeSystemDontDisturb)

	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_dont_disturb_close"), nil, 
    {
        terminal_name = "red_alert_time_system_dont_disturb_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_system_dont_disturb_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    -- 开启关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_dont_disturb"), nil, 
    {
        terminal_name = "red_alert_time_system_dont_disturb_state", 
        terminal_state = 0,
        coordinate_type = 8,
        touch_black = true,
    }, 
     nil, 1)
	
	-- 起始时间
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_input_1"), nil, 
    {
        terminal_name = "red_alert_time_system_dont_disturb_open_input_digital", 
        terminal_state = 0,
        coordinate_type = 8,
        touch_black = true,
    }, 
     nil, 1)
     
    -- 结束时间
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_input_2"), nil, 
    {
        terminal_name = "red_alert_time_system_dont_disturb_open_input_digital", 
        terminal_state = 0,
        coordinate_type = 9,
        touch_black = true,
    }, 
     nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_box"), nil, 
    {
        terminal_name = "red_alert_time_system_dont_disturb_close_input_digital", 
        terminal_state = 0,
    }, 
     nil, 1)

    local Panel_num_input = ccui.Helper:seekWidgetByName(root, "Panel_num_input")
    self.Panel_num_input = Panel_num_input

	self:onUpdateDraw()
end

function RedAlertTimeSystemDontDisturb:onExit()
	state_machine.remove("red_alert_time_system_dont_disturb_open_input_digital")
    state_machine.remove("red_alert_time_system_dont_disturb_close_input_digital")
    state_machine.remove("red_alert_time_system_dont_disturb_update_condition")
    state_machine.remove("red_alert_time_system_dont_disturb_window_close")
end