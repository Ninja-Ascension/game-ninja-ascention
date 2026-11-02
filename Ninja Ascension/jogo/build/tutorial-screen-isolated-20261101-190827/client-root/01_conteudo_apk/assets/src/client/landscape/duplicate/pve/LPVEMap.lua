-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏副关卡场景界面
-------------------------------------------------------------------------------------------------------
LPVEMap = class("LPVEMapClass", Window)

function LPVEMap:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	
	self.sceneID = 0
	self.mapType = 1
	self.copytype = 0
	self.rewardBoxes = {}
	self.nightmareBoxes = {}				-- 噩梦宝箱cell

	self.sceneTypeEnum = {
		MAINLINE = 0,
		ELITE = 1,
		NIGHTMARE = 15
	}
	
	app.load("client.landscape.cells.duplicate.lduplicate_npc_cell")
	app.load("client.cells.copy.plot_copy_chest")
	app.load("client.duplicate.pve.PVEChallengeFamousFistReward")
    local function init_lpve_map_window_terminal()
		local lpve_map_action_play_terminal = {
            _name = "lpve_map_action_play",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local action = self.actions[1]
				action:play(params._actionName, params._bRepeated or false)
				action:setFrameEventCallFunc(function (frame)
					if nil == frame or nil == params._eventName then
						return
					end
					
					local str = frame:getEvent()
					if str == params._eventName then
						params._eventFunc()
					end
				end)
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--npc点击事件
		local general_copy_npc_click_terminal = {
			_name = "general_copy_npc_click",
			_init = function(terminal)
			app.load("client.landscape.duplicate.pve.LPVEGeneral")
			end,
			 _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas
				--print("---",cell._npcid,cell._sceneID,cell._bossFlag,cell._npcState)
				if cell._npcState == nil then
					return false
				end
				-- datas{
				-- _npcid = npcid
				-- _sceneID = self.sceneID
				-- _bossFlag = tempNpcIds
				-- _npcState = npcStates
				-- }
				
				local _LPVEGeneral = LPVEGeneral:new()
				_LPVEGeneral:init(cell._npcid, 
							  cell._sceneID, 
							  cell._bossFlag,
							  cell._npcState)
				fwin:open(_LPVEGeneral, fwin._ui)
			return true
            end,
            _terminal = nil,
            _terminals = nil
			
		}
		state_machine.add(lpve_map_action_play_terminal)
		state_machine.add(general_copy_npc_click_terminal)
        state_machine.init()
    end
    
    init_lpve_map_window_terminal()
end

function LPVEMap:init(_sceneID, _type)
	self.copytype=_type
	self.sceneID = _sceneID
	-- print("_type,_sceneID",_type,_sceneID)
	if tonumber(_sceneID) >= 5 then
		self.mapType = 5
	else
		self.mapType = tonumber(_sceneID)
	end
	--名将副本直接读mapid
	if _type == 3 then
		self.mapType = dms.int(dms["pve_scene"],self.sceneID , pve_scene.scene_map_id)
		--print("mapid",self.mapType)
	end
end

function LPVEMap:onUpdateDraw()
	local root = self.roots[1]
	local action = self.actions[1]
	
	self.npcIds = {}
	self.npcStates = {}
	self.nightmareBoxes = {}
	local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], tonumber(self.sceneID), pve_scene.npcs), ",")
	local sceneState = tonumber(_ED.scene_current_state[self.sceneID])
	local tIndex = 1
	for i = 1, table.getn(tempNpcIds) do
		local npcState = 0
		if sceneState + 1 == i then
			npcState = 1
		-- elseif sceneState + 2 == i then
			-- npcState = 2
		-- elseif sceneState + 2 < i then
			self.npcIds[tIndex] = tempNpcIds[i]
			self.npcStates[tIndex] = npcState
			break
		end
		self.npcIds[tIndex] = tempNpcIds[i]
		self.npcStates[tIndex] = npcState
		tIndex = tIndex + 1
	end
	
	-- npc
	local npcIdTableText = nil
	local npcIdTable = nil
	if self.copytype == 3 then
		npcIdTableText = dms.string(dms["pve_scene"], self.sceneID, pve_scene.npcs)
		--print("npcIdTableText:",npcIdTableText)
		npcIdTable= zstring.split(npcIdTableText,",")
		--print("npcIdTable:",npcIdTable)		
	end
	local currentSceneType = dms.int(dms["pve_scene"], self.sceneID , pve_scene.scene_type) 
	for i = 1, #tempNpcIds do
		if self.copytype == 3 then
			self:createNpcAnimation(i,npcIdTable[i],self.npcStates[i], self.sceneID,i == #tempNpcIds)		
		else
			if __lua_project_id == __lua_project_gragon_tiger_gate 
				or __lua_project_id == __lua_project_red_alert 
				then
				local pad1 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pve_npc_yx_1")
				local pad2 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pve_npc_yx_2")
				local pad3 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pve_npc_yx_3")
				local pad4 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pve_npc_yx_4")
				local pad5 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pve_yx_baoxiang")
			
				pad1:setTouchEnabled(false)
				pad2:setTouchEnabled(false)
				pad3:setTouchEnabled(false)
				pad4:setTouchEnabled(false)
				pad5:setTouchEnabled(false)
			end
			local cell_npc = LDuplicateNPCCell:createCell()
			cell_npc:init(tempNpcIds[i], self.npcStates[i], self.sceneID, i, i == #tempNpcIds)
			local curNpcPad = ccui.Helper:seekWidgetByName(root, string.format("Panel_pve_npc_%d", i))
			curNpcPad:removeAllChildren(true)
			curNpcPad:addChild(cell_npc)
			curNpcPad.roots = cell_npc.roots

			cell_npc._data = tempNpcIds[i]
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
			else
				state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_battle_control_box",
				_widget = cell_npc,
				_invoke = nil,
				_interval = 0.5,})
			end

			if currentSceneType == self.sceneTypeEnum.NIGHTMARE then
				table.insert(self.nightmareBoxes, cell_npc)
			end
		end
	end
	
	-- npc创建的时候播放npc出现动画，只播放一次，这里做状态重置，因为新npc在下个地图，这个地图创建的npc不播动画
	LDuplicateWindow._infoDatas._isNewNPCAction = true
