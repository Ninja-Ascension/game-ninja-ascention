--[[ ----------------------------------------------------------------------------
-- 主界面排行奖励列表项
--]] ----------------------------------------------------------------------------
LimPoolRewardIconList = class("LimPoolRewardIconListClass", Window)
LimPoolRewardIconList.__size = nil

-- 创建Cell实例
local lim_pool_reward_icon_list_create_terminal = {
	_name = "lim_pool_reward_icon_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if LimPoolRewardIconList then
			local cell = LimPoolRewardIconList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(lim_pool_reward_icon_list_create_terminal)
state_machine.init()

-- 构造器
function LimPoolRewardIconList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._info = nil

	-- load lua files.

	-- Initialize lim pool ranking list main page state machine.
	local function init_lim_pool_reward_icon_list_terminal()
		
	end
	-- call func init lim pool ranking list main state machine.
	init_lim_pool_reward_icon_list_terminal()
end

-- 对象初始化
function LimPoolRewardIconList:init(params)
	self._info = params

	self:onInit(params)
	self:setContentSize(LimPoolRewardIconList.__size)
	return self
end

function LimPoolRewardIconList:updateUI()
	local info = self._info

	self.Text_num:setString("*" .. info[3])

	local Panel_reward_icon = self.Panel_reward_icon
	Panel_reward_icon:removeAllChildren(true)

	local cell = self:addResourcesIconCell(info)
	Panel_reward_icon:addChild(cell)
end

function LimPoolRewardIconList:addResourcesIconCell(propData)
	local cell = ResourcesIconCell:createCell()
	local rewardType = tonumber(propData[1])
	if 13 == rewardType then
		local extraTable = {}
		if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
			extraTable.shipStar = tonumber(propData[4])
		else
			extraTable.shipStar = 0
		end
		cell:init(rewardType, 0, tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
	else
		cell:init(rewardType, 0, tonumber(propData[2]), nil, nil, true ,true, 1)
	end
	return cell
end

function LimPoolRewardIconList:onUpdateDraw()
	local root = self.roots[1]

	-- 道具图标
	self.Panel_reward_icon = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon")

	-- 数量
	self.Text_num = ccui.Helper:seekWidgetByName(root, "Text_num")

	self:updateUI()
end

function LimPoolRewardIconList:onEnterTransitionFinish()
	
end

function LimPoolRewardIconList:onInit(params)
	-- 加载LimPoolRewardIconListWindow界面资源.
	-- res.activity.lim_pool.lim_pool_reward_list_0 = res/activity/lim_pool/lim_pool_reward_list_0.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/lim_pool/lim_pool_reward_list_0.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/lim_pool/lim_pool_reward_list_0.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if LimPoolRewardIconList.__size == nil then
		LimPoolRewardIconList.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function LimPoolRewardIconList:onExit()
	-- 释放LimPoolRewardIconListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/lim_pool/lim_pool_reward_list_0.csb", root)
	-- ]]
end

function LimPoolRewardIconList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function LimPoolRewardIconList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/lim_pool/lim_pool_reward_list_0.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
