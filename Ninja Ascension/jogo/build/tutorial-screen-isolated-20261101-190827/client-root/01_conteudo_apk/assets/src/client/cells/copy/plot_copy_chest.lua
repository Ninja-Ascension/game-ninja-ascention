----------------------------------------------------------------------------------------------------
-- 说明：副本宝箱元件的绘制及逻辑实现
-------------------------------------------------------------------------------------------------------
PlotCopyChest = class("PlotCopyChestClass", Window)
 
function PlotCopyChest:ctor()
    self.super:ctor()
	self.roots = {}
	self.sceneId = 0 -- 场景id
	self.npcId = 0
	self.openState = {}  -- state = 0.关闭状态  1.开启未获取宝物状态 2.开启并已经获取状态  starNum 星数
	self.chestState = 0 --0.Npc宝箱   1.铜箱子  2.铁箱子  3.金箱子  4.龙虎门Npc宝箱
	self.starReward = -1
	self.isCanPlayGetAni = false

    -- Initialize PlotCopyChest page state machine.
    local function init_plot_copy_chest_terminal()	
		-- 打开场景星级奖励界面
		local plot_copy_chest_pve_scene_star_rewardterminal = {
            _name = "plot_copy_chest_pve_scene_star_reward",
            _init = function (terminal) 
                app.load("client.duplicate.pve.PVESceneStarReward")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local sceneId = params._datas._sceneId
				local openState = params._datas._openState
				local chestState = params._datas._chestState
                local pveSceneStarReward = PVESceneStarReward:new()
				pveSceneStarReward:init(sceneId, chestState, openState)
				fwin:open(pveSceneStarReward, fwin._windows)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- NPC宝箱领取
		local lpve_map_npc_box_click_terminal = {
			_name = "lpve_map_npc_box_click",
			_init = function (terminal) 
				app.load("client.landscape.duplicate.pve.LPVENpcRewardBox")
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local prb = LPVENpcRewardBox:new()
				local tmpSeatCell = {npcState = params._datas._npcState}
				if params._datas._npcState == nil then
					tmpSeatCell = nil
				end
				prb:init(params._datas._sceneId, params._datas._npcId, tmpSeatCell, params._datas._cell)
				fwin:open(prb, fwin._ui)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- NPC宝箱领取(舰娘)
		local gpve_map_npc_box_click_terminal = {
			_name = "gpve_map_npc_box_click",
			_init = function (terminal) 
				app.load("client.duplicate.pve.PVENpcRewardBox")
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local prb = PVENpcRewardBox:new()
				local tmpSeatCell = {npcState = params._datas._npcState}
				if params._datas._npcState == nil then
					tmpSeatCell = nil
				end
				prb:init(params._datas._sceneId, params._datas._npcId, tmpSeatCell, params._datas._cell)
				fwin:open(prb, fwin._ui)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- NPC宝箱领取成功
		local plot_copy_chest_npc_get_success_rewardterminal = {
            _name = "plot_copy_chest_npc_get_success",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance.isCanPlayGetAni == true then
            		ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_bukequ"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_kelingqu"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_lingdonghua"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_lingquhou"):setVisible(false)
            		instance.isCanPlayGetAni = false
            		local panel = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_lingdonghua")
            		panel:setVisible(true)
					local armature = panel:getChildByName("ArmatureNode_3")
					armature:getAnimation():playWithIndex(0, 0, 0)
            	end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(gpve_map_npc_box_click_terminal)
		state_machine.add(lpve_map_npc_box_click_terminal)
        state_machine.add(plot_copy_chest_pve_scene_star_rewardterminal)
        state_machine.add(plot_copy_chest_npc_get_success_rewardterminal)
        state_machine.init()
    end
    
    -- call func init PlotCopyChest state machine.
    init_plot_copy_chest_terminal()
end

function PlotCopyChest:onUpdateDraw()

	-- if self.chestState == 3 then
		-- return
	-- end

	self.starReward = tonumber(self.starReward)
	self.chestState = tonumber(self.chestState)
	
	local sourceName = self.chestState
	
	if self.chestState == 5 then
		sourceName = 3
	end
	
	if sourceName == 1 then
		sourceName = 3
	elseif sourceName == 3 then
		sourceName = 1
	end
	
	
	local ChestImag = nil
	local armature = nil
	if (__lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) then
		if ___is_open_PlotCopyChest ~= false then
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_bukequ"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_kelingqu"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_lingdonghua"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_lingquhou"):setVisible(false)
		end
	end
	if self.openState.state == 0 then
	
		if (self.starReward == 1 and self.chestState == 1)
			or (self.starReward == 2 and self.chestState == 2)
			or (self.starReward == 4 and self.chestState == 3)
			or (self.starReward == 3 and (self.chestState == 1 or self.chestState == 2))
			or (self.starReward == 5 and (self.chestState == 1 or self.chestState == 3))
			or (self.starReward == 6 and (self.chestState == 2 or self.chestState == 3))
			or self.starReward == 7	then
			
			ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_o_%d", sourceName))
		else
			ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_c_%d", sourceName))
		end
		
		if self.chestState == 4 then
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_bukequ")
				armature = ChestImag:getChildByName("ArmatureNode_1")
			else
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_c_%d", sourceName))
			end
		elseif self.chestState == 5 then
			if  (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
				and ___is_open_PlotCopyChest ~= false
				 then
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_bukequ")
				armature = ChestImag:getChildByName("ArmatureNode_1")
			else
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_c_%d", sourceName))
			end
		end
		
	elseif self.openState.state == 1 then
	
		if self.starReward == 0 then
			ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_r_%d", sourceName))
		elseif self.starReward == 1 then
			if self.chestState == 1 then
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_o_%d", sourceName))
			else
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_r_%d", sourceName))
			end
		elseif self.starReward == 2 then
			if self.chestState == 2 then
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_o_%d", sourceName))
			else
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_r_%d", sourceName))
			end
		elseif self.starReward == 4 then
			if self.chestState == 3 then
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_o_%d", sourceName))
			else
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_r_%d", sourceName))
			end
		elseif self.starReward == 3 then
			if self.chestState == 1 or self.chestState == 2 then
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_o_%d", sourceName))
			else
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_r_%d", sourceName))
			end
		elseif self.starReward == 5 then
			if self.chestState == 1 or self.chestState == 3 then
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_o_%d", sourceName))
			else
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_r_%d", sourceName))
			end
		elseif self.starReward == 6 then
			if self.chestState == 2 or self.chestState == 3 then
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_o_%d", sourceName))
			else
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_r_%d", sourceName))
			end
		elseif self.starReward == 7 then
			ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_o_%d", sourceName))
		end
	
	-- elseif self.openState.state == 2 then
		-- local ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_o_%d", self.chestState))
		-- ChestImag:setVisible(true)
		
		if self.chestState == 4 then
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_kelingqu")
				armature = ChestImag:getChildByName("ArmatureNode_2")
				self.isCanPlayGetAni = true
			else
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_r_%d", sourceName))
			end
		elseif self.chestState == 5 then
			if  (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
				and ___is_open_PlotCopyChest ~= false
				 then
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_kelingqu")
				armature = ChestImag:getChildByName("ArmatureNode_2")
				self.isCanPlayGetAni = true
			else
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_r_%d", sourceName))
			end
		end
		
	elseif self.openState.state == 2 then
		if self.chestState == 4 then
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				if self.isCanPlayGetAni == true then
					ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_lingdonghua")
					ccui.Helper:seekWidgetByName(self.roots[1], "Panel_lingdonghua"):setVisible(true)
					armature = ChestImag:getChildByName("ArmatureNode_3")
					draw.initArmature(armature, nil, -1, 0, 1)
					armature:getAnimation():playWithIndex(0, 0, 0)
					
					armature._invoke = function(armatureBack)
						self.isCanPlayGetAni=false
						ccui.Helper:seekWidgetByName(self.roots[1], "Panel_lingdonghua"):setVisible(false)
						self:onUpdateDraw()
					end
					return			
				else
					ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_lingquhou")
					armature = ChestImag:getChildByName("ArmatureNode_4")
				end
				
			else
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_o_%d", sourceName))
			end
		elseif self.chestState == 5 then
			-- if  __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				-- or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
			-- 	if self.isCanPlayGetAni == true then
			-- 		ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_lingdonghua")
			-- 		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_lingdonghua"):setVisible(true)
			-- 		-- armature = ChestImag:getChildByName("ArmatureNode_3")
			-- 		-- draw.initArmature(armature, nil, -1, 0, 1)
			-- 		-- armature:getAnimation():playWithIndex(0, 0, 0)
					
			-- 		-- armature._invoke = function(armatureBack)
			-- 		-- 	self.isCanPlayGetAni=false
			-- 		-- 	ccui.Helper:seekWidgetByName(self.roots[1], "Panel_lingdonghua"):setVisible(false)
			-- 		-- 	self:onUpdateDraw()
			-- 		-- end
			-- 		return			
			-- 	else
			-- 		ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_lingquhou")
			-- 		armature = ChestImag:getChildByName("ArmatureNode_4")
			-- 	end
			-- else
				ChestImag = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_o_%d", sourceName))
			-- end
		end
	end
	
	if ChestImag ~= nil then
		if self.chestState == 4 and __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_bukequ"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_kelingqu"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_lingdonghua"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_lingquhou"):setVisible(false)
			ChestImag:setVisible(true)
			if armature ~= nil then
				armature:getAnimation():playWithIndex(0, 0, -1)
			end
			if ChestImag == ccui.Helper:seekWidgetByName(self.roots[1], "Panel_lingquhou") then
				ccui.Helper:seekWidgetByName(self.roots[1], "Panel_lingquhou"):removeAllChildren(true)
			end
		elseif self.chestState == 5 and (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) 
			and ___is_open_PlotCopyChest ~= false then
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_bukequ"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_kelingqu"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_lingdonghua"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_lingquhou"):setVisible(false)
			ChestImag:setVisible(true)
			if armature ~= nil then
				armature:getAnimation():playWithIndex(0, 0, -1)
			end
		else 
			ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_o_%d", sourceName)):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_r_%d", sourceName)):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_c_%d", sourceName)):setVisible(false)
			ChestImag:setVisible(true)
		end
	end
	
	-- if self.openState.starNum ~= 0 then
		local starNum = ccui.Helper:seekWidgetByName(self.roots[1], "Label_35137")
		starNum:setString(self.openState.starNum)--self.openState.starNum
	-- end
	
	if self.chestState == 4 then
		starNum:setVisible(false)
		ccui.Helper:seekWidgetByName(self.roots[1], "ImageView_15617"):setVisible(false)
	elseif self.chestState == 5 then
		starNum:setVisible(false)
		ccui.Helper:seekWidgetByName(self.roots[1], "ImageView_15617"):setVisible(false)
	end
