--[[ ----------------------------------------------------------------------------
-- 锁定石消耗界面
--]] ----------------------------------------------------------------------------
SmEquipmentQianghuaTab3Window2 = class("SmEquipmentQianghuaTab3Window2Class", Window)

-- 打开窗口
local sm_equipment_qianghua_tab3_window2_window_open_terminal = {
	_name = "sm_equipment_qianghua_tab3_window2_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SmEquipmentQianghuaTab3Window2Class") then
			fwin:open(SmEquipmentQianghuaTab3Window2:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local sm_equipment_qianghua_tab3_window2_window_close_terminal = {
	_name = "sm_equipment_qianghua_tab3_window2_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmEquipmentQianghuaTab3Window2Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_equipment_qianghua_tab3_window2_window_open_terminal)
state_machine.add(sm_equipment_qianghua_tab3_window2_window_close_terminal)
state_machine.init()

-- 构造器
function SmEquipmentQianghuaTab3Window2:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.equip = nil
	-- load lua files.

	-- Initialize sm equipment qianghua tab3 window2 page state machine.
	local function init_sm_equipment_qianghua_tab3_window2_terminal()
		-- 打开角色创建窗口
		local sm_equipment_qianghua_tab3_window2_open_terminal = {
			_name = "sm_equipment_qianghua_tab3_window2_open",
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
		local sm_equipment_qianghua_tab3_window2_close_terminal = {
			_name = "sm_equipment_qianghua_tab3_window2_close",
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
		local sm_equipment_qianghua_tab3_window2_show_terminal = {
			_name = "sm_equipment_qianghua_tab3_window2_show",
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
		local sm_equipment_qianghua_tab3_window2_hide_terminal = {
			_name = "sm_equipment_qianghua_tab3_window2_hide",
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

		-- 锁定
		local sm_equipment_qianghua_tab3_window2_start_lock_terminal = {
			_name = "sm_equipment_qianghua_tab3_window2_start_lock",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					state_machine.lock("sm_equipment_qianghua_tab3_window2_start_lock",0,"")
					local equip = instance.equip
					local function responseEquipmentStartLockCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							state_machine.excute("sm_equipment_qianghua_to_update_equip_icon",0,nil)
							state_machine.excute("sm_equipment_qianghua_tab3_window1_update_draw",0,nil)
							state_machine.excute("sm_equipment_qianghua_tab3_window2_window_close",0,"")
							state_machine.unlock("sm_equipment_qianghua_tab3_window2_start_lock")
						else

							state_machine.unlock("sm_equipment_qianghua_tab3_window2_start_lock")
						end
					end
                	protocol_command.equipment_harden_locking.param_list = equip.ship_id .. "\r\n" ..equip.m_index.. "\r\n"..equip.lockIndex.. "\r\n" .. equip.lockType.. "\r\n"
                	NetworkManager:register(protocol_command.equipment_harden_locking.code, nil, nil, nil, instance, responseEquipmentStartLockCallback,false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(sm_equipment_qianghua_tab3_window2_open_terminal)
		state_machine.add(sm_equipment_qianghua_tab3_window2_close_terminal)
		state_machine.add(sm_equipment_qianghua_tab3_window2_show_terminal)
		state_machine.add(sm_equipment_qianghua_tab3_window2_hide_terminal)
		state_machine.add(sm_equipment_qianghua_tab3_window2_start_lock_terminal)
		state_machine.init()
	end
	-- call func init sm equipment qianghua tab3 window2 state machine.
	init_sm_equipment_qianghua_tab3_window2_terminal()
end

-- 对象初始化
function SmEquipmentQianghuaTab3Window2:init(params)
	self.equip = params[1]
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function SmEquipmentQianghuaTab3Window2:onUpdateDraw()
	local root = self.roots[1]


	local prop_mould_id = dms.int(dms["play_config"], 189, pirates_config.param)
	local prop_name = dms.string(dms["prop_mould"], prop_mould_id, prop_mould.prop_name)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		prop_name = setThePropsIcon(prop_mould_id)[2]
	end

	local haveNum = 0
	if fundPropWidthId(prop_mould_id) then 
		haveNum = tonumber(fundPropWidthId(prop_mould_id).prop_number)
	end

	-- 等级上限
	self.Text_3 = ccui.Helper:seekWidgetByName(root, "Text_3")

	-- 提示文字
	self.Text_rule = ccui.Helper:seekWidgetByName(root, "Text_rule")
	self.Text_rule:setString(string.format(tipStringInfo_equipment_harden[2],tostring(prop_name)))

	-- 数量文本
	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	self.Text_1:setString(string.format(tipStringInfo_equipment_harden[3],tostring(haveNum)))

end

function SmEquipmentQianghuaTab3Window2:onInit()
	-- 加载SmEquipmentQianghuaTab3Window2Window界面资源.
	-- res.packs.EquipStorage.sm_equipment_qianghua_tab_3_window_2 = res/packs/EquipStorage/sm_equipment_qianghua_tab_3_window_2.csb
	local csbNode = csb.createNode("packs/EquipStorage/sm_equipment_qianghua_tab_3_window_2.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 确定按钮
	self.Button_confirm = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_confirm"), nil,
	{
		terminal_name = "sm_equipment_qianghua_tab3_window2_start_lock",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 取消按钮
	self.Button_Cancel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_Cancel"), nil,
	{
		terminal_name = "sm_equipment_qianghua_tab3_window2_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭窗口
	self.Button_back = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil,
	{
		terminal_name = "sm_equipment_qianghua_tab3_window2_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end



function SmEquipmentQianghuaTab3Window2:onExit()
	-- 释放SmEquipmentQianghuaTab3Window2Window界面资源.
	state_machine.remove("sm_equipment_qianghua_tab3_window2_open")
	state_machine.remove("sm_equipment_qianghua_tab3_window2_close")
	state_machine.remove("sm_equipment_qianghua_tab3_window2_show")
	state_machine.remove("sm_equipment_qianghua_tab3_window2_hide")
	state_machine.remove("sm_equipment_qianghua_tab3_window2_start_lock")
end

function SmEquipmentQianghuaTab3Window2:close()
	-- window event : close.
	
end

function SmEquipmentQianghuaTab3Window2:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
