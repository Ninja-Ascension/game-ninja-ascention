----------------------------------------------------------------------------------------------------
-- 说明：七日活动每日折扣商品购买页面
-------------------------------------------------------------------------------------------------------
SevenDaysForEveryDayPropBuy = class("SevenDaysForEveryDayPropBuyClass", Window)
    
function SevenDaysForEveryDayPropBuy:ctor()
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
    self.needGolds = 0
    app.load("client.cells.equip.equip_icon_cell")
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.prop.prop_money_icon")

    -- Initialize seven days activity for every day prop buy page state machine.
    local function init_seven_days_activity_for_every_day_prop_buy_terminal()
        -- 半价抢购
        local seven_days_activity_for_every_day_prop_buy_request_terminal = {
            _name = "seven_days_activity_for_every_day_prop_buy_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseDrawWeekRewardCallback(response)
                    if (__lua_project_id == __lua_project_warship_girl_a 
		    	or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
                        or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh) 
			and params.status ~= nil 
			then
                        state_machine.excute("use_diamond_confirm_tip_close",0,"")
                    end
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- response.node:isDrawedUpdateDraw()
                        local sevenDaysReward = _ED.active_activity[42].seven_days_rewards[response.node.dayIndex]
                        sevenDaysReward.half_prop_buy_count = "" .. (zstring.tonumber(sevenDaysReward.half_prop_buy_count) - 1)
                        sevenDaysReward.half_prop_buy_state = 1
                        response.node:initDraw()
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(47)
                        fwin:open(getRewardWnd, fwin._ui)
                    end
                end
				if TipDlg.drawStorageTipo() == false then
					local cell = params._datas.cell

                    if (__lua_project_id == __lua_project_warship_girl_a 
		    	or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
                        or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh) 
                        and ___is_open_diamond_confirm == true and params.status == nil and cell.needGolds > 0 then
                        app.load("client.utils.UseDiamondConfirmTip")
                        local window_terminal = state_machine.find("use_diamond_confirm_tip_open")
                        if window_terminal.unopen ~= true then
                            local str1 = string.format(tipStringInfo_use_diamond[1],cell.needGolds)
                            local str2 = tipStringInfo_use_diamond[4]..tipStringInfo_use_diamond[6]
                            state_machine.excute("use_diamond_confirm_tip_open", 0, {_datas={instance,nil,str1.."|"..str2 ,params}})
                            return
                        else
                             protocol_command.draw_week_reward.param_list = "" .. cell.dayIndex .. "\r\n" .. 3 ..  "\r\n" .. "-1" .. "\r\n" .. "-1"
                             NetworkManager:register(protocol_command.draw_week_reward.code, nil, nil, nil, cell, responseDrawWeekRewardCallback, false, nil)
                        end
                    else
                        protocol_command.draw_week_reward.param_list = "" .. cell.dayIndex .. "\r\n" .. 3 ..  "\r\n" .. "-1" .. "\r\n" .. "-1"
                        NetworkManager:register(protocol_command.draw_week_reward.code, nil, nil, nil, cell, responseDrawWeekRewardCallback, false, nil)
                    end 
					
				end
			   return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local seven_days_activity_for_every_day_prop_buy_reset_terminal = {
            _name = "seven_days_activity_for_every_day_prop_buy_reset",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:init(params)
                instance:initDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(seven_days_activity_for_every_day_prop_buy_request_terminal)
        state_machine.add(seven_days_activity_for_every_day_prop_buy_reset_terminal)
        state_machine.init()
    end
    
    -- call func init seven days activity for every day prop buy state machine.
    init_seven_days_activity_for_every_day_prop_buy_terminal()
end

function SevenDaysForEveryDayPropBuy:initDraw()
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
    self.needGolds= zstring.tonumber(dms.atos(carnivalMouldElement, carnival_mould.now_price))
    -- 原价
    ccui.Helper:seekWidgetByName(root, "Text_3_0_0"):setString(dms.atos(carnivalMouldElement, carnival_mould.cost_price))

    -- 限定购买的人数
    local totalBuyCount = dms.atoi(carnivalMouldElement, carnival_mould.limit)
    local buyTipString = string.format(_string_piece_info[306], totalBuyCount, sevenDaysReward.half_prop_buy_count) 
    ccui.Helper:seekWidgetByName(root, "Text_7"):setString(buyTipString)

    local drawRewardState = zstring.tonumber(sevenDaysReward.half_prop_buy_state)
    -- if drawRewardState == 0 then
    --     if completeCount >= needCompleteCount then
    --         self.drawState = 1
    --     else
    --         self.drawState = 0
    --     end
    -- else
    --     self.drawState = 2
    -- end
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

function SevenDaysForEveryDayPropBuy:onEnterTransitionFinish()
    local csbSevenDaysForEveryDayPropBuy = csb.createNode("activity/7days/week_Activities_qianggou.csb")
    self:addChild(csbSevenDaysForEveryDayPropBuy)

    local root = csbSevenDaysForEveryDayPropBuy:getChildByName("root")
    table.insert(self.roots, root)

    -- self:initDraw()
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self)
	
    -- 领取奖励的事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"),       nil, 
    {
        terminal_name = "seven_days_activity_for_every_day_prop_buy_request",      
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0):setSwallowTouches(false)
end

function SevenDaysForEveryDayPropBuy:onExit()
    -- state_machine.remove("seven_days_activity_for_every_day_prop_buy_request")
    -- state_machine.remove("seven_days_activity_for_every_day_prop_buy_reset")
end

function SevenDaysForEveryDayPropBuy:init(dayIndex)
    self.dayIndex = dayIndex
    return self
end

function SevenDaysForEveryDayPropBuy:createCell()
    local cell = SevenDaysForEveryDayPropBuy:new()
    cell:registerOnNodeEvent(cell)
    return cell
end