end

function PlotCopyChest:onInit( ... )
    local csbEquipPatchListCell = csb.createNode("duplicate/pve_reward.csb")
	local root = csbEquipPatchListCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(true)
	self:addChild(root)
	
	if missionIsOver() == false then

		if tonumber(self.chestState) == 4 then
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_15612"), nil, 
			{
				terminal_name = "lpve_map_npc_box_click", 
				terminal_state = 0, 
				touch_scale = true,
				_sceneId = self.sceneId,
				_npcId = self.npcId,
				_npcState = self.npcState,
				_cell = self,
			},nil, 0)
		elseif tonumber(self.chestState) == 5 then
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_15612"), nil, 
			{
				terminal_name = "gpve_map_npc_box_click", 
				terminal_state = 0, 
				touch_scale = true,
				_sceneId = self.sceneId,
				_npcId = self.npcId,
				_npcState = self.npcState,
				_cell = self,
			},nil, 0)
		elseif tonumber(self.chestState) == 1 then
			local Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_15612"), nil, 
			{
				terminal_name = "plot_copy_chest_pve_scene_star_reward", 
				terminal_state = 0, 
				touch_scale = true,
				_sceneId = self.sceneId,
				_openState = self.openState,
				_chestState = self.chestState
			},nil, 0)
		else
			local Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_15612"), nil, 
			{
				terminal_name = "plot_copy_chest_pve_scene_star_reward", 
				terminal_state = 0, 
				touch_scale = true,
				_sceneId = self.sceneId,
				_openState = self.openState,
				_chestState = self.chestState
			},nil, 0)
		end
	else
		if self.chestState == 4 then
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_15612"), nil, 
			{
				terminal_name = "lpve_map_npc_box_click", 
				terminal_state = 0, 
				touch_scale = true,
				_sceneId = self.sceneId,
				_npcId = self.npcId,
				_npcState = self.npcState,
				_cell = self,
			},nil, 0)
		elseif self.chestState == 5 then
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_15612"), nil, 
			{
				terminal_name = "gpve_map_npc_box_click", 
				terminal_state = 0, 
				touch_scale = true,
				_sceneId = self.sceneId,
				_npcId = self.npcId,
				_npcState = self.npcState,
				_cell = self,
			},nil, 0)
		else
			local Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_15612"), nil, 
			{
				terminal_name = "plot_copy_chest_pve_scene_star_reward", 
				terminal_state = 0, 
				touch_scale = true,
				_sceneId = self.sceneId,
				_openState = self.openState,
				_chestState = self.chestState
			},nil, 0)
		end
	end
	self:onUpdateDraw()
end

function PlotCopyChest:onEnterTransitionFinish()
	self:onInit()
end

function PlotCopyChest:onExit()
    
end

function PlotCopyChest:changeState(_state)
	self:removeAllChildren(true)
    self.openState.state = _state
    self.roots = {}
	self:onInit()
end

function PlotCopyChest:init(chestState, openState, sceneId, npcId, npcState)
	self.chestState = chestState
	self.openState	= openState
	self.sceneId = sceneId
	self.npcId = npcId
	self.npcState = npcState
	self.starReward = zstring.tonumber(_ED.star_reward_state[self.sceneId])
end

function PlotCopyChest:createCell()
	local cell = PlotCopyChest:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
