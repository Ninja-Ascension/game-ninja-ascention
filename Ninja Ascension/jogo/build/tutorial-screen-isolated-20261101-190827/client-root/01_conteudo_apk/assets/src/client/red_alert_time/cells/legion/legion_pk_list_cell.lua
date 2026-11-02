-- ------------------------------------------------------------------------------------------------------------
--  军团pk列表cell
-- ------------------------------------------------------------------------------------------------------------
LegionPKListCell = class("LegionPKListCellClass", Window)
LegionPKListCell.__size = nil

--创建cell
local legion_pk_list_create_cell_terminal = {
    _name = "legion_pk_list_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionPKListCell:new()
        local info_data = params[1]
        local index = params[2]
        cell:init(info_data, index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_pk_list_create_cell_terminal)
state_machine.init()

function LegionPKListCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info_data = nil
    self._index = 0

    local function init_legion_pk_list_cell_terminal()
        local legion_pk_list_cell_click_terminal = {
            _name = "legion_pk_list_cell_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if __lua_project_id == __lua_project_pacific_rim then
                    _ED._battle_init_type = battle_enum._fight_type._fight_type_24
                    _ED._current_scene_id = 1
                    _ED._legion_pk_defender_id = cell._info_data.id
                    state_machine.excute("formation_window_open", 0, {_datas = {form_type = 5, next_terminal = "formation_defend_add_legion_formation_info", next_terminal_params = {cell._info_data, 0}}})
                    -- state_machine.excute("formation_defend_add_legion_formation_info", 0, {cell._info_data, 0})
                else
                    state_machine.excute("legion_pk_attack_open", 0, {cell._info_data,0})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_pk_list_cell_click_terminal)
        state_machine.init()
    end
    init_legion_pk_list_cell_terminal()
end

function LegionPKListCell:updateDraw()
    local root = self.roots[1]
    local Panel_player_head = ccui.Helper:seekWidgetByName(root, "Panel_player_head")
    local Textvs_vs_troops_name_lv = ccui.Helper:seekWidgetByName(root, "Textvs_vs_troops_name_lv")
    local Text_troops_fight_n = ccui.Helper:seekWidgetByName(root, "Text_troops_fight_n")
    Panel_player_head:removeAllChildren(true)
    Textvs_vs_troops_name_lv:removeAllChildren(true)

    local cell = PlayerHeadIcon:createCell()
    local avatar_info = {}
    avatar_info.object = self._info_data.user_head_id
    avatar_info.vip = self._info_data.vip_level
    avatar_info._type = 0
    cell:init(avatar_info)
    Panel_player_head:addChild(cell) 

    local fontName = config_res.font.font_name
    if isContentZh_TW() == true then
        fontName = ""
    end
    local fontSize = Textvs_vs_troops_name_lv:getFontSize()

    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, self._info_data.name.." ", fontName,fontSize)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, string.format(red_alert_all_str[117],self._info_data.level), config_res.font.font_name,fontSize)
    _richText:pushBackElement(re2)
    _richText:setPosition(cc.p(Textvs_vs_troops_name_lv:getContentSize().width/2,Textvs_vs_troops_name_lv:getContentSize().height/2))
    _richText:setContentSize(cc.size(Textvs_vs_troops_name_lv:getContentSize().width,fontSize))
    Textvs_vs_troops_name_lv:addChild(_richText)

    Text_troops_fight_n:setString(exChangeNumToString(self._info_data.formation_capactity))

end

function LegionPKListCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_member_vs_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_vs_troops_look"), nil, 
    {
        terminal_name = "legion_pk_list_cell_click", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cell = self,
    }, nil, 1)

    if LegionPKListCell.__size == nil then
        LegionPKListCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function LegionPKListCell:onEnterTransitionFinish()

end

function LegionPKListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionPKListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_member_vs_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionPKListCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_player_head = ccui.Helper:seekWidgetByName(root, "Panel_player_head")
    local Textvs_vs_troops_name_lv = ccui.Helper:seekWidgetByName(root, "Textvs_vs_troops_name_lv")
    local Text_troops_fight_n = ccui.Helper:seekWidgetByName(root, "Text_troops_fight_n")
    if Panel_player_head ~= nil then
        Panel_player_head:removeAllChildren(true)
        Textvs_vs_troops_name_lv:removeAllChildren(true)
        Text_troops_fight_n:setString("")
    end
end

function LegionPKListCell:init(info_data, index)
    self._info_data = info_data
    self._index = index 
    if index ~= nil and index <= 8 then
        self:onInit()
    end
    self:setContentSize(LegionPKListCell.__size)
    return self
end

function LegionPKListCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_member_vs_cell, self.roots[1])
end

