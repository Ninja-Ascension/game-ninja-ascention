FightSpiritObtain = class("FightSpiritObtainClass", Window)

-- 打开窗口
local fight_spirit_obtain_window_open_terminal = {
	_name = "fight_spirit_obtain_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FightSpiritObtainClass") then
			fwin:open(FightSpiritObtain:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fight_spirit_obtain_window_close_terminal = {
	_name = "fight_spirit_obtain_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritObtainClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_obtain_window_open_terminal)
state_machine.add(fight_spirit_obtain_window_close_terminal)
state_machine.init()

-- 构造器
function FightSpiritObtain:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.packs.FightSpirit.fightspiritobtaincell")

	-- Initialize fight spirit zh att page state machine.
	local function init_fight_spirit_obtain_terminal()
		-- 打开角色创建窗口
		local fight_spirit_obtain_open_terminal = {
			_name = "fight_spirit_obtain_open",
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
		local fight_spirit_obtain_close_terminal = {
			_name = "fight_spirit_obtain_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("fight_spirit_obtain_window_close", nil, {})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local fight_spirit_obtain_show_terminal = {
			_name = "fight_spirit_obtain_show",
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
		local fight_spirit_obtain_hide_terminal = {
			_name = "fight_spirit_obtain_hide",
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
		
		state_machine.add(fight_spirit_obtain_open_terminal)
		state_machine.add(fight_spirit_obtain_close_terminal)
		state_machine.add(fight_spirit_obtain_show_terminal)
		state_machine.add(fight_spirit_obtain_hide_terminal)
		state_machine.init()
	end
	-- call func init fight spirit zh att state machine.
	init_fight_spirit_obtain_terminal()
end

-- 对象初始化
function FightSpiritObtain:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function FightSpiritObtain:onInit(params)
	self.itemId = params.itemId
end

function FightSpiritObtain:onUpdateDraw()
	local root = self.roots[1]

	local cell = ResourcesIconCell:createCell()
	cell:init(6,0,self.itemId,nil,nil,true,true,1)
	ccui.Helper:seekWidgetByName(root, "Panel_charactor"):addChild(cell)

	local property = dms.int(dms["prop_mould"],self.itemId,prop_mould.prop_name)
	local porp_name_word = dms.element(dms["word_mould"], property)
	local porp_name = porp_name_word[3]
	ccui.Helper:seekWidgetByName(root, "Text_name"):setString(porp_name)

	ccui.Helper:seekWidgetByName(root, "Text_quanaity_0"):setString(getPropAllCountByMouldId(self.itemId))

	local listview = ccui.Helper:seekWidgetByName(root, "ListView_1")
	listview:removeAllItems()
	for i = 1, 1 do
		local cell = state_machine.excute("fight_spirit_obtain_cell_create", 0, {})
		listview:addChild(cell)
	end

	listview:jumpToTop()
	listview:requestRefreshView()
end

function FightSpiritObtain:onEnterTransitionFinish()
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_obtain.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fight_spirit_obtain_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
	
	self:onUpdateDraw()
end

function FightSpiritObtain:onExit()
	-- 释放FightSpiritObtainWindow界面资源.
	state_machine.remove("fight_spirit_obtain_open")
	state_machine.remove("fight_spirit_obtain_close")
	state_machine.remove("fight_spirit_obtain_show")
	state_machine.remove("fight_spirit_obtain_hide")
end

function FightSpiritObtain:close()
	-- window event : close.
	
end

function FightSpiritObtain:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
