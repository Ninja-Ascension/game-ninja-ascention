--[[ ----------------------------------------------------------------------------
-- 特权卡奖励预览控件
--]] ----------------------------------------------------------------------------
SmSpecialVipCardPreviewList = class("SmSpecialVipCardPreviewListClass", Window)
SmSpecialVipCardPreviewList.__size = nil

-- 创建Cell实例
local sm_special_vip_card_preview_list_create_terminal = {
	_name = "sm_special_vip_card_preview_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if SmSpecialVipCardPreviewList then
			local cell = SmSpecialVipCardPreviewList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_special_vip_card_preview_list_create_terminal)
state_machine.init()

-- 构造器
function SmSpecialVipCardPreviewList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._rewardInfo = nil

	-- load lua files.
	app.load("client.cells.utils.activity_reword_cell")

	-- Initialize sm special vip card preview list page state machine.
	local function init_sm_special_vip_card_preview_list_terminal()
		-- 打开角色创建窗口
		local sm_special_vip_card_preview_list_open_terminal = {
			_name = "sm_special_vip_card_preview_list_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 关闭角色创建窗口
		local sm_special_vip_card_preview_list_close_terminal = {
			_name = "sm_special_vip_card_preview_list_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local sm_special_vip_card_preview_list_show_terminal = {
			_name = "sm_special_vip_card_preview_list_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local sm_special_vip_card_preview_list_hide_terminal = {
			_name = "sm_special_vip_card_preview_list_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(sm_special_vip_card_preview_list_open_terminal)
		state_machine.add(sm_special_vip_card_preview_list_close_terminal)
		state_machine.add(sm_special_vip_card_preview_list_show_terminal)
		state_machine.add(sm_special_vip_card_preview_list_hide_terminal)
		state_machine.init()
	end
	-- call func init sm special vip card preview list state machine.
	init_sm_special_vip_card_preview_list_terminal()
end

-- 对象初始化
function SmSpecialVipCardPreviewList:init(params)
	self._rewardInfo = params
	if self._rewardInfo.vipLvl < 9 then
		self:onInit(params)
	end
	self:setContentSize(SmSpecialVipCardPreviewList.__size)
	return self
end

function SmSpecialVipCardPreviewList:onUpdateDraw()
	local root = self.roots[1]

	-- 每日奖励的VIP级别
	self.Text_preview_t = ccui.Helper:seekWidgetByName(root, "Text_preview_t")

	-- 奖励容器
	self.ListView_7 = ccui.Helper:seekWidgetByName(root, "ListView_7")

	self.Text_preview_t:setString(string.format(tipStringInfo_vip_card_tip[4], self._rewardInfo.vipLvl))

	self:updateRewardList()
end

function SmSpecialVipCardPreviewList:updateRewardList()
	local ListView_7 = self.ListView_7
	ListView_7:removeAllItems()
	
	local rewards = zstring.splits(self._rewardInfo.reward, "|", ",")

	for i, reward in ipairs(rewards) do
		local rewardType = zstring.tonumber(reward[1])
		local cell = ActivityRewordCell:createCell()
		if 13 == rewardType then
			local table = {}
			if reward[4] ~= nil and tonumber(reward[4]) ~= -1 then
				table.shipStar = tonumber(reward[4])
			end
			cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]), nil, nil, true, true, 1, table)
		else
			cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]), nil, nil, true, true, 1)
		end
		ListView_7:addChild(cell)
	end

	ListView_7:jumpToLeft()
	ListView_7:requestRefreshView()
end

function SmSpecialVipCardPreviewList:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Text_preview_t = ccui.Helper:seekWidgetByName(root, "Text_preview_t")
	self.Text_preview_t:setString("")

	self.ListView_7 = ccui.Helper:seekWidgetByName(root, "ListView_7")
	self.ListView_7:removeAllItems()
end

function SmSpecialVipCardPreviewList:onEnterTransitionFinish()
	
end

function SmSpecialVipCardPreviewList:onInit(params)
	-- 加载SmSpecialVipCardPreviewListWindow界面资源.
	-- res.activity.wonderful.sm_special_vip_card_preview_list = res/activity/wonderful/sm_special_vip_card_preview_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/wonderful/sm_special_vip_card_preview_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/wonderful/sm_special_vip_card_preview_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if SmSpecialVipCardPreviewList.__size == nil then
		SmSpecialVipCardPreviewList.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function SmSpecialVipCardPreviewList:onExit()
	-- 释放SmSpecialVipCardPreviewListWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/wonderful/sm_special_vip_card_preview_list.csb", root)
	-- ]]
end

function SmSpecialVipCardPreviewList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SmSpecialVipCardPreviewList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/wonderful/sm_special_vip_card_preview_list.csb", root)
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
