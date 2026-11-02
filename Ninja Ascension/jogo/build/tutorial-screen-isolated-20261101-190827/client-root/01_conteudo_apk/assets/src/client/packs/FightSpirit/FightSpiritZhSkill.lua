--[[ ----------------------------------------------------------------------------
-- 战魂技能
--]] ----------------------------------------------------------------------------
FightSpiritZhSkill = class("FightSpiritZhSkillClass", Window)

-- 打开窗口
local fight_spirit_zh_skill_window_open_terminal = {
	_name = "fight_spirit_zh_skill_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FightSpiritZhSkillClass") then
			fwin:open(FightSpiritZhSkill:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fight_spirit_zh_skill_window_close_terminal = {
	_name = "fight_spirit_zh_skill_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritZhSkillClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_zh_skill_window_open_terminal)
state_machine.add(fight_spirit_zh_skill_window_close_terminal)
state_machine.init()

-- 构造器
function FightSpiritZhSkill:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fight spirit zh att page state machine.
	local function init_fight_spirit_zh_skill_terminal()
		-- 打开角色创建窗口
		local fight_spirit_zh_skill_open_terminal = {
			_name = "fight_spirit_zh_skill_open",
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
		local fight_spirit_zh_skill_close_terminal = {
			_name = "fight_spirit_zh_skill_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("fight_spirit_zh_skill_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local fight_spirit_zh_skill_show_terminal = {
			_name = "fight_spirit_zh_skill_show",
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
		local fight_spirit_zh_skill_hide_terminal = {
			_name = "fight_spirit_zh_skill_hide",
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

		state_machine.add(fight_spirit_zh_skill_open_terminal)
		state_machine.add(fight_spirit_zh_skill_close_terminal)
		state_machine.add(fight_spirit_zh_skill_show_terminal)
		state_machine.add(fight_spirit_zh_skill_hide_terminal)
		state_machine.init()
	end
	-- call func init fight spirit zh att state machine.
	init_fight_spirit_zh_skill_terminal()
end

-- 对象初始化
function FightSpiritZhSkill:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function FightSpiritZhSkill:onInit(params)
	self.shipId = params.shipId
	if params._datas then
		self.suitId = params._datas.suitId
	end
end

function FightSpiritZhSkill:onUpdateDraw()
	local cell = csb.createNode("packs/FightSpirit/FightSpirit_skill_1.csb")
	cell:setPosition(268,60)
	ccui.Helper:seekWidgetByName(self.roots[1], "Panel_fight_soul"):addChild(cell)

	local root = cell:getChildByName("root")

	local suitId
	local info
	if self.shipId then
		info = FightSpiritHandle:getShipFightSpiritAttributeById(self.shipId)
		suitId = info.suit4Id
	else
		suitId = self.suitId
	end

	local iconContainer = ccui.Helper:seekWidgetByName(root, "Panel_skill_icon")
	local icon1 = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", 7))
	icon1:setAnchorPoint(cc.p(0,0))
	iconContainer:addChild(icon1)
	local propId = dms.string(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.prop_id)
	local icon2 = cc.Sprite:create(string.format("images/ui/props/props_%d.png", propId))
	iconContainer:addChild(icon2)
	icon2:setPosition(60,60)

	local name = dms.element(dms["word_mould"], 
		dms.int(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.suit_name))[3]
	ccui.Helper:seekWidgetByName(root, "Text_name"):setString(name)
	ccui.Helper:seekWidgetByName(root, "Text_skill_cd"):setString(string.format(tipStringInfo_fight_spirit[8], name))
	ccui.Helper:seekWidgetByName(root, "Button_lock"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Button_unlock"):setVisible(false)

	local listview = ccui.Helper:seekWidgetByName(root, "ListView_1")
	listview:removeAllItems()

	local totalHeight = 0

	function createLabel()
		local label = csb.createNode("packs/FightSpirit/FightSpirit_skill_list_4.csb")
		return label:getChildByName("root")
	end

	function addLabel(label, height)
		local layout = ccui.Layout:create()
		layout:setContentSize(listview:getContentSize().width, height)
		layout:addChild(label)
		listview:addChild(layout)
		totalHeight = totalHeight + height
	end

	local skillDescs = dms.string(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.skill)
	local descs = zstring.split(skillDescs, "|")
	for i,v in ipairs(descs) do
		local labelRoot = createLabel()
		local label = ccui.Helper:seekWidgetByName(labelRoot, "Text_skill")
		local skillDescs = zstring.split(v, ",")
		local skillNameId = dms.string(dms["talent_mould"], skillDescs[2], talent_mould.talent_describe)
    	local word_info = dms.element(dms["word_mould"], skillNameId)
		label:setString(word_info[3])

		local fontColor = cc.c3b(tipStringInfo_fight_spirit[31][1], tipStringInfo_fight_spirit[31][2], tipStringInfo_fight_spirit[31][3])
		if info and info.suit4Quality == i then
	    	label:setColor(fontColor)
	    end

		local autoRenderSize = label:getAutoRenderSize()
		local virtualRendererSize = label:getVirtualRendererSize()
		local needRowNumber = math.ceil(autoRenderSize.width / virtualRendererSize.width)
	    local currRowNumber = math.floor(virtualRendererSize.height / autoRenderSize.height)
	    local curHeight = 0
	    
		curHeight = needRowNumber * autoRenderSize.height + label:getFontSize() + 10
		
		label:setContentSize(label:getContentSize().width, curHeight)
		-- DSC重塑
		local addHeight = 0
		if __lua_project_id == __lua_project_l_digital then 
			local pixHeight = (labelRoot:getContentSize().height - ccui.Helper:seekWidgetByName(labelRoot, "Text_colour"):getPositionY()) * 2
			curHeight = curHeight + pixHeight 
			addHeight = labelRoot:getContentSize().height - curHeight
		end
		
	    if i <= 5 then
	    	ccui.Helper:seekWidgetByName(labelRoot, "Text_colour"):setColor(cc.c3b(_quality_color[i+1][1], _quality_color[i+1][2], _quality_color[i+1][3]))
			ccui.Helper:seekWidgetByName(labelRoot, "Text_colour"):setString(tipStringInfo_fight_spirit_quality[i])
			-- DSC重塑
			if __lua_project_id == __lua_project_l_digital then 
				local colorPosY = ccui.Helper:seekWidgetByName(labelRoot, "Text_colour"):getPositionY()
				ccui.Helper:seekWidgetByName(labelRoot, "Text_colour"):setPositionY(colorPosY-addHeight)
			else
				ccui.Helper:seekWidgetByName(labelRoot, "Text_colour"):setPositionY(curHeight / 2)
			end
	    	ccui.Helper:seekWidgetByName(labelRoot, "Image_ws"):setVisible(false)
		else
			-- DSC重塑
			if __lua_project_id == __lua_project_l_digital then 
				local colorPosY = ccui.Helper:seekWidgetByName(labelRoot, "Image_ws"):getPositionY()
				ccui.Helper:seekWidgetByName(labelRoot, "Image_ws"):setPositionY(colorPosY-addHeight)
			else
				ccui.Helper:seekWidgetByName(labelRoot, "Image_ws"):setPositionY(curHeight / 2)
			end
	    	ccui.Helper:seekWidgetByName(labelRoot, "Text_colour"):setVisible(false)
		end
		
		-- DSC重塑
		if __lua_project_id == __lua_project_l_digital then 
			addLabel(labelRoot:getParent(), curHeight)
		else
			addLabel(labelRoot:getParent(), label:getContentSize().height + 12)
		end

	end

	listview:jumpToTop()
	listview:requestRefreshView()
end

function FightSpiritZhSkill:onEnterTransitionFinish()
	-- 加载FightSpiritZhSkillWindow界面资源.
	-- res.cocostudio.packs.FightSpirit_zh_skill = res/packs/FightSpirit/FightSpirit_zh_skill.csb
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_skill.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	ccui.Helper:seekWidgetByName(root, "Panel_fight_soul"):setSwallowTouches(false)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_1_1"), nil,
	{
		terminal_name = "fight_spirit_zh_skill_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	
	self:onUpdateDraw()
end

function FightSpiritZhSkill:onExit()
	-- 释放FightSpiritZhSkillWindow界面资源.
	state_machine.remove("fight_spirit_zh_skill_open")
	state_machine.remove("fight_spirit_zh_skill_close")
	state_machine.remove("fight_spirit_zh_skill_show")
	state_machine.remove("fight_spirit_zh_skill_hide")
end

function FightSpiritZhSkill:close()
	-- window event : close.
	
end

function FightSpiritZhSkill:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
