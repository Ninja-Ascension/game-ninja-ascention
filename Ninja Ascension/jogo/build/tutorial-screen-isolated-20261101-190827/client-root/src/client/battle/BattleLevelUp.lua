-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗结束后主将升级
-- 创建时间2014-03-02 22:07
-- 作者：周义文
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

BattleLevelUp = class("BattleLevelUpClass", Window)


local battle_level_up_window_open_terminal = {
    _name = "battle_level_up_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local clv = tonumber(_ED.user_info.user_grade)
        if clv < 7 then
        	return false
        end
        if nil == fwin:find("BattleLevelUpClass") then
            fwin:open(BattleLevelUp:new():init(params), fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_level_up_window_open_mission_terminal = {
    _name = "battle_level_up_window_open_mission",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("BattleLevelUpClass") then
        	___stop_mission = true
            fwin:open(BattleLevelUp:new():init(params), fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}


local battle_level_up_window_close_terminal = {
    _name = "battle_level_up_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattleLevelUpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_level_up_window_open_terminal)
state_machine.add(battle_level_up_window_open_mission_terminal)
state_machine.add(battle_level_up_window_close_terminal)
state_machine.init()

function BattleLevelUp:ctor()
    self.super:ctor()
	self.roots = {}
	app.load("client.cells.battle.battle_function_open_cell")
	app.load("client.battle.fight.FightEnum")

	local _level = dms.string(dms["fun_open_condition"],51, fun_open_condition.level)
	if tonumber(_ED.user_info.user_grade) ==  tonumber(_level) then
		local screenSize = cc.Director:getInstance():getOpenGLView():getFrameSize()
		local currentAccount = _ED.user_platform[_ED.default_user].platform_account
		local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
		local saveKey = currentAccount..currentServerNumber.."chatViewDialog".."end"
		local x,y = 0,(screenSize.height/2 + 100 * app.scaleFactor) / app.scaleFactor
		local str = x .. "," .. y .. "," .. "1"
		cc.UserDefault:getInstance():setStringForKey(saveKey, str)
		app.load("client.chat.ChatHomeView")
		state_machine.excute("chat_show_self",0,"chat_show_self")
	end

    local function init_BattleLevelUp_terminal()
		local battle_level_up_close_terminal = {
            _name = "battle_level_up_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(instance)
				smFightingChange()
				if nil ~= _ED.battleData and nil ~= _ED.battleData.battle_init_type then
					-- 副本战斗中
					if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_0 or
						_ED.battleData.battle_init_type == _enum_fight_type._fight_type_1 or
						_ED.battleData.battle_init_type == _enum_fight_type._fight_type_2 or
						_ED.battleData.battle_init_type == _enum_fight_type._fight_type_3 or
						_ED.battleData.battle_init_type == _enum_fight_type._fight_type_4 or
						_ED.battleData.battle_init_type == _enum_fight_type._fight_type_51 or
						_ED.battleData.battle_init_type == _enum_fight_type._fight_type_52 or
						_ED.battleData.battle_init_type == _enum_fight_type._fight_type_54 or
						_ED.battleData.battle_init_type == _enum_fight_type._fight_type_9 or
						_ED.battleData.battle_init_type == _enum_fight_type._fight_type_108 
						then
						
						if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2
							or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3
							or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4
							or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_51
							or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_52 then
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					        	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
					        	then
								-- fwin:open(Menu:new(), fwin._taskbar)
								-- state_machine.excute("menu_manager", 1, {_datas = {next_terminal_name = "menu_show_home_page", but_image = 1}})
								-- fwin:removeAll()
								-- cacher.removeAllObject(_object)
								fwin:close(fwin:find("BattleSceneClass"))
				                cacher.removeAllTextures()
				                fwin:reset(nil)
								-- fwin:removeAll()
								app.load("client.home.Menu")
								fwin:open(Menu:new(), fwin._taskbar)
								if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				                    if fwin:find("HomeClass") == nil then
				                        state_machine.excute("menu_manager", 0, 
				                            {
				                                _datas = {
				                                    terminal_name = "menu_manager",     
				                                    next_terminal_name = "menu_show_home_page", 
				                                    current_button_name = "Button_home",
				                                    but_image = "Image_home",       
				                                    terminal_state = 0, 
				                                    _needOpenHomeHero = true,
				                                    isPressedActionEnabled = true
				                                }
				                            }
				                        )
				                    end
				                    state_machine.excute("menu_back_home_page", 0, "")
                        			state_machine.excute("home_change_open_atrribute", 0, false)
				                end
								state_machine.excute("explore_window_open", 0, 0)
								state_machine.excute("explore_window_open_fun_window", 0, nil)
								return true
							end
						end

						local win = fwin:find("BattleSceneClass")
						local fight = fwin:find("FightClass")
						if nil ~= fight then
							fwin:close(win)
							cacher.removeAllTextures()
							fwin:reset(nil)
							app.load("client.home.Menu")
							fwin:open(Menu:new(), fwin._taskbar)
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			                    if fwin:find("HomeClass") == nil then
			                        state_machine.excute("menu_manager", 0, 
			                            {
			                                _datas = {
			                                    terminal_name = "menu_manager",     
			                                    next_terminal_name = "menu_show_home_page", 
			                                    current_button_name = "Button_home",
			                                    but_image = "Image_home",       
			                                    terminal_state = 0, 
			                                    _needOpenHomeHero = true,
			                                    isPressedActionEnabled = true
			                                }
			                            }
			                        )
			                    end
			                end
							state_machine.excute("menu_show_duplicate_goto_last_view", 0, nil)
						end
					end
				else
					if missionIsOver() == true then
						if executeMissionExt(mission_mould_tuition, touch_off_mission_ls_scene, "".._ED.user_info.user_grade, nil, false, nil, false) == false then
							if missionIsOver() == false then
						        local windowLock = fwin:find("WindowLockClass")
						        if windowLock == nil then
						            fwin:open(WindowLock:new():init(), fwin._windows)
						        end
						    	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						    		-- 回到主页
						    		fwin:close(fwin:find("BattleSceneClass"))
					                cacher.removeAllTextures()
					                fwin:reset(nil)
									-- fwin:removeAll()
									app.load("client.home.Menu")
									fwin:open(Menu:new(), fwin._taskbar)
									if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					                    if fwin:find("HomeClass") == nil then
					                        state_machine.excute("menu_manager", 0, 
					                            {
					                                _datas = {
					                                    terminal_name = "menu_manager",     
					                                    next_terminal_name = "menu_show_home_page", 
					                                    current_button_name = "Button_home",
					                                    but_image = "Image_home",       
					                                    terminal_state = 0, 
					                                    _needOpenHomeHero = true,
					                                    isPressedActionEnabled = true
					                                }
					                            }
					                        )
					                    end
					                    state_machine.excute("menu_back_home_page", 0, "")
	                        			state_machine.excute("home_change_open_atrribute", 0, false)
					                end
									-- state_machine.excute("explore_window_open", 0, 0)
									-- state_machine.excute("explore_window_open_fun_window", 0, nil)
						    	end
								executeNextEvent(nil, true)
						    end
						end
					end
				end
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					if fwin:find("HomeClass") ~= nil then
	                    state_machine.excute("home_update_first_recharge", 0, "")
	                end
                end

		        if ___stop_mission == true then
		        	___stop_mission = false
		        	executeNextEvent(nil, true)
		        end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(battle_level_up_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_BattleLevelUp_terminal()
end

function BattleLevelUp:init(params)
	return self
end

function BattleLevelUp:upDataDraw()
	local root = self.roots[1]
	
	local currentLV = ccui.Helper:seekWidgetByName(root, "Text_lzy001_1")	--升级之前等级
	local currentPS = ccui.Helper:seekWidgetByName(root, "Text_ranliao002_1")	--升级之前体力
	local currentEnergy = ccui.Helper:seekWidgetByName(root, "Text_danyao003_1")	--升级之前精力
	if tonumber(_ED.user_info.last_user_grade) == tonumber(_ED.user_info.user_grade) then
		_ED.user_info.last_user_grade = tonumber(_ED.user_info.user_grade) - 1
	end
	if tonumber(_ED.user_info.user_grade) == 7 then
		_ED.user_info.last_user_grade = tonumber(_ED.user_info.user_grade) - 1
	end
	currentLV:setString(_ED.user_info.last_user_grade)
	currentPS:setString(_ED.user_info.last_user_food)
	currentEnergy:setString(_ED.user_info.last_endurance)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		if _ED.arena_is_level_up == true then
			_ED.arena_is_level_up = false 
			currentLV:setString(_ED.last_grade)
			currentPS:setString(_ED.last_food)
			currentEnergy:setString(_ED.last_endurance)

			_ED.last_grade = 0
			_ED.last_food = 0
			_ED.last_endurance = 0			
		end
	end
	--数码显示体力上限
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		currentEnergy:setString(dms.string(dms["user_experience_param"] ,tonumber(_ED.user_info.last_user_grade), user_experience_param.combatFoodCapacity))
	end	
	jttd.NewAPPeventSlogger("3|".._ED.user_info.user_grade)
	local _currentLV = ccui.Helper:seekWidgetByName(root, "Text_lzy001_2")	--升级之后等级
	local _currentPS = ccui.Helper:seekWidgetByName(root, "Text_ranliao002_2")	--升级之后体力
	local _currentEnergy = ccui.Helper:seekWidgetByName(root, "Text_danyao003_2")	--升级之后精力
	_currentLV:setString(_ED.user_info.user_grade)
	_currentPS:setString(_ED.user_info.user_food)
	_currentEnergy:setString(_ED.user_info.endurance)
	local myListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	-- upgrade_open_function = {
	-- id = 1,						-- int(11)	notnull	主键，自增
	-- grade = 2,					-- int(3)		等级
	-- functions = 3,				-- varchar(255)		功能(1,2…)

	local functionStr = dms.string(dms["upgrade_open_function"], _ED.user_info.user_grade, upgrade_open_function.functions)
	local functionTab = zstring.split(functionStr,",")
	for i , v in pairs(functionTab) do
		if zstring.tonumber(v) > 0 and dms.element(dms["function_param"],zstring.tonumber(v)) ~= nil then
			local cell = BattleFunctionOpenCell:createCell()
			cell:init(v)
			myListView:addChild(cell)
		end
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local firstopenid = dms.string(dms["function_param"],functionTab[1] ,function_param.open_leve) --开启等级
		if tonumber(firstopenid) ~= tonumber(_ED.user_info.user_grade) then
			local Panel_kaiqi = ccui.Helper:seekWidgetByName(root,"Panel_kaiqi")
			Panel_kaiqi:setVisible(false)
		end
		local userlevel = tonumber(_ED.user_info.user_grade) 
        local openautolevel = tonumber(dms.string(dms["fun_open_condition"], 55, fun_open_condition.level)) 
        if userlevel >= openautolevel and _ED.capture_resource_build_info == nil then
			local function responseCaptureCallback(response)
			end
			NetworkManager:register(protocol_command.map_scattered_init.code, nil, nil, nil, self, responseCaptureCallback, false, nil)						
        end
	end
	--数码显示体力上限
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		_currentEnergy:setString(dms.string(dms["user_experience_param"] ,tonumber(_ED.user_info.user_grade), user_experience_param.combatFoodCapacity))
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then				--龙虎门项目控制
		local currentLeadImage = ccui.Helper:seekWidgetByName(root, "Panel_403")
		if zstring.tonumber(_ED.user_info.user_gender) == 1 then
			currentLeadImage:setBackGroundImage(string.format("images/ui/decorative/head_j.png"))
		else
			currentLeadImage:setBackGroundImage(string.format("images/ui/decorative/head_l.png"))
		end
		
	end

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		-- local _level = dms.string(dms["fun_open_condition"],51, fun_open_condition.level)
		-- if tonumber(_ED.user_info.user_grade) ==  tonumber(_level) then
		-- 	local screenSize = cc.Director:getInstance():getOpenGLView():getFrameSize()
		-- 	local currentAccount = _ED.user_platform[_ED.default_user].platform_account
		-- 	local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
		-- 	local saveKey = currentAccount..currentServerNumber.."chatViewDialog".."end"
		-- 	local x,y = 0,(screenSize.height/2 + 100 * app.scaleFactor) / app.scaleFactor
		-- 	local str = x .. "," .. y .. "," .. "1"
		-- 	cc.UserDefault:getInstance():setStringForKey(saveKey, str)
		-- 	app.load("client.chat.ChatHomeView")
		-- 	state_machine.excute("chat_show_self",0,"chat_show_self")
		-- end
		--升级的时候刷新顶部信息
		if fwin:find("LPVESceneClass") ~= nil then
			state_machine.excute("lpve_scene_updeteinfo",0,"")

		end
		state_machine.excute("lpve_main_scene_updeteinfo",0,"")
		if tonumber(_ED.user_info.user_grade) == dms.int(dms["fun_open_condition"], 150, fun_open_condition.level) then
			state_machine.excute("home_update_first_recharge", 0,nil)
		end
		state_machine.excute("activity_window_refresh_button", 0,nil)
	end
	--升级刷新开启功能提示
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		_ED.system_fun_open_event = -1
		state_machine.excute("sm_model_open_push_updata",0,"sm_model_open_push_updata.")
		local open_str = dms.string(dms["user_experience_param"], tonumber(_ED.user_info.user_grade), user_experience_param.fun_open_text)
		local Panel_fun_open = ccui.Helper:seekWidgetByName(root, "Panel_fun_open")
		Panel_fun_open:setVisible(false)
		if open_str ~= "-1" then
			Panel_fun_open:setVisible(true)
			local Text_fun_open_name = ccui.Helper:seekWidgetByName(root, "Text_fun_open_name")
			Text_fun_open_name:setString(open_str)
		end
	end
end

function BattleLevelUp:onUpdate(dt)
	if fwin:find("TuitionControllerClass") ~= nil and fwin:find("TuitionControllerClass"):isVisible() == true then
		fwin:find("TuitionControllerClass"):setVisible(false)
	end
	if fwin:find("WindowLockClass") ~= nil and fwin:find("WindowLockClass"):isVisible() == true then
		fwin:find("WindowLockClass"):setVisible(false)
	end
end


function BattleLevelUp:onEnterTransitionFinish()
	_ED.user_is_level_up = false
    local csbBattleLevelUp = csb.createNode("battle/levelup.csb")
    self:addChild(csbBattleLevelUp)
	local root = csbBattleLevelUp:getChildByName("root")
	table.insert(self.roots, root)
    local action = csb.createTimeline("battle/levelup.csb")
    csbBattleLevelUp:runAction(action)
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
    	action:setTimeSpeed(app.getTimeSpeed())
    	action:play("window_open",false)
    else
    	action:gotoFrameAndPlay(0, action:getDuration(), false)
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    	local Panel_403 = ccui.Helper:seekWidgetByName(root, "Panel_403")
    	local function onFrameEventBullet(bone,evt,originFrameIndex,currentFrameIndex)
    	end
    	local jsonFile = "images/ui/effice/effect_user_up_lv/effect_user_up_lv.json"
	    local atlasFile = "images/ui/effice/effect_user_up_lv/effect_user_up_lv.atlas"
	    local animation = sp.spine(jsonFile, atlasFile, 1, 0, animation_name, true, nil)
	    animation.animationNameList = {"animation1","animation2"}
	    sp.initArmature(animation, false)
	    animation._invoke = changeActionCallback
	    animation:getAnimation():setFrameEventCallFunc(onFrameEventBullet)
	    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
	    csb.animationChangeToAction(animation, 0, 1, false)
	    Panel_403:addChild(animation)
    end
    
	self:upDataDraw()
	ccui.Helper:seekWidgetByName(root, "Image_1"):setSwallowTouches(false)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then

		action:setFrameEventCallFunc(function (frame)
	        if nil == frame then
	            return
	        end

	        local str = frame:getEvent()
	        if str == "window_open_over" then
	        	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, {func_string = [[state_machine.excute("battle_level_up_close", 0, "click battle_level_up_close.'")]]}, nil, 1)
	        end
	        
	    end)

	    -- 等级基金活动推送
	    state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 27)
	else
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, {func_string = [[state_machine.excute("battle_level_up_close", 0, "click battle_level_up_close.'")]]}, nil, 1)
	end
	
	-- 隐藏教学
	if fwin:find("TuitionControllerClass") ~= nil then
		fwin:find("TuitionControllerClass"):setVisible(false)
	end
	if fwin:find("WindowLockClass") ~= nil then
		fwin:find("WindowLockClass"):setVisible(false)
	end

	playEffect(formatMusicFile("effect", 9997))
	-- 清理开启升级的标记
	_ED.user_is_level_up = false
end

function BattleLevelUp:onExit()
	state_machine.remove("battle_level_up_close")
	-- 还原教学
	if fwin:find("TuitionControllerClass") ~= nil then
		fwin:find("TuitionControllerClass"):setVisible(true)
	end
	if fwin:find("WindowLockClass") ~= nil then
		fwin:find("WindowLockClass"):setVisible(true)
	end
	state_machine.excute("activity_window_update_activity_info", 0, 27)
	state_machine.excute("home_update_online_reward_info_state", 0, nil)
end