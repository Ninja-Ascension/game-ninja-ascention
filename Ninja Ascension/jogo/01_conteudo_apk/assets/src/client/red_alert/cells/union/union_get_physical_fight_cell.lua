
UnionGetPhysicalFightCell = class("UnionGetPhysicalFightCellClass", Window)
UnionGetPhysicalFightCell.__size = nil

local union_get_physical_fight_create_cell_terminal = {
    _name = "union_get_physical_fight_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        return UnionGetPhysicalFightCell:new():init(params)
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_get_physical_fight_create_cell_terminal)
state_machine.init()

function UnionGetPhysicalFightCell:ctor()
	self.super:ctor()
	self.roots = {}
    self._index = 0
    self._info_data = nil
    self._isPass = false
    
    local function init_union_get_physical_fight_cell_terminal()
        --加入
        local union_get_physical_fight_cell_join_terminal = {
            _name = "union_get_physical_fight_cell_join",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if tonumber(cell._info_data.team_type) == 1 
                    and dms.int(dms["union_config"], 10, union_config.param) >= zstring.tonumber(_ED.user_info.user_gold)
                    then
                    state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
                    {
                        terminal_name = "shortcut_open_recharge_window", 
                        terminal_state = 0, 
                        _msg = red_alert_all_str[185], 
                        _datas= 
                        {
                        }
                    })
                    return
                end
                if tonumber(cell._info_data.team_type) == 0 
                    and dms.int(dms["union_config"], 9, union_config.param) >= zstring.tonumber(_ED.user_info.user_silver)
                    then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[71])
                    return
                end
                local function respondCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("union_get_physical_fight_enter_fight", 0, nil)
                    end
                end
                protocol_command.union_food_copy_join_group.param_list = _ED.union.user_union_info.union_id.."\r\n"..cell._info_data.team_id.."\r\n"..cell._info_data.team_type
                NetworkManager:register(protocol_command.union_food_copy_join_group.code, nil, nil, nil, cell, respondCallBack, false, nil)           
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_get_physical_fight_cell_join_terminal)
        state_machine.init()
    end
    
    init_union_get_physical_fight_cell_terminal()
end

function UnionGetPhysicalFightCell:updateDraw()
    local root = self.roots[1]
    local jion_index = 0 
    for i=1,3 do
        local Panel_player = ccui.Helper:seekWidgetByName(root, "Panel_player_"..i)
        local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name_"..i)
        Panel_player:removeAllChildren(true)
        Text_player_name:setString("")
        if i <= tonumber(self._info_data.member_nums) then
            jion_index = i
            local memberInfo = self._info_data.member_info[i]
            local data = {
                user_sex = memberInfo.sex, 
                user_level = memberInfo.level,
                user_camp = _ED.union.union_info.union_camp,
            }
            Panel_player:addChild(state_machine.excute("user_head_icon_create", 0, {data, 2}))
            Text_player_name:setString(memberInfo.name)
        end
    end

    local Text_spend_lv = ccui.Helper:seekWidgetByName(root, "Text_spend_lv")
    local Panel_button_join = ccui.Helper:seekWidgetByName(root, "Panel_button_join")
    local Button_battle = ccui.Helper:seekWidgetByName(root, "Button_battle")
    local Button_join = ccui.Helper:seekWidgetByName(root, "Button_join")
    local Image_gold = ccui.Helper:seekWidgetByName(root, "Image_gold")
    local Image_gem = ccui.Helper:seekWidgetByName(root, "Image_gem")
    local Text_spend = ccui.Helper:seekWidgetByName(root, "Text_spend")
    local Image_flag_1 = ccui.Helper:seekWidgetByName(root, "Image_flag_1"):setVisible(false)
    local Image_flag_2 = ccui.Helper:seekWidgetByName(root, "Image_flag_2"):setVisible(false)
    
    Panel_button_join:setVisible(false)
    Button_battle:setVisible(false)
    Button_join:setVisible(false)
    Image_gem:setVisible(false)
    Image_gold:setVisible(false)
    Text_spend_lv:setString("")
    Text_spend:setVisible(false)
    if tonumber(self._info_data.team_type) == 0 then
        Image_flag_1:setVisible(true)
    else
        Image_flag_2:setVisible(true)
    end
    if self._isPass == false then
        Panel_button_join:setVisible(true)
        if tonumber(_ED.union.union_get_physical_my_team_id) == tonumber(self._info_data.team_id) then
            Button_battle:setVisible(true)
        else
            if jion_index < 3 then
                Button_join:setVisible(true)
                Text_spend:setVisible(true)
                if tonumber(self._info_data.team_type) == 0 then
                    Image_gold:setVisible(true)
                    Text_spend_lv:setString(dms.string(dms["union_config"], 11, union_config.param))
                else
                    Image_gem:setVisible(true)
                    Text_spend_lv:setString(dms.string(dms["union_config"], 12, union_config.param))
                end
            end
        end
    end
end

function UnionGetPhysicalFightCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.legion.legion_alaxi_battle_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root) 
    table.insert(self.roots, root)

    local panel = ccui.Helper:seekWidgetByName(root, "Panel_legion_alaxi_battle_cell")

    if UnionGetPhysicalFightCell.__size == nil then
        UnionGetPhysicalFightCell.__size = panel:getContentSize()
    end
    --加入
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_join"), nil, 
    {
        terminal_name = "union_get_physical_fight_cell_join", 
        terminal_state = 0, 
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95,        
    }, nil, 2) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_battle"), nil, 
    {
        terminal_name = "union_get_physical_fight_enter_fight", 
        terminal_state = 0, 
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95,        
    }, nil, 2) 

	self:updateDraw()
end

function UnionGetPhysicalFightCell:onEnterTransitionFinish()

end

--清除缓存
function UnionGetPhysicalFightCell:close()
    
end

function UnionGetPhysicalFightCell:init(params)
    self._index = params[1]
    self._info_data = params[2]
    self._isPass = params[3]
	self:onInit()
    self:setContentSize(UnionGetPhysicalFightCell.__size)
    return self
end

function UnionGetPhysicalFightCell:onExit()
    for i=1,3 do
        local Panel_player = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_player_"..i)
        if Panel_player ~= nil then
            Panel_player:removeAllChildren(true)
        end
    end
end