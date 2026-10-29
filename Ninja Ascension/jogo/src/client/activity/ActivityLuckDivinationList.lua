--[[ ----------------------------------------------------------------------------
-- 占卜跑马灯
--]] ----------------------------------------------------------------------------
ActivityLuckDivinationList = class("ActivityLuckDivinationListClass", Window)
ActivityLuckDivinationList.__size = nil

-- 创建Cell实例
local activity_luck_divination_list_create_terminal = {
	_name = "activity_luck_divination_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if ActivityLuckDivinationList then
			local cell = ActivityLuckDivinationList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(activity_luck_divination_list_create_terminal)
state_machine.init()

-- 构造器
function ActivityLuckDivinationList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize sm luck draw record list page state machine.
	local function init_activity_luck_divination_list_terminal()
		
	end
	-- call func init sm luck draw record list state machine.
	init_activity_luck_divination_list_terminal()
end

-- 对象初始化
function ActivityLuckDivinationList:init(params)
	self.recordData = params
	if self.recordData.rank < 4 then
		self:onInit(params)
	end
	self:setContentSize(ActivityLuckDivinationList.__size)
	return self
end

function ActivityLuckDivinationList:onUpdateDraw()
	local root = self.roots[1]
	-- 玩家名称
	self.Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")

	-- 获得的道具图标
	self.Text_zs_n = ccui.Helper:seekWidgetByName(root, "Text_zs_n")

	self.Text_player_name:setString(self.recordData.record.name)


	local lucknum = zstring.split(_ED.active_activity[161].need_recharge_count,"@")
	lucknum = tostring(lucknum[2])
	local xiangdeng = 0
	local drawNum = tostring(self.recordData.record.divineNum)
	for i=1, 5 do
		local char1 = string.sub(drawNum, i, i)
		local char2 = string.sub(lucknum, i, i)
		if char1 == char2 then
			xiangdeng = xiangdeng+1
		end
	end
	self.Text_zs_n:setString(xiangdeng)

end

function ActivityLuckDivinationList:clearUIInfo( ... )
	-- self.Text_zs_n:setString('')
	-- self.Text_player_name:setString('')
end

function ActivityLuckDivinationList:onEnterTransitionFinish()
	
end

function ActivityLuckDivinationList:onInit(params)
	-- 加载ActivityLuckDivinationListWindow界面资源.
	-- res.activity.wonderful.activity_luck_divination_list = res/activity/wonderful/activity_luck_divination_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/wonderful/activity_luck_divination_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("Lucky/activity_luck_divination_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if ActivityLuckDivinationList.__size == nil then
		ActivityLuckDivinationList.__size = root:getContentSize()
	end
    self:clearUIInfo()
	self:onUpdateDraw()
end

function ActivityLuckDivinationList:onExit()
	-- 释放ActivityLuckDivinationListWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/wonderful/activity_luck_divination_list.csb", root)
	-- ]]
end

function ActivityLuckDivinationList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ActivityLuckDivinationList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("activity/wonderful/activity_luck_divination_list.csb", root)
	self:stopAllActions()
	root:removeFromParent(false)

	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
