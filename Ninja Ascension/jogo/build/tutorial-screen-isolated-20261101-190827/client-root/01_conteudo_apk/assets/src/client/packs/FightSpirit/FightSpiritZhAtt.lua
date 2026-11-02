--[[ ----------------------------------------------------------------------------
-- 战魂属性
--]] ----------------------------------------------------------------------------
FightSpiritZhAtt = class("FightSpiritZhAttClass", Window)

-- 打开窗口
local fight_spirit_zh_att_window_open_terminal = {
	_name = "fight_spirit_zh_att_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FightSpiritZhAttClass") then
			fwin:open(FightSpiritZhAtt:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fight_spirit_zh_att_window_close_terminal = {
	_name = "fight_spirit_zh_att_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritZhAttClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_zh_att_window_open_terminal)
state_machine.add(fight_spirit_zh_att_window_close_terminal)
state_machine.init()

-- 构造器
function FightSpiritZhAtt:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.packs.FightSpirit.fightspiritzhattcell")
	
	-- Initialize fight spirit zh att page state machine.
	local function init_fight_spirit_zh_att_terminal()
		-- 打开角色创建窗口
		local fight_spirit_zh_att_open_terminal = {
			_name = "fight_spirit_zh_att_open",
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
		local fight_spirit_zh_att_close_terminal = {
			_name = "fight_spirit_zh_att_close",
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
		local fight_spirit_zh_att_show_terminal = {
			_name = "fight_spirit_zh_att_show",
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
		local fight_spirit_zh_att_hide_terminal = {
			_name = "fight_spirit_zh_att_hide",
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

		state_machine.add(fight_spirit_zh_att_open_terminal)
		state_machine.add(fight_spirit_zh_att_close_terminal)
		state_machine.add(fight_spirit_zh_att_show_terminal)
		state_machine.add(fight_spirit_zh_att_hide_terminal)
		state_machine.init()
	end
	-- call func init fight spirit zh att state machine.
	init_fight_spirit_zh_att_terminal()
end

-- 对象初始化
function FightSpiritZhAtt:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function FightSpiritZhAtt:onInit(params)
	self.attrs = params.attrs
end

function FightSpiritZhAtt:onUpdateDraw()
	local root = self.roots[1]

	-- 战魂属性文本滚动容器
	self.ScrollView_1 = ccui.Helper:seekWidgetByName(root, "ScrollView_1")

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

	local attrKVs = {}
	for i = 0, 233 do
		if self.attrs[i] then
			table.insert(attrKVs, {k = i, v = self.attrs[i]})
		end
	end

	local lineNum = math.ceil(#attrKVs / 2)

	local totalHeight = 0
	local cellList = {}
	for i = 1, lineNum do
		local attrs = {
			attrKVs[(i-1)*2+1],
			attrKVs[(i-1)*2+2],
		}
		local cell = state_machine.excute("fight_spirit_zh_att_cell_create", 0, {attrs = attrs})
		local realCellHeight = cell:getContentSize().height + 10
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

function FightSpiritZhAtt:onEnterTransitionFinish()
	-- 加载FightSpiritZhAttWindow界面资源.
	-- res.cocostudio.packs.FightSpirit_zh_att = res/packs/FightSpirit/FightSpirit_zh_att.csb
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_zh_att.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_1_1"), nil,
	{
		terminal_name = "fight_spirit_zh_att_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	
	self:onUpdateDraw()
end

function FightSpiritZhAtt:onExit()
	-- 释放FightSpiritZhAttWindow界面资源.
	state_machine.remove("fight_spirit_zh_att_open")
	state_machine.remove("fight_spirit_zh_att_close")
	state_machine.remove("fight_spirit_zh_att_show")
	state_machine.remove("fight_spirit_zh_att_hide")
end

function FightSpiritZhAtt:close()
	-- window event : close.
	
end

function FightSpiritZhAtt:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
