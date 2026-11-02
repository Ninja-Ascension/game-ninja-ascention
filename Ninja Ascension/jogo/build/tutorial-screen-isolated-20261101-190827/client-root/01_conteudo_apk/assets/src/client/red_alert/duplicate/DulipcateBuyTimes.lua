-----------------------------
--说明:副本挑战次数
-----------------------------
DulipcateBuyTimes = class("DulipcateBuyTimesClass", Window)

--打开界面
local dulipcate_buy_times_window_open_terminal = {
    _name = "dulipcate_buy_times_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _DulipcateBuyTimesWindow = fwin:find("DulipcateBuyTimesClass")
        if nil == _DulipcateBuyTimesWindow then
            local npc_id = params[1]
            fwin:open(DulipcateBuyTimes:new():init(npc_id), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local dulipcate_buy_times_window_close_terminal = {
    _name = "dulipcate_buy_times_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("DulipcateBuyTimesClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(dulipcate_buy_times_window_open_terminal)
state_machine.add(dulipcate_buy_times_window_close_terminal)
state_machine.init()

function DulipcateBuyTimes:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    -- load lua file

    
    --var 
    --最大次数  
    self._max_times = nil        
    --已买次数
    self._now_times = nil     
    --购买次数
    self._select_times = nil   
    --需要宝石
    self._need_gem = nil      
    --格式化消耗宝石配置
    self._copy_config_str = {}
    --购买的次数npcid
    self._npc_id = nil

    -- Initialize dulipcate_buy_times state machine.
    local function init_dulipcate_buy_times_terminal()
	   --购买次数
       local dulipcate_buy_times_buy_sure_terminal = {
            _name = "dulipcate_buy_times_buy_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                --判断宝石是否足够
                if zstring.tonumber(instance._need_gem) > tonumber(_ED.user_info.user_gold) then
                    TipDlg.drawTextDailog(red_alert_all_str[79])
                    return
                end
                --判断是否还有剩余次数
                if instance._now_times >= instance._max_times then
                    TipDlg.drawTextDailog(red_alert_all_str[39])
                    return
                end

                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then    
                        state_machine.excute("dulipcate_buy_times_close",0,"")
                        state_machine.excute("duplicate_window_update_attack_times",0,"")
                    end
                end

                protocol_command.buy_copy_attack_times.param_list = instance._npc_id.."\r\n" .. instance._select_times
                NetworkManager:register(protocol_command.buy_copy_attack_times.code, nil, nil, nil,nil, responseCallback, false, nil)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --加一
        local buy_times_add_one_terminal = {
            _name = "buy_times_add_one",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._select_times >= instance._max_times - instance._now_times then
                    return
                end
                instance._select_times = instance._select_times + 1
                instance:setBuyNumberString()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --减一
        local buy_times_remove_one_terminal = {
            _name = "buy_times_remove_one",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._select_times == 1 then
                    return
                end
                instance._select_times = instance._select_times - 1
                instance:setBuyNumberString()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        --关闭界面
        local dulipcate_buy_times_close_terminal = {
            _name = "dulipcate_buy_times_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onWindowClose()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(dulipcate_buy_times_buy_sure_terminal)
        state_machine.add(buy_times_add_one_terminal)
        state_machine.add(buy_times_remove_one_terminal)
        state_machine.add(dulipcate_buy_times_close_terminal)
        state_machine.init()
    end
    
    -- call func init dulipcate_buy_times state machine.
    init_dulipcate_buy_times_terminal()
end

-- 设置当前购买需要的宝石
function DulipcateBuyTimes:setBuyNumberString()
    local root = self.roots[1]
    local Text_buy_power_number = ccui.Helper:seekWidgetByName(root,"Text_buy_power_number")    --购买次数
    Text_buy_power_number:setString(self._select_times)
    local Text_consume_power = ccui.Helper:seekWidgetByName(root,"Text_consume_power")          --需要的宝石数
    local Text_buy_power_4 = ccui.Helper:seekWidgetByName(root,"Text_buy_power_4")
    Text_buy_power_4:setVisible(false)
    local Panel_add_icon = ccui.Helper:seekWidgetByName(root,"Panel_add_icon")
    Panel_add_icon:setVisible(false)

    local will_need_gem = 0
    local add_times = 0

    for i,v in pairs(self._copy_config_str) do
        if add_times == self._select_times then
            break
        end
        if i > self._now_times then
            will_need_gem = self._copy_config_str[i] + will_need_gem
            add_times = add_times + 1            
        end
    end
    self._need_gem = will_need_gem
    Text_consume_power:setString(will_need_gem)
end

--设置购买次数
function DulipcateBuyTimes:canBuyNumberString()
    local root = self.roots[1]
    local Text_buy_power_time = ccui.Helper:seekWidgetByName(root,"Text_buy_power_time")  --今日已购买次数/剩余次数
    Text_buy_power_time:setString(self._now_times .. "/" ..  self._max_times)
end

--更新画面
function DulipcateBuyTimes:onUpdateDraw()
    local root = self.roots[1]
    local Text_buy_power_title = ccui.Helper:seekWidgetByName(root,"Text_buy_power_title") --标题
    -- Text_buy_power_title:setString(red_alert_all_str[125])
    local Text_buy_power_t = ccui.Helper:seekWidgetByName(root,"Text_buy_power_t")      --购买次数
    Text_buy_power_t:setString(red_alert_all_str[125])

end

-- 关闭购买界面
function DulipcateBuyTimes:onWindowClose()
    local root = self.roots[1]
    local action = self.actions[1]
    action:play("window_close", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_close_over" then
            state_machine.excute("dulipcate_buy_times_window_close", 0, "")
        end
    end)
end

--初始化界面
function DulipcateBuyTimes:onInit( )
    local csbItem = csb.createNode(config_csb.utils.buy_resource)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.utils.buy_resource)
    table.insert(self.actions, action)
    action:setTimeSpeed(app.getTimeSpeed())
    action:play("window_open", false)
    csbItem:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "window_open_over" then

        end  
    end)

    local Button_power_add = ccui.Helper:seekWidgetByName(root,"Button_power_add")      --加一按钮
    local Button_power_subtract = ccui.Helper:seekWidgetByName(root,"Button_power_subtract")    --减一按钮
    local Button_buy_power_close = ccui.Helper:seekWidgetByName(root,"Button_buy_power_close")  --关闭按钮
    local Button_buy_power = ccui.Helper:seekWidgetByName(root,"Button_buy_power")      --购买按钮

    -- 关闭
    fwin:addTouchEventListener(Button_buy_power_close, nil, 
    {
        terminal_name = "dulipcate_buy_times_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_buy_power_out") , nil, 
    {
        terminal_name = "dulipcate_buy_times_close", 
        terminal_state = 0, 
    }, nil, 0)

    -- 加一
    fwin:addTouchEventListener(Button_power_add, nil, 
    {
        terminal_name = "buy_times_add_one", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 减一
    fwin:addTouchEventListener(Button_power_subtract, nil, 
    {
        terminal_name = "buy_times_remove_one", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    
    
    --  购买次数
    fwin:addTouchEventListener(Button_buy_power, nil, 
    {
        terminal_name = "dulipcate_buy_times_buy_sure", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 
    self:initDatas()
    self:setBuyNumberString()
    self:canBuyNumberString()
    self:onUpdateDraw() 
end

--初始化部分数据
function DulipcateBuyTimes:initDatas()
    local max_times = dms.int(dms["base_consume"],74,base_consume.vip_0_value + tonumber(_ED.vip_grade))
    self._max_times = max_times
    self._now_times = zstring.tonumber(_ED.npc_current_buy_count[tonumber(self._npc_id)])
    self._select_times = 1
    self._need_gem = 0

    local copy_config_str = dms.string(dms["copy_config"],3,copy_config.param)
    copy_config_str = zstring.split(copy_config_str,",")
    self._copy_config_str = copy_config_str
end

--初始化
function DulipcateBuyTimes:init(npc_id)
    self._npc_id = npc_id
	self:onInit()
    return self
end

--退出
function DulipcateBuyTimes:onExit()
    state_machine.remove("dulipcate_buy_times_buy_sure")
    state_machine.remove("buy_times_add_one")
    state_machine.remove("buy_times_remove_one")
    state_machine.remove("dulipcate_buy_times_close")
end