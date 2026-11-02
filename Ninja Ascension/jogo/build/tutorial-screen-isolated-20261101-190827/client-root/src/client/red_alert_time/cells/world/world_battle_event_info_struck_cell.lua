----------------------------------------------------------------------------------------------------
-- 说明：来袭队列列表cell
-------------------------------------------------------------------------------------------------------
WorldBattleEventInfoStruckCell = class("WorldBattleEventInfoStruckCellClass", Window)
WorldBattleEventInfoStruckCell.__size = nil

local world_battle_event_info_struck_cell_create_terminal = {
    _name = "world_battle_event_info_struck_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = WorldBattleEventInfoStruckCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(world_battle_event_info_struck_cell_create_terminal)
state_machine.init()

function WorldBattleEventInfoStruckCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._info = nil

    self.local_time = 0
    self.old_local_time = 0

    self._loading_bar = nil
    self._text_time = nil

    local function init_world_battle_event_info_struck_cell_terminal()
        local world_battle_event_info_struck_cell_update_info_terminal = {
            _name = "world_battle_event_info_struck_cell_update_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)           
                local cell = params.cell
                cell._index = params.index
                cell._info = params._info
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
        
        state_machine.add(world_battle_event_info_struck_cell_update_info_terminal)
        state_machine.init()
    end
    init_world_battle_event_info_struck_cell_terminal()         
end

function WorldBattleEventInfoStruckCell:onShow()
    self:setVisible(true)
end

function WorldBattleEventInfoStruckCell:onHide()
    self:setVisible(false)
end

function WorldBattleEventInfoStruckCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_implement_icon = ccui.Helper:seekWidgetByName(root,"Panel_implement_icon")
    local Text_attack_player_name_lv = ccui.Helper:seekWidgetByName(root,"Text_attack_player_name_lv")
    local Text_attack_res_xy_n = ccui.Helper:seekWidgetByName(root,"Text_attack_res_xy_n")
    local Text_arrive_time = ccui.Helper:seekWidgetByName(root,"Text_arrive_time")
    local LoadingBar_distance_bar = ccui.Helper:seekWidgetByName(root,"LoadingBar_distance_bar")
    Panel_implement_icon:removeBackGroundImage()
    Panel_implement_icon:setBackGroundImage("images/ui/share/world_implement_icon_4.png")
    Text_attack_player_name_lv:setString(self._info._nickname.." "..string.format(red_alert_all_str[13], ""..self._info._level))
    local Text_attack_res_xy_n = ccui.Helper:seekWidgetByName(root,"Text_attack_res_xy_n")
    local worldMines = ""
    if tonumber(self._info._world_mine_mould_id) > 0 then
        local element = dms.element(dms["world_mine_mould"], self._info._world_mine_mould_id)
        local name = dms.atos(element, world_mine_mould.name)
        worldMines = name.."["..self._info._dx..","..self._info._dy.."]"
    else
        worldMines = tipStringInfo_consumption_info[24].." "..string.format(red_alert_all_str[13], "".._ED.user_info.user_grade).."["..self._info._dx..","..self._info._dy.."]"
    end
    Text_attack_res_xy_n:setString(worldMines)
    self.local_time = (tonumber(self._info._start_time)/1000+tonumber(self._info._complete_time))-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))
    local m_times = getWorldTwopointMovementTime(self._info._sx,self._info._sy,self._info._dx,self._info._dy)
    self.old_local_time = tonumber(self._info._complete_time)
    Text_arrive_time:setString(exChangeTimeToString(self.local_time))
    local progress = math.min((m_times-self.local_time)/m_times*100)
    LoadingBar_distance_bar:setPercent(progress)

    self._text_time = Text_arrive_time
    self._loading_bar = LoadingBar_distance_bar
end

function WorldBattleEventInfoStruckCell:onUpdate(dt)
    if self.roots == nil and self.roots[1] == nil then
        return
    end
    if self._info == nil then
        return
    end
    if self._text_time ~= nil then
        if self.local_time > 0 then
            self.local_time = self.local_time - dt
            self._text_time:setString(exChangeTimeToString(self.local_time))
            local progress = math.min((self.old_local_time-self.local_time)/self.old_local_time*100)
            self._loading_bar:setPercent(progress)

            if self._index == 1 then
                state_machine.excute("world_battle_event_info_update_show_info", 0, {2, exChangeTimeToString(self.local_time)})
            end
        end
    end
end

function WorldBattleEventInfoStruckCell:onEnterTransitionFinish()

end

function WorldBattleEventInfoStruckCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.world.battle_infor_window_cell_3, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if WorldBattleEventInfoStruckCell.__size == nil then
        WorldBattleEventInfoStruckCell.__size = root:getContentSize()
    end

    self:onUpdateDraw()
end

function WorldBattleEventInfoStruckCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.world.battle_infor_window_cell_3, self.roots[1])
end

function WorldBattleEventInfoStruckCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function WorldBattleEventInfoStruckCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.world.battle_infor_window_cell_3, root)
    root:removeFromParent(false)
    self.roots = {}
end

function WorldBattleEventInfoStruckCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_implement_icon = ccui.Helper:seekWidgetByName(root,"Panel_implement_icon")
    local Text_attack_player_name_lv = ccui.Helper:seekWidgetByName(root,"Text_attack_player_name_lv")
    local Text_attack_res_xy_n = ccui.Helper:seekWidgetByName(root,"Text_attack_res_xy_n")
    local Text_arrive_time = ccui.Helper:seekWidgetByName(root,"Text_arrive_time")
    if Panel_implement_icon ~= nil then
        Panel_implement_icon:removeBackGroundImage()
        Text_attack_player_name_lv:setString("")
        Text_attack_res_xy_n:setString("")
        Text_arrive_time:setString("")
    end

    self:unregisterOnNoteUpdate(self)
end

function WorldBattleEventInfoStruckCell:init(params)
    self._index = params[1]
    self._info = params[2]
    -- if self._index <= 6 then
       self:onInit()
    -- end
    self:setContentSize(WorldBattleEventInfoStruckCell.__size)
end

