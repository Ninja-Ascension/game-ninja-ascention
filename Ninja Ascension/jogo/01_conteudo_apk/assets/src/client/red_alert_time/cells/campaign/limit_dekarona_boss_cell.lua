-- ---------------------------
-- 极限挑战Boss cell
-- ---------------------------
LimitDekaronaBossCell = class("LimitDekaronaBossCellClass", Window)
LimitDekaronaBossCell.__size = nil

local limit_dekarona_boss_create_cell_terminal = {
    _name = "limit_dekarona_boss_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LimitDekaronaBossCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(limit_dekarona_boss_create_cell_terminal)
state_machine.init()

function LimitDekaronaBossCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._formation_info = nil
    app.load("client.red_alert_time.cells.leader.leader_big_head_cell")
    local function init_limit_dekarona_boss_cell_terminal()
        local limit_dekarona_boss_cell_dekaron_terminal = {
            _name = "limit_dekarona_boss_cell_dekaron",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local fight_type = battle_enum._fight_type._fight_type_202
                local scene_id = 1
                local npc_id = 1
                state_machine.excute("adventure_mine_request_battle_field_init", 0, {fight_type, scene_id, npc_id, 0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local limit_dekarona_boss_cell_infor_terminal = {
            _name = "limit_dekarona_boss_cell_infor",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if __lua_project_id == __lua_project_pacific_rim then
                    _ED._battle_init_type = battle_enum._fight_type._fight_type_202
                    _ED._current_scene_id = 1
                    _ED._scene_npc_id = 1
                    _ED._npc_difficulty_index = 0
                    state_machine.excute("formation_defend_attack_open", 0, {2, 1})
                    state_machine.excute("formation_defend_attack_add_legion_formation_info", 0, {cell._formation_info, 1})
                else
                    state_machine.excute("legion_pk_attack_open", 0, {cell._formation_info, 1})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(limit_dekarona_boss_cell_dekaron_terminal)
        state_machine.add(limit_dekarona_boss_cell_infor_terminal)
        state_machine.init()
    end
    
    init_limit_dekarona_boss_cell_terminal()
end

--刷新列表数据
function LimitDekaronaBossCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_limit_leader_icon = ccui.Helper:seekWidgetByName(root,"Panel_limit_leader_icon")
    local Text_limit_get_star_n = ccui.Helper:seekWidgetByName(root,"Text_limit_get_star_n")
    local Text_limit_leader_vs = ccui.Helper:seekWidgetByName(root,"Text_limit_leader_vs")
    local Panel_limit_vs_bg = root:getChildByName("Panel_limit_vs_bg")
    local Panel_limit_leader_effect = root:getChildByName("Panel_limit_leader_effect")
    
    Panel_limit_leader_icon:removeAllChildren(true)
    Text_limit_get_star_n:setString("")
    Text_limit_leader_vs:setString("")
    Panel_limit_leader_effect:removeAllChildren(true)
    local formation_info = {}
    local ship_mould_id = 0 
    local info = _ED.user_extreme_info.challge_info[1]
    if info ~= nil then
        self._formation_info = info.formation_info
        local formation_tabs = zstring.split(info.formation_info, "|")
        for k, v in pairs(formation_tabs) do
            local info = {}
            local info_tabs = zstring.split(v, ",")
            if k == 1 then
                ship_mould_id = tonumber(info_tabs[7])
            end
            table.insert(formation_info, info_tabs)
        end
        local vs_info = zstring.split(info.vs_info, ",")
        Text_limit_leader_vs:setString(vs_info[2].."V"..vs_info[1])
        if tonumber(vs_info[1]) > tonumber(vs_info[2]) then
            Panel_limit_vs_bg:setBackGroundImage(string.format(config_res.images.ui.combat.limit_dekaron_bar_vs, 1))
        elseif tonumber(vs_info[1]) == tonumber(vs_info[2]) then
            Panel_limit_vs_bg:setBackGroundImage(string.format(config_res.images.ui.combat.limit_dekaron_bar_vs, 2))
        else
            Panel_limit_vs_bg:setBackGroundImage(string.format(config_res.images.ui.combat.limit_dekaron_bar_vs, 3))
        end
        Text_limit_get_star_n:setString(3)
        if tonumber(info.reward_state) == 1 then
        else
        end
    end
    local cell = state_machine.excute("leader_big_head_create_cell", 0, {ship_mould_id})
    Panel_limit_leader_icon:addChild(cell) 
    Panel_limit_leader_icon:setScale(2.5)
    Panel_limit_leader_icon:runAction(cc.Sequence:create(
        cc.DelayTime:create(0.2),
        cc.ScaleTo:create(0.1, 1)
    ))
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_leader)
    local armature = ccs.Armature:create("effect_leader")
    armature:getAnimation():playWithIndex(0)
    armature:setPosition(cc.p(Panel_limit_leader_effect:getContentSize().width/2,Panel_limit_leader_effect:getContentSize().height/2))
    Panel_limit_leader_effect:addChild(armature)
end

function LimitDekaronaBossCell:onUpdate( dt )
    
end

function LimitDekaronaBossCell:onEnterTransitionFinish()

end

--初始化列表
function LimitDekaronaBossCell:onInit( )
    local root = cacher.createUIRef(string.format(config_csb.cells.campaign.limit_dekarona_cell, 2), "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if LimitDekaronaBossCell.__size == nil then
        LimitDekaronaBossCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_limit_dekaron"), nil, 
    {
        terminal_name = "limit_dekarona_boss_cell_dekaron", 
        terminal_state = 0, 
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_limit_leader_icon"), nil, 
    {
        terminal_name = "limit_dekarona_boss_cell_infor", 
        terminal_state = 0, 
        cell = self,
    }, nil, 1)

	self:onUpdateDraw()	
end

function LimitDekaronaBossCell:init(params)
    self:onInit()
    self:setContentSize(LimitDekaronaBossCell.__size)
    return self
end

function LimitDekaronaBossCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.cells.campaign.limit_dekarona_cell, 2), self.roots[1])
end

function LimitDekaronaBossCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LimitDekaronaBossCell:clearUIInfo()
    local root = self.roots[1]
    if root ~= nil then
        local Panel_limit_leader_icon = ccui.Helper:seekWidgetByName(root,"Panel_limit_leader_icon")
        local Text_limit_get_star_n = ccui.Helper:seekWidgetByName(root,"Text_limit_get_star_n")
        local Text_limit_leader_vs = ccui.Helper:seekWidgetByName(root,"Text_limit_leader_vs")
        local Panel_limit_vs_bg = root:getChildByName("Panel_limit_vs_bg")
        local Panel_limit_leader_effect = root:getChildByName("Panel_limit_leader_effect")
        if Panel_limit_leader_icon ~=nil then
            Panel_limit_leader_icon:removeAllChildren(true)
            Text_limit_get_star_n:setString("")
            Text_limit_leader_vs:setString("")
            Panel_limit_vs_bg:removeBackGroundImage()
            Panel_limit_leader_effect:removeAllChildren(true)
        end
    end
end

function LimitDekaronaBossCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.cells.campaign.limit_dekarona_cell, 2))
    root:removeFromParent(false)
    self.roots = {}
end


