--[[ ----------------------------------------------------------------------------
-- 奖励道具框格页面
--]] ----------------------------------------------------------------------------
FortuneBagRewardList2 = class("FortuneBagRewardList2Class", Window)
FortuneBagRewardList2.__size = nil

-- 创建Cell实例
local fortune_bag_reward_list2_create_terminal = {
	_name = "fortune_bag_reward_list2_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if FortuneBagRewardList2 then
			local cell = FortuneBagRewardList2:new()
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

state_machine.add(fortune_bag_reward_list2_create_terminal)
state_machine.init()

-- 构造器
function FortuneBagRewardList2:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._group = nil
	self._lines = nil
	self._reward_data = nil
	-- load lua files.

	-- Initialize fortune bag reward list2 page state machine.
	local function init_fortune_bag_reward_list2_terminal()
		
	end
	-- call func init fortune bag reward list2 state machine.
	init_fortune_bag_reward_list2_terminal()
end

-- 对象初始化
function FortuneBagRewardList2:init(params)
	self:onInit(params)
	return self
end

function FortuneBagRewardList2:onUpdateDraw()
	local root = self.roots[1]
	local Panel_fortune_bag_icon = ccui.Helper:seekWidgetByName(root, "Panel_fortune_bag_icon")
	Panel_fortune_bag_icon:removeAllChildren(true)
	Panel_fortune_bag_icon:setVisible(false)
	if self._group > 0 and self._lines == 1 then
		if self._group == 1 then
			-- A库组图标
			local sp = cc.Sprite:create("images/ui/text/fortune_bag/fortune_bag_icon2.png")
			Panel_fortune_bag_icon:addChild(sp)
		else
			-- B库组图标
			local sp = cc.Sprite:create("images/ui/text/fortune_bag/fortune_bag_icon1.png")
			Panel_fortune_bag_icon:addChild(sp)
		end
		Panel_fortune_bag_icon:setVisible(true)
	end

	local ListView_reward_reward_2 = ccui.Helper:seekWidgetByName(root, "ListView_reward_reward_2")
	ListView_reward_reward_2:removeAllChildren(true)

	local nums = #self._reward_data - (self._lines * 5)
	if nums > 0 then
		for i = (self._lines - 1) * 5 + 1,self._lines * 5 do
			local cell = self:addResourcesIconCell(zstring.split(self._reward_data[i],","))
			ListView_reward_reward_2:addChild(cell)
		end
	else
		for i = (self._lines - 1) * 5 + 1,#self._reward_data do
			local cell = self:addResourcesIconCell(zstring.split(self._reward_data[i],","))
			ListView_reward_reward_2:addChild(cell)
		end
	end
	ListView_reward_reward_2:setDirection(ccui.ListViewDirection.none)
	ListView_reward_reward_2:jumpToTop()
	ListView_reward_reward_2:requestRefreshView()
end

-- 添加道具图标
function FortuneBagRewardList2:addResourcesIconCell(propData)
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

function FortuneBagRewardList2:onEnterTransitionFinish()
	-- 加载FortuneBagRewardList2Window界面资源.
	-- res.activity.fortune_bag.fortune_bag_reward_list_2 = res/activity/fortune_bag/fortune_bag_reward_list_2.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/fortune_bag/fortune_bag_reward_list_2.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/fortune_bag/fortune_bag_reward_list_2.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	self:clearUIInfo()
	if FortuneBagRewardList2.__size == nil then
		FortuneBagRewardList2.__size = root:getContentSize()
	end
	self:setContentSize(FortuneBagRewardList2.__size)

	self:onUpdateDraw()
end

function FortuneBagRewardList2:onInit(params)
	self._group = params[1]
	self._lines = params[2]
	self._reward_data = params[3]
end

function FortuneBagRewardList2:onExit()
	-- 释放FortuneBagRewardList2Window界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/fortune_bag/fortune_bag_reward_list_2.csb", root)
	-- ]]
end

function FortuneBagRewardList2:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:registerOnNoteUpdate(self)
	self:onInit()
end

function FortuneBagRewardList2:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/fortune_bag/fortune_bag_reward_list_2.csb", root)
	
	self.roots = {}
end


function FortuneBagRewardList2:clearUIInfo()
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
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_fortune_bag_icon")
	Panel_prop:removeAllChildren()
	local ListView_reward_reward_2  = ccui.Helper:seekWidgetByName(root, "ListView_reward_reward_2")
	ListView_reward_reward_2:removeAllChildren()

end

-- ~END
-- ----------------------------------------------------------------------------