end
--创建角色动画
function LPVEMap:createNpcAnimation(i,npcid,npcStates,sceneID,tempNpcIds)
	local curNpcPad = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_pve_npc_yx_%d",i))
	
	app.load("client.landscape.cells.duplicate.plot.lpvemap_general_cell")
	local _LPVEMapGeneralCell = LPVEMapGeneralCell:createCell()
	_LPVEMapGeneralCell:init(npcid,npcStates,i)
	curNpcPad:addChild(_LPVEMapGeneralCell)
	
	local spirteindex = dms.int(dms["npc"], npcid, npc.head_pic)

	local armature = nil
	if animationMode == 1 then
		app.load("client.battle.fight.FightEnum")
		armature = sp.spine_sprite(curNpcPad, spirteindex, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
		armature:setPosition(cc.p(curNpcPad:getContentSize().width/2, 0))
	else
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. spirteindex .. ".ExportJson")
		armature = ccs.Armature:create("spirte_" .. spirteindex)
		armature:getAnimation():playWithIndex(0)
		armature:setPositionX(curNpcPad:getContentSize().width/2)
		curNpcPad:addChild(armature)
	end

	if npcStates == nil then
		armature:setColor(cc.c3b(50, 50, 50))
	end
	
	fwin:addTouchEventListener(curNpcPad, nil, 
	{
		terminal_name = "general_copy_npc_click", 	
		terminal_state = 0,
		_npcid = npcid,
		_sceneID = sceneID,
		_bossFlag = tempNpcIds,
		_npcState = npcStates
	}, 
	nil, 0)
	
end

