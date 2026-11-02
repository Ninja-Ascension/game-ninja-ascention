-- ------------------------------------------------------------------------------------------------------------
--  守卫战增益cell
-- ------------------------------------------------------------------------------------------------------------
GuardBattleGuardListCell = class("GuardBattleGuardListCellClass", Window)
GuardBattleGuardListCell.__size = nil

--创建cell
local guard_battle_guard_list_cell_create_terminal = {
    _name = "guard_battle_guard_list_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = GuardBattleGuardListCell:new()
        local index = params[1]
        local info_data = params[2]
        cell:init(index, info_data)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(guard_battle_guard_list_cell_create_terminal)
state_machine.init()

function GuardBattleGuardListCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info_data = nil
    self._index = 0
    local function init_guard_battle_guard_list_cell_terminal()

        local guard_battle_guard_list_look_infor_terminal = {
            _name = "guard_battle_guard_list_look_infor",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if __lua_project_id == __lua_project_pacific_rim then
                    local leave_time = _ED.guard_battle_user_info.cd_end_time - (os.time() + _ED.time_add_or_sub)
                    if leave_time > 0 then
                        state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {m_type = 25}})
                    else
                        _ED._battle_init_type = battle_enum._fight_type._fight_type_209
                        _ED._current_scene_id = 1
                        _ED._scene_npc_id = cell._info_data.id
                        _ED._npc_difficulty_index = cell._info_data.user_type
                        state_machine.excute("formation_window_open", 0, {_datas = {form_type = 13, next_terminal = "formation_defend_add_guard_formation_info", next_terminal_params = {cell._info_data}}})
                        -- state_machine.excute("formation_defend_add_guard_formation_info", 0, {cell._info_data})
                    end
                else
                    state_machine.excute("guard_battle_pk_attack_open", 0, {cell._info_data})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local guard_battle_guard_list_hit_terminal = {
            _name = "guard_battle_guard_list_hit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local leave_time = _ED.guard_battle_user_info.cd_end_time - (os.time() + _ED.time_add_or_sub)
                if leave_time > 0 then
                    state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {m_type = 25}})
                else
                    _ED._battle_init_type = battle_enum._fight_type._fight_type_209
                    _ED._current_scene_id = 1
                    _ED._scene_npc_id = cell._info_data.id
                    _ED._npc_difficulty_index = cell._info_data.user_type
                    state_machine.excute("formation_window_open",0,{_datas = {form_type = 13}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local guard_battle_guard_list_update_info_terminal = {
            _name = "guard_battle_guard_list_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params.cell
                local index = params.index
                cell._index = index 
                cell._info_data = params.info_data
                if cell._info_data ~= nil then
                    if index <= 7 then
                        cell:reload()
                        cell:updateDraw()
                    else
                        cell:unload()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(guard_battle_guard_list_look_infor_terminal)
        state_machine.add(guard_battle_guard_list_hit_terminal)
        state_machine.add(guard_battle_guard_list_update_info_terminal)
        state_machine.init()
    end
    
    init_guard_battle_guard_list_cell_terminal()
end

function GuardBattleGuardListCell:updateDraw()
    local root = self.roots[1]
    local Panel_guard_list_icon = ccui.Helper:seekWidgetByName(root, "Panel_guard_list_icon")
    local Text_guard_list_name = ccui.Helper:seekWidgetByName(root, "Text_guard_list_name")
    local Text_guard_list_fight_n = ccui.Helper:seekWidgetByName(root, "Text_guard_list_fight_n")
    Panel_guard_list_icon:removeAllChildren(true)

        -- 人物头像      
    local cell = PlayerHeadIcon:createCell()
    local avatar_info = {}
    avatar_info.object = self._info_data.head_pic
    avatar_info.vip = 1
    avatar_info._type = 0
    cell:init(avatar_info)
    Panel_guard_list_icon:addChild(cell) 

    local fontName = config_res.font.font_name
    if isContentZh_TW() == true then
        fontName = ""
    end
    if self._info_data.user_type ~= nil and zstring.tonumber(self._info_data.user_type) == -1 then
        fontName = config_res.font.font_name
    end
    Text_guard_list_name:setFontName(fontName)
    Text_guard_list_name:setFontSize(Text_guard_list_name:getFontSize()) 

    Text_guard_list_name:setString(""..self._info_data.name.." "..string.format(red_alert_time_str[33], self._info_data.level))
    Text_guard_list_fight_n:setString(exChangeNumToString(self._info_data.fight_number))

    local Button_guard_list_hit = ccui.Helper:seekWidgetByName(root, "Button_guard_list_hit")
    if tonumber(_ED.guard_battle_user_info.battle_type) == 0 then
        Button_guard_list_hit:setTouchEnabled(false)
        Button_guard_list_hit:setBright(false)
    else
        Button_guard_list_hit:setTouchEnabled(true)
        Button_guard_list_hit:setBright(true)
    end
end

function GuardBattleGuardListCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.campaign.guard_battle_guard_list_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if GuardBattleGuardListCell.__size == nil then
        GuardBattleGuardListCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guard_list_infor"), nil, 
    {
        terminal_name = "guard_battle_guard_list_look_infor", 
        terminal_state = 0, 
        touch_black = true,
        cell = self,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guard_list_hit"), nil, 
    {
        terminal_name = "guard_battle_guard_list_hit", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cell = self,
    }, nil, 1)

    self:updateDraw()
end

function GuardBattleGuardListCell:onEnterTransitionFinish()

end

function GuardBattleGuardListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function GuardBattleGuardListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.guard_battle_guard_list_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function GuardBattleGuardListCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_guard_list_icon = ccui.Helper:seekWidgetByName(root, "Panel_guard_list_icon")
    local Text_guard_list_name = ccui.Helper:seekWidgetByName(root, "Text_guard_list_name")
    local Text_guard_list_fight_n = ccui.Helper:seekWidgetByName(root, "Text_guard_list_fight_n")

    if Panel_guard_list_icon ~= nil then
        Panel_guard_list_icon:removeAllChildren(true)
        Text_guard_list_name:setString("")
        Text_guard_list_fight_n:setString("")
        Text_guard_list_name:removeAllChildren(true)
    end
end

function GuardBattleGuardListCell:init(index, info_data)
    self._index = index 
    self._info_data = info_data
    if index ~= nil and index <= 7 then
        self:onInit()
    end
    self:setContentSize(GuardBattleGuardListCell.__size)
    return self
end

function GuardBattleGuardListCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.guard_battle_guard_list_cell, self.roots[1])
end

