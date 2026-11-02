----------------------------------------------------------------------------------------------------
-- 说明：全民福利活动
-------------------------------------------------------------------------------------------------------

ActivityRechargeSale = class("ActivityRechargeSaleClass", Window)
    
function ActivityRechargeSale:ctor()
    self.super:ctor()
    self.roots = {}
    self.recharge_progress = 0
    self.needUpdateRefreshCd = false
    self.isShowRechargeTip = false
    self.extraAddGold = 0
    self._Text_sy1 = nil
    -- Initialize all server welfare activity page state machine.
    local function init_activity_recharge_sale_terminal()
        local activity_recharge_sale_goto_buy_page_terminal = {
            _name = "activity_recharge_sale_goto_buy_page",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                    or __lua_project_id == __lua_project_l_naruto 
                    then
                    if funOpenDrawTip(181) == true then
                        return
                    end
                end
                app.load("client.shop.recharge.RechargeDialog")
                local Recharge = RechargeDialog:new()
                Recharge:init(10,100)
                fwin:open(Recharge , fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_recharge_sale_update_draw_terminal = {
            _name = "activity_recharge_sale_update_draw",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if fwin:find("ActivityRechargeSaleClass") ~= nil then
					instance:onRefreshDraw()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_recharge_sale_goto_limit_terminal = {
            _name = "activity_recharge_sale_goto_limit",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("activity_limit_time_coupons_manager", 0, {
                    _datas = {
                        terminal_name = "activity_limit_time_coupons_manager",     
                        next_terminal_name = "activity_limit_time_coupons_limit_prop",     
                        current_button_name = "Button_kf_7",
                        but_image = "Image_20",       
                        terminal_state = 0, 
                        isPressedActionEnabled = true
                    }
                })
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --充值后关闭对话框弹出提示
        local activity_recharge_sale_goto_recharge_close_tip_terminal = {
            _name = "activity_recharge_sale_goto_recharge_close_tip",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.isShowRechargeTip == true then 
                    --购买成功
                    if _ED.limit_recharege_info.recharge_count_down > 0 and _ED.limit_recharege_info.limit_prop_id == 0 then 
                        --两种情况 ，1 倒计时刷新 ，2购买刷新 排除第一种
                        instance.isShowRechargeTip = false
                        local tipString = string.format(_activity_new_tip_string_info[5],instance.extraAddGold)
                        TipDlg.drawTextDailog(tipString)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(activity_recharge_sale_update_draw_terminal)
        state_machine.add(activity_recharge_sale_goto_buy_page_terminal)
        state_machine.add(activity_recharge_sale_goto_limit_terminal)
        state_machine.add(activity_recharge_sale_goto_recharge_close_tip_terminal)
        state_machine.init()
    end
    
    -- call func init all server welfare activity state machine.
    init_activity_recharge_sale_terminal()
end

function ActivityRechargeSale:onRefreshDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end 
    self.interval = _ED.limit_recharege_info.os_time + _ED.limit_recharege_info.recharge_count_down - os.time()
    self.needUpdateRefreshCd = true
    local Panelx = ccui.Helper:seekWidgetByName(root, "Panel_x") 
    local Panelo = ccui.Helper:seekWidgetByName(root, "Panel_o") 
    self._Text_sy1 = ccui.Helper:seekWidgetByName(root, "Text_sy1")
    self.recharge_progress = _ED.limit_recharege_info.current_progress
    local maxProgress = dms.int(dms["pirates_config"], 352, pirates_config.param)
    local isOpen = self.recharge_progress >= maxProgress 
    Panelx:setVisible(isOpen == false)
    Panelo:setVisible(isOpen)
    local rechargeId = _ED.limit_recharege_info.limit_prop_id
    local Panel_time = ccui.Helper:seekWidgetByName(root, "Panel_time")
    if isOpen == true and rechargeId > 0 then 
        self.extraAddGold = dms.int(dms["limited_recharge"],rechargeId,limited_recharge.reward_gold)
        ccui.Helper:seekWidgetByName(root, "Text_yhed"):setString(dms.string(dms["limited_recharge"],rechargeId,limited_recharge.game_money).._string_piece_info[207])
        ccui.Helper:seekWidgetByName(root, "Text_fhzs"):setString("".. self.extraAddGold.._string_piece_info[207])
        Panel_time:setVisible(true)
        self.isShowRechargeTip = true
    else
        Panel_time:setVisible(false)
    end
end

function ActivityRechargeSale:onUpdate(dt)
    if _ED.limit_recharege_info ~= nil and  _ED.limit_recharege_info.current_progress ~= nil then 
        if self.recharge_progress ~= _ED.limit_recharege_info.current_progress then 
            --重置成功
            self:onRefreshDraw()
            state_machine.excute("activity_limit_time_coupons_update",0,0)
        end
    end
    
    if _ED.limit_recharege_info.recharge_count_down ~= nil and _ED.limit_recharege_info.limit_prop_id > 0  then
        local interval = _ED.limit_recharege_info.os_time + _ED.limit_recharege_info.recharge_count_down - os.time()
        if self.interval >= 0 then 
            self.interval = interval
        end
        self:updateRefreshCd()
    end
end 

function ActivityRechargeSale:updateRefreshCd()
    if self.needUpdateRefreshCd == false then
        return
    end
    local root = self.roots[1]
    local interval = self.interval
    if interval <= 0 then
        self._Text_sy1:setString("0"..tipStringInfo_time_info[5].."00"..tipStringInfo_time_info[6] .. "00"..tipStringInfo_time_info[7])
        self:onUpdateSendRequestInit()
    else
        self.interval = math.max(0, self.interval)

        local timeTabel = formatTime(self.interval)
        local str = timeTabel.hour ..tipStringInfo_time_info[5]
        str = str .. string.format("%02d"..tipStringInfo_time_info[6], timeTabel.minute)
        str = str .. string.format("%02d"..tipStringInfo_time_info[7], timeTabel.second)

        self._Text_sy1:setString(str)
    end
end

function ActivityRechargeSale:onUpdateSendRequestInit()
   self.needUpdateRefreshCd = false
   local function responseLimitInitCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                response.node.needUpdateRefreshCd = true
                response.node:onRefreshDraw()
                state_machine.excute("activity_limit_time_coupons_update",0,0)
            end
        end
    end
    NetworkManager:register(protocol_command.limited_recharge_init.code, nil, nil, nil, self, responseLimitInitCallback, false, nil)
end

function ActivityRechargeSale:onEnterTransitionFinish()
    local csbActivityRechargeSale = csb.createNode("activity/wonderful/limited_time_discount_2.csb")
    self:addChild(csbActivityRechargeSale)

    local root = csbActivityRechargeSale:getChildByName("root")
    table.insert(self.roots, root)

 --    self:initActivityListView()

    self:onRefreshDraw()
	-- -- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)

    -- 前往购买开服基金的按钮事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cz"),       nil, 
    {
        terminal_name = "activity_recharge_sale_goto_buy_page",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wygm"),       nil, 
    {
        terminal_name = "activity_recharge_sale_goto_limit",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
  
end


function ActivityRechargeSale:onExit()
	state_machine.remove("activity_recharge_sale_update_draw")
    state_machine.remove("activity_recharge_sale_goto_buy_page")
    state_machine.remove("activity_recharge_sale_goto_limit")
    state_machine.remove("activity_recharge_sale_goto_recharge_close_tip")
end

function ActivityRechargeSale:init()
end

function ActivityRechargeSale:createCell()
    local cell = ActivityRechargeSale:new()
    cell:registerOnNodeEvent(cell)
    cell:registerOnNoteUpdate(cell, 1)
    return cell
end