-----------------------------
--组队争霸
-----------------------------
UnionTeamFight = class("UnionTeamFightClass", Window)
--打开
local union_team_fight_window_open_terminal = {
    _name = "union_team_fight_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(122) == true then
            return
        end 
        fwin:open(UnionTeamFight:new():init(), fwin._view)
        state_machine.excute("player_resource_window_hide", 0, "")
        state_machine.excute("main_window_hide", 0, "")   
        state_machine.excute("home_button_for_action_window_hide",0,"")
        state_machine.excute("chat_view_window_hide",0,"")
        state_machine.excute("duplicate_title_window_hide",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local union_team_fight_window_close_terminal = {
    _name = "union_team_fight_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("UnionTeamFightClass"))
        
        -- clear cacher
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_team_fight_window_open_terminal)
state_machine.add(union_team_fight_window_close_terminal)
state_machine.init()

function UnionTeamFight:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    app.load("client.utils.ConfirmTip")
    app.load("client.red_alert.battle.battle_enum")
    app.load("client.red_alert.cells.union.union_team_fight_cell")
    app.load("client.red_alert.union.teamFight.UnionTeamFightRule")
    app.load("client.red_alert.union.teamFight.UnionTeamFightCreate")
    app.load("client.red_alert.union.teamFight.UnionTeamFightFormation")
    app.load("client.red_alert.cells.hero.hero_icon_union_team_fight_cell")

    local function init_union_team_fight_terminal()
        --打开规则
        local union_team_fight_rule_terminal = {
            _name = "union_team_fight_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("union_team_fight_rule_window_open",0,{2})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --创建队伍
        local union_team_fight_open_create_terminal = {
            _name = "union_team_fight_open_create",
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
                state_machine.excute("union_team_fight_create_window_open",0,nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新
        local union_team_fight_update_terminal = {
            _name = "union_team_fight_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_team_fight_rule_terminal)
        state_machine.add(union_team_fight_open_create_terminal)
        state_machine.add(union_team_fight_update_terminal)
        state_machine.init()
    end

    init_union_team_fight_terminal()
end 

function UnionTeamFight:onUpdateDraw()
    local root = self.roots[1]
    local isPass = false
    -- 获取npcid
    for i = 1, dms.count( dms["pve_scene"] ) do
        local pve_scene_data = dms.element(dms["pve_scene"], i)
        if dms.atoi(pve_scene_data, pve_scene.scene_type) == battle_enum._fight_type._fight_type_21 then --战斗场景组队争霸
            local npcs = zstring.split(dms.atos(pve_scene_data, pve_scene.npcs), ",")
            local npc = tonumber(npcs[tonumber(_ED.union.user_union_info.team_fight_floor)])
            _ED._current_scene_id = dms.atoi(pve_scene_data, pve_scene.scene_id)
            _ED._scene_npc_id = npc
            isPass = tonumber(_ED.npc_current_attack_count[npc]) > 0
            break
        end
    end
    local npc_data = dms.element(dms["npc"], _ED._scene_npc_id)
    -- npc头像
    local Panel_hero_header = ccui.Helper:seekWidgetByName(root, "Panel_hero_header")
    local base_pic = dms.atoi(npc_data, npc.base_pic)
    local cell = state_machine.excute("hero_icon_union_team_fight_create_cell", 0, {base_pic})
    Panel_hero_header:addChild(cell)

    -- 关卡
    local Text_checkpoint_lv = ccui.Helper:seekWidgetByName(root, "Text_checkpoint_lv")
    Text_checkpoint_lv:setString(string.format(tipStringInfo_union_str[25], _ED.union.user_union_info.team_fight_floor))

    -- npc名字
    local Text_checkpoint_name = ccui.Helper:seekWidgetByName(root, "Text_checkpoint_name")
    local name = dms.atos(npc_data, npc.npc_name)
    Text_checkpoint_name:setString(name)
    
    -- 奖励
    local ListView_reward = ccui.Helper:seekWidgetByName(root, "ListView_reward")
    ListView_reward:removeAllItems()
    local rewardID_first = dms.atoi(npc_data, npc.first_reward) --首杀奖
    local rewardID = dms.atoi(npc_data, npc.drop_library)
    if rewardID_first > 0 then
        local reward_items_first = dms.string(dms["scene_reward"], rewardID_first, scene_reward.reward_items)
        local reward_items = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_items)
        reward_items_first = zstring.split(reward_items_first,"|")
        table.insert(reward_items_first, reward_items)
        for i, reward in ipairs(reward_items_first) do
            local reward_tab = zstring.split(reward, ",")
            local _item_value = tonumber(reward_tab[3])
            local _prop_type = tonumber(reward_tab[2])
            local _prop_item = tonumber(reward_tab[1])
            local data = 
            {
                item_value = _item_value,
                prop_type = _prop_type,
                prop_item = _prop_item,
            }
            local cell = nil
            if _prop_type == 6 then
                local equipment_mould_id = zstring.tonumber(dms.int(dms["prop_mould"], _prop_item, prop_mould.change_of_equipment))
                local ship_mould_id = zstring.tonumber(dms.int(dms["prop_mould"], _prop_item, prop_mould.use_of_ship))
                if equipment_mould_id > 0 or ship_mould_id > 0 then
                    cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,9,0,false,true})
                else
                    cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
                end
                ListView_reward:addChild(cell)
            else
                cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
                ListView_reward:addChild(cell)
            end
        end
    end    

    -- 队伍
    local ListView_team_challenge = ccui.Helper:seekWidgetByName(root, "ListView_team_challenge")
    ListView_team_challenge:removeAllItems()
    local my_team_ids = {}
    if _ED.union.user_union_info.team_fight_team_ids ~= "" then
        my_team_ids = zstring.split(_ED.union.user_union_info.team_fight_team_ids, ",")
    end
    local my_team = {}
    local other_team = {}
    for k,v in pairs(_ED.union.union_team_fight_info_list) do
        local isMyTeam = false
        for k1,v1 in pairs(my_team_ids) do
            if tonumber(v.team_id) == tonumber(v1) then
                isMyTeam = true
                table.insert(my_team, v)
            end
        end
        if isMyTeam == false then
            table.insert(other_team, v)
        end
    end
    for k,v in pairs(other_team) do
        table.insert(my_team, v)
    end

    for k,v in pairs(my_team) do
        local cell = state_machine.excute("union_team_fight_create_cell", 0, {i, v, isPass})
        ListView_team_challenge:addChild(cell)
    end

    ListView_team_challenge:requestRefreshView()
end

function UnionTeamFight:onInit( )
    local csbItem = csb.createNode(config_csb.legion.legion_team_challenge_hero)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "union_team_fight_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --创建队伍
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_creat_team"), nil, 
    {
        terminal_name = "union_team_fight_open_create",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

    --打开规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rule"), nil, 
    {
        terminal_name = "union_team_fight_rule",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw()
end

function UnionTeamFight:onEnterTransitionFinish()
   self:checkReward()
end

function UnionTeamFight:checkReward()
   state_machine.excute("reward_obtain_window_open",0,{37})
end

function UnionTeamFight:init()
	self:onInit()
    return self
end

function UnionTeamFight:onExit()
    state_machine.remove("union_team_fight_rule")
    state_machine.remove("union_team_fight_open_create")
    state_machine.remove("union_team_fight_update")
end