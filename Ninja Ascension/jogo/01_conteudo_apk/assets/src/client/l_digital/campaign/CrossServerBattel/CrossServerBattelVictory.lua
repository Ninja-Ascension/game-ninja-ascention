-- ----------------------------------------------------------------------------------------------------
-- 说明：跨服矿战结算界面
-------------------------------------------------------------------------------------------------------
CrossServerBattelVictory = class("CrossServerBattelVictoryClass", Window)

local sm_arena_battle_reward_open_terminal = {
    _name = "cross_server_battel_victory_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("CrossServerBattelVictoryClass")
        if nil == _homeWindow then
            local panel = CrossServerBattelVictory:new():init(params)
            fwin:open(panel,fwin._window)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_arena_battle_reward_close_terminal = {
    _name = "cross_server_battel_victory_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("CrossServerBattelVictoryClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("CrossServerBattelVictoryClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_arena_battle_reward_open_terminal)
state_machine.add(sm_arena_battle_reward_close_terminal)
state_machine.init()
    
function CrossServerBattelVictory:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    self.battle_type = 0

    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.ship.hero_icon_list_cell")
    app.load("client.cells.ship.ship_icon_cell")

    local function init_sm_arena_battle_reward_terminal()

        --退出
        local sm_arena_battle_reward_drop_out_terminal = {
            _name = "cross_server_battel_victory_drop_out",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local fightType = instance.battle_type
                _ED.battle_playback_arena = {}
                _ED._current_scene_id = 0
				_ED._scene_npc_id = 0
				_ED._current_seat_index = -1
				_ED._npc_difficulty_index = 0
				_ED._npc_addition_params = ""
				fwin:close(instance)
				fwin:close(fwin:find("BattleSceneClass"))

				cacher.cleanSystemCacher()
				cacher.destoryRefPools()
				cacher.cleanActionTimeline()
				if __lua_project_id == __lua_project_gragon_tiger_gate
                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
					checkTipBeLeave()
				end				
				cacher.removeAllTextures()
				fwin:reset(nil)

				app.load("client.home.Menu")
				if fwin:find("MenuClass") == nil then
					fwin:open(Menu:new(), fwin._taskbar)
				end

                app.load("client.l_digital.campaign.Campaign")
                state_machine.excute("campaign_window_open", 0, nil)
                app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelMap")
                state_machine.excute("cross_server_battel_map_window_open", 0, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 再看一次
        local cross_server_battel_victory_play_again_terminal = {
            _name = "cross_server_battel_victory_play_again",
            _init = function (terminal) 
                app.load("client.battle.BattleStartEffect")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

                local function callback3(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- print("再看一次请求完毕")
                        -- 初始第一场的数据
                        _ED.battleData = _ED.crossServer_battleData[1]
                        _ED.attackData = _ED.crossServer_attackData[1]

                        _ED.battleData._battle_start_influence_info = _ED.crossServer_battle_start_influence_info[1]
                        _ED.battleData._battle_round_influence_infos = _ED.crossServer_battle_round_influence_infos[1]
                        _ED.battleData._camp_change_influence_infos = _ED.crossServer_start_influence_info[1]

                        -- 记录三场的输赢情况
                        _ED.cross_server_battel_result = {}
                        table.insert(_ED.cross_server_battel_result, _ED.attackData.isWin)

                        fwin:cleanView(fwin._windows)
                        fwin:freeAllMemeryPool()

                        app.load("client.battle.BattleStartEffect")
                        app.load("client.battle.fight.FightEnum") 

                        local bse = BattleStartEffect:new()
                        bse:init(_enum_fight_type._fight_type_214)
                        fwin:open(bse, fwin._windows)

                        -- 初始第一场的数据
                        _ED.battleData = _ED.crossServer_battleData[1]
                        _ED.attackData = _ED.crossServer_attackData[1]

                        _ED.battleData._battle_start_influence_info = _ED.crossServer_battle_start_influence_info[1]
                        _ED.battleData._battle_round_influence_infos = _ED.crossServer_battle_round_influence_infos[1]
                        _ED.battleData._camp_change_influence_infos = _ED.crossServer_start_influence_info[1]

                        -- 记录三场的输赢情况
                        _ED.cross_server_battel_result = {}
                        table.insert(_ED.cross_server_battel_result, _ED.attackData.isWin)
                    end
                end

                local function callback2(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        protocol_command.cross_mine_load_battle_info.param_list = _ED.cross_server_battel_grab_other_formation2.index .. "\r\n" .. 3
                        NetworkManager:register(protocol_command.cross_mine_load_battle_info.code, nil, nil, nil, self, callback3, false, nil)
                    end
                end

                local function callback1(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        protocol_command.cross_mine_load_battle_info.param_list = _ED.cross_server_battel_grab_other_formation2.index .. "\r\n" .. 2
                        NetworkManager:register(protocol_command.cross_mine_load_battle_info.code, nil, nil, nil, self, callback2, false, nil)
                    end
                end

                -- print("开始请求再看一次")

                -- 清空跨服战的战斗数据缓存
                _ED.crossServer_battleData = {}
                _ED.crossServer_attackData = {}
                _ED.crossServer_battle_start_influence_info = {}
                _ED.crossServer_battle_round_influence_infos = {}
                _ED.crossServer_start_influence_info = {}

                protocol_command.cross_mine_load_battle_info.param_list = _ED.cross_server_battel_grab_other_formation2.index .. "\r\n" .. 1
                NetworkManager:register(protocol_command.cross_mine_load_battle_info.code, nil, nil, nil, self, callback1, false, nil)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_arena_battle_reward_drop_out_terminal)
        state_machine.add(cross_server_battel_victory_play_again_terminal)
        state_machine.init()

    end
    
    init_sm_arena_battle_reward_terminal()
end

function CrossServerBattelVictory:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    -- 名称
    local Text_name_1 = ccui.Helper:seekWidgetByName(root,"Text_name_1")
    local Text_name_2 = ccui.Helper:seekWidgetByName(root,"Text_name_2")
    Text_name_1:setString(_ED.battleData.attacker_name .. "(" .. _ED.cross_server_battel_ui_result.serverName1 .. ")")
    Text_name_2:setString(_ED.battleData.defender_name .. "(" .. _ED.cross_server_battel_ui_result.serverName2 .. ")")

    -- 结果
    local battleResult = tonumber(_ED.cross_server_battel_grab_other_formation2.BattleResult)
    local Text_score_1 = ccui.Helper:seekWidgetByName(root, "Text_score_1")
    Text_score_1:setString(battleResult)
    local Text_score_2 = ccui.Helper:seekWidgetByName(root, "Text_score_2")
    Text_score_2:setString(3 - battleResult)

    -- 排名
    local Text_rank_n_1 = ccui.Helper:seekWidgetByName(root, "Text_rank_n_1")
    Text_rank_n_1:setString(_ED.cross_server_battel_ui_result.rank1)
    local Text_rank_n_2 = ccui.Helper:seekWidgetByName(root, "Text_rank_n_2")
    Text_rank_n_2:setString(_ED.cross_server_battel_ui_result.rank2)

    -- 速度
    local Text_res_speed_n_1 = ccui.Helper:seekWidgetByName(root, "Text_res_speed_n_1")
    Text_res_speed_n_1:setString(_ED.cross_server_battel_ui_result.lootProduction .. "/10m")
    local Text_res_speed_n_2 = ccui.Helper:seekWidgetByName(root, "Text_res_speed_n_2")
    Text_res_speed_n_2:setString(_ED.cross_server_battel_ui_result.byLootProduction .. "/10m")

    -- 抢夺的资源
    local Text_res_snatch_n_1 = ccui.Helper:seekWidgetByName(root, "Text_res_snatch_n_1")
    Text_res_snatch_n_1:setString(_ED.cross_server_battel_ui_result.canLootMineNum)

    self.actions[1]:play("text_open", false)
    self.actions[1]:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "over" then
            local Panel_bifen_dh = ccui.Helper:seekWidgetByName(root, "Panel_bifen_dh")
            local jsonFile = "images/ui/effice/effect_zdjs/effect_zdjs.json" 
            local atlasFile = "images/ui/effice/effect_zdjs/effect_zdjs.atlas" 
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            animation.animationNameList = {"animation"}
            sp.initArmature(animation, false)
            animation._invoke = changeActionCallback
            Panel_bifen_dh:addChild(animation)
            animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
            csb.animationChangeToAction(animation, 0, 1, false)

             --胜利动画
            local Panel_win_dh = ccui.Helper:seekWidgetByName(root,"Panel_win_dh")

            local jsonFile = "sprite/spirte_shengli.json"
            local atlasFile = "sprite/spirte_shengli.atlas"
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "chuxian", true, nil)
            animation.animationNameList = {"chuxian","xunhuan"}
            sp.initArmature(animation, false)
            local function changeActionCallback( armatureBack )
            end
            animation._invoke = changeActionCallback
            animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
            csb.animationChangeToAction(animation, 0, 1, false)
            Panel_win_dh:addChild(animation)
        end
    end)

end

function CrossServerBattelVictory:init(params)
    self.battle_type = params
    self:onInit()
    return self
end

function CrossServerBattelVictory:onInit()
    local csbCrossServerBattelVictory = csb.createNode("campaign/cross_service/cross_service_battle_victory.csb")
    local root = csbCrossServerBattelVictory:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbCrossServerBattelVictory)
    local action = csb.createTimeline("campaign/cross_service/cross_service_battle_victory.csb")
    table.insert(self.actions, action)
    csbCrossServerBattelVictory:runAction(action)
    -- playEffect(formatMusicFile("effect", 9996))
    self:onUpdateDraw()

	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_exit"), nil, 
    {
        terminal_name = "cross_server_battel_victory_drop_out",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil, 3)

    --再看一次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_playback"), nil, 
    {
        terminal_name = "cross_server_battel_victory_play_again",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil, 3)
end

function CrossServerBattelVictory:onExit()
    state_machine.remove("cross_server_battel_victory_drop_out")
    state_machine.remove("cross_server_battel_victory_play_again")
end