--[[ ----------------------------------------------------------------------------
-- 天赋详情弹窗
--]] ----------------------------------------------------------------------------
MythicalAnimalsTalentTip = class("MythicalAnimalsTalentTipClass", Window)

-- 打开窗口
local mythical_animals_talent_tip_window_open_terminal = {
	_name = "mythical_animals_talent_tip_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("MythicalAnimalsTalentTipClass") then
			fwin:open(MythicalAnimalsTalentTip:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local mythical_animals_talent_tip_window_close_terminal = {
	_name = "mythical_animals_talent_tip_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("MythicalAnimalsTalentTipClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_talent_tip_window_open_terminal)
state_machine.add(mythical_animals_talent_tip_window_close_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsTalentTip:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize lim pool rule page state machine.
	local function init_mythical_animals_talent_tip_terminal()
		-- 打开角色创建窗口
		local mythical_animals_talent_tip_open_terminal = {
			_name = "mythical_animals_talent_tip_open",
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
		local mythical_animals_talent_tip_close_terminal = {
			_name = "mythical_animals_talent_tip_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("mythical_animals_talent_tip_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local mythical_animals_talent_tip_show_terminal = {
			_name = "mythical_animals_talent_tip_show",
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
		local mythical_animals_talent_tip_hide_terminal = {
			_name = "mythical_animals_talent_tip_hide",
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

		state_machine.add(mythical_animals_talent_tip_open_terminal)
		state_machine.add(mythical_animals_talent_tip_close_terminal)
		state_machine.add(mythical_animals_talent_tip_show_terminal)
		state_machine.add(mythical_animals_talent_tip_hide_terminal)
		state_machine.init()
	end
	-- call func init lim pool rule state machine.
	init_mythical_animals_talent_tip_terminal()
end

-- 对象初始化
function MythicalAnimalsTalentTip:init(params)
	self._animalsMouldId = params

	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function MythicalAnimalsTalentTip:onUpdateDraw()
	local root = self.roots[1]

	self.Text_character = ccui.Helper:seekWidgetByName(root, "Text_character")

	self.Panel_player_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1")

	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	self.Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")

	self:updateUI()
end

function MythicalAnimalsTalentTip:updateUI()
	local name = MythicalAnimalsHandle.getAnimalsNameById(self._animalsMouldId)
	self.Text_character:setString(name)

	local curStage = MythicalAnimalsHandle.getMythicalAnimalsStageById(self._animalsMouldId)
	self.Text_1_0:setString(string.format(tipStringInfo_magical_animals_word[2], curStage))

	local curStar = MythicalAnimalsHandle.getMythicalAnimalsStarById(self._animalsMouldId)
	self.Panel_player_icon_1:removeAllChildren(true)

	local data = dms.element(dms["magical_animals_mould"], self._animalsMouldId)
	local cell = state_machine.excute("mythical_animals_icon_cell_create", 0, {index = nil, data = data, isCanTouch = false})
	self.Panel_player_icon_1:addChild(cell)

	local ListView_1 = self.ListView_1
	ListView_1:removeAllItems()

	local talentList = MythicalAnimalsHandle.getAnimalsStageTalentById(self._animalsMouldId)
	local curStage = MythicalAnimalsHandle.getMythicalAnimalsStageById(self._animalsMouldId)
	for i, v in ipairs(talentList) do
		local cell = state_machine.excute("mythical_animals_talent_tip_cell_create", 0, {index = i, talentMouldId = v, curStage = curStage})
		ListView_1:addChild(cell)
	end
end

function MythicalAnimalsTalentTip:onEnterTransitionFinish()
	-- 加载MythicalAnimalsTalentTipWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_talent_info = res/cultivate/Mythical_animals/mythical_animals_talent_info.csb
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_talent_info.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Image_1_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_1_1"), nil,
	{
		terminal_name = "mythical_animals_talent_tip_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function MythicalAnimalsTalentTip:onExit()
	-- 释放MythicalAnimalsTalentTipWindow界面资源.
	state_machine.remove("mythical_animals_talent_tip_open")
	state_machine.remove("mythical_animals_talent_tip_close")
	state_machine.remove("mythical_animals_talent_tip_show")
	state_machine.remove("mythical_animals_talent_tip_hide")
end

function MythicalAnimalsTalentTip:close()
	-- window event : close.
	
end

function MythicalAnimalsTalentTip:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
