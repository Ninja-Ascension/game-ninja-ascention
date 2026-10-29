-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏副关卡场景界面
-------------------------------------------------------------------------------------------------------
LPVEMainScene = class("LPVEMainSceneClass", Window)

function LPVEMainScene:ctor()
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
	self.user_upgrade = 0
	
	self.openlist = true

	self._foodText = nil
	self._userSilverText = nil
	self._userGoldText = nil

    local function init_lpve_main_scene_terminal()
		-- 副本排行
		local lpve_main_scene_open_starchart_terminal = {
            _name = "lpve_main_scene_open_starchart",
            _init = function (terminal) 
				app.load("client.duplicate.pve.PVESceneStarChart")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local star = PVESceneStarChart:new()
            	
				star:init(instance.copytype)
				fwin:open(star, fwin._windows)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--关卡宝箱
		local lpve_main_scene_open_star_cheat_panel_terminal = {
            _name = "lpve_main_scene_open_star_cheat_panel",
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

		--顶部信息的刷新
		local lpve_main_scene_updeteinfo_terminal = {
            _name = "lpve_main_scene_updeteinfo",
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
        --检查教学
		local lpve_main_scene_check_mission_terminal = {
            _name = "lpve_main_scene_check_mission",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:checkMission(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	-----------------------------------------
        --刷新名称
		local lpve_main_scene_update_scene_name_terminal = {
            _name = "lpve_main_scene_update_scene_name",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local sceneNameText = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_1042")
				local name = dms.string(dms["pve_scene"], params, pve_scene.scene_name)
				sceneNameText:setString(name)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	-----------------------------------------
        state_machine.add(lpve_main_scene_updeteinfo_terminal)
		state_machine.add(lpve_main_scene_open_starchart_terminal)
		state_machine.add(lpve_main_scene_open_star_cheat_panel_terminal)
		state_machine.add(lpve_main_scene_check_mission_terminal)
		-----------------------------------------
		state_machine.add(lpve_main_scene_update_scene_name_terminal)
		-----------------------------------------
        state_machine.init()
    end
    
    init_lpve_main_scene_terminal()
end

function LPVEMainScene:init(_sceneID, _dispatcher, _type)
	--print("_type",_type)
	self.sceneID = _sceneID
	self.dispatcher = _dispatcher
	self.copytype = _type
end

function LPVEMainScene:updateUserInfoDraw()
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
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local Label_power_left = ccui.Helper:seekWidgetByName(self.roots[1], "Label_power_left")
		local Label_power_right = ccui.Helper:seekWidgetByName(self.roots[1], "Label_power_right")
		Label_power_left:setString(self.user_food)
		Label_power_right:setString(self.max_user_food)
		if tonumber(self.user_food) > tonumber(self.max_user_food) then
			Label_power_left:setColor(cc.c3b(0,255,0))
		else
			Label_power_left:setColor(cc.c3b(255,255,255))
		end
	else
		if tonumber( self.user_food ) > 10000  then
			foodText:setString(math.floor(self.user_food /1000)..string_equiprety_name[40] .."/"..self.max_user_food)
		else
			foodText:setString(self.user_food  .. "/" ..self.max_user_food)
		end
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
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local scene_type = dms.int(dms["pve_scene"], self.sceneID, pve_scene.scene_type)
		if scene_type == 0 then
			ccui.Helper:seekWidgetByName(root, "Image_zx_t"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Image_jy_t"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_em_t"):setVisible(false)
		elseif scene_type == 1 then
			ccui.Helper:seekWidgetByName(root, "Image_zx_t"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_jy_t"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Image_em_t"):setVisible(false)
		else
			ccui.Helper:seekWidgetByName(root, "Image_zx_t"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_jy_t"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_em_t"):setVisible(true)	
		end
	end

	self._foodText = foodText
	self._userSilverText = userSilverText
	self._userGoldText = userGoldText
end

function LPVEMainScene:onUpdate(dt)
	local root = self.roots[1]
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		if self.user_upgrade ~= _ED.user_info.user_grade then
			self.user_upgrade = _ED.user_info.user_grade
			self.max_user_food = dms.int(dms["user_experience_param"], _ED.user_info.user_grade, user_experience_param.combatFoodCapacity)
		end
	end
	
	if self.user_food ~= _ED.user_info.user_food then
		self.user_food = _ED.user_info.user_food
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local Label_power_left = ccui.Helper:seekWidgetByName(self.roots[1], "Label_power_left")
			local Label_power_right = ccui.Helper:seekWidgetByName(self.roots[1], "Label_power_right")
			Label_power_left:setString(self.user_food)
			Label_power_right:setString(self.max_user_food)
			if tonumber(self.user_food) > tonumber(self.max_user_food) then
				Label_power_left:setColor(cc.c3b(0,255,0))
			else
				Label_power_left:setColor(cc.c3b(255,255,255))
			end
		else
			if tonumber( self.user_food ) > 10000  then
				self._foodText:setString(math.floor(self.user_food /1000)..string_equiprety_name[40] .."/"..self.max_user_food)
			else
				self._foodText:setString(self.user_food  .. "/" ..self.max_user_food)
			end
		end
	end

	if self.user_silver ~= _ED.user_info.user_silver then
		self.user_silver = _ED.user_info.user_silver
		-- if tonumber( self.user_silver) > 100000000 then
		-- 	self._userSilverText:setString(math.floor(self.user_silver/ 100000000) .. string_equiprety_name[39])
		-- else
		if tonumber( self.user_silver)> 10000 then
			self._userSilverText:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
		else
			self._userSilverText:setString(self.user_silver)
		end
	end

	if self.user_gold ~= _ED.user_info.user_gold then
		self.user_gold = _ED.user_info.user_gold
		-- if tonumber(self.user_gold) > 100000000 then
		-- 	self._userGoldText:setString(math.floor(self.user_gold / 100000000) .. string_equiprety_name[39])
		-- else
		if tonumber( self.user_gold)> 1000000 then
			self._userGoldText:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
		else
			self._userGoldText:setString(self.user_gold)
		end
	end
end

function LPVEMainScene:onUpdateDraw()
	local root = self.roots[1]
	
	-- local sceneNameText = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_zj_name")
	-- local name = dms.string(dms["pve_scene"], self.sceneID, pve_scene.scene_name)
	-- sceneNameText:setString(name)
	-- local length = sceneNameText:getStringLength() -- 文字个数
	-- sceneNameText:setPositionY(sceneNameText:getPositionY() - length*20)
	-- sceneNameText:setMaxLineWidth(36)
	-- if zstring.tonumber(self.sceneID) == 2 then
	-- 	sceneNameText:setPositionX(sceneNameText:getPositionX() + 20)
	-- end

	-- -- 关卡宝箱星数
	-- local sceneBoxStarText = ccui.Helper:seekWidgetByName(root, "Text_stare")
	-- --星星数量
	-- local getStarCount = tonumber(_ED.get_star_count[self.sceneID])
	-- local sceneStarNum = dms.int(dms["pve_scene"], self.sceneID, pve_scene.total_star)
	-- sceneBoxStarText:setString(getStarCount .. " / " .. sceneStarNum)
	
	self:updateUserInfoDraw()
	
end


function LPVEMainScene:onUpdatePageLabel()
	local root = self.roots[1]
	local Text_pve_name = ccui.Helper:seekWidgetByName(root, "Text_pve_name")
	if self.copytype == 1 then
		Text_pve_name:setString(tipStringInfo_pve_main_tips[1])
	elseif self.copytype == 2 then
		Text_pve_name:setString(tipStringInfo_pve_main_tips[2])
	elseif self.copytype == 3 then
		Text_pve_name:setString(tipStringInfo_pve_main_tips[3])
	end
end

function LPVEMainScene:startSceneEvent(pveSceneID)
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

function LPVEMainScene:onEnterTransitionFinish()
    local csbLPVEScene = csb.createNode("duplicate/pve_duplicate_zx.csb")
    local root = csbLPVEScene:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbLPVEScene)
    local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
    if Panel_2 ~= nil then
		Panel_2:setTouchEnabled(false)
	end
	local Button_923 = ccui.Helper:seekWidgetByName(root, "Button_923")
	if Button_923 ~= nil then
		Button_923:setVisible(true)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_923"), nil, 
		{
			terminal_name = "lpve_main_scene_open_starchart", 	
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_923_0"), nil, 
	{
		terminal_name = "lpve_main_scene_open_star_cheat_panel", 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_zuanshi_add"), nil, 
	    {
	        terminal_name = "activity_home_recharge_button", 
	        terminal_state = 0, 
	        touch_black = true,
	    }, nil, 0)
	    app.load("client.utils.SmBuySilverCoins")
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_jinbi_add"), nil, 
	    {
	        terminal_name = "sm_buy_silver_coinsopen", 
	        terminal_state = 0, 
	        touch_black = true,
	    }, nil, 0)
	    app.load("client.utils.SmBuyPhysical")
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tili_add"), nil, 
	    {
	        terminal_name = "sm_buy_physicalopen", 
	        terminal_state = 0, 
	        touch_black = true,
	    }, nil, 0)
	end
	-- local Button_zhangjie_list = ccui.Helper:seekWidgetByName(root, "Button_zhangjie_list")
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhangjie_list"), nil, 
	-- {
	-- 	terminal_name = "lpve_main_scene_goto_open_list", 	
	-- 	terminal_state = 0, 
	-- 	isPressedActionEnabled = false

	-- }, 
	-- nil, 0)
	
	-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_battle_ordinary_the_chest",
	-- _widget = ccui.Helper:seekWidgetByName(root, "Panel_zx_tuishong"),
	-- _invoke = nil,
	-- _interval = 0.5,})
	-- if fwin:find("PVEStarCheatPanelClass") == nil then
	-- 	state_machine.excute("lpve_main_scene_open_star_cheat_panel", 0, "")
	-- else
	-- 	fwin:close(fwin:find("PVEStarCheatPanelClass"))
	-- 	state_machine.excute("lpve_main_scene_open_star_cheat_panel", 0, "")
	-- end
	
	self:onUpdateDraw()
	if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		self:onUpdatePageLabel()
	end
	self:checkMission(self.sceneID)

end
function LPVEMainScene:checkMission(sceneID)
	if missionIsOver() == false then
		executeNextEvent(nil, true)
	else
		self:startSceneEvent(sceneID)
	end
end
function LPVEMainScene:close()
	cacher.destoryRefPools()
	cacher.cleanSystemCacher()
	cacher.remvoeUnusedArmatureFileInfoes()
	cacher.removeAllTextures()
end

function LPVEMainScene:onExit()
    state_machine.remove("lpve_main_scene_updeteinfo")
	state_machine.remove("lpve_main_scene_open_starchart")
	state_machine.remove("lpve_main_scene_open_star_cheat_panel")
	state_machine.remove("lpve_main_scene_check_mission")
	-----------------------------------------
	state_machine.remove("lpve_main_scene_update_scene_name")
	-----------------------------------------
end
