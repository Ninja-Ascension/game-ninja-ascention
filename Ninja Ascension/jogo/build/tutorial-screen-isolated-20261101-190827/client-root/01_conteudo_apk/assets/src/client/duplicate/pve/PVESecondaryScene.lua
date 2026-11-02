-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE 二级战斗 场景
-------------------------------------------------------------------------------------------------------
PVESecondaryScene = class("PVESecondarySceneClass", Window)

function PVESecondaryScene:ctor()
    self.super:ctor()
    self.roots = {}
	self.pveSceneID = 0				--场景ID
	self.selectSeatIndex = -1			--当前选择关卡的index
	self.hasImmaturity = false -- 标记是否存在该场景中没有打过的npc
	
	self.seatIndex = nil
	
	app.load("client.duplicate.pve.PVESecondarySceneCover")
	app.load("client.duplicate.pve.PVEChallengeFamousFistReward")
	app.load("client.mission.missionex.PrologueScreenInfo")
	
	app.load("client.cells.duplicate.pageview_seat_role_cell")
	app.load("client.cells.duplicate.pageview_seat_role_guide_cell")
	_ED._battle_init_type = "0"
	local function init_terminal()
		
		-- 返回
		local duplicate_pve_secondary_scene_back_home_terminal = {
            _name = "duplicate_pve_secondary_scene_back_home",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				local pveWin = fwin:find("PVEStageClass")
				
				if nil == pveWin then
					if instance.currentPageType == 1 or instance.currentPageType == 2 then
						if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
							or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge 
							or __lua_project_id == __lua_project_warship_girl_b
							or __lua_project_id == __lua_project_yugioh 
							then 
							if instance.currentPageType == 1 then 
								state_machine.excute("shortcut_open_duplicate_window", 0, nil)
							else
								state_machine.excute("shortcut_open_elite_duplicate_window", 0, nil)
							end
						else
							state_machine.excute("shortcut_open_duplicate_window", 0, nil)
						end
						
					else
						state_machine.excute("shortcut_open_duplicate_hight_copy_window", 0, nil)
					end
				
				end
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 武将
		local duplicate_pve_secondary_scene_role_click_terminal = {
            _name = "duplicate_pve_secondary_scene_role_click",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			
				-- local sceneID = params._datas.sceneID
				-- local owner = params._datas.owner
				-- local currentPageType = params._datas.currentPageType
				-- state_machine.excute("duplicate_page_controller_change_scene", 0, {_datas = { sceneID = sceneID, currentPageType = currentPageType }})

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		-- 宝箱
		local duplicate_pve_secondary_scene_box_click_terminal = {
		_name = "duplicate_pve_secondary_scene_box_click",
		_init = function (terminal) 
		end,
		_inited = false,
		_instance = self,
		_state = 0,
		_invoke = function(terminal, instance, params)
		
			-- local sceneID = params._datas.sceneID
			-- local owner = params._datas.owner
			-- local currentPageType = params._datas.currentPageType
			-- state_machine.excute("duplicate_page_controller_change_scene", 0, {_datas = { sceneID = sceneID, currentPageType = currentPageType }})

			return true
		end,
		_terminal = nil,
		_terminals = nil
        }
		
		--
		
		-- --添加需要使用的状态机到状态机管理器去
		
		
		state_machine.add(duplicate_pve_secondary_scene_back_home_terminal)
		state_machine.add(duplicate_pve_secondary_scene_role_click_terminal)
		state_machine.add(duplicate_pve_secondary_scene_box_click_terminal)
        state_machine.init()
	end
	
	init_terminal()
	
end


function PVESecondaryScene:drawRole()
	local root = self.npcRoot
	self.rewardNeedStar = zstring.split(dms.string(dms["pve_scene"], tonumber(self.sceneID), pve_scene.reward_need_star), ",")
	self.sceneNameTxt = dms.string(dms["pve_scene"], tonumber(self.sceneID), pve_scene.scene_name)
	self.sceneStarNum = dms.string(dms["pve_scene"], tonumber(self.sceneID), pve_scene.total_star)
	self.getStarCount = tonumber(_ED.get_star_count[self.sceneID])
	self.starRewardState = zstring.tonumber(_ED.star_reward_state[self.sceneID])

	self.npcIds = {}
	self.npcStates = {}
	local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], tonumber(self.sceneID), pve_scene.npcs), ",")
	local sceneState = tonumber(_ED.scene_current_state[self.sceneID])
	local tIndex = 1
	for i = 1, table.getn(tempNpcIds) do
		local npcState = 0
		if sceneState + 1 == i then
			npcState = 1
		elseif sceneState + 2 == i then
			npcState = 2
		elseif sceneState + 2 < i then
			npcState = 2
		end
		self.npcIds[tIndex] = tempNpcIds[i]
		self.npcStates[tIndex] = npcState
		tIndex = tIndex + 1
	end
	
	local lastSeatIndex = -9999
	local lastSeatCell = nil

	local rootWidth = root:getContentSize().width
	
	self.hasImmaturity = false -- 标记是否存在该场景中没有打过的npc
	--显示所有关卡
	for i = 1, table.getn(self.npcIds) do
		--------------------------------------------------------------------
		local npcPanel = ccui.Helper:seekWidgetByName(root, string.format("Panel_js_%d",i))
		
		local isLeft = rootWidth * 0.5 < npcPanel:getPositionX()
		local cell_npc = PageViewSeatRole:createCell()
		cell_npc:init(self.npcIds[i], self.npcStates[i], self.sceneID, i,self.currentPageType, isLeft)
		
		npcPanel:addChild(cell_npc)
		cell_npc._data = self.npcIds[i]

		if self.npcStates[i] >= 2 then
			-- 未开启的
			
			if self.currentPageType == 3 then
				-- 名将灰色
				cell_npc:setGrayRole()
			else
				-- 普通隐藏
				cell_npc:setHideRole(true)
			end
			--unfinished
			self.hasImmaturity = true
			
		elseif self.npcStates[i] == 1 then
			-- 当前的
			cell_npc:setSelectSign(true)
			lastSeatIndex = lastSeatIndex +1
			
			self.hasImmaturity = true
			if self.currentPageType == 1 or self.currentPageType == 2 then
				if i > 1 then
					-- 普通隐藏
					cell_npc:setHideRole(true)
					-- 普通的 准备 显示 动画
					self:checkupAnimationRole(i,cell_npc)
				else
					local action = csb.createTimeline(self.csbPath)	
					root:runAction(action)
					action:gotoFrameAndPause(0)
				end
			end
		else
			-- 打过的
			
			lastSeatIndex = i
			lastSeatCell = cell_npc
			self.currentNpcID = cell_npc.npcID
		
		end
		
		--------------------------------------------------------------------
	end
	self.lastSeatIndex = lastSeatIndex
	--self:checkupAnimationRole(2,cell_npc)
	
	if false == self.hasImmaturity then
		if self.currentPageType == 1 or self.currentPageType == 2 then
			
			-- 普通的 准备 显示 动画
			self:showAllPathSign()
		end
	end
	----------------------------------------------------------------------
	
	-- 如果有外部跳入指引
	if nil ~=  tonumber(self.seatIndex) and tonumber(self.seatIndex) > 0 then
		lastSeatIndex = tonumber(self.seatIndex)
		self:gotoIndex(lastSeatIndex)
		-- -1 战斗返回  0 碎片指引 
		if _ED._duplicate_is_show_guide == true then
			self:showGuide(lastSeatIndex)
		end
	else
		-- 定位 当前最大npc位置
		if -9999 ~= lastSeatIndex then
			self:gotoIndex(lastSeatIndex)
		end
	end
	
	_ED._duplicate_is_show_guide = false
	-------------------------------------------------------------------------
