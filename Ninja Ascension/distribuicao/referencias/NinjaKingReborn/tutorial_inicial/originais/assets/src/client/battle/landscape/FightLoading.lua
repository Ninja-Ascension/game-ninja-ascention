FightLoadingCell = class("FightLoadingCellClass", Window)

function FightLoadingCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.currentType = 0
	self.totalNum = 5
	self.basePosX = 0
	self.fightWindow = nil
	self.isCreateFight = false
	self.isLoadEffect = false
	self.isCreateCSB = false
	self.isLoadTeam = false
	self.isLoadRole = false
	self.isLoadQte = false
	self.isAddMap = false
	self.isAddController = false
	self.isLoadFightRole = false
	self.isAddFightUI = false
	self.isBeginLoad = false
	self._unload = false
	self._excute_mission = true

	local function init_fight_loading_terminal()
		local fight_loading_update_draw_terminal = {
			_name = "fight_loading_update_draw",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		local fight_loading_execute_mission_terminal = {
			_name = "fight_loading_execute_mission",
			_init = function (terminal)

			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				___stop_mission = true
				fwin:addService({
					callback = function ( params )
						params._excute_mission = false
						___stop_mission = false
						fwin._close_touch_end_event = false
						state_machine.unlock("fight_request_battle")
						state_machine.excute("fight_request_battle", 0, 0)
					end,
					delay = 1,
					params = instance
				})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(fight_loading_update_draw_terminal)
		state_machine.add(fight_loading_execute_mission_terminal)
        state_machine.init()
    end

	init_fight_loading_terminal()
	fwin._close_touch_end_event = true
end

function FightLoadingCell:init( nType )
	self.currentType = nType
	self:onInit()
	return self
end

function FightLoadingCell:createFight( ... )
	self.isLoadEffect = true
	app.load("client.battle.fight.Fight")
	app.load("client.battle.fight.FightEnum")

    fwin:cleanView(fwin._frameview)
	fwin:cleanView(fwin._background)
	fwin:cleanView(fwin._view)
	fwin:cleanView(fwin._viewdialog)
	fwin:cleanView(fwin._taskbar)
	fwin:cleanView(fwin._ui)
	fwin:cleanView(fwin._dialog)
	fwin:cleanView(fwin._notification)
	fwin:cleanView(fwin._screen)
	fwin:cleanView(fwin._system)
	fwin:cleanView(fwin._display_log)

	cacher.cleanSystemCacher()

	cc.Director:getInstance():getTextureCache():addImage("images/ui/battle/battle_1.png")
	cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/battle/battle_1.plist")

	self.fightWindow = Fight:new()
	self.fightWindow:init(self.currentType, _ED._current_scene_id, _ED._scene_npc_id, _ED._npc_difficulty_index, _ED._npc_addition_params)
	self.fightWindow:retain()
	state_machine.excute("fight_begin_load_assets", 0, nil)





end

function FightLoadingCell:onAddLoginLoading( ... )





    self.LoginLoading = LoginLoading:new()
    self:addChild(self.LoginLoading)
end

function FightLoadingCell:onInit( ... )
	_ED.back_by_fighting = true
	fwin:unAllCovers(nil, false, nil)
	if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
	cacher.destoryRefPools()
	fwin:reset(nil)
	cacher.cleanActionTimeline()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		checkTipBeLeave()
	end
	if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
	cacher.destorySystemCacher(nil)
	cacher.removeAllTextures()
	audioUtilUncacheAll()


    local csbBattleLoadingCell = csb.createNode("utils/donghua_loading.csb")
	local root = csbBattleLoadingCell:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbBattleLoadingCell)

	self.Text_loading_01 = ccui.Helper:seekWidgetByName(root, "Text_loading_01")
	self.Text_loading_02 = ccui.Helper:seekWidgetByName(root, "Text_loading_02")
	self.Text_loading_01:setString(_string_piece_info[376])
	self.Text_loading_02:setString("10/100")

	self.Panel_loading_ing = ccui.Helper:seekWidgetByName(root, "Panel_loading_ing")
	self.basePosX = self.Panel_loading_ing:getPositionX()

	self.loadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_112")

	local width = self.loadingBar:getContentSize().width
    self.Panel_loading_ing:setPositionX(self.basePosX + width * self.totalNum/100)

	if tipStringInfo_loading_notice_info ~= nil then
		local count = #tipStringInfo_loading_notice_info
		local id = 1 + math.floor(math.random() * count)
		if id > count then
	        id = count
	    end
	    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		    if nil ~= _ED.scene_current_state and tonumber(_ED.scene_current_state[1]) >= 0 then
		    	if tonumber(_ED.npc_state[1]) <= 0 then
		    		id = 2
				elseif tonumber(_ED.npc_state[2]) <= 0 then
					id = 3
				elseif tonumber(_ED.npc_state[3]) <= 0 then
					id = 4
				end
		    end
		end
	    ccui.Helper:seekWidgetByName(root, "Text_tishi"):setString(tipStringInfo_loading_notice_info[id])
	end

	local action = csb.createTimeline("utils/donghua_loading.csb")
    table.insert(self.actions, action)

    self:unregisterOnNoteUpdate(self)

    csbBattleLoadingCell:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "window_close_over" then
        	fwin:close(self)

        elseif str == "window_open_over" then
        	self.isBeginLoad = true
        end
    end)
    action:play("window_open", false)
	local Panel_donghua = ccui.Helper:seekWidgetByName(root, "Panel_donghua")
	Panel_donghua:setVisible(true)

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
		local random = math.ceil(math.random(0, 3))
	    if nil ~= _ED.scene_current_state and tonumber(_ED.scene_current_state[1]) >= 0 then
	    	if tonumber(_ED.npc_state[1]) <= 0 then
	    		random = 1
			elseif tonumber(_ED.npc_state[2]) <= 0 then
				random = 2
			elseif tonumber(_ED.npc_state[3]) <= 0 then
				random = 3
			end
	    end
	    Image_1:loadTexture(string.format("images/ui/battle/kaichang/zy_%s.png", random))

	else
		local ArmatureNode_2 = Panel_donghua:getChildByName("ArmatureNode_2")
	    local animation = ArmatureNode_2:getAnimation()

	    local function changeActionCallback( armatureBack )
	        local _self = armatureBack._self
	        local actionIndex = armatureBack._actionIndex
	        armatureBack:pause()
	        if actionIndex == 0 then
	        	_self.isBeginLoad = true
	        elseif actionIndex == 2 then
	        	Panel_donghua:setVisible(false)
	        end
	    end

	    local random = math.ceil(math.random(0, 3))
	    local kcIcon = ccs.Skin:create(string.format("images/ui/battle/kaichang/kc_%s.png", random))
	    ArmatureNode_2:getBone("Layer1"):addDisplay(kcIcon, 0)

	    ArmatureNode_2._invoke = changeActionCallback
	    ArmatureNode_2:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
	    ArmatureNode_2._self = self

	    csb.animationChangeToAction(ArmatureNode_2, 0, 0, false)

    end
