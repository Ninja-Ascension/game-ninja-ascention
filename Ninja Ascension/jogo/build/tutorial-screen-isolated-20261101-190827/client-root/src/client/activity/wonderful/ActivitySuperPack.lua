--[[ ----------------------------------------------------------------------------
-- 单笔充值独立界面
--]] ----------------------------------------------------------------------------
ActivitySuperPack = class("ActivitySuperPackClass", Window)

-- 打开窗口
local activity_super_pack_window_open_terminal = {
	_name = "activity_super_pack_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("ActivitySuperPackClass") then
			fwin:open(ActivitySuperPack:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local activity_super_pack_window_close_terminal = {
	_name = "activity_super_pack_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ActivitySuperPackClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(activity_super_pack_window_open_terminal)
state_machine.add(activity_super_pack_window_close_terminal)
state_machine.init()

-- 构造器
function ActivitySuperPack:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._tick_time = 0

	-- load lua files.
	app.load("client.activity.wonderful.ActivitySuperPackCell")

	-- Initialize activity single recharge page state machine.
	local function init_activity_super_pack_terminal()
		-- 打开角色创建窗口
		local activity_super_pack_open_terminal = {
			_name = "activity_super_pack_open",
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
		local activity_super_pack_close_terminal = {
			_name = "activity_super_pack_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("activity_super_pack_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local activity_super_pack_show_terminal = {
			_name = "activity_super_pack_show",
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
		local activity_super_pack_hide_terminal = {
			_name = "activity_super_pack_hide",
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

		-- 刷新界面
		local activity_super_pack_refresh_terminal = {
			_name = "activity_super_pack_refresh",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:onUpdateDraw()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(activity_super_pack_refresh_terminal)
		state_machine.add(activity_super_pack_open_terminal)
		state_machine.add(activity_super_pack_close_terminal)
		state_machine.add(activity_super_pack_show_terminal)
		state_machine.add(activity_super_pack_hide_terminal)
		state_machine.init()
	end
	-- call func init activity single recharge state machine.
	init_activity_super_pack_terminal()
end

-- 对象初始化
function ActivitySuperPack:init(params)
	self.actType = params
	return self
end

function ActivitySuperPack:updateRechargeList()
	-- FURY: MONEDAS PREMIUM (tipo propio 29150 con esta ventana, 30-sep-2026;
	-- docs/systems/evento_monedas_premium.md): sus dos reglas en 12 idiomas
	-- (`_fury_premium_event_text` de TipStringInfo.lua).
	if tonumber(self.actType) == 29150 and _fury_premium_event_text ~= nil then
		self.Text_45:setString(tostring(_fury_premium_event_text[2]))
		self.Text_45_1:setString(tostring(_fury_premium_event_text[3]))
	else
		self.Text_45:setString(tipStringInfo_daily_once_recharge_tips[1])
		self.Text_45_1:setString(tipStringInfo_daily_once_recharge_tips[2])
	end

	local activity_info = _ED.active_activity[self.actType]
	local activity_params = zstring.splits(activity_info.activity_params, "|", ",")
	local result = {}
	for i, v in ipairs(activity_info.activity_Info) do
		table.insert(result, v)
	end
	
	local closeItems = {}       -- 已完成
	local drawItems = {}            -- 可领取
	local uncompItems = {}      -- 未完成
	for k, v in ipairs(result) do
		local maxCompNum = zstring.split(v.activityInfo_need_day, ",")[2]
		if tonumber(maxCompNum) <= tonumber(activity_params[k][2]) then
			v.state = 2
			table.insert(closeItems, v)
		else
		if tonumber(activity_params[k][1]) > tonumber(activity_params[k][2]) then
			table.insert(drawItems, v)
			v.state = 1
		else
			table.insert(uncompItems, v)
			v.state = 0
		end
	end
		v.curRecharge = tonumber(activity_params[k][1])
		v.curGetReward = tonumber(activity_params[k][2])
	end

	result = {}
	for k, v in pairs(drawItems) do
		table.insert(result, v)
	end
	for k, v in pairs(uncompItems) do
		table.insert(result, v)
	end
	for k, v in pairs(closeItems) do
		table.insert(result, v)
	end

	self.ListView_1:removeAllItems()
	for k, v in ipairs(result) do
		local cell = state_machine.excute("activity_super_pack_cell_create", 0, {v, self.actType})
		self.ListView_1:addChild(cell)
	end
	self.ListView_1:requestRefreshView()

	self._tick_time = (tonumber(activity_info.end_time) - (os.time() + _ED.time_add_or_sub) * 1000) / 1000
end

function ActivitySuperPack:onUpdateDraw()
	local root = self.roots[1]

	-- 单笔充值列表
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	-- 倒计时
	self.Text_32 = ccui.Helper:seekWidgetByName(root, "Text_32")

	-- 说明1
	self.Text_45 = ccui.Helper:seekWidgetByName(root, "Text_45")

	-- 说明2
	self.Text_45_1 = ccui.Helper:seekWidgetByName(root, "Text_45_1")

	self:updateRechargeList()
end

function ActivitySuperPack:onUpdate(dt)
    if self.Text_32 ~= nil and self._tick_time > 0 then 
        self._tick_time = self._tick_time - dt
        self.Text_32:setString(getRedAlertTimeActivityFormat(self._tick_time))
        -- if self._tick_time <= 0 then
        --     self._tick_time = nil
        -- end
    end
end

function ActivitySuperPack:onEnterTransitionFinish()
	-- 加载ActivitySuperPackWindow界面资源.
	-- res.activity.wonderful.sm_discount_package = res/activity/wonderful/sm_discount_package.csb
	local csbNode = csb.createNode("activity/wonderful/sm_value_packag.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- FURY: MONEDAS PREMIUM (29150, 30-sep-2026). El titulo es arte con
	-- «Valuable Giftpack» quemado (`value_pack_title.png`): se oculta y se
	-- escribe encima el de `_fury_premium_event_text[1]`.
	local furyTitleArt = ccui.Helper:seekWidgetByName(root, "Image_3")
	if tonumber(self.actType) == 29150 and furyTitleArt ~= nil and _fury_premium_event_text ~= nil then
		furyTitleArt:setVisible(false)
		local fontName = ccui.Helper:seekWidgetByName(root, "Text_32"):getFontName()
		local title = ccui.Text:create(tostring(_fury_premium_event_text[1]), fontName, 34)
		title:setColor(cc.c3b(255, 214, 64))
		title:enableOutline(cc.c4b(90, 20, 90, 255), 3)
		title:setAnchorPoint(furyTitleArt:getAnchorPoint())
		-- Subido a la altura de «Tiempo»: en su sitio tapaba la regla 1 (visto 30-sep).
		local artX, artY = furyTitleArt:getPosition()
		title:setPosition(cc.p(artX, artY + 26))
		furyTitleArt:getParent():addChild(title)
		local w = title:getVirtualRendererSize().width
		if w > 300 then
			title:setScale(300 / w)
		end
	end

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "activity_super_pack_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function ActivitySuperPack:onExit()
	-- 释放ActivitySuperPackWindow界面资源.
	state_machine.remove("activity_super_pack_open")
	state_machine.remove("activity_super_pack_close")
	state_machine.remove("activity_super_pack_show")
	state_machine.remove("activity_super_pack_hide")
	state_machine.remove("activity_super_pack_refresh")
end

function ActivitySuperPack:close()
	-- window event : close.
	
end

function ActivitySuperPack:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
