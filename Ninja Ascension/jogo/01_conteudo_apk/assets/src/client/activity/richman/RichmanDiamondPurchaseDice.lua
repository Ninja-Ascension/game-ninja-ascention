-- ----------------------------------------------------------------------------------------------------
-- 说明：钻石购买骰子界面
-------------------------------------------------------------------------------------------------------
RichmanDiamondPurchaseDice = class("RichmanDiamondPurchaseDiceClass", Window)

local richman_diamond_purchase_dice_window_open_terminal = {
    _name = "richman_diamond_purchase_dice_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("RichmanDiamondPurchaseDiceClass") then
			fwin:open(RichmanDiamondPurchaseDice:new():init(params), fwin._view)
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local richman_diamond_purchase_dice_window_close_terminal = {
    _name = "richman_diamond_purchase_dice_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("RichmanDiamondPurchaseDiceClass") then
            fwin:close(fwin:find("RichmanDiamondPurchaseDiceClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(richman_diamond_purchase_dice_window_open_terminal)
state_machine.add(richman_diamond_purchase_dice_window_close_terminal)
state_machine.init()

function RichmanDiamondPurchaseDice:ctor()
    self.super:ctor()
    
	self.roots = {}

	self.dicePropInfo = nil
	self._max_select_num = 0
	self._select_num = 0
	self.dicePrice = 0				-- 骰子单价
	self.userMoney = 0				-- 玩家钻石数量

    local function init_richman_diamond_purchase_dice_terminal()
		-- 打开角色创建窗口
		local richman_diamond_purchase_dice_open_terminal = {
			_name = "richman_diamond_purchase_dice_open",
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
		local richman_diamond_purchase_dice_close_terminal = {
			_name = "richman_diamond_purchase_dice_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("richman_diamond_purchase_dice_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local richman_diamond_purchase_dice_show_terminal = {
			_name = "richman_diamond_purchase_dice_show",
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
		local richman_diamond_purchase_dice_hide_terminal = {
			_name = "richman_diamond_purchase_dice_hide",
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

		local richman_diamond_purchase_dice_use_set_min_or_max_terminal = {
            _name = "richman_diamond_purchase_dice_use_set_min_or_max",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance ~= nil then
					local setType = params._datas.setType
					if setType == 1 then
						instance:setSelectNum(1)
					elseif setType == 2 then
						instance:setSelectNum(instance._max_select_num)
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local richman_diamond_purchase_dice_use_update_terminal = {
            _name = "richman_diamond_purchase_dice_use_update",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
					local select_num = math.ceil(tonumber(instance.Slider_2:getPercent()) * instance._max_select_num / 100)
					instance:setSelectNum(select_num)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local richman_diamond_purchase_dice_buy_terminal = {
            _name = "richman_diamond_purchase_dice_buy",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance._max_select_num == 0 or instance._select_num == 0 then
					TipDlg.drawTextDailog(tipStringInfo_richman[7])
					return false
				end
                local function callBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then

							_ED.active_activity[187].activity_data.remainBuyDiceTimes = _ED.active_activity[187].activity_data.remainBuyDiceTimes - response.node._select_num

							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(7)
							fwin:open(getRewardWnd, fwin._ui)

							state_machine.excute("richman_main_update_dice_numbers", 0, nil)
							state_machine.excute("richman_diamond_purchase_dice_window_close",0,"")  
						end
                    end
                end
                protocol_command.monopoly_buy.param_list = instance._select_num
                NetworkManager:register(protocol_command.monopoly_buy.code, nil, nil, nil, instance, callBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(richman_diamond_purchase_dice_open_terminal)
		state_machine.add(richman_diamond_purchase_dice_close_terminal)
		state_machine.add(richman_diamond_purchase_dice_show_terminal)
		state_machine.add(richman_diamond_purchase_dice_hide_terminal)
		state_machine.add(richman_diamond_purchase_dice_use_set_min_or_max_terminal)
		state_machine.add(richman_diamond_purchase_dice_use_update_terminal)
		state_machine.add(richman_diamond_purchase_dice_buy_terminal)
		
		state_machine.init()
	end
	-- call func init richman_reward record state machine.
	init_richman_diamond_purchase_dice_terminal()
end

function RichmanDiamondPurchaseDice:setSelectNum(select_num)
	self._select_num = select_num
    if self._select_num > self._max_select_num then
        self._select_num = self._max_select_num
    end
    if self._select_num <= 0 then
        self._select_num = 1
    end
    local percent = math.floor(self._select_num / self._max_select_num*100)
    self:updateSliderInfo(percent)
end

function RichmanDiamondPurchaseDice:updateSliderInfo(percent)
    if self._max_select_num > 0 and self._select_num == 0 then
        self._select_num = 1
	elseif self._max_select_num == 0 then
		self._select_num = 0
    end
    self.Slider_2:setPercent(percent)
    self.Text_1:setString(self._select_num.."/"..self._max_select_num)
	
	self.Text_11:setString(self.dicePrice * self._select_num)
end

function RichmanDiamondPurchaseDice:initPropData()
	local activity_data = _ED.active_activity[187].activity_data
	if activity_data == nil then
		return false
	end
	-- 单价
	self.dicePrice = activity_data.buyDicePrice
	self.userMoney = _ED.user_info.user_gold

	local limitTimes = activity_data.remainBuyDiceTimes
	local _max_select_num = math.floor(self.userMoney / self.dicePrice)
	self._max_select_num = limitTimes >= _max_select_num and _max_select_num or limitTimes

	local propInfoString = dms.string(dms["activity_config"], 102, activity_config.param)
	self.dicePropInfo = zstring.split(propInfoString, ",", tonumber)
end

function RichmanDiamondPurchaseDice:onUpdateDraw()
	local root = self.roots[1]

	-- 道具名称
	self.Text_8 = ccui.Helper:seekWidgetByName(root, "Text_8")
	-- 单价文本
	self.Text_11 = ccui.Helper:seekWidgetByName(root, "Text_11")
	-- 玩家钻石数量
	self.Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
	-- 玩家兑换数量
	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	-- 图标绘制容器
	self.Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
	self.Panel_icon:removeAllChildren(true)

	-- 滑动选择
	self.Slider_2 = ccui.Helper:seekWidgetByName(root, "Slider_2")

	local function percentChangedEvent(sender,eventType)
		if eventType == ccui.SliderEventType.percentChanged then
			state_machine.excute("richman_diamond_purchase_dice_use_update", 0, {sender:getPercent()})
		end
	end
	self.Slider_2:addEventListener(percentChangedEvent)

	self.Text_2:setString(self.userMoney)
	self.Text_11:setString(self.dicePrice * self._select_num)
	
    local propNameQuality = getItemNameAndQuality(self.dicePropInfo)
	local propText = propNameQuality[1]
	self.Text_8:setString(propText)

	local propInfo = self.dicePropInfo
	propInfo[3] = -1
	local propCell = DrawHandle.drawIcon(propInfo)
	self.Panel_icon:addChild(propCell)
	self:setSelectNum(self._max_select_num)
end

function RichmanDiamondPurchaseDice:drawButton()
	local root = self.roots[1]
    -- 设置最小
    self.Button_6 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_6"), nil,
	{
		terminal_name = "richman_diamond_purchase_dice_use_set_min_or_max",
		terminal_state = 0,
		isPressedActionEnabled = true,
		setType = 1,
	}, nil, 0)	

    -- 设置最大
    self.Button_7 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7"), nil,
	{
		terminal_name = "richman_diamond_purchase_dice_use_set_min_or_max",
		terminal_state = 0,
		isPressedActionEnabled = true,
		setType = 2,
	}, nil, 0)	
	
    -- 购买按钮
    self.Button_8 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_8"), nil,
	{
		terminal_name = "richman_diamond_purchase_dice_buy",
		terminal_state = 0,
		isPressedActionEnabled = true,
		m_type = 3,
	}, nil, 0)	

    -- 关闭界面
    self.Button_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "richman_diamond_purchase_dice_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
		m_type = 3,
	}, nil, 0)	

end

-- 对象初始化
function RichmanDiamondPurchaseDice:init(params)
	if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function RichmanDiamondPurchaseDice:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/dafuweng/dafuweng_goumai.csb")
	local root = csbNode:getChildByName("root")
    self:addChild(csbNode)
	table.insert(self.roots, root)
	
	self:initPropData()
	self:drawButton()
    self:onUpdateDraw()
end

function RichmanDiamondPurchaseDice:onExit()
    state_machine.remove("richman_diamond_purchase_dice_open")
	state_machine.remove("richman_diamond_purchase_dice_close")
	state_machine.remove("richman_diamond_purchase_dice_show")
	state_machine.remove("richman_diamond_purchase_dice_hide")
	state_machine.remove("richman_diamond_purchase_dice_use_set_min_or_max")
	state_machine.remove("richman_diamond_purchase_dice_use_update")
	state_machine.remove("richman_diamond_purchase_dice_buy")
end


function RichmanDiamondPurchaseDice:close()
	-- window event : close.
	
end

function RichmanDiamondPurchaseDice:destroy(window)
	-- window event : destroy.
	
end
