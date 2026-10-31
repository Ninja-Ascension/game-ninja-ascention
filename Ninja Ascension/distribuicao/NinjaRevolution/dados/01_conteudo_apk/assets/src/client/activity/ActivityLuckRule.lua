--[[ ----------------------------------------------------------------------------
-- 幸运占卜活动规则界面
--]] ----------------------------------------------------------------------------
ActivityLuckRule = class("ActivityLuckRuleClass", Window)

-- 打开窗口
local activity_luck_rule_window_open_terminal = {
	_name = "activity_luck_rule_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("ActivityLuckRuleClass") then
			fwin:open(ActivityLuckRule:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local activity_luck_rule_window_close_terminal = {
	_name = "activity_luck_rule_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ActivityLuckRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(activity_luck_rule_window_open_terminal)
state_machine.add(activity_luck_rule_window_close_terminal)
state_machine.init()

-- 构造器
function ActivityLuckRule:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize activity luck rule page state machine.
	local function init_activity_luck_rule_terminal()
		-- 打开角色创建窗口
		local activity_luck_rule_open_terminal = {
			_name = "activity_luck_rule_open",
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
		local activity_luck_rule_close_terminal = {
			_name = "activity_luck_rule_close",
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
		local activity_luck_rule_show_terminal = {
			_name = "activity_luck_rule_show",
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
		local activity_luck_rule_hide_terminal = {
			_name = "activity_luck_rule_hide",
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

		state_machine.add(activity_luck_rule_open_terminal)
		state_machine.add(activity_luck_rule_close_terminal)
		state_machine.add(activity_luck_rule_show_terminal)
		state_machine.add(activity_luck_rule_hide_terminal)
		state_machine.init()
	end
	-- call func init activity luck rule state machine.
	init_activity_luck_rule_terminal()
end

-- 对象初始化
function ActivityLuckRule:init(params)
	self.isFortuneCat = params._datas.isFortuneCat or nil
	self.activityId = params._datas.activityId or nil
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function ActivityLuckRule:onUpdateDraw()
	local root = self.roots[1]

	-- 活动规则列表
	self.ScrollView_luck_rule = ccui.Helper:seekWidgetByName(root, "ScrollView_luck_rule")

	-- -- 活动规则文本
	-- self.Text_luck_content = ccui.Helper:seekWidgetByName(root, "Text_luck_content")

	-- local texts_info = zstring.split(zstring.exchangeFrom(WordMould.load(5002650):getText()), "\r\n")
	-- local index = 0
	-- local font_name = self.Text_luck_content:getFontName()
	-- local _richText_combination = {}
	-- for i=1,#texts_info do
	-- 	--^##^
	-- 	local _richText = ccui.RichText:create()
	-- 	_richText:ignoreContentAdaptWithSize(false)
		
	-- 	_richText:setAnchorPoint(cc.p(0, 0))
	-- 	local char_str = texts_info[i]
	-- 	if self.Text_luck_content:getContentSize().width > 0 then
	-- 		_richText:setContentSize(cc.size(self.Text_luck_content:getContentSize().width, 0))
	-- 	else
	-- 		_richText:setContentSize(cc.size(500, 0))
	-- 	end
	-- 	local baseColor = cc.c3b(117, 75, 50)
	-- 	local rt, count, text = draw.richTextCollectionMethod(_richText, 
	-- 		char_str, 
	-- 		baseColor,
	-- 		baseColor,
	-- 		0, 
	-- 		0, 
	-- 		font_name, 
	-- 		self.Text_luck_content:getFontSize(),
	-- 		config_res.chat_rich_text.color)
	-- 	_richText:formatTextExt()
	-- 	local rsize = _richText:getContentSize()
	-- 	_richText:setPositionY(self.Text_luck_content:getContentSize().height-index)
	-- 	self.Text_luck_content:addChild(_richText)
	-- 	--^#^
	-- 	index = index + rsize.height+5
	-- end
	-- local newHeight = 0
	-- local addNumber = 0
	-- newHeight = index+self.Text_luck_content:getFontSize()
	-- if newHeight > self.Text_luck_content:getContentSize().height then
	-- 	newHeight = index+self.Text_luck_content:getFontSize()
	-- 	addNumber = newHeight - self.Text_luck_content:getContentSize().height
	-- else
	-- 	newHeight = self.Text_luck_content:getContentSize().height
	-- end
	-- self.Text_luck_content:setString("")
	-- self.Panel_luck_table = ccui.Helper:seekWidgetByName(root, "Panel_luck_table")
	-- self.Panel_luck_table:setPositionY(0-newHeight)
	
	-- local Panel_luck_form = ccui.Helper:seekWidgetByName(root, "Panel_luck_form")
	-- local startPos = 223.00
	-- for i, v in pairs(_ED.activityLuckInfo.taskList) do
		
	-- 	local cell = Panel_luck_form:clone()
	-- 	local Text_luck_form_number = ccui.Helper:seekWidgetByName(cell, "Text_luck_form_number")
	-- 	Text_luck_form_number:setString(v.rewardStr.."次")
	-- 	local Text_luck_form_diamond = ccui.Helper:seekWidgetByName(cell, "Text_luck_form_diamond")
	-- 	Text_luck_form_diamond:setString(v.targetValue)
	-- 	cell:setPositionY(startPos)
	-- 	self.Panel_luck_table:addChild(cell)
	-- 	startPos = startPos - 40
	-- end
	-- 消耗钻石数值
	-- self.Text_luck_form_diamond = ccui.Helper:seekWidgetByName(root, "Text_luck_form_diamond")

	-- 次数数值
	-- self.Text_luck_form_number = ccui.Helper:seekWidgetByName(root, "Text_luck_form_number")

end

function ActivityLuckRule:drawCatView()
	local root = self.roots[1]

    -- 活动规则列表
	self.ScrollView_luck_rule = ccui.Helper:seekWidgetByName(root, "ScrollView_luck_rule")

	-- -- 活动规则文本
	-- self.Text_luck_content = ccui.Helper:seekWidgetByName(root, "Text_luck_content")

	-- local texts_info = zstring.split(zstring.exchangeFrom(WordMould.load(5002700):getText()), "\r\n")
	-- local index = 0
	-- local font_name = self.Text_luck_content:getFontName()
	-- local _richText_combination = {}
	-- for i=1,#texts_info do
	-- 	--^##^
	-- 	local _richText = ccui.RichText:create()
	-- 	_richText:ignoreContentAdaptWithSize(false)
		
	-- 	_richText:setAnchorPoint(cc.p(0, 0))
	-- 	local char_str = texts_info[i]
	-- 	if self.Text_luck_content:getContentSize().width > 0 then
	-- 		_richText:setContentSize(cc.size(self.Text_luck_content:getContentSize().width, 0))
	-- 	else
	-- 		_richText:setContentSize(cc.size(500, 0))
	-- 	end
	-- 	local baseColor = cc.c3b(117, 75, 50)
	-- 	local rt, count, text = draw.richTextCollectionMethod(_richText, 
	-- 		char_str, 
	-- 		baseColor,
	-- 		baseColor,
	-- 		0, 
	-- 		0, 
	-- 		font_name, 
	-- 		self.Text_luck_content:getFontSize(),
	-- 		config_res.chat_rich_text.color)
	-- 	_richText:formatTextExt()
	-- 	local rsize = _richText:getContentSize()
	-- 	_richText:setPositionY(self.Text_luck_content:getContentSize().height-index)
	-- 	self.Text_luck_content:addChild(_richText)
	-- 	--^#^
	-- 	index = index + rsize.height+5
	-- end
	-- local newHeight = 0
	-- local addNumber = 0
	-- newHeight = index+self.Text_luck_content:getFontSize()
	-- if newHeight > self.Text_luck_content:getContentSize().height then
	-- 	newHeight = index+self.Text_luck_content:getFontSize()
	-- 	addNumber = newHeight - self.Text_luck_content:getContentSize().height
	-- else
	-- 	newHeight = self.Text_luck_content:getContentSize().height
	-- end
	-- self.Text_luck_content:setString("")
	-- self.Panel_luck_table = ccui.Helper:seekWidgetByName(root, "Panel_luck_table")
	-- self.Panel_luck_table:setPositionY(0-newHeight)
	
	-- local Panel_luck_form = ccui.Helper:seekWidgetByName(root, "Panel_luck_form")
	-- local startPos = 223.00
	-- for i, v in pairs(_ED.activityInfo[""..self.activityId].taskList) do
		
	-- 	local cell = Panel_luck_form:clone()
	-- 	local Text_luck_form_number = ccui.Helper:seekWidgetByName(cell, "Text_luck_form_number")
	-- 	Text_luck_form_number:setString(v.rewardStr.."次")
	-- 	local Text_luck_form_diamond = ccui.Helper:seekWidgetByName(cell, "Text_luck_form_diamond")
	-- 	Text_luck_form_diamond:setString(v.targetValue)
	-- 	cell:setPositionY(startPos)
	-- 	self.Panel_luck_table:addChild(cell)
	-- 	startPos = startPos - 40
	-- end
end


function ActivityLuckRule:onEnterTransitionFinish()
	-- 加载ActivityLuckRuleWindow界面资源.
	-- res.activity.activity_luck_rule = res/activity/activity_luck_rule.csb
	local csbNode = csb.createNode("Lucky/activity_luck_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 确定按键
	self.Button_luck_confirm = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil,
	{
		terminal_name = "activity_luck_rule_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self.Text_luck_diamond = ccui.Helper:seekWidgetByName(root, "Text_luck_diamond")

	self.Text_fortune_money = ccui.Helper:seekWidgetByName(root, "Text_fortune_money")

	-- if self.isFortuneCat ~= nil and self.isFortuneCat == true then
	-- 	self.Text_luck_diamond:setVisible(false)
	-- 	self.Text_fortune_money:setVisible(true)
	-- 	self:drawCatView()
	-- else
	-- 	self.Text_luck_diamond:setVisible(true)
	-- 	self.Text_fortune_money:setVisible(false)
	-- 	self:onUpdateDraw()
	-- end
end

function ActivityLuckRule:onExit()
	-- 释放ActivityLuckRuleWindow界面资源.
	state_machine.remove("activity_luck_rule_open")
	state_machine.remove("activity_luck_rule_close")
	state_machine.remove("activity_luck_rule_show")
	state_machine.remove("activity_luck_rule_hide")
end

function ActivityLuckRule:close()
	-- window event : close.
	
end

function ActivityLuckRule:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