function LPVEMap:getNpcState(_npcId)
	for i, v in pairs(self.npcIds or {}) do -- Fury 4-oct (:235): pagina aun sin onUpdateDraw (cofres del 一键领取)
		if tonumber(v) == tonumber(_npcId) then
			return self.npcStates[i]
		end
	end
	return nil
end

function LPVEMap:drawPVERewardBox()
	local root = self.roots[1]
	self.rewardBoxes = {}
	local npcIdListStr = dms.string(dms["pve_scene"], self.sceneID, pve_scene.design_npc)
	local npcIDTable = zstring.split(npcIdListStr, ",")

	for i = 1, #npcIDTable do
		local npcBoxPad = nil 
		if self.copytype == 3 then
			npcBoxPad=ccui.Helper:seekWidgetByName(root, string.format("Panel_pve_yx_baoxiang"))
		else
			npcBoxPad=ccui.Helper:seekWidgetByName(root, string.format("Panel_pve_baoxiang_%d", i))
		end
		if npcBoxPad ~= nil then
			npcBoxPad:removeAllChildren(true)
			table.insert(self.rewardBoxes, npcBoxPad)
		end
	end
	
	for i, v in ipairs(self.rewardBoxes) do
		local chest_cell = nil
		local param = {state = 0, starNum = 0}
		local drawState = _ED.scene_draw_chest_npcs[npcIDTable[i]]
		local npcState = self:getNpcState(npcIDTable[i])
		
		if npcState ~= nil and npcState ~= 1 and drawState ~= 1 then
			param.state = 1
		elseif drawState == 1 then 	
			param.state = 2
		end	
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
			then
			chest_cell = state_machine.excute("lpve_reward_cell_create", 0, {4, param, self.sceneID, tonumber(npcIDTable[i]), npcState})
		else
			chest_cell = PlotCopyChest:createCell()
			chest_cell:init(4, param, self.sceneID, tonumber(npcIDTable[i]), npcState)
		end
		
		v:addChild(chest_cell)
		v.roots = chest_cell.roots
		
		if param.state == 1 then
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_battle_control_box",
			_widget = v,
			_invoke = nil,
			_interval = 0.5,})
		end
	end

	-- 刷新噩梦宝箱
	for _, v in ipairs(self.nightmareBoxes) do
		v:onUpdateDraw()
	end
end

-- 显示 首胜奖励
function LPVEMap:chenkupFistReward()
	local rewardList = getSceneReward(41)
	--print("---------------",rewardList)
	--print("---------------",_ED._scene_npc_id)
	if nil ~= rewardList then
		local gnum = zstring.tonumber(getRewardValueWithType(rewardList, 2))
		local npcid = zstring.tonumber(_ED._scene_npc_id)
		if gnum  > 0 and  npcid > 0 then
			
			local view = PVEChallengeFamousFistReward:createCell()
			
			view:init(npcid, gnum)
			
			fwin:open(view, fwin._windows)
		end
	end

end

