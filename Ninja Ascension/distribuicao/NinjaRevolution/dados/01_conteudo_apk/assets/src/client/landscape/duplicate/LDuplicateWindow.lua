-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏副本界面
-------------------------------------------------------------------------------------------------------
LDuplicateWindow = class("LDuplicateWindowClass", Window)

LDuplicateWindow._infoDatas = {
	_type 	 = 1, 	-- 默认主线副本
	_chapter = -1, 	-- 副本章节，默认最后一章
	_isLastNpc = false, -- 记录上次战斗是否选择的最后的NPC
	_isBattleWin = false, -- 记录上次战斗是否胜利
	_isNewNPCAction = false, -- 记录新npc出现动画是否播放
	
}

-- 副本类型
LDuplicateWindow._adventureType = {
	MAINLINE = 1,		-- 主线
	ELITE = 2,			-- 精英
	NIGHTMARE = 3,		-- 噩梦
}
-----------------------------------------
LDuplicateWindow._pageViews = nil
LDuplicateWindow._pageViewsElite = nil
LDuplicateWindow._pageViewsEm = nil
LDuplicateWindow.lastIndex = 0
LDuplicateWindow.lastIndexElite = 0
LDuplicateWindow.lastIndexEm = 0
-----------------------------------------
if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	app.load("client.duplicate.pve.PVEDailyTopInfo")
	app.load("client.landscape.cells.duplicate.lpve_reward_cell")
	app.load("client.cells.ship.hero_icon_list_cell")
	app.load("client.packs.hero.HeroFormationChoiceWear")
	app.load("client.reward.DrawRareReward")
	app.load("client.landscape.duplicate.pve.LPVEMap")
end
-- 副本窗口的的管理器
local lduplicate_window_manager_terminal = {
    _name = "lduplicate_window_manager",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local pageIndex = params
		if type(params) == "table" and params[1] ~= nil then
			pageIndex = params[1]
		end
		local openinitmap = nil
		if type(params) == "table" and params[2] ~= nil then
			openinitmap = params[2]
		end
        fwin:open(LDuplicateWindow:new():init(pageIndex,openinitmap), fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local lduplicate_window_pve_quick_entrance_terminal = {
    _name = "lduplicate_window_pve_quick_entrance",
    _init = function (terminal) 
        app.load("client.landscape.duplicate.pve.LPVEScene")
        app.load("client.landscape.duplicate.pve.LPVEMap")
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
	    app.load("client.landscape.duplicate.pve.LPVENewMap")
	    app.load("client.landscape.duplicate.pve.LPVEMainScene")
	    app.load("client.landscape.duplicate.pve.LPVEAbyssNewMap")
	    app.load("client.duplicate.pve.PVEStarChestPanel")
	    if LDuplicateWindow._pageViews ~= nil then
		    LDuplicateWindow._pageViews.pageNumber = 0
		end
		if LDuplicateWindow._pageViewsElite ~= nil then
		    LDuplicateWindow._pageViewsElite.pageNumber = 0
		end
		if LDuplicateWindow._pageViewsEm ~= nil then
		    LDuplicateWindow._pageViewsEm.pageNumber = 0
		end

	    state_machine.lock("lduplicate_window_pve_quick_entrance")
		if params._type == 1 then
			-- 记录选择关卡
			if fwin:find("LDuplicateWindowClass") == nil then
				state_machine.excute("lduplicate_window_manager",0,{1,1})
			end

			_ED._current_scene_type = 1
			local tempSceneId = params._sceneId
			if tempSceneId == nil or tempSceneId < 0 then
				tempSceneId = _ED._current_scene_id
			end
			tempSceneId = zstring.tonumber(tempSceneId)
			LDuplicateWindow._infoDatas._chapter = tempSceneId
			-----------------------------------------
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				-- if fwin:find("LPVENewMapClass") == nil then
				-- LDuplicateWindow._pageViews:removeAllChildren(true)
				-- for i,v in pairs(LDuplicateWindow._pageViews:getPages()) do
				-- 	LDuplicateWindow._pageViews:removePage(v)  
				-- end
				-- LDuplicateWindow._pageViews:removeAllPages()
				LDuplicateWindow._pageViews:setVisible(true)
				LDuplicateWindow._pageViewsElite:setVisible(false)
				LDuplicateWindow._pageViewsEm:setVisible(false)
				local index = 0
				-- for i=1,tempSceneId do
				-- 	local _LPVEMap = LPVEMap:createCell()
				-- 	_LPVEMap:init(i,true)
				-- 	_LPVEMap.m_SceneId = i
				-- 	LDuplicateWindow._pageViews:addPage(_LPVEMap)
				-- 	index = index + 1
				-- end
				
				local maxOpenScene = fwin:find("LDuplicateWindowClass"):getOpenScene()
				for i = maxOpenScene, 1, -1 do
					if i >= 1 and i < 51 then
						local _LPVEMap = LPVEMap:createCell()
						_LPVEMap:init(i,true)
						_LPVEMap.m_SceneId = i
						LDuplicateWindow._pageViews:insertPage(_LPVEMap,0) 
						if LDuplicateWindow._pageViews.pageNumber == nil then
							LDuplicateWindow._pageViews.pageNumber = 0
						end
						LDuplicateWindow._pageViews.pageNumber = LDuplicateWindow._pageViews.pageNumber + 1
						if i <= tempSceneId then
							index = index + 1
						end
					end
				end
				-- for i=1,#LDuplicateWindow._pageViews:getPages() do
				-- 	if i > m_p_ndex then
				-- 		LDuplicateWindow._pageViews:removePageAtIndex(i-1)
				-- 	end
				-- end
				-- LDuplicateWindow._pageViews:getPage(index-1):onInit()
				LDuplicateWindow._pageViews:scrollToPage(index-1)
				if nil ~= LDuplicateWindow._pageViews.callback then
					LDuplicateWindow.lastIndex = -1
					LDuplicateWindow._pageViews.callback(LDuplicateWindow._pageViews, ccui.PageViewEventType.turning)
				end
	   --          fwin:close(fwin:find("PVEStarCheatPanelClass"))
				if fwin:find("PVEStarCheatPanelClass") == nil then
					state_machine.excute("open_star_cheat_panel",0,{tempSceneId})
				else
					state_machine.excute("pve_star_cheat_update_info",0,{tempSceneId})
				end

				-- DSC通关宝箱领取提示
				if __lua_project_id == __lua_project_l_digital then
					fwin:find("LDuplicateWindowClass"):showArrowRedDot(LDuplicateWindow._pageViews, LDuplicateWindow._adventureType.MAINLINE)
				end

				state_machine.excute("lduplicate_window_show_one_click", 0, nil)
			else
				if fwin:find("LPVENewMapClass") == nil then
					local _LPVEMap = LPVENewMap:new()
					_LPVEMap:init(tempSceneId,true)
					fwin:open(_LPVEMap, fwin._ui)
					-- function openOther()
					-- 	if _LPVEMap ~= nil then
					-- 		_LPVEMap:afterOpen()
					-- 	end
					-- end
					-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
					-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg,openOther,_LPVEMap)
					local openother = cc.Sequence:create({cc.DelayTime:create(0), cc.CallFunc:create(function(sender)
						_LPVEMap:afterOpen()
					end)})
					_LPVEMap:runAction(openother)
				else
					fwin:close(fwin:find("LPVENewMapClass"))
					local _LPVEMap = LPVENewMap:new()
					_LPVEMap:init(tempSceneId,true)
					fwin:open(_LPVEMap, fwin._ui)
					-- function openOther()
					-- 	_LPVEMap:afterOpen()
					-- end				
					-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
					-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg,openOther,_LPVEMap)
					local openother = cc.Sequence:create({cc.DelayTime:create(0), cc.CallFunc:create(function(sender)
						_LPVEMap:afterOpen()
					end)})
					_LPVEMap:runAction(openother)
				end
			end
			-----------------------------------------
			if fwin:find("LPVEMainSceneClass") == nil then
 				local _LPVEScene = LPVEMainScene:new()
				_LPVEScene:init(tempSceneId,nil,1)
				fwin:open(_LPVEScene, fwin._ui)
			else
				fwin:close(fwin:find("LPVEMainSceneClass"))
				 local _LPVEScene = LPVEMainScene:new()
				_LPVEScene:init(tempSceneId,nil,1)
				fwin:open(_LPVEScene, fwin._ui)
			end
			-----------------------------------------
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				state_machine.excute("lpve_main_scene_update_scene_name",0,tempSceneId)
			end
			-----------------------------------------
			local npcid = params._npcid
			if npcid ~= nil then
				app.load("client.landscape.duplicate.pve.LPVENpc")
				if fwin:find("LPVENpcClass") == nil then
					local sceneParam = "nc".._ED.npc_state[zstring.tonumber(npcid)]
					if missionIsOver() == false or executeMissionExt(mission_mould_plot, touch_off_mission_touch_npc, ""..npcid, nil, true, sceneParam, false) == false then
						local _LPVENpc = LPVENpc:new()
						_LPVENpc:init(npcid, 
									  params._sceneId 
									 )
						fwin:open(_LPVENpc, fwin._ui)
					end
				else
					fwin:close(fwin:find("LPVENpcClass"))
					if missionIsOver() == false or executeMissionExt(mission_mould_plot, touch_off_mission_touch_npc, ""..npcid, nil, true, sceneParam, false) == false then
						local _LPVENpc = LPVENpc:new()
						_LPVENpc:init(npcid, 
									  params._sceneId
									 )
						fwin:open(_LPVENpc, fwin._ui)
					end
				end
			end
			
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				state_machine.excute("daily_copy_show_add_roots",0,"daily_copy_show_add_roots.")
			end
		elseif params._type == 2 then
			--精英副本
			if fwin:find("LDuplicateWindowClass") == nil then
				state_machine.excute("lduplicate_window_manager",0,{2,1})
			end

			_ED._current_scene_type = 2
			local tempSceneId = params._sceneId
			if tempSceneId == nil or tempSceneId < 0 then
				tempSceneId = _ED._current_scene_id
			end
			tempSceneId = zstring.tonumber(tempSceneId)
			LDuplicateWindow._infoDatas._chapter = tempSceneId
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		        then
		        -- LDuplicateWindow._pageViewsElite:removeAllChildren(true)
	        	-- LDuplicateWindow._pageViewsElite:removeAllPages()
	   --      	for i,v in pairs(LDuplicateWindow._pageViewsElite:getPages()) do
				-- 	LDuplicateWindow._pageViewsElite:removePage(v)  
				-- end
	        	LDuplicateWindow._pageViews:setVisible(false)
	        	LDuplicateWindow._pageViewsEm:setVisible(false)
				LDuplicateWindow._pageViewsElite:setVisible(true)
				local index = 0
				
				local maxOpenScene = fwin:find("LDuplicateWindowClass"):getOpenScene()
				for i = maxOpenScene, 1, -1 do
					if i >= 51 and i < 101 then
						local _LPVEMap = LPVEMap:createCell()
						_LPVEMap:init(i,true)
						_LPVEMap.m_SceneId = i
						LDuplicateWindow._pageViewsElite:insertPage(_LPVEMap,0) 
						if LDuplicateWindow._pageViewsElite.pageNumber == nil then
							LDuplicateWindow._pageViewsElite.pageNumber = 0
						end
						LDuplicateWindow._pageViewsElite.pageNumber = LDuplicateWindow._pageViewsElite.pageNumber + 1
						if i <= tempSceneId then
							index = index + 1
						end
					end
				end
				-- for i=1,#LDuplicateWindow._pageViewsElite:getPages() do
				-- 	if i > m_p_ndex then
				-- 		LDuplicateWindow._pageViewsElite:removePageAtIndex(i-1)
				-- 	end
				-- end
				-- for i=101,tempSceneId do
				-- 	local _LPVEMap = LPVEMap:createCell()
				-- 	_LPVEMap:init(i,true)
				-- 	_LPVEMap.m_SceneId = i
				-- 	LDuplicateWindow._pageViewsElite:addPage(_LPVEMap)
				-- 	index = index + 1
				-- end
				-- LDuplicateWindow._pageViewsElite:getPage(index-1):onInit()
				LDuplicateWindow._pageViewsElite:scrollToPage(index-1)
				if nil ~= LDuplicateWindow._pageViewsElite.callback then
					LDuplicateWindow.lastIndexElite = -1
					LDuplicateWindow._pageViewsElite.callback(LDuplicateWindow._pageViewsElite, ccui.PageViewEventType.turning)
				end
	   --          fwin:close(fwin:find("PVEStarCheatPanelClass"))
				if fwin:find("PVEStarCheatPanelClass") == nil then
					state_machine.excute("open_star_cheat_panel",0,{tempSceneId})
				else
					state_machine.excute("pve_star_cheat_update_info",0,{tempSceneId})
				end
				
				-- DSC通关宝箱领取提示
				if __lua_project_id == __lua_project_l_digital then
					fwin:find("LDuplicateWindowClass"):showArrowRedDot(LDuplicateWindow._pageViewsElite, LDuplicateWindow._adventureType.ELITE)
				end

				state_machine.excute("lduplicate_window_show_one_click", 0, nil)
		    else
				if fwin:find("LPVEAbyssNewMapClass") == nil then
					local _LPVEMap = LPVEAbyssNewMap:new()
					_LPVEMap:init(tempSceneId,true)
					fwin:open(_LPVEMap, fwin._ui)
		
					local openother = cc.Sequence:create({cc.DelayTime:create(0), cc.CallFunc:create(function(sender)
						_LPVEMap:afterOpen()
					end)})
					_LPVEMap:runAction(openother)
				else
					fwin:close(fwin:find("LPVEAbyssNewMapClass"))
					local _LPVEMap = LPVEAbyssNewMap:new()
					_LPVEMap:init(tempSceneId,true)
					fwin:open(_LPVEMap, fwin._ui)
					-- function openOther()
					-- 	_LPVEMap:afterOpen()
					-- end				
					-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
					-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg,openOther,_LPVEMap)
					local openother = cc.Sequence:create({cc.DelayTime:create(0), cc.CallFunc:create(function(sender)
						_LPVEMap:afterOpen()
					end)})
					_LPVEMap:runAction(openother)
				end
			end

			if fwin:find("LPVEMainSceneClass") == nil then
 				local _LPVEScene = LPVEMainScene:new()
				_LPVEScene:init(tempSceneId,nil,2)
				fwin:open(_LPVEScene, fwin._ui)
			else
				fwin:close(fwin:find("LPVEMainSceneClass"))
				 local _LPVEScene = LPVEMainScene:new()
				_LPVEScene:init(tempSceneId,nil,2)
				fwin:open(_LPVEScene, fwin._ui)
			end
			-----------------------------------------
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				state_machine.excute("lpve_main_scene_update_scene_name",0,tempSceneId)
			end
			-----------------------------------------
			local npcid = params._npcid
			if npcid ~= nil then
				app.load("client.landscape.duplicate.pve.LPVENpc")
				if fwin:find("LPVENpcClass") == nil then
					local sceneParam = "nc".._ED.npc_state[zstring.tonumber(npcid)]
					if missionIsOver() == false or executeMissionExt(mission_mould_plot, touch_off_mission_touch_npc, ""..npcid, nil, true, sceneParam, false) == false then
						local _LPVENpc = LPVENpc:new()
						_LPVENpc:init(npcid, 
									  params._sceneId 
									 )
						fwin:open(_LPVENpc, fwin._ui)
					end
				else
					fwin:close(fwin:find("LPVENpcClass"))
					if missionIsOver() == false or executeMissionExt(mission_mould_plot, touch_off_mission_touch_npc, ""..npcid, nil, true, sceneParam, false) == false then
						local _LPVENpc = LPVENpc:new()
						_LPVENpc:init(npcid, 
									  params._sceneId
									 )
						fwin:open(_LPVENpc, fwin._ui)
					end
				end
			end

		elseif params._type == 3 then
			local tempSceneId = params._sceneId
			if tempSceneId == nil or tempSceneId < 0 then
				tempSceneId = _ED._current_scene_id
			end
			tempSceneId = zstring.tonumber(tempSceneId)
			LDuplicateWindow._infoDatas._chapter = tempSceneId
			
			local _LPVEMap = LPVEMap:new()
			_LPVEMap:init(tempSceneId,params._type)
			fwin:open(_LPVEMap, fwin._ui)
			
			local _LPVEScene = LPVEScene:new()
			_LPVEScene:init(tempSceneId,nil,params._type)
			fwin:open(_LPVEScene, fwin._ui)
		elseif params._type == 15 then
			--噩梦副本
			if fwin:find("LDuplicateWindowClass") == nil then
				state_machine.excute("lduplicate_window_manager",0,{15,1})
			end
			_ED._current_scene_type = 15
			local tempSceneId = params._sceneId
			if tempSceneId == nil or tempSceneId < 0 then
				tempSceneId = _ED._current_scene_id
			end
			tempSceneId = zstring.tonumber(tempSceneId)
			LDuplicateWindow._infoDatas._chapter = tempSceneId
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		        then
		        -- LDuplicateWindow._pageViewsElite:removeAllChildren(true)
	        	-- LDuplicateWindow._pageViewsElite:removeAllPages()
	   --      	for i,v in pairs(LDuplicateWindow._pageViewsElite:getPages()) do
				-- 	LDuplicateWindow._pageViewsElite:removePage(v)  
				-- end
	        	LDuplicateWindow._pageViews:setVisible(false)
	        	LDuplicateWindow._pageViewsEm:setVisible(true)
				LDuplicateWindow._pageViewsElite:setVisible(false)
				local index = 0

				local maxOpenScene = fwin:find("LDuplicateWindowClass"):getOpenScene()
				for i = maxOpenScene, 1, -1 do
					if i >= 101 and i < 151 then
						local _LPVEMap = LPVEMap:createCell()
						_LPVEMap:init(i,true)
						_LPVEMap.m_SceneId = i
						LDuplicateWindow._pageViewsEm:insertPage(_LPVEMap,0) 
						if LDuplicateWindow._pageViewsEm.pageNumber == nil then
							LDuplicateWindow._pageViewsEm.pageNumber = 0
						end
						LDuplicateWindow._pageViewsEm.pageNumber = LDuplicateWindow._pageViewsEm.pageNumber + 1
						if i <= tempSceneId then
							index = index + 1
						end
					end
				end
				LDuplicateWindow._pageViewsEm:scrollToPage(index-1)
				if nil ~= LDuplicateWindow._pageViewsEm.callback then
					LDuplicateWindow.lastIndexEm = -1
					LDuplicateWindow._pageViewsEm.callback(LDuplicateWindow._pageViewsEm, ccui.PageViewEventType.turning)
				end
	   --          fwin:close(fwin:find("PVEStarCheatPanelClass"))
				if fwin:find("PVEStarCheatPanelClass") == nil then
					state_machine.excute("open_star_cheat_panel",0,{tempSceneId})
				else
					state_machine.excute("pve_star_cheat_update_info",0,{tempSceneId})
				end
				
				-- DSC通关宝箱领取提示
				if __lua_project_id == __lua_project_l_digital then
					fwin:find("LDuplicateWindowClass"):showArrowRedDot(LDuplicateWindow._pageViewsEm, LDuplicateWindow._adventureType.NIGHTMARE)
				end
				
				state_machine.excute("lduplicate_window_show_one_click", 0, nil)
		    else
				if fwin:find("LPVEAbyssNewMapClass") == nil then
					local _LPVEMap = LPVEAbyssNewMap:new()
					_LPVEMap:init(tempSceneId,true)
					fwin:open(_LPVEMap, fwin._ui)
		
					local openother = cc.Sequence:create({cc.DelayTime:create(0), cc.CallFunc:create(function(sender)
						_LPVEMap:afterOpen()
					end)})
					_LPVEMap:runAction(openother)
				else
					fwin:close(fwin:find("LPVEAbyssNewMapClass"))
					local _LPVEMap = LPVEAbyssNewMap:new()
					_LPVEMap:init(tempSceneId,true)
					fwin:open(_LPVEMap, fwin._ui)
					-- function openOther()
					-- 	_LPVEMap:afterOpen()
					-- end				
					-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
					-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg,openOther,_LPVEMap)
					local openother = cc.Sequence:create({cc.DelayTime:create(0), cc.CallFunc:create(function(sender)
						_LPVEMap:afterOpen()
					end)})
					_LPVEMap:runAction(openother)
				end
			end
			if fwin:find("LPVEMainSceneClass") == nil then
 				local _LPVEScene = LPVEMainScene:new()
				_LPVEScene:init(tempSceneId,nil,15)
				fwin:open(_LPVEScene, fwin._ui)
			else
				fwin:close(fwin:find("LPVEMainSceneClass"))
				 local _LPVEScene = LPVEMainScene:new()
				_LPVEScene:init(tempSceneId,nil,15)
				fwin:open(_LPVEScene, fwin._ui)
			end
			-----------------------------------------
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				state_machine.excute("lpve_main_scene_update_scene_name",0,tempSceneId)
			end
			-----------------------------------------
			local npcid = params._npcid
			if npcid ~= nil then
				app.load("client.landscape.duplicate.pve.LPVENpc")
				if fwin:find("LPVENpcClass") == nil then
					local sceneParam = "nc".._ED.npc_state[zstring.tonumber(npcid)]
					if missionIsOver() == false or executeMissionExt(mission_mould_plot, touch_off_mission_touch_npc, ""..npcid, nil, true, sceneParam, false) == false then
						local _LPVENpc = LPVENpc:new()
						_LPVENpc:init(npcid, 
									  params._sceneId 
									 )
						fwin:open(_LPVENpc, fwin._ui)
					end
				else
					fwin:close(fwin:find("LPVENpcClass"))
					if missionIsOver() == false or executeMissionExt(mission_mould_plot, touch_off_mission_touch_npc, ""..npcid, nil, true, sceneParam, false) == false then
						local _LPVENpc = LPVENpc:new()
						_LPVENpc:init(npcid, 
									  params._sceneId
									 )
						fwin:open(_LPVENpc, fwin._ui)
					end
				end
			end
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(lduplicate_window_manager_terminal)
state_machine.add(lduplicate_window_pve_quick_entrance_terminal)
state_machine.init()

