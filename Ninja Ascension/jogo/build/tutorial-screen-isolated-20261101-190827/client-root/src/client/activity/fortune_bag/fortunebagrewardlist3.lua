--[[ ----------------------------------------------------------------------------
-- 奖励配对框格页面
--]] ----------------------------------------------------------------------------
FortuneBagRewardList3 = class("FortuneBagRewardList3Class", Window)
FortuneBagRewardList3.__size = nil

-- 创建Cell实例
local fortune_bag_reward_list3_create_terminal = {
	_name = "fortune_bag_reward_list3_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if FortuneBagRewardList3 then
			local cell = FortuneBagRewardList3:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
        	cell:registerOnNoteUpdate(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fortune_bag_reward_list3_create_terminal)
state_machine.init()

-- 构造器
function FortuneBagRewardList3:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.cells.utils.resources_icon_cell")
	-- Initialize fortune bag reward list3 page state machine.
	local function init_fortune_bag_reward_list3_terminal()
		
	end
	-- call func init fortune bag reward list3 state machine.
	init_fortune_bag_reward_list3_terminal()
end

-- 对象初始化
function FortuneBagRewardList3:init(params)
	self:onInit(params)
	self:setContentSize(FortuneBagRewardList3.__size)
	return self
end

function FortuneBagRewardList3:onUpdateDraw()
	local root = self.roots[1]
	local rewardData = self._match_data
	if nil == rewardData then
		return 
	end
	local panelList = {}
	for i=1,3 do
		local panelPer = ccui.Helper:seekWidgetByName(root, "Panel_fortune_bag_icon"..i)
		panelPer:removeAllChildren(true)
		table.insert(panelList,panelPer)
	end

	local matchConditions = zstring.split(rewardData.matchCondition,"|")
	for i=1,2 do
		local propData = zstring.split(matchConditions[i],",")
		panelList[i]:addChild(self:addResourcesIconCell(propData))
	end

	local getAward = zstring.split(rewardData.matchReward,"|")
	local getPropData = zstring.split(getAward[1],",")
	panelList[3]:addChild(self:addResourcesIconCell(getPropData))

end

-- 添加道具图标
function FortuneBagRewardList3:addResourcesIconCell(propData)
	local cell = ResourcesIconCell:createCell()
	local rewardType = tonumber(propData[1])
	if 13 == rewardType then
		local extraTable = {}
		if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
			extraTable.shipStar = tonumber(propData[4])
		else
			extraTable.shipStar = 0
		end
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
	else
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true ,true, 1)
	end
	return cell
end

function FortuneBagRewardList3:onEnterTransitionFinish()
	
end

function FortuneBagRewardList3:onInit(params)
	self._match_data = params[1]
	-- 加载FortuneBagRewardList3Window界面资源.
	-- res.activity.fortune_bag.fortune_bag_reward_list_3 = res/activity/fortune_bag/fortune_bag_reward_list_3.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/fortune_bag/fortune_bag_reward_list_3.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/fortune_bag/fortune_bag_reward_list_3.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	self:clearUIInfo()
	if FortuneBagRewardList3.__size == nil then
		FortuneBagRewardList3.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function FortuneBagRewardList3:onExit()
	-- 释放FortuneBagRewardList3Window界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/fortune_bag/fortune_bag_reward_list_3.csb", root)
	-- ]]
end

function FortuneBagRewardList3:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:registerOnNoteUpdate(self)
	self:onInit()
end

function FortuneBagRewardList3:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/fortune_bag/fortune_bag_reward_list_3.csb", root)
	
	self.roots = {}
end

function FortuneBagRewardList3:clearUIInfo()
	local root = self.roots[1]
	if root == nil then
        return
    end
	if root._x ~= nil then
        root:setPositionX(root._x)
    end
    if root._y ~= nil then
        root:setPositionY(root._y)
    end
	for i=1,3 do
		local panelPer = ccui.Helper:seekWidgetByName(root, "Panel_fortune_bag_icon"..i)
		panelPer:removeAllChildren(true)
	end

end
-- ~END
-- ----------------------------------------------------------------------------
