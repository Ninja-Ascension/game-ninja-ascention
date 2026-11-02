-- ----------------------------------------------------------------------------------------------------
-- NPC宝箱领取界面
-------------------------------------------------------------------------------------------------------
PVENpcRewardBox = class("PVENpcRewardBoxClass", Window)

function PVENpcRewardBox:ctor()
    self.super:ctor()
    self.roots = {}
	
    self.sceneId = 0
    self.npcId = 0
	self.boxIndex = 0		--宝箱的下标
	
	--更新状态所用的pageview_seat_cell实例
	self.tmpSeatCell = nil
	
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.duplicate.pve.PVERewardPreviewPanel")
	app.load("client.cells.utils.resources_icon_cell")

    -- Initialize PVENpcRewardBox page state machine.
    local function init_pve_npc_reward_box_terminal()	
		-- 关闭场景星级奖励窗口
		local pve_npc_reward_box_close_window_terminal = {
            _name = "pve_npc_reward_box_close_window",
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

		--领取场景星级奖励
		local pve_npc_reward_box_draw_reward_terminal = {
            _name = "pve_npc_reward_box_draw_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				local sceneId = params._datas._sceneId
				
				local function responseDrawStarRewardCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							-- 根据NPC宝箱的状态，来启动教学事件
							local drawState = _ED.scene_draw_chest_npcs[tostring(response.node.npcId)]
							local sceneParam = "nc"..drawState
							if missionIsOver() == false or executeMissionExt(mission_mould_tuition, touch_off_mission_touch_ui, ""..instance.npcId, nil, true, sceneParam, true) == false then
				    			
							end

							--> print("领取成功！！！！！！！！！！！")
							---[[
							local boxId = self:checkBoxIDForNpcID(response.node.npcId)
							local previewWnd = PVERewardPreviewPanel:new()
							previewWnd:init(boxId)
							fwin:open(previewWnd, fwin._windows)
							
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
								state_machine.excute("duplicate_pve_secondary_scene_npc_box_update_panel", 0, {targetCell = params._datas._targetCell})
							else
								state_machine.excute("pve_bottom_update_box_state", 0, "event pve_bottom_update_box_state.")
							end
							
							fwin:close(response.node)
							--]]
						end
					end
				end
				
				--> print("领取奖励的索引", rewardIndex)
				protocol_command.draw_scene_npc_rewad.param_list = ""..sceneId .."\r\n" .. (instance.boxIndex - 1)
				NetworkManager:register(protocol_command.draw_scene_npc_rewad.code, nil, nil, nil, instance, responseDrawStarRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(pve_npc_reward_box_close_window_terminal)
        state_machine.add(pve_npc_reward_box_draw_reward_terminal)
        state_machine.init()
    end
    
    -- call func init PVENpcRewardBox state machine.
    init_pve_npc_reward_box_terminal()
end

function PVENpcRewardBox:onUpdateDraw()
	-- 显示当前关卡的奖励数据
	--绘制奖励
	local root = self.roots[1]
	local rewardItem = {
		"Panel_1",
		"Panel_2",
		"Panel_3",
		"Panel_4"
	}
	
	--判断NPC宝箱是否显示
	local boxIndex
	local boxID
	boxID, boxIndex = self:checkBoxIDForNpcID(self.npcId)
	self.boxIndex = boxIndex
	
	--显示奖励
	local rewardTotal = 1
	local rewardName = dms.string(dms["scene_reward"], boxID, scene_reward.reward_name)
	local rewardMoney = dms.int(dms["scene_reward"], boxID, scene_reward.reward_silver)
	local rewardGold = dms.int(dms["scene_reward"], boxID, scene_reward.reward_gold)
	local rewardHonor = dms.int(dms["scene_reward"], boxID, scene_reward.reward_honor)
	local rewardSoul = dms.int(dms["scene_reward"], boxID, scene_reward.reward_soul)
	local rewardJade = dms.int(dms["scene_reward"], boxID, scene_reward.reward_jade)
	local rewardItemListStr = dms.string(dms["scene_reward"], boxID, scene_reward.reward_prop)
	local rewardEquListStr = dms.string(dms["scene_reward"], boxID, scene_reward.reward_equipment)
	local rewardShipListStr = dms.string(dms["scene_reward"], boxID, scene_reward.reward_ship)
	
	--> print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm", rewardItemListStr)
	
	--显示标题
	self.cacheTipsText:setString(rewardName)
	-- 4001	元宝	
	-- 4002	银两	
	-- 4003	军团贡献	
	-- 4004	声望	
	-- 4005	战功	
	-- 4006	威名	
	-- 4007	神魂	
	-- 4008	将魂	
	
	if rewardMoney > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(1, rewardMoney, -1)
		local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		mRewardItem:addChild(reward)
		reward:showName(-1,1)
		rewardTotal = rewardTotal + 1
	end
	
	--> print("gggggggggggggggggggggggggggggggggggggggggg", rewardGold)
	if rewardGold > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(2, rewardGold, -1)
		local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		mRewardItem:addChild(reward)
		reward:showName(-1,2)
		rewardTotal = rewardTotal + 1
	end
	
	if rewardHonor > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(3, rewardHonor, -1)
		local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		mRewardItem:addChild(reward)
		reward:showName(-1,3)
		rewardTotal = rewardTotal + 1
	end
	
	if rewardSoul > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(4, rewardSoul, -1)
		local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		mRewardItem:addChild(reward)
		reward:showName(-1,4)
		rewardTotal = rewardTotal + 1
	end
	
	-- if rewardTotal > 4 then
		-- return
	-- end
	
	if rewardJade > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(5, rewardJade, -1)
		local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		mRewardItem:addChild(reward)
		reward:showName(-1,5)
		rewardTotal = rewardTotal + 1
	end
	
	-- if rewardTotal > 4 then
		-- return
	-- end
	
	--> print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh", rewardItemListStr)
	
	--绘制道具
	if rewardItemListStr ~= nil and rewardItemListStr ~= 0 and rewardItemListStr ~= "" then
	------------------------------------------------------------
		local rewardProp = zstring.split(rewardItemListStr, "|")
		--> print("ggggggggggggggggggggggggggggggggggggggg", table.getn(rewardProp))
		if table.getn(rewardProp) > 0 then
			for i,v in pairs(rewardProp) do
				local rewardPropInfo = zstring.split(v, ",")
				--> print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz", #rewardPropInfo)
				-- if rewardPropInfo == "" or rewardPropInfo == nil then break end
				if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
					-- app.load("client.cells.prop.prop_icon_cell")
					local reward = PropIconCell:createCell()
					local reawrdID = tonumber(rewardPropInfo[2])
					local rewardNum = tonumber(rewardPropInfo[1])
					reward:init(23, {user_prop_template = reawrdID, prop_number = rewardNum})
					local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
					mRewardItem:addChild(reward)
					rewardTotal = rewardTotal + 1
					
					-- if rewardTotal > 4 then
						-- break
					-- end
				end
			end
		end
	--------------------------------------------------------
	end
	
	--绘制装备
	if rewardEquListStr ~= nil and rewardEquListStr ~= 0 and rewardEquListStr ~= "" then
	------------------------------------------------------------
		local rewardProp = zstring.split(rewardEquListStr, "|")
		if table.getn(rewardProp) > 0 then
			for i,v in pairs(rewardProp) do
				local rewardPropInfo = zstring.split(v, ",")
				if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
					-- app.load("client.cells.prop.prop_icon_cell")
					-- local reward = ArenaRoleIconCell:createCell()
					local reawrdID = tonumber(rewardPropInfo[2])
					local rewardNum = tonumber(rewardPropInfo[1])
					
					local tmpTable = {
						user_equiment_template = reawrdID,
						mould_id = reawrdID,
						user_equiment_grade = 1
					}
					
					local eic = EquipIconCell:createCell()
					eic:init(10, tmpTable, reawrdID)
					-- self.equipIconPanelArr[i]:addChild(eic)
					local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
					mRewardItem:addChild(eic)
					rewardTotal = rewardTotal + 1
					
					-- if rewardTotal > 4 then
						-- break
					-- end
				end
			end
		end
	--------------------------------------------------------
	end
	
	--奖励武将 rewardShipListStr
	if rewardShipListStr ~= nil and rewardShipListStr ~= 0 and rewardShipListStr ~= "" then
	------------------------------------------------------------
		local rewardProp = zstring.split(rewardShipListStr, "|")
		if table.getn(rewardProp) > 0 then
			for i,v in pairs(rewardProp) do
				local rewardPropInfo = zstring.split(v, ",")
				if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
					-- app.load("client.cells.prop.prop_icon_cell")
					-- 等级,数量,id,概率
					local reward = ShipHeadCell:createCell()
					local reawrdID = tonumber(rewardPropInfo[3])
					local rewardLv = tonumber(rewardPropInfo[1])
					local rewardNums = tonumber(rewardPropInfo[2])
					reward:init(nil,13, reawrdID,rewardNums,true)
					local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
					mRewardItem:addChild(reward)
					rewardTotal = rewardTotal + 1
					
					-- if rewardTotal > 4 then
						-- break
					-- end
				end
			end
		end
	--------------------------------------------------------
	end
	--奖励绘制完毕
	-----------------------------------------------------------
	
	--判断按钮状态
	local drawState = _ED.scene_draw_chest_npcs[tostring(self.npcId)]
	if drawState == 1 then--已经领取
		ccui.Helper:seekWidgetByName(root, "Button_receive"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Button_receive_ylq"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "ImageView_11991"):setVisible(false)--领取
		ccui.Helper:seekWidgetByName(root, "ImageView_11990"):setVisible(true)--已领取
		
		self.cacheTipsText:setString(_string_piece_info[181])
		
	else--没有领取
		if self.tmpSeatCell ~= nil and tonumber(self.tmpSeatCell.npcState) ~= 1 and tonumber(self.tmpSeatCell.npcState) ~= 2 then
			ccui.Helper:seekWidgetByName(root, "Button_receive"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Button_receive_ylq"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "ImageView_11991"):setVisible(true)--领取
			ccui.Helper:seekWidgetByName(root, "ImageView_11990"):setVisible(false)--已领取
		else
			ccui.Helper:seekWidgetByName(root, "Button_receive"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Button_receive_ylq"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "ImageView_11991"):setVisible(true)--领取
			ccui.Helper:seekWidgetByName(root, "ImageView_11990"):setVisible(false)--已领取
		end
	end
end

--检测table中是否包含传入的NPCid
function PVENpcRewardBox:checkBoxIDForNpcID(npcID)
	
	local npcIdListStr = dms.string(dms["pve_scene"], self.sceneId, pve_scene.design_npc)
	local npcIdTable = zstring.split(npcIdListStr, ",")
	local npcRewardListStr = dms.string(dms["pve_scene"], self.sceneId, pve_scene.design_reward)
	local npcRewardTable = zstring.split(npcRewardListStr, ",")
	
	--> print("jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj", #npcRewardTable)
	
	for i, v in pairs(npcIdTable) do
		if tonumber(v) == npcID then
			return npcRewardTable[i], i, npcRewardTable
		end
	end
	return 0, 0, nil
end

-- function PVENpcRewardBox:checkAndUpdateStar(nowStar)
	-- if nowStar >= tonumber(self.openState.starNum) then
		-- ccui.Helper:seekWidgetByName(self.roots[1], "Button_receive"):setVisible(true)
	-- end
	-- self.cacheTipsText:setString(string.format(_string_piece_info[180], self.openState.starNum))
-- end

function PVENpcRewardBox:init(sceneId, npcId, aSeatIns, targetCell)
	
	self.sceneId = tonumber(sceneId)
	self.npcId = tonumber(npcId)
	self.tmpSeatCell = aSeatIns
	self.targetCell = targetCell
	--> print("tttttttttttttttttttttttttttttttttttttttttttttttttt", self.starReward)
	--> print("场景id和奖励索引", self.starReward)
	--> print("场景id", self.sceneId)
end

function PVENpcRewardBox:onEnterTransitionFinish()
	local csbPveDuplicate = csb.createNode("duplicate/copy_the_award.csb")
    local root = csbPveDuplicate:getChildByName("root")
	table.insert(self.roots, root)

	-- local action = csb.createTimeline("duplicate/copy_the_award.csb")
    -- csbPveDuplicate:runAction(action)
    -- if action:getDuration() > 0 then
    	-- csbPveDuplicate:gotoFrameAndPlay(0, action:getDuration(), false)
	-- end

    self:addChild(csbPveDuplicate)
	
	--提示文字
	self.cacheTipsText = ccui.Helper:seekWidgetByName(root, "Label_12223")
	
	--临时处理的
	if ccui.Helper:seekWidgetByName(root, "ImageView_13") ~= nil then
		ccui.Helper:seekWidgetByName(root, "ImageView_13"):setVisible(true)
    end
	
	--添加关闭按钮的事件
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
	{
		terminal_name = "pve_npc_reward_box_close_window", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)

	--添加领取奖励按钮事件
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_receive"), nil, 
	{
		terminal_name = "pve_npc_reward_box_draw_reward", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_sceneId  = self.sceneId,
		_npcid  = self.npcId,
		_targetCell = self.targetCell
	}, 
	nil, 0)
	
    self:onUpdateDraw()
end

function PVENpcRewardBox:onExit()
    state_machine.remove("pve_npc_reward_box_close_window")
    state_machine.remove("pve_npc_reward_box_draw_reward")
end