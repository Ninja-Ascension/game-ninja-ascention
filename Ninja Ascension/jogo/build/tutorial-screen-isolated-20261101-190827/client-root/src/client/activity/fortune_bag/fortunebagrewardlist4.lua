--[[ ----------------------------------------------------------------------------
-- 奖励奖励名称页面
--]] ----------------------------------------------------------------------------
FortuneBagRewardList4 = class("FortuneBagRewardList4Class", Window)
FortuneBagRewardList4.__size = nil

-- 创建Cell实例
local fortune_bag_reward_list4_create_terminal = {
	_name = "fortune_bag_reward_list4_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if FortuneBagRewardList4 then
			local cell = FortuneBagRewardList4:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fortune_bag_reward_list4_create_terminal)
state_machine.init()

-- 构造器
function FortuneBagRewardList4:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fortune bag reward list4 page state machine.
	local function init_fortune_bag_reward_list4_terminal()
		
	end
	-- call func init fortune bag reward list4 state machine.
	init_fortune_bag_reward_list4_terminal()
end

-- 对象初始化
function FortuneBagRewardList4:init(params)
	self:onInit(params)
	self:setContentSize(FortuneBagRewardList4.__size)
	return self
end

function FortuneBagRewardList4:onUpdateDraw()
	local root = self.roots[1]
	local Text_fortune_bag_reward_name = ccui.Helper:seekWidgetByName(root, "Text_fortune_bag_reward_name")
	Text_fortune_bag_reward_name:setString(self._text)
	
end

function FortuneBagRewardList4:onEnterTransitionFinish()
	
end

function FortuneBagRewardList4:onInit(params)
	self._text = params[1]
	-- 加载FortuneBagRewardList4Window界面资源.
	-- res.activity.fortune_bag.fortune_bag_reward_list_4 = res/activity/fortune_bag/fortune_bag_reward_list_4.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/fortune_bag/fortune_bag_reward_list_4.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/fortune_bag/fortune_bag_reward_list_4.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if FortuneBagRewardList4.__size == nil then
		FortuneBagRewardList4.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function FortuneBagRewardList4:onExit()
	-- 释放FortuneBagRewardList4Window界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/fortune_bag/fortune_bag_reward_list_4.csb", root)
	-- ]]
end

function FortuneBagRewardList4:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function FortuneBagRewardList4:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/fortune_bag/fortune_bag_reward_list_4.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
