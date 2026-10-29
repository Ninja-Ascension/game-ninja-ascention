MapRaiderscutNpcCell = class("MapRaiderscutNpcCellClass", Window)
MapRaiderscutNpcCell.__size = nil

local map_raiderscut_npc_cell_create_cell_terminal = {
    _name = "map_raiderscut_npc_cell_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = MapRaiderscutNpcCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(map_raiderscut_npc_cell_create_cell_terminal)
state_machine.init()

function MapRaiderscutNpcCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._info = nil

    -- load lua file
    app.load("client.red_alert_time.cells.campaign.raiderscut.raiders_cut_reward_cell")
    app.load("client.battle.fight.FightEnum")

    local function init_map_raiderscut_npc_cell_terminal()
        local map_raiderscut_npc_cell_fight_control_terminal = {
            _name = "map_raiderscut_npc_cell_fight_control",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                app.load("client.utils.ConfirmTip")
                local tip = ConfirmTip:new()
                tip:init(nil, nil, nil, {terminal_name = "map_raiderscut_npc_cell_callback", terminal_state = 0, _datas = params._datas, _msg = string.format(red_alert_all_str[186], cell._info.user_name)})
                fwin:open(tip,fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local map_raiderscut_npc_cell_callback_terminal = {
            _name = "map_raiderscut_npc_cell_callback",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params.status == 1 then
                    state_machine.excute("map_raiderscut_npc_cell_enter_battle", 0, params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local map_raiderscut_npc_cell_enter_battle_terminal = {
            _name = "map_raiderscut_npc_cell_enter_battle",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local max_attack_times = dms.int(dms["raiders_cut_config"],4,raiders_cut_config.param)
                if _ED.raiders_cut_attack_times >= max_attack_times then
                    TipDlg.drawTextDailog(daily_string[9])
                    return
                end
                local cell = params._datas.cell
                if cell == nil or cell.roots == nil or cell._info == nil then
                    return
                end
                app.load("client.red_alert_time.battle.battle_enum")
                local scene_npc_tab = dms.string(dms["raiders_cut_config"],8,raiders_cut_config.param)
                scene_npc_tab = zstring.split(scene_npc_tab,",")
                local scene_id = tonumber(scene_npc_tab[1])
                local npc_id = tonumber(scene_npc_tab[2])
                
                _ED._current_scene_id = scene_id
                _ED._scene_npc_id = npc_id
                _ED._npc_difficulty_index = "1"
                _ED.show_reward_list_group = {}
                _ED.last_level = _ED.user_info.user_grade
                _ED.last_user_food = _ED.user_info.user_food
                _ED._battle_init_type = battle_enum._fight_type._fight_type_10
                _ED.attack_user_id = cell._info.user_id
                _ED.raiders_cut_id = cell._info.raider_id

                _ED.raiders_need_enter_fight = true
                local city_info = zstring.split(dms.string(dms["city_resource_hold_config"], 16, city_resource_hold_config.param), "|")
                for k,v in pairs(city_info) do
                    local info = zstring.split(v, ",")
                    if tonumber(info[1]) == tonumber(cell._info.pos_index) then
                        state_machine.excute("national_city_move_raiderscut_fight", 0, {tonumber(info[2])})
                    end
                end
                -- local function responseBattleStartCallback( response )
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         protocol_command.battle_result_verify.param_list = "" .. _ED.raiders_cut_id
                --         app.load("client.red_alert_time.battle.battle_loading")
                --         state_machine.excute("battle_loading_window_open",0,battle_enum._fight_type._fight_type_10)                                            
                --     end
                -- end
                -- protocol_command.battle_result_start.param_list = ""..battle_enum._fight_type._fight_type_10.."\r\n".."1".."\r\n".._ED.attack_user_id
                -- NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, nil, responseBattleStartCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(map_raiderscut_npc_cell_fight_control_terminal)
        state_machine.add(map_raiderscut_npc_cell_callback_terminal)
        state_machine.add(map_raiderscut_npc_cell_enter_battle_terminal)
        state_machine.init()
    end
    init_map_raiderscut_npc_cell_terminal()
end

function MapRaiderscutNpcCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_raider_npc = ccui.Helper:seekWidgetByName(root,"Panel_raider_npc")
    local Text_raider_name = ccui.Helper:seekWidgetByName(root,"Text_raider_name")
    local Text_raider_fight_n = ccui.Helper:seekWidgetByName(root,"Text_raider_fight_n")
    local Panel_reward_icon = ccui.Helper:seekWidgetByName(root,"Panel_reward_icon")
    Panel_raider_npc:removeAllChildren(true)
    Panel_reward_icon:removeAllChildren(true)

    local spine_index = ""
    if tonumber(self._info.user_sex) == 1 then
        spine_index = "1501_2"
    else
        spine_index = "1511_2"
    end
    local armature = sp.spine_sprite(Panel_raider_npc, spine_index, _spine_sprite_animation_names[90], true, nil, nil, cc.p(0.5, 0))

    Text_raider_name:setString(self._info.user_name)
    Text_raider_fight_n:setString(self._info.user_fight)

    local reward_cell = state_machine.excute("raiders_cut_reward_create_cell", 0, {self._info, 0})
    Panel_reward_icon:addChild(reward_cell)
end

function MapRaiderscutNpcCell:onEnterTransitionFinish()

end

--初始化列表
function MapRaiderscutNpcCell:onInit( )
    local csbItem = csb.createNode(config_csb.cells.big_map.map_raiderscut_npc_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root)
	
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_raider_npc"), nil, 
    {
        terminal_name = "map_raiderscut_npc_cell_fight_control", 
        terminal_state = 0, 
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

	self:onUpdateDraw()	
end

function MapRaiderscutNpcCell:init(params)
    self._index = params[1]
    self._info = params[2]
	self:onInit()
    return self
end

function MapRaiderscutNpcCell:onExit()

end
