----------------------------------------------------------------------------------------------------
-- 说明：七日活动每日折扣商品购买页面
-------------------------------------------------------------------------------------------------------
SevenDaysPropBuy = class("SevenDaysPropBuyClass", Window)
    
function SevenDaysPropBuy:ctor()
    self.super:ctor()
    self.roots = {}
    self.group = {
        _welfare = nil,
        _achievement1 = nil,
        _achievement2 = nil,
        _prop_buy = nil
    }

    self.activity = _ED.active_activity[42]
    self.dayIndex = 0
    self.drawState = 0
    
    app.load("client.cells.equip.equip_icon_cell")
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.prop.prop_money_icon")

    -- Initialize seven days activity for every day prop buy page state machine.
    local function init_seven_prop_buy_terminal()
        -- 半价抢购
        local seven_days_prop_buy_request_terminal = {
            _name = "seven_days_prop_buy_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseDrawWeekRewardCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- response.node:isDrawedUpdateDraw()
                        local sevenDaysReward = _ED.active_activity[42].seven_days_rewards[response.node.dayIndex]
                        sevenDaysReward.half_prop_buy_count = "" .. (zstring.tonumber(sevenDaysReward.half_prop_buy_count) - 1)
                        sevenDaysReward.half_prop_buy_state = 1
                        response.node:onUpdateDraw(response.node.dayIndex)
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(47)
                        fwin:open(getRewardWnd, fwin._ui)
                    end
                end
				if TipDlg.drawStorageTipo() == false then
					local cell = params._datas.cell
					protocol_command.draw_week_reward.param_list = "" .. cell.dayIndex .. "\r\n" .. 3 ..  "\r\n" .. "-1" .. "\r\n" .. "-1"
					NetworkManager:register(protocol_command.draw_week_reward.code, nil, nil, nil, cell, responseDrawWeekRewardCallback, false, nil)
				end
			   return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --改变天数
        local seven_days_propbuy_change_day_terminal = {
            _name = "seven_days_propbuy_change_day",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local day_index = params._datas._day_index
                for i=1, 7 do
                    local Image_day = ccui.Helper:seekWidgetByName(instance.roots[1],string.format("Image_day_%d_0",i))
                    Image_day:setVisible(false)
                end
                local Image_day_now = ccui.Helper:seekWidgetByName(instance.roots[1],string.format("Image_day_%d_0",day_index))
                Image_day_now:setVisible(true)

                state_machine.excute("seven_days_change_day",0,day_index)
               return true
            end,
            _terminal = nil,
            _terminals = nil
        }
                --改变天数图片选中
        local seven_days_propbuy_change_image_day_terminal = {
            _name = "seven_days_propbuy_change_image_day",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local day_index = params
                for i=1, 7 do
                    local Image_day = ccui.Helper:seekWidgetByName(instance.roots[1],string.format("Image_day_%d_0",i))
                    Image_day:setVisible(false)
                end
                local Image_day_now = ccui.Helper:seekWidgetByName(instance.roots[1],string.format("Image_day_%d_0",day_index))
                Image_day_now:setVisible(true)
               return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(seven_days_prop_buy_request_terminal)
        state_machine.add(seven_days_propbuy_change_day_terminal)
        state_machine.add(seven_days_propbuy_change_image_day_terminal)
        state_machine.init()
    end
    
    -- call func init_seven_prop_buy_terminal state machine.
    init_seven_prop_buy_terminal()
end

function SevenDaysPropBuy:onUpdateDraw(dayIndex)
    self.dayIndex = dayIndex
    local root = self.roots[1]

    local sevenDaysReward = _ED.active_activity[42].seven_days_rewards[self.dayIndex]
    local carnivalMouldElement = dms.element(dms["carnival_mould"], self.dayIndex)

    local iconPad = ccui.Helper:seekWidgetByName(root, "Panel_icon")
    iconPad:removeAllChildren(true)

    -- 绘制商品信息
    local rewardIcon = nil
    local v = zstring.split(dms.atos(carnivalMouldElement, carnival_mould.half_prop), ",")
    local rewardType = zstring.tonumber(v[1])
    if rewardType == 6 then     --道具
        rewardIcon = PropIconCell:createCell()
        -- rewardIcon:init(16, v[2], v[3])
        rewardIcon:init(24, tostring(v[2]), v[3])
    elseif rewardType == 7 then     --装备
        rewardIcon = EquipIconCell:createCell()
        -- rewardIcon:init(8, nil, v[2], nil)
        rewardIcon:init(10, nil, v[2], nil)
    else
        rewardIcon = propMoneyIcon:createCell()
        if rewardType == 1 then
            rewardIcon:init(""..rewardType, v[3], _All_tip_string_info._fundName)
        elseif rewardType == 2 then
            rewardIcon:init(""..rewardType, v[3], _All_tip_string_info._crystalName)
        elseif rewardType == 5 then
            rewardIcon:init(""..rewardType, v[3], _All_tip_string_info._soulName)
        else
            rewardIcon = ResourcesIconCell:createCell()      
            rewardIcon:init(rewardType, -1, -1)
        end
    end
    if rewardIcon ~= nil then
        iconPad:addChild(rewardIcon)
    end
    -- 现价
    ccui.Helper:seekWidgetByName(root, "Text_3_0"):setString(dms.atos(carnivalMouldElement, carnival_mould.now_price))
    -- 原价
    ccui.Helper:seekWidgetByName(root, "Text_3_0_0"):setString(dms.atos(carnivalMouldElement, carnival_mould.cost_price))

    -- 限定购买的人数
    local totalBuyCount = dms.atoi(carnivalMouldElement, carnival_mould.limit)
    local buyTipString = string.format(_string_piece_info[306], totalBuyCount, sevenDaysReward.half_prop_buy_count) 
    ccui.Helper:seekWidgetByName(root, "Text_7"):setString(buyTipString)

    local drawRewardState = zstring.tonumber(sevenDaysReward.half_prop_buy_state)
    local drawButton = ccui.Helper:seekWidgetByName(root, "Button_4")
    if drawRewardState == 1 then
        drawButton:setBright(false)
        drawButton:setTouchEnabled(false)
    else
        drawButton:setBright(true)
        drawButton:setTouchEnabled(true)
    end
	if zstring.tonumber(_ED._sevenDaysActivity_currentActivityDayCount) < zstring.tonumber(_ED._sevenDaysActivity_selectActivityDayCount) then
		drawButton:setBright(false)
        drawButton:setTouchEnabled(false)
	end
end
function SevenDaysPropBuy:initListView()
    local root = self.roots[1]
    local ListView_123 = ccui.Helper:seekWidgetByName(root,"ListView_123")
    local items = ListView_123:getItems()
    for i,v in pairs(items) do 
        if i > 1 then
            local button = v
            local day = i - 1
            fwin:addTouchEventListener(button,nil, 
            {
                terminal_name = "seven_days_propbuy_change_day",      
                terminal_state = 0,
                _day_index = day,
                isPressedActionEnabled = true
            }, 
            nil, 0)

            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_new_everydays_half",
            _widget = button,
            _invoke = nil,
            dayIndex = day,
            _interval = 0.5,})
        end
    end
end
function SevenDaysPropBuy:onEnterTransitionFinish()
end
function SevenDaysPropBuy:onInit()
    local csbSevenDaysPropBuy = csb.createNode("activity/7days/week_Activities_page_4.csb")
    self:addChild(csbSevenDaysPropBuy)

    local root = csbSevenDaysPropBuy:getChildByName("root")
    table.insert(self.roots, root)
    self:initListView()
    -- 领取奖励的事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"),       nil, 
    {
        terminal_name = "seven_days_prop_buy_request",      
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0):setSwallowTouches(false)
end

function SevenDaysPropBuy:onExit()
    state_machine.remove("seven_days_prop_buy_request")
    state_machine.remove("seven_days_propbuy_change_day")
    state_machine.remove("seven_days_propbuy_change_image_day")
end

function SevenDaysPropBuy:init(dayIndex)
    self.dayIndex = dayIndex
    self:onInit()
end
