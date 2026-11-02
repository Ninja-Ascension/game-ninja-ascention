--[[ ----------------------------------------------------------------------------
-- 获奖记录界面列表控件
--]] ----------------------------------------------------------------------------
SmLuckDrawRecordList = class("SmLuckDrawRecordListClass", Window)
SmLuckDrawRecordList.__size = nil

-- 创建Cell实例
local sm_luck_draw_record_list_create_terminal = {
	_name = "sm_luck_draw_record_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if SmLuckDrawRecordList then
			local cell = SmLuckDrawRecordList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_luck_draw_record_list_create_terminal)
state_machine.init()

-- 构造器
function SmLuckDrawRecordList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize sm luck draw record list page state machine.
	local function init_sm_luck_draw_record_list_terminal()
		
	end
	-- call func init sm luck draw record list state machine.
	init_sm_luck_draw_record_list_terminal()
end

-- 对象初始化
function SmLuckDrawRecordList:init(params)
	self.recordData = params
	if self.recordData.rank < 9 then
		self:onInit(params)
	end
	self:setContentSize(SmLuckDrawRecordList.__size)
	return self
end

function SmLuckDrawRecordList:onUpdateDraw()
	local root = self.roots[1]
	-- 玩家名称
	self.Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")

	-- 获得的道具图标
	self.Panel_reward_icon = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon")

	self.Text_player_name:setString(self.recordData.record.userName)
	-- 中奖号码
	local luckyPullRodRewardIconIds = self.recordData.record.luckyPullRodRewardIconIds
	for i,v in pairs(luckyPullRodRewardIconIds) do
		panel = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_"..i)
		local cell = ResourcesIconCell:createCell()
		local rewardType = v[1]
		if 13 == tonumber(rewardType) then
			local table = {}
			if v[4] ~= nil and tonumber(v[4]) ~= -1 then
				table.shipStar = tonumber(v[4])
			else
				table.shipStar = 0
			end
			cell:init(rewardType, 0, tonumber(v[2]),nil,nil,true,true,1,table)
		else
			cell:init(rewardType, 0, tonumber(v[2]),nil,nil,true,true,1)
		end
		panel:addChild(cell)
	end
	-- 奖励
	local returnIconId = self.recordData.record.reward
	self.ListView_reward_icon = ccui.Helper:seekWidgetByName(root, "ListView_reward_icon")
	self.ListView_reward_icon:removeAllItems()
	self.ListView_reward_icon:setVisible(true)
	for i,v in pairs(returnIconId) do
		local cell = ResourcesIconCell:createCell()
		local rewardType = v.sourceType
		if 13 == tonumber(rewardType) then
			local table = {}
			if v.sourceStarNumber ~= nil and tonumber(v.sourceStarNumber) ~= -1 then
				table.shipStar = tonumber(v.sourceStarNumber)
			else
				table.shipStar = 0
			end
			cell:init(rewardType, tonumber(v.sourceNumber), tonumber(v.sourceMouldID),nil,nil,true,true,1,table)
		else
			cell:init(rewardType, tonumber(v.sourceNumber), tonumber(v.sourceMouldID),nil,nil,true,true,1)
		end
		self.ListView_reward_icon:addChild(cell)
	end	
	self.ListView_reward_icon:jumpToLeft()
	self.ListView_reward_icon:requestRefreshView()

end

function SmLuckDrawRecordList:clearUIInfo( ... )
    local root = self.roots[1]
    -- 玩家名称
	self.Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")
	self.Text_player_name:setString('')
	for i=1,6 do
		panel = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_"..i)
		panel:removeAllChildren(true)
	end
	self.ListView_reward_icon = ccui.Helper:seekWidgetByName(root, "ListView_reward_icon")
	self.ListView_reward_icon:removeAllItems()

end

function SmLuckDrawRecordList:onEnterTransitionFinish()
	
end

function SmLuckDrawRecordList:onInit(params)
	-- 加载SmLuckDrawRecordListWindow界面资源.
	-- res.activity.wonderful.sm_luck_draw_record_list = res/activity/wonderful/sm_luck_draw_record_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/wonderful/sm_luck_draw_record_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/wonderful/sm_luck_draw_record_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if SmLuckDrawRecordList.__size == nil then
		SmLuckDrawRecordList.__size = root:getContentSize()
	end
    self:clearUIInfo()
	self:onUpdateDraw()
end

function SmLuckDrawRecordList:onExit()
	-- 释放SmLuckDrawRecordListWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/wonderful/sm_luck_draw_record_list.csb", root)
	-- ]]
end

function SmLuckDrawRecordList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SmLuckDrawRecordList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("activity/wonderful/sm_luck_draw_record_list.csb", root)
	self:stopAllActions()
	root:removeFromParent(false)

	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
