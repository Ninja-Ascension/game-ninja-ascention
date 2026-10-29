-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏副本界面
-------------------------------------------------------------------------------------------------------
LGeneralCopyWindow = class("LGeneralCopyWindowClass", Window)

local lgeneral_copy_window_open_window_terminal = {
	_name = "lgeneral_copy_window_open_window",
	_init = function (terminal) 
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params) 
		fwin:open(LGeneralCopyWindow:new():init(), fwin._ui)
		return true
	end,
	_terminal = nil, 
	_terminals = nil
}

local lgeneral_copy_window_close_window_terminal = {
	_name = "lgeneral_copy_window_close_window",
	_init = function (terminal) 
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params) 
		fwin:close(fwin:find("LGeneralCopyWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(lgeneral_copy_window_open_window_terminal)
state_machine.add(lgeneral_copy_window_close_window_terminal)
state_machine.init()

function LGeneralCopyWindow:ctor()
    self.super:ctor()
	self.roots = {}
	
	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosX = nil
	
	self.currentPageType = nil
	self.currentSceneType = nil
	
	self.sceneID = -1			--当前的关卡id
	self.npcIndex = -1			--npcIndex
	self.copyId = -1 			--NPC的ID号，目前用于日常活动副本 
	
	-- Initialize lgeneral copy window state machine.
    local function init_lgeneral_copy_window_terminal()
		local lgeneral_copy_window_visible_terminal = {
			_name = "lgeneral_copy_window_visible",
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
		state_machine.add(lgeneral_copy_window_visible_terminal)
        state_machine.init()
    end
    
    -- call func init lgeneral copy window state machine.
    init_lgeneral_copy_window_terminal()
end

function LGeneralCopyWindow:init()
	return self
end

function LGeneralCopyWindow:onUpdate(dt)
	if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
		local size = self.currentListView:getContentSize()
		local posX = self.currentInnerContainer:getPositionX()
		if self.currentInnerContainerPosX == posX then
			return
		end
		self.currentInnerContainerPosX = posX
		local items = self.currentListView:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempX = v:getPositionX() + posX
			if tempX + itemSize.width * 2 < 0 or tempX > size.width + itemSize.width * 2 then
				v:unload()
			else
				v:reload()
			end
		end
	end
end


function LGeneralCopyWindow:onEnterTransitionFinish()
	local csbGeneralCopyList = csb.createNode("duplicate/pve_main_zx_listview_0.csb")
    local root = csbGeneralCopyList:getChildByName("root")
	root:removeFromParent(false)
	table.insert(self.roots, root)
    self:addChild(root)
	
	self.currentListView = ccui.Helper:seekWidgetByName(root, "ListView_pve_zx")
	self:initDraw()
end

--绘制控件
function LGeneralCopyWindow:initDraw()
	local user_grade=dms.int(dms["fun_open_condition"], 18, fun_open_condition.level)
	--print("user_grade,_ED.user_info.user_grade",user_grade,_ED.user_info.user_grade)
	if user_grade <= zstring.tonumber(_ED.user_info.user_grade) then
		
	else
		TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 18, fun_open_condition.tip_info))
		return false
	end
	
	local lastSceneId, firstScene = self:getOpenMaxSceneId(9)
	-- if lastSceneId < 0 then
	-- 	local dySceneDes = dms.atos(firstScene, pve_scene.open_condition_describe)
	-- 	TipDlg.drawTextDailog(dySceneDes)
	-- 	return false
	-- end
		
	if self.currentPageType ~= 1 then
		_ED._current_scene_id = 0
		_ED._current_seat_index = -1
	end	
	self:changeToPage(3, 9)
	self:updateCurrentCopyInfo()
	self:updateListView()
end

function LGeneralCopyWindow:updateListView()
		local root = self.roots[1]
		-- 关卡列表
		self.currentListView:removeAllItems()
		
		local isNext = false
		--显示所有seat
		local sCountCurrent = 0 --用于记录当前有多少条场景
		local normalScene = {}
		local sCount = 0
		local maxCount = 0
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
		
		maxCount = sCount
		self.maxMapCount = sCount
		self.openSceneList = normalScene
		self.currentListView:removeAllItems()

		local nowAttackSceneId, firstScene = self:getOpenMaxSceneId(9)
		
		app.load("client.landscape.cells.duplicate.lgeneral_copy_list_cell")
		for i,v in pairs(self.openSceneList) do	
			local cell = LgeneralCopyListCell:createCell()
			--print("..",v)
			cell:init(v,nowAttackSceneId,i)
			self.currentListView:addChild(cell)
		end
		
		self.currentListView:refreshView()

		self.currentListView:jumpToRight()
		
		--初次进入定位
		-- local items = self.currentListView:getItems()
		-- for i,v in ipairs (items) do
		-- 	if v.mySceneID == self.pveSceneID then
				
		-- 			self:gotoIndexChapters(i)
		-- 			self.sceneIndex = i
		-- 			--检查是否存在 跳转npc 
		-- 			if nil ~=  tonumber(_ED._current_seat_index) and tonumber(_ED._current_seat_index) > 0 then
		-- 				self:gotoTargetScene()
		-- 			end
					
		-- 		return
				
		-- 	end
		-- end
	
end

function LGeneralCopyWindow:getOpenMaxSceneId(currentSceneType)
		--print("getOpenMaxSceneId")
		local lastSceneId = -1
		--print("pve_scene.scene_type",pve_scene.scene_type)
		local _scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, currentSceneType)
		for i, v in pairs(_scenes) do
			local tempSceneId = dms.atoi(v, pve_scene.id)
			--print("---->", tempSceneId, _ED.scene_current_state[tempSceneId])
			if _ED.scene_current_state[tempSceneId] == nil
				or _ED.scene_current_state[tempSceneId] == ""
				or tonumber(_ED.scene_current_state[tempSceneId]) < 0 
				then
				break
			end	
			lastSceneId = tempSceneId	
		end
		--print("lastSceneId, _scenes[1]",lastSceneId, _scenes[1])
		return lastSceneId, _scenes[1]
