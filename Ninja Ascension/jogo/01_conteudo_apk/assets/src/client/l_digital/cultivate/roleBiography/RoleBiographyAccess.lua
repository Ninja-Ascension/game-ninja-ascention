--[[ ----------------------------------------------------------------------------
-- 获取界面
--]] ----------------------------------------------------------------------------
RoleBiographyAccess = class("RoleBiographyAccessClass", Window)

-- 打开窗口
local role_biography_access_window_open_terminal = {
	_name = "role_biography_access_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RoleBiographyAccessClass") then
			fwin:open(RoleBiographyAccess:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local role_biography_access_window_close_terminal = {
	_name = "role_biography_access_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RoleBiographyAccessClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_access_window_open_terminal)
state_machine.add(role_biography_access_window_close_terminal)
state_machine.init()

-- 构造器
function RoleBiographyAccess:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies obtain page state machine.
	local function init_role_biography_access_terminal()
		-- 打开角色创建窗口
		local role_biography_access_open_terminal = {
			_name = "role_biography_access_open",
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
		local role_biography_access_close_terminal = {
			_name = "role_biography_access_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_access_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local role_biography_access_show_terminal = {
			_name = "role_biography_access_show",
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
		local role_biography_access_hide_terminal = {
			_name = "role_biography_access_hide",
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

		state_machine.add(role_biography_access_open_terminal)
		state_machine.add(role_biography_access_close_terminal)
		state_machine.add(role_biography_access_show_terminal)
		state_machine.add(role_biography_access_hide_terminal)
		state_machine.init()
	end
	-- call func init ninja biographies obtain state machine.
	init_role_biography_access_terminal()
end

-- 对象初始化
function RoleBiographyAccess:init(params)
	self._propId = params

	return self
end

function RoleBiographyAccess:updateUI()
	local Panel_charactor = self.Panel_charactor
	Panel_charactor:removeAllChildren(true)

	local propData = {6, self._propId, 0}

	local cell = self:addResourcesIconCell(propData)
	Panel_charactor:addChild(cell)

	local name = setThePropsIcon(self._propId)[2]
	self.Text_name:setString(name)

	local haveCount = tonumber(getPropAllCountByMouldId(self._propId))
	self.Text_quanaity_0:setString(haveCount)

	self:updateList()
end

function RoleBiographyAccess:updateList()
	local ListView_1 = self.ListView_1
	ListView_1:removeAllItems()

	-- 判断该道具是否可以在抽奖库中抽到
	local canDraw = RoleBiographyHandle.getPropIsInRewards(self._propId)
	local showType = canDraw and 1 or 2

	local cell = state_machine.excute("role_biography_access_cell_create", 0, showType)
	ListView_1:addChild(cell)

	ListView_1:jumpToTop()
	ListView_1:requestRefreshView()
end

function RoleBiographyAccess:addResourcesIconCell(propData)
	local cell = ResourcesIconCell:createCell()
	local rewardType = tonumber(propData[1])
	if 13 == rewardType then
		local extraTable = {}
		if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
			extraTable.shipStar = tonumber(propData[4])
		else
			extraTable.shipStar = 0
		end
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
	else
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true ,true, 1)
	end
	return cell
end


function RoleBiographyAccess:onUpdateDraw()
	local root = self.roots[1]

	-- 忍列传名称
	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")

	-- 数量显示
	self.Text_quanaity_0 = ccui.Helper:seekWidgetByName(root, "Text_quanaity_0")

	-- 印记图标容器
	self.Panel_charactor = ccui.Helper:seekWidgetByName(root, "Panel_charactor")

	-- 获取途径容器
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	self:updateUI()
end

function RoleBiographyAccess:onEnterTransitionFinish()
	-- 加载RoleBiographyAccessWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_obtain = res/cultivate/ninja_biographies/ninja_biographies_obtain.csb
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_obtain.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "role_biography_access_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function RoleBiographyAccess:onExit()
	-- 释放RoleBiographyAccessWindow界面资源.
	state_machine.remove("role_biography_access_open")
	state_machine.remove("role_biography_access_close")
	state_machine.remove("role_biography_access_show")
	state_machine.remove("role_biography_access_hide")
end

function RoleBiographyAccess:close()
	-- window event : close.
	
end

function RoleBiographyAccess:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
