--------------------------------------------------------------------------------------------------------------
--  说明：折扣卖场抢折扣券界面
--------------------------------------------------------------------------------------------------------------
RedAlertTimeDiscountStoreTicket = class("RedAlertTimeDiscountStoreTicketClass", Window)
RedAlertTimeDiscountStoreTicket.__size = nil
--打开界面
local red_alert_time_discount_store_ticket_open_terminal = {
	_name = "red_alert_time_discount_store_ticket_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
    	local cell = RedAlertTimeDiscountStoreTicket:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(red_alert_time_discount_store_ticket_open_terminal)
state_machine.init()

function RedAlertTimeDiscountStoreTicket:ctor()
	self.super:ctor()
	self.roots = {}
    self._state = 0
    self._activity_type = nil
    self.m_reset_times_2 = 0
    self.text_reset_times = nil
	
    local function init_red_alert_time_discount_store_ticket_terminal()
        --抢折扣卷
        local red_alert_time_discount_store_ticket_explore_terminal = {
            _name = "red_alert_time_discount_store_ticket_explore",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas._cell
                local activity = _ED.activity_info["103"]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        activity = _ED.activity_info["103"]
                        local activity_add_state = zstring.split(activity.activity_add_state,",")
                        local str = ""
                        if tonumber(activity_add_state[4]) < 1 then
                            local curr_discount = tonumber(activity_add_state[4]) * 10
                            if verifySupportLanguage(_lua_release_language_en) == true then
                                curr_discount = (10 - curr_discount) * 10
                            end
                            str = string.format(activity_str_tip[143] , curr_discount)
                        else
                            str = string.format(activity_str_tip[144] , tonumber(activity_add_state[5]))
                        end
                        str = activity_str_tip[142]..str
                        TipDlg.drawTextDailog(str)
                        state_machine.excute("red_alert_time_discount_store_transfer_change_page",0,2)
                    end
                end     
                protocol_command.draw_activity_reward.param_list = activity.activity_id .. "\r\n"..activity.activity_type.."\r\n".."1".."\r\n".."0".."\r\n".."1"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --刷新显示
        local red_alert_time_discount_store_ticket_update_terminal = {
            _name = "red_alert_time_discount_store_ticket_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                self._state = params
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_discount_store_ticket_update_terminal)
        state_machine.add(red_alert_time_discount_store_ticket_explore_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_discount_store_ticket_terminal()
end

function RedAlertTimeDiscountStoreTicket:updateDraw()
    local root = self.roots[1]
	--信息
    self._activity_type = _ED.activity_info[""..self._activity_type.activity_type]
    local activity_add_state_arry = zstring.split(self._activity_type.activity_add_state,"|")
    local activity_add_state = zstring.split(activity_add_state_arry[1],",")
    local time_info = zstring.split(activity_add_state_arry[2],",")
    local bug_goods_time = tonumber(time_info[4]) -- 购买时间
    local wait_time = tonumber(time_info[5]) -- 等待时间
    local reset_times = ((tonumber(_ED.treasure_discount_store_info[1].reset_times)/1000)-(os.time()-_ED.treasure_discount_store_info[1].time))
    local Button_discount_rob = ccui.Helper:seekWidgetByName(root, "Button_discount_rob")
    local Text_discount_rob_t_time = ccui.Helper:seekWidgetByName(root, "Text_discount_rob_t_time")
    if self._state == 3 then -- 等待时间
        Button_discount_rob:setBright(false)
        Button_discount_rob:setTouchEnabled(false)
        self.m_reset_times_2 = reset_times
        Text_discount_rob_t_time:setString(activity_str_tip[146])
    else
        Button_discount_rob:setBright(true)
        Button_discount_rob:setTouchEnabled(true)
        self.m_reset_times_2 = reset_times - (bug_goods_time + wait_time) * 60
        Text_discount_rob_t_time:setString(activity_str_tip[145])
    end
    local Text_discount_rob_t_time_n = ccui.Helper:seekWidgetByName(root, "Text_discount_rob_t_time_n")
    self.text_reset_times = Text_discount_rob_t_time_n
end

function RedAlertTimeDiscountStoreTicket:onUpdate(dt)
    if self.m_reset_times_2 > 0 then
        self.m_reset_times_2 = self.m_reset_times_2 - dt
        if self.text_reset_times ~= nil then
            self.text_reset_times:setString(getRedAlertTimeActivityFormat(self.m_reset_times_2))
        end
        
    end
end

--初始化
function RedAlertTimeDiscountStoreTicket:onInit()
    local root = cacher.createUIRef(config_csb.treasurehouse.discount_store_tab_2, "root")
    table.insert(self.roots, root)
    self:addChild(root)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_discount_rob"), nil, 
        {
            terminal_name = "red_alert_time_discount_store_ticket_explore", 
            terminal_state = 0, 
            _index = i,
            _cell = self,
        }, nil, 1)

    if RedAlertTimeDiscountStoreTicket.__size == nil then
        RedAlertTimeDiscountStoreTicket.__size = root:getContentSize()
    end  
    self:updateDraw()
end

function RedAlertTimeDiscountStoreTicket:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_discount_rob_t_time_n = ccui.Helper:seekWidgetByName(root, "Text_discount_rob_t_time_n")
    local Text_discount_rob_t_time = ccui.Helper:seekWidgetByName(root, "Text_discount_rob_t_time")
    if Text_discount_rob_t_time_n ~= nil then
        Text_discount_rob_t_time_n:setString("")
        Text_discount_rob_t_time:setString("")
    end
end

function RedAlertTimeDiscountStoreTicket:onEnterTransitionFinish()

end

function RedAlertTimeDiscountStoreTicket:init(params)
    self._activity_type = params[1]
    self._state = params[2]
	self:onInit()
    self:setContentSize(RedAlertTimeDiscountStoreTicket.__size)
    return self
end

function RedAlertTimeDiscountStoreTicket:onExit()
    state_machine.remove("red_alert_time_discount_store_ticket_update")
    state_machine.remove("red_alert_time_discount_store_ticket_explore")
    self:clearUIInfo()
    cacher.freeRef(config_csb.treasurehouse.discount_store_tab_2, self.roots[1])
end