--[[ ----------------------------------------------------------------------------
-- 升星重置
--]] ----------------------------------------------------------------------------
RoleBiographyStartReset = class("RoleBiographyStartResetClass", Window)

-- 打开窗口
local role_biography_start_reset_window_open_terminal = {
	_name = "role_biography_start_reset_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RoleBiographyStartResetClass") then
			fwin:open(RoleBiographyStartReset:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local role_biography_start_reset_window_close_terminal = {
	_name = "role_biography_start_reset_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RoleBiographyStartResetClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_start_reset_window_open_terminal)
state_machine.add(role_biography_start_reset_window_close_terminal)
state_machine.init()

-- 构造器
function RoleBiographyStartReset:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies report page state machine.
	local function init_role_biography_start_reset_terminal()
		-- 打开角色创建窗口
		local role_biography_start_reset_open_terminal = {
			_name = "role_biography_start_reset_open",
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
		local role_biography_start_reset_close_terminal = {
			_name = "role_biography_start_reset_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_start_reset_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local role_biography_start_reset_show_terminal = {
			_name = "role_biography_start_reset_show",
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
		local role_biography_start_reset_hide_terminal = {
			_name = "role_biography_start_reset_hide",
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

		local role_biography_start_reset_sure_terminal = {
			_name = "role_biography_start_reset_sure",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					state_machine.lock("role_biography_start_reset_sure")

					local biographyId = params._datas._biographyId
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then	
							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(7)
							fwin:open(getRewardWnd, fwin._ui)
							
							-- 清空原有属性
							RoleBiographyHandle.clearTotalPropertyData()
							
							state_machine.unlock("role_biography_start_reset_sure")

							-- 刷新界面
							state_machine.excute("role_biography_refresh_ui", 0, nil)
							state_machine.excute("role_biography_start_reset_close", 0, nil)
						else
							state_machine.unlock("role_biography_start_reset_sure")
						end
					end
					protocol_command.biographies_rebirth.param_list = "" .. biographyId
					NetworkManager:register(protocol_command.biographies_rebirth.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(role_biography_start_reset_open_terminal)
		state_machine.add(role_biography_start_reset_close_terminal)
		state_machine.add(role_biography_start_reset_show_terminal)
		state_machine.add(role_biography_start_reset_hide_terminal)
		state_machine.add(role_biography_start_reset_sure_terminal)
		state_machine.init()
	end
	-- call func init ninja biographies report state machine.
	init_role_biography_start_reset_terminal()
end

-- 对象初始化
function RoleBiographyStartReset:init(params)
	self._biographyId = params

	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function RoleBiographyStartReset:updateUI()
	local costStr = dms.string(dms["play_config"], 206, play_config.param)
	local costCount = tonumber(zstring.split(costStr, ",")[3])
	self.Text_buy:setString(costCount)

	local ListView_item = self.ListView_item
	ListView_item:removeAllItems()
	
	local data = self:getUpLevelCost()
	for _, v in ipairs(data) do
		local cell = self:addResourcesIconCell(v)
		ListView_item:addChild(cell)
	end

	ListView_item:jumpToTop()
	ListView_item:requestRefreshView()
end

function RoleBiographyStartReset:getUpLevelCost()
	local biographyId = self._biographyId

	local result = {}
	for _, v in pairs(dms["biographies_star_mould"]) do
        local id = dms.atof(v, biographies_star_mould.biographies_mould_id)
        if biographyId == id then
	        local costPropStr = dms.atos(v, biographies_star_mould.costProp)
	        if costPropStr ~= "-1" then
				local cost = zstring.splits(costPropStr, "|", ",")
				for _, m in ipairs(cost) do
					table.insert(result, m)
				end
	        end
        end
    end

	local tempMap = {}
	for _, v in ipairs(result) do
		local propId = tonumber(v[2])
		tempMap[propId] = (tempMap[propId] or 0) + tonumber(v[3])
	end

	local finalResult = {}
	for propId, count in pairs(tempMap) do
		table.insert(finalResult, {6, propId, count})
	end

	local function fightingCapacity(a, b)
        local al = dms.int(dms["prop_mould"], a[2], prop_mould.prop_quality)
        local bl = dms.int(dms["prop_mould"], b[2], prop_mould.prop_quality)
            
        if al == bl then
            local aCount = tonumber(a[3])
            local bCount = tonumber(b[3])

            return aCount > bCount
        end

        return al > bl 
    end

	table.sort(finalResult, fightingCapacity)

	-- debug.print_r(finalResult, "finalResult")
	return finalResult
end

function RoleBiographyStartReset:addResourcesIconCell(propData)
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

function RoleBiographyStartReset:onUpdateDraw()
	local root = self.roots[1]

	self.ListView_item = ccui.Helper:seekWidgetByName(root, "ListView_item")

	self.Text_buy = ccui.Helper:seekWidgetByName(root, "Text_buy")

	self:updateUI()
end


function RoleBiographyStartReset:onEnterTransitionFinish()
	-- 加载RoleBiographyStartResetWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_reset = res/cultivate/ninja_biographies/ninja_biographies_reset.csb
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_reset.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)


	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "role_biography_start_reset_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self.Button_cancel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil,
	{
		terminal_name = "role_biography_start_reset_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self.Button_reset = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reset"), nil,
	{
		terminal_name = "role_biography_start_reset_sure",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_biographyId = self._biographyId
	}, nil, 0)	

	self:onUpdateDraw()
end

function RoleBiographyStartReset:onExit()
	-- 释放RoleBiographyStartResetWindow界面资源.
	state_machine.remove("role_biography_start_reset_open")
	state_machine.remove("role_biography_start_reset_close")
	state_machine.remove("role_biography_start_reset_show")
	state_machine.remove("role_biography_start_reset_hide")
	state_machine.remove("role_biography_start_reset_sure")
end

function RoleBiographyStartReset:close()
	-- window event : close.
	
end

function RoleBiographyStartReset:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
