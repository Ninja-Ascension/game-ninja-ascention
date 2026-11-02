-- ---------------------------
-- 极限挑战敌方cell
-- ---------------------------
LimitDekaronaCell = class("LimitDekaronaCellClass", Window)
LimitDekaronaCell.__size = nil

local limit_dekarona_create_cell_terminal = {
    _name = "limit_dekarona_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LimitDekaronaCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(limit_dekarona_create_cell_terminal)
state_machine.init()

function LimitDekaronaCell:ctor()
    self.super:ctor()
    self.roots = {}

    local function init_limit_dekarona_cell_terminal()
        local limit_dekarona_cell_dekaron_terminal = {
            _name = "limit_dekarona_cell_dekaron",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                local fight_type = battle_enum._fight_type._fight_type_202
                local scene_id = 1
                local npc_id = 1
                local difficulty = index - 1
                state_machine.excute("adventure_mine_request_battle_field_init", 0, {fight_type, scene_id, npc_id, difficulty})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(limit_dekarona_cell_dekaron_terminal)
        state_machine.init()
    end
    
    init_limit_dekarona_cell_terminal()
end

--刷新列表数据
function LimitDekaronaCell:onUpdateDraw()
    local root = self.roots[1]
    for i=1,3 do
        local Panel_limit_dekaron_in = ccui.Helper:seekWidgetByName(root,"Panel_limit_dekaron_in_"..i)
        local Panel_limit_leader_icon = ccui.Helper:seekWidgetByName(root,"Panel_limit_leader_icon_"..i)
        local Text_limit_leader_name = ccui.Helper:seekWidgetByName(root,"Text_limit_leader_name_"..i)
        local Text_limit_get_star_n = ccui.Helper:seekWidgetByName(root,"Text_limit_get_star_n_"..i)
        local Text_limit_vs = ccui.Helper:seekWidgetByName(root,"Text_limit_vs_"..i)
        local limit_vs_treasure_box = Panel_limit_dekaron_in:getChildByName("limit_vs_treasure_box_"..i)
        local Panel_limit_vs_bg = ccui.Helper:seekWidgetByName(root,"Panel_limit_vs_bg_"..i)
        local Button_limit_dekaron = ccui.Helper:seekWidgetByName(root,"Button_limit_dekaron_"..i)
        -- local Panel_limit_buff_in = root:getChildByName("Panel_limit_buff_in_"..i)
        Panel_limit_leader_icon:removeAllChildren(true)
        Text_limit_leader_name:setString("")
        Text_limit_get_star_n:setString("")
        Text_limit_vs:setString("")

        local info = _ED.user_extreme_info.challge_info[i]
        local formation_info = {}
        local ship_mould_id = 0 
        local result = 0
        if info ~= nil then
            local formation_tabs = zstring.split(info.formation_info, "|")
            for k, v in pairs(formation_tabs) do
                local info = {}
                local info_tabs = zstring.split(v, ",")
                if ship_mould_id == 0 then
                    ship_mould_id = tonumber(info_tabs[7])
                end
                table.insert(formation_info, info_tabs)
            end
            local vs_info = zstring.split(info.vs_info, ",")
            Text_limit_vs:setString(vs_info[2].."V"..vs_info[1])
            result = tonumber(vs_info[2]) - tonumber(vs_info[1])
            if tonumber(vs_info[1]) > tonumber(vs_info[2]) then
                Panel_limit_vs_bg:setBackGroundImage(string.format(config_res.images.ui.combat.limit_dekaron_bar_vs, 3))
            elseif tonumber(vs_info[1]) == tonumber(vs_info[2]) then
                Panel_limit_vs_bg:setBackGroundImage(string.format(config_res.images.ui.combat.limit_dekaron_bar_vs, 2))
            else
                Panel_limit_vs_bg:setBackGroundImage(string.format(config_res.images.ui.combat.limit_dekaron_bar_vs, 1))
            end
            Text_limit_get_star_n:setString(4-i)
            if tonumber(info.reward_state) == 1 then
                limit_vs_treasure_box:setVisible(true)
            else
                limit_vs_treasure_box:setVisible(false)
            end
        end
        local cell = state_machine.excute("props_icon_create_cell",0,{2,11,ship_mould_id,3,i,false,info.formation_info})
        Panel_limit_leader_icon:addChild(cell) 
        local captain_name = dms.string(dms["ship_mould"], ship_mould_id, ship_mould.captain_name)
        Text_limit_leader_name:setString(captain_name)
        if __lua_project_id == __lua_project_pacific_rim then
            local pic = 0
            if result < 0 then
                pic = 3
            elseif result == 0 then
                pic = 2
            else
                pic = 1
            end
            Button_limit_dekaron:loadTextureNormal(string.format(config_res.images.ui.combat.limit_dekaron_npc_bar, pic))
            Button_limit_dekaron:loadTexturePressed(string.format(config_res.images.ui.combat.limit_dekaron_npc_bar, pic))
        else
            Panel_limit_dekaron_in:runAction(cc.Sequence:create(
                cc.DelayTime:create(0.1),
                cc.MoveTo:create(0.3, cc.p(0, 0))
            ))
        end
        -- Animations_PlayOpenMainUI({Panel_limit_dekaron_in}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN,0.5)
    end
end

function LimitDekaronaCell:onUpdate( dt )
    
end

function LimitDekaronaCell:onEnterTransitionFinish()

end

--初始化列表
function LimitDekaronaCell:onInit( )
    local root = cacher.createUIRef(string.format(config_csb.cells.campaign.limit_dekarona_cell, 1), "root")
    table.insert(self.roots, root)
    self:addChild(root)
    if LimitDekaronaCell.__size == nil then
        LimitDekaronaCell.__size = root:getContentSize()
    end

    for i=1,3 do
        local Panel_limit_dekaron_in = ccui.Helper:seekWidgetByName(root,"Panel_limit_dekaron_in_"..i)
        if __lua_project_id == __lua_project_pacific_rim then
        else
            Panel_limit_dekaron_in:setPositionX(-600)
        end
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_limit_dekaron_"..i), nil, 
        {
            terminal_name = "limit_dekarona_cell_dekaron", 
            terminal_state = 0, 
            cell = self,
            touch_scale = true,
            touch_scale_xy = 0.95, 
            index = i,
        }, nil, 1)
    end

	self:onUpdateDraw()	
end

function LimitDekaronaCell:init(params)
    self:onInit()
    self:setContentSize(LimitDekaronaCell.__size)
    return self
end

function LimitDekaronaCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LimitDekaronaCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.cells.campaign.limit_dekarona_cell, 1))
    root:removeFromParent(false)
    self.roots = {}
end

function LimitDekaronaCell:clearUIInfo( ... )
    local root = self.roots[1]
    for i=1,3 do
        local Panel_limit_leader_icon = ccui.Helper:seekWidgetByName(root,"Panel_limit_leader_icon_"..i)
        local Text_limit_leader_name = ccui.Helper:seekWidgetByName(root,"Text_limit_leader_name_"..i)
        local Text_limit_get_star_n = ccui.Helper:seekWidgetByName(root,"Text_limit_get_star_n_"..i)
        local Text_limit_vs = ccui.Helper:seekWidgetByName(root,"Text_limit_vs_"..i)
        if Panel_limit_leader_icon ~= nil then
            Panel_limit_leader_icon:removeAllChildren(true)
            Text_limit_leader_name:setString("")
            Text_limit_get_star_n:setString("")
            Text_limit_vs:setString("")
        end
    end
end

function LimitDekaronaCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.cells.campaign.limit_dekarona_cell, 1), self.roots[1])
end
