-----------------------------
-- 活动广告页
-----------------------------
SmActivityVipPush = class("SmActivityVipPushClass", Window)

local sm_activity_vip_push_window_open_terminal = {
    _name = "sm_activity_vip_push_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("SmActivityVipPushClass") then
            fwin:open(SmActivityVipPush:new():init(params), fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_activity_vip_push_window_close_terminal = {
    _name = "sm_activity_vip_push_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SmActivityVipPushClass"))

        -- 如果跳转至其它界面则返回
        if params ~= nil then
            local jumpPage = params.jumpPage
            if jumpPage == true then
                return true
            end
        end

        -- 老用户回归
        if nil ~= _ED.active_activity 
            and nil ~= _ED.active_activity[164] 
            and nil ~= _ED.active_activity[165] 
            and nil ~= _ED.active_activity[166]
            and _ED.user_return_open_datas
            and 1 == tonumber(_ED.user_return_open_datas.open_flag)
            then
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.activity.user_return.UserReturnWindow")
                        state_machine.excute("user_return_window_open", 0, "")
                    end
                end
                local function responseChargeCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        NetworkManager:register(protocol_command.old_user_back_seven_day_init.code, nil, nil, nil, instance, responseCallback, false, nil)
                    end
                end

                NetworkManager:register(protocol_command.old_user_back_recharge_init.code, nil, nil, nil, instance, responseChargeCallback, false, nil)
        elseif _ED.webSevenDayOpen and _ED.showSevenDaysRecharge then 
            if _ED.seven_day_recharge_infos and tonumber(_ED.seven_day_recharge_infos.everyDayFirstShow) <= 1 then
                app.load("client.activity.seven_days_recharge.SevenDaysRechargeWindow")
                state_machine.excute("seven_days_recharge_window_open", 0, nil)
            end
        else
            -- state_machine.excute("menu_window_login_popup_banner_open", 0, 0) 
            if fwin:find("SmCheckInInfoWindowClass") == nil then
                app.load("client.l_digital.activity.wonderful.SmCheckInInfoWindow")
                if _ED.active_activity ~= nil and _ED.active_activity[38] ~= nil then
                    local activityInfo = _ED.active_activity[38].activity_Info[tonumber(_ED.active_activity[38].activity_login_day)]
                    if activityInfo ~= nil 
                        and zstring.tonumber(activityInfo.activityInfo_isReward) == 0
                        then
                        showUserReturn = false
                        cc.UserDefault:getInstance():setStringForKey(getKey("GuanBattleIndex"), "-1")
                        cc.UserDefault:getInstance():flush()
                        state_machine.excute("sm_check_in_info_window_window_open", 0, {})
                        state_machine.excute("activity_window_list_view_jump_bottom", 0, "")
                    end
                end
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_vip_push_window_open_terminal)
state_machine.add(sm_activity_vip_push_window_close_terminal)
state_machine.init()

