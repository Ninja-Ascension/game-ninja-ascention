-- ----------------------------------------------------------------------------------------------------
-- 说明：世界坐标数字输入窗口
-------------------------------------------------------------------------------------------------------
WorldInputWindow = class("WorldInputWindowClass", Window)

--打开界面
local world_input_window_open_terminal = {
    _name = "world_input_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("WorldInputWindowClass") == nil then
            fwin:open(WorldInputWindow:new():init(params), fwin._ui)  
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local world_input_window_close_terminal = {
    _name = "world_input_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("WorldInputWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(world_input_window_open_terminal)
state_machine.add(world_input_window_close_terminal)
state_machine.init()
    
function WorldInputWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.coordinateType = 0         -- 0：选择X，1：选择Y
    self.enter_recording = ""
    self.old_enter_recording = ""
    self._max_number = 600

    self._coord_x = 1
    self._coord_y = 1
    self._text_coord_x = nil
    self._text_coord_y = nil

    app.load("client.red_alert_time.legion.LegionEstablish")
    app.load("client.red_alert_time.legion.LegionManage")
    app.load("client.red_alert_time.system.RedAlertTimeSystemDontDisturb")
    
    local function init_world_input_window_terminal()
        -- 输入
        local world_input_window_enter_terminal = {
            _name = "world_input_window_enter",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if zstring.tonumber(instance.enter_recording..params._datas.inputNumber) < 1 then
                    TipDlg.drawTextDailog(red_alert_time_str[162])
                    instance.enter_recording = 1
                    if zstring.tonumber(instance.coordinateType) == 0 then
                        instance._coord_x = tonumber(instance.enter_recording)
                        instance._text_coord_x:setString(""..instance._coord_x)
                    else
                        instance._coord_y = tonumber(instance.enter_recording)
                        instance._text_coord_y:setString(""..instance._coord_y)
                    end
                    return
                end
                if zstring.tonumber(instance.enter_recording..params._datas.inputNumber) > instance._max_number then
                    TipDlg.drawTextDailog(string.format(red_alert_time_str[93], ""..instance._max_number))
                    return
                end
                instance.enter_recording = instance.enter_recording..params._datas.inputNumber
                if zstring.tonumber(instance.coordinateType) == 0 then
                    instance._coord_x = tonumber(instance.enter_recording)
                    instance._text_coord_x:setString(""..instance._coord_x)
                elseif zstring.tonumber(instance.coordinateType) == 1 then  
                    instance._coord_y = tonumber(instance.enter_recording)
                    instance._text_coord_y:setString(""..instance._coord_y)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 删除
        local world_input_window_enter_delete_terminal = {
            _name = "world_input_window_enter_delete",
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
                        instance._coord_x = 1
                        instance._text_coord_x:setString(""..instance._coord_x)
                    elseif zstring.tonumber(instance.coordinateType) == 1 then  
                        instance._coord_y = 1
                        instance._text_coord_y:setString(""..instance._coord_y)
                    end
                else
                    if zstring.tonumber(instance.coordinateType) == 0 then
                        instance._coord_x = tonumber(instance.enter_recording)
                        instance._text_coord_x:setString(""..instance._coord_x)
                    elseif zstring.tonumber(instance.coordinateType) == 1 then  
                        instance._coord_y = tonumber(instance.enter_recording)
                        instance._text_coord_y:setString(""..instance._coord_y)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local world_input_window_change_coordinate_type_terminal = {
            _name = "world_input_window_change_coordinate_type",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.coordinateType = params._datas.coordinateType
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local world_input_window_search_for_coordinate_terminal = {
            _name = "world_input_window_search_for_coordinate",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("red_alert_time_mine_input_digital_coordinate_update", 0, {instance._coord_x, instance._coord_y})
                state_machine.excute("red_alert_time_mine_search_for_coordinate", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
         
        state_machine.add(world_input_window_enter_terminal)
        state_machine.add(world_input_window_enter_delete_terminal)
        state_machine.add(world_input_window_change_coordinate_type_terminal)
        state_machine.add(world_input_window_search_for_coordinate_terminal)
        state_machine.init()
    end

    init_world_input_window_terminal()
end

function WorldInputWindow:onUpdateDraw()
    local root = self.roots[1]
    local Image_xy_hook_x = ccui.Helper:seekWidgetByName(root, "Image_xy_hook_x")
    local Image_xy_hook_y = ccui.Helper:seekWidgetByName(root, "Image_xy_hook_y")
    if self.coordinateType == 0 then
        Image_xy_hook_x:setVisible(true)
        Image_xy_hook_y:setVisible(false)
    else
        Image_xy_hook_x:setVisible(false)
        Image_xy_hook_y:setVisible(true)
    end
    self.enter_recording = ""

    local Text_num_x = ccui.Helper:seekWidgetByName(root, "Text_num_x")
    local Text_num_y = ccui.Helper:seekWidgetByName(root, "Text_num_y")
    Text_num_x:setString(""..self._coord_x)
    Text_num_y:setString(""..self._coord_y)
    self._text_coord_x = Text_num_x
    self._text_coord_y = Text_num_y
end

function WorldInputWindow:init(params)
    self.coordinateType = params[1]   
    self._coord_x = params[2]  
    self._coord_y = params[3]  
    self:onInit()
    return self
end

function WorldInputWindow:onInit()
    local csbWorldInputWindow =  csb.createNode(config_csb.world_map.world_input_window)
    local action = csb.createTimeline(config_csb.world_map.world_input_window)
    local root = csbWorldInputWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbWorldInputWindow)
    self:setContentSize(root:getContentSize())
    table.insert(self.actions, action)
    csbWorldInputWindow:runAction(action)
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
            terminal_name = "world_input_window_enter",
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
        terminal_name = "world_input_window_enter_delete",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_num_11"), nil, 
    {
        terminal_name = "world_input_window_search_for_coordinate",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "world_input_window_close",
        terminal_state = 0,
    },
    nil,1)

    --X坐标
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_xy_y_bg"), nil, 
    {
        terminal_name = "world_input_window_change_coordinate_type",
        terminal_state = 0,
        coordinateType = 0,
    },
    nil,1)
    --Y坐标
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_xy_x_bg"), nil, 
    {
        terminal_name = "world_input_window_change_coordinate_type",
        terminal_state = 0,
        coordinateType = 1,
    },
    nil,1)

    self:onUpdateDraw()
end

function WorldInputWindow:onExit()
    state_machine.remove("world_input_window_enter")
    state_machine.remove("world_input_window_enter_delete")
    state_machine.remove("world_input_window_change_coordinate_type")
    state_machine.remove("world_input_window_search_for_coordinate")
end