function LPVEMap:showEnterAction( ... )
	local root = self.roots[1]
	for i=1,10 do
		local Panel_pve_npc = ccui.Helper:seekWidgetByName(root, "Panel_pve_npc_"..i)
		if Panel_pve_npc ~= nil then
			Panel_pve_npc:stopAllActions()
			Panel_pve_npc:setScale(0)
			local basePosY = Panel_pve_npc:getPositionY()
			local delay = cc.DelayTime:create((i - 1) * 0.1)
			local moveTo1 = cc.MoveTo:create(0.1, cc.p(Panel_pve_npc:getPositionX(), basePosY + 12))
            local scale1 = cc.ScaleTo:create(0.1, 1.1)
			local bigAction = cc.Spawn:create(moveTo1, scale1)

            local scale2 = cc.ScaleTo:create(0.08, 1)
            local moveTo2 = cc.MoveTo:create(0.08, cc.p(Panel_pve_npc:getPositionX(), basePosY))
			local smallAction = cc.Spawn:create(moveTo2, scale2)

            Panel_pve_npc:runAction(cc.Sequence:create(delay, bigAction, smallAction))
		end
		local Panel_pve_baoxiang = ccui.Helper:seekWidgetByName(root, "Panel_pve_baoxiang_"..i)
		if Panel_pve_baoxiang ~= nil then
			Panel_pve_baoxiang:stopAllActions()
			Panel_pve_baoxiang:setScale(0)

			local basePosY = Panel_pve_baoxiang:getPositionY()
			local delay = cc.DelayTime:create((i - 1) * 0.25)
			local moveTo1 = cc.MoveTo:create(0.1, cc.p(Panel_pve_baoxiang:getPositionX(), basePosY + 12))
            local scale1 = cc.ScaleTo:create(0.1, 1.1)
			local bigAction = cc.Spawn:create(moveTo1, scale1)

            local scale2 = cc.ScaleTo:create(0.08, 1)
            local moveTo2 = cc.MoveTo:create(0.08, cc.p(Panel_pve_baoxiang:getPositionX(), basePosY))
			local smallAction = cc.Spawn:create(moveTo2, scale2)

            Panel_pve_baoxiang:runAction(cc.Sequence:create(delay, bigAction, smallAction))
		end
	end
end

function LPVEMap:onEnterTransitionFinish()
	local filePath = string.format("duplicate/map/pve_map_%d.csb", self.mapType)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local pathId = dms.string(dms["pve_scene"], self.sceneID, pve_scene.scene_map_id)
		filePath = string.format("duplicate/map/pve_map_%d.csb", pathId)
	end
    local csbPVEMap = csb.createNode(filePath)
    local root = csbPVEMap:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbPVEMap)
	
	local action = csb.createTimeline(filePath)
	root:runAction(action)
	table.insert(self.actions, action)

	-- 彩蛋事件添加
	local Panel_map = ccui.Helper:seekWidgetByName(root, "Panel_map")
	local sceneType = dms.int(dms["pve_scene"], self.sceneID, pve_scene.scene_type)
	if sceneType == 0 or sceneType == 1 then 
		showEasterEggEvent(sceneType + 2,self.sceneID,Panel_map)
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		return
	end
	self:onUpdateDraw()
	self:drawPVERewardBox()

	if self.copytype == 3 then
		self:chenkupFistReward()
	end

end

function LPVEMap:onInit( ... )
	if self.roots ~= nil and self.roots[1] ~= nil then
	else
		local pathId = dms.string(dms["pve_scene"], self.sceneID, pve_scene.scene_map_id)
		local filePath = string.format("duplicate/map/pve_map_%d.csb", pathId)
	    local csbPVEMap = csb.createNode(filePath)
	    local root = csbPVEMap:getChildByName("root")
		table.insert(self.roots, root)
	    self:addChild(csbPVEMap)
		
		local action = csb.createTimeline(filePath)
		root:runAction(action)
		table.insert(self.actions, action)
	end
	
	self:onUpdateDraw()
	self:drawPVERewardBox()

	if _ED.back_by_fighting == true then
	else
		self:showEnterAction()
	end
	_ED.back_by_fighting = false
	if self.copytype == 3 then
		self:chenkupFistReward()
	end
end

function LPVEMap:unLoad( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end
	for i=1,10 do
		local Panel_pve_npc = ccui.Helper:seekWidgetByName(root, "Panel_pve_npc_"..i)
		local Panel_pve_baoxiang = ccui.Helper:seekWidgetByName(root, "Panel_pve_baoxiang_"..i)
		if Panel_pve_npc ~= nil then
			Panel_pve_npc:removeAllChildren(true)
		end
		if Panel_pve_baoxiang ~= nil then
			Panel_pve_baoxiang:removeAllChildren(true)
		end
	end
end

function LPVEMap:onExit()
	state_machine.remove("lpve_map_action_play")
	state_machine.remove("general_copy_npc_click")
end
-----------------------------------------
function LPVEMap:createCell()
    local cell = LPVEMap:new()
    cell:registerOnNodeEvent(cell)
    return cell
end
-----------------------------------------