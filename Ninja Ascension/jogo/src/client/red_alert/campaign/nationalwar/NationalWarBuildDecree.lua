-----------------------------
--城池号令
-----------------------------
NationalWarBuildDecree = class("NationalWarBuildDecreeClass", Window)

local national_war_build_decree_window_open_terminal = {
    _name = "national_war_build_decree_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("NationalWarBuildDecreeClass") == nil then
            local city_id = params[1]
            fwin:open(NationalWarBuildDecree:new():init(city_id), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_war_build_decree_window_close_terminal = {
    _name = "national_war_build_decree_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarBuildDecreeClass"))  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_build_decree_window_open_terminal)
state_machine.add(national_war_build_decree_window_close_terminal)
state_machine.init()

function NationalWarBuildDecree:ctor()
    app.load("client.utils.ConfirmTip")

    self.super:ctor()
    self.roots = {}
    self.city_id = nil
    self.panel_infor = nil
    -- Initialize NationalWarBuildDecree state machine.
    local function init_national_war_build_decree_terminal()

        -- 前往
        local national_war_build_decree_goto_city_terminal = {
            _name = "national_war_build_decree_goto_city",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- print("====前往===点击的城池",instance.city_id)
                local city_id = instance.city_id
                state_machine.excute("national_war_city_war_map_window_close",0,{city_id})
                state_machine.excute("national_war_build_button_window_close",0,"")
                state_machine.excute("national_war_build_decree_window_close",0,"")
                state_machine.excute("national_war_map_move_to_city",0,{city_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 请求发布号令
        local national_war_build_decree_to_decree_terminal = {
            _name = "national_war_build_decree_to_decree",
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
        state_machine.add(national_war_build_decree_goto_city_terminal)   
        state_machine.add(national_war_build_decree_to_decree_terminal)   
        state_machine.init()
    end
    
    -- call func init NationalWarBuildDecree state machine.
    init_national_war_build_decree_terminal()
end

function NationalWarBuildDecree:onUpdateSendInfo(n)
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

function NationalWarBuildDecree:onUpdateDraw()
    local root = self.roots[1]
    local Text_bilud_decree_time = ccui.Helper:seekWidgetByName(root,"Text_bilud_decree_time")
    self.text_time = Text_bilud_decree_time
    local Panel_infor = ccui.Helper:seekWidgetByName(root,"Panel_infor")
    self.panel_infor = Panel_infor
    local Text_bilud_decree_description = ccui.Helper:seekWidgetByName(root,"Text_bilud_decree_description")
    local city_id = self.city_id
    local now_time = os.time()
 --     city = "10"
 -- order_type = "1"
 -- officer = "1"
 -- userName = "杜阳羽"
 -- coolintTime = "180"
    local userName = ""
    local officer = 1
    local union_id = 0
    local order_type = 0
    for i , v in pairs(_ED.warfare_order_info) do 
        if city_id == tonumber(v.city) then
            userName = v.userName
            officer = tonumber(v.officer)
            union_id = v.union_id
            order_type = v.order_type
        end
    end
    local city_name = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould],city_id,warfare_map_mould.city_name)
    if _ED.war_decree_time[city_id] ~= nil and zstring.tonumber(_ED.war_decree_time[city_id].country_leave_time) ~= 0 and zstring.tonumber(_ED.war_decree_time[city_id].country_start_time) ~= 0 then
        if _ED.war_decree_time[city_id].country_leave_time - (now_time - _ED.war_decree_time[city_id].country_start_time) < 0 then
            -- _ED.war_decree_time[city_id].country_leave_time = 0
        else
            local leave_time = _ED.war_decree_time[city_id].country_leave_time - (now_time - _ED.war_decree_time[city_id].country_start_time)
            Text_bilud_decree_time:setString(self:formatTimeString(leave_time))
            local str_dec = string.format(red_alert_all_str[41],red_alert_officer[officer]..userName , city_name)
            if ___is_open_leadname == true then 
                Text_bilud_decree_description:setFontName("")   
                Text_bilud_decree_description:setFontSize(Text_bilud_decree_description:getFontSize())
            end
            Text_bilud_decree_description:setString(str_dec)
            Panel_infor:setVisible(true)
            return
        end
    end  

    if _ED.war_decree_time[city_id] ~= nil and zstring.tonumber(_ED.war_decree_time[city_id].family_leave_time) ~= 0 and zstring.tonumber(_ED.war_decree_time[city_id].family_start_time) ~= 0 then
        if _ED.war_decree_time[city_id].family_leave_time - (now_time - _ED.war_decree_time[city_id].family_start_time) < 0 then
            -- _ED.war_decree_time[city_id].family_leave_time = 0
        else
            if _ED.user_war_info.union_id == union_id and order_type == 2 then    
                local leave_time = _ED.war_decree_time[city_id].family_leave_time - (now_time - _ED.war_decree_time[city_id].family_start_time)
                Text_bilud_decree_time:setString(self:formatTimeString(leave_time))
                local str_dec = string.format(red_alert_all_str[41],red_alert_family_officer[officer]..userName , city_name)
                if ___is_open_leadname == true then 
                    Text_bilud_decree_description:setFontName("")   
                    Text_bilud_decree_description:setFontSize(Text_bilud_decree_description:getFontSize())
                end
                Text_bilud_decree_description:setString(str_dec)            
                Panel_infor:setVisible(true)
                return
            end 
        end
    end 
    Panel_infor:setVisible(false)
end

function NationalWarBuildDecree:formatTimeString(_time)    --系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%02d", math.floor(math.max(0,tonumber(_time)/3600))) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((math.max(0,tonumber(_time)%3600)/60))) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(math.max(0,tonumber(_time)%60)))
    return timeString
end

function NationalWarBuildDecree:onUpdate(dt)
    local now_time = os.time()
    local root = self.roots[1]
    local city_id = self.city_id
    if _ED.war_decree_time[city_id] ~= nil and zstring.tonumber(_ED.war_decree_time[city_id].country_leave_time) ~= 0 and zstring.tonumber(_ED.war_decree_time[city_id].country_start_time) ~= 0 then
        if _ED.war_decree_time[city_id].country_leave_time - (now_time - _ED.war_decree_time[city_id].country_start_time) < 0 then
            _ED.war_decree_time[city_id].country_leave_time = 0
            self.panel_infor:setVisible(false)
        else
            local leave_time = _ED.war_decree_time[city_id].country_leave_time - (now_time - _ED.war_decree_time[city_id].country_start_time)
            self.text_time:setString(self:formatTimeString(leave_time))
            self.panel_infor:setVisible(true)
            return
        end
    end  

    if _ED.war_decree_time[city_id] ~= nil and zstring.tonumber(_ED.war_decree_time[city_id].family_leave_time) ~= 0 and zstring.tonumber(_ED.war_decree_time[city_id].family_start_time) ~= 0 then
        if _ED.war_decree_time[city_id].family_leave_time - (now_time - _ED.war_decree_time[city_id].family_start_time) < 0 then
            _ED.war_decree_time[city_id].family_leave_time = 0
            self.panel_infor:setVisible(false)
        else
            local leave_time = _ED.war_decree_time[city_id].family_leave_time - (now_time - _ED.war_decree_time[city_id].family_start_time)
            self.text_time:setString(self:formatTimeString(leave_time))
            self.panel_infor:setVisible(true)
            return
        end
    end
end

function NationalWarBuildDecree:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_build_decree)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_bilud_decree_close"), nil, 
    {
        terminal_name = "national_war_build_decree_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
    --集结军团
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_bilud_decree_build"), nil, 
    {
        terminal_name = "national_war_build_decree_to_decree", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        decree_index = 2,
    }, nil, 0)

    -- 号令
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bilud_decree_release"), nil, 
    {
        terminal_name = "national_war_build_decree_to_decree",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        decree_index = 1,
    }, nil, 0)
    
    -- 前往
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bilud_decree_go"), nil, 
    {
        terminal_name = "national_war_build_decree_goto_city",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)    
    self:onUpdateDraw() 
end

function NationalWarBuildDecree:init(city_id)
    self.city_id = city_id
    self:onInit()
    return self
end

function NationalWarBuildDecree:onExit()
    state_machine.remove("national_war_build_decree_goto_city",0,"")
    state_machine.remove("national_war_build_decree_to_decree",0,"")
end
