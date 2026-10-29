-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏副关卡场景界面
-------------------------------------------------------------------------------------------------------
LPVEScene = class("LPVESceneClass", Window)

function LPVEScene:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions ={}
	self.sceneID = 0
	
	-- 用于非常规副本选择记录（如获取途径跳转，记录之前的界面返回）
	self.dispatcher = nil 
	self.copytype = 0
	self.user_food = 0
	self.max_user_food = 0
	self.user_silver = 0
	self.user_gold = 0
	
    local function init_lpve_scene_terminal()
		-- 副本排行
		local lpve_scene_open_starchart_terminal = {
            _name = "lpve_scene_open_starchart",
            _init = function (terminal) 
				app.load("client.duplicate.pve.PVESceneStarChart")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local star = PVESceneStarChart:new()
				star:init()
				fwin:open(star, fwin._windows)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 关卡宝箱
		local lpve_scene_open_star_cheat_panel_terminal = {
            _name = "lpve_scene_open_star_cheat_panel",
            _init = function (terminal) 
				app.load("client.duplicate.pve.PVEStarChestPanel")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.copytype == 3 then --如果是名将副本地图
					return true
				end
            	local pcp = PVEStarCheatPanel:new()
				pcp:init(instance.sceneID)
				fwin:open(pcp, fwin._ui)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 返回
		local lpve_scene_return_terminal = {
            _name = "lpve_scene_return",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local  copytype = instance.copytype
				fwin:close(instance)
				state_machine.excute("lgeneral_copy_window_visible",0, true)
				state_machine.excute("pve_star_cheat_panel_close", 0, "")
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					--代表是新加的，其实不用版本控制
					local new_map_wnd = fwin:find("LPVENewMapClass")
					if new_map_wnd ~= nil then
						fwin:close(new_map_wnd)
					end
				end
				local map_wnd = fwin:find("LPVEMapClass")
				if map_wnd ~= nil then 
					fwin:close(map_wnd)
				end		
				if instance.dispatcher == nil then
					local duplicate_main_wnd = fwin:find("LDuplicateWindowClass")
					if duplicate_main_wnd ~= nil then
						-- print("the way -- visible")
						state_machine.excute("lduplicate_window_visible", 0, true)
					else
						-- print("the way -- new")
						--print("copytype",copytype)
						if copytype == 3 then
							state_machine.excute("lduplicate_window_manager", 0, {3})
						else
							state_machine.excute("lduplicate_window_manager", 0, "")
						end
					end
				else
					-- 处理非常规副本选择返回（如获取途径跳转，返回之前的界面）
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--顶部信息的刷新
		local lpve_scene_updeteinfo_terminal = {
            _name = "lpve_scene_updeteinfo",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:updateUserInfoDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 名将副本传记打开，关闭
		local lpve_scene_show_general_panle_terminal = {
            _name = "lpve_show_general_panle",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:showAction()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local lpve_scene_hidden_general_panle_terminal = {
            _name = "lpve_hidden_general_panle",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:hiddenAction()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		--挑战次数显示刷新
		local lpve_general_copy_show_attack_times_terminal = {
            _name = "lpve_general_copy_show_attack_times",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)	
				instance:setAttackTimes()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --返回主页
        local lpve_scene_return_home_terminal = {
            _name = "lpve_scene_return_home",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					cacher.destoryRefPools()
					cacher.removeAllTextures()
					cacher.cleanSystemCacher()
				end
				local new_map_wnd = fwin:find("LPVENewMapClass")
				if new_map_wnd ~= nil then
					fwin:close(new_map_wnd)
				end
				local map_wnd = fwin:find("LPVEMapClass")
				if map_wnd ~= nil then 
					fwin:close(map_wnd)
				end
				
				state_machine.excute("pve_star_cheat_panel_close", 0, "")

				if fwin:find("HomeClass") == nil then
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						-- cacher.cleanActionTimeline()
						-- fwin:removeAll()
					end
	            	state_machine.excute("menu_manager", 0, 
						{
							_datas = {
								terminal_name = "menu_manager", 	
								next_terminal_name = "menu_show_home_page", 
								current_button_name = "Button_home",
								but_image = "Image_home", 		
								terminal_state = 0, 
								isPressedActionEnabled = true
							}
						}
					)
	            end

				state_machine.unlock("menu_manager_change_to_page", 0, "")
				state_machine.excute("menu_back_home_page", 0, "")
				state_machine.excute("menu_clean_page_state", 0, "") 
				state_machine.excute("home_hero_refresh_draw", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(lpve_scene_updeteinfo_terminal)
		state_machine.add(lpve_scene_open_starchart_terminal)
		state_machine.add(lpve_scene_open_star_cheat_panel_terminal)
		state_machine.add(lpve_scene_return_terminal)
		state_machine.add(lpve_scene_show_general_panle_terminal)
		state_machine.add(lpve_scene_hidden_general_panle_terminal)
		state_machine.add(lpve_general_copy_show_attack_times_terminal)
		state_machine.add(lpve_scene_return_home_terminal)
        state_machine.init()
    end
    
    init_lpve_scene_terminal()
end

function LPVEScene:init(_sceneID, _dispatcher, _type)
	--print("_type",_type)
	self.sceneID = _sceneID
	self.dispatcher = _dispatcher
	self.copytype = _type  
end
function LPVEScene:showAction()
--print("show")
	self.actions[1]:play("button_923_touch", false)
end
function LPVEScene:hiddenAction()
--print("close")
	self.actions[1]:play("button_923_untouch", false)
end

function LPVEScene:setAttackTimes()
	local root = self.roots[1]
	local Text_jinritz_cishu = ccui.Helper:seekWidgetByName(root,"Text_jinritz_cishu")
	local params = dms.string(dms["pirates_config"],167, pirates_config.param)
	local tables = zstring.split(params, ",")
	--Text_jinritz_cishu:setString(tables[3])
	Text_jinritz_cishu:setString(_ED.activity_pve_times[347])
end
function LPVEScene:updateUserInfoDraw()
	local root = self.roots[1]
	
	-- 体力
	local foodText = ccui.Helper:seekWidgetByName(root, "Text_15")
	
	-- 金币
	local userSilverText = ccui.Helper:seekWidgetByName(root, "Text_15_0")
	
	-- 钻石
	local userGoldText = ccui.Helper:seekWidgetByName(root, "Text_15_0_0")
	
	self.user_food 		= _ED.user_info.user_food or 0			--当前体力
	self.max_user_food 	= _ED.user_info.max_user_food or 0	--体力上限
	self.user_silver = _ED.user_info.user_silver
	self.user_gold = _ED.user_info.user_gold
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		self.max_user_food = dms.int(dms["user_experience_param"], _ED.user_info.user_grade, user_experience_param.combatFoodCapacity)
	end
	if tonumber( self.user_food ) > 10000  then
		foodText:setString(math.floor(self.user_food /1000)..string_equiprety_name[40] .."/"..self.max_user_food)
	else
		foodText:setString(self.user_food  .. "/" ..self.max_user_food)
	end

	-- if tonumber( self.user_silver) > 100000000 then
	-- 	userSilverText:setString(math.floor(self.user_silver/ 100000000) .. string_equiprety_name[39])
	-- else
	if tonumber( self.user_silver)> 10000 then
		userSilverText:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
	else
		userSilverText:setString(self.user_silver)
	end

	-- if tonumber(self.user_gold) > 100000000 then
	-- 	userGoldText:setString(math.floor(self.user_gold / 100000000) .. string_equiprety_name[39])
	-- else
	if tonumber( self.user_gold)> 1000000 then
		userGoldText:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
	else
		userGoldText:setString(self.user_gold)
	end
	

end

function LPVEScene:onUpdateDraw()
	local root = self.roots[1]
	
	-- 关卡名称
	if self.copytype == 3 then
		local sceneNameText = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_zhangjie_yx")
		local name = dms.string(dms["pve_scene"], self.sceneID, pve_scene.scene_name)
		sceneNameText:setString(name)
		sceneNameText:setMaxLineWidth(36)
		local length = sceneNameText:getStringLength() -- 文字个数
		sceneNameText:setPositionY(sceneNameText:getPositionY() - length*22)	
		--print(name)
	else
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			local sceneNameText = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_zhangjie")
			local name = dms.string(dms["pve_scene"], self.sceneID, pve_scene.scene_name)
			sceneNameText:setString(name)
			local length = sceneNameText:getStringLength() -- 文字个数
			sceneNameText:setPositionY(sceneNameText:getPositionY() - length*20)
			sceneNameText:setMaxLineWidth(36)
			if zstring.tonumber(self.sceneID) == 2 then
				sceneNameText:setPositionX(sceneNameText:getPositionX() + 20)
			end
		else
			local sceneNameText = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_zhangjie")
			local name = dms.string(dms["pve_scene"], self.sceneID, pve_scene.scene_name)
			sceneNameText:setString(_string_piece_info[97] .. self.sceneID .. _string_piece_info[98] .. name)
			local length = sceneNameText:getStringLength() -- 文字个数
			sceneNameText:setPositionY(sceneNameText:getPositionY() - length*20)
			sceneNameText:setMaxLineWidth(36)
			if zstring.tonumber(self.sceneID) == 1 then
			sceneNameText:setPositionX(sceneNameText:getPositionX() + 20)
			end
		end	
	end	
	-- 关卡宝箱星数
	local sceneBoxStarText = ccui.Helper:seekWidgetByName(root, "Text_stare")
	--星星数量
	local getStarCount = tonumber(_ED.get_star_count[self.sceneID])
	local sceneStarNum = dms.int(dms["pve_scene"], self.sceneID, pve_scene.total_star)
	sceneBoxStarText:setString(getStarCount .. " / " .. sceneStarNum)
	
	self:updateUserInfoDraw()
	
end

function LPVEScene:startSceneEvent(pveSceneID)
	-- if executeMissionExt(mission_mould_tuition, touch_off_mission_ls_scene, "".._ED.user_info.user_grade, nil, true, "0", false) == false then
		local currentPveSceneID = zstring.tonumber(pveSceneID)
		local sceneParam = "sc".._ED.scene_current_state[zstring.tonumber(""..currentPveSceneID)]..
			"m".._ED.scene_max_state[zstring.tonumber(""..currentPveSceneID)]
			
		local pve_scene_event_mark_str = readKey("pve_scene_event_mark_"..currentPveSceneID..sceneParam)
		
		if pve_scene_event_mark_str == "1" or 
		  executeMissionExt(mission_mould_plot, touch_off_mission_into_scene, ""..currentPveSceneID, nil, true, sceneParam, false) == false then
			if executeMissionExt(mission_mould_tuition, touch_off_mission_into_scene, ""..currentPveSceneID, nil, true, sceneParam, false) == false then
				local sceneData = dms.element(dms["pve_scene"], currentPveSceneID)
				local placeView = zstring.split(dms.atos(sceneData,pve_scene.star_reward_id),",")
				local rewardView = zstring.split(dms.atos(sceneData, pve_scene.reward_need_star),",")
				local sceneDrawParam = "s"..currentPveSceneID
				if zstring.tonumber(_ED.get_star_count[currentPveSceneID]) >= zstring.tonumber(rewardView[1]) then
					if zstring.tonumber(_ED.star_reward_state[currentPveSceneID]) == 0 then
						sceneDrawParam = sceneDrawParam.."".."d"..0
					end
				end
				if executeMissionExt(mission_mould_tuition, touch_off_mission_into_scene, ""..currentPveSceneID, nil, true, sceneDrawParam, false) == false then
					executeNextEvent(nil, true)
				end
			end
		else
			writeKey("pve_scene_event_mark_"..currentPveSceneID..sceneParam, "1")
		end
	--end
	if missionIsOver() == false then
		local windowLock = fwin:find("WindowLockClass")
		if windowLock == nil then
			fwin:open(WindowLock:new():init(), fwin._windows)
		end
	end
end

function LPVEScene:onEnterTransitionFinish()
    local csbLPVEScene = csb.createNode("duplicate/pve_duplicate.csb")
    local root = csbLPVEScene:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbLPVEScene)
	ccui.Helper:seekWidgetByName(root, "Panel_2"):setTouchEnabled(false)
    -- 设置UI的事件响应
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back_0"), nil, 
	{
		terminal_name = "lpve_scene_return", 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local Button_back_home = ccui.Helper:seekWidgetByName(root, "Button_back_home")
		fwin:addTouchEventListener(Button_back_home, nil, 
		{
			terminal_name = "lpve_scene_return_home", 	
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
	end
	if self.copytype == 3 then
		local action = csb.createTimeline("duplicate/pve_duplicate.csb")
		table.insert(self.actions, action)
		csbLPVEScene:runAction(action)
	
		ccui.Helper:seekWidgetByName(root, "Button_923"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Panel_yingxiong_pve"):setVisible(true)
		ccui.Helper:seekWidgetByName(root,"Image_2_0"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Button_back_home"):setVisible(false)
		
		-- 剧情简介
		local Text_juqing_miaoshu = ccui.Helper:seekWidgetByName(root, "Text_juqing_miaoshu")
		local _text = dms.string(dms["pve_scene"], self.sceneID, pve_scene.brief_introduction)
		Text_juqing_miaoshu:setString(_text)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_9230"), nil, 
		{
			terminal_name = "lpve_show_general_panle", 	
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
		
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_9230_0"), nil, 
		{
			terminal_name = "lpve_hidden_general_panle", 	
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yx_back_home"), nil, 
		{
			terminal_name = "lpve_scene_return_home", 	
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
		
		state_machine.excute("lpve_general_copy_show_attack_times",0,"")
		state_machine.excute("lpve_show_general_panle",0,"")
	else
		ccui.Helper:seekWidgetByName(root, "Button_923"):setVisible(true)
		ccui.Helper:seekWidgetByName(root,"Panel_yingxiong_pve"):setVisible(false)
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_923"), nil, 
	{
		terminal_name = "lpve_scene_open_starchart", 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_923_0"), nil, 
	{
		terminal_name = "lpve_scene_open_star_cheat_panel", 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	state_machine.excute("lpve_scene_open_star_cheat_panel", 0, "")
	
	self:onUpdateDraw()

	if missionIsOver() == false then
		executeNextEvent(nil, true)
	else
		self:startSceneEvent(self.sceneID)
	end
end
function LPVEScene:close()
	cacher.destoryRefPools()
	cacher.cleanSystemCacher()
	cacher.remvoeUnusedArmatureFileInfoes()
	cacher.removeAllTextures()
end

function LPVEScene:onExit()
	state_machine.remove("lpve_scene_updeteinfo")
	state_machine.remove("lpve_scene_open_starchart")
	state_machine.remove("lpve_scene_open_star_cheat_panel")
	state_machine.remove("lpve_scene_return")
	state_machine.remove("lpve_scene_show_general_panle")
	state_machine.remove("lpve_scene_hidden_general_panle")
	state_machine.remove("lpve_general_copy_show_attack_times")
	state_machine.remove("lpve_scene_return_home")
end
