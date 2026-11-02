--[[ ----------------------------------------------------------------------------
-- 战魂分解界面
--]] ----------------------------------------------------------------------------
FightSpiritBreakDown = class("FightSpiritBreakDownClass", Window)

-- 打开窗口
local fight_spirit_break_down_window_open_terminal = {
	_name = "fight_spirit_break_down_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FightSpiritBreakDownClass") then
			fwin:open(FightSpiritBreakDown:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fight_spirit_break_down_window_close_terminal = {
	_name = "fight_spirit_break_down_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritBreakDownClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_break_down_window_open_terminal)
state_machine.add(fight_spirit_break_down_window_close_terminal)
state_machine.init()

-- 构造器
function FightSpiritBreakDown:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._hcFightSpiritIds = {0,0,0,0,0}

	-- load lua files.
	app.load("client.packs.FightSpirit.FightSpiritSelect")

	-- Initialize fight spirit break down page state machine.
	local function init_fight_spirit_break_down_terminal()
		-- 打开角色创建窗口
		local fight_spirit_break_down_open_terminal = {
			_name = "fight_spirit_break_down_open",
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
		local fight_spirit_break_down_close_terminal = {
			_name = "fight_spirit_break_down_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("fight_spirit_break_down_window_close", 0, {})	
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local fight_spirit_break_down_show_terminal = {
			_name = "fight_spirit_break_down_show",
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
		local fight_spirit_break_down_hide_terminal = {
			_name = "fight_spirit_break_down_hide",
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

		-- 一键装备
		local fight_spirit_break_down_one_key_equip_terminal = {
			_name = "fight_spirit_break_down_one_key_equip",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:oneKeyEquip()
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 点击战魂材料图标
		local fight_spirit_break_down_click_material_terminal = {
			_name = "fight_spirit_break_down_click_material",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				params._datas.hcFightSpiritIds = instance._hcFightSpiritIds
				params._datas.selectType = 2
				state_machine.excute("fight_spirit_select_window_open", 0, params)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 打开分解确认
		local fight_spirit_break_down_open_confirm_terminal = {
			_name = "fight_spirit_break_down_open_confirm",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local materials = {}
				for i,id in ipairs(instance._hcFightSpiritIds) do
					if id > 0 then
						table.insert(materials, FightSpiritHandle.getFightSpiritById(id))
					end
				end
				if #materials == 0 then
					TipDlg.drawTextDailog(tipStringInfo_fight_spirit[22])
					return
				end
				state_machine.excute("fight_spirit_break_confirm_window_open", 0, 
				{
					_datas = {
						materials = materials,
					}
				})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(fight_spirit_break_down_open_terminal)
		state_machine.add(fight_spirit_break_down_close_terminal)
		state_machine.add(fight_spirit_break_down_show_terminal)
		state_machine.add(fight_spirit_break_down_hide_terminal)
		state_machine.add(fight_spirit_break_down_one_key_equip_terminal)
		state_machine.add(fight_spirit_break_down_click_material_terminal)
		state_machine.add(fight_spirit_break_down_open_confirm_terminal)
		state_machine.init()
	end
	-- call func init fight spirit break down state machine.
	init_fight_spirit_break_down_terminal()
end

-- 对象初始化
function FightSpiritBreakDown:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function FightSpiritBreakDown:setHcFightSpirit(fightSpiritId, pos)
	self._hcFightSpiritIds[pos] = fightSpiritId
	self:updateSingleHechengFightSpirit(pos)
end

function FightSpiritBreakDown:updateSingleHechengFightSpirit(pos)
	ccui.Helper:seekWidgetByName(self.roots[1], "Button_add_"..pos):removeAllChildren()
	
	if self._hcFightSpiritIds[pos] > 0 then
		local fightSpirit = FightSpiritHandle.getFightSpiritById(self._hcFightSpiritIds[pos])
		local cell = ResourcesIconCell:createCell()
		cell:init(73,nil,nil,nil,nil,nil,nil,nil,{fightSpirit=fightSpirit})
		ccui.Helper:seekWidgetByName(self.roots[1], "Button_add_"..pos):addChild(cell)
		ccui.Helper:seekWidgetByName(cell, "Panel_prop"):setTouchEnabled(false)
	end
end

function FightSpiritBreakDown:oneKeyEquip()
	local isFull = true
	for i = 1, 5 do
		if self._hcFightSpiritIds[i] <= 0 then
			isFull = false
			break
		end
	end

	if isFull then
		TipDlg.drawTextDailog(tipStringInfo_fight_spirit[29])
		return
	end

	local unequipedFightSpirits = {}
	local allFightSpirits = FightSpiritHandle.getAllFightSpiritsList()
	for i,fightSpirit in ipairs(allFightSpirits) do
		if fightSpirit.shipId <= 0 and fightSpirit.quality >= 5 and fightSpirit.lockStatus == 0 then
			table.insert(unequipedFightSpirits, fightSpirit)
		end
	end

	table.sort(unequipedFightSpirits, function (a, b)
		local aSuitId = dms.int(dms["fight_spirit_mould"], a.mouldId, fight_spirit_mould.suit_id)
		local bSuitId = dms.int(dms["fight_spirit_mould"], b.mouldId, fight_spirit_mould.suit_id)
		if a.quality ~= b.quality then
			return a.quality < b.quality
		else
			if a.level ~= b.level then
				return a.level < b.level
			else
				if aSuitId ~= bSuitId then
					return aSuitId > bSuitId
				else
					return a.createTime < b.createTime
				end
			end
		end
	end)

	for i = 1, 5 do
		if unequipedFightSpirits[i] then
			self:setHcFightSpirit(unequipedFightSpirits[i].id, i)
		else
			self:setHcFightSpirit(-1, i)
			TipDlg.drawTextDailog(tipStringInfo_fight_spirit[21])
		end
	end
end

function FightSpiritBreakDown:onUpdateDraw()
	local root = self.roots[1]

end

function FightSpiritBreakDown:onEnterTransitionFinish()
	-- 加载FightSpiritBreakDownWindow界面资源.
	-- res.cocostudio.packs.FightSpirit.FightSpirit_break_down = res/packs/FightSpirit/FightSpirit/FightSpirit_break_down.csb
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_break_down.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 一键添加
	self.Button_yjtj = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yjtj"), nil,
	{
		terminal_name = "fight_spirit_break_down_one_key_equip",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 分解
	self.Button_break_down = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_break_down"), nil,
	{
		terminal_name = "fight_spirit_break_down_open_confirm",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fight_spirit_break_down_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	for i = 1, 5 do
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_add_"..i), nil, 
		{
			terminal_name = "fight_spirit_break_down_click_material", 
			terminal_state = 0, 
			pos = i,
			isPressedActionEnabled = true,
		}, nil, 0)
	end

	self:onUpdateDraw()
end

function FightSpiritBreakDown:onExit()
	-- 释放FightSpiritBreakDownWindow界面资源.
	state_machine.remove("fight_spirit_break_down_open")
	state_machine.remove("fight_spirit_break_down_close")
	state_machine.remove("fight_spirit_break_down_show")
	state_machine.remove("fight_spirit_break_down_hide")
	state_machine.remove("fight_spirit_break_down_one_key_equip")
	state_machine.remove("fight_spirit_break_down_click_material")
	state_machine.remove("fight_spirit_break_down_open_confirm")
end

function FightSpiritBreakDown:close()
	-- window event : close.
	
end

function FightSpiritBreakDown:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
