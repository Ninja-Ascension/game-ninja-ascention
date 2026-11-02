CaptureResourceWin = class("CaptureResourceWinClass", Window)

function CaptureResourceWin:ctor()
    self.super:ctor()
    self.roots = {}

    local fight_reward_ror_capture_win_close_terminal = {
        _name = "fight_reward_ror_capture_win_close",
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

			app.load("client.home.Menu")
			if fwin:find("MenuClass") == nil then
				fwin:open(Menu:new(), fwin._taskbar)
			end

			app.load("client.captureResource.CaptureResourceMain")
        	state_machine.excute("capture_resource_open", 0, nil)
			return true
        end,
        _terminal = nil,
        _terminals = nil
    }
	local fight_reward_ror_open_three_choice_one_terminal = {
        _name = "fight_reward_ror_open_three_choice_one",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        -- print("===================")
			app.load("client.battle.BattleWinCardLottery")
			local battleWinCardLottery = BattleWinCardLottery:new()
			battleWinCardLottery:init(_enum_fight_type._fight_type_106)
			fwin:open(battleWinCardLottery, fwin._view) 
			instance:setVisible(false)
			return true
        end,
        _terminal = nil,
        _terminals = nil
    }
    state_machine.add(fight_reward_ror_capture_win_close_terminal)
    state_machine.add(fight_reward_ror_open_three_choice_one_terminal)
    state_machine.init()
end

function CaptureResourceWin:init()
end

function CaptureResourceWin:onEnterTransitionFinish()
    local csbFightRewardCaptureWin = csb.createNode("secret_society/secret_victory.csb")
    local root = csbFightRewardCaptureWin:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbFightRewardCaptureWin)

 --    local Panel_win_open = ccui.Helper:seekWidgetByName(root, "Panel_win_open")
 --    local ArmatureNode_4 = Panel_win_open:getChildByName("ArmatureNode_4")

 --    local action = csb.createTimeline("duplicate/GameActivity/GameActivity_victory.csb")
 --    csbFightRewardCaptureWin:runAction(action)
 --    action:play("window_open_win", false)
	-- action:setFrameEventCallFunc(function (frame)
	-- 	if nil == frame then
	-- 		return
	-- 	end

	-- 	local str = frame:getEvent()
	-- 	if str == "window_open_win_over" then
	-- 		ArmatureNode_4:setVisible(true)
	-- 		csb.animationChangeToAction(ArmatureNode_4, 0, 0, nil)
	-- 	elseif str == "over" then
	-- 		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_7"), nil, 
	-- 	    {
	-- 	        terminal_name = "fight_reward_ror_capture_win_close",
	-- 	        terminal_state = 0, 
	-- 	        isPressedActionEnabled = false
	-- 	    }, nil, 0)
	-- 	end
	-- end)
	
	-- draw.initArmature(ArmatureNode_4, nil, -1, 0, 1)
	-- ArmatureNode_4:getAnimation():playWithIndex(0, 0, 0)
	-- ArmatureNode_4:setVisible(false)
	
	-- ArmatureNode_4._invoke = function(armatureBack)
	-- 	armatureBack:setVisible(false)
	-- 	action:play("window_open", false)
	-- 	armatureBack._invoke = nil
	-- end

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_victory"), nil, 
    {
        terminal_name = "fight_reward_ror_open_three_choice_one",
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, nil, 0)
end

function CaptureResourceWin:onExit()
	state_machine.remove("fight_reward_ror_capture_win_close")
	state_machine.remove("fight_reward_ror_open_three_choice_one")
end
