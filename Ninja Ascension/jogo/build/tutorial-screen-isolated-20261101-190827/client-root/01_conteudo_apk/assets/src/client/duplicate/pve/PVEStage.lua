-- ----------------------------------------------------------------------------------------------------
-- -- 说明：出击界面
-- -- 创建时间：2015-03-21
-- -- 作者：刘迎
-- -- 修改记录：
-- --		1 刘迎 		界面呈现 功能实现
-- --		2 胡文轩		扫荡功能实现
-- --		3 刘迎		按照效果图调整细节
-- -- 最后修改人：刘迎
-- -------------------------------------------------------------------------------------------------------

PVEStage = class("PVEStageClass", Window)

function PVEStage:ctor()
	self.super:ctor()

	self.oneTimes = false

	self.types = nil
	
	self.oldCurrentPageType = nil
	self.currentPageType = nil
	
	app.load("client.cells.duplicate.duplicate_select_seat_chapters_cell")
	app.load("client.cells.duplicate.duplicate_select_seat_cell")
	app.load("client.duplicate.pve.PVEIntroduction") 
	app.load("client.cells.duplicate.pageview_seat_role_cell")
	--app.load("client.cells.duplicate.pve_stage_bottom_cell")
	app.load("client.duplicate.pve.PVESecondaryScene")
	
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	
	self.cacheListView = nil			--缓存ListView
	-- self.cacheListViewPostionY = nil		--缓存ListView 位置信息

	self.enterFrameStatus = false		--控制帧循环是否开始
	self.enterFrameForCancel = false	--控制甩动循环是否开始
	
	self.currentNpcID = 1				--当前选择的NPC
	self.currentSceneType = 0			--当前关卡类型
	
	-- 实现实现pve场景的绘制
	self.pveSceneID = 0					--当前关卡ID
	self.selectSeatIndex = -1			--当前选择关卡的index
	
	self.cacheNpcArmature = nil			--缓存npc动画
	self.cacheBgImagePanel = nil		--缓存背景图层
	
	self.moveQuene = {}					--移动队列
	
	self.isMouseHoldStatus = false		--是否是鼠标控制状态

	self.chapterListView = nil
	
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = nil

	-- 初始化武将小像事件响应需要使用的状态机
	local function init_page_stage_terminal()
		
		-- 强制关闭
		local page_stage_general_close_terminal = {
			_name = "page_stage_general_close",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				fwin:close(instance)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 更新场景数据
		local page_stage_update_information_terminal = {
			_name = "page_stage_update_information",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance.pveSceneID = tonumber(params.sceneID)
				instance.selectSeatIndex = params.npcIndex
				instance.oldCurrentPageType = instance.currentPageType
				instance.currentPageType = params.currentPageType
							instance.moveQuene = {}
				instance.enterFrameStatus = false
				
				if true == params.isGotoNPC then
					state_machine.excute("pve_stage_goto_target_scene", 0, nil)
					
				else
					instance:onInitInfo()
				end					
				

				instance:startSceneEvent(instance.pveSceneID)
				
				-- local cell = self.cacheListView:getItems()
				-- for i,v in pairs(cell) do
					-- if instance.types == 1 then
						-- v:onShow()
					-- elseif instance.types == 2 then
						-- v:onHide()
					-- end
				-- end
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 当NPC选项卡被选择的时候触发事件
		local page_view_seat_click_terminal = {
			_name = "page_view_seat_click",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- --> print("page_view_seat_click")
				-- local seat = params.click
				
				-- if seat.npcState < 2 then
					-- instance.currentNpcID = seat.npcID
					-- local index = self:getListViewIndexForItems(seat)
					-- instance.enterFrameStatus = true
					-- instance.isMouseHoldStatus = false
					-- instance:scrollToPosForIndex(index - 1)
					-- instance.selectSeatIndex = index
					-- state_machine.excute("duplicate_update_selected_data", 0, { sceneID = instance.pveSceneID, npcIndex = instance.selectSeatIndex })
					
				-- else
					-- instance:playAction("close")
					-- instance:playNpcAnimation(0)
					-- state_machine.excute("pve_bottom_play_action", 0, "close")
				-- end
				-- --控制蒙古包的出现
				
				-- -- if tonumber(instance.pveSceneID) >= 201 then
					-- -- local id = instance.pveSceneID
					-- -- if instance.selectSeatIndex == 1 and tonumber(instance.pveSceneID) ~= 201 then
						-- -- id = id - 1
					-- -- elseif instance.selectSeatIndex == 6 then
						-- -- id = id + 1
					-- -- end
					-- -- local open_scene = dms.string(dms["pve_scene"], id, pve_scene.open_scene)
					-- -- local npcs = dms.string(dms["pve_scene"], id, pve_scene.npcs)
					-- -- local step = zstring.split(npcs,",")
					-- -- if tonumber(_ED.scene_current_state[id]) == table.getn(step) and 
						-- -- tonumber(_ED.scene_max_state[id]) == table.getn(step) and
						-- -- tonumber(_ED.scene_current_state[id]) == tonumber(_ED.scene_max_state[id]) then
						-- -- local item = zstring.split(open_scene, ",")
						-- -- if item[2] ~= nil then
							-- -- local types = dms.int(dms["pve_scene"], item[2], pve_scene.scene_type)
							-- -- if types == 10 then
								-- -- self.specialId = item[2]
								-- -- ccui.Helper:seekWidgetByName(instance.roots[1], "Button_31"):setVisible(true)
								-- -- ccui.Helper:seekWidgetByName(instance.roots[1], "Text_6"):setString(dms.string(dms["pve_scene"], item[2], pve_scene.scene_name))
							-- -- else
								-- -- ccui.Helper:seekWidgetByName(instance.roots[1], "Button_31"):setVisible(false)
								-- -- ccui.Helper:seekWidgetByName(instance.roots[1], "Text_6"):setString(" ")
							-- -- end
						-- -- else
							-- -- ccui.Helper:seekWidgetByName(instance.roots[1], "Button_31"):setVisible(false)
							-- -- ccui.Helper:seekWidgetByName(instance.roots[1], "Text_6"):setString(" ")
						-- -- end
					-- -- else
						-- -- ccui.Helper:seekWidgetByName(instance.roots[1], "Button_31"):setVisible(false)
						-- -- ccui.Helper:seekWidgetByName(instance.roots[1], "Text_6"):setString(" ")
					-- -- end
				
				-- -- end
				
				
				return true
				
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 控制框框的动画
		local page_stage_play_action_terminal = {
			_name = "page_stage_play_action",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- instance:playAction(params)
				-- instance:playNpcAnimation(2)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 处理副本自动选择bug
		local page_stage_fight_data_deal_terminal = {
			_name = "page_stage_fight_data_deal",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- _ED._current_seat_index = instance.selectSeatIndex
				-- if instance.pveSceneID > 1 and _ED._current_seat_index > -1 then
					-- _ED._current_seat_index = _ED._current_seat_index - 1
				-- end
				
				-- -- print("\n\n\n处理副本自动选择bug", _ED._current_seat_index)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 打开布阵
		local page_view_open_formation_terminal = {
			_name = "page_view_open_formation",
			_init = function (terminal)
				app.load("client.formation.FormationChange") 
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- local formationChangeWindow = FormationChange:new()
				-- fwin:open(formationChangeWindow, fwin._windows)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- scrolling enterframe for scale
		local page_view_scrolling_terminal = {
			_name = "page_view_scrolling",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- self.enterFrameStatus = true
				-- self.enterFrameForCancel = false
				-- self.isMouseHoldStatus = true
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- scrolling enterframe for cancel
		local page_view_scrolling_for_cancel_terminal = {
			_name = "page_view_scrolling_for_cancel_terminal",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- self.enterFrameForCancel = true
				-- self.isMouseHoldStatus = false
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 清空所有关卡名称
		local page_view_clean_all_seat_name_terminal = {
			_name = "page_view_clean_all_seat_name",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- self.isMouseHoldStatus = true
				-- --清空名字
				-- for i, v in pairs(self.cacheListView:getItems()) do
					-- v:resetName(true)
				-- end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		local pve_stage_show_notice_dialog_terminal = {
			_name = "pve_stage_show_notice_dialog", 
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- self.cacheAction:play("Button_8_2_touch", false)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		local pve_stage_goto_target_scene_terminal = {
			_name = "pve_stage_goto_target_scene",
			_init = function (terminal)
				-- app.load("client.duplicate.pve.PVESpecialPass")
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:gotoTargetScene()
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		
		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(pve_stage_goto_target_scene_terminal)
		state_machine.add(page_view_seat_click_terminal)
		state_machine.add(page_view_scrolling_terminal)
		state_machine.add(page_view_open_formation_terminal)
		state_machine.add(page_stage_update_information_terminal)
		state_machine.add(page_stage_play_action_terminal)
		state_machine.add(page_stage_general_close_terminal)
		state_machine.add(page_view_clean_all_seat_name_terminal)
		state_machine.add(page_view_scrolling_for_cancel_terminal)
		state_machine.add(pve_stage_show_notice_dialog_terminal)
		state_machine.add(page_stage_fight_data_deal_terminal)
		state_machine.init()
	end
	init_page_stage_terminal()
end

function PVEStage:startSceneEvent(pveSceneID)
	-- if executeMissionExt(mission_mould_tuition, touch_off_mission_ls_scene, "".._ED.user_info.user_grade, nil, true, "0", false) == false then
		
		--if fwin:find("PVESecondarySceneInfoClass") == nil then
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
	--end
	if missionIsOver() == false then
		local windowLock = fwin:find("WindowLockClass")
		if windowLock == nil then
			fwin:open(WindowLock:new():init(), fwin._windows)
		end
	end
end

--绘制背景图
function PVEStage:drawBgIamgePanel()
	local index =  dms.int(dms["pve_scene"], self.pveSceneID, pve_scene.scene_entry_pic)
	local bgImage = string.format("map/plot/plot_bg_%s.jpg",index)
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
		then 
		if self.types == 3 then 
			bgImage = "map/plot/jingyingfuben.jpg"
		else
			bgImage = "map/plot/plot_bg_1.jpg"
		end
		
	end
	self.cacheBgImagePanel:setBackGroundImage(bgImage)
end

function PVEStage:updateBriefIntroduction()
	self.pveIntroduction:onUpdateInfo(self.pveSceneID)
end


function PVEStage:drawNpcPanel()
	local root = self.roots[1]
	-- 关卡列表
	local clist = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,200,201,202,203,204}
	--local n = 15 -- 总共15种形式
	
	local npcIcon = nil
	local npcIconBtn = nil
	
	local index = dms.int(dms["pve_scene"], self.pveSceneID, pve_scene.scene_map_id)
	
	for i = 1 , table.getn(clist) do
		local n = clist[i]
		npcIcon = ccui.Helper:seekWidgetByName(root, string.format("Panel_zj_%d" ,n))
		if nil == npcIcon then
			break
		end

		if n == index then
			npcIcon:setVisible(true)
			npcIconBtn = ccui.Helper:seekWidgetByName(root, string.format("Button_%d" ,n))
		else
			npcIcon:setVisible(false)
		end
	end
	
	if nil~= npcIconBtn then
		fwin:addTouchEventListener(npcIconBtn, nil, 
		{
			terminal_name = "pve_stage_goto_target_scene", 
			next_terminal_name = "", 
			but_image = "", 
			terminal_state = 0, 
			isPressedActionEnabled = false,
			sceneID = self.pveSceneID,
			currentPageType = self.currentPageType
		},
		nil, 0)
	end
end

function PVEStage:gotoTargetScene()
	-- 开启 二级界面
	
	local sceneIndex = self.sceneIndex
	
	local list = self.chapterListView:getItems()
	local n = table.getn(list)
	for i,v in ipairs(list) do
		if v:getSceneID()  == self.pveSceneID then
			-- sceneIndex 要倒过来
			sceneIndex = (i - n - 1) * -1
			break
		end
	end
	
	local scene = PVESecondaryScene:new()
	scene:init(self.pveSceneID, self.currentPageType, sceneIndex)
	fwin:open(scene, fwin._view)
end

function PVEStage:initAction()
	
end

function PVEStage:onEnterTransitionFinish()
	-- if self.fresh == true then
		-- self.fresh = false
	-- else
		state_machine.unlock("menu_manager_change_to_page", 0, "")
	-- end
end

function PVEStage:gotoIndexChapters(index, isClick)
	self.chapterListView:jumpToBottom()
	local items = self.chapterListView:getItems()
	local item = items[index]
	if nil == item then
		
		return
	
	end

	local maxPageCount = 4
	if __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		then
		maxPageCount = 2
	end
	
	if table.getn(items) - index <= maxPageCount then
	
		self.chapterListView:jumpToBottom()
		
	elseif index <= maxPageCount then
		self.chapterListView:jumpToTop()
	else
		
		local clv = self.chapterListView
		local clvHeight = clv:getContentSize().height
		local clvInnerContainer = clv:getInnerContainer()
		local clvInnerContainerHeight = clvInnerContainer:getContentSize().height
		
		
		local itemHeight = item:getContentSize().height
		
		local newY = clvInnerContainerHeight - itemHeight * (index + 2)
		
		newY = newY * -1
		clvInnerContainer:runAction(
			cc.Sequence:create(
				cc.MoveTo:create(
					0.0, cc.p(0, newY)
				)
			)
		)
	
	end
	-----------------------------------------
	-- 触发点击
	
	if true == isClick then
		self:clickIndexChapters(index)
	end
end

-- 点击列表更新界面
function PVEStage:clickIndexChapters(index)
	local items = self.chapterListView:getItems()
	local item = items[index]
	if nil == item then
		return
	end
	item:setHighlighted(true)
	local sceneID = item.mySceneID
	local owner = item
	local currentPageType = item.currentPageType
	state_machine.excute("duplicate_page_controller_change_scene", 0, {_datas = { sceneID = sceneID, currentPageType = currentPageType }})
end

function PVEStage:updateListViewChange()
	local items = self.chapterListView:getItems()

	for i,v in ipairs (items) do
		v:setHighlighted(false)
		if v.mySceneID == self.pveSceneID then
			v:setHighlighted(true)
			self.sceneIndex = i
		end
	end
end

function PVEStage:updateListView()
	
	local root = self.roots[1]
	-- 关卡列表
	self.chapterListView:removeAllItems()
	local isNext = false
	--显示所有seat
	local sCountCurrent = 0 --用于记录当前有多少条场景
	local normalScene = {}
	local sCount = 0
	local bLastScene = false
	
	local function getOpenSceneList()
		for i = 1,table.getn(_ED.scene_current_state) do
			local _scene_type = dms.int(dms["pve_scene"], i, pve_scene.scene_type)
			if _scene_type == self.currentSceneType then
				if _ED.scene_current_state[i] == nil or _ED.scene_current_state[i] == "" then
					return
				end
				if tonumber(_ED.scene_current_state[i]) < 0 then
					if isNext == true then
						return
					else
						isNext = true
					end
				end
				sCount = sCount + 1
				sCountCurrent = sCount
				normalScene[sCount] = i
			end
		end
	end
	getOpenSceneList()
	
	self.maxMapCount = sCount
	self.openSceneList = normalScene

	self.currentInnerContainer = self.chapterListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()

	local nCount = table.getn(self.openSceneList)
	
	local n = nCount
	local k = nCount
	for i = 1, nCount do
		local isInvalid = false
		if i == 1 and isNext == true then
			isInvalid = true
		end
		local v = self.openSceneList[k]
		local tmpDSSC = DuplicateSelectSeatCell:createCell()
		tmpDSSC:init(v, self.currentPageType, isInvalid, i)
		self.chapterListView:addChild(tmpDSSC)
		k = k - 1
	end
	self.chapterListView:refreshView()
	self.chapterListView:jumpToBottom()
	
	-- 初次进入定位
	local items = self.chapterListView:getItems()
	for i,v in ipairs (items) do
		if v.mySceneID == self.pveSceneID then
			self:gotoIndexChapters(i)
			self.sceneIndex = i
			-- 检查是否存在 跳转npc 
			if nil ~=  tonumber(_ED._current_seat_index) and tonumber(_ED._current_seat_index) > 0 then
				self:gotoTargetScene()
			end
			return
		end
	end
end

function PVEStage:onUpdate( dt )
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
		then
		if self.chapterListView ~= nil and self.currentInnerContainer ~= nil then
			local size = self.chapterListView:getContentSize()
			local posY = self.currentInnerContainer:getPositionY()
			-- if self.currentInnerContainerPosY == posY then
			-- 	return
			-- end
			local items = self.chapterListView:getItems()
			if items[1] == nil then
				return
			end
			self.currentInnerContainerPosY = posY
			local itemSize = items[1]:getContentSize()
			for i, v in pairs(items) do
				local tempY = v:getPositionY() + posY
				if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
					v:unload()
				else
					v:reload()
				end
			end
		end
	end
end

function PVEStage:onLoad()
	self._load_over = true
	self:onInit()
end

function PVEStage:onInit()
	local tmpCsb = nil
	local root = nil
	tmpCsb = csb.createNode("duplicate/pve_zhangjie_1.csb")
	root = tmpCsb:getChildByName("root")
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)

	self.cacheBgImagePanel = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	self.chapterListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
end


function PVEStage:onInitInfo()
	self:drawBgIamgePanel()
	self:updateListView()
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
	else
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_zhangjie_2"):setString(_plot_copy_name[self.currentPageType])
	end
end

--播放npc动画
function PVEStage:playNpcAnimation(index)
	self.cacheNpcArmature._nextAction = index
	self.cacheNpcArmature:getAnimation():playWithIndex(index)
	self:drawNpcBody()
end

--通用按钮点击事件添加
function PVEStage:addTouchEventFunc(uiName, eventName, actionMode)
	local tmpArt = ccui.Helper:seekWidgetByName(self.roots[1], uiName)
	fwin:addTouchEventListener(tmpArt, nil, 
	{
		terminal_name = eventName, 
		next_terminal_name = eventName, 
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = actionMode
	},
	nil, 0)
	return tmpArt
end


function PVEStage:onExit()
	cacher.removeObject("PVEStageClass")
	
	if fwin:find("PVESecondarySceneClass") ~= nil then
		state_machine.excute("duplicate_pve_secondary_scene_back_home", 0, nil)
	end
	
end


function PVEStage:init(sceneID, types)
	self.pveSceneID = tonumber(sceneID)
	self.currentSceneType = dms.int(dms["pve_scene"], self.pveSceneID, pve_scene.scene_type) 

	self.types = types   -- 1为普通副本   2为名将副本 3 精英副本
	if self.types == 2 and self.oneTimes == true then

	elseif self.types == 1 and self.oneTimes == true then
	
	end
	self.oneTimes = true

	return self
end

local page_stage_open_instance_window_terminal = {
	_name = "page_stage_open_instance_window",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local sceneID = params.sceneID
		local sceneType = params.sceneType
		local isInit = params.isInit
		local pveStage = cacher.getObject("PVEStageClass")

		if pveStage == nil then
			pveStage = PVEStage:new():init(sceneID, sceneType)
			pveStage._load_over = false
			pveStage:onLoad()
			pveStage:initAction()
			cacher.addObject(pveStage)
			
			if true == isInit then
				return true
			end
		else
			pveStage:init(sceneID, sceneType)
			pveStage:initAction()
		end
		fwin:open(pveStage, fwin._background)

		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(page_stage_open_instance_window_terminal)
state_machine.init()
