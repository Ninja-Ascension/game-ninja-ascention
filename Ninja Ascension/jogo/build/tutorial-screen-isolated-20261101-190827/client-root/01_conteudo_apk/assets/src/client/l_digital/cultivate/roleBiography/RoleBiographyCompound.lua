--[[ ----------------------------------------------------------------------------
-- 幻彩印记合成界面
--]] ----------------------------------------------------------------------------
RoleBiographyCompound = class("RoleBiographyCompoundClass", Window)

-- 打开窗口
local role_biography_compound_window_open_terminal = {
	_name = "role_biography_compound_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RoleBiographyCompoundClass") then
			fwin:open(RoleBiographyCompound:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local role_biography_compound_window_close_terminal = {
	_name = "role_biography_compound_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RoleBiographyCompoundClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_compound_window_open_terminal)
state_machine.add(role_biography_compound_window_close_terminal)
state_machine.init()

-- 构造器
function RoleBiographyCompound:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies obtain page state machine.
	local function init_role_biography_compound_terminal()
		-- 打开角色创建窗口
		local role_biography_compound_open_terminal = {
			_name = "role_biography_compound_open",
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
		local role_biography_compound_close_terminal = {
			_name = "role_biography_compound_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_compound_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local role_biography_compound_show_terminal = {
			_name = "role_biography_compound_show",
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
		local role_biography_compound_hide_terminal = {
			_name = "role_biography_compound_hide",
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

		-- 确认合成
		local role_biography_compound_sure_terminal = {
			_name = "role_biography_compound_sure",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local canCompound = true
					for _, v in pairs(instance._compoundNeedProps) do
						local needCount = zstring.tonumber(v[3])
						local haveCount = zstring.tonumber(getPropAllCountByMouldId(v[2]))

						if haveCount < needCount then
							canCompound = false
							break
						end
					end

					if canCompound == false then
						TipDlg.drawTextDailog(tipStringInfo_role_biography[18])
						return
					end

					if instance._propId == nil then
						return
					end

					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
								local getRewardWnd = DrawRareReward:new()
								getRewardWnd:init(7)
								fwin:open(getRewardWnd, fwin._ui)

								-- 刷新忍列传界面
								state_machine.excute("role_biography_refresh_ui", 0, nil)
								state_machine.excute("notification_center_update",0,"push_notification_role_biography")

								response.node:updatePropCount()
								-- state_machine.excute("role_biography_compound_close", 0, nil)
							end
						end
					end
					protocol_command.biographies_mark_synthesis.param_list = instance._propId
					NetworkManager:register(protocol_command.biographies_mark_synthesis.code, nil, nil, nil, instance, responseCallback, false, nil)

				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}


		state_machine.add(role_biography_compound_open_terminal)
		state_machine.add(role_biography_compound_close_terminal)
		state_machine.add(role_biography_compound_show_terminal)
		state_machine.add(role_biography_compound_hide_terminal)
		state_machine.add(role_biography_compound_sure_terminal)
		state_machine.init()
	end
	-- call func init ninja biographies obtain state machine.
	init_role_biography_compound_terminal()
end

-- 对象初始化
function RoleBiographyCompound:init(params)
	self._propId = params

	self._compoundNeedProps = RoleBiographyHandle.getImprintCompoundNeedProps(self._propId)

	return self
end

function RoleBiographyCompound:updateUI()
	local Panel_icon = self.Panel_icon
	Panel_icon:removeAllChildren(true)

	local propData = {6, self._propId, 0}

	local cell = DrawHandle.drawIcon(propData)
	Panel_icon:addChild(cell)

	local name = setThePropsIcon(self._propId)[2]
	self.Text_yj_name:setString(name)

	self:updateList()
end

function RoleBiographyCompound:updateList()
	local ListView_1 = self.ListView_1
	ListView_1:removeAllItems()
	
	for _, v in ipairs(self._compoundNeedProps) do
		local cell = state_machine.excute("role_biography_compound_cell_create", 0, v)
		ListView_1:addChild(cell)
	end

	ListView_1:jumpToTop()
	ListView_1:requestRefreshView()
end

function RoleBiographyCompound:updatePropCount()
	local ListView_1 = self.ListView_1
	if ListView_1 then
		for _, v in pairs(ListView_1:getChildren()) do
			if v ~= nil and v.updateHaveCount then
				v:updateHaveCount()
			end
		end
	end
end

function RoleBiographyCompound:onUpdateDraw()
	local root = self.roots[1]

	-- 忍列传名称
	self.Text_yj_name = ccui.Helper:seekWidgetByName(root, "Text_yj_name")

	-- 印记图标容器
	self.Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")

	-- 获取途径容器
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	self:updateUI()
end

function RoleBiographyCompound:onEnterTransitionFinish()
	-- 加载RoleBiographyCompoundWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_synthesis = res/cultivate/ninja_biographies/ninja_biographies_synthesis.csb
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_synthesis.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "role_biography_compound_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 合成
	self.Button_hc = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hc"), nil,
	{
		terminal_name = "role_biography_compound_sure",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function RoleBiographyCompound:onExit()
	-- 释放RoleBiographyCompoundWindow界面资源.
	state_machine.remove("role_biography_compound_open")
	state_machine.remove("role_biography_compound_close")
	state_machine.remove("role_biography_compound_show")
	state_machine.remove("role_biography_compound_hide")
	state_machine.remove("role_biography_compound_sure")
end

function RoleBiographyCompound:close()
	-- window event : close.
	
end

function RoleBiographyCompound:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
