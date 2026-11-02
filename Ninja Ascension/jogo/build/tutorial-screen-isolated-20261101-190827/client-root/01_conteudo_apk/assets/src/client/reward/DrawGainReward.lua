-- ----------------------------------------------------------------------------------------------------
-- 说明：奖励绘制（上飘消失，最多只显示3个物品）
-- ----------------------------------------------------------------------------------------------------
DrawGainReward = class("DrawGainRewardClass", Window)

function DrawGainReward:ctor()
    self.super:ctor()
    app.load("client.cells.utils.resources_icon_cell")
	self.roots = {}
	
	self._rewardType = nil
	self._rewardPad = {}
	
    -- Initialize DrawGainReward page state machine.
    local function init_hero_reborn_terminal()
        -- local hero_reborn_terminal = {
            -- _name = "DrawGainReward",
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

function DrawGainReward:onEnterTransitionFinish()
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
   
	local function calculateIconType(number)
		local iconid = 3009
		if number >=1 and number<=9999 then
			iconid = 3009
		elseif number>=10000 and number<=99999 then
			iconid = 3011
		elseif number >=100000 then
			iconid = 3013
		end
		return iconid
	end
   
	for i=1, tonumber(self._reward ._reward_item_count) do
		if i > 3 then
			break
		end
		local flag = false
		local rewardList = self._reward ._reward_list[i]
		-- 物品1类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:经验 9:耐力 10:功能点 
		-- 11:上阵人数 12:体力 13:武将 14竞技场排名 15:伤害 16:比武积分 17:霸气18威名 19 日常任务积分 20功勋 21战功)
		
		--如果有钱
		if tonumber(rewardList.prop_type) == 1 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value), -1)
			self._rewardPad[i]:addChild(cell)
			cell:showName(-1,rewardList.prop_type)
			flag = true
			--> print("=======================================")
			--> print("获得银币", rewardList.item_value)
		end
		--如果有宝石
		if tonumber(rewardList.prop_type) == 2 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			--> print("rewardList.prop_type======",rewardList.prop_type)
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value), -1)
			self._rewardPad[i]:addChild(cell)
			cell:showName(-1,rewardList.prop_type)
			flag = true
			--> print("=======================================")
			--> print("获得宝石", rewardList.item_value)
		end
		
		--如果有魂玉
		if tonumber(rewardList.prop_type) == 5 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value), -1)
			self._rewardPad[i]:addChild(cell)
			flag = true
			cell:showName(-1,rewardList.prop_type)
			--> print("=======================================")
			--> print("获得将魂", rewardList.item_value)
		end		
		--道具
		if tonumber(rewardList.prop_type) == 6 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item)
			self._rewardPad[i]:addChild(cell)
			cell:showName(rewardList.prop_item,rewardList.prop_type)
			flag = true
			--> print("=======================================")
			--> print("获得道具", rewardList.prop_item)
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

function DrawGainReward:onExit()
	-- state_machine.remove("DrawGainReward")
end

function DrawGainReward:init(_reward)
	self._reward = _reward
end
