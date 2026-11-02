-----------------------------
-- 绑定谷歌账号
-----------------------------
BandingGooglePlay = class("BandingGooglePlayClass", Window)

local sm_binding_google_play_window_open_terminal = {
    _name = "sm_binding_google_play_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("BandingGooglePlayClass") then
            fwin:open(BandingGooglePlay:new():init(params), fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_binding_google_play_window_close_terminal = {
    _name = "sm_binding_google_play_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("BandingGooglePlayClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_binding_google_play_window_open_terminal)
state_machine.add(sm_binding_google_play_window_close_terminal)
state_machine.init()

function BandingGooglePlay:ctor()
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

    app.load("client.network.ConnectingView")

    local function init_sm_binding_google_play_terminal()
		local sm_binding_google_go_to_bind_terminal = {
            _name = "sm_binding_google_go_to_bind",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function callback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
                        fwin:open(getRewardWnd, fwin._notification)
                        state_machine.excute("sm_binding_google_play_window_close", 0, "")
                    end
                end

                if _ED.bind_google_paly_info and tonumber(_ED.bind_google_paly_info.bind_state) == 0 then
                    --打开谷歌登录
                    _ED.bind_google = true
                    state_machine.excute("platform_manager_login", 0, { messageType = LOGIN ,messageText = "1"})
                elseif _ED.bind_google_paly_info and tonumber(_ED.bind_google_paly_info.bind_state) == 1 then
                    NetworkManager:register(protocol_command.draw_google_bind_reward.code, nil, nil, nil, instance, callback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_binding_google_play_get_reword_terminal = {
            _name = "sm_binding_google_play_get_reword",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function callback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
                        fwin:open(getRewardWnd, fwin._notification)
                        if response.node ~= nil then
                            response.node:updateInfo()
                        end
                    end
                end

                NetworkManager:register(protocol_command.draw_google_bind_reward.code, nil, nil, nil, instance, callback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_binding_google_update_terminal = {
            _name = "sm_binding_google_update",
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

        state_machine.add(sm_binding_google_go_to_bind_terminal)
		state_machine.add(sm_binding_google_play_get_reword_terminal)
        state_machine.add(sm_binding_google_update_terminal)
        state_machine.init()
    end
    
    init_sm_binding_google_play_terminal()
end

function BandingGooglePlay:onSelectChoose()
    local root = self.roots[1]
end

function BandingGooglePlay:onEnterTransitionFinish()

end

function BandingGooglePlay:updateInfo()
    local root = self.roots[1]
    self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
    local ListView_receive_t = ccui.Helper:seekWidgetByName(root, "ListView_receive_t")
    ListView_receive_t:removeAllItems()
    local reword = zstring.splits(_ED.bind_google_paly_info.bind_reword_info, "|", ",")
    for i,v in ipairs(reword) do
        local cell = ResourcesIconCell:createCell()
        local rewardType = tonumber(v[1])
        cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1,table)
        ListView_receive_t:addChild(cell)

        ListView_receive_t:jumpToLeft()
    end
    
    --按钮
    local des = tonumber(_ED.bind_google_paly_info.bind_state) == 0 and tipStringInfo_bind_google_play_tips[2] or tipStringInfo_bind_google_play_tips[3]
    ccui.Helper:seekWidgetByName(root, "Button_ok"):setTitleText(des)

    --领取
    local Button_receive = ccui.Helper:seekWidgetByName(root, "Button_receive") 
    if tonumber(_ED.bind_google_paly_info.bind_state) == 0 then
        Button_receive:setBright(false)
        Button_receive:setTouchEnabled(false)
    else
        if tonumber(_ED.bind_google_paly_info.bind_reword_state) == 0 then
            Button_receive:setBright(true)
            Button_receive:setTouchEnabled(true)
        else
            Button_receive:setBright(false)
            Button_receive:setTouchEnabled(false)
            Button_receive:setTitleText(tipStringInfo_bind_google_play_tips[4])
        end
    end
end

function BandingGooglePlay:formatTimeString( _time )--系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%d", math.floor(tonumber(_time)/3600/24)) .. tipStringInfo_cross_server_battel_tips[28]
    timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)/3600)%24)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end

function BandingGooglePlay:onUpdate(dt)
    if nil ~= self.left_time then
        self.left_time = self.left_time - dt
        if self.left_time <= 0 then
            self.left_time = nil
        else
            self.Text_time:setString(self:formatTimeString(self.left_time))
        end
    end
end

function BandingGooglePlay:onInit()
    local csbItem = csb.createNode("utils/accounts_binding_prompt.csb")
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    local action = csb.createTimeline("utils/accounts_binding_prompt.csb")
    table.insert(self.actions, action)
    csbItem:runAction(action)
    action:play("window_open", false)
    
    -- 前往绑定/关闭按钮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ok"), nil, 
    {
        terminal_name = "sm_binding_google_go_to_bind",
        terminal_state = 0,
        instance = self,
    }, nil, 0)

    ccui.Helper:seekWidgetByName(root, "Button_receive"):setVisible(false)
    --领取按钮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_receive"), nil, 
    {
        terminal_name = "sm_binding_google_play_get_reword",
        terminal_state = 0,
        instance = self,
    }, nil, 0)

    --关闭按钮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "sm_binding_google_play_window_close",
        terminal_state = 0,
        instance = self,
    }, nil, 0)

    self:updateInfo()
    self:registerOnNoteUpdate(self, 1)
end

function BandingGooglePlay:init(params)
    self.left_time = zstring.tonumber(_ED.bind_google_paly_info.bind_close_time)/1000
	self:onInit()
    return self
end

function BandingGooglePlay:onExit()
end
