--[[ ----------------------------------------------------------------------------
-- 重生选择界面
--]] ----------------------------------------------------------------------------
MythicalAnimalsRebirthChoice = class("MythicalAnimalsRebirthChoiceClass", Window)

-- 打开窗口
local mythical_animals_rebirth_choice_window_open_terminal = {
	_name = "mythical_animals_rebirth_choice_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("MythicalAnimalsRebirthChoiceClass") then
			fwin:open(MythicalAnimalsRebirthChoice:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local mythical_animals_rebirth_choice_window_close_terminal = {
	_name = "mythical_animals_rebirth_choice_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("MythicalAnimalsRebirthChoiceClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_rebirth_choice_window_open_terminal)
state_machine.add(mythical_animals_rebirth_choice_window_close_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsRebirthChoice:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize lim pool rule page state machine.
	local function init_mythical_animals_rebirth_choice_terminal()
		-- 打开角色创建窗口
		local mythical_animals_rebirth_choice_open_terminal = {
			_name = "mythical_animals_rebirth_choice_open",
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
		local mythical_animals_rebirth_choice_close_terminal = {
			_name = "mythical_animals_rebirth_choice_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("mythical_animals_rebirth_choice_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local mythical_animals_rebirth_choice_show_terminal = {
			_name = "mythical_animals_rebirth_choice_show",
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
		local mythical_animals_rebirth_choice_hide_terminal = {
			_name = "mythical_animals_rebirth_choice_hide",
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

		state_machine.add(mythical_animals_rebirth_choice_open_terminal)
		state_machine.add(mythical_animals_rebirth_choice_close_terminal)
		state_machine.add(mythical_animals_rebirth_choice_show_terminal)
		state_machine.add(mythical_animals_rebirth_choice_hide_terminal)
		state_machine.init()
	end
	-- call func init lim pool rule state machine.
	init_mythical_animals_rebirth_choice_terminal()
end

-- 对象初始化
function MythicalAnimalsRebirthChoice:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function MythicalAnimalsRebirthChoice:onUpdateDraw()
	local root = self.roots[1]

	-- 列表
	self.ScrollView_2 = ccui.Helper:seekWidgetByName(root, "ScrollView_2")

	self:updateUI()
end

function MythicalAnimalsRebirthChoice:updateUI()
	self:updateScrollView()
end

-- 获得可以重生的神兽
function MythicalAnimalsRebirthChoice:getCanRebirthList()
	local resultList = {}

 	local data = dms["magical_animals_mould"]
    for _, v in ipairs(data) do
        local id = dms.atof(v, magical_animals_mould.id)
        -- 神锻过
        if MythicalAnimalsHandle.getAnimalsHaveForgeStateById(id) == true then
            table.insert(resultList, id)
        end
    end

	return resultList
end

function MythicalAnimalsRebirthChoice:updateScrollView()
	local tSortedHeroes = self:getCanRebirthList()

	local m_ScrollView = self.ScrollView_2
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
	local wPosition = sWidth/2

	local Hlindex = 0
	local number = #tSortedHeroes
	local m_number = math.ceil(number/2)

	-- 单个cell高度是scrollview的一半
	cellHeight = m_number*(m_ScrollView:getContentSize().height/4)

	sHeight = math.max(sHeight, cellHeight)
	panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
	local first = nil
	for j, v in pairs(tSortedHeroes) do
		local cell = state_machine.excute("mythical_animals_rebirth_choice_cell_create", 0, v)
		panel:addChild(cell)

		local realCellHeight = cell:getContentSize().height
		if j == 1 then
			first = cell
		end
		tWidth = tWidth + wPosition

		if (j-1)%2 ==0 then
			Hlindex = Hlindex+1
			tWidth = 0
			tHeight = sHeight - realCellHeight*Hlindex  
		end
		cell:setPosition(cc.p(tWidth,tHeight))
	end
	m_ScrollView:jumpToTop()
end

function MythicalAnimalsRebirthChoice:onEnterTransitionFinish()
	-- 加载MythicalAnimalsRebirthChoiceWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_rebirth_choice = res/cultivate/Mythical_animals/mythical_animals_rebirth_choice.csb
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_rebirth_choice.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "mythical_animals_rebirth_choice_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self:onUpdateDraw()
end

function MythicalAnimalsRebirthChoice:onExit()
	-- 释放MythicalAnimalsRebirthChoiceWindow界面资源.
	state_machine.remove("mythical_animals_rebirth_choice_open")
	state_machine.remove("mythical_animals_rebirth_choice_close")
	state_machine.remove("mythical_animals_rebirth_choice_show")
	state_machine.remove("mythical_animals_rebirth_choice_hide")
end

function MythicalAnimalsRebirthChoice:close()
	-- window event : close.
	
end

function MythicalAnimalsRebirthChoice:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
