-----------------------------
--显示复活时间
-----------------------------
NatinalWarReviveTime = class("NatinalWarReviveTimeClass", Window)

local natinal_war_revivetime_window_open_terminal = {
    _name = "natinal_war_revivetime_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("NatinalWarReviveTimeClass") == nil then
            fwin:open(NatinalWarReviveTime:new():init(), fwin._viewdialog)
        end
        state_machine.excute("national_war_city_war_map_window_close",0,"")
        state_machine.excute("national_war_map_window_show",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local natinal_war_revivetime_window_close_terminal = {
    _name = "natinal_war_revivetime_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NatinalWarReviveTimeClass"))  
        _ED.warfar_my_fight_fail_info_is_show  = false
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(natinal_war_revivetime_window_open_terminal)
state_machine.add(natinal_war_revivetime_window_close_terminal)
state_machine.init()

function NatinalWarReviveTime:ctor()
    self.super:ctor()
    self.roots = {}
    self._cd_text = nil
    self._lasttime = nil
    -- -- Initialize national_war_decree machine.
    local function init_natinal_war_revive_time_terminal()

        -- 复活
        local natinal_war_revive_time_renascence_terminal = {
            _name = "natinal_war_revive_time_renascence",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        _ED.war_user_dead = false
                        state_machine.excute("natinal_war_revivetime_window_close",0,"")
                        TipDlg.drawTextDailog(red_alert_all_str[73])
                    end
                end
                local need_resouce = nil
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
                    need_resouce = dms.string(dms["pirates_config"],316,pirates_config.param)
                else
                    need_resouce = dms.string(dms["pirates_config"],312,pirates_config.param)
                end
                need_resouce = zstring.split(need_resouce,",")
                need_resouce = tonumber(need_resouce[2])
                if tonumber(_ED.selfWarProvisions) < need_resouce then
                    state_machine.excute("natinal_war_buy_resource_window_open",0,"")
                    return
                end
                NetworkManager:register(protocol_command.renascence.code, nil, nil, nil,nil, responseCallback, false, nil)     
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 


        state_machine.add(natinal_war_revive_time_renascence_terminal)    
        state_machine.init()
    end
    
    -- call func init national_war_decree machine.
    init_natinal_war_revive_time_terminal()
end

function NatinalWarReviveTime:formatTimeString(_time)    --系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%02d", math.floor(math.max(0,tonumber(_time)/3600))) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((math.max(0,tonumber(_time)%3600)/60))) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(math.max(0,tonumber(_time)%60)))
    return timeString
end

function NatinalWarReviveTime:onUpdateDraw()
    local root = self.roots[1]
    local Text_revive_time = ccui.Helper:seekWidgetByName(root,"Text_revive_time")
    self._cd_text = Text_revive_time
    local leave_time = tonumber(_ED.revive_cooling_time)
    Text_revive_time:setString(self:formatTimeString(leave_time))
end

function NatinalWarReviveTime:onUpdate(dt)
    local now_time = os.time()
    if self._cd_text == nil or self._lasttime == now_time then
        return
    end  
    if self._last_time == nil or now_time >= self._last_time + 1 then

        local leave_time = tonumber(_ED.revive_cooling_time) - (now_time - tonumber(_ED.revive_cooling_start_time))
        if leave_time < 0 then
            _ED.revive_cooling_time = 0
            _ED.war_user_dead = false

            self:unregisterOnNoteUpdate(self)
            self:setVisible(false)
            fwin:addService({
                callback = function ( params )    
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            local function doUpdateHp( )
                                state_machine.excute("national_war_hero_listview_update_hp",0,"")
                                state_machine.excute("natinal_war_revivetime_window_close",0,"")
                            end
                            self:runAction(cc.Sequence:create(cc.DelayTime:create(tonumber(_ED.revive_cooling_time)),cc.CallFunc:create(doUpdateHp)))                            
                        end
                    end   
                    protocol_command.refush_city_info.param_list = _ED.war_user_at_city_id
                    NetworkManager:register(protocol_command.refush_city_info.code, nil, nil, nil,nil, responseCallback, false, nil)                    
            end,
            params = self
            })
            
            return
        end
        self._cd_text:setString(self:formatTimeString(leave_time))
    end
    self._last_time = now_time
end

function NatinalWarReviveTime:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.natinalwar_revive_time)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    --复活
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_revive_go_on"), nil, 
    {
        terminal_name = "natinal_war_revive_time_renascence", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
     
    self:onUpdateDraw() 
end

function NatinalWarReviveTime:init()
    self:onInit()
    return self
end

function NatinalWarReviveTime:onExit()
    state_machine.remove("natinal_war_revive_time_renascence")
end
