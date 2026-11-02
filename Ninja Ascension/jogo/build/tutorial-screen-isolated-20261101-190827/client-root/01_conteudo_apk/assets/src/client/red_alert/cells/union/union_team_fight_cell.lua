
UnionTeamFightCell = class("UnionTeamFightCellClass", Window)
UnionTeamFightCell.__size = nil

local union_team_fight_create_cell_terminal = {
    _name = "union_team_fight_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        return UnionTeamFightCell:new():init(params)
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_team_fight_create_cell_terminal)
state_machine.init()

function UnionTeamFightCell:ctor()
	self.super:ctor()
	self.roots = {}
    self._index = 0
    self._team_info = nil
    self._isPass = false

    local function init_union_team_fight_cell_terminal()
        local union_team_fight_join_terminal = {
            _name = "union_team_fight_join",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local my_team_ids = {}
                if _ED.union.user_union_info.team_fight_team_ids ~= "" then
                    my_team_ids = zstring.split(_ED.union.user_union_info.team_fight_team_ids, ",")
                end
                if table.getn(my_team_ids) >= 2 then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[41])
                    return
                end
                local cell = params._datas.cell
                state_machine.excute("union_team_fight_create_window_open", 0, cell._team_info)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        local union_team_fight_fighting_terminal = {
            _name = "union_team_fight_fighting",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local info = ""
                local index = 0
                _ED.union.union_team_fight_ship_info = {}
                for k,v in pairs(cell._team_info.member_info) do
                    if tonumber(v.id) ~= tonumber(_ED.user_info.user_id) then
                        index = index + 1
                        if index == 1 then
                            info = v.id..","..v.ship_id
                        else
                            info = info.."|"..v.id..","..v.ship_id
                        end
                    end
                end
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("union_team_fight_formation_window_open", 0, "")
                    end
                end
                if info == "" then
                    state_machine.excute("union_team_fight_formation_window_open", 0, "")
                else
                    protocol_command.get_ship_info.param_list = info
                    NetworkManager:register(protocol_command.get_ship_info.code, nil, nil, nil, cell, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(union_team_fight_join_terminal)
        state_machine.add(union_team_fight_fighting_terminal)
        state_machine.init()
    end
    
    init_union_team_fight_cell_terminal()
end

function UnionTeamFightCell:updateDraw()
    local root = self.roots[1]
    local jion_index = 0 
    for i=1,3 do
        local memberInfo = self._team_info.member_info[i]
        local Panel_player = ccui.Helper:seekWidgetByName(root, "Panel_player_header_"..i)
        Panel_player:removeAllChildren(true)
        local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name_"..i)
        local Image_name_bg = ccui.Helper:seekWidgetByName(root, "Image_name_bg_"..i)
        if memberInfo ~= nil then
            jion_index = i
            local data = {
                user_sex = memberInfo.sex, 
                user_level = memberInfo.level,
                user_camp = _ED.union.union_info.union_camp,
                -- user_name = memberInfo.name,
            }
            Panel_player:addChild(state_machine.excute("user_head_icon_create", 0, {data}))
            Text_player_name:setString(memberInfo.name)
            Image_name_bg:setVisible(true)
            local ships = zstring.split(memberInfo.ship_mould_id, ",")
            for j=1,2 do
                local Panel_hero_header = ccui.Helper:seekWidgetByName(root, "Panel_hero_header_"..i.."_"..j)
                Panel_hero_header:removeAllChildren(true)
                local cell = state_machine.excute("hero_icon_union_team_fight_create_cell", 0, {ships[j]})
                Panel_hero_header:addChild(cell)
            end
        end
    end
    local Text_team_lv = ccui.Helper:seekWidgetByName(root, "Text_team_lv")
    Text_team_lv:setString(string.format(tipStringInfo_union_str[24], self._team_info.team_id))

    local Button_join = ccui.Helper:seekWidgetByName(root, "Button_join")
    local Button_battle = ccui.Helper:seekWidgetByName(root, "Button_battle")
    local Image_had_jion = ccui.Helper:seekWidgetByName(root, "Image_had_jion")
    Button_join:setVisible(false)
    Button_battle:setVisible(false)
    Image_had_jion:setVisible(false)

    local isMyTeam = false
    if _ED.union.user_union_info.team_fight_team_ids ~= "" then
        local my_team_ids = zstring.split(_ED.union.user_union_info.team_fight_team_ids, ",")
        for k,v in pairs(my_team_ids) do
            if tonumber(self._team_info.team_id) == tonumber(v) then
                isMyTeam = true
            end
        end
    end
    if tonumber(_ED.union.user_union_info.team_fight_use_state) == 0 then
        if isMyTeam == true then
            Button_battle:setVisible(true)
        else
            if jion_index < 3 then
                Button_join:setVisible(true)
            end
        end
    else
        Image_had_jion:setVisible(true)
    end
end

function UnionTeamFightCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.legion.legion_team_challenge_hero_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root) 
    table.insert(self.roots, root)

    local panel = ccui.Helper:seekWidgetByName(root, "Panel_legion_team_challenge_hero")

    if UnionTeamFightCell.__size == nil then
        UnionTeamFightCell.__size = panel:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_join"), nil, 
    {
        terminal_name = "union_team_fight_join", 
        terminal_state = 0, 
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95,        
    }, nil, 2) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_battle"), nil, 
    {
        terminal_name = "union_team_fight_fighting", 
        terminal_state = 0, 
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95,        
    }, nil, 2) 

	self:updateDraw()
end

function UnionTeamFightCell:onEnterTransitionFinish()

end

--清除缓存
function UnionTeamFightCell:close()
    
end

function UnionTeamFightCell:init(params)
    self._index = params[1]
    self._team_info = params[2]
    self._isPass = params[3]
	self:onInit()
    self:setContentSize(UnionTeamFightCell.__size)
    return self
end

function UnionTeamFightCell:onExit()
    for i=1,3 do
        local Panel_player = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_player_header_"..i)
        if Panel_player ~= nil then
            Panel_player:removeAllChildren(true)
        end
    end
end