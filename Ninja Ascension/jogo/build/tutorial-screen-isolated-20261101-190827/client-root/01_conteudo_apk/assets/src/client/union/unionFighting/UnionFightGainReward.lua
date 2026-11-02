UnionFightGainReward = class("UnionFightGainRewardClass", Window)

function UnionFightGainReward:ctor()
    self.super:ctor()
    app.load("client.cells.utils.resources_icon_cell")
	self.roots = {}
	self._rewardPad = {}
end

function UnionFightGainReward:onEnterTransitionFinish()
	local csbfenjiefanhuan = csb.createNode("refinery/refinery_fenjiefanhuan_1.csb")
	self:addChild(csbfenjiefanhuan)
	local root = csbfenjiefanhuan:getChildByName("root")
	table.insert(self.roots, root)
	local action = csb.createTimeline("refinery/refinery_fenjiefanhuan_1.csb")
    csbfenjiefanhuan:runAction(action)
    action:gotoFrameAndPlay(0, action:getDuration(), false)
	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "exit" then
            fwin:close(self)
        end
    end)

	for i=1, 3 do
		self._rewardPad[i] = ccui.Helper:seekWidgetByName(root, string.format("Panel_huode_%d", i))
		self._rewardPad[i]:removeAllChildren(true)
	end

	for i=1, tonumber(self._reward._reward_item_count) do
		if i > 3 then
			break
		end
		local flag = false
		local rewardList = self._reward._reward_list[i]
		-- 物品1类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:经验 9:耐力 10:功能点 
		-- 11:上阵人数 12:体力 13:武将 14竞技场排名 15:伤害 16:比武积分 17:霸气18威名 19 日常任务积分 20功勋 21战功)
		
		--如果有钱
		if tonumber(rewardList.prop_type) == 1 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value), -1)
			self._rewardPad[i]:addChild(cell)
			cell:showName(-1,rewardList.prop_type)
			flag = true
		end
		--如果有宝石
		if tonumber(rewardList.prop_type) == 2 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value), -1)
			self._rewardPad[i]:addChild(cell)
			cell:showName(-1,rewardList.prop_type)
			flag = true
		end
		--如果有魂玉
		if tonumber(rewardList.prop_type) == 5 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value), -1)
			self._rewardPad[i]:addChild(cell)
			flag = true
			cell:showName(-1,rewardList.prop_type)
		end		
		--道具
		if tonumber(rewardList.prop_type) == 6 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item)
			self._rewardPad[i]:addChild(cell)
			cell:showName(rewardList.prop_item,rewardList.prop_type)
			flag = true
		end	
		--装备
		if tonumber(rewardList.prop_type) == 7 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item)
			self._rewardPad[i]:addChild(cell)
			cell:showName(rewardList.prop_item,rewardList.prop_type)
			flag = true
		end	
		--武将
		if tonumber(rewardList.prop_type) == 13 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item)
			self._rewardPad[i]:addChild(cell)
			cell:showName(rewardList.prop_item,rewardList.prop_type)
			flag = true
		end	
		--威名
		if tonumber(rewardList.prop_type) == 18 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item, -1)
			self._rewardPad[i]:addChild(cell)
			cell:showName(-1,rewardList.prop_type)
			flag = true
		end	
	end	
end

function UnionFightGainReward:onExit()
end

function UnionFightGainReward:init(rewards)
	if rewards ~= nil then
		self._reward = rewards
	else
		self._reward = _ED.union_fight_reward_info
		_ED.union_fight_reward_info = nil
		getSceneReward(14)
	end
	return self
end