end


function PVESecondaryScene:gotoIndex(index)
	----------------------------------------------------------------------
	-- 定位 当前最大npc位置
	if index > 0 and index <= 10 then
		
		local sv = self.mapScrollView
		local svHeight = sv:getContentSize().height
		local svInnerContainer = sv:getInnerContainer()
		local svInnerContainerHeight = svInnerContainer:getContentSize().height
		
		local npcPanel = ccui.Helper:seekWidgetByName(self.npcRoot, string.format("Panel_js_%d",index))
		
		if nil == npcPanel then
			return 
		end
		self.mapScrollView:jumpToBottom()
		local npcPanelY = npcPanel:getPositionY()
		local newY = npcPanelY - svHeight*0.5
		if svInnerContainerHeight > svHeight then
			if npcPanelY <= svHeight*0.5 then
				self.mapScrollView:jumpToBottom()
			elseif npcPanelY >= svHeight or #self.npcStates == index then
				self.mapScrollView:jumpToTop()
			else
				newY = newY * -1
				if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
					self.mapScrollView:jumpToTop()
					local topPosY = sv:getInnerContainer():getPositionY()
					if topPosY > newY then 
						newY = topPosY
					end

					svInnerContainer:runAction(
					cc.Sequence:create(
						cc.MoveTo:create(
							0.0, cc.p(0, newY)
						)
					)
				)
				else
					svInnerContainer:runAction(
						cc.Sequence:create(
							cc.MoveTo:create(
								0.0, cc.p(0, newY)
							)
						)
					)
				end
				
			end
		end
	end
	-------------------------------------------------------------------------
end

-- 显示 跳入指引
function PVESecondaryScene:showGuide(index)
	if index > 0 and index <= 10 then
		local npcPanel = ccui.Helper:seekWidgetByName(self.npcRoot, string.format("Panel_js_%d",index))
		local size = npcPanel:getContentSize()
		
		local guide = PageViewSeatRoleGuide:createCell()
		if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
			guide:setPosition(cc.p(size.width * 0.5-40, size.height*0.5-10))
		else
			guide:setPosition(cc.p(size.width * 0.5, size.height*0.5))
		end
		
		npcPanel:addChild(guide)
		
		self.guide = guide
	end
end

-- 显示 首胜奖励
function PVESecondaryScene:chenkupFistReward()

	local rewardList = getSceneReward(41)
	if nil ~= rewardList then
		local gnum = zstring.tonumber(getRewardValueWithType(rewardList, 2))
		local npcid = zstring.tonumber(_ED._duplicate_current_seat_index_npc)
		if gnum  > 0 and  npcid > 0 then
			
			local view = PVEChallengeFamousFistReward:createCell()
			
			view:init(npcid, gnum)
			
			fwin:open(view, fwin._windows)
		end
	end

end

function PVESecondaryScene:firstOpenScene(sceneId)
	if _ED.scene_last_state1[sceneId] ~= _ED.scene_current_state[sceneId] then
		_ED.scene_last_state1[sceneId] = _ED.scene_current_state[sceneId]
		return true
	end
	return false
end


-- 显示 通关关卡 界面
function PVESecondaryScene:chenkupFinishedAllNPC()

	if self.hasImmaturity == false  then
		if self:firstOpenScene(zstring.tonumber(self.sceneID)) then
			if (__lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_warship_girl_b 
				or __lua_project_id == __lua_project_yugioh
				)
				and self.currentPageType == 2 
				then 
			else
				local infoGUI = PrologueScreenInfo:new()
				infoGUI:init(self.sceneID, self.sceneIndex,1)
				fwin:open(infoGUI, fwin._screen)
			end
		end
	end
end

function PVESecondaryScene:firstIntoScene(sceneId)
	if _ED.scene_last_state[sceneId] ~= _ED.scene_current_state[sceneId] then
		_ED.scene_last_state[sceneId] = _ED.scene_current_state[sceneId]
		return true
	end
	return false
end

-- 显示 初始关卡 界面
function PVESecondaryScene:chenkupFirstInto()
	-- 获取当前场景的 星星数
	local currentStar = tonumber(_ED.get_star_count[self.sceneID])
	
	-- 为0时 就是一个都没打过新进入的
	
	if currentStar == 0 then
		if self:firstIntoScene(zstring.tonumber(self.sceneID)) == true then
			if (__lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_warship_girl_b 
				or __lua_project_id == __lua_project_yugioh
				)
				and self.currentPageType == 2 
				then 
				--精英副本中不弹这个界面
			else
				local infoGUI = PrologueScreenInfo:new()
				infoGUI:init(self.sceneID, self.sceneIndex,0)
				fwin:open(infoGUI, fwin._screen)
			end
		end
	end
end

function PVESecondaryScene:firstOpenNPC(npdId)
	if _ED.npc_last_state1[npdId] ~= _ED.npc_state[npdId] then
		_ED.npc_last_state1[npdId] = _ED.npc_state[npcid]
		return true
	end
	return false
end

function PVESecondaryScene:checkupAnimationRole(index,cell_npc) 
	if true then
		local action = csb.createTimeline(self.csbPath)	
		self.roots[1]:runAction(action)
		local kname = string.format("Panel_js_%d", index-1)
		if self:firstOpenNPC(zstring.tonumber(cell_npc.npcID)) then
			-- 记录
			action:setFrameEventCallFunc(function (frame)
				if nil == frame then
					return
				end
				
				local str = frame:getEvent()
				if str == "Panel_js_over" then
					-- 显示角色
					-- cell_npc:setHideRole(false)
				end
			end)
			cell_npc:setHideRole(false)
			action:play(kname, false)
			
			-- 检查 当前关卡数 2-2 弹窗
			if cSceneID == 2 and npcIndex == 2  then
				state_machine.excute("show_activity_first_recharge_popup", 0, nil)
			end
			
		else

			cell_npc:setHideRole(false)
			if __lua_project_id == __lua_project_warship_girl_b 
				or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_yugioh 
				then 
			else
				local ret = action:getAnimationInfo(kname)
				local endIndex = ret.endIndex
				action:gotoFrameAndPause(endIndex)
			end
		end
	
	end
