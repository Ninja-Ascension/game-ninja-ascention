----------------------------------------------------------------------------------------------------
-- 说明：限时优惠
-------------------------------------------------------------------------------------------------------
ActivityLimitTimeCoupons = class("ActivityLimitTimeCouponsClass", Window)

local activity_limit_time_coupons_open_terminal = {
    _name = "activity_limit_time_coupons_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local limitTimeCoupons = ActivityLimitTimeCoupons:createCell()
        limitTimeCoupons:init()
        fwin:open(limitTimeCoupons,fwin._windows)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_limit_time_coupons_window_close_terminal = {
    _name = "activity_limit_time_coupons_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ActivityLimitTimeCouponsClass"))
        fwin:close(fwin:find("UserInformationShopClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(activity_limit_time_coupons_open_terminal)
state_machine.add(activity_limit_time_coupons_window_close_terminal)
state_machine.init()

function ActivityLimitTimeCoupons:ctor()
    self.super:ctor()
    self.roots = {}
    self.group = {
        _limit_prop = nil,
        _recharge_sale = nil,
    }

    self.loaded = false
	
    -- Initialize open server activity page state machine.
    local function init_activity_limit_time_coupons_terminal()
		local activity_limit_time_coupons_manager_terminal = {
            _name = "activity_limit_time_coupons_manager",
            _init = function (terminal) 
                app.load("client.cells.activity.open_server_list_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(false)
                    terminal.select_button:setTouchEnabled(true)
                end
                if params._datas.current_button_name ~= nil or params._datas.current_button_name ~= "" then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
                end
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(true)
                    terminal.select_button:setTouchEnabled(false)
                end

                if terminal.last_terminal_name ~= params._datas.next_terminal_name then
                    terminal.last_terminal_name = params._datas.next_terminal_name
                    state_machine.excute(params._datas.next_terminal_name, 0, params)
                end

                local but_bgImage = nil
                if terminal.page_name ~= nil then
                    but_bgImage = ccui.Helper:seekWidgetByName(instance.roots[1], terminal.page_name)
                    if but_bgImage ~= nil then
                        but_bgImage:setVisible(false)
                    end
                end
                terminal.page_name = params._datas.but_image
                but_bgImage = ccui.Helper:seekWidgetByName(instance.roots[1], terminal.page_name)
                if but_bgImage ~= nil then
                    but_bgImage:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
                
        -- 折扣道具
        local activity_limit_time_coupons_limit_prop_terminal = {
            _name = "activity_limit_time_coupons_limit_prop",
            _init = function (terminal) 
                app.load("client.activity.limitcoupons.ActivityLimitProp")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:showLimitPropActivity()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --充值优惠
        local activity_limit_time_coupons_recharge_sale_terminal = {
            _name = "activity_limit_time_coupons_recharge_sale",
            _init = function (terminal)
                app.load("client.activity.limitcoupons.ActivityRechargeSale")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:showRechargeSaleActivity()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

       local activity_limit_time_coupons_recharge_sale2_terminal = {
            _name = "activity_limit_time_coupons_recharge_sale2",
            _init = function (terminal)
                app.load("client.activity.limitcoupons.ActivityRechargeSale")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local maxProgress = dms.int(dms["pirates_config"], 352, pirates_config.param)
                local progress = _ED.limit_recharege_info.current_progress
                if progress >= maxProgress then 
                    state_machine.excute("activity_limit_time_coupons_manager", 0, {
                        _datas = {
                            terminal_name = "activity_limit_time_coupons_manager",     
                            next_terminal_name = "activity_limit_time_coupons_recharge_sale",     
                            current_button_name = "Button_kf_8",
                            but_image = "Image_21",
                            terminal_state = 0, 
                            isPressedActionEnabled = true
                        }
                    })
                else
                     TipDlg.drawTextDailog(_activity_new_tip_string_info[2])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --全民福利
        local activity_limit_time_coupons_people_weal_terminal = {
            _name = "activity_limit_time_coupons_people_weal",
            _init = function (terminal)
                app.load("client.activity.limitcoupons.ActivityPeopleWeal")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:showPeopleWealActivity()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --帮助
        local activity_limit_time_coupons_help_terminal = {
            _name = "activity_limit_time_coupons_help",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                app.load("client.activity.limitcoupons.ActivityLimitTimeCouponsHelp")
                state_machine.excute("activity_limit_time_coupons_help_window_open",0,0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新
        local activity_limit_time_coupons_update_terminal = {
            _name = "activity_limit_time_coupons_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.onUpdateDraw ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        
        state_machine.add(activity_limit_time_coupons_manager_terminal)
        state_machine.add(activity_limit_time_coupons_limit_prop_terminal)
        state_machine.add(activity_limit_time_coupons_recharge_sale_terminal)
        state_machine.add(activity_limit_time_coupons_people_weal_terminal)
        state_machine.add(activity_limit_time_coupons_recharge_sale2_terminal)
        state_machine.add(activity_limit_time_coupons_help_terminal)
        state_machine.add(activity_limit_time_coupons_update_terminal)
        state_machine.init()
    end
    
    -- call func init open server activity state machine.
    init_activity_limit_time_coupons_terminal()
end

function ActivityLimitTimeCoupons:initLimitPropActivity()
    local root = self.roots[1]

    self._limit_prop = ActivityLimitProp:createCell()
    root:addChild(self._limit_prop)
end

--折扣道具
function ActivityLimitTimeCoupons:showLimitPropActivity()
    if self._limit_prop == nil then
        self:initLimitPropActivity()
    end
    self._limit_prop:setVisible(true)
    if self._recharge_sale ~= nil then
        self._recharge_sale:setVisible(false)
    end
    if self._people_weal ~= nil then 
        self._people_weal:setVisible(false)
    end
end

--充值优惠
function ActivityLimitTimeCoupons:initRechargeSaleActivity()
    local root = self.roots[1]
    self._recharge_sale = ActivityRechargeSale:createCell()
    root:addChild(self._recharge_sale)
end

--全民福利
function ActivityLimitTimeCoupons:initPeopleWealActivity()
    local root = self.roots[1]
    self._people_weal = ActivityPeopleWeal:createCell()
    root:addChild(self._people_weal)
end

function ActivityLimitTimeCoupons:showPeopleWealActivity()
    if self._people_weal == nil then
        self:initPeopleWealActivity()
    else
        self._people_weal:onRefreshDraw()
    end
    self._people_weal:setVisible(true)
    
    if self._limit_prop ~= nil then
        self._limit_prop:setVisible(false)
    end
    if self._recharge_sale ~= nil then 
        self._recharge_sale:setVisible(false)
    end
end

function ActivityLimitTimeCoupons:showRechargeSaleActivity()
    if self._recharge_sale  == nil then
        self:initRechargeSaleActivity()
    else
        self._recharge_sale:onRefreshDraw()
    end
    self._recharge_sale:setVisible(true)

    if self._limit_prop ~= nil then
        self._limit_prop:setVisible(false)
    end
    if self._people_weal ~= nil then 
        self._people_weal:setVisible(false)
    end
end

function ActivityLimitTimeCoupons:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local loadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
    local perText = ccui.Helper:seekWidgetByName(root, "Text_jd")
    local progress = _ED.limit_recharege_info.current_progress
    loadingBar:setPercent(_ED.limit_recharege_info.current_progress)
    local maxProgress = dms.int(dms["pirates_config"], 352, pirates_config.param)
    perText:setString("" .. progress .."/" .. maxProgress)
    local Button_czyh = ccui.Helper:seekWidgetByName(root, "Button_czyh")
    local dhArmature = Button_czyh:getChildByName("ArmatureNode_2")
    if progress >= maxProgress then 
        dhArmature:setVisible(true)
    else
        dhArmature:setVisible(false)
    end
end

function ActivityLimitTimeCoupons:onEnterTransitionFinish()
    self:onInit()
end

function ActivityLimitTimeCoupons:onInit()
    local csbActivityLimitTimeCoupons = csb.createNode("activity/wonderful/limited_time_discount.csb")
    self:addChild(csbActivityLimitTimeCoupons)

    local root = csbActivityLimitTimeCoupons:getChildByName("root")
    table.insert(self.roots, root)
    self:onUpdateDraw()
    local  SeyPressedActionEnabled = true 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        terminal_name = "activity_limit_time_coupons_window_close",
        terminal_state = 0, 
        isPressedActionEnabled = SetPressedActionEnabled
    }, 
    nil, 0)

    -- 折扣
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kf_7"),       nil, 
    {
        terminal_name = "activity_limit_time_coupons_manager",     
        next_terminal_name = "activity_limit_time_coupons_limit_prop",     
        current_button_name = "Button_kf_7",
        but_image = "Image_20",
        terminal_state = 0, 
        isPressedActionEnabled = SetPressedActionEnabled
    }, 
    nil, 0)

    -- 充值优惠
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kf_8"),       nil, 
    {
        terminal_name = "activity_limit_time_coupons_manager",     
        next_terminal_name = "activity_limit_time_coupons_recharge_sale",     
        current_button_name = "Button_kf_8",
        but_image = "Image_21",
        terminal_state = 0, 
        isPressedActionEnabled = SetPressedActionEnabled
    }, 
    nil, 0)

    --全民福利
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kf_8_0"),       nil, 
    {
        terminal_name = "activity_limit_time_coupons_manager",     
        next_terminal_name = "activity_limit_time_coupons_people_weal",     
        current_button_name = "Button_kf_8_0",
        but_image = "Image_22",
        terminal_state = 0, 
        isPressedActionEnabled = SetPressedActionEnabled
    }, 
    nil, 0)
    
    -- 前往充值的按钮事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_help"),       nil, 
    {
        terminal_name = "activity_limit_time_coupons_help",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --充值优惠
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_czyh"),       nil, 
    {
        terminal_name = "activity_limit_time_coupons_recharge_sale2",
        terminal_state = 0, 
        isPressedActionEnabled = SetPressedActionEnabled
    }, 
    nil, 0)

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
    app.load("client.player.UserInformationShop")
    fwin:open(UserInformationShop:new(),fwin._windows)
end


function ActivityLimitTimeCoupons:onExit()
    state_machine.remove("activity_limit_time_coupons_manager")
    state_machine.remove("activity_limit_time_coupons_limit_prop")
    state_machine.remove("activity_limit_time_coupons_recharge_sale")
    state_machine.remove("activity_limit_time_coupons_recharge_sale2")
    state_machine.remove("activity_limit_time_coupons_help")
    state_machine.remove("activity_limit_time_coupons_update")
end

function ActivityLimitTimeCoupons:init()
    
end


function ActivityLimitTimeCoupons:createCell()
	local cell = ActivityLimitTimeCoupons:new()
	cell:registerOnNodeEvent(cell)
	return cell
end