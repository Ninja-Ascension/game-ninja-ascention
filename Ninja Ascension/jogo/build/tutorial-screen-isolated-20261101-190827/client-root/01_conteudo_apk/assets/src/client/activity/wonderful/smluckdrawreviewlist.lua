--[[ ----------------------------------------------------------------------------
-- 奖励预览列表控件
--]] ----------------------------------------------------------------------------
SmLuckDrawReviewList = class("SmLuckDrawReviewListClass", Window)
SmLuckDrawReviewList.__size = nil

-- 创建Cell实例
local sm_luck_draw_review_list_create_terminal = {
	_name = "sm_luck_draw_review_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if SmLuckDrawReviewList then
			local cell = SmLuckDrawReviewList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_luck_draw_review_list_create_terminal)
state_machine.init()

-- 构造器
function SmLuckDrawReviewList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
    app.load("client.cells.utils.resources_icon_cell")

	-- Initialize sm luck draw review list page state machine.
	local function init_sm_luck_draw_review_list_terminal()
		
	end
	-- call func init sm luck draw review list state machine.
	init_sm_luck_draw_review_list_terminal()
end

-- 对象初始化
function SmLuckDrawReviewList:init(params)
	self.data = params
	self:onInit(params)
	self:setContentSize(SmLuckDrawReviewList.__size)
	return self
end

function SmLuckDrawReviewList:onUpdateDraw()
	local root = self.roots[1]

	-- -- 转到的道具图标1
	-- self.Panel_reward_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_1")

	-- -- 转到的道具图标2
	-- self.Panel_reward_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_2")

	-- -- 转到的道具图标3
	-- self.Panel_reward_icon_3 = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_3")

	-- -- 转到的道具图标4
	-- self.Panel_reward_icon_4 = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_4")

	-- -- 转到的道具图标5
	-- self.Panel_reward_icon_5 = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_5")

	-- -- 转到的道具图标6
	-- self.Panel_reward_icon_6 = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_6")

	-- 获得的道具图标
	-- self.Panel_reward_icon = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon")
	self.ListView_reward_icon = ccui.Helper:seekWidgetByName(root, "ListView_reward_icon")

	local returnIconId = self.data.returnIconId
	for i,v in pairs(returnIconId) do
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

	self.ListView_reward_icon:removeAllItems()
	for i,v in pairs(self.data.returnReward) do
		local cell = ResourcesIconCell:createCell()
		local rewardType = v.sourceType
		if 13 == tonumber(rewardType) then
			local table = {}
			if v.sourceStarNumber ~= nil and tonumber(v.sourceStarNumber) ~= -1 then
				table.shipStar = tonumber(v.sourceStarNumber)
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

function SmLuckDrawReviewList:onEnterTransitionFinish()
	
end

function SmLuckDrawReviewList:onInit(params)
	-- 加载SmLuckDrawReviewListWindow界面资源.
	-- res.activity.wonderful.sm_luck_draw_review_list = res/activity/wonderful/sm_luck_draw_review_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/wonderful/sm_luck_draw_review_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/wonderful/sm_luck_draw_review_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if SmLuckDrawReviewList.__size == nil then
		SmLuckDrawReviewList.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function SmLuckDrawReviewList:onExit()
	-- 释放SmLuckDrawReviewListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/wonderful/sm_luck_draw_review_list.csb", root)
	-- ]]
end

function SmLuckDrawReviewList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SmLuckDrawReviewList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/wonderful/sm_luck_draw_review_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