function LDuplicateWindow:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self._enumPveType = {
		_COMMON = 1,
		_ABYSS = 2,
		_ELITE = 3,
		_ACTIVITY = 4,
		_EM = 15,
	}
	
	self._enumUiGroup = {
		_PVE_TYPE = 1,
		_PVE_DIFFICULTY = 2,
		_PVE_EM = 3,
	}
	
	self.currentSceneType = 0
	self.openinitmap = nil
	self.pveMenuPanel = nil

	self.m_scenes_type = 0		--场景类型
    -- Initialize LDuplicateWindow page state machine.
    local function init_lduplicate_window_terminal()
		local lduplicate_window_switch_terminal = {
            _name = "lduplicate_window_switch",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- if terminal.ui_manager == nil then
					-- terminal.ui_manager = {}
				-- end	
				
				-- if type(params._datas.group_name) ~= "number" or params._datas.group_name <= 0 then
					-- params._datas.group_name = instance._enumUiGroup._PVE_TYPE
				-- end
				
				-- if terminal.ui_manager[params._datas.group_name] == nil then
					-- terminal.ui_manager[params._datas.group_name] = {}
				-- end
			
				-- local _ui_manager = terminal.ui_manager[params._datas.group_name]
			
				-- if _ui_manager.last_terminal_name ~= params._datas.next_terminal_name then
					-- if state_machine.excute(params._datas.next_terminal_name, 0, params) == true then
                    	-- _ui_manager.last_terminal_name = params._datas.next_terminal_name
                    -- else
                    	-- return false
                	-- end
            		
				-- end
				
				-- -- set select ui button is highlighted
				-- if _ui_manager.select_button ~= nil and _ui_manager.select_button.setHighlighted ~= nil then
					-- _ui_manager.select_button:setHighlighted(false)
				-- end
				
				-- if _ui_manager.select_button == nil and params._datas.current_button_name ~= nil then
					-- _ui_manager.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
				-- else
					-- _ui_manager.select_button = params
				-- end
				-- if _ui_manager.select_button ~= nil and _ui_manager.select_button.setHighlighted ~= nil then
					-- _ui_manager.select_button:setHighlighted(true)
				-- end
				if  params._datas.next_terminal_name == "general_copy" then
			   	    if dms.int(dms["fun_open_condition"],18,fun_open_condition.level) > tonumber(_ED.user_info.user_grade) then
			            local tipstr =  dms.string(dms["fun_open_condition"],18,fun_open_condition.tip_info)
			            TipDlg.drawTextDailog(tipstr)
			            return
			        end
				elseif params._datas.next_terminal_name == "daily_copy" then
			        if dms.int(dms["fun_open_condition"],19,fun_open_condition.level) > tonumber(_ED.user_info.user_grade) then
			            local tipstr =  dms.string(dms["fun_open_condition"],19,fun_open_condition.tip_info)
			            TipDlg.drawTextDailog(tipstr)
			            return
			        end
			    elseif params._datas.next_terminal_name == "plot_change_to_abyss" then
			        if dms.int(dms["fun_open_condition"],26,fun_open_condition.level) > tonumber(_ED.user_info.user_grade) then
			            local tipstr =  dms.string(dms["fun_open_condition"],26,fun_open_condition.tip_info)
			            TipDlg.drawTextDailog(tipstr)
			            return
			        end
			    elseif params._datas.next_terminal_name == "plot_change_to_em" then
			        if dms.int(dms["fun_open_condition"],109,fun_open_condition.level) > tonumber(_ED.user_info.user_grade) then
			            local tipstr =  dms.string(dms["fun_open_condition"],26,fun_open_condition.tip_info)
			            TipDlg.drawTextDailog(tipstr)
			            return
			        end
				end

                -- set select ui button is highlighted
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(false)
                    terminal.select_button:setTouchEnabled(true)
                end
                if params._datas.current_button_name ~= nil or params._datas.current_button_name ~= "" then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
                end
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(true)
                    terminal.select_button:setTouchEnabled(false)
                end
                if terminal.last_terminal_name ~= params._datas.next_terminal_name and params._datas.next_terminal_name ~= params._datas.terminal_name then
					terminal.last_terminal_name = params._datas.next_terminal_name
                    state_machine.excute(terminal.last_terminal_name, 0, params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 返回主界面
		local lduplicate_window_return_terminal = {
            _name = "lduplicate_window_return",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("LPVENewMapClass"))
				fwin:close(fwin:find("LPVEMainScene"))
				fwin:close(fwin:find("LPVERaidSelectPanelClass"))
				fwin:close(fwin:find("PVEStarCheatPanelClass"))
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_red_alert then
            		cacher.destoryRefPools()
            		cacher.removeAllTextures()
					cacher.cleanSystemCacher()
					cacher.remvoeUnusedArmatureFileInfoes()
				end
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
		
		-- 隐藏/显示该界面
		local lduplicate_window_visible_terminal = {
            _name = "lduplicate_window_visible",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:setVisible(params)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        -- 名将副本的管理器
		local general_copy_terminal = {
            _name = "general_copy",
            _init = function (terminal) 
             app.load("client.landscape.duplicate.general.LGeneralCopyWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				LDuplicateWindow._infoDatas._type = self._enumPveType._ELITE
				_ED._current_scene_type = 3
				local pve_select_pad = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_1014")
				pve_select_pad:removeAllChildren(true)	
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then	
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_pve_1"):setHighlighted(true)
					if fwin:find("LGeneralCopyWindowClass") == nil then
						state_machine.excute("lgeneral_copy_window_open_window",0,"")
					end
					local panel_daily = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_richang_pve")
					if nil ~= panel_daily then
						panel_daily:setVisible(false)
					end
					if self.pveMenuPanel ~= nil then
						self.pveMenuPanel:setVisible(false)
					end
					instance:changePveButtonsMenu(3)
					state_machine.excute("general_copy_show_attack_times",0,"")
					fwin:close(fwin:find("PVEDailyActivityCopyClass"))
					state_machine.excute("pve_daily_top_info_hide",0,"")
				end
				instance:hidePveMap()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 主线副本的管理器
		local plot_copy_terminal = {
            _name = "plot_copy",
            _init = function (terminal) 
                app.load("client.landscape.duplicate.pve.LPVERaidSelectPanel")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				LDuplicateWindow._infoDatas._type = self._enumPveType._COMMON
				local _LPVERaidSelectPanel = LPVERaidSelectPanel:createCell()
				_LPVERaidSelectPanel:init(LDuplicateWindow._infoDatas._type, instance.currentSceneType)
				
				local pve_select_pad = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_1014")
				pve_select_pad:removeAllChildren(true)
				
				_LPVERaidSelectPanel:setTag(100 + self._enumPveType._COMMON)
				pve_select_pad:addChild(_LPVERaidSelectPanel)
				
				
				if __lua_project_id ==  __lua_project_gragon_tiger_gate 
					then
					fwin:close(fwin:find("PVEDailyActivityCopyClass"))
					state_machine.excute("pve_daily_top_info_hide",0,"")
					if self.pveMenuPanel ~= nil then
						self.pveMenuPanel:setVisible(true)
					end
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_1030"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_1031"):setVisible(true)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 日常副本的管理器
		local daily_copy_terminal = {
            _name = "daily_copy",
            _init = function (terminal) 
				app.load("client.duplicate.pve.PVEDailyActivityCopy")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				LDuplicateWindow._infoDatas._type = self._enumPveType._ACTIVITY
				
				local pve_select_pad = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_1014")
				pve_select_pad:removeAllChildren(true)
				
				if __lua_project_id ==  __lua_project_gragon_tiger_gate 
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					state_machine.excute("lgeneral_copy_window_close_window",0,"")
					state_machine.excute("daily_copy_show_attack_times",0,"")
					local Panel_yingxiong_pve = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_yingxiong_pve")
					if nil ~= Panel_yingxiong_pve then
						Panel_yingxiong_pve:setVisible(false)
					end
					if fwin:find("PVEDailyActivityCopyClass") == nil then
						fwin:open(PVEDailyActivityCopy:new():init(-1), fwin._ui)
					end
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_pve_1"):setHighlighted(false)
					self.pveMenuPanel:setVisible(false)
					instance:changePveButtonsMenu(3)

					if fwin:find("PVEDailyTopInfoClass") == nil then
						state_machine.excute("pve_daily_top_info_open",0,"")
					else
						state_machine.excute("pve_daily_top_info_show",0,"")
					end
				end
				instance:hidePveMap()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 主线、精英切换（主线）
		local plot_change_to_common_terminal = {
            _name = "plot_change_to_common",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				LDuplicateWindow._infoDatas._type = self._enumPveType._COMMON
				-- local pve_select_pad = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_1014")
				
				-- local commonList = pve_select_pad:getChildByTag(100 + self._enumPveType._COMMON)
				-- local abyssList = pve_select_pad:getChildByTag(100 + self._enumPveType._ABYSS)
				
				-- if abyssList ~= nil then
				-- 	abyssList:setVisible(false)
				-- end	
				
				-- if commonList ~= nil then
				-- 	commonList:setVisible(true)
				-- else
					-- app.load("client.landscape.duplicate.pve.LPVERaidSelectPanel")
					-- local _LPVERaidSelectPanel = LPVERaidSelectPanel:createCell()
					-- _LPVERaidSelectPanel:init(LDuplicateWindow._infoDatas._type, instance.currentSceneType)
				-- 	_LPVERaidSelectPanel:setTag(100 + self._enumPveType._COMMON)
				-- 	pve_select_pad:addChild(_LPVERaidSelectPanel)
				-- 	table.insert(instance.roots, _LPVERaidSelectPanel.roots[1])
				-- end	
				instance:showPveMap()
				_ED._current_scene_type = 1
				if __lua_project_id == __lua_project_gragon_tiger_gate 
					or __lua_project_id == __lua_project_red_alert 
					then
					state_machine.excute("lgeneral_copy_window_close_window",0,"")
					local Panel_yingxiong_pve = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_yingxiong_pve")
					if nil ~= Panel_yingxiong_pve then
						Panel_yingxiong_pve:setVisible(false)
					end
					local panel_daily = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_richang_pve")
					if nil ~= panel_daily then
						panel_daily:setVisible(false)
					end
					local pveButton = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_pve_1")
					if nil ~= pveButton then
						pveButton:setHighlighted(false)
						pveButton:setVisible(true)
					end
					instance.pveMenuPanel:setVisible(true)
					instance:changePveButtonsMenu(1)

					state_machine.excute("pve_daily_top_info_hide",0,"")
				end
				fwin:close(fwin:find("PVEDailyActivityCopyClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 主线、精英切换（精英）
		local plot_change_to_abyss_terminal = {
            _name = "plot_change_to_abyss",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				LDuplicateWindow._infoDatas._type = self._enumPveType._ABYSS
				_ED._current_scene_type = 2
				instance:showAbyssMap()
				if __lua_project_id == __lua_project_gragon_tiger_gate 
					or __lua_project_id == __lua_project_red_alert 
					then
					state_machine.excute("lgeneral_copy_window_close_window",0,"")
					local Panel_yingxiong_pve = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_yingxiong_pve")
					if nil ~= Panel_yingxiong_pve then
						Panel_yingxiong_pve:setVisible(false)
					end
					local panel_daily = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_richang_pve")
					if nil ~= panel_daily then
						panel_daily:setVisible(false)
					end
					local pveButton = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_pve_1")
					if nil ~= pveButton then
						pveButton:setHighlighted(false)
						pveButton:setVisible(true)
					end

					instance.pveMenuPanel:setVisible(true)
					instance:changePveButtonsMenu(2)

					state_machine.excute("pve_daily_top_info_hide",0,"")
				end
				fwin:close(fwin:find("PVEDailyActivityCopyClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 主线、精英、噩梦切换（噩梦）
		local plot_change_to_em_terminal = {
            _name = "plot_change_to_em",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				LDuplicateWindow._infoDatas._type = self._enumPveType._EM
				_ED._current_scene_type = 15
				instance:showEmMap()
				if __lua_project_id == __lua_project_gragon_tiger_gate 
					or __lua_project_id == __lua_project_red_alert 
					then
					state_machine.excute("lgeneral_copy_window_close_window",0,"")
					local Panel_yingxiong_pve = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_yingxiong_pve")
					if nil ~= Panel_yingxiong_pve then
						Panel_yingxiong_pve:setVisible(false)
					end
					local panel_daily = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_richang_pve")
					if nil ~= panel_daily then
						panel_daily:setVisible(false)
					end
					local pveButton = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_pve_1")
					if nil ~= pveButton then
						pveButton:setHighlighted(false)
						pveButton:setVisible(true)
					end

					instance.pveMenuPanel:setVisible(true)
					instance:changePveButtonsMenu(2)

					state_machine.excute("pve_daily_top_info_hide",0,"")
				end
				fwin:close(fwin:find("PVEDailyActivityCopyClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 主线、精英菜单按钮切换
		local plot_change_to_abyss_menu_terminal = {
            _name = "plot_change_to_abyss_menu",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local index = params._datas.button_type
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					if instance.m_scenes_type == tonumber(index) then
						return
					end
				end

				-- 刷新世界等级tip
				self:showWorldGradeTip(tonumber(index))

				if tonumber(index) == 1 then
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						instance.m_scenes_type = tonumber(index)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_1031"):setHighlighted(true)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_1031"):setTouchEnabled(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_1030"):setHighlighted(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_1030"):setTouchEnabled(true)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_em"):setHighlighted(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_em"):setTouchEnabled(true)

						instance:showSuperMoppingButton(tonumber(index))

						instance.Button_1:setVisible(true)
						instance.Button_2:setVisible(false)

						instance.is_show_panel = true
						state_machine.excute("lduplicate_window_show_panel",0,"")
					end
					--普通
					state_machine.excute("lduplicate_window_switch", 0, 
						{
							_datas = {
								terminal_name = "lduplicate_window_switch", 	
								next_terminal_name = "plot_change_to_common", 	
								current_button_name = "Button_pve_2",  
								group_name = self._enumUiGroup._PVE_DIFFICULTY,				
								terminal_state = 0, 
								isPressedActionEnabled = false
							}
						}
					)
				elseif tonumber(index) == 2 then
					local _opened = false
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						then
						_opened = funOpenDrawTip(108)
					else
						_opened = false
					end
					if _opened == false then
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
							instance.m_scenes_type = tonumber(index)
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_1031"):setHighlighted(false)
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_1031"):setTouchEnabled(true)
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_1030"):setHighlighted(true)
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_1030"):setTouchEnabled(false)
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_em"):setHighlighted(false)
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_em"):setTouchEnabled(true)
							
							instance:showSuperMoppingButton(tonumber(index))

							instance.Button_1:setVisible(true)
							instance.Button_2:setVisible(false)

							instance.is_show_panel = true
							state_machine.excute("lduplicate_window_show_panel",0,"")
						end
						--精英
						state_machine.excute("lduplicate_window_switch", 0, 
							{
								_datas = {
									terminal_name = "lduplicate_window_switch", 	
									next_terminal_name = "plot_change_to_abyss", 	
									current_button_name = "Button_jingyingbt",  
									group_name = self._enumUiGroup._PVE_DIFFICULTY,				
									terminal_state = 0, 
									isPressedActionEnabled = false
								}
							}
						)
					end
				elseif tonumber(index) == 15 then
					local _opened = false
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						then
						_opened = funOpenDrawTip(109)
					else
						_opened = false
					end
					if _opened == false then
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
							instance.m_scenes_type = tonumber(index)
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_1031"):setHighlighted(false)
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_1031"):setTouchEnabled(true)
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_1030"):setHighlighted(false)
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_1030"):setTouchEnabled(true)
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_em"):setHighlighted(true)
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_em"):setTouchEnabled(false)

							instance:showSuperMoppingButton(tonumber(index))

							instance.Button_1:setVisible(false)
							instance.Button_2:setVisible(true)
						end
						--噩梦
						state_machine.excute("lduplicate_window_switch", 0, 
							{
								_datas = {
									terminal_name = "lduplicate_window_switch", 	
									next_terminal_name = "plot_change_to_em", 	
									current_button_name = "Button_emeng",  
									group_name = self._enumUiGroup._PVE_EM,				
									terminal_state = 0, 
									isPressedActionEnabled = false
								}
							}
						)
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--显示名将副本可挑战次数，做状态机方便刷新,不可见，就直接setvisible
		local general_copy_show_attack_times_terminal = {
            _name = "general_copy_show_attack_times",
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
		--显示日常副本可挑战次数
		local daily_copy_show_attack_times_terminal = {
            _name = "daily_copy_show_attack_times",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.lock("daily_copy_show_attack_times")
				instance:setDailyAttactTimes()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local daily_copy_show_add_roots_terminal = {
            _name = "daily_copy_show_add_roots",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local index = LDuplicateWindow._pageViews:getPages()
				for i=#index, 1, -1 do
					local m_root = LDuplicateWindow._pageViews:getPage(i-1).roots[1]
					table.insert(instance.roots, m_root)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local lduplicate_window_switch_to_terminal = {
            _name = "lduplicate_window_switch_to",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:switchTo(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local Button_pve_chapter_terminal = {
            _name = "Button_pve_chapter",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:switchTo(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local lduplicate_window_remove_old_page_terminal = {
            _name = "lduplicate_window_remove_old_page",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local scheduler = cc.Director:getInstance():getScheduler()  
            	local schedulerID = nil  
            	schedulerID = scheduler:scheduleScriptFunc(function ()
            		if zstring.tonumber(LDuplicateWindow._pageViews.pageNumber) > 0 then
		            	for i,v in pairs(LDuplicateWindow._pageViews:getPages()) do
		            		if i > LDuplicateWindow._pageViews.pageNumber then
								LDuplicateWindow._pageViews:removePage(v)  
							end
						end
					end
					LDuplicateWindow._pageViews.pageNumber = 0
					if zstring.tonumber(LDuplicateWindow._pageViewsElite.pageNumber) > 0 then
						for i,v in pairs(LDuplicateWindow._pageViewsElite:getPages()) do
		            		if i > LDuplicateWindow._pageViewsElite.pageNumber then
								LDuplicateWindow._pageViewsElite:removePage(v)  
							end
						end
					end
					LDuplicateWindow._pageViewsElite.pageNumber = 0

					if zstring.tonumber(LDuplicateWindow._pageViewsEm.pageNumber) > 0 then
						for i,v in pairs(LDuplicateWindow._pageViewsEm:getPages()) do
		            		if i > LDuplicateWindow._pageViewsEm.pageNumber then
								LDuplicateWindow._pageViewsEm:removePage(v)  
							end
						end
					end
					LDuplicateWindow._pageViewsEm.pageNumber = 0

            		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID)
                end,0.5,false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local lduplicate_window_goto_formation_terminal = {
            _name = "lduplicate_window_goto_formation",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	_ED.lduplicate_window_go_fotmation_info = {}
            	_ED.lduplicate_window_go_fotmation_info.sceneType = _ED._current_scene_type
            	if tonumber(_ED._current_scene_type) == 2 then
	            	local currentPageIndex = LDuplicateWindow._pageViewsElite:getCurPageIndex()
	            	_ED.lduplicate_window_go_fotmation_info.sceneId = LDuplicateWindow._pageViewsElite:getPage(currentPageIndex).m_SceneId
            	else
            		local currentPageIndex = LDuplicateWindow._pageViews:getCurPageIndex()
	            	_ED.lduplicate_window_go_fotmation_info.sceneId = LDuplicateWindow._pageViews:getPage(currentPageIndex).m_SceneId
            	end
            	state_machine.excute("lduplicate_window_return", 0, nil)
            	local chooseShip = nil
            	for i = 2, 7 do
					local shipId = _ED.formetion[i]
					if zstring.tonumber(shipId) > 0 then
			            local ship = _ED.user_ship[shipId]
			            if chooseShip == nil then
			            	chooseShip = ship
			            end
			            if shipIsCanEvolution(ship) == true then
			                chooseShip = ship
			                break
			            end 
			            if shipIsCanUpGradeStar(ship) == true then
			                chooseShip = ship
			                break
			            end
			            if shipIsCanProcess(ship) == true then
			                chooseShip = ship
			                break
			            end
			            if shipEquipmentIsCanEvolution(ship) == true then
			                chooseShip = ship
			                break
			            end
			            if shipEquipmentIsCanAwake(ship) == true then
			                chooseShip = ship
			                break
			            end
					end
				end
            	state_machine.excute("formation_open_instance_window", 0, {_datas = {_shipInstance = chooseShip, _enter_type = "lduplicateWindow"}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local lduplicate_window_show_panel_terminal = {
        	_name = "lduplicate_window_show_panel",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local Panel_em_line = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_em_line")
            	if Panel_em_line then
            		Panel_em_line:setVisible(not instance.is_show_panel)
            		instance.is_show_panel = not instance.is_show_panel
            	end
            	return true
            end,
            _terminal = nil,
            _terminals = nil

    	}


    	local battle_ready_window_open_join_formation_window_terminal = {
            _name = "battle_ready_window_open_join_formation_window",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                _ED.activity_battle_copy_formation_limit = nil
                if instance.currentSceneType == 52 then
                    _ED.activity_battle_copy_formation_limit = 3
                end
                state_machine.excute("hero_formation_choice_wear_window_open", 0, {params._datas.cell_index, 5, -1, _ED.em_user_ship, "battle_ready_window_join_formation", params._datas.cell_index})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local battle_ready_window_join_formation_terminal = {
            _name = "battle_ready_window_join_formation",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:joinFormtion(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local em_one_key_formation_window_terminal = {
            _name = "em_one_key_formation_window",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:oneKeyFormationChange()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local em_formation_save_terminal = {
            _name = "em_formation_save",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if _ED.em_user_ship and table.nums(_ED.em_user_ship) ~= 0 then
            		local formation = ""
            		for i,v in ipairs(_ED.em_user_ship) do
            			if formation == "" then
            				formation = v
            			else
            				formation = formation .. "," .. v
            			end
            			
            		end
            		local function responseCallback(response)
	                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
	                        	--TipDlg.drawTextDailog(_new_interface_text[72])
	                        	self:updateHeroIcons()
	                        end
	                    end
	                end
            		protocol_command.save_hard_copy_user_formation.param_list = formation
                	NetworkManager:register(protocol_command.save_hard_copy_user_formation.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local em_team_window_formation_change_terminal = {
            _name = "em_team_window_formation_change",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.formation.FormationChange")
            	local temp_em_user_ship = {}
            	table.add(temp_em_user_ship, _ED.em_user_ship)
            	if table.nums(_ED.em_user_ship) == 6 then
            		table.insert(temp_em_user_ship, 1, 1)
            	end
            	state_machine.excute("formation_change_window_open", 0, {nil, "em_team_window_formation_change_request", nil, nil, temp_em_user_ship})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local em_team_window_formation_change_request_terminal = {
            _name = "em_team_window_formation_change_request",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local old_em_user_ship = {}
            	local temp = {}
    			table.add(old_em_user_ship, _ED.em_user_ship)
    			table.add(temp, params)
            	if params then
            		if table.nums(params) == 7 then
            			table.remove(temp, 1)
            			table.merge(_ED.em_user_ship, temp)
            		else
            			table.merge(_ED.em_user_ship, temp)
            		end
            		local result = false
            		for i,v in ipairs(_ED.em_user_ship) do
				    	if old_em_user_ship[i] ~= v then
				    		result = true
				    		break
				    	end
            		end
            		if result then
				    	state_machine.excute("em_formation_save", 0, "")
				    end
            	end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 超级扫荡事件
        local super_mopping_button_touch_terminal = {
            _name = "super_mopping_button_touch",
            _init = function(terminal)
                app.load("client.duplicate.pve.PveSuperMopping")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local user_level = _ED.user_info.user_grade
                local target_level = tipStringInfo_mopping_word[3]
                if tonumber(user_level) >= tonumber(target_level) then
                    local datas = {}
                    local chapter_id = self:getOpenScene()
                    local npc_number = _ED.scene_current_state[chapter_id]
                    local pve_scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, self:getPageIndex())

                    local function table_push(table_arr, value)
                        if value ~= nil then
                            table.insert(table_arr, tonumber(value))
                        end
                    end

                    for i, pve_scene_info in pairs(pve_scenes) do
                        local current_data = {current_chapter_id = tonumber(pve_scene_info[pve_scene.id]), npc_star = {}, npc_id = {}}
                        if tonumber(pve_scene_info[pve_scene.id]) < chapter_id then
                            local npcs_str = pve_scene_info[pve_scene.npcs]
                            local npcs = zstring.split(npcs_str, ",")
                            if LDuplicateWindow._infoDatas._type == 1 then
                                table_push(current_data.npc_star, _ED.npc_state[tonumber(npcs[3])])
                                table_push(current_data.npc_id, npcs[3])

                                table_push(current_data.npc_star, _ED.npc_state[tonumber(npcs[6])])
                                table_push(current_data.npc_id, npcs[6])

                                table_push(current_data.npc_star, _ED.npc_state[tonumber(npcs[9])])
                                table_push(current_data.npc_id, npcs[9])
                            elseif LDuplicateWindow._infoDatas._type == 2 then
                                for j = 1, #npcs do
                                    table_push(current_data.npc_star, _ED.npc_state[tonumber(npcs[j])])
                                    table_push(current_data.npc_id, npcs[j])
                                end
                            end
                            table.insert(datas, current_data)
                        elseif tonumber(pve_scene_info[pve_scene.id]) == chapter_id then
                            local npcs_str = pve_scene_info[pve_scene.npcs]
                            local npcs = zstring.split(npcs_str, ",")
                            if LDuplicateWindow._infoDatas._type == 1 then
                                if tonumber(npc_number) / 3 > 0 then
                                    if tonumber(npc_number) / 3 >= 1 and tonumber(npc_number) / 3 < 2 then
                                        table_push(current_data.npc_star, _ED.npc_state[tonumber(npcs[3])])
                                        table_push(current_data.npc_id, npcs[3])
                                    elseif tonumber(npc_number) / 3 >= 2 and tonumber(npc_number) / 3 < 3 then
                                        table_push(current_data.npc_star, _ED.npc_state[tonumber(npcs[3])])
                                        table_push(current_data.npc_id, npcs[3])

                                        table_push(current_data.npc_star, _ED.npc_state[tonumber(npcs[6])])
                                        table_push(current_data.npc_id, npcs[6])
                                    elseif tonumber(npc_number) / 3 >= 3 then
                                        table_push(current_data.npc_star, _ED.npc_state[tonumber(npcs[3])])
                                        table_push(current_data.npc_id, npcs[3])

                                        table_push(current_data.npc_star, _ED.npc_state[tonumber(npcs[6])])
                                        table_push(current_data.npc_id, npcs[6])

                                        table_push(current_data.npc_star, _ED.npc_state[tonumber(npcs[9])])
                                        table_push(current_data.npc_id, npcs[9])
                                    end
                                end
                            elseif LDuplicateWindow._infoDatas._type == 2 then
                                for k = 1, tonumber(npc_number) do
                                    table_push(current_data.npc_star, _ED.npc_state[tonumber(npcs[k])])
                                    table_push(current_data.npc_id, npcs[k])
                                end
                            end
                            table.insert(datas, current_data)
                        end
                    end

                    state_machine.excute("pve_super_mopping_open", 0, datas)
                else
                    TipDlg.drawTextDailog(tipStringInfo_mopping_word[4])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 刷新一键领取按钮的显示
		local lduplicate_window_show_one_click_terminal = {
            _name = "lduplicate_window_show_one_click",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil then
					instance:showOneClickBtn()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 一键领取所有奖励
		local lduplicate_window_get_one_click_reward_terminal = {
            _name = "lduplicate_window_get_one_click_reward",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil then
					local function responseCallback(response)
	                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
								local getRewardWnd = DrawRareReward:new()
								getRewardWnd:init(7)
								getRewardWnd:updateSortState(false)
								fwin:open(getRewardWnd,fwin._ui)
								
								-- 刷新场景宝箱状态
								local is2002 = false
								if __lua_project_id == __lua_project_warship_girl_a 
								or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
								or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
								or __lua_project_id == __lua_project_koone
								then
									if dev_version >= 2002 then
										is2002 = true
									end
								end
								if true == is2002 then
									state_machine.excute("duplicate_pve_secondary_scene_star_box_update_panel",0 ,"event duplicate_pve_secondary_scene_star_box_update_panel.")
								else
									state_machine.excute("pve_star_cheat_update_panel",0 ,"event pve_star_cheat_update_panel.")
								end

								state_machine.excute("lpve_scene_updeteinfo",0,"")--刷新顶部信息
								state_machine.excute("lpve_main_scene_updeteinfo",0,"")

								-- 刷新一键领取按钮显隐状态
	                        	state_machine.excute("lduplicate_window_show_one_click", 0, nil)
								response.node:updateChestState()
								response.node:updateArrowRedDot()
	                        end
	                    end
	                end
					local curPageIndex = instance:getPageIndex()
            		protocol_command.one_key_draw_scene_reward.param_list = curPageIndex
                	NetworkManager:register(protocol_command.one_key_draw_scene_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(lduplicate_window_switch_terminal)
        state_machine.add(lduplicate_window_visible_terminal)
        state_machine.add(lduplicate_window_return_terminal)
        state_machine.add(general_copy_terminal)
        state_machine.add(plot_copy_terminal)
        state_machine.add(daily_copy_terminal)
        state_machine.add(plot_change_to_common_terminal)
        state_machine.add(plot_change_to_abyss_terminal)
        state_machine.add(plot_change_to_em_terminal)
        state_machine.add(general_copy_show_attack_times_terminal)
        state_machine.add(daily_copy_show_attack_times_terminal)
        state_machine.add(plot_change_to_abyss_menu_terminal)
        state_machine.add(daily_copy_show_add_roots_terminal)
        state_machine.add(lduplicate_window_switch_to_terminal)
        state_machine.add(lduplicate_window_remove_old_page_terminal)
        state_machine.add(lduplicate_window_goto_formation_terminal)
        state_machine.add(lduplicate_window_show_panel_terminal)
        state_machine.add(battle_ready_window_open_join_formation_window_terminal)
        state_machine.add(battle_ready_window_join_formation_terminal)
        state_machine.add(em_one_key_formation_window_terminal)
        state_machine.add(em_formation_save_terminal)
        state_machine.add(em_team_window_formation_change_terminal)
        state_machine.add(em_team_window_formation_change_request_terminal)
        state_machine.add(lduplicate_window_show_one_click_terminal)
        state_machine.add(lduplicate_window_get_one_click_reward_terminal)

        -- 超级扫荡事件
		state_machine.add(super_mopping_button_touch_terminal)
		
		if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
			state_machine.add(Button_pve_chapter_terminal)
		end
		state_machine.init()
    end
    
    -- call func init hom state machine.
    init_lduplicate_window_terminal()
end

-- 更新地图npc宝箱状态
function LDuplicateWindow:updateChestState()
	local curSceneType = tonumber(_ED._current_scene_type) 
	local curPageView = self:getPageViewByType(curSceneType)
	local curIndex = curPageView:getCurPageIndex()
	local curMap = curPageView:getPage(curIndex)
	curMap:drawPVERewardBox()
end

-- 一键领取按钮的显隐
function LDuplicateWindow:showOneClickBtn()
	if self.Button_receive == nil then
		return
	end

	local sceneID =  self:getOpenScene()
	local sceneType = self:getPageIndex()
	local startSceneInfo = dms.searchs(dms["pve_scene"], pve_scene.scene_type, sceneType)[1]
	-- 获取关卡类型的起始场景ID
	local startSceneID = dms.atoi(startSceneInfo, pve_scene.id)
	local isShow = false
	-- 检测击杀NPC宝箱是否被领取
	local isCheckNPCTreasureChest = true
	for i = startSceneID, sceneID do
		isShow = checkGetLastSceneReward(i, isCheckNPCTreasureChest)
		if isShow == true then
			break
		end
	end

	self.Button_receive:setVisible(isShow)
end

function LDuplicateWindow:getPageViewByType(curSceneType)
	local curPageView = nil
	if curSceneType == 1 then
		curPageView = LDuplicateWindow._pageViews
	elseif curSceneType == 2 then
		curPageView = LDuplicateWindow._pageViewsElite
	elseif curSceneType == 15 then
		curPageView = LDuplicateWindow._pageViewsEm
	end

	return curPageView
end

-- 刷新左边箭头和右边箭头的红点
function LDuplicateWindow:updateArrowRedDot()
	local root = self.roots[1]
	local redDotPicLeft = ccui.Helper:seekWidgetByName(root,"Image_tip_1")
	local redDotPicRight = ccui.Helper:seekWidgetByName(root,"Image_tip_2")

	if redDotPicLeft ~= nil and redDotPicRight ~= nil then
		local curSceneType = tonumber(_ED._current_scene_type) 
		local curPageView = self:getPageViewByType(curSceneType)
	
		if curPageView ~= nil then
			self:showArrowRedDot(curPageView, curSceneType)
		end
	end
end

-- 是否存在可领取且未领取的宝箱
function LDuplicateWindow:checkChestCanReceive(startSceneID, endSceneID)
	-- 是否存在未被领取的关卡宝箱
	local isCanReceiveChset = false
	-- 不检测击杀NPC宝箱是否被领取
	local isCheckNPCTreasureChest = false
	for sceneID = startSceneID, endSceneID do
		isCanReceiveChset = checkGetLastSceneReward(sceneID, isCheckNPCTreasureChest)
		if isCanReceiveChset == true then
			break
		end
	end
	return isCanReceiveChset
end

-- 控制左边箭头和右边箭头的红点
function LDuplicateWindow:showArrowRedDot(_pageViews, curType)
	-- curType：1、普通 2、精英 3、噩梦
	local sceneid =  self:getOpenScene()
	-- 每个类型的场景起始ID为50的倍数+1
	local curTypeStartIndex = (curType - 1) * 50 + 1
	local currentPageIndex = tonumber(_pageViews:getCurPageIndex() + curTypeStartIndex)

	local isDrawRightRedDot = false
	local isDrawLeftRedDot = false
	-- 判断当前界面左边是否有关卡宝箱可领取
	if currentPageIndex > 1 then
		isDrawLeftRedDot = self:checkChestCanReceive(curTypeStartIndex, currentPageIndex - 1)
	end
	self:displayRedDot(isDrawLeftRedDot, "left")
	-- 判断当前界面右边是否有关卡宝箱可领取
	if currentPageIndex < sceneid then
		isDrawRightRedDot = self:checkChestCanReceive(currentPageIndex + 1, sceneid)
	end
	self:displayRedDot(isDrawRightRedDot, "right")
end

-- 红点的显隐
function LDuplicateWindow:displayRedDot(drawState, direction)
	local root = self.roots[1]
	local redDotPic = nil

	if direction == "left" then
		redDotPic = ccui.Helper:seekWidgetByName(root,"Image_tip_1")
	elseif direction == "right" then
		redDotPic = ccui.Helper:seekWidgetByName(root,"Image_tip_2")
	end

	if redDotPic ~= nil then
		if drawState == true then
			redDotPic:setVisible(true)
		else
			redDotPic:setVisible(false)
		end
	end

end

function LDuplicateWindow:showPveMap()
	for k,v in pairs(LDuplicateWindow._pageViewsElite:getPages()) do
		v:unLoad()
	end
	for k,v in pairs(LDuplicateWindow._pageViews:getPages()) do
		v:unLoad()
	end
	for k,v in pairs(LDuplicateWindow._pageViewsEm:getPages()) do
		v:unLoad()
	end
	local sceneid =  self:getOpenScene()
	if fwin:find("LPVENewMapClass") == nil then
		if self.openinitmap == 1 then
			self.openinitmap = nil
		elseif self.openinitmap == nil then
			state_machine.excute("lduplicate_window_pve_quick_entrance",0,{_type = 1, _sceneId = sceneid})
		end
	else
		fwin:find("LPVENewMapClass"):setVisible(true)
		local mainScene = fwin:find("LPVEMainSceneClass")
		if mainScene ~= nil then 
			mainScene:setVisible(true)
			mainScene:init(sceneid,nil,1)
		end
		local cheatWindow = fwin:find("PVEStarCheatPanelClass")
		if cheatWindow ~= nil then 
			cheatWindow:setVisible(true)
			
			cheatWindow:init(sceneid)
			cheatWindow:onUpdateAllDraw()
			cheatWindow:onUpdateBoxDraw()
		end
		
	end
	--精英
	if fwin:find("LPVEAbyssNewMapClass") ~= nil then
		fwin:find("LPVEAbyssNewMapClass"):setVisible(false)
	end	
	if fwin:find("LPVERaidSelectPanelClass") ~= nil then
		fwin:find("LPVERaidSelectPanelClass"):setVisible(true)
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		LDuplicateWindow._pageViews:setVisible(true)
		LDuplicateWindow._pageViewsElite:setVisible(false)
		LDuplicateWindow._pageViewsEm:setVisible(false)
		
		local currentPageIndex = LDuplicateWindow._pageViews:getCurPageIndex()
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local max_sceneid = tonumber(sceneid)
			local max_open_scene = zstring.split(dms.string(dms["pve_scene"], max_sceneid, pve_scene.open_scene),",")[1]
			if #zstring.split(dms.string(dms["pve_scene"], max_sceneid, pve_scene.npcs),",") == zstring.tonumber(_ED.scene_current_state[tonumber(max_sceneid)]) 
				and dms.int(dms["pve_scene"], tonumber(max_open_scene), pve_scene.open_level) < 999 then
			-- if currentPageIndex - 1 < #LDuplicateWindow._pageViewsElite:getPages() - 1 then
			-- if sceneid > LDuplicateWindow._pageViewsElite:getPage(currentPageIndex-1).m_SceneId then
				ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_2"):setVisible(true)
			else
				ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_2"):setVisible(false)
			end
		else
			if currentPageIndex < #LDuplicateWindow._pageViews:getPages() - 1 then
				ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_2"):setVisible(true)
			else
				ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_2"):setVisible(false)
			end
		end
		if currentPageIndex > 0 then
			ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_1"):setVisible(true)
		else
			ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_1"):setVisible(false)
		end

		if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
			ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_2"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_1"):setVisible(false)
		end
	end
end

--显示精英副本
function LDuplicateWindow:showAbyssMap()
	for k,v in pairs(LDuplicateWindow._pageViewsElite:getPages()) do
		v:unLoad()
	end
	for k,v in pairs(LDuplicateWindow._pageViews:getPages()) do
		v:unLoad()
	end
	for k,v in pairs(LDuplicateWindow._pageViewsEm:getPages()) do
		v:unLoad()
	end
	local sceneid =  self:getOpenScene()
	if fwin:find("LPVEAbyssNewMapClass") == nil then
		if self.openinitmap == 1 then
			self.openinitmap = nil
		elseif self.openinitmap == nil then
			state_machine.excute("lduplicate_window_pve_quick_entrance",0,{_type = 2, _sceneId = sceneid})
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				state_machine.excute("lpve_main_scene_check_mission", 0, sceneid)
			end
		end
	else
		fwin:find("LPVEAbyssNewMapClass"):setVisible(true)
		local mainScene = fwin:find("LPVEMainSceneClass")
		if mainScene ~= nil then 
			mainScene:setVisible(true)
			mainScene:init(sceneid,nil,2)
		end
		local cheatWindow = fwin:find("PVEStarCheatPanelClass")
		if cheatWindow ~= nil then 
			cheatWindow:setVisible(true)
			cheatWindow:init(sceneid)
			cheatWindow:onUpdateAllDraw()
			cheatWindow:onUpdateBoxDraw()
		end
	end

	if fwin:find("LPVENewMapClass") ~= nil then
		fwin:find("LPVENewMapClass"):setVisible(false)
	end
	if fwin:find("LPVERaidSelectPanelClass") ~= nil then
		fwin:find("LPVERaidSelectPanelClass"):setVisible(true)
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		LDuplicateWindow._pageViews:setVisible(false)
		LDuplicateWindow._pageViewsElite:setVisible(true)
		LDuplicateWindow._pageViewsEm:setVisible(false)
        local currentPageIndex = LDuplicateWindow._pageViewsElite:getCurPageIndex()
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local max_sceneid = tonumber(sceneid)
			local max_open_scene = zstring.split(dms.string(dms["pve_scene"], max_sceneid, pve_scene.open_scene),",")[1]
			if #zstring.split(dms.string(dms["pve_scene"], max_sceneid, pve_scene.npcs),",") == zstring.tonumber(_ED.scene_current_state[tonumber(max_sceneid)]) 
				and dms.int(dms["pve_scene"], tonumber(max_open_scene), pve_scene.open_level) < 999 then
			-- if currentPageIndex - 1 < #LDuplicateWindow._pageViewsElite:getPages() - 1 then
			-- if sceneid > LDuplicateWindow._pageViewsElite:getPage(currentPageIndex-1).m_SceneId then
				ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_2"):setVisible(true)
			else
				ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_2"):setVisible(false)
			end
		else
			if currentPageIndex < #LDuplicateWindow._pageViewsElite:getPages() - 1 then
				ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_2"):setVisible(true)
			else
				ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_2"):setVisible(false)
			end
		end
		if currentPageIndex > 0 then
			ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_1"):setVisible(true)
		else
			ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_1"):setVisible(false)
		end

		if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
			ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_2"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_1"):setVisible(false)
		end
	end
end

--显示噩梦副本
function LDuplicateWindow:showEmMap()
	for k,v in pairs(LDuplicateWindow._pageViewsElite:getPages()) do
		v:unLoad()
	end
	for k,v in pairs(LDuplicateWindow._pageViews:getPages()) do
		v:unLoad()
	end
	for k,v in pairs(LDuplicateWindow._pageViewsEm:getPages()) do
		v:unLoad()
	end
	local sceneid =  self:getOpenScene()
	if fwin:find("LPVEAbyssNewMapClass") == nil then
		if self.openinitmap == 1 then
			self.openinitmap = nil
		elseif self.openinitmap == nil then
			state_machine.excute("lduplicate_window_pve_quick_entrance",0,{_type = 15, _sceneId = sceneid})
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				state_machine.excute("lpve_main_scene_check_mission", 0, sceneid)
			end
		end
	else
		fwin:find("LPVEAbyssNewMapClass"):setVisible(true)
		local mainScene = fwin:find("LPVEMainSceneClass")
		if mainScene ~= nil then 
			mainScene:setVisible(true)
			mainScene:init(sceneid,nil,15)
		end
		local cheatWindow = fwin:find("PVEStarCheatPanelClass")
		if cheatWindow ~= nil then 
			cheatWindow:setVisible(true)
			cheatWindow:init(sceneid)
			cheatWindow:onUpdateAllDraw()
			cheatWindow:onUpdateBoxDraw()
		end
	end

	if fwin:find("LPVENewMapClass") ~= nil then
		fwin:find("LPVENewMapClass"):setVisible(false)
	end
	if fwin:find("LPVERaidSelectPanelClass") ~= nil then
		fwin:find("LPVERaidSelectPanelClass"):setVisible(true)
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		LDuplicateWindow._pageViews:setVisible(false)
		LDuplicateWindow._pageViewsElite:setVisible(false)
		LDuplicateWindow._pageViewsEm:setVisible(true)

        local currentPageIndex = LDuplicateWindow._pageViewsEm:getCurPageIndex()
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local max_sceneid = tonumber(sceneid)
			local max_open_scene = zstring.split(dms.string(dms["pve_scene"], max_sceneid, pve_scene.open_scene),",")[1]
			if #zstring.split(dms.string(dms["pve_scene"], max_sceneid, pve_scene.npcs),",") == zstring.tonumber(_ED.scene_current_state[tonumber(max_sceneid)]) 
				and dms.int(dms["pve_scene"], tonumber(max_open_scene), pve_scene.open_level) < 999 then
			-- if currentPageIndex - 1 < #LDuplicateWindow._pageViewsElite:getPages() - 1 then
			-- if sceneid > LDuplicateWindow._pageViewsElite:getPage(currentPageIndex-1).m_SceneId then
				ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_2"):setVisible(true)
			else
				ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_2"):setVisible(false)
			end
		else
			if currentPageIndex < #LDuplicateWindow._pageViewsEm:getPages() - 1 then
				ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_2"):setVisible(true)
			else
				ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_2"):setVisible(false)
			end
		end
		if currentPageIndex > 0 then
			ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_1"):setVisible(true)
		else
			ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_1"):setVisible(false)
		end

		if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
			ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_2"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_1"):setVisible(false)
		end
	end
end

function LDuplicateWindow:hidePveMap()
	if fwin:find("LPVENewMapClass") ~= nil then
		fwin:find("LPVENewMapClass"):setVisible(false)
		fwin:find("LPVEMainSceneClass"):setVisible(false)
		fwin:find("PVEStarCheatPanelClass"):setVisible(false)
	end
	if fwin:find("LPVEAbyssNewMapClass") ~= nil then
		fwin:find("LPVEAbyssNewMapClass"):setVisible(false)
	end

	if fwin:find("LPVERaidSelectPanelClass") ~= nil then
		fwin:find("LPVERaidSelectPanelClass"):setVisible(false)
	end
	local root = self.roots[1]
	if root ~= nil then 
		ccui.Helper:seekWidgetByName(root,"Image_jingying"):setVisible(false)
	end
end

function LDuplicateWindow:getOpenScene()
	local sceneid = 0
	local _scenes = nil
	if LDuplicateWindow._infoDatas._type  == 1 then 
		--普通副本
		_scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, 0)
		for i, v in pairs(_scenes) do
			local tempSceneId = dms.atoi(v, pve_scene.id)
			if _ED.scene_current_state[tempSceneId] == nil
				or _ED.scene_current_state[tempSceneId] == ""
				or tonumber(_ED.scene_current_state[tempSceneId]) < 0 
				then
				sceneid = i - 1
				break
			end
		end
		local textScene = 0
		for i = 1,table.getn(_ED.scene_current_state) do
			if tonumber(_ED.scene_current_state[i]) == -1 then
				textScene = i - 1
				break
			end
		end
	elseif LDuplicateWindow._infoDatas._type  == 2 then
		--精英副本
		_scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, 1)

		for i, v in pairs(_scenes) do
			local tempSceneId = dms.atoi(v, pve_scene.id)
			if _ED.scene_current_state[tempSceneId] == nil
				or _ED.scene_current_state[tempSceneId] == ""
				or tonumber(_ED.scene_current_state[tempSceneId]) < 0 
				then
				sceneid = tempSceneId - 1
				break
			end
		end
	elseif LDuplicateWindow._infoDatas._type  == 15 then
		--噩梦副本
		_scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, 15)
		for i, v in pairs(_scenes) do
			local tempSceneId = dms.atoi(v, pve_scene.id)
			if _ED.scene_current_state[tempSceneId] == nil
				or _ED.scene_current_state[tempSceneId] == ""
				or tonumber(_ED.scene_current_state[tempSceneId]) < 0 
				then
				sceneid = tempSceneId - 1
				break
			end
		end
	end
	return sceneid
end

--副本菜单界面 --精英，普通
function LDuplicateWindow:changePveButtonsMenu(pve_type)
	local root = self.roots[1] 
	if root == nil then 
		return
	end
	--切换到日常或则英雄 副本界面主动切换到主线 
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        ccui.Helper:seekWidgetByName(root,"Button_1031"):setVisible(true) --主线按钮 
		ccui.Helper:seekWidgetByName(root,"Button_1030"):setVisible(true) --精英按钮
    else
      	ccui.Helper:seekWidgetByName(root,"Button_1031"):setVisible(pve_type == 1 or pve_type == 3 ) --主线按钮 
		ccui.Helper:seekWidgetByName(root,"Button_1030"):setVisible(pve_type == 2) --精英按钮 
		local ptButton = ccui.Helper:seekWidgetByName(root,"Button_pve_2")
		local jyButton = ccui.Helper:seekWidgetByName(root,"Button_jingyingbt")
		ptButton:setVisible(pve_type == 1 or pve_type == 3) --主线按钮 
		jyButton:setVisible(pve_type == 2) --精英按钮
		if pve_type == 1 or pve_type == 3 then 
			ptButton:setHighlighted(pve_type == 1)
			ccui.Helper:seekWidgetByName(root,"Image_jingying"):setVisible(false)
		else
			jyButton:setHighlighted(true)
			ccui.Helper:seekWidgetByName(root,"Image_jingying"):setVisible(true)
		end	
		self.pveMenuPanel:setVisible(pve_type ~= 3)
    end 
end

function LDuplicateWindow:init(params, _openinitmap) -- _open代表是否初始化的时候就定位
	if params == nil or params == "" then
		-- LDuplicateWindow._infoDatas = {
			-- _type 	 = self._enumPveType._COMMON, -- 默认主线副本
			-- _chapter = -1, 						  -- 副本章节，默认最后一章
		-- }
		
		LDuplicateWindow._infoDatas._type = 1
	else	
		LDuplicateWindow._infoDatas._type = params
	end
	self.openinitmap = _openinitmap
	self.is_show_panel = false

    return self
end
--英雄副本挑战次数
function LDuplicateWindow:setAttackTimes()
	local root = self.roots[1]
	local Panel_yingxiong_pve = ccui.Helper:seekWidgetByName(root, "Panel_yingxiong_pve")
	Panel_yingxiong_pve:setVisible(true)
	local Text_tzcs_0 = ccui.Helper:seekWidgetByName(root,"Text_tzcs_0")
	local params = dms.string(dms["pirates_config"],167, pirates_config.param)
	local tables = zstring.split(params, ",")
	
	Text_tzcs_0:setString(_ED.activity_pve_times[347])--tables[3])
end

--日常副本挑战次数
function LDuplicateWindow:setDailyAttactTimes()
	local root = self.roots[1]
	local vipLevel = zstring.tonumber(_ED.vip_grade)
	local attackCountElement = dms.element(dms["base_consume"], 53)
	local fightCount = dms.atoi(attackCountElement, base_consume.vip_0_value + vipLevel) - zstring.tonumber(_ED.game_activity_times)
	local _times=ccui.Helper:seekWidgetByName(root, "Text_tzcs_0_0")
	local panel_daily = ccui.Helper:seekWidgetByName(root,"Panel_richang_pve")
	panel_daily:setVisible(true)
	_times:setString(fightCount)
	state_machine.unlock("daily_copy_show_attack_times")
end

function LDuplicateWindow:switchTo(params)
	local root = self.roots[1]
	local PageView_pve_map = nil
	if self._infoDatas._type == self._enumPveType._COMMON then
		PageView_pve_map = ccui.Helper:seekWidgetByName(root,"PageView_pve_map")
	elseif self._infoDatas._type == self._enumPveType._ABYSS then
		PageView_pve_map = ccui.Helper:seekWidgetByName(root,"PageView_pve_map_jy")
	elseif self._infoDatas._type == self._enumPveType._EM then
		PageView_pve_map = ccui.Helper:seekWidgetByName(root,"PageView_pve_map_em")
	end
	local currentPageIndex = PageView_pve_map:getCurPageIndex()
	if params._datas.dir == 0 then
		currentPageIndex = currentPageIndex - 1
		if currentPageIndex >= 0 then
			PageView_pve_map:scrollToPage(currentPageIndex)
		end
	end
	if params._datas.dir == 1 then
		local max_sceneid = PageView_pve_map:getPage(currentPageIndex).m_SceneId
		local max_open_scene = zstring.split(dms.string(dms["pve_scene"], max_sceneid, pve_scene.open_scene),",")[1]
		if zstring.tonumber(_ED.user_info.user_grade) < dms.int(dms["pve_scene"], max_open_scene, pve_scene.open_level) then
			TipDlg.drawTextDailog(string.format(_new_interface_text[223],dms.int(dms["pve_scene"], max_open_scene, pve_scene.open_level)))
			return
		end
		local tempSceneId = tonumber(max_open_scene)
		if _ED.scene_current_state[tempSceneId] == nil
			or _ED.scene_current_state[tempSceneId] == ""
			or tonumber(_ED.scene_current_state[tempSceneId]) < 0 
			then
			local needOpenScene = zstring.split(dms.string(dms["pve_scene"], max_open_scene, pve_scene.by_open_scene), ",")
			local isBreak = false
			for k,v in pairs(needOpenScene) do
				local open_id = LDuplicateWindow._infoDatas._type == 15 and v or max_open_scene
				local npcCount = #(zstring.split(dms.string(dms["pve_scene"], open_id, pve_scene.npcs), ","))
				if zstring.tonumber(_ED.scene_current_state[tonumber(v)]) < npcCount then
					isBreak = true
					TipDlg.drawTextDailog(string.format(_new_interface_text[296],dms.string(dms["pve_scene"], tonumber(v), pve_scene.scene_name)))
					break
				end
			end
			if isBreak == false then
				TipDlg.drawTextDailog(_new_interface_text[297])
			end
			return
		end
		currentPageIndex = currentPageIndex + 1
		if currentPageIndex >= 0 then
			PageView_pve_map:scrollToPage(currentPageIndex)
		end
	end
	if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
		local page = params._datas.page
		currentPageIndex = page - 1
		--local max_sceneid = PageView_pve_map:getPage(tonumber(currentPageIndex)).m_SceneId
		if currentPageIndex > 0 then
			local max_open_scene = zstring.split(dms.string(dms["pve_scene"], currentPageIndex, pve_scene.open_scene),",")[1]
			if zstring.tonumber(_ED.user_info.user_grade) < dms.int(dms["pve_scene"], max_open_scene, pve_scene.open_level) then
				TipDlg.drawTextDailog(string.format(_new_interface_text[223],dms.int(dms["pve_scene"], max_open_scene, pve_scene.open_level)))
				return
			end
			local tempSceneId = tonumber(max_open_scene)
			if _ED.scene_current_state[tempSceneId] == nil
				or _ED.scene_current_state[tempSceneId] == ""
				or tonumber(_ED.scene_current_state[tempSceneId]) < 0 
				then
				local needOpenScene = zstring.split(dms.string(dms["pve_scene"], max_open_scene, pve_scene.by_open_scene), ",")
				local isBreak = false
				for k,v in pairs(needOpenScene) do
					local open_id = LDuplicateWindow._infoDatas._type == 15 and v or max_open_scene
					local npcCount = #(zstring.split(dms.string(dms["pve_scene"], open_id, pve_scene.npcs), ","))
					if zstring.tonumber(_ED.scene_current_state[tonumber(v)]) < npcCount then
						isBreak = true
						TipDlg.drawTextDailog(string.format(_new_interface_text[296],dms.string(dms["pve_scene"], tonumber(v), pve_scene.scene_name)))
						break
					end
				end
				if isBreak == false then
					TipDlg.drawTextDailog(_new_interface_text[297])
				end
				return
			end
		end
		if currentPageIndex >= 0 then
			PageView_pve_map:scrollToPage(currentPageIndex)
		end
	end

	if nil ~= PageView_pve_map.callback then
		PageView_pve_map.callback(PageView_pve_map, ccui.PageViewEventType.turning)
	end
end

function LDuplicateWindow:showWorldGradeTip(typeIndex)
	local root = self.roots[1]
    local Panel_word_lv_prompt_box = ccui.Helper:seekWidgetByName(root, "Panel_word_lv_prompt_box")
    Panel_word_lv_prompt_box:setVisible(false)
	if typeIndex ~= 1 and typeIndex ~= 2 then
		Panel_word_lv_prompt_box:setVisible(false)
		return
	end
	--_ED.user_info.world_grade = 85
	-- 世界等级
    if _ED.user_info.world_grade and tonumber(_ED.user_info.user_grade) >= 50 and tonumber(_ED.user_info.user_grade) < _ED.user_info.world_grade then
    	Panel_word_lv_prompt_box:setVisible(true)

    	local worldgrade = ccui.Helper:seekWidgetByName(root, "Text_severs_lv")
    	worldgrade:setString(_ED.user_info.world_grade)

    	local usergrade = ccui.Helper:seekWidgetByName(root, "Text_player_lv")
    	usergrade:setString(_ED.user_info.user_grade)

    	local Text_duplicate_exp_lv = ccui.Helper:seekWidgetByName(root, "Text_duplicate_exp_lv")
    	
    	local data = zstring.split(dms.string(dms["order_config"], 3, 4), "|")

    	local expData = nil
    	local gradeOffset = _ED.user_info.world_grade - tonumber(_ED.user_info.user_grade)
    	if gradeOffset > 20 then
    		expData = data[2]
    	else
    		expData = data[1]
    	end

    	if expData then
    		local expArr = zstring.split(expData, ",")
    		local expValue = expArr[typeIndex + 1]
    		Text_duplicate_exp_lv:setString(expValue .. "%")
    	end

    	local Text_dh_info = ccui.Helper:seekWidgetByName(root, "Text_dh_info")
    	local Text_dh_info_jy = ccui.Helper:seekWidgetByName(root, "Text_dh_info_jy")
    	if typeIndex == 1 then
    		Text_dh_info:setVisible(true)
    		Text_dh_info_jy:setVisible(false)
    	elseif typeIndex == 2 then
    		Text_dh_info:setVisible(false)
    		Text_dh_info_jy:setVisible(true)
    	end

    end
end

function LDuplicateWindow:onEnterTransitionFinish()
    local csbDuplicate = csb.createNode("duplicate/pve_main.csb")
    local root = csbDuplicate:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbDuplicate)
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        app.load("client.home.WarshipGirlPushInfo")
        state_machine.excute("warship_girl_push_info_open",0,{_datas={_openType=0}})
    end
    local function addBackFunCall( ... )
    	-- 设置UI的事件响应
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_103"), nil, 
		{
			terminal_name = "lduplicate_window_return", 	
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
    end
	
	if __lua_project_id == __lua_project_gragon_tiger_gate then
		local action = csb.createTimeline("duplicate/pve_main.csb") 
		table.insert(self.actions, action )
		csbDuplicate:runAction(action)

		action:setFrameEventCallFunc(function (frame)
	        if nil == frame then
	            return
	        end
	        local str = frame:getEvent()
	        if str == "window_open_over" then
	            addBackFunCall()
	        end
	    end)
		action:play("window_open", false)
		--state_machine.excute("lpve_scene_return", 0, nil)
	-- else
	end
		addBackFunCall()
    
	---------------------------------------------------------------------------
	-- _PVE_TYPE
	---------------------------------------------------------------------------
	-- 名将
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_1"), nil, 
	{
		terminal_name = "lduplicate_window_switch", 	
		next_terminal_name = "general_copy",
		current_button_name = "Button_pve_1",
		group_name = self._enumUiGroup._PVE_TYPE,
		terminal_state = 0, 
		isPressedActionEnabled = false}, 
	nil, 0)
-----------------------------------------


    -- 一键领取宝箱事件
    self.Button_receive = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_receive"), nil, 
    {
        terminal_name = "lduplicate_window_get_one_click_reward",
        terminal_state = 0, 
        isPressedActionEnabled = true,
    },
    nil,0)

	local Button_pve_map_arrow_1 = ccui.Helper:seekWidgetByName(root,"Button_pve_map_arrow_1")
	local Button_pve_map_arrow_2 = ccui.Helper:seekWidgetByName(root,"Button_pve_map_arrow_2")
	LDuplicateWindow._pageViews = ccui.Helper:seekWidgetByName(root,"PageView_pve_map")
	LDuplicateWindow._pageViews:removeAllPages()
	LDuplicateWindow._pageViews:setCustomScrollThreshold(20)

	if __lua_project_id == __lua_project_l_digital then
		local Image_tip_1 = ccui.Helper:seekWidgetByName(root,"Image_tip_1")
		local Image_tip_2 = ccui.Helper:seekWidgetByName(root,"Image_tip_2")
		if Image_tip_1 ~= nil then
			Image_tip_1:setVisible(false)
		end
		if Image_tip_2 ~= nil then
			Image_tip_2:setVisible(false)
		end
	end

	if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
		local Button_pve_chapter_01 = ccui.Helper:seekWidgetByName(root,"Button_pve_chapter_01")
		local Button_pve_chapter_02 = ccui.Helper:seekWidgetByName(root,"Button_pve_chapter_02")
		local Button_pve_chapter_03 = ccui.Helper:seekWidgetByName(root,"Button_pve_chapter_03")
		local Button_pve_chapter_04 = ccui.Helper:seekWidgetByName(root,"Button_pve_chapter_04")
		local Button_pve_chapter_05 = ccui.Helper:seekWidgetByName(root,"Button_pve_chapter_05")
		local Button_pve_chapter_06 = ccui.Helper:seekWidgetByName(root,"Button_pve_chapter_06")
		local Button_pve_chapter_07 = ccui.Helper:seekWidgetByName(root,"Button_pve_chapter_07")
		Button_pve_chapter_01:setVisible(false)
		Button_pve_chapter_02:setVisible(false)
		Button_pve_chapter_03:setVisible(false)
		Button_pve_chapter_04:setVisible(false)
		Button_pve_chapter_05:setVisible(false)
		Button_pve_chapter_06:setVisible(false)
		Button_pve_chapter_07:setVisible(false)
	end

	local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
        	if LDuplicateWindow._pageViews:isVisible() == true then
	            local currentPageIndex = LDuplicateWindow._pageViews:getCurPageIndex()
	            if LDuplicateWindow.lastIndex == currentPageIndex then
	            	return
	            end
	            currentPageIndex = tonumber(LDuplicateWindow._pageViews:getCurPageIndex() + 1)
	            sender._one_called = true
	            state_machine.excute("lpve_main_scene_update_scene_name",0,LDuplicateWindow._pageViews:getPage(currentPageIndex-1).m_SceneId)
	   --          fwin:close(fwin:find("PVEStarCheatPanelClass"))
				if fwin:find("PVEStarCheatPanelClass") == nil then
					state_machine.excute("open_star_cheat_panel",0,{LDuplicateWindow._pageViews:getPage(currentPageIndex-1).m_SceneId})
				else
					state_machine.excute("pve_star_cheat_update_info",0,{LDuplicateWindow._pageViews:getPage(currentPageIndex-1).m_SceneId})
				end

				local sceneid =  self:getOpenScene()
				--箭头的显示
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					local max_sceneid = LDuplicateWindow._pageViews:getPage(currentPageIndex - 1).m_SceneId
					local max_open_scene = zstring.split(dms.string(dms["pve_scene"], max_sceneid, pve_scene.open_scene),",")[1]
					if #zstring.split(dms.string(dms["pve_scene"], max_sceneid, pve_scene.npcs),",") == zstring.tonumber(_ED.scene_current_state[tonumber(max_sceneid)]) 
						and dms.int(dms["pve_scene"], tonumber(max_open_scene), pve_scene.open_level) < 999 then
					-- if currentPageIndex - 1 < #LDuplicateWindow._pageViewsElite:getPages() - 1 then
					-- if sceneid > LDuplicateWindow._pageViewsElite:getPage(currentPageIndex-1).m_SceneId then
						Button_pve_map_arrow_2:setVisible(true)
					else
						Button_pve_map_arrow_2:setVisible(false)
					end
				else
					if currentPageIndex - 1 < #LDuplicateWindow._pageViews:getPages() - 1 then
					-- if sceneid > LDuplicateWindow._pageViews:getPage(currentPageIndex-1).m_SceneId then
						Button_pve_map_arrow_2:setVisible(true)
					else
						Button_pve_map_arrow_2:setVisible(false)
					end
				end

				if currentPageIndex > 1 then
				-- if LDuplicateWindow._pageViews:getPage(currentPageIndex-1).m_SceneId > 1 then
					Button_pve_map_arrow_1:setVisible(true)
				else
					Button_pve_map_arrow_1:setVisible(false)
				end

				if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
					ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_2"):setVisible(false)
					ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_1"):setVisible(false)
				end

				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
					then
					for k,v in pairs(LDuplicateWindow._pageViews:getPages()) do
						v:unLoad()
					end
					LDuplicateWindow._pageViews:getPage(currentPageIndex-1):onInit()
				else
					--如果是第三页的话就先添加一页，添加后再删除一页
					if currentPageIndex == 3 then
						local m_SceneId = LDuplicateWindow._pageViews:getPage(currentPageIndex-1).m_SceneId+1
						--添加一页,如果是最后一页就不做
						if sceneid <= m_SceneId-1 then
							return
						end
						local _LPVEMap = LPVEMap:createCell()
						_LPVEMap:init(m_SceneId,true)
						_LPVEMap.m_SceneId = m_SceneId
						LDuplicateWindow._pageViews:addPage(_LPVEMap)
						-- 删除第一页
						LDuplicateWindow._pageViews:removePage(LDuplicateWindow._pageViews:getPage(0))
						LDuplicateWindow._pageViews:scrollToPage(1)
					end
					--如果是第一页的话就插入一个在最前面,然后 再删除最后一项
					if currentPageIndex == 1 then
						local m_SceneId = LDuplicateWindow._pageViews:getPage(currentPageIndex-1).m_SceneId-1
						--如果到了第一个副本就不做
						if m_SceneId <= 0 then
							return
						end
						local _LPVEMap = LPVEMap:createCell()
						_LPVEMap:init(m_SceneId,true)
						_LPVEMap.m_SceneId = m_SceneId
						LDuplicateWindow._pageViews:insertPage(_LPVEMap,0) 

						--删除最后一页
						local index = LDuplicateWindow._pageViews:getPages()
						LDuplicateWindow._pageViews:removePage(LDuplicateWindow._pageViews:getPage(#index-1))
						LDuplicateWindow._pageViews:scrollToPage(1)
					end
				end
	            LDuplicateWindow.lastIndex = currentPageIndex - 1

				-- DSC通关宝箱领取提示
				if __lua_project_id == __lua_project_l_digital then
					self:showArrowRedDot(LDuplicateWindow._pageViews, LDuplicateWindow._adventureType.MAINLINE)
				end
			end
			-- self:onUpdateDrawPageView()
        end
    end 
	LDuplicateWindow._pageViews:addEventListener(pageViewEvent)
	LDuplicateWindow._pageViews.callback = pageViewEvent

	LDuplicateWindow._pageViewsElite = ccui.Helper:seekWidgetByName(root,"PageView_pve_map_jy") 
	LDuplicateWindow._pageViewsElite:removeAllPages()
	LDuplicateWindow._pageViewsElite:setCustomScrollThreshold(20)

	local function pageViewEventElite(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
        	if LDuplicateWindow._pageViewsElite:isVisible() == true then
	            local currentPageIndex = LDuplicateWindow._pageViewsElite:getCurPageIndex()
	            if LDuplicateWindow.lastIndexElite == currentPageIndex then
	            	return
	            end
	            currentPageIndex = tonumber(LDuplicateWindow._pageViewsElite:getCurPageIndex() + 1)
	            state_machine.excute("lpve_main_scene_update_scene_name",0,LDuplicateWindow._pageViewsElite:getPage(currentPageIndex-1).m_SceneId)
	   --          fwin:close(fwin:find("PVEStarCheatPanelClass"))
				if fwin:find("PVEStarCheatPanelClass") == nil then
					state_machine.excute("open_star_cheat_panel",0,{LDuplicateWindow._pageViewsElite:getPage(currentPageIndex-1).m_SceneId})
				else
					state_machine.excute("pve_star_cheat_update_info",0,{LDuplicateWindow._pageViewsElite:getPage(currentPageIndex-1).m_SceneId})
				end
				local sceneid =  self:getOpenScene()
				--箭头的显示
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					local max_sceneid = LDuplicateWindow._pageViewsElite:getPage(currentPageIndex - 1).m_SceneId
					local max_open_scene = zstring.split(dms.string(dms["pve_scene"], max_sceneid, pve_scene.open_scene),",")[1]
					if #zstring.split(dms.string(dms["pve_scene"], max_sceneid, pve_scene.npcs),",") == zstring.tonumber(_ED.scene_current_state[tonumber(max_sceneid)]) 
						and dms.int(dms["pve_scene"], tonumber(max_open_scene), pve_scene.open_level) < 999 then
					-- if currentPageIndex - 1 < #LDuplicateWindow._pageViewsElite:getPages() - 1 then
					-- if sceneid > LDuplicateWindow._pageViewsElite:getPage(currentPageIndex-1).m_SceneId then
						Button_pve_map_arrow_2:setVisible(true)
					else
						Button_pve_map_arrow_2:setVisible(false)
					end
				else
					if currentPageIndex - 1 < #LDuplicateWindow._pageViewsElite:getPages() - 1 then
					-- if sceneid > LDuplicateWindow._pageViewsElite:getPage(currentPageIndex-1).m_SceneId then
						Button_pve_map_arrow_2:setVisible(true)
					else
						Button_pve_map_arrow_2:setVisible(false)
					end
				end

				if currentPageIndex > 1 then
				-- if LDuplicateWindow._pageViewsElite:getPage(currentPageIndex-1).m_SceneId > 1 then
					Button_pve_map_arrow_1:setVisible(true)
				else
					Button_pve_map_arrow_1:setVisible(false)
				end

				if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
					ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_2"):setVisible(false)
					ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_1"):setVisible(false)
				end

				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
					then
					for k,v in pairs(LDuplicateWindow._pageViewsElite:getPages()) do
						v:unLoad()
					end
					LDuplicateWindow._pageViewsElite:getPage(currentPageIndex-1):onInit()
				else
					--如果是第三页的话就先添加一页，添加后再删除一页
					if currentPageIndex == 3 then
						local m_SceneId = LDuplicateWindow._pageViewsElite:getPage(currentPageIndex-1).m_SceneId+1
						--添加一页,如果是最后一页就不做
						if sceneid <= m_SceneId-1 then
							return
						end
						local _LPVEMap = LPVEMap:createCell()
						_LPVEMap:init(m_SceneId,true)
						_LPVEMap.m_SceneId = m_SceneId
						LDuplicateWindow._pageViewsElite:addPage(_LPVEMap)
						-- 删除第一页
						LDuplicateWindow._pageViewsElite:removePage(LDuplicateWindow._pageViewsElite:getPage(0))
						LDuplicateWindow._pageViewsElite:scrollToPage(1)
					end
					--如果是第一页的话就插入一个在最前面,然后 再删除最后一项
					if currentPageIndex == 1 then
						local m_SceneId = LDuplicateWindow._pageViewsElite:getPage(currentPageIndex-1).m_SceneId-1
						--如果到了第一个副本就不做
						if m_SceneId <= 101 then
							return
						end
						local _LPVEMap = LPVEMap:createCell()
						_LPVEMap:init(m_SceneId,true)
						_LPVEMap.m_SceneId = m_SceneId
						LDuplicateWindow._pageViewsElite:insertPage(_LPVEMap,0) 

						--删除最后一页
						local index = LDuplicateWindow._pageViewsElite:getPages()
						LDuplicateWindow._pageViewsElite:removePage(LDuplicateWindow._pageViewsElite:getPage(#index-1))
						LDuplicateWindow._pageViewsElite:scrollToPage(1)
					end
				end
				-- DSC通关宝箱领取提示
				if __lua_project_id == __lua_project_l_digital then
					self:showArrowRedDot(LDuplicateWindow._pageViewsElite, LDuplicateWindow._adventureType.ELITE)
				end
				LDuplicateWindow.lastIndexElite = currentPageIndex - 1
			end
        end
    end 
	LDuplicateWindow._pageViewsElite:addEventListener(pageViewEventElite)
	LDuplicateWindow._pageViewsElite.callback = pageViewEventElite


	LDuplicateWindow._pageViewsEm = ccui.Helper:seekWidgetByName(root,"PageView_pve_map_em") 
	LDuplicateWindow._pageViewsEm:removeAllPages()
	LDuplicateWindow._pageViewsEm:setCustomScrollThreshold(20)

	local function pageViewEventEm(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
        	if LDuplicateWindow._pageViewsEm:isVisible() == true then
	            local currentPageIndex = LDuplicateWindow._pageViewsEm:getCurPageIndex()
	            if LDuplicateWindow.lastIndexEm== currentPageIndex then
	            	return
	            end
	            currentPageIndex = tonumber(LDuplicateWindow._pageViewsEm:getCurPageIndex() + 1)
	            state_machine.excute("lpve_main_scene_update_scene_name",0,LDuplicateWindow._pageViewsEm:getPage(currentPageIndex-1).m_SceneId)
	   --          fwin:close(fwin:find("PVEStarCheatPanelClass"))
				if fwin:find("PVEStarCheatPanelClass") == nil then
					state_machine.excute("open_star_cheat_panel",0,{LDuplicateWindow._pageViewsEm:getPage(currentPageIndex-1).m_SceneId})
				else
					state_machine.excute("pve_star_cheat_update_info",0,{LDuplicateWindow._pageViewsEm:getPage(currentPageIndex-1).m_SceneId})
				end
				local sceneid =  self:getOpenScene()
				--箭头的显示
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					local max_sceneid = LDuplicateWindow._pageViewsEm:getPage(currentPageIndex - 1).m_SceneId
					local max_open_scene = zstring.split(dms.string(dms["pve_scene"], max_sceneid, pve_scene.open_scene),",")[1]
					if #zstring.split(dms.string(dms["pve_scene"], max_sceneid, pve_scene.npcs),",") == zstring.tonumber(_ED.scene_current_state[tonumber(max_sceneid)]) 
						and dms.int(dms["pve_scene"], tonumber(max_open_scene), pve_scene.open_level) < 999 then
					-- if currentPageIndex - 1 < #LDuplicateWindow._pageViewsElite:getPages() - 1 then
					-- if sceneid > LDuplicateWindow._pageViewsElite:getPage(currentPageIndex-1).m_SceneId then
						Button_pve_map_arrow_2:setVisible(true)
					else
						Button_pve_map_arrow_2:setVisible(false)
					end
				else
					if currentPageIndex - 1 < #LDuplicateWindow._pageViewsEm:getPages() - 1 then
					-- if sceneid > LDuplicateWindow._pageViewsElite:getPage(currentPageIndex-1).m_SceneId then
						Button_pve_map_arrow_2:setVisible(true)
					else
						Button_pve_map_arrow_2:setVisible(false)
					end
				end

				if currentPageIndex > 1 then
				-- if LDuplicateWindow._pageViewsElite:getPage(currentPageIndex-1).m_SceneId > 1 then
					Button_pve_map_arrow_1:setVisible(true)
				else
					Button_pve_map_arrow_1:setVisible(false)
				end

				if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
					ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_2"):setVisible(false)
					ccui.Helper:seekWidgetByName(self.roots[1],"Button_pve_map_arrow_1"):setVisible(false)
				end

				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
					then
					for k,v in pairs(LDuplicateWindow._pageViewsEm:getPages()) do
						v:unLoad()
					end
					LDuplicateWindow._pageViewsEm:getPage(currentPageIndex-1):onInit()
				else
					--如果是第三页的话就先添加一页，添加后再删除一页
					if currentPageIndex == 3 then
						local m_SceneId = LDuplicateWindow._pageViewsEm:getPage(currentPageIndex-1).m_SceneId+1
						--添加一页,如果是最后一页就不做
						if sceneid <= m_SceneId-1 then
							return
						end
						local _LPVEMap = LPVEMap:createCell()
						_LPVEMap:init(m_SceneId,true)
						_LPVEMap.m_SceneId = m_SceneId
						LDuplicateWindow._pageViewsEm:addPage(_LPVEMap)
						-- 删除第一页
						LDuplicateWindow._pageViewsEm:removePage(LDuplicateWindow._pageViewsEm:getPage(0))
						LDuplicateWindow._pageViewsEm:scrollToPage(1)
					end
					--如果是第一页的话就插入一个在最前面,然后 再删除最后一项
					if currentPageIndex == 1 then
						local m_SceneId = LDuplicateWindow._pageViewsEm:getPage(currentPageIndex-1).m_SceneId-1
						--如果到了第一个副本就不做
						if m_SceneId <= 101 then
							return
						end
						local _LPVEMap = LPVEMap:createCell()
						_LPVEMap:init(m_SceneId,true)
						_LPVEMap.m_SceneId = m_SceneId
						LDuplicateWindow._pageViewsEm:insertPage(_LPVEMap,0) 

						--删除最后一页
						local index = LDuplicateWindow._pageViewsEm:getPages()
						LDuplicateWindow._pageViewsEm:removePage(LDuplicateWindow._pageViewsEm:getPage(#index-1))
						LDuplicateWindow._pageViewsEm:scrollToPage(1)
					end
				end
				-- DSC通关宝箱领取提示
				if __lua_project_id == __lua_project_l_digital then
					self:showArrowRedDot(LDuplicateWindow._pageViewsEm, LDuplicateWindow._adventureType.NIGHTMARE)
				end
				LDuplicateWindow.lastIndexEm = currentPageIndex - 1
			end
        end
    end 
	LDuplicateWindow._pageViewsEm:addEventListener(pageViewEventEm)
	LDuplicateWindow._pageViewsEm.callback = pageViewEventEm

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_map_arrow_1"), nil, 
	{
		terminal_name = "lduplicate_window_switch_to",
		dir = 0,
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_map_arrow_2"), nil, 
	{
		terminal_name = "lduplicate_window_switch_to",
		dir = 1,
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, nil, 0)

-----------------------------------------
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_daily_duplicate",
	_widget = ccui.Helper:seekWidgetByName(root, "Button_pve_3"),
	_invoke = nil,
	_interval = 0.5,})		
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_hero_duplicate",
	_widget = ccui.Helper:seekWidgetByName(root, "Button_pve_1"),
	_invoke = nil,
	_interval = 0.5,})		
	-- -- 普通
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_2"), nil, 
	-- {
		-- terminal_name = "lduplicate_window_switch", 	
		-- next_terminal_name = "plot_copy",
		-- current_button_name = "Button_pve_2",
		-- group_name = self._enumUiGroup._PVE_DIFFICULTY,
		-- terminal_state = 0, 
		-- isPressedActionEnabled = true}, 
	-- nil, 0)
	
	-- 日常
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_3"), nil, 
	{
		terminal_name = "lduplicate_window_switch", 	
		next_terminal_name = "daily_copy",
		current_button_name = "Button_pve_3",
		group_name = self._enumUiGroup._PVE_TYPE,
		terminal_state = 0, 
		isPressedActionEnabled = false}, 
	nil, 0)
	
	---------------------------------------------------------------------------
	-- _PVE_DIFFICULTY
	---------------------------------------------------------------------------
	-- 主线
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_2"), nil, 
	{
		terminal_name = "lduplicate_window_switch", 	
		next_terminal_name = "plot_change_to_common",
		current_button_name = "Button_pve_2",
		group_name = self._enumUiGroup._PVE_DIFFICULTY,
		terminal_state = 0, 
		isPressedActionEnabled = false}, 
	nil, 0)
	
	self.pveMenuPanel = ccui.Helper:seekWidgetByName(root, "Panel_xz_pve")
	-- 精英
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jingyingbt"), nil, 
	{
		terminal_name = "lduplicate_window_switch", 	
		next_terminal_name = "plot_change_to_abyss",
		current_button_name = "Button_jingyingbt",
		group_name = self._enumUiGroup._PVE_DIFFICULTY,
		terminal_state = 0, 
		isPressedActionEnabled = false}, 
	nil, 0)

	local Button_1 = ccui.Helper:seekWidgetByName(root, "Button_1")
	if Button_1 ~= nil then
		self.Button_1 = Button_1
		fwin:addTouchEventListener(Button_1, nil, 
		{
			terminal_name = "lduplicate_window_goto_formation",
			dir = 1,
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, nil, 0)

		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_hero_develop_duplicate_formation",
        _widget = Button_1,
        _invoke = nil,
        _interval = 0.5,})
	end

	local Button_2 = ccui.Helper:seekWidgetByName(root, "Button_change_line")
	if Button_2 ~= nil then
		self.Button_2 = Button_2
		fwin:addTouchEventListener(Button_2, nil, 
		{
			terminal_name = "lduplicate_window_show_panel",
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, nil, 0)

		-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_hero_develop_duplicate_formation",
  --       _widget = Button_1,
  --       _invoke = nil,
  --       _interval = 0.5,})
	end

	local Button_em_line = ccui.Helper:seekWidgetByName(root, "Button_em_line")
	if Button_em_line ~= nil then
		fwin:addTouchEventListener(Button_em_line, nil, 
		{
			terminal_name = "em_one_key_formation_window",
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, nil, 0)
	end

	local Button_em_line_change = ccui.Helper:seekWidgetByName(root, "Button_em_line_change")
	if Button_em_line ~= nil then
		fwin:addTouchEventListener(Button_em_line_change, nil, 
		{
			terminal_name = "em_team_window_formation_change",
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, nil, 0)
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		if LDuplicateWindow._infoDatas._type == self._enumPveType._COMMON then
			ccui.Helper:seekWidgetByName(root, "Button_1031"):setHighlighted(true)
			ccui.Helper:seekWidgetByName(root, "Button_1031"):setTouchEnabled(false)
			ccui.Helper:seekWidgetByName(root, "Button_1030"):setHighlighted(false)
			ccui.Helper:seekWidgetByName(root, "Button_1030"):setTouchEnabled(true)
			ccui.Helper:seekWidgetByName(root, "Button_em"):setHighlighted(false)
			ccui.Helper:seekWidgetByName(root, "Button_em"):setTouchEnabled(true)

			self:showWorldGradeTip(1)

		elseif LDuplicateWindow._infoDatas._type == self._enumPveType._ABYSS then
			ccui.Helper:seekWidgetByName(root, "Button_1031"):setHighlighted(false)
			ccui.Helper:seekWidgetByName(root, "Button_1031"):setTouchEnabled(true)
			ccui.Helper:seekWidgetByName(root, "Button_1030"):setHighlighted(true)
			ccui.Helper:seekWidgetByName(root, "Button_1030"):setTouchEnabled(false)
			ccui.Helper:seekWidgetByName(root, "Button_em"):setHighlighted(false)
			ccui.Helper:seekWidgetByName(root, "Button_em"):setTouchEnabled(true)

			self:showWorldGradeTip(2)

		elseif LDuplicateWindow._infoDatas._type == self._enumPveType._EM then
			ccui.Helper:seekWidgetByName(root, "Button_1031"):setHighlighted(false)
			ccui.Helper:seekWidgetByName(root, "Button_1031"):setTouchEnabled(true)
			ccui.Helper:seekWidgetByName(root, "Button_1030"):setHighlighted(false)
			ccui.Helper:seekWidgetByName(root, "Button_1030"):setTouchEnabled(true)
			ccui.Helper:seekWidgetByName(root, "Button_em"):setHighlighted(true)
			ccui.Helper:seekWidgetByName(root, "Button_em"):setTouchEnabled(false)

			self:showWorldGradeTip(15)
		end
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1030"),          nil, 
		{
			terminal_name = "plot_change_to_abyss_menu",
			button_type = 2,
			terminal_state = 0, 
			isPressedActionEnabled = true,
		}, nil, 0)

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1031"),          nil, 
		{
			terminal_name = "plot_change_to_abyss_menu",     
			button_type = 1,
			terminal_state = 0, 
			isPressedActionEnabled = true,
		}, nil, 0)

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_em"),          nil, 
		{
			terminal_name = "plot_change_to_abyss_menu",     
			button_type = 15,
			terminal_state = 0, 
			isPressedActionEnabled = true,
		}, nil, 0)
	else
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1030"),          nil, 
		{
			terminal_name = "plot_change_to_abyss_menu",     
			button_type = 1,
			terminal_state = 0, 
			isPressedActionEnabled = true,
		}, nil, 0)

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1031"),          nil, 
		{
			terminal_name = "plot_change_to_abyss_menu",     
			button_type = 2,
			terminal_state = 0, 
			isPressedActionEnabled = true,
		}, nil, 0)
	end
	
	---------------------------------------------------------------------------
	
	
	if LDuplicateWindow._infoDatas._type == self._enumPveType._COMMON then
		state_machine.excute("lduplicate_window_switch", 0, 
			{
				_datas = {
					terminal_name = "lduplicate_window_switch", 	
					next_terminal_name = "plot_change_to_common", 	
					current_button_name = "Button_pve_2",  
					group_name = self._enumUiGroup._PVE_DIFFICULTY,				
					terminal_state = 0, 
					isPressedActionEnabled = false
				}
			}
		)
	elseif LDuplicateWindow._infoDatas._type == self._enumPveType._ABYSS then
		state_machine.excute("lduplicate_window_switch", 0, 
			{
				_datas = {
					terminal_name = "lduplicate_window_switch", 
					next_terminal_name = "plot_change_to_abyss",
					current_button_name = "Button_jingyingbt",
					group_name = self._enumUiGroup._PVE_DIFFICULTY,				
					terminal_state = 0, 
					isPressedActionEnabled = false
				}
			}
		)
	elseif LDuplicateWindow._infoDatas._type == self._enumPveType._ACTIVITY then
		state_machine.excute("lduplicate_window_switch", 0, 
			{
				_datas = {
					terminal_name = "lduplicate_window_switch", 	
					next_terminal_name = "daily_copy",
					current_button_name = "Button_pve_3",
					group_name = self._enumUiGroup._PVE_TYPE,
					terminal_state = 0, 
					isPressedActionEnabled = false
				}
			}
		)
	elseif LDuplicateWindow._infoDatas._type == self._enumPveType._ELITE then
		state_machine.excute("lduplicate_window_switch", 0, 
			{
				_datas = {
					terminal_name = "lduplicate_window_switch", 	
					next_terminal_name = "general_copy", 	
					current_button_name = "Button_pve_1", 
					group_name = self._enumUiGroup._PVE_TYPE,
					terminal_state = 0, 
					isPressedActionEnabled = false
				}
			}
		)
	elseif LDuplicateWindow._infoDatas._type == self._enumPveType._EM then
		state_machine.excute("lduplicate_window_switch", 0, 
			{
				_datas = {
					terminal_name = "lduplicate_window_switch", 	
					next_terminal_name = "plot_change_to_em", 	
					current_button_name = "Button_pve_1", 
					group_name = self._enumUiGroup._PVE_TYPE,
					terminal_state = 0, 
					isPressedActionEnabled = false
				}
			}
		)
	else
		state_machine.excute("lduplicate_window_switch", 0, 
			{
				_datas = {
					terminal_name = "lduplicate_window_switch", 	
					next_terminal_name = "plot_change_to_common", 	
					current_button_name = "Button_pve_2",  
					group_name = self._enumUiGroup._PVE_DIFFICULTY,				
					terminal_state = 0, 
					isPressedActionEnabled = false
				}
			}
		)
	end

	self.Button_1:setVisible(LDuplicateWindow._infoDatas._type ~= 15)
	self.Button_2:setVisible(LDuplicateWindow._infoDatas._type == 15)

	-- 评审状态
	if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
		Button_pve_map_arrow_1:setVisible(false)
		Button_pve_map_arrow_2:setVisible(false)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_chapter_01"),          nil, 
		{
			terminal_name = "Button_pve_chapter", 
			page = 1,    
			terminal_state = 0, 
			isPressedActionEnabled = true,
		}, nil, 0)

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_chapter_02"),          nil, 
		{
			terminal_name = "Button_pve_chapter", 
			page = 2,    
			terminal_state = 0, 
			isPressedActionEnabled = true,
		}, nil, 0)

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_chapter_03"),          nil, 
		{
			terminal_name = "Button_pve_chapter",
			page = 3,     
			terminal_state = 0, 
			isPressedActionEnabled = true,
		}, nil, 0)

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_chapter_04"),          nil, 
		{
			terminal_name = "Button_pve_chapter",
			page = 4,     
			terminal_state = 0, 
			isPressedActionEnabled = true,
		}, nil, 0)

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_chapter_05"),          nil, 
		{
			terminal_name = "Button_pve_chapter",
			page = 5,     
			terminal_state = 0, 
			isPressedActionEnabled = true,
		}, nil, 0)

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_chapter_06"),          nil, 
		{
			terminal_name = "Button_pve_chapter",
			page = 6,     
			terminal_state = 0, 
			isPressedActionEnabled = true,
		}, nil, 0)

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_chapter_07"),          nil, 
		{
			terminal_name = "Button_pve_chapter",
			page = 7,     
			terminal_state = 0, 
			isPressedActionEnabled = true,
		}, nil, 0)

		ccui.Helper:seekWidgetByName(root, "Button_pve_chapter_01"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Button_pve_chapter_02"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Button_pve_chapter_03"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Button_pve_chapter_04"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Button_pve_chapter_05"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Button_pve_chapter_06"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Button_pve_chapter_07"):setVisible(true)
	end

	--获取噩梦副本阵容信息
	local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
            	response.node:updateHeroIcons()
            end
        end
    end

	if _ED.em_user_ship and table.nums(_ED.em_user_ship) ~= 0 then
		self:updateHeroIcons()
	else
    	NetworkManager:register(protocol_command.get_hard_copy_user_formation.code, nil, nil, nil, self, responseCallback, false, nil)
	end

	-- 超级扫荡按钮事件绑定
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_super_mopping"),
        nil,
        {
            terminal_name = "super_mopping_button_touch",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    self:showSuperMoppingButton(LDuplicateWindow._infoDatas._type)
end

-- 控制超级扫荡按钮的显示和隐藏
function LDuplicateWindow:showSuperMoppingButton(index)
	local root = self.roots[1]
	local Button_super_mopping = ccui.Helper:seekWidgetByName(root, "Button_super_mopping")
	if Button_super_mopping ~= nil then
		Button_super_mopping:setVisible(false)
		if index == 1 then
			Button_super_mopping:setVisible(true)
		elseif index == 2 then
			Button_super_mopping:setVisible(true)
		elseif index == 15 then
			Button_super_mopping:setVisible(false)
		end
		-- DB2重塑,扫荡显示处理
		if __lua_project_id == __lua_project_l_dragonball2 then
			local user_level = _ED.user_info.user_grade
			local target_level = tipStringInfo_mopping_word[3]
			if tonumber(user_level) < tonumber(target_level) then 
				Button_super_mopping:setVisible(false)
			end
		end
	end
end

function LDuplicateWindow:getPageIndex()
    if LDuplicateWindow._infoDatas._type == 1 then
        return 0
    elseif LDuplicateWindow._infoDatas._type == 2 then
        return 1
    elseif LDuplicateWindow._infoDatas._type == 15 then
        return 15
    end
end

function LDuplicateWindow:updateHeroIcons()
	local root = self.roots[1]
	local ListView_em_line = ccui.Helper:seekWidgetByName(root, "ListView_em_line")
    ListView_em_line:removeAllItems()
	for i= 1, 6 do
		if _ED.em_user_ship then
	        local cell = HeroIconListCell:createCell()
	        local ship = _ED.user_ship["".._ED.em_user_ship[i]]        
	        if nil ~= ship then
	            cell:init(ship, i, true, nil,nil,true)
	            local Image_line_role = ccui.Helper:seekWidgetByName(cell.roots[1], "Image_line_role")
	            if nil ~= Image_line_role then
		            Image_line_role:setVisible(false)
		        end
	        else
	        	cell:init(nil,i, true, nil,nil,true)
	        end
	        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop"), nil, 
	            {
	                terminal_name = "battle_ready_window_open_join_formation_window",
	                cell_index = i,
	                isPressedActionEnabled = true
	            },
	            nil,0)

	        ListView_em_line:addChild(cell)
	    end
	end
end

function LDuplicateWindow:joinFormtion( params )
	state_machine.excute("hero_formation_choice_wear_window_close", 0, 0)
	local cell_index = params[1]
    local ship_id = params[2]

    local ship = _ED.user_ship["" .. ship_id]
    local old_em_user_ship = {}
    table.add(old_em_user_ship, _ED.em_user_ship)
    _ED.em_user_ship[cell_index] = ship_id

    local result = false
    for i,v in ipairs(_ED.em_user_ship) do
    	if old_em_user_ship[i] ~= v then
    		result = true
    		break
    	end
    end
    if result then
    	state_machine.excute("em_formation_save", 0, "")
    end
end

function LDuplicateWindow:oneKeyFormationChange( ... )
	local function fightingCapacity(a,b)
        local al = tonumber(a.hero_fight)
        local bl = tonumber(b.hero_fight)
        local result = false
        if al > bl then
            result = true
        end
        return result 
    end
    local fightShipList = {}
 	for i, ship in pairs(_ED.user_ship) do
        if ship.ship_id ~= nil then
           	table.insert(fightShipList, ship)
        end
    end
    table.sort(fightShipList, fightingCapacity)
    local old_em_user_ship = {}
    table.add(old_em_user_ship, _ED.em_user_ship)
    for i=1,6 do
    	local ship = fightShipList[i]
    	_ED.em_user_ship[i] = ship.ship_id
    end
    local result = false
    for i,v in ipairs(_ED.em_user_ship) do
    	if old_em_user_ship[i] ~= v then
    		result = true
    		break
    	end
    end
    if result then
    	state_machine.excute("em_formation_save", 0, "")
    end
end

function LDuplicateWindow:close( ... )
    -- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then  
    --     state_machine.excute("warship_girl_push_info_close",0,"")
    -- end
end

function LDuplicateWindow:onExit()
	state_machine.remove("lduplicate_window_switch")
	state_machine.remove("lduplicate_window_return")
	state_machine.remove("lduplicate_window_visible")
	state_machine.remove("general_copy")
	state_machine.remove("plot_copy")
	state_machine.remove("daily_copy")
	state_machine.remove("plot_change_to_common")
	state_machine.remove("plot_change_to_abyss")
	state_machine.remove("general_copy_show_attack_times")
	state_machine.remove("daily_copy_show_attack_times")
	state_machine.remove("daily_copy_show_add_roots")
	state_machine.remove("lduplicate_window_switch_to")
	state_machine.remove('lduplicate_window_goto_formation')
	state_machine.remove("lduplicate_window_show_one_click")
	state_machine.remove("lduplicate_window_get_one_click_reward")
	
end

function LDuplicateWindow:destroy( window )
    if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
    audioUtilUncacheAll()
    cacher.cleanSystemCacher()

    state_machine.excute("home_open_secret_shop", 0, true)
end
