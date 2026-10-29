----------------------------------------------------------------------------------------------------
-- 说明：全服基金活动
-------------------------------------------------------------------------------------------------------

AllServerFundActivity = class("AllServerFundActivityClass", Window)
    
function AllServerFundActivity:ctor()
    self.super:ctor()
    self.roots = {}
    self._drawGold = 0
    self.resultList = {}
    -- Initialize all server fund activity page state machine.
    local function init_all_server_fund_activity_terminal()
        local all_server_fund_activity_buy_request_terminal = {
            _name = "all_server_fund_activity_buy_request",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local status = params.status
                if status ~= 1 then
                    return false
                end
                -- run\res\cocostudio\utils\prompted.csb
                local function responseGrowPlanPurchaseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots[1] ~= nil then
							TipDlg.drawTextDailog(_string_piece_info[279])
							state_machine.excute("all_server_fund_activity_update_draw", 0, "")
							state_machine.excute("all_server_welfare_activity_update_draw", 0, "")
						end	
                    end
                end
                protocol_command.grow_plan_purchase.param_list = "".._ED.active_activity[27].activity_id
                NetworkManager:register(protocol_command.grow_plan_purchase.code, nil, nil, nil, instance, responseGrowPlanPurchaseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local all_server_fund_activity_buy_terminal = {
            _name = "all_server_fund_activity_buy",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- 对用户的状态进行判断，给出对应的提示窗口
                local vipLevel = zstring.tonumber(_ED.vip_grade)
                local activity = _ED.active_activity[27]
                local needVipLevel = zstring.tonumber(activity.limit_vip_level)
                local needGold = zstring.tonumber(activity.price_gold)
                if vipLevel < needVipLevel then
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                        TipDlg.drawTextDailog(_string_piece_info[278])
                    else
                        state_machine.excute("shortcut_open_recharge_tip_dialog", 0, {10, 0, 0, _string_piece_info[278]})
                    end
                else
                    -- TipDlg.drawTextDailog(_string_piece_info[238])
                    local currentGold = zstring.tonumber(_ED.user_info.user_gold)
                    if needGold > currentGold then
                        -- 不可购买
                        state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
                        {
                            terminal_name = "shortcut_open_recharge_window", 
                            terminal_state = 0, 
                            _msg = _string_piece_info[273], 
                            _datas= 
                            {

                            }
                        })
                    else
                        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                            local function responseGrowPlanPurchaseCallback(response)
                                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                    if response.node ~= nil and response.node.roots[1] ~= nil then
                                        TipDlg.drawTextDailog(_string_piece_info[279])
                                        state_machine.excute("all_server_fund_activity_update_draw", 0, "")
                                        state_machine.excute("all_server_welfare_activity_update_draw", 0, "")
                                    end 
                                end
                            end

                            function showConfirmTip(instance,n)
                                if n == 0 then
                                    protocol_command.grow_plan_purchase.param_list = "".._ED.active_activity[27].activity_id
                                    NetworkManager:register(protocol_command.grow_plan_purchase.code, nil, nil, nil, instance, responseGrowPlanPurchaseCallback, false, nil)
                                end
                            end
                            
                            app.load("client.utils.ConfirmTip")
                            local tip = ConfirmTip:new()
                            tip:init(instance, showConfirmTip, _string_piece_info[277])
                            fwin:open(tip,fwin._ui)
                        else
                            -- 可购买
                            state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
                            {
                                terminal_name = "all_server_fund_activity_buy_request", 
                                terminal_state = 0, 
                                _msg = _string_piece_info[277], 
                                _datas= 
                                {

                                }
                            })
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local all_server_fund_activity_update_draw_terminal = {
            _name = "all_server_fund_activity_update_draw",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.onUpdateDraw ~= nil then
                    if __lua_project_id == __lua_project_gragon_tiger_gate 
                        or __lua_project_id == __lua_project_l_naruto 
                        or __lua_project_id == __lua_project_red_alert 
                        then
                        instance:initActivityListViewEX()
                    elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                        then
                        instance:initActivityListViewEXX()
                    end
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(all_server_fund_activity_buy_terminal)
        state_machine.add(all_server_fund_activity_buy_request_terminal)
        state_machine.add(all_server_fund_activity_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func init all server fund activity state machine.
    init_all_server_fund_activity_terminal()
end

function AllServerFundActivity:loading_cell()
    if AllServerFundActivity.cacheListView == nil then
        return 
    end
    local cell = self.resultList[AllServerFundActivity.asyncIndex]
    if cell ~= nil then
        AllServerFundActivity.cacheListView:addChild(cell)
        cell:release()
        AllServerFundActivity.asyncIndex = AllServerFundActivity.asyncIndex + 1
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            AllServerFundActivity.cacheListView:requestRefreshView()
        end        
    end
end

function AllServerFundActivity:initActivityListViewEXX( ... )
    local root = self.roots[1]
    app.load("client.cells.activity.open_server_list_cell_new")
    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_service")
    m_ScrollView:removeAllChildren(true)
    local activity = _ED.active_activity[27]

    local horizontalNumber = 4
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
    local wPosition = sWidth/horizontalNumber
    local Hlindex = 0
    local number = #activity.activity_Info
    local m_number = math.ceil(number/horizontalNumber)
    cellHeight = m_number*(m_ScrollView:getContentSize().width/horizontalNumber)
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(m_ScrollView:getContentSize().width, sHeight + 10)

    local totalRewardCount = 0
    for j, v in pairs(activity.activity_Info) do
        local cell = OpenServerListCellNew:createCell()
        local tcell, drawState = cell:init(1, m_ScrollView, activity, v, j - 1, nil, v.activityInfo_isReward)
        panel:addChild(cell)
        tWidth = tWidth + wPosition
        if (j-1)%horizontalNumber == 0 then
            Hlindex = Hlindex+1
            tWidth = 0
            tHeight = sHeight - (wPosition + 2)*Hlindex  
        end
        if j <= horizontalNumber then
            tHeight = sHeight - wPosition
        end
        cell:setPosition(cc.p(tWidth, tHeight))

        totalRewardCount = totalRewardCount + 1
    end
    m_ScrollView:jumpToTop()

    if totalRewardCount == number then
        state_machine.excute("home_update_top_activity_info_state", 0, "")
    end
end

function AllServerFundActivity:initActivityListViewEX()
    local root = self.roots[1]
    app.load("client.cells.activity.open_server_list_cell_new")
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_4")
    local activity = _ED.active_activity[27]
    local uncompItems = {}
    local drawItems = {}
    local closeItems = {}

    self.resultList = {}
    --cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    --AllServerFundActivity.asyncIndex = 1
    AllServerFundActivity.cacheListView = listView
    AllServerFundActivity.cacheListView:removeAllItems()

    if activity ~= nil then
        for i, v in pairs(activity.activity_Info) do
            local cell = OpenServerListCellNew:createCell()
            local tcell, drawState = cell:init(1, listView, activity, v, i - 1, nil, v.activityInfo_isReward)
            cell:retain()
            if drawState == 0 then
                table.insert(uncompItems, cell)
            elseif drawState == 1 then
                table.insert(drawItems, cell)
            elseif drawState == 2 then
                table.insert(closeItems, cell)
            end
        end
        for i, v in pairs(drawItems) do
            table.insert(self.resultList, v)
        end
        for i, v in pairs(uncompItems) do
            table.insert(self.resultList, v)
        end
        for i, v in pairs(closeItems) do
            table.insert(self.resultList, v)
        end
        for k,v in pairs(self.resultList) do
            local cell = self.resultList[k]
            if cell ~= nil then
                listView:addChild(cell)
                cell:release()     
            end
            --cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)
        end
        listView:requestRefreshView()

        if #closeItems == #self.resultList then
            -- 奖励已领完
            state_machine.excute("home_update_top_activity_info_state", 0, "")
        end
    end
end

function AllServerFundActivity:initActivityListView()
    if __lua_project_id == __lua_project_gragon_tiger_gate 
        or __lua_project_id == __lua_project_l_naruto 
        or __lua_project_id == __lua_project_red_alert
        then
        self:initActivityListViewEX()
        return
    elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        then
        self:initActivityListViewEXX()
        return
    end
    local root = self.roots[1]
    app.load("client.cells.activity.open_server_list_cell")
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_4")
    local activity = _ED.active_activity[27]
    local uncompItems = {}
    local drawItems = {}
    local closeItems = {}
    for i, v in pairs(activity.activity_Info) do
        local cell = OpenServerListCell:createCell()
        local tcell, drawState = cell:init(1, listView, activity, v, i - 1, nil, v.activityInfo_isReward)
        -- listView:addChild(cell)
        if drawState == 0 then
            table.insert(uncompItems, cell)
        elseif drawState == 1 then
            table.insert(drawItems, cell)
        elseif drawState == 2 then
            table.insert(closeItems, cell)
        end
    end
    for i, v in pairs(drawItems) do
        listView:addChild(v)
    end
    for i, v in pairs(uncompItems) do
        listView:addChild(v)
    end
    for i, v in pairs(closeItems) do
        listView:addChild(v)
    end
    listView:requestRefreshView()
end

function AllServerFundActivity:onUpdate(dt)
	-- 绘制用户的领取信息
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
        then
        return
    end
	local activity = _ED.active_activity[27]
	local totalGold = 0
	local drawGold = 0
	for i, v in pairs(activity.activity_Info) do
		totalGold = totalGold + zstring.tonumber(v.activityInfo_gold)
		local drawRewardState = zstring.tonumber(v.activityInfo_isReward)
		if drawRewardState == 1 then
			drawGold = drawGold + zstring.tonumber(v.activityInfo_gold)
		end
	end
	if self._drawGold ~= drawGold then
		local root = self.roots[1]
		self._drawGold = drawGold
		local drawTotalGold = ""..drawGold
		drawTotalGold = drawTotalGold .. _All_tip_string_info._crystalName
		ccui.Helper:seekWidgetByName(root, "Text_103_0"):setString(drawTotalGold)
		local hasDrawGold = ""..(totalGold - drawGold)
		hasDrawGold = hasDrawGold .. _All_tip_string_info._crystalName
		ccui.Helper:seekWidgetByName(root, "Text_103_2"):setString(hasDrawGold)
	end	
end 

function AllServerFundActivity:onUpdateDraw()
    local root = self.roots[1]
    local buyButton = ccui.Helper:seekWidgetByName(root, "Button_kf_14_6")
    local Text_lv = ccui.Helper:seekWidgetByName(root, "Text_lv")
    local activity = _ED.active_activity[27]
    local buyed = activity.activity_isReward == "3"
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        ccui.Helper:seekWidgetByName(root, "Text_fund_mis_n"):setString(activity.price_gold)
    end
	
    if Text_lv ~= nil then
        Text_lv:setString(string.format(_new_interface_text[302], _ED.user_info.user_grade))
    end
	if buyButton == nil then
		return
	end
	
    if buyed == true then
        -- buyButton:setBright(false)
        -- buyButton:setTouchEnabled(false)
        buyButton:setVisible(false)

        ccui.Helper:seekWidgetByName(root, "Image_5"):setVisible(true)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
            then
        else
            ccui.Helper:seekWidgetByName(root, "Panel_7"):setVisible(false)
            ccui.Helper:seekWidgetByName(root, "Panel_8"):setVisible(true)
            -- 绘制用户的领取信息
            local activity = _ED.active_activity[27]
            local totalGold = 0
            local drawGold = 0
            for i, v in pairs(activity.activity_Info) do
                totalGold = totalGold + zstring.tonumber(v.activityInfo_gold)
                local drawRewardState = zstring.tonumber(v.activityInfo_isReward)
                if drawRewardState == 1 then
                    drawGold = drawGold + zstring.tonumber(v.activityInfo_gold)
                end
            end
    		self._drawGold = drawGold
            local drawTotalGold = ""..drawGold
            drawTotalGold = drawTotalGold .. _All_tip_string_info._crystalName
            ccui.Helper:seekWidgetByName(root, "Text_103_0"):setString(drawTotalGold)
            local hasDrawGold = ""..(totalGold - drawGold)
            hasDrawGold = hasDrawGold .. _All_tip_string_info._crystalName
            ccui.Helper:seekWidgetByName(root, "Text_103_2"):setString(hasDrawGold)
        end
    end
    -- 绘制当前vip等级
    -- FURY: EL NUMERO DEL CARTEL ES EL VIP QUE PIDE EL FONDO, NO EL DEL
    -- JUGADOR. El rotulo de al lado (`Text_15`) dice «VIP _ or above
    -- players can buy», asi que con el VIP del jugador un VIP 0 leia
    -- «VIP 0 o superior puede comprar» y el boton le rebotaba igual.
    --
    -- Y el atlas de esta variante se llama `BitmapFontLabel_2_2`
    -- (comprobado en `open_service_fund_1.csb`): con el nombre viejo el
    -- seek daba nil, no se pintaba nada y el cartel se quedaba con el
    -- «3» que trae el arte, que solo es verdad mientras nadie cambie el
    -- hueco de terminos de `level_fund` en `activity_event_rewards`.
    local BitmapFontLabel_1_4 = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_1_4")
        or ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_2_2")
    if BitmapFontLabel_1_4 ~= nil then
        BitmapFontLabel_1_4:setString(""..(activity.limit_vip_level or _ED.vip_grade or "0"))
    end
    -- 绘制当前的购买人数
    activity = _ED.active_activity[41]
    if activity ~= nil then
        ccui.Helper:seekWidgetByName(root, "Text_17"):setString(string.format(_string_piece_info[281], (activity.activity_buy_count)))
    end

    local listView = ccui.Helper:seekWidgetByName(root, "ListView_4")

    -- 更新列表的状态
    local items = listView:getItems()
    for i, v in pairs(items) do
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
             state_machine.excute("open_server_list_cell_new_update_draw", 0, v)
        else
            state_machine.excute("open_server_list_cell_update_draw", 0, v)
        end
    end
end

function AllServerFundActivity:onEnterTransitionFinish()
    local csbAllServerFundActivity = csb.createNode("activity/wonderful/open_service_fund_1.csb")
    self:addChild(csbAllServerFundActivity)
    local root = csbAllServerFundActivity:getChildByName("root")
    table.insert(self.roots, root)

    self:initActivityListView()

    self:onUpdateDraw()
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)

    -- 购买开服基金的按钮事件响应
    local buyButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kf_14_6"),       nil, 
    {
        terminal_name = "all_server_fund_activity_buy",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_open_server_activity_buy",
    _widget = buyButton,
    _invoke = nil,
    _interval = 0.5,})

    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        local rechargeButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kaifu_cz"),       nil, 
        {
            terminal_name = "shortcut_open_recharge_window",     
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_open_server_activity_recharge",
        _widget = rechargeButton,
        _invoke = nil,
        _interval = 0.5,})        
    end
end


function AllServerFundActivity:onExit()
    
end

function AllServerFundActivity:init()
end


function AllServerFundActivity:createCell()
    local cell = AllServerFundActivity:new()
    cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 1)
    return cell
end