end

function LGeneralCopyWindow:changeToPage(_currentPageType, _currentSceneType)
	self.currentPageType = _currentPageType
	self.currentSceneType = _currentSceneType
	_ED._last_page_type = self.currentPageType
end


function LGeneralCopyWindow:updateCurrentCopyInfo()
		--设置到最新最后的关卡
		-- self.sceneID = 1		--当前的关卡id
		-- self.npcIndex = -1		--npcIndex 
	local sCountCurrent = 0 --用于记录当前有多少条场景

	local function getOpenSceneList()
		for i = 1,table.getn(_ED.scene_current_state) do
			local _scene_type = dms.int(dms["pve_scene"], i, pve_scene.scene_type) 
			--> print(_scene_type)
			if _scene_type == self.currentSceneType then
				if _ED.scene_current_state[i] == nil 
					or _ED.scene_current_state[i] == ""
					or tonumber(_ED.scene_current_state[i]) < 0 then
					return
				end
				sCountCurrent = sCountCurrent + 1
			end
		end
	end
	if tonumber(_ED._current_scene_id) == 0 or _ED._current_scene_id == "" or _ED._current_scene_id == nil or true then
		getOpenSceneList()
		self.sceneID = sCountCurrent
	else
		self.sceneID = _ED._current_scene_id
	end

	if tonumber(_ED._current_seat_index) == 0 or _ED._current_seat_index == "" or _ED._current_seat_index == nil then
		self.npcIndex = -1
	else
		self.npcIndex = _ED._current_seat_index
	end
	-- 07/01 修正新版副本的教学指引时屏蔽的
	if  missionIsOver() == false then
	--	_ED._current_scene_id = 0
	--	_ED._current_seat_index = -1
	end

	if self.currentPageType == 4 then
		self.copyId = zstring.tonumber(_ED._daily_copy_npc_id)
		if self.copyId <= 0 then
			self.copyId = 1
		end
		return
	else
		self.copyId = -1
		_ED._daily_copy_npc_id = -1
	end
	local lastSceneId = -1
	local _scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, self.currentSceneType)
	for i, v in pairs(_scenes) do
		local tempSceneId = dms.atoi(v, pve_scene.id)
		if _ED.scene_current_state[tempSceneId] == nil
			or _ED.scene_current_state[tempSceneId] == ""
			or tonumber(_ED.scene_current_state[tempSceneId]) < 0 
			then
			break
		end
		lastSceneId = tempSceneId
	end
	self.sceneID = lastSceneId
	self.npcIndex = -1


	-- 获取下一个场景的开启状态
	local function getNextSceneId(_sceneId)	
		local _scene_type = dms.int(dms["pve_scene"], _sceneId, pve_scene.scene_type)
		local _scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, _scene_type)
		local _prevSceneId = -1
		local _nextSceneId = -1
		if _scenes ~= nil then
			for i, v in pairs(_scenes) do
				local tempSceneId = dms.atoi(v, pve_scene.id)
				if _prevSceneId == sceneID then
					_nextSceneId = tempSceneId
					return _nextSceneId
				end
				_prevSceneId = tempSceneId
			end
		end
		return nil
	end

	local tempNextSceneId = getNextSceneId(_ED._current_scene_id)
	if tempNextSceneId ~= nil and tonumber(_ED._current_scene_id) > 0 and tonumber(_ED.scene_current_state[tempNextSceneId]) == 0 then
		self.sceneID = tempNextSceneId
		self.npcIndex = -1
	else
		if tonumber(_ED._current_scene_id) == 0 or _ED._current_scene_id == "" or _ED._current_scene_id == nil then
		else
			self.sceneID = _ED._current_scene_id
			--> print("_ED._current_scene_id",_ED._current_scene_id)
		end

		if tonumber(_ED._current_seat_index) == 0 or _ED._current_seat_index == "" or _ED._current_seat_index == nil then
			self.npcIndex = -1
		else
			self.npcIndex = _ED._current_seat_index
			--> print("_ED._current_seat_index",_ED._current_seat_index)
		end
	end
	
	local tIndex = 0
	local maxIndex = 0
	if self.npcIndex > -1 then
		local npcIds = {}
		local npcStates = {}
		local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], zstring.tonumber(self.sceneID), pve_scene.npcs), ",")
		local sceneState = tonumber(_ED.scene_current_state[self.sceneID])
		if sceneState == nil then
			self.sceneID = lastSceneId
			sceneState = tonumber(_ED.scene_current_state[self.sceneID])
		end
		if sceneState ~= nil then
			for i = 1, table.getn(tempNpcIds) do
				local npcState = 0
				if sceneState + 1 == i then
					npcState = 1
				elseif sceneState + 2 == i then
					npcState = 2
					break
				elseif sceneState + 2 < i then
					break
				end
				tIndex = tIndex + 1
				npcIds[tIndex] = tempNpcIds[i]
				npcStates[tIndex] = npcState
			end
			if tIndex > 0 and npcStates[tIndex] == 1 and tIndex == self.npcIndex + 1 then
				self.npcIndex = -1
			end
			maxIndex = table.getn(tempNpcIds)
		else
			self.npcIndex = -1
		end
	end
	
	--print("new have scen",sCountCurrent)
end

function LGeneralCopyWindow:onExit()
	state_machine.remove("lgeneral_copy_window_visible")
end
