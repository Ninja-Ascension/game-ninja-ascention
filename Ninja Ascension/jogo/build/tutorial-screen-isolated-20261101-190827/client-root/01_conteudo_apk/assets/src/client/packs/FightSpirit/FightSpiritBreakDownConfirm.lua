FightSpiritBreakDownConfirm = class("FightSpiritBreakDownConfirmClass", Window)

-- 打开窗口
local fight_spirit_break_confirm_window_open_terminal = {
	_name = "fight_spirit_break_confirm_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FightSpiritBreakDownConfirmClass") then
			fwin:open(FightSpiritBreakDownConfirm:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fight_spirit_break_confirm_window_close_terminal = {
	_name = "fight_spirit_break_confirm_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritBreakDownConfirmClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_break_confirm_window_open_terminal)
state_machine.add(fight_spirit_break_confirm_window_close_terminal)
state_machine.init()

-- 构造器
function FightSpiritBreakDownConfirm:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fight spirit zh att page state machine.
	local function init_fight_spirit_break_confirm_terminal()
		-- 打开角色创建窗口
		local fight_spirit_break_confirm_open_terminal = {
			_name = "fight_spirit_break_confirm_open",
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
		local fight_spirit_break_confirm_close_terminal = {
			_name = "fight_spirit_break_confirm_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("fight_spirit_break_confirm_window_close", nil, {})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local fight_spirit_break_confirm_show_terminal = {
			_name = "fight_spirit_break_confirm_show",
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
		local fight_spirit_break_confirm_hide_terminal = {
			_name = "fight_spirit_break_confirm_hide",
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
		local fight_spirit_break_confirm_ok_terminal = {
			_name = "fight_spirit_break_confirm_ok",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local function responseCallback(response)
        			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("fight_spirit_break_confirm_close",0,{})
						state_machine.excute("fight_spirit_break_down_window_close", nil, {})
						state_machine.excute("fight_spirit_main_update_detail", 0, {})
						state_machine.excute("fight_spirit_awake_update", 0, {})
						app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
						fwin:open(getRewardWnd,fwin._ui)
        			end
        		end
        		local materials = instance.params.materials
        		local str = ""
        		for i = 1, 5 do
        			local fightSpirit = materials[i]
        			if fightSpirit then
        				str = str .. fightSpirit.id
        			else
        				str = str .. -1
        			end
        			if i ~= 5 then
        				str = str .. "\r\n"
        			end
        		end
				protocol_command.fight_spirit_break_down.param_list = ""..str
    			NetworkManager:register(protocol_command.fight_spirit_break_down.code, nil, nil, nil, nil, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(fight_spirit_break_confirm_open_terminal)
		state_machine.add(fight_spirit_break_confirm_close_terminal)
		state_machine.add(fight_spirit_break_confirm_show_terminal)
		state_machine.add(fight_spirit_break_confirm_hide_terminal)
		state_machine.add(fight_spirit_break_confirm_ok_terminal)
		state_machine.init()
	end
	-- call func init fight spirit zh att state machine.
	init_fight_spirit_break_confirm_terminal()
end

-- 对象初始化
function FightSpiritBreakDownConfirm:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function FightSpiritBreakDownConfirm:onInit(params)
	self.params = params._datas
end

function FightSpiritBreakDownConfirm:onUpdateDraw()
	local root = self.roots[1]

	local retMaterials = {}

	local materials = self.params.materials
	local totalExp = 0
	local awakeQualitys = zstring.split(dms.string(dms["play_config"], 236, pirates_config.param), ",")
	local awakeCosts = zstring.split(dms.string(dms["play_config"], 232, pirates_config.param), "!")
	for i,fightSpirit in ipairs(materials) do
		totalExp = totalExp + fightSpirit.currentExp
		local row = dms.searchs(dms["fight_spirit_strengthen_mould"], fight_spirit_strengthen_mould.quality, fightSpirit.quality,
			fight_spirit_strengthen_mould.cur_lev, fightSpirit.level)[1]
		local exp = dms.atof(row, fight_spirit_strengthen_mould.total_exp)
		totalExp = totalExp + exp

		local awakenIndex
		for i,v in ipairs(awakeQualitys) do
			local t = zstring.split(v, "|", function (value) return tonumber(value) end)
			if t[2] == fightSpirit.quality then
				awakenIndex = i
				break
			end
		end

		if awakenIndex then
			local returnRate = tonumber(zstring.split(dms.string(dms["play_config"], 237, pirates_config.param), ",")[1])
			local costInfo = {}
			local costsStr = awakeCosts[awakenIndex]
			local costsStr1 = zstring.split(costsStr, "|")
			for i,str in ipairs(costsStr1) do
				local info = zstring.split(str, ",", function (value) return tonumber(value) end)
				if not costInfo[info[2]] then
					costInfo[info[2]] = info[3]
				else
					costInfo[info[2]] = costInfo[info[2]] + info[3]
				end
			end
			for id,num in pairs(costInfo) do
				local num1 = math.floor(num * returnRate)
				if num1 > 0 then
					table.insert(retMaterials,{6, id, num1})
				end
			end
		end
	end

	local totalExp2 = totalExp
	local fightStoneInfo = zstring.split(dms.string(dms["play_config"], 228, pirates_config.param), "|")
	for i = #fightStoneInfo ,1, -1 do
		local info = zstring.split(fightStoneInfo[i], ",")
		local id = tonumber(info[2])
		local exp = tonumber(zstring.split(info[3], ":")[2])
		local num = math.floor(totalExp / exp)
		if num > 0 then
			table.insert(retMaterials,{6, id, num})
			totalExp = totalExp - exp * num
		end
	end

	local info = zstring.split(dms.string(dms["play_config"], 230, pirates_config.param), ",", function (value) return tonumber(value) end)
	table.insert(retMaterials,{info[1], info[2], #materials * tonumber(info[3])})

	local costSilver = zstring.split(dms.string(dms["play_config"], 229, pirates_config.param), ",")[3]
	table.insert(retMaterials,{1, -1, totalExp2 * tonumber(costSilver)})

	for i = #retMaterials, 2, -1 do
		for j = i - 1, 1, -1 do
			local info1 = retMaterials[i]
			local info2 = retMaterials[j]
			if info1[1] == info2[1] and info1[2] == info2[2] then
				retMaterials[j][3] = retMaterials[j][3] + retMaterials[i][3]
				table.remove(retMaterials, i)
				break
			end
		end
	end

	local lineNum = 5
	local listview = ccui.Helper:seekWidgetByName(root, "ListView_1")
	listview:removeAllChildren()
	for i = 1, math.ceil(#retMaterials / lineNum) do
		local layout = ccui.Layout:create()
		layout:setContentSize(listview:getContentSize().width, 120)
		for j = 1, lineNum do
			local index = (i - 1) * lineNum + j
			if index > #retMaterials then
				break
			end
			local v = retMaterials[index]
			local cell = ResourcesIconCell:createCell()
			cell:init(v[1],v[3],v[2],nil,nil,true,true,1)
			cell:setPositionX((j-1) * 120)
			layout:addChild(cell)
		end
		listview:addChild(layout)
	end
end

function FightSpiritBreakDownConfirm:onEnterTransitionFinish()
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_bd_obtain.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fight_spirit_break_confirm_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qd"), nil,
	{
		terminal_name = "fight_spirit_break_confirm_ok",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qx"), nil,
	{
		terminal_name = "fight_spirit_break_confirm_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	
	self:onUpdateDraw()
end

function FightSpiritBreakDownConfirm:onExit()
	-- 释放FightSpiritBreakDownConfirmWindow界面资源.
	state_machine.remove("fight_spirit_break_confirm_open")
	state_machine.remove("fight_spirit_break_confirm_close")
	state_machine.remove("fight_spirit_break_confirm_show")
	state_machine.remove("fight_spirit_break_confirm_hide")
	state_machine.remove("fight_spirit_break_confirm_ok")
end

function FightSpiritBreakDownConfirm:close()
	-- window event : close.
	
end

function FightSpiritBreakDownConfirm:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
