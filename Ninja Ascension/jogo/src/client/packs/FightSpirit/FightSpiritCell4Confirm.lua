FightSpiritCell4Confirm = class("FightSpiritCell4ConfirmClass", Window)

-- 打开窗口
local fight_spirit_hecheng_confirm_window_open_terminal = {
	_name = "fight_spirit_hecheng_confirm_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FightSpiritCell4ConfirmClass") then
			fwin:open(FightSpiritCell4Confirm:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fight_spirit_hecheng_confirm_window_close_terminal = {
	_name = "fight_spirit_hecheng_confirm_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritCell4ConfirmClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_hecheng_confirm_window_open_terminal)
state_machine.add(fight_spirit_hecheng_confirm_window_close_terminal)
state_machine.init()

-- 构造器
function FightSpiritCell4Confirm:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fight spirit zh att page state machine.
	local function init_fight_spirit_hecheng_confirm_terminal()
		-- 打开角色创建窗口
		local fight_spirit_hecheng_confirm_open_terminal = {
			_name = "fight_spirit_hecheng_confirm_open",
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
		local fight_spirit_hecheng_confirm_close_terminal = {
			_name = "fight_spirit_hecheng_confirm_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("fight_spirit_hecheng_confirm_window_close", nil, {})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local fight_spirit_hecheng_confirm_show_terminal = {
			_name = "fight_spirit_hecheng_confirm_show",
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
		local fight_spirit_hecheng_confirm_hide_terminal = {
			_name = "fight_spirit_hecheng_confirm_hide",
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
		local fight_spirit_hecheng_confirm_window_ok_terminal = {
			_name = "fight_spirit_hecheng_confirm_window_ok",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local function responseCallback(response)
        			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
        				local wnd = fwin:find("FightSpiritCell4Class")
		                if wnd ~= nil then
		                	for i = 1, 3 do
		                		wnd:setHcFightSpirit(-1, i)
		                		wnd:onUpdateDraw()
		                	end
		                end
						state_machine.excute("fight_spirit_hecheng_confirm_close",0,{})
						app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
						fwin:open(getRewardWnd,fwin._ui)
						state_machine.excute("fight_spirit_main_update_detail", 0, {})
        			end
        		end
				protocol_command.fight_spirit_compund.param_list = ""..instance.params.targetFightSpirit.mouldId.."\r\n"..
				instance.params.materials[1].id.."\r\n"..instance.params.materials[2].id.."\r\n"..instance.params.materials[3].id
    			NetworkManager:register(protocol_command.fight_spirit_compund.code, nil, nil, nil, nil, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		state_machine.add(fight_spirit_hecheng_confirm_open_terminal)
		state_machine.add(fight_spirit_hecheng_confirm_close_terminal)
		state_machine.add(fight_spirit_hecheng_confirm_show_terminal)
		state_machine.add(fight_spirit_hecheng_confirm_hide_terminal)
		state_machine.add(fight_spirit_hecheng_confirm_window_ok_terminal)
		state_machine.init()
	end
	-- call func init fight spirit zh att state machine.
	init_fight_spirit_hecheng_confirm_terminal()
end

-- 对象初始化
function FightSpiritCell4Confirm:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function FightSpiritCell4Confirm:onInit(params)
	self.params = params._datas
end

function FightSpiritCell4Confirm:onUpdateDraw()
	local root = self.roots[1]
	local materials = self.params.materials
	for i,fightSpirit in ipairs(materials) do
		local cell = ResourcesIconCell:createCell()
		cell:init(73,nil,nil,nil,nil,nil,true,nil,{fightSpirit=fightSpirit})
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_zh_"..i):addChild(cell)
	end
	local fightSpirit = self.params.targetFightSpirit
	local cell = ResourcesIconCell:createCell()
	cell:init(73,nil,nil,nil,nil,nil,false,nil,{fightSpirit=fightSpirit})
	ccui.Helper:seekWidgetByName(self.roots[1], "Panel_zh_4"):addChild(cell)

	local pos = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.pos)
	local suitId = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.suit_id)
	ccui.Helper:seekWidgetByName(root, "Text_name"):setString(dms.element(dms["word_mould"], 
		dms.int(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.suit_name))[3].."."..chinese_num[pos])
end

function FightSpiritCell4Confirm:onEnterTransitionFinish()
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_synthesis.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fight_spirit_hecheng_confirm_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qd"), nil,
	{
		terminal_name = "fight_spirit_hecheng_confirm_window_ok",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qx"), nil,
	{
		terminal_name = "fight_spirit_hecheng_confirm_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	
	self:onUpdateDraw()
end

function FightSpiritCell4Confirm:onExit()
	-- 释放FightSpiritCell4ConfirmWindow界面资源.
	state_machine.remove("fight_spirit_hecheng_confirm_open")
	state_machine.remove("fight_spirit_hecheng_confirm_close")
	state_machine.remove("fight_spirit_hecheng_confirm_show")
	state_machine.remove("fight_spirit_hecheng_confirm_hide")
	state_machine.remove("fight_spirit_hecheng_confirm_window_ok")
end

function FightSpiritCell4Confirm:close()
	-- window event : close.
	
end

function FightSpiritCell4Confirm:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
