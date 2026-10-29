--[[ ----------------------------------------------------------------------------
-- 奖励预览弹窗
--]] ----------------------------------------------------------------------------
SmLuckDrawReview = class("SmLuckDrawReviewClass", Window)

-- 打开窗口
local sm_luck_draw_review_window_open_terminal = {
	_name = "sm_luck_draw_review_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SmLuckDrawReviewClass") then
			fwin:open(SmLuckDrawReview:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local sm_luck_draw_review_window_close_terminal = {
	_name = "sm_luck_draw_review_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmLuckDrawReviewClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_luck_draw_review_window_open_terminal)
state_machine.add(sm_luck_draw_review_window_close_terminal)
state_machine.init()

-- 构造器
function SmLuckDrawReview:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
    app.load("client.activity.wonderful.smluckdrawreviewlist")

	-- Initialize sm luck draw review page state machine.
	local function init_sm_luck_draw_review_terminal()
		-- 打开角色创建窗口
		local sm_luck_draw_review_open_terminal = {
			_name = "sm_luck_draw_review_open",
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
		local sm_luck_draw_review_close_terminal = {
			_name = "sm_luck_draw_review_close",
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
		local sm_luck_draw_review_show_terminal = {
			_name = "sm_luck_draw_review_show",
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
		local sm_luck_draw_review_hide_terminal = {
			_name = "sm_luck_draw_review_hide",
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

		state_machine.add(sm_luck_draw_review_open_terminal)
		state_machine.add(sm_luck_draw_review_close_terminal)
		state_machine.add(sm_luck_draw_review_show_terminal)
		state_machine.add(sm_luck_draw_review_hide_terminal)
		state_machine.init()
	end
	-- call func init sm luck draw review state machine.
	init_sm_luck_draw_review_terminal()
end

-- 对象初始化
function SmLuckDrawReview:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function SmLuckDrawReview:onUpdateDraw()
	local root = self.roots[1]

	-- 奖励预览列表控件
	self.ListView_review_list = ccui.Helper:seekWidgetByName(root, "ListView_review_list")
	
	-- Abierta antes de que llegue el S2C 13049: lista vacia.
	for i,v in pairs(_ED.active_activity[162].previewReward or {}) do
		local cell= state_machine.excute("sm_luck_draw_review_list_create", 0, v)
		self.ListView_review_list:addChild(cell)
	end
end

function SmLuckDrawReview:onEnterTransitionFinish()
	-- 加载SmLuckDrawReviewWindow界面资源.
	-- res.activity.wonderful.sm_luck_draw_review = res/activity/wonderful/sm_luck_draw_review.csb
	local csbNode = csb.createNode("activity/wonderful/sm_luck_draw_review.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "sm_luck_draw_review_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function SmLuckDrawReview:onExit()
	-- 释放SmLuckDrawReviewWindow界面资源.
	state_machine.remove("sm_luck_draw_review_open")
	state_machine.remove("sm_luck_draw_review_close")
	state_machine.remove("sm_luck_draw_review_show")
	state_machine.remove("sm_luck_draw_review_hide")
end

function SmLuckDrawReview:close()
	-- window event : close.
	
end

function SmLuckDrawReview:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