end

function FightLoadingCell:onUpdate( dt )
	if self.isBeginLoad == false or self._unload == true then
		return
	end
	if nil ~= self.LoginLoading then
		self.LoginLoading:checkLoginLoading(self, false)
	end
	if self.totalNum >= 100 then
		if 1 == tonumber(_ED.user_info.user_grade) and 0 == tonumber(_ED.user_info.user_experience) then
			if self._excute_mission == true then
				self:executeMission()
			else
				self:loadingSuccess()
			end
		else
			self:loadingSuccess()
		end
		return
	elseif self.totalNum >= 20 and self.totalNum <= 30 and self.isLoadEffect == false then
		self:createFight()
	elseif self.totalNum >= 31 and self.totalNum <= 36 and self.isCreateCSB == false then
		self.isCreateCSB = true
		self.fightWindow:initTigerGateMap()
	elseif self.totalNum >= 38 and self.totalNum <= 43 and self.isLoadTeam == false then
		self.isLoadTeam = true
		self.fightWindow:loadTigerGateFight(1)
	elseif self.totalNum >= 45 and self.totalNum <= 53 and self.isLoadQte == false then
		self.isLoadQte = true
		self.fightWindow:loadTigerGateFight(2)
	elseif self.totalNum >= 55 and self.totalNum <= 60 and self.isLoadRole == false then
		self.isLoadRole = true
		self.fightWindow:loadTigerGateFight(3)
	elseif self.totalNum >= 63 and self.totalNum <= 70 and self.isAddMap == false then
		self.isAddMap = true
		self.fightWindow:addTigerGateMap()
	elseif self.totalNum >= 72 and self.totalNum <= 83 and self.isAddController == false then
		self.isAddController = true
		self.fightWindow:addTigerGateController()
	elseif self.totalNum >= 85 and self.totalNum <= 90 and self.isLoadFightRole == false then
		self.isLoadFightRole = true
		app.load("client.battle.report.BattleReport")
		state_machine.excute("fight_role_controller_load_success", 0, nil)
	elseif self.totalNum >= 95 and self.totalNum <= 98 and self.isAddFightUI == false then
		self.isAddFightUI = true
		self.fightWindow:addTigerGateFightUI()
	end
	self.totalNum = self.totalNum + 1

	local width = self.loadingBar:getContentSize().width
    self.Panel_loading_ing:setPositionX(self.basePosX + width * self.totalNum/100)

	self.loadingBar:setPercent(self.totalNum)
	self.Text_loading_02:setString(self.totalNum.."/100")
