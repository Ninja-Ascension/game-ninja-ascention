--[[ ----------------------------------------------------------------------------
-- 技能详情弹窗
--]] ----------------------------------------------------------------------------
MythicalAnimalsSkillTip = class("MythicalAnimalsSkillTipClass", Window)

-- 打开窗口
local mythical_animals_skill_tip_window_open_terminal = {
	_name = "mythical_animals_skill_tip_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("MythicalAnimalsSkillTipClass") then
			fwin:open(MythicalAnimalsSkillTip:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local mythical_animals_skill_tip_window_close_terminal = {
	_name = "mythical_animals_skill_tip_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("MythicalAnimalsSkillTipClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_skill_tip_window_open_terminal)
state_machine.add(mythical_animals_skill_tip_window_close_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsSkillTip:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize lim pool rule page state machine.
	local function init_mythical_animals_skill_tip_terminal()
		-- 打开角色创建窗口
		local mythical_animals_skill_tip_open_terminal = {
			_name = "mythical_animals_skill_tip_open",
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
		local mythical_animals_skill_tip_close_terminal = {
			_name = "mythical_animals_skill_tip_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("mythical_animals_skill_tip_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local mythical_animals_skill_tip_show_terminal = {
			_name = "mythical_animals_skill_tip_show",
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
		local mythical_animals_skill_tip_hide_terminal = {
			_name = "mythical_animals_skill_tip_hide",
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

		state_machine.add(mythical_animals_skill_tip_open_terminal)
		state_machine.add(mythical_animals_skill_tip_close_terminal)
		state_machine.add(mythical_animals_skill_tip_show_terminal)
		state_machine.add(mythical_animals_skill_tip_hide_terminal)
		state_machine.init()
	end
	-- call func init lim pool rule state machine.
	init_mythical_animals_skill_tip_terminal()
end

-- 对象初始化
function MythicalAnimalsSkillTip:init(params)
	self._animalsMouldId = params

	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function MythicalAnimalsSkillTip:onUpdateDraw()
	local root = self.roots[1]

	self.Text_animal_name = ccui.Helper:seekWidgetByName(root, "Text_animal_name")

	self.Panel_skill_icon = ccui.Helper:seekWidgetByName(root, "Panel_skill_icon")

	self.Text_animal_cost = ccui.Helper:seekWidgetByName(root, "Text_animal_cost")

	self.Text_skill_cd_0 = ccui.Helper:seekWidgetByName(root, "Text_skill_cd_0")

	self.Text_tips = ccui.Helper:seekWidgetByName(root, "Text_tips")

	self.ScrollView_1 = ccui.Helper:seekWidgetByName(root, "ScrollView_1")

	self:updateUI()
end

function MythicalAnimalsSkillTip:updateUI()
	local name = MythicalAnimalsHandle.getAnimalsNameById(self._animalsMouldId)
	self.Text_animal_name:setString(name)

	local info = MythicalAnimalsHandle.getAnimalsSkillInfoById(self._animalsMouldId)

	local talentMouldId = info.talentMouldId
	local coolRound = info.coolRound
	local needAnger = info.needAnger

	self.Text_animal_cost:setString(needAnger)
	self.Text_skill_cd_0:setString(string.format(tipStringInfo_magical_animals_word[10], coolRound))
	self.Text_tips:setString(string.format(tipStringInfo_magical_animals_word[9], name))

	self.Panel_skill_icon:removeAllChildren(true)
	local cell = state_machine.excute("mythical_animals_skill_icon_cell_create", 0, {index = nil, animalsMouldId = self._animalsMouldId, isCanDrag = false})
	self.Panel_skill_icon:addChild(cell)

	self:updateScrollView()
end

function MythicalAnimalsSkillTip:getSkillList()
	local skillListStr = dms.string(dms["magical_animals_mould"], self._animalsMouldId, magical_animals_mould.skillList)
	local skillList = zstring.split(skillListStr, "|")
	return skillList
end

function MythicalAnimalsSkillTip:updateScrollView()
	local tSortedHeroes = self:getSkillList()

	local m_ScrollView = self.ScrollView_1
	m_ScrollView:removeAllChildren(true)

	local panel = m_ScrollView:getInnerContainer()
	panel:setContentSize(m_ScrollView:getContentSize())
	panel:setPosition(cc.p(0,0))
	panel:removeAllChildren(true)

	local sSize = panel:getContentSize()
	local sHeight = sSize.height
	local sWidth = sSize.width
	local controlSize = m_ScrollView:getInnerContainerSize()
	local nextY = sSize.height
	local nextX = sSize.width
	local tHeight = 0
	local cellHeight = 0
	local tWidth = 0
	local wPosition = sWidth/1

	local curStar = MythicalAnimalsHandle.getMythicalAnimalsStarById(self._animalsMouldId)

	local totalHeight = 0
	local cellList = {}
	for i, v in ipairs(tSortedHeroes) do
		local cell = state_machine.excute("mythical_animals_skill_tip_cell_create", 0, {index = i, talentMouldId = v, curStar = curStar})
		local realCellHeight = cell._cellHeight
		totalHeight = totalHeight + realCellHeight

		table.insert(cellList, {cell = cell, realCellHeight = realCellHeight})
	end

	sHeight = math.max(sHeight, totalHeight)
	panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)

	for i, v in ipairs(cellList) do
		local cell = v.cell
		local realCellHeight = v.realCellHeight

		if (i - 1) % 1 == 0 then
			tWidth = 0
			sHeight = sHeight - realCellHeight  
		end
		cell:setPosition(cc.p(tWidth, sHeight))
		panel:addChild(cell)
	end

	m_ScrollView:jumpToTop()
end

function MythicalAnimalsSkillTip:onEnterTransitionFinish()
	-- 加载MythicalAnimalsSkillTipWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_skill_info = res/cultivate/Mythical_animals/mythical_animals_skill_info.csb
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_skill_info.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Image_1_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_1_1"), nil,
	{
		terminal_name = "mythical_animals_skill_tip_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function MythicalAnimalsSkillTip:onExit()
	-- 释放MythicalAnimalsSkillTipWindow界面资源.
	state_machine.remove("mythical_animals_skill_tip_open")
	state_machine.remove("mythical_animals_skill_tip_close")
	state_machine.remove("mythical_animals_skill_tip_show")
	state_machine.remove("mythical_animals_skill_tip_hide")
end

function MythicalAnimalsSkillTip:close()
	-- window event : close.
	
end

function MythicalAnimalsSkillTip:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
