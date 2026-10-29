-- ----------------------------------------------------------------------------------------------------
-- 说明：宠物通关奖励
-------------------------------------------------------------------------------------------------------

BattleFieldReward = class("BattleFieldRewardClass", Window)
   
local battle_field_reward_window_open_terminal = {
    _name = "battle_field_reward_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("BattleFieldRewardClass") then
        	
        	local helpWindow = BattleFieldReward:new()
			helpWindow:init(params)
			fwin:open(helpWindow, fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_field_reward_window_close_terminal = {
    _name = "battle_field_reward_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattleFieldRewardClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_field_reward_window_open_terminal)
state_machine.add(battle_field_reward_window_close_terminal)
state_machine.init()
  
function BattleFieldReward:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
    self._can_get_reward = false 

    app.load("client.cells.prop.prop_icon_new_cell")
	
    -- Initialize Home page state machine.
    local function init_battle_field_reward_terminal()
        --确定领取
        local battle_field_reward_get_reward_terminal = {
            _name = "battle_field_reward_get_reward",

            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local _self = params._datas._self
                 local function responseBoxRewardCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(66)
                        fwin:open(getRewardWnd,fwin._ui)
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end
                NetworkManager:register(protocol_command.pet_counterpart_get_reward.code, nil, nil, nil, _self, responseBoxRewardCallBack, false, nil)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(battle_field_reward_get_reward_terminal)
        state_machine.init()
    end
    
    init_battle_field_reward_terminal()
end

function BattleFieldReward:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
    local rewards = zstring.split("".._ED._pet_battle_filed_info.box_reward,";")
    local itemCounts = 1
    --道具
    for i=1,4 do
        local propPanel = ccui.Helper:seekWidgetByName(root, "Panel_reward_"..i)
        local countText = ccui.Helper:seekWidgetByName(root, "Text_reward_"..i)
        propPanel:removeAllChildren(true)
        countText:setString("")
    end
    for k,v in pairs(rewards) do
        local one = zstring.split(""..v,",")
        if #one == 2 and  zstring.tonumber(one[2]) == 0 then 
            local propPanel = ccui.Helper:seekWidgetByName(root, "Panel_reward_"..itemCounts)
            local countText = ccui.Helper:seekWidgetByName(root, "Text_reward_"..itemCounts)
            propPanel:removeAllChildren(true)
            local rewardDate = dms.element(dms["popper_reward"], one[1])

            local prop = dms.atoi(rewardDate, popper_reward.prop_mould)
            local cell = PropIconNewCell:createCell()
            countText:setString("x("..dms.atos(rewardDate,popper_reward.prop_amount_min).."~"..dms.atos(rewardDate,popper_reward.prop_amount)..")")
            cell:init(14,prop)
            propPanel:addChild(cell)            
            itemCounts = itemCounts + 1 
        end
    end

    --状态
    local current_floor = zstring.tonumber(_ED._pet_battle_filed_info.current_floor)
    ccui.Helper:seekWidgetByName(root, "Text_bz"):setString(string.format(_pet_tipString_info[30],current_floor))

    local rewardButton = ccui.Helper:seekWidgetByName(root, "Button_receive")
    local tipText = ccui.Helper:seekWidgetByName(root, "Text_tip1")
    local mfText = ccui.Helper:seekWidgetByName(root, "Text_mf")
    local openPanel = ccui.Helper:seekWidgetByName(root, "Panel_zs")
    openPanel:setVisible(false)
    rewardButton:setVisible(true)
    mfText:setVisible(false)
    if self._can_get_reward then 
        --可以领取
        if _ED._pet_battle_filed_info.box_open_free_times > 0 then 
            --还有免费次数
            tipText:setString("")
            mfText:setVisible(true)
        else
            --没有免费次数
            local openTimes = _ED._pet_battle_filed_info.box_open_times
            if openTimes > 0 then 
                local x = 1
                --还有钻石购买
                local consume = zstring.split(dms.string(dms["pet_counterpart_mould"],current_floor,pet_counterpart_mould.open_box_need_gold),",")
                local maxTimes = #consume
                local current_time =  maxTimes - openTimes + 1
                if current_time < 1 or current_time > maxTimes then 
                    --防止错误
                    current_time = 1
                end
                openPanel:setVisible(true)
                ccui.Helper:seekWidgetByName(root, "Text_cs_1"):setString(string.format(_pet_tipString_info[31],openTimes))
                ccui.Helper:seekWidgetByName(root, "Text_zs_1"):setString(""..consume[current_time])
                tipText:setString("")
            else
                --没有任何机会领取了
                rewardButton:setVisible(false)
                tipText:setString(_pet_tipString_info[29])
            end
        end
    else
        --不可领取
        rewardButton:setVisible(false)
        tipText:setString(_pet_tipString_info[28])
    end
end

function BattleFieldReward:onEnterTransitionFinish()
	self.roots = {}
    local csbEquipInformation = csb.createNode("campaign/BattleField/BattleField_treasure.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)

	self:onUpdateDraw()

	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
	{
		terminal_name = "battle_field_reward_window_close",
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)

    local rewardButton = ccui.Helper:seekWidgetByName(root, "Button_receive")
    fwin:addTouchEventListener(rewardButton, nil, 
    {
        terminal_name = "battle_field_reward_get_reward",
        terminal_state = 0, 
        isPressedActionEnabled = true,
        _self = self,
    },
    nil,0)
end

function BattleFieldReward:onExit()
    state_machine.remove("battle_field_reward_get_reward")
end

function BattleFieldReward:init(isGet)
	self._can_get_reward = isGet
end
