--[[ ----------------------------------------------------------------------------
-- 组合卡册满级界面
--]] ----------------------------------------------------------------------------
IllustrationCombineCardMaxLevel = class("IllustrationCombineCardMaxLevelClass", Window)

-- 打开窗口
local illustration_max_level_window_open_terminal = {
	_name = "illustration_max_level_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("IllustrationCombineCardMaxLevelClass") then
			fwin:open(IllustrationCombineCardMaxLevel:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local illustration_max_level_window_close_terminal = {
	_name = "illustration_max_level_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("IllustrationCombineCardMaxLevelClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(illustration_max_level_window_open_terminal)
state_machine.add(illustration_max_level_window_close_terminal)
state_machine.init()

-- 构造器
function IllustrationCombineCardMaxLevel:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	
	-- var
	self._ship_mould_id = nil
	self._is_combine_card = nil

	-- load lua files.

	-- Initialize illustration levelup page state machine.
	local function init_illustration_max_level_terminal()
		-- 打开角色创建窗口
		local illustration_max_level_open_terminal = {
			_name = "illustration_max_level_open",
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
		local illustration_max_level_close_terminal = {
			_name = "illustration_max_level_close",
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
		local illustration_max_level_show_terminal = {
			_name = "illustration_max_level_show",
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
		local illustration_max_level_hide_terminal = {
			_name = "illustration_max_level_hide",
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

		state_machine.add(illustration_max_level_open_terminal)
		state_machine.add(illustration_max_level_close_terminal)
		state_machine.add(illustration_max_level_show_terminal)
		state_machine.add(illustration_max_level_hide_terminal)
		state_machine.init()
	end
	-- call func init illustration levelup state machine.
	init_illustration_max_level_terminal()
end

function IllustrationCombineCardMaxLevel:onUpdateDraw()
	local root = self.roots[1]
	-- 卡数据
	local cardDatas = self._per_card_data
	local mouldId = cardDatas.cardMouldId

	-- 角色头像
	self.Panel_charactor = ccui.Helper:seekWidgetByName(root, "Panel_charactor")
	self.Panel_charactor:removeAllChildren(true)

	local icon = IllustrationHandle.createHeroIcon(mouldId, true)
	icon:setAnchorPoint(cc.p(0.5,0.5))
	local size = self.Panel_charactor:getContentSize()
	icon:setPosition(cc.p(size.width/2,size.height/2))
	self.Panel_charactor:addChild(icon)

	-- 角色名称
	self.Text_charactor_name = ccui.Helper:seekWidgetByName(root, "Text_charactor_name")
	local nameStr = IllustrationHandle.getCardName(mouldId, true)
	self.Text_charactor_name:setString(nameStr)

	-- 卡册评分值
	self.Text_after_1_t = ccui.Helper:seekWidgetByName(root, "Text_after_1_t")
	self.Text_after_1_t:setString(tostring(cardDatas.cardScore))

	-- 消耗,当前加成,下一级加成,本级分值加权
	local consume,curAdd,nextAdd,markAdd = IllustrationHandle.getUpLevelConsume(mouldId, cardDatas.cardStar, true)
	if curAdd and -1 ~= tonumber(curAdd) then
		local curAddDatas = zstring.split(curAdd,"|")
		for i=1,#curAddDatas do
			local datas = zstring.split(curAddDatas[i],",")
			local addType = tonumber(datas[1])
			local addVal = tonumber(datas[2])
				
			local propertyName, propertyValue = getPropertyNameAndValue(addType, addVal)

			local Text_after_n = ccui.Helper:seekWidgetByName(root, string.format("Text_after_%d_n",i + 1))
			local Text_after_t = ccui.Helper:seekWidgetByName(root, string.format("Text_after_%d_t",i + 1))

			Text_after_n:setString(propertyName)
			Text_after_t:setString(propertyValue)
		end
	else
		for i = 1, 3 do
			local Text_after_n = ccui.Helper:seekWidgetByName(root, string.format("Text_after_%d_n",i + 1))
			local Text_after_t = ccui.Helper:seekWidgetByName(root, string.format("Text_after_%d_t",i + 1))

			Text_after_n:setVisible(false)
			Text_after_t:setVisible(false)
		end
	end
end

function IllustrationCombineCardMaxLevel:onEnterTransitionFinish()
	-- 加载IllustrationCombineCardMaxLevelWindow界面资源.
	-- res.cultivate.illustration.illustration_levelup_max = res/cultivate/illustration/illustration_levelup_max.csb
	local csbNode = csb.createNode("cultivate/illustration/illustration_levelup_max.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "illustration_max_level_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

-- 对象初始化
function IllustrationCombineCardMaxLevel:init(params)
	self._per_card_data = params[1]
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function IllustrationCombineCardMaxLevel:onExit()
	-- 释放IllustrationCombineCardMaxLevelWindow界面资源.
	state_machine.remove("illustration_max_level_open")
	state_machine.remove("illustration_max_level_close")
	state_machine.remove("illustration_max_level_show")
	state_machine.remove("illustration_max_level_hide")
end

function IllustrationCombineCardMaxLevel:close()
	-- window event : close.
	
end

function IllustrationCombineCardMaxLevel:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