function SmActivityVipPush:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._listInfo = {}
    self._index = 0

    -- var
    self._isSelectEd = false

    self._notification_type = nil
    
    self._addition_png = nil

    self._tracking = nil

    self._activityType = 0

    local function init_sm_activity_vip_push_terminal()
		local sm_activity_vip_push_choose_terminal = {
            _name = "sm_activity_vip_push_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_activity_vip_push_goto_terminal = {
            _name = "sm_activity_vip_push_goto",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local notification_type = params._datas.instance._notification_type
                state_machine.excute("sm_activity_vip_push_window_close", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 前往至其它界面
        local sm_activity_vip_push_jump_page_terminal = {
            _name = "sm_activity_vip_push_jump_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local activity_type = instance._activityType
                app.load("client.cells.activity.activity_icon_cell")
                if activity_type == 182 then
                   
                    local result = state_machine.excute("activity_new_server_celebration_open_with_home", 0, nil)
                    if result == true then
                        state_machine.excute("sm_activity_vip_push_window_close", 0, {jumpPage = true})
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_activity_vip_push_goto_terminal)
		state_machine.add(sm_activity_vip_push_choose_terminal)
		state_machine.add(sm_activity_vip_push_jump_page_terminal)
        state_machine.init()
    end
    
    init_sm_activity_vip_push_terminal()
end

function SmActivityVipPush:onSelectChoose()
    local root = self.roots[1]
end

function SmActivityVipPush:onEnterTransitionFinish()

end

function SmActivityVipPush:updateInfo( ... )
    local root = self.roots[1]
    local isShow = false
    for k,v in pairs(self._listInfo) do
        if k > self._index then
            self._index = k
            if v.activity_type == 182 then
                -- 如果不是每日首次登陆，不显示海报
                if self:dailyFirstLogin() ~= true then
                    v.activity_pic_id = -1
                end
            end
            local fileName = "images/ui/activity/activity_poster_"..v.activity_pic_id..".png"
            -- 如果充值过，就不显示首充的广告
            if v.activity_pic_id == 3 then
                if tonumber(_ED.recharge_rmb_number) == 0 and true == cc.FileUtils:getInstance():isFileExist(fileName) then
                    isShow = true
                    ccui.Helper:seekWidgetByName(root, "Panel_vip_get"):setBackGroundImage(fileName)
                    break
                end
            else
                if true == cc.FileUtils:getInstance():isFileExist(fileName) then
                    isShow = true
                    self._activityType = v.activity_type
                    ccui.Helper:seekWidgetByName(root, "Panel_vip_get"):setBackGroundImage(fileName)
                    break
                end
            end
        end 
    end
    if isShow == true then
        self:updateDraw()
    end

    if isShow == false then
        state_machine.excute("sm_activity_vip_push_window_close", 0, nil)
    end
end

-- 判断是否为当天第一次登陆
function SmActivityVipPush:dailyFirstLogin()
    local nowSeverTime = os.time() + _ED.time_add_or_sub
	
    local day = math.floor(nowSeverTime / 86400)
    local openState = cc.UserDefault:getInstance():getStringForKey("poster_push_daily_first_login"..self._activityType.._ED.user_info.user_id, "")
	
    if openState == "" or openState == nil then
        cc.UserDefault:getInstance():setStringForKey("poster_push_daily_first_login"..self._activityType.._ED.user_info.user_id, day)
        cc.UserDefault:getInstance():flush()
        return true
    end
    if tonumber(day) == tonumber(openState) then
        return false
	else
		cc.UserDefault:getInstance():setStringForKey("poster_push_daily_first_login"..self._activityType.._ED.user_info.user_id, day)
        cc.UserDefault:getInstance():flush()
	end
	
	return true
end

function SmActivityVipPush:updateDraw()
    if self._activityType == 182 then
        if self.Button_go ~= nil then
            self.Button_go:setVisible(true)
        end
        if self.Button_chacha ~= nil then
            self.Button_chacha:setVisible(true)
        end
        if self.Button_close ~= nil then
            self.Button_close:setVisible(false)
        end
    else
        if self.Button_go ~= nil then
            self.Button_go:setVisible(false)
        end
        if self.Button_chacha ~= nil then
            self.Button_chacha:setVisible(false)
        end
        if self.Button_close ~= nil then
            self.Button_close:setVisible(true)
        end
    end
end

function SmActivityVipPush:onInit( )
    local csbItem = csb.createNode("activity/wonderful/activity_vip_push.csb")
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    local action = csb.createTimeline("activity/wonderful/activity_vip_push.csb")
    table.insert(self.actions, action)
    csbItem:runAction(action)
    action:play("window_open", false)

    -- 关闭按钮
    self.Button_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "sm_activity_vip_push_choose",
        terminal_state = 0,
        instance = self,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

    -- 前往按钮
    self.Button_go = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go"), nil, 
    {
        terminal_name = "sm_activity_vip_push_jump_page",
        terminal_state = 0,
        instance = self,
        touch_scale = true,
        touch_scale_xy = 0.95,
        _self = self,
    }, nil, 0)

    -- 右上角关闭按钮
    self.Button_chacha = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chacha"), nil, 
    {
        terminal_name = "sm_activity_vip_push_choose",
        terminal_state = 0,
        instance = self,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

    self:updateInfo()
end

function SmActivityVipPush:init(params)
    self._listInfo = params
    -- self._notification_type = params[1]
    -- self._addition_png = params[2]
    -- self._tracking = params[3]
    -- local order = params[4]
    -- local server_date = os.date("%x", _ED.system_time)
    -- local save_date = cc.UserDefault:getInstance():getStringForKey(getKey("notification_popup_windows_" .. self._notification_type), "")
    -- self._isSelectEd = save_date == server_date

    -- self._zorder = order
	self:onInit()
    return self
end

function SmActivityVipPush:onExit()
    -- local root = self.roots[1]

    -- local save_date = ""
    -- if true == self._isSelectEd then
    --     save_date = os.date("%x", _ED.system_time)
    -- end
    -- cc.UserDefault:getInstance():setStringForKey(getKey("notification_popup_windows_" .. self._notification_type), save_date)

    state_machine.remove("sm_activity_vip_push_goto")
    state_machine.remove("sm_activity_vip_push_choose")
    state_machine.remove("sm_activity_vip_push_jump_page")
    
end
