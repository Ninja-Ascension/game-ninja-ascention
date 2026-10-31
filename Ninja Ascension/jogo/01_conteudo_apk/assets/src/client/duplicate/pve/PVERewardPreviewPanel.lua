-- ----------------------------------------------------------------------------------------------------
-- 说明：奖励绘制（上飘消失，最多只显示4个物品）
-- ----------------------------------------------------------------------------------------------------
PVERewardPreviewPanel = class("PVERewardPreviewPanelClass", Window)

function PVERewardPreviewPanel:ctor()
    self.super:ctor()
    
	self.roots = {}
	
	self._rewardId = nil
	self._rewardPad = {}
	
	app.load("client.cells.prop.prop_icon_cell")
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		app.load("client.cells.ship.ship_head_cell")
	end
    -- Initialize PVERewardPreviewPanel page state machine.
    local function init_hero_reborn_terminal()
        -- local hero_reborn_terminal = {
            -- _name = "PVERewardPreviewPanel",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params) 
				
            -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }

        -- state_machine.add(hero_reborn_terminal)
        -- state_machine.init()
    end
    
    init_hero_reborn_terminal()
end

function PVERewardPreviewPanel:onEnterTransitionFinish()
	local csbfenjiefanhuan = csb.createNode("refinery/refinery_fenjiefanhuan_1.csb")
	self:addChild(csbfenjiefanhuan)
	local root = csbfenjiefanhuan:getChildByName("root")
	table.insert(self.roots, root)
	
	--获取动画
	local action = csb.createTimeline("refinery/refinery_fenjiefanhuan_1.csb")
    csbfenjiefanhuan:runAction(action)
    action:gotoFrameAndPlay(0, action:getDuration(), false)
	
	--添加监听事件
	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "exit" then
            fwin:close(self)
        end
    end)
   
	for i = 1, 4 do
		self._rewardPad[i] = ccui.Helper:seekWidgetByName(root, string.format("Panel_huode_%d", i))
	end
	
	local rewardListView = nil
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		rewardListView=ccui.Helper:seekWidgetByName(root, "ListView_136")
	end
	rewardListView:removeAllItems()
	
	--绘制奖励
	local rewardTotal = 1
	local rewardID = self._rewardId
	local rewardMoney = dms.int(dms["scene_reward"], rewardID, scene_reward.reward_silver)
	local rewardGold = dms.int(dms["scene_reward"], rewardID, scene_reward.reward_gold)
	local rewardHonor = dms.int(dms["scene_reward"], rewardID, scene_reward.reward_honor)
	local rewardSoul = dms.int(dms["scene_reward"], rewardID, scene_reward.reward_soul)
	local rewardJade = dms.int(dms["scene_reward"], rewardID, scene_reward.reward_jade)
	local rewardItemListStr = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_prop)
	local rewardEquListStr = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_equipment)
	local rewardShipListStr = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_ship)
	
	if rewardMoney > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(1, rewardMoney, -1)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			rewardListView:addChild(reward)
		else
			self._rewardPad[rewardTotal]:addChild(reward)
		end
		reward:showName(-1,1)
		rewardTotal = rewardTotal + 1
	end
	
	--> print("gggggggggggggggggggggggggggggggggggggggggg", rewardGold)
	if rewardGold > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(2, rewardGold, -1)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			rewardListView:addChild(reward)
		else
			self._rewardPad[rewardTotal]:addChild(reward)
		end
		reward:showName(-1,2)
		rewardTotal = rewardTotal + 1
	end
	
	if rewardHonor > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(3, rewardHonor, -1)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			rewardListView:addChild(reward)
		else
			self._rewardPad[rewardTotal]:addChild(reward)
		end
		reward:showName(-1,3)
		rewardTotal = rewardTotal + 1
	end
	
	if rewardSoul > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(4, rewardSoul, -1)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			rewardListView:addChild(reward)
		else
			self._rewardPad[rewardTotal]:addChild(reward)
		end
		reward:showName(-1,4)
		rewardTotal = rewardTotal + 1
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		
	else
		if rewardTotal > 4 then
			return
		end
	end
	if rewardJade > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(5, rewardJade, -1)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			rewardListView:addChild(reward)
		else
			self._rewardPad[rewardTotal]:addChild(reward)
		end
		reward:showName(-1,5)
		rewardTotal = rewardTotal + 1
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		
	else
		if rewardTotal > 4 then
			return
		end
	end
	
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
					reward:init(5, {user_prop_template = reawrdID, prop_number = rewardNum})
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						rewardListView:addChild(reward)
					else
						self._rewardPad[rewardTotal]:addChild(reward)
					end
					rewardTotal = rewardTotal + 1
					
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		
					else
						if rewardTotal > 4 then
							return
						end
					end
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
					eic:init(9, tmpTable, reawrdID)
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						rewardListView:addChild(eic)
					else
						self._rewardPad[rewardTotal]:addChild(eic)
					end
					rewardTotal = rewardTotal + 1
					
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		
					else
						if rewardTotal > 4 then
							return
						end
					end
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
					-- local reward = ArenaRoleIconCell:createCell()
					-- local reawrdID = tonumber(rewardPropInfo[3])
					-- local rewardLv = tonumber(rewardPropInfo[1])
					-- local rewardNums = tonumber(rewardPropInfo[2])
					-- reward:init(reawrdID, 2)
					
					local reward = ShipHeadCell:createCell()
					local reawrdID = tonumber(rewardPropInfo[3])
					local rewardLv = tonumber(rewardPropInfo[1])
					local rewardNums = tonumber(rewardPropInfo[2])
					reward:init(nil,13, reawrdID,rewardNums,true)
					
					
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						rewardListView:addChild(reward)
					else
						self._rewardPad[rewardTotal]:addChild(reward)
					end
					rewardTotal = rewardTotal + 1
					
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		
					else
						if rewardTotal > 4 then
							return
						end
					end
				end
			end
		end
	--------------------------------------------------------
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local tpx=120--每个奖励框大小
		local x= rewardListView:getContentSize().width
		local _tables=rewardListView:getItems()
		for i, v in pairs(_tables) do
			tpx=v.roots[1]:getContentSize().width
			v.roots[1]:setPositionX(v.roots[1]:getPositionX()+(x-tpx*(rewardTotal-1))/2)
		end
	end
	-- for i, v in pairs(self._rewardTable) do
		-- local rewardPropInfo = zstring.split(v, ",")
		-- local tmpList = {}
		-- if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
			-- tmpList.item_value = tonumber(rewardPropInfo[1])
			-- tmpList.prop_item = tonumber(rewardPropInfo[2])
			-- tmpList.prop_type = dms.int(dms["prop_mould"], tonumber(tmpList.prop_item), prop_mould.props_type)
			-- -- table.insert(rewardTable, tmpList)
			-- local reward = PropIconCell:createCell()
			-- reward:init(5, {user_prop_template = tmpList.prop_item, prop_number = tmpList.item_value})
			-- self._rewardPad[i]:addChild(reward)
		-- end
	-- end
end

function PVERewardPreviewPanel:onExit()
	-- state_machine.remove("PVERewardPreviewPanel")
end

function PVERewardPreviewPanel:init(aRrewardId)
	self._rewardId = tonumber(aRrewardId)
end
