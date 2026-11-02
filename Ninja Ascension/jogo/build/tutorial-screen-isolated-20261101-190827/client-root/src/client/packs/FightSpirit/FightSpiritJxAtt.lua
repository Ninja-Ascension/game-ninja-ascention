--[[ ----------------------------------------------------------------------------
-- 战魂属性
--]] ----------------------------------------------------------------------------
FightSpiritJxAtt = class("FightSpiritJxAttClass", Window)

-- 打开窗口
local fight_spirit_jx_att_window_open_terminal = {
	_name = "fight_spirit_jx_att_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FightSpiritJxAttClass") then
			fwin:open(FightSpiritJxAtt:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fight_spirit_jx_att_window_close_terminal = {
	_name = "fight_spirit_jx_att_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritJxAttClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_jx_att_window_open_terminal)
state_machine.add(fight_spirit_jx_att_window_close_terminal)
state_machine.init()

-- 构造器
function FightSpiritJxAtt:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	
	-- Initialize fight spirit zh att page state machine.
	local function init_fight_spirit_jx_att_terminal()
		-- 打开角色创建窗口
		local fight_spirit_jx_att_open_terminal = {
			_name = "fight_spirit_jx_att_open",
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
		local fight_spirit_jx_att_close_terminal = {
			_name = "fight_spirit_jx_att_close",
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
		local fight_spirit_jx_att_show_terminal = {
			_name = "fight_spirit_jx_att_show",
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
		local fight_spirit_jx_att_hide_terminal = {
			_name = "fight_spirit_jx_att_hide",
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

		state_machine.add(fight_spirit_jx_att_open_terminal)
		state_machine.add(fight_spirit_jx_att_close_terminal)
		state_machine.add(fight_spirit_jx_att_show_terminal)
		state_machine.add(fight_spirit_jx_att_hide_terminal)
		state_machine.init()
	end
	-- call func init fight spirit zh att state machine.
	init_fight_spirit_jx_att_terminal()
end

-- 对象初始化
function FightSpiritJxAtt:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function FightSpiritJxAtt:onInit(params)
	self.mouldId = params.mouldId
	self.isAwaken = params.isAwaken
end

function FightSpiritJxAtt:onUpdateDraw()
	local root = self.roots[1]

	ccui.Helper:seekWidgetByName(root, "Text_jxsx_0_0"):setVisible(self.isAwaken)
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

	local libId = dms.int(dms["fight_spirit_mould"], self.mouldId, fight_spirit_mould.awake_lib_id)
	local rows = dms.searchs(dms["fight_spirit_talent_mould"], fight_spirit_talent_mould.lib_type, 3,
		fight_spirit_talent_mould.lib_id, libId)

	local totalHeight = 0
	local cellList = {}
	for i,row in ipairs(rows) do
		local label = csb.createNode("packs/FightSpirit/FightSpirit_jx_att_cell.csb")
		local labelRoot = label:getChildByName("root")
		local talentId = dms.atof(row, fight_spirit_talent_mould.awake_talent_id)
		local talentWordId = dms.string(dms["talent_mould"], talentId, talent_mould.talent_describe)
		local word_info = dms.element(dms["word_mould"], talentWordId)
		ccui.Helper:seekWidgetByName(labelRoot, "Text_1"):setString(word_info[3])

		local realCellHeight = labelRoot:getContentSize().height + 10
		totalHeight = totalHeight + realCellHeight

		table.insert(cellList, {cell = label, realCellHeight = realCellHeight})
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

function FightSpiritJxAtt:onEnterTransitionFinish()
	-- 加载FightSpiritJxAttWindow界面资源.
	-- res.cocostudio.packs.FightSpirit_zh_att = res/packs/FightSpirit/FightSpirit_zh_att.csb
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_jx_att.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_1_1"), nil,
	{
		terminal_name = "fight_spirit_jx_att_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	
	self:onUpdateDraw()
end

function FightSpiritJxAtt:onExit()
	-- 释放FightSpiritJxAttWindow界面资源.
	state_machine.remove("fight_spirit_jx_att_open")
	state_machine.remove("fight_spirit_jx_att_close")
	state_machine.remove("fight_spirit_jx_att_show")
	state_machine.remove("fight_spirit_jx_att_hide")
end

function FightSpiritJxAtt:close()
	-- window event : close.
	
end

function FightSpiritJxAtt:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