end

function FightLoadingCell:executeMission()
	if missionIsOver() == true then
		if 1 == tonumber(_ED.user_info.user_grade) and 0 == tonumber(_ED.user_info.user_experience) then
			if executeMissionExt(mission_mould_battle, touch_off_mission_start_battle, "".._ED._scene_npc_id.."v".._ED.battleData._currentBattleIndex, nil) == true then
				state_machine.lock("fight_request_battle")
				self:setVisible(false)
			else
				self._excute_mission = false
			end
		end
	end
end

function FightLoadingCell:loadingSuccess( ... )
	if nil ~= self.LoginLoading then
		playBgm(formatMusicFile("background", 3))
	end
	cc.Director:getInstance():getTextureCache():addImage("images/ui/battle/battle_1.png")
	cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/battle/battle_1.plist")
	self:unregisterOnNoteUpdate(self)
	fwin:open(self.fightWindow, fwin._view)
	self.fightWindow:release()
    if missionIsOver() == false then
		if checkEventType(execute_type_role_restart, 1) == true then
			executeNextEvent(nil, true)
		end
    end
    self:closeUi()
end

function FightLoadingCell:closeUi( ... )
	local action = self.actions[1]
    action:play("window_close", false)
    local root = self.roots[1]
    self.Panel_loading_ing:setVisible(false)
    local Panel_donghua = ccui.Helper:seekWidgetByName(root, "Panel_donghua")
	local ArmatureNode_2 = Panel_donghua:getChildByName("ArmatureNode_2")
	if ArmatureNode_2 ~= nil then
		ArmatureNode_2:resume()
	    csb.animationChangeToAction(ArmatureNode_2, 2, 2, false)

	end
    collectgarbage("stop")
end

function FightLoadingCell:onEnterTransitionFinish()

end

function FightLoadingCell:onExit()
	state_machine.remove("battle_loading_update_draw")
end

function FightLoadingCell:onArmatureDataLoad( ... )

end

function FightLoadingCell:onArmatureDataLoadEx( ... )

end

function FightLoadingCell:loadArmature( ... )
	local path = "images/ui/effice/effect_kaichang/effect_kaichang.ExportJson"

	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path)
end

function FightLoadingCell:unLoadArmature( ... )
	local path = "images/ui/effice/effect_kaichang/effect_kaichang.ExportJson"
	ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(path)
end

function FightLoadingCell:close( window )
	if _ED.battleData and _ED.battleData.battle_init_type == _enum_fight_type._fight_type_211 then
		app.load("client.battle.fight.BattlePause")
		app.load("client.battle.landscape.TheKingsBattleReadyWindow")
		state_machine.excute("the_kings_battle_ready_window_open", 0, table.nums(_ED.battleData.__heros))
		state_machine.excute("battle_pause", 0, 0)
	end

	if true == app.configJson.displayAll then
		app.load("client.battle.landscape.RoleInfoDebug")
		state_machine.excute("role_info_debug_window_open", 0, 0)
	end
end
