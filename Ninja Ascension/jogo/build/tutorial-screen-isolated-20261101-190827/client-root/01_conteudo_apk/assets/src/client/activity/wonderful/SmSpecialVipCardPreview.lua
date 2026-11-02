--[[ ----------------------------------------------------------------------------
-- 特权卡奖励预览
--]] ----------------------------------------------------------------------------
SmSpecialVipCardPreview = class("SmSpecialVipCardPreviewClass", Window)

-- 打开窗口
local sm_special_vip_card_preview_window_open_terminal = {
	_name = "sm_special_vip_card_preview_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SmSpecialVipCardPreviewClass") then
			fwin:open(SmSpecialVipCardPreview:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local sm_special_vip_card_preview_window_close_terminal = {
	_name = "sm_special_vip_card_preview_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmSpecialVipCardPreviewClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_special_vip_card_preview_window_open_terminal)
state_machine.add(sm_special_vip_card_preview_window_close_terminal)
state_machine.init()

-- 构造器
function SmSpecialVipCardPreview:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._rewardList = nil
	self.ListView_preview_rule_poy = nil

	-- load lua files.
	app.load("client.activity.wonderful.SmSpecialVipCardPreviewList")

	-- Initialize sm special vip card preview page state machine.
	local function init_sm_special_vip_card_preview_terminal()
		-- 打开角色创建窗口
		local sm_special_vip_card_preview_open_terminal = {
			_name = "sm_special_vip_card_preview_open",
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
		local sm_special_vip_card_preview_close_terminal = {
			_name = "sm_special_vip_card_preview_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				fwin:close(fwin:find("SmSpecialVipCardPreviewClass"))
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local sm_special_vip_card_preview_show_terminal = {
			_name = "sm_special_vip_card_preview_show",
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
		local sm_special_vip_card_preview_hide_terminal = {
			_name = "sm_special_vip_card_preview_hide",
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

		state_machine.add(sm_special_vip_card_preview_open_terminal)
		state_machine.add(sm_special_vip_card_preview_close_terminal)
		state_machine.add(sm_special_vip_card_preview_show_terminal)
		state_machine.add(sm_special_vip_card_preview_hide_terminal)
		state_machine.init()
	end
	-- call func init sm special vip card preview state machine.
	init_sm_special_vip_card_preview_terminal()
end

-- 对象初始化
function SmSpecialVipCardPreview:init(params)
	local rewardInfo = _ED.active_activity[163].activity_Info

	self._rewardList = {}
	for i, v in pairs(rewardInfo) do
		table.insert(self._rewardList, {reward = v.activityInfo_reward_select, vipLvl = zstring.tonumber(v.index) - 1})
	end

	table.sort(self._rewardList, function(a, b)
		return a.vipLvl < b.vipLvl
	end)

	return self
end

function SmSpecialVipCardPreview:onUpdateDraw()
	local root = self.roots[1]

	-- 每日奖励预览列表
	self.ListView_preview_rule = ccui.Helper:seekWidgetByName(root, "ListView_preview_rule")

	-- 关闭按钮
	self.Button_closed = ccui.Helper:seekWidgetByName(root, "Button_closed")

	self:updatePreviewList()
end

function SmSpecialVipCardPreview:updatePreviewList()
	self.ListView_preview_rule:removeAllItems()
	local rewardList = self._rewardList
	for i, v in ipairs(rewardList) do
		local cell = state_machine.excute("sm_special_vip_card_preview_list_create", 0, v)
		self.ListView_preview_rule:addChild(cell)
	end
	self.ListView_preview_rule_poy = self.ListView_preview_rule:getInnerContainer():getPositionY()
	self.ListView_preview_rule:jumpToTop()
	self.ListView_preview_rule:requestRefreshView()
end

function SmSpecialVipCardPreview:onEnterTransitionFinish()
	-- 加载SmSpecialVipCardPreviewWindow界面资源.
	-- res.activity.wonderful.sm_special_vip_card_preview = res/activity/wonderful/sm_special_vip_card_preview.csb
	local csbNode = csb.createNode("activity/wonderful/sm_special_vip_card_preview.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "sm_special_vip_card_preview_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

-- @onUpdate(dt)
function SmSpecialVipCardPreview:onUpdate(dt)
	if self.ListView_preview_rule ~= nil then
		local size = self.ListView_preview_rule:getContentSize()
		local posY = self.ListView_preview_rule:getInnerContainer():getPositionY()
		if self.ListView_preview_rule_poy == posY then
			return
		end
		self.ListView_preview_rule_poy = posY
		local items = self.ListView_preview_rule:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempY = v:getPositionY() + posY
			if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then	
				v:unload()
			else	
				v:reload()				
			end
		end
	end
end

function SmSpecialVipCardPreview:onExit()
	-- 释放SmSpecialVipCardPreviewWindow界面资源.
	state_machine.remove("sm_special_vip_card_preview_open")
	state_machine.remove("sm_special_vip_card_preview_close")
	state_machine.remove("sm_special_vip_card_preview_show")
	state_machine.remove("sm_special_vip_card_preview_hide")
end

function SmSpecialVipCardPreview:close()
	-- window event : close.
	
end

function SmSpecialVipCardPreview:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
