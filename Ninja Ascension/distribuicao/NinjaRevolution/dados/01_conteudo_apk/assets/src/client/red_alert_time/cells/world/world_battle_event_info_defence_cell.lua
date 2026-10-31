----------------------------------------------------------------------------------------------------
-- 说明：协防队列列表cell
-------------------------------------------------------------------------------------------------------
WorldBattleEventInfoDefenceCell = class("WorldBattleEventInfoDefenceCellClass", Window)
WorldBattleEventInfoDefenceCell.__size = nil
WorldBattleEventInfoDefenceCell.__panel_y = nil
WorldBattleEventInfoDefenceCell.__text_attack_y = nil
WorldBattleEventInfoDefenceCell.__loading_bar_y = nil
WorldBattleEventInfoDefenceCell.__text_arrive_y = nil
WorldBattleEventInfoDefenceCell.__text_player_y = nil
WorldBattleEventInfoDefenceCell.__image_y = nil

local world_battle_event_info_defence_cell_create_terminal = {
    _name = "world_battle_event_info_defence_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = WorldBattleEventInfoDefenceCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(world_battle_event_info_defence_cell_create_terminal)
state_machine.init()

function WorldBattleEventInfoDefenceCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._info = nil
    self.m_object = nil

    self.local_time = 0
    self.old_local_time = 0

    self._text_time = nil
    self._loading_bar = nil

    local function init_world_battle_event_info_defence_cell_terminal()
        local world_battle_event_info_defence_cell_update_info_terminal = {
            _name = "world_battle_event_info_defence_cell_update_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)           
                local cell = params.cell
                cell._index = params.index
                cell._info = params._info
                cell.m_object = cell._info
                if cell._info == nil then
                    cell:onHide()
                else
                    cell:onShow()
                    -- if cell._index <= 6 then
                        -- cell:reload()
                        cell:onUpdateDraw()
                    -- else
                        -- cell:unload()
                    -- end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local world_battle_event_info_defence_cell_repatriation_terminal = {
            _name = "world_battle_event_info_defence_cell_repatriation",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local fighting_type = "0"
                if tonumber(cell._info._event_type) == 14 then
                    fighting_type = "17"
                end
                local m_times = getWorldTwopointMovementTime(cell._info._sx,cell._info._sy,cell._info._dx,cell._info._dy, false, true)
                protocol_command.world_add_target_event.param_list = fighting_type .. "\r\n" ..cell._info._dx.."\r\n" ..cell._info._dy.."\r\n"..m_times.."\r\n"..cell._info._time.."\r\n-"
                NetworkManager:register(protocol_command.world_add_target_event.code, nil, nil, nil, cell, nil, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --切换待命和协防
        local world_battle_event_info_defence_cell_switch_data_terminal = {
            _name = "world_battle_event_info_defence_cell_switch_data",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local key = cell._info._user_info..","..cell._info._time..","..cell._info._dx..","..cell._info._dy
                local state_of_war = 0
                if tonumber(cell._info._help_defend_state) == 0 then
                    state_of_war = 1
                else
                    state_of_war = 0
                end
                protocol_command.world_help_defend_set.param_list = "1".."\r\n"..key.."\r\n"..state_of_war
                NetworkManager:register(protocol_command.world_help_defend_set.code, nil, nil, nil, cell, nil, false, nil)   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local world_battle_event_info_defence_cell_look_info_terminal = {
            _name = "world_battle_event_info_defence_cell_look_info",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                state_machine.excute("world_battle_troops_infor_open", 0, {cell._info})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(world_battle_event_info_defence_cell_update_info_terminal)
        state_machine.add(world_battle_event_info_defence_cell_repatriation_terminal)
        state_machine.add(world_battle_event_info_defence_cell_switch_data_terminal)
        state_machine.add(world_battle_event_info_defence_cell_look_info_terminal)
        state_machine.init()
    end
    init_world_battle_event_info_defence_cell_terminal()         
end

function WorldBattleEventInfoDefenceCell:onShow()
    self:setVisible(true)
end

function WorldBattleEventInfoDefenceCell:onHide()
    self:setVisible(false)
end

function WorldBattleEventInfoDefenceCell:onUpdateDraw()
    local root = self.roots[1]
    --图标
    local Panel_implement_icon = ccui.Helper:seekWidgetByName(root,"Panel_implement_icon")
    Panel_implement_icon:removeBackGroundImage()
    --名称
    local Text_attack_player_name_lv = ccui.Helper:seekWidgetByName(root,"Text_attack_player_name_lv")
    --进度
    local LoadingBar_help_arrive_bar = ccui.Helper:seekWidgetByName(root,"LoadingBar_help_arrive_bar")
    local Image_loading_xy_bg = ccui.Helper:seekWidgetByName(root,"Image_loading_xy_bg")
    --进度内容
    local Text_arrive_time = ccui.Helper:seekWidgetByName(root,"Text_arrive_time")
    --战力
    local Text_player_fight = ccui.Helper:seekWidgetByName(root,"Text_player_fight")

    --遣返按钮
    local Button_help_repatriate = ccui.Helper:seekWidgetByName(root,"Button_help_repatriate")
    --查看
    local Button_help_look = ccui.Helper:seekWidgetByName(root,"Button_help_look")
    --待命
    local Button_help_standby = ccui.Helper:seekWidgetByName(root,"Button_help_standby")

    if tonumber(self._info._help_defend_state) == 0 then
        Panel_implement_icon:setBackGroundImage("images/ui/share/world_implement_icon_8.png")
    else
        Panel_implement_icon:setBackGroundImage("images/ui/share/world_implement_icon_6.png")
    end

    Text_player_fight:setString(exChangeNumToString(tonumber(self._info._combat_force)))

    Text_attack_player_name_lv:setString(self._info._nickname.." "..string.format(red_alert_all_str[13], ""..self._info._level)..string.format(red_alert_time_str[6], tonumber(self._info._dx),tonumber(self._info._dy)))
    if tonumber(self._info._event_type) == 13 then
        self.local_time = (tonumber(self._info._start_time)/1000+tonumber(self._info._complete_time))-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))
        local m_times = getWorldTwopointMovementTime(self._info._sx,self._info._sy,self._info._dx,self._info._dy, false, true)
        self.old_local_time = tonumber(self._info._complete_time)
        Text_arrive_time:setString(tipStringInfo_campaign_info[37]..exChangeTimeToString(self.local_time))
        local progress = math.min((m_times-self.local_time)/m_times*100)
        LoadingBar_help_arrive_bar:setPercent(progress)
        Panel_implement_icon:setPositionY(WorldBattleEventInfoDefenceCell.__panel_y-20)
        Text_attack_player_name_lv:setPositionY(WorldBattleEventInfoDefenceCell.__text_attack_y-20)
        LoadingBar_help_arrive_bar:setPositionY(WorldBattleEventInfoDefenceCell.__loading_bar_y-20)
        Text_arrive_time:setPositionY(WorldBattleEventInfoDefenceCell.__text_arrive_y-20)
        Text_player_fight:setPositionY(WorldBattleEventInfoDefenceCell.__text_player_y-20)
        Image_loading_xy_bg:setPositionY(WorldBattleEventInfoDefenceCell.__image_y-20)

        Button_help_repatriate:setVisible(false)
        Button_help_look:setVisible(false)
        Button_help_standby:setVisible(false)
    else
        Panel_implement_icon:setPositionY(WorldBattleEventInfoDefenceCell.__panel_y)
        Text_attack_player_name_lv:setPositionY(WorldBattleEventInfoDefenceCell.__text_attack_y)
        LoadingBar_help_arrive_bar:setPositionY(WorldBattleEventInfoDefenceCell.__loading_bar_y)
        Text_arrive_time:setPositionY(WorldBattleEventInfoDefenceCell.__text_arrive_y)
        Text_player_fight:setPositionY(WorldBattleEventInfoDefenceCell.__text_player_y)
        Image_loading_xy_bg:setPositionY(WorldBattleEventInfoDefenceCell.__image_y)
        if tonumber(self._info._help_defend_state) == 0 then
            Text_arrive_time:setString(red_alert_time_str[271])
            Button_help_standby:setTitleText(red_alert_time_str[274])
        else
            Text_arrive_time:setString(red_alert_time_str[272])
            Button_help_standby:setTitleText(red_alert_time_str[273])
        end

        LoadingBar_help_arrive_bar:setPercent(0)
        Button_help_repatriate:setVisible(true)
        Button_help_look:setVisible(true)
        Button_help_standby:setVisible(true)

    end

    self._text_time = Text_arrive_time
    self._loading_bar = LoadingBar_help_arrive_bar
end

function WorldBattleEventInfoDefenceCell:onUpdate(dt)
    if self.roots == nil and self.roots[1] == nil then
        return
    end
    if self._info == nil then
        return
    end
    if tonumber(self._info._event_type) == 13 then
        if self.local_time > 0 then
            self.local_time = self.local_time - dt
            self._text_time:setString(tipStringInfo_campaign_info[37]..exChangeTimeToString(self.local_time))
            local progress = math.min((self.old_local_time-self.local_time)/self.old_local_time*100)
            self._loading_bar:setPercent(progress)
        end
    end

    if self._index == 1 then
        local show_info = ""
        if tonumber(self._info._event_type) == 13 then
            if self.local_time > 0 then
                show_info = exChangeTimeToString(self.local_time)
            end
        elseif tonumber(self._info._event_type) == 14 then
            if tonumber(self._info._help_defend_state) == 0 then
                show_info = red_alert_time_str[271]
            else
                show_info = red_alert_time_str[272]
            end
        end
        state_machine.excute("world_battle_event_info_update_show_info", 0, {3, show_info})
    end
end

function WorldBattleEventInfoDefenceCell:onEnterTransitionFinish()

end

function WorldBattleEventInfoDefenceCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.world.battle_infor_window_cell_4, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if WorldBattleEventInfoDefenceCell.__size == nil then
        WorldBattleEventInfoDefenceCell.__size = root:getContentSize()
    end

    if WorldBattleEventInfoDefenceCell.__panel_y == nil then
        local Panel_implement_icon = ccui.Helper:seekWidgetByName(root,"Panel_implement_icon")
        WorldBattleEventInfoDefenceCell.__panel_y = Panel_implement_icon:getPositionY()
    end
    if WorldBattleEventInfoDefenceCell.__text_attack_y == nil then
        local Text_attack_player_name_lv = ccui.Helper:seekWidgetByName(root,"Text_attack_player_name_lv")
        WorldBattleEventInfoDefenceCell.__text_attack_y = Text_attack_player_name_lv:getPositionY()
    end
    if WorldBattleEventInfoDefenceCell.__loading_bar_y == nil then
        local LoadingBar_help_arrive_bar = ccui.Helper:seekWidgetByName(root,"LoadingBar_help_arrive_bar")
        WorldBattleEventInfoDefenceCell.__loading_bar_y = LoadingBar_help_arrive_bar:getPositionY()
    end
    if WorldBattleEventInfoDefenceCell.__text_arrive_y == nil then
        local Text_arrive_time = ccui.Helper:seekWidgetByName(root,"Text_arrive_time")
        WorldBattleEventInfoDefenceCell.__text_arrive_y = Text_arrive_time:getPositionY()
    end
    if WorldBattleEventInfoDefenceCell.__text_player_y == nil then
        local Text_player_fight = ccui.Helper:seekWidgetByName(root,"Text_player_fight")
        WorldBattleEventInfoDefenceCell.__text_player_y = Text_player_fight:getPositionY()
    end
    if WorldBattleEventInfoDefenceCell.__image_y == nil then
        local Image_loading_xy_bg = ccui.Helper:seekWidgetByName(root,"Image_loading_xy_bg")
        WorldBattleEventInfoDefenceCell.__image_y = Image_loading_xy_bg:getPositionY()
    end

    --遣返
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_help_repatriate") , nil, 
    {
        terminal_name = "world_battle_event_info_defence_cell_repatriation", 
        terminal_state = 0,
        touch_scale = false,
        touch_scale_xy = 0.95,
        touch_black = true, 
        cell = self,
    }, nil, 1)    

    --查看
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_help_look") , nil, 
    {
        terminal_name = "world_battle_event_info_defence_cell_look_info", 
        terminal_state = 0,
        touch_scale = false,
        touch_scale_xy = 0.95,
        touch_black = true, 
        cells = self,
    }, nil, 1)    

    --待命
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_help_standby") , nil, 
    {
        terminal_name = "world_battle_event_info_defence_cell_switch_data", 
        terminal_state = 0,
        touch_scale = false,
        touch_scale_xy = 0.95,
        touch_black = true, 
        cell = self,
    }, nil, 1)   

    self:onUpdateDraw()
end

function WorldBattleEventInfoDefenceCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.world.battle_infor_window_cell_4, self.roots[1])
end

function WorldBattleEventInfoDefenceCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function WorldBattleEventInfoDefenceCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.world.battle_infor_window_cell_4, root)
    root:removeFromParent(false)
    self.roots = {}
end

function WorldBattleEventInfoDefenceCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_implement_icon = ccui.Helper:seekWidgetByName(root,"Panel_implement_icon")
    local Text_attack_player_name_lv = ccui.Helper:seekWidgetByName(root,"Text_attack_player_name_lv")
    local Text_arrive_time = ccui.Helper:seekWidgetByName(root,"Text_arrive_time")
    local Text_player_fight = ccui.Helper:seekWidgetByName(root,"Text_player_fight")
    local LoadingBar_help_arrive_bar = ccui.Helper:seekWidgetByName(root,"LoadingBar_help_arrive_bar")
    local Image_loading_xy_bg = ccui.Helper:seekWidgetByName(root,"Image_loading_xy_bg")
    if Panel_implement_icon ~= nil then
        Panel_implement_icon:removeBackGroundImage()
        Text_attack_player_name_lv:setString("")
        Text_arrive_time:setString("")
        Text_player_fight:setString("")

        Panel_implement_icon:setPositionY(WorldBattleEventInfoDefenceCell.__panel_y)
        Text_attack_player_name_lv:setPositionY(WorldBattleEventInfoDefenceCell.__text_attack_y)
        LoadingBar_help_arrive_bar:setPositionY(WorldBattleEventInfoDefenceCell.__loading_bar_y)
        Text_arrive_time:setPositionY(WorldBattleEventInfoDefenceCell.__text_arrive_y)
        Text_player_fight:setPositionY(WorldBattleEventInfoDefenceCell.__text_player_y)
        Image_loading_xy_bg:setPositionY(WorldBattleEventInfoDefenceCell.__image_y)
    end

    self:unregisterOnNoteUpdate(self)
end

function WorldBattleEventInfoDefenceCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self.m_object = self._info
    -- if self._index <= 6 then
       self:onInit()
    -- end
    self:setContentSize(WorldBattleEventInfoDefenceCell.__size)
end