end

function PVESecondaryScene:showAllPathSign() 
	local action = csb.createTimeline(self.csbPath)	
	self.roots[1]:runAction(action)
	local n = action:getDuration()
	action:gotoFrameAndPause(n)
end


function PVESecondaryScene:init(sceneID,currentPageType,sceneIndex, seatIndex)
	self.sceneID = sceneID
	self.currentPageType = currentPageType
	self.sceneIndex = sceneIndex
	
	if nil ~= seatIndex then
		self.seatIndex = seatIndex
	else
		self.seatIndex = _ED._current_seat_index
	end
end

function PVESecondaryScene:onEnterTransitionFinish()
	_ED._duplicate_current_scene_id = self.sceneID
	
	local sv = csb.createNode("duplicate/pve_guanka_scrollview.csb")
	
	local root = sv:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(sv)
	
	self.mapScrollView = ccui.Helper:seekWidgetByName(self.roots[1],"ScrollView_1")
	self.mapScrollView:jumpToBottom()
	
	if (__lua_project_id == __lua_project_warship_girl_a 
        or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
		and ___is_open_firstCharge == true
        then
        if _ED._fight_is_win_bool ~= nil and _ED._fight_is_win_bool == true then
        	_ED._fight_is_win_bool = false
        	app.load("client.activity.ActivityFirstRechargePopup")
            state_machine.excute("activity_first_recharge_popup_open_window", 0, 0)
        end
    end


	
	local index = dms.int(dms["pve_scene"], self.sceneID, pve_scene.scene_map_id)
	self.mapIndex = index
	self.csbPath = string.format("duplicate/pve_guanka_%d.csb", index)
	
	local csbPVESecondaryScene = csb.createNode(self.csbPath)
	local sroot = csbPVESecondaryScene:getChildByName("root")
	local Panel_7 = ccui.Helper:seekWidgetByName(sroot,"Panel_7")
	Panel_7:removeFromParent(false)
	table.insert(self.roots, Panel_7)
	self.npcRoot = Panel_7
	
    self.mapScrollView:getInnerContainer():addChild(Panel_7)
	self.mapScrollView:getInnerContainer():setContentSize( Panel_7:getContentSize())
	

	local cover = PVESecondarySceneCover:createCell()
	cover:init(self.sceneID,self.currentPageType)
	self:addChild(cover)
	table.insert(self.roots, cover.roots[1])
	
	if self.currentPageType == 3 then
	 
		app.load("client.duplicate.pve.PVESecondaryScenePlot")
		local plot = PVESecondaryScenePlot:createCell()
		plot:init(self.sceneID,self.currentPageType)
		self:addChild(plot)
	
	end

	self:drawRole()
	
	-------------------------------------------------------------------------------
	
	-- 名将场景
	if self.currentPageType == 3 then
		self:chenkupFistReward()
	end
	
	if missionIsOver() == true then
		-- 教学中,不主动触发
		-- 普通场景
		if self.currentPageType == 1 or self.currentPageType == 2 then
			self:chenkupFinishedAllNPC()
			self:chenkupFirstInto()
		elseif self.currentPageType == 3 then
			local npcInfo = fwin:find("PrologueScreenInfoClass")
			if npcInfo ~= nil then
				fwin:close(npcInfo)
			end
			
		end
	end

	--------------------------------------------------------------------------------
	
	----------------------------------
	if self.currentPageType == 1 or self.currentPageType == 2 then
		local menu = fwin:find("MenuClass")
		if menu ~= nil then
			menu:setVisible(false)
		end
	end
	----------------------------------
	-- 绘制用户的基础信息
	self.pveMapInformation = PVEMapInformation:new()
	if __lua_project_id ~= __lua_project_red_alert_time then
		fwin:open(self.pveMapInformation, fwin._windows)
	end
	----------------------------------
	
	_ED._duplicate_current_scene_index = self.sceneIndex --场景序号
	_ED._duplicate_current_scene_type = self.currentPageType --场景类型
end

function PVESecondaryScene:onExit()

	local menu = fwin:find("MenuClass")
	if menu ~= nil then
		menu:setVisible(true)
	end
	
	local npcInfo = fwin:find("PrologueScreenInfoClass")
	if npcInfo ~= nil then
		fwin:close(npcInfo)
	end
		
	if nil ~= self.pveMapInformation then
		fwin:close(self.pveMapInformation)
	end
	
	state_machine.remove("duplicate_pve_secondary_scene_back_home")
	state_machine.remove("duplicate_pve_secondary_scene_role_click")
	state_machine.remove("duplicate_pve_secondary_scene_box_click")
	
end

