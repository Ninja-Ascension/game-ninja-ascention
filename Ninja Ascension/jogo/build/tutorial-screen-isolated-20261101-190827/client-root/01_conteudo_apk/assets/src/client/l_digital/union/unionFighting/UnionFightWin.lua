UnionFightWin = class("UnionFightWinClass", Window)

function UnionFightWin:ctor()
    self.super:ctor()
    self.roots = {}
    self._fight_type = 0

    local fight_reward_for_union_fight_win_close_terminal = {
        _name = "fight_reward_for_union_fight_win_close",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            _ED._current_scene_id = 0
            _ED._scene_npc_id = 0
            _ED._current_seat_index = -1
            _ED._npc_difficulty_index = 0
            _ED._npc_addition_params = ""
            local fightType = instance._fight_type
			fwin:close(instance)
			fwin:close(fwin:find("BattleSceneClass"))

			cacher.cleanSystemCacher()
			cacher.destoryRefPools()
			cacher.cleanActionTimeline()
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				checkTipBeLeave()
			end				
            cacher.removeAllTextures()
            fwin:reset(nil)
            if fightType == _enum_fight_type._fight_type_107 then
                if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
                    or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge 
                    or __lua_project_id == __lua_project_yugioh 
                    or __lua_project_id == __lua_project_warship_girl_b 
                    then 
                    app.load("client.home.Menu")
                    fwin:open(Menu:new(), fwin._taskbar)
                end
                app.load("client.adventure.campaign.arena.warcraft.AdventureArenaWarcraftList")
                fwin:open(AdventureArenaWarcraftList:new(), fwin._view)
            else
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    app.load("client.l_digital.union.unionFighting.UnionFightingMain")
                else
                    app.load("client.union.unionFighting.UnionFightingMain")
                end
                state_machine.excute("union_fighting_main_open", 0, true)
            end
			
			return true
        end,
        _terminal = nil,
        _terminals = nil
    }
	
    state_machine.add(fight_reward_for_union_fight_win_close_terminal)
    state_machine.init()
end

function UnionFightWin:init(fight_type)
    self._fight_type = fight_type
    return self
end

function UnionFightWin:onEnterTransitionFinish()
    local csbFightRewardUnion = csb.createNode("secret_society/secret_victory.csb")
    local root = csbFightRewardUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbFightRewardUnion)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_victory"), nil, 
    {
        terminal_name = "fight_reward_for_union_fight_win_close",
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, nil, 0)
end

function UnionFightWin:onExit()
	state_machine.remove("fight_reward_for_union_fight_win_close")
end
