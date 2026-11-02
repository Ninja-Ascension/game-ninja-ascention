--[[ ----------------------------------------------------------------------------
-- 卡册升级提示界面
--]] ----------------------------------------------------------------------------
IllustrationTips = class("IllustrationTipsClass", Window)

-- 打开窗口
local illustration_tips_window_open_terminal = {
	_name = "illustration_tips_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("IllustrationTipsClass") then
			fwin:open(IllustrationTips:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local illustration_tips_window_close_terminal = {
	_name = "illustration_tips_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("IllustrationTipsClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(illustration_tips_window_open_terminal)
state_machine.add(illustration_tips_window_close_terminal)
state_machine.init()

-- 构造器
function IllustrationTips:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.l_digital.cultivate.illustration.IllustrationLevelup")
	-- Initialize illustration tips page state machine.
	local function init_illustration_tips_terminal()
		-- 打开角色创建窗口
		local illustration_tips_open_terminal = {
			_name = "illustration_tips_open",
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
		local illustration_tips_close_terminal = {
			_name = "illustration_tips_close",
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
		local illustration_tips_show_terminal = {
			_name = "illustration_tips_show",
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
		local illustration_tips_hide_terminal = {
			_name = "illustration_tips_hide",
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

		-- 跳转升级
		local illustration_jump_level_terminal = {
			_name = "illustration_jump_level",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if params._datas then
					local cardData = params._datas.card_data
					local isCombineCard = params._datas.isCombineCard
					state_machine.excute("illustration_levelup_window_open","",{cardData, isCombineCard})
				end
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(illustration_tips_open_terminal)
		state_machine.add(illustration_tips_close_terminal)
		state_machine.add(illustration_tips_show_terminal)
		state_machine.add(illustration_tips_hide_terminal)
		state_machine.add(illustration_jump_level_terminal)
		state_machine.init()
	end
	-- call func init illustration tips state machine.
	init_illustration_tips_terminal()
end

-- 对象初始化
function IllustrationTips:init(params)
	self._show_data = params
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function IllustrationTips:onUpdateDraw()
	local root = self.roots[1]
	local type = self._show_data.type
	local num = self._show_data.num
	
	-- cocos动画容器
	self.Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")

	-- 有%s個卡冊可以升級
	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	self.Text_1:setVisible(false)
	-- 还差%s个卷轴即可升級卡册
	self.Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
	self.Text_2:setVisible(false)
	if 0 == type then
		self.Text_1:setString(string.format(self.Text_1:getString(),tostring(num)))
		self.Text_1:setVisible(true)
		local cardList = self._show_data.val
			
		-- 这个地方可能 普通卡册 和组合卡册都有，需要单独处理下一下
		-- 优先普攻卡册的升级操作

		local normalCardList = {}
		local combineCardList = {}

		for _, v in pairs(cardList) do
			if v.isCombineCard then
				table.insert(combineCardList, v.mouldId)
			else
				table.insert(normalCardList, v.mouldId)
			end
		end

		-- 攻防技卡册
		local function AbilityCapacity(a, b)
			local al = dms.int(dms["ship_mould"], tonumber(a), ship_mould.ability)
			local bl = dms.int(dms["ship_mould"], tonumber(b), ship_mould.ability)
			local result = false
			if al > bl then
				result = true
			end
			local cardA = IllustrationHandle.getCardDataByShipMouldId(a)
			local cardB = IllustrationHandle.getCardDataByShipMouldId(b)
			if cardA and cardB then
				if al == bl then
					local k1 = tonumber(cardA.cardScore)
					local k2 = tonumber(cardB.cardScore)
					if k1 > k2 then
						return true
					end
				end
			end
			return result 
		end
		table.sort(normalCardList, AbilityCapacity)

		-- 组合卡册
		local function sortFunction(a, b)
	        local result = false
	        local cardA = IllustrationHandle.getCardDataByCardMouldId(a)
	        local cardB = IllustrationHandle.getCardDataByCardMouldId(b)
	        if cardA and cardB then
	            local k1 = tonumber(cardA.cardScore)
	            local k2 = tonumber(cardB.cardScore)
	            if k1 > k2 then
	                result =  true
	            end
	        end
	        
	        return result 
	    end
		table.sort(combineCardList, sortFunction)

		local cardData = nil
		local isCombineCard = false
		local mouldId = tonumber(normalCardList[1])
		if mouldId and mouldId ~= 0 then
			cardData = IllustrationHandle.getCardDataByShipMouldId(mouldId)
			isCombineCard = false
		else
			mouldId = tonumber(combineCardList[1])
			cardData = IllustrationHandle.getCardDataByCardMouldId(mouldId)
			isCombineCard = true
		end
			
		-- print("isCombineCard = ", isCombineCard, " mouldId = ", mouldId)

		fwin:addTouchEventListener(self.Panel_1, nil,{
			terminal_name = "illustration_jump_level", 
			terminal_state = 0,
			card_data = cardData,
			isCombineCard = isCombineCard,
			isPressedActionEnabled = true
		}, nil, 0)
	else
		-- 缺少的道具不在传数量 而是缺少的道具具体信息
		local needProps = {}
		for _, v in pairs(num) do
			local id, count = v[2], v[3]
			needProps[id] = (needProps[id] or 0) + count
		end

		local props = {}
		for id, count in pairs(needProps) do
			table.insert(props, {id, count})
		end

		local propData = props[1]
		local propId = tonumber(propData[1])
		local needNum = tonumber(propData[2])

		local propName = setThePropsIcon(propId)[2]

		self.Text_2:setString(string.format(tipStringInfo_illustration_tip[13], needNum, propName))
		self.Text_2:setVisible(true)
	end

end

function IllustrationTips:onEnterTransitionFinish()
	-- 加载IllustrationTipsWindow界面资源.
	-- res.cultivate.illustration.illustration_tips = res/cultivate/illustration/illustration_tips.csb
	local csbNode = csb.createNode("cultivate/illustration/illustration_tips.csb")
	local root = csbNode:getChildByName("root")

	local action = csb.createTimeline("cultivate/illustration/illustration_tips.csb") 
	
	action:gotoFrameAndPlay(0, action:getDuration(), false)
	csbNode:runAction(action)	

	table.insert(self.roots, root)
	self:addChild(csbNode)
	
	self:onUpdateDraw()
end

function IllustrationTips:onExit()
	-- 释放IllustrationTipsWindow界面资源.
	state_machine.remove("illustration_tips_open")
	state_machine.remove("illustration_tips_close")
	state_machine.remove("illustration_tips_show")
	state_machine.remove("illustration_tips_hide")
	state_machine.remove("illustration_jump_level")
end

function IllustrationTips:close()
	-- window event : close.
	
end

function IllustrationTips:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
