-- ----------------------------------------------------------------------------------------------------
-- 说明：数字输入窗口
-------------------------------------------------------------------------------------------------------
InputDigitalWindow = class("InputDigitalWindowClass", Window)
    
function InputDigitalWindow:ctor()
    self.super:ctor()
    self.roots = {}
	self.actions = {}
	self.coordinateType = 0
	self.enter_recording = ""
	self.old_enter_recording = ""

    app.load("client.red_alert_time.legion.LegionEstablish")
    app.load("client.red_alert_time.legion.LegionManage")
    app.load("client.red_alert_time.system.RedAlertTimeSystemDontDisturb")
	
    local function init_input_digital_window_terminal()
        -- 输入
        local input_digital_window_enter_terminal = {
            _name = "input_digital_window_enter",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if zstring.tonumber(instance.enter_recording..params._datas.inputNumber) < 1 then
					if zstring.tonumber(instance.coordinateType) == 0 then
                        TipDlg.drawTextDailog(red_alert_time_str[162])
						state_machine.excute("red_alert_time_mine_input_digital_coordinate_update", 0, {1,nil})
                        return
					elseif zstring.tonumber(instance.coordinateType) == 1 then 	
                        TipDlg.drawTextDailog(red_alert_time_str[162])
						state_machine.excute("red_alert_time_mine_input_digital_coordinate_update", 0, {nil,1})
                        return
                    elseif zstring.tonumber(instance.coordinateType) == 6 then  
                        TipDlg.drawTextDailog(red_alert_time_str[162])
                        return
                    elseif zstring.tonumber(instance.coordinateType) == 7 then  
                        TipDlg.drawTextDailog(red_alert_time_str[163])
                        return
					end
				end
				if zstring.tonumber(instance.coordinateType) == 0 or zstring.tonumber(instance.coordinateType) == 1 then
                    if zstring.tonumber(instance.enter_recording..params._datas.inputNumber) > 600 then
					   TipDlg.drawTextDailog(string.format(red_alert_time_str[93], ""..600))
					-- if zstring.tonumber(instance.coordinateType) == 0 then
						-- state_machine.excute("red_alert_time_mine_input_digital_coordinate_update", 0, {600,nil})
					-- elseif zstring.tonumber(instance.coordinateType) == 1 then 	
						-- state_machine.excute("red_alert_time_mine_input_digital_coordinate_update", 0, {nil,600})
					-- end
					   return
                    end
                elseif zstring.tonumber(instance.coordinateType) == 2 or zstring.tonumber(instance.coordinateType) == 4 then
                    if zstring.tonumber(instance.enter_recording..params._datas.inputNumber) > 60 then
                        TipDlg.drawTextDailog(string.format(red_alert_time_str[93], ""..60))
                        return
                    end
                elseif zstring.tonumber(instance.coordinateType) == 3 or zstring.tonumber(instance.coordinateType) == 5 then
                    local max_number = dms.int(dms["union_config"], 59, union_config.param)
                    if zstring.tonumber(instance.enter_recording..params._datas.inputNumber) > max_number then
                        TipDlg.drawTextDailog(string.format(red_alert_time_str[93], ""..max_number))
                        return
                    end
                elseif zstring.tonumber(instance.coordinateType) == 6 then
                    if zstring.tonumber(instance.enter_recording..params._datas.inputNumber) > zstring.tonumber(instance._max_number) then
                        TipDlg.drawTextDailog(string.format(red_alert_time_str[161], ""..zstring.tonumber(instance._max_number)))
                        return
                    end
                elseif zstring.tonumber(instance.coordinateType) == 7 then
                    if zstring.tonumber(instance.enter_recording..params._datas.inputNumber) > zstring.tonumber(instance._max_number) then
                        TipDlg.drawTextDailog(string.format(red_alert_time_str[161], ""..zstring.tonumber(instance._max_number)))
                        return
                    end
                elseif zstring.tonumber(instance.coordinateType) == 8 or zstring.tonumber(instance.coordinateType) == 9 then
                    if zstring.tonumber(instance.enter_recording..params._datas.inputNumber) > 24 then
                        TipDlg.drawTextDailog(string.format(red_alert_time_str[93], ""..24))
                        return
                    end
                end
				instance.enter_recording = instance.enter_recording..params._datas.inputNumber
				if zstring.tonumber(instance.coordinateType) == 0 then
					state_machine.excute("red_alert_time_mine_input_digital_coordinate_update", 0, {zstring.tonumber(instance.enter_recording),nil})
				elseif zstring.tonumber(instance.coordinateType) == 1 then 	
					state_machine.excute("red_alert_time_mine_input_digital_coordinate_update", 0, {nil,zstring.tonumber(instance.enter_recording)})
                elseif zstring.tonumber(instance.coordinateType) == 2 then  
                    state_machine.excute("legion_establish_update_add_condition", 0, {zstring.tonumber(instance.enter_recording),nil})
                elseif zstring.tonumber(instance.coordinateType) == 3 then  
                    state_machine.excute("legion_establish_update_add_condition", 0, {nil,zstring.tonumber(instance.enter_recording)})
                elseif zstring.tonumber(instance.coordinateType) == 4 then  
                    state_machine.excute("legion_manage_update_add_condition", 0, {zstring.tonumber(instance.enter_recording),nil})
                elseif zstring.tonumber(instance.coordinateType) == 5 then  
                    state_machine.excute("legion_manage_update_add_condition", 0, {nil,zstring.tonumber(instance.enter_recording)})
                elseif zstring.tonumber(instance.coordinateType) == 6 then  
                    state_machine.excute("legion_welfare_window_update_condition", 0, {zstring.tonumber(instance.enter_recording)})
                elseif zstring.tonumber(instance.coordinateType) == 7 then  
                    state_machine.excute("formation_choose_troop_update_select_number", 0, {zstring.tonumber(instance.enter_recording)})
                elseif zstring.tonumber(instance.coordinateType) == 8 then  
                    state_machine.excute("red_alert_time_system_dont_disturb_update_condition", 0, {zstring.tonumber(instance.enter_recording),nil})
                elseif zstring.tonumber(instance.coordinateType) == 9 then  
                    state_machine.excute("red_alert_time_system_dont_disturb_update_condition", 0, {nil,zstring.tonumber(instance.enter_recording)})
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 删除
        local input_digital_window_enter_delete_terminal = {
            _name = "input_digital_window_enter_delete",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				function getIntPart(x)
					if x<= 0 then
						return math.ceil(x)
					end
					if math.ceil(x) == x then
						x = math.ceil(x)
					else
						x = math.ceil(x)-1
					end


					return x
				end
				if instance.enter_recording == "" or zstring.tonumber(instance.enter_recording) /10 <1 then
					instance.enter_recording = ""
				else
					instance.enter_recording = getIntPart(instance.enter_recording/10)
				end
				if instance.enter_recording == "" then
					if zstring.tonumber(instance.coordinateType) == 0 then
						state_machine.excute("red_alert_time_mine_input_digital_coordinate_update", 0, {1,nil})
					elseif zstring.tonumber(instance.coordinateType) == 1 then 	
						state_machine.excute("red_alert_time_mine_input_digital_coordinate_update", 0, {nil,1})
                    elseif zstring.tonumber(instance.coordinateType) == 2 then  
                        state_machine.excute("legion_establish_update_add_condition", 0, {0,nil})
                    elseif zstring.tonumber(instance.coordinateType) == 3 then  
                        state_machine.excute("legion_establish_update_add_condition", 0, {nil,0})
                    elseif zstring.tonumber(instance.coordinateType) == 4 then  
                        state_machine.excute("legion_manage_update_add_condition", 0, {0,nil})
                    elseif zstring.tonumber(instance.coordinateType) == 5 then  
                        state_machine.excute("legion_manage_update_add_condition", 0, {nil,0})
                    elseif zstring.tonumber(instance.coordinateType) == 6 then  
                        state_machine.excute("legion_welfare_window_update_condition", 0, {0})
                    elseif zstring.tonumber(instance.coordinateType) == 7 then  
                        TipDlg.drawTextDailog(red_alert_time_str[163])
                    elseif zstring.tonumber(instance.coordinateType) == 8 then  
                        state_machine.excute("red_alert_time_system_dont_disturb_update_condition", 0, {0,nil})
                    elseif zstring.tonumber(instance.coordinateType) == 9 then  
                        state_machine.excute("red_alert_time_system_dont_disturb_update_condition", 0, {nil,0})
					end
				else
					if zstring.tonumber(instance.coordinateType) == 0 then
						state_machine.excute("red_alert_time_mine_input_digital_coordinate_update", 0, {zstring.tonumber(instance.enter_recording),nil})
					elseif zstring.tonumber(instance.coordinateType) == 1 then 	
						state_machine.excute("red_alert_time_mine_input_digital_coordinate_update", 0, {nil,zstring.tonumber(instance.enter_recording)})
                    elseif zstring.tonumber(instance.coordinateType) == 2 then  
                        state_machine.excute("legion_establish_update_add_condition", 0, {zstring.tonumber(instance.enter_recording),nil})
                    elseif zstring.tonumber(instance.coordinateType) == 3 then  
                        state_machine.excute("legion_establish_update_add_condition", 0, {nil,zstring.tonumber(instance.enter_recording)})
                    elseif zstring.tonumber(instance.coordinateType) == 4 then  
                        state_machine.excute("legion_manage_update_add_condition", 0, {zstring.tonumber(instance.enter_recording),nil})
                    elseif zstring.tonumber(instance.coordinateType) == 5 then  
                        state_machine.excute("legion_manage_update_add_condition", 0, {nil,zstring.tonumber(instance.enter_recording)})
                    elseif zstring.tonumber(instance.coordinateType) == 6 then  
                        state_machine.excute("legion_welfare_window_update_condition", 0, {zstring.tonumber(instance.enter_recording)})
                    elseif zstring.tonumber(instance.coordinateType) == 7 then  
                        state_machine.excute("formation_choose_troop_update_select_number", 0, {zstring.tonumber(instance.enter_recording)})
                    elseif zstring.tonumber(instance.coordinateType) == 8 then  
                        state_machine.excute("red_alert_time_system_dont_disturb_update_condition", 0, {zstring.tonumber(instance.enter_recording),nil})
                    elseif zstring.tonumber(instance.coordinateType) == 9 then  
                        state_machine.excute("red_alert_time_system_dont_disturb_update_condition", 0, {nil,zstring.tonumber(instance.enter_recording)})
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭
        local input_digital_window_close_terminal = {
            _name = "input_digital_window_close",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if zstring.tonumber(instance.coordinateType) == 0 then
                    state_machine.excute("red_alert_time_mine_close_input_digital", 0, "")
                elseif zstring.tonumber(instance.coordinateType) == 1 then  
                    state_machine.excute("red_alert_time_mine_close_input_digital", 0, "")
                elseif zstring.tonumber(instance.coordinateType) == 2 then  
                    state_machine.excute("legion_establish_close_input_digital", 0, "")
                elseif zstring.tonumber(instance.coordinateType) == 3 then  
                    state_machine.excute("legion_establish_close_input_digital", 0, "")
                elseif zstring.tonumber(instance.coordinateType) == 4 then  
                    state_machine.excute("legion_manage_close_input_digital", 0, "")
                elseif zstring.tonumber(instance.coordinateType) == 5 then  
                    state_machine.excute("legion_manage_close_input_digital", 0, "")
                elseif zstring.tonumber(instance.coordinateType) == 6 then  
                    state_machine.excute("legion_welfare_window_close_input_digital", 0, "")
                elseif zstring.tonumber(instance.coordinateType) == 7 then  
                    state_machine.excute("formation_choose_troop_close_input_digital", 0, "")
                elseif zstring.tonumber(instance.coordinateType) == 8 then  
                    state_machine.excute("red_alert_time_system_dont_disturb_close_input_digital", 0, "")
                elseif zstring.tonumber(instance.coordinateType) == 9 then  
                    state_machine.excute("red_alert_time_system_dont_disturb_close_input_digital", 0, "")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
         
        state_machine.add(input_digital_window_enter_terminal)
        state_machine.add(input_digital_window_enter_delete_terminal)
        state_machine.add(input_digital_window_close_terminal)
        state_machine.init()
    end

    init_input_digital_window_terminal()
end

function InputDigitalWindow:init(coordinateType, max_number)
	self.coordinateType = coordinateType       -- 0，1:世界地图坐标，2，3:创建军团等级、战力要求，4,5：军团管理等级。战力要求,6：军团福利分配
                                               -- 7：阵型上阵数量 ， 8、9：游戏免打扰
    self._max_number = max_number
    self:onInit()
    return self
end

function InputDigitalWindow:onInit()
    local csbInputDigitalWindow = nil
    local action = nil
    if self.coordinateType == 0 or self.coordinateType == 1 
        or self.coordinateType == 6
        or self.coordinateType == 8
        then
        csbInputDigitalWindow = csb.createNode(config_csb.digitalinput.window)
        action = csb.createTimeline(config_csb.digitalinput.window)
    elseif self.coordinateType == 2 or self.coordinateType == 3 
        or self.coordinateType == 4 or self.coordinateType == 5 
        or self.coordinateType == 7 
        or self.coordinateType == 9
        then  
        csbInputDigitalWindow = csb.createNode(config_csb.digitalinput.window_1)
        action = csb.createTimeline(config_csb.digitalinput.window_1)
    end
    local root = csbInputDigitalWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbInputDigitalWindow)
	self:setContentSize(root:getContentSize())
	table.insert(self.actions, action)
	csbInputDigitalWindow:runAction(action)
	self.actions[1]:play("window_open", false)
    self.actions[1]:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
        elseif str == "window_open_over" then
			--打开结束
        end
        
    end)
	
	for i=0,9 do
		 fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_num_"..i), nil, 
		{
			terminal_name = "input_digital_window_enter",
			terminal_state = 0,
			inputNumber = i,
			touch_scale = true,
			touch_scale_xy = 0.95,
			touch_black = true,
		},
		nil,1)
	end
	--删除
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_num_10"), nil, 
    {
        terminal_name = "input_digital_window_enter_delete",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_num_11"), nil, 
    {
        terminal_name = "input_digital_window_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
end

function InputDigitalWindow:onExit()
	state_machine.remove("input_digital_window_enter")
    state_machine.remove("input_digital_window_enter_delete")
    state_machine.remove("input_digital_window_close")
end

function InputDigitalWindow:createCell()
	local cell = InputDigitalWindow:new()
	cell:registerOnNodeEvent(cell)
	return cell
end