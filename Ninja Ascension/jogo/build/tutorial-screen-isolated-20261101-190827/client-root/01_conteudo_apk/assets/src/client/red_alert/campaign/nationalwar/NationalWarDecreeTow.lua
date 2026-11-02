-----------------------------
--城池内号令
-----------------------------
NationalWarDecreeTow = class("NationalWarDecreeTowClass", Window)

local national_war_decree_window_tow_open_terminal = {
    _name = "national_war_decree_window_tow_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("NationalWarDecreeTowClass") == nil then
            local city_id = params._datas.city_id
            fwin:open(NationalWarDecreeTow:new():init(city_id), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_war_decree_window_tow_close_terminal = {
    _name = "national_war_decree_window_tow_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarDecreeTowClass"))  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_decree_window_tow_open_terminal)
state_machine.add(national_war_decree_window_tow_close_terminal)
state_machine.init()

function NationalWarDecreeTow:ctor()
    self.super:ctor()
    self.roots = {}

    app.load("client.red_alert.campaign.nationalwar.NationalWarDecreeCell")
    app.load("client.utils.ConfirmTip")

    self.city_id = nil
    -- -- Initialize national_war_decree machine.
    local function init_national_war_decree_tow_terminal()

        -- 移除cell
        local national_war_decree_tow_remove_cell_terminal = {
            _name = "national_war_decree_tow_remove_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:removeCell(params[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        -- 请求发布号令
        local national_war_decree_tow_to_decree_terminal = {
            _name = "national_war_decree_tow_to_decree",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local decree_index = params._datas.decree_index
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.onUpdateDraw ~= nil then
                            response.node:onUpdateDraw()
                            state_machine.excute("national_war_map_user_to_update",0,{response.node.city_id})
                        end
                    end
                end
                for i ,v in pairs(red_alert_home_city_id) do
                    if tonumber(instance.city_id) == tonumber(v) then
                        TipDlg.drawTextDailog(red_alert_all_str[57])
                        return
                    end
                end
                
                if decree_index == 1 then
                    if _ED.user_war_info.user_leader_level > 3 or _ED.user_war_info.user_leader_level == 0 then
                        TipDlg.drawTextDailog(red_alert_all_str[56])
                        return
                    end
                    if _ED.user_war_info.release_order_count > 0 then
                        local consume = dms.int(dms["warfare_config"], 21, warfare_config.param)
                        if consume > tonumber(_ED.selfWarProvisions) then
                            TipDlg.drawTextDailog(red_alert_all_str[167])
                        else
                            instance.release_order_decree_index = decree_index
                            local tip = ConfirmTip:new()
                            tip:init(instance, instance.onUpdateSendInfo, string.format(red_alert_all_str[168], consume))
                            fwin:open(tip,fwin._ui)
                            return
                        end
                    end
                elseif decree_index == 2 then
                    if _ED.union.union_info == nil 
                        or _ED.union.union_info == {} 
                        or _ED.union.union_info.union_id == nil 
                        or _ED.union.union_info.union_id == "" 
                        then
                        TipDlg.drawTextDailog(red_alert_all_str[166])
                        return
                    end
                    if _ED.user_war_info.union_user_level > 2 or _ED.user_war_info.union_user_level == 0 then
                        TipDlg.drawTextDailog(red_alert_all_str[165])
                        return
                    end
                end
                protocol_command.release_order.param_list = instance.city_id.."\r\n"..decree_index .."\r\n"
                NetworkManager:register(protocol_command.release_order.code, nil, nil, nil,instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }             

        state_machine.add(national_war_decree_tow_remove_cell_terminal)   
        state_machine.add(national_war_decree_tow_to_decree_terminal) 
        state_machine.init()
    end
    
    -- call func init national_war_decree machine.
    init_national_war_decree_tow_terminal()
end

function NationalWarDecreeTow:onUpdateSendInfo(n)
    if n ~= 0 then
        return 
    end
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.onUpdateDraw ~= nil then
                response.node:onUpdateDraw()
                state_machine.excute("national_war_map_user_to_update",0,{response.node.city_id})
            end
        end
    end
    protocol_command.release_order.param_list = self.city_id.."\r\n"..self.release_order_decree_index .."\r\n"
    NetworkManager:register(protocol_command.release_order.code, nil, nil, nil,self, responseCallback, false, nil)
end

function NationalWarDecreeTow:removeCell(cell)
    local root = self.roots[1]
    local ListView_decree = ccui.Helper:seekWidgetByName(root,"ListView_decree")
    ListView_decree:removeItem(ListView_decree:getIndex(cell))
end

function NationalWarDecreeTow:onUpdateDraw()
    local root = self.roots[1]
    local ListView_decree = ccui.Helper:seekWidgetByName(root,"ListView_decree")
    ListView_decree:removeAllItems()
    for i,v in pairs(_ED.warfare_order_info) do
        local city_id = tonumber(v.city)
        local order_type = tonumber(v.order_type)
        local leave_time = 0
        if order_type == 1 then
            leave_time = _ED.war_decree_time[city_id].country_leave_time
        elseif order_type == 2 then
            if _ED.user_war_info.union_id == v.union_id then
                leave_time = _ED.war_decree_time[city_id].family_leave_time
            end
        end
        if leave_time > 0 then
            local cell = state_machine.excute("national_war_decree_cell_create_cell",0,{v,2})
            ListView_decree:addChild(cell)
        end
    end
    local Panel_no_decree = ccui.Helper:seekWidgetByName(root,"Panel_no_decree")
    if #_ED.warfare_order_info == 0 then
        if Panel_no_decree ~= nil then
            Panel_no_decree:setVisible(true)
        end
    else
        if Panel_no_decree ~= nil then
            Panel_no_decree:setVisible(false)
        end
    end    
end

function NationalWarDecreeTow:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_decree_tow)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_decree_close"), nil, 
    {
        terminal_name = "national_war_decree_window_tow_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
    --集结军团
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_mass"), nil, 
    {
        terminal_name = "national_war_decree_tow_to_decree", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        decree_index = 2,
    }, nil, 0)

    -- 号令
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_order"), nil, 
    {
        terminal_name = "national_war_decree_tow_to_decree",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        decree_index = 1,
    }, nil, 0)
    self:onUpdateDraw() 
end

function NationalWarDecreeTow:init(city_id)
    self.city_id = city_id
    self:onInit()
    return self
end

function NationalWarDecreeTow:onExit()
    state_machine.remove("national_war_decree_remove_cell")
    state_machine.remove("national_war_decree_tow_to_decree")
end
