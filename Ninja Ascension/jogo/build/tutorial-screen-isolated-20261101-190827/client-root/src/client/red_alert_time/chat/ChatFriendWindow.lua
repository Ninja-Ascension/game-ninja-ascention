-- ---------------------------
-- 联系人
-- ---------------------------
ChatFriendWindow = class("ChatFriendWindowClass", Window)

local chat_friend_window_open_terminal = {
    _name = "chat_friend_window_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("ChatFriendWindowClass")
        if nil == _Window then
            fwin:open(ChatFriendWindow:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local chat_friend_window_close_terminal = {
    _name = "chat_friend_window_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ChatFriendWindowClass"))
        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(chat_friend_window_open_terminal)
state_machine.add(chat_friend_window_close_terminal)
state_machine.init()

function ChatFriendWindow:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_page = 0
    self._pages = {}
    self._buttons = {}

    self._from_type = 0         -- 1：私聊，2：侦查仪，3：写邮件，4：发红包

    app.load("client.red_alert_time.chat.ChatFriendWindowListview")

    local function init_chat_friend_window_terminal()
        local chat_friend_window_change_page_terminal = {
            _name = "chat_friend_window_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeSelectPage(params._datas._page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local chat_friend_window_change_update_state_terminal = {
            _name = "chat_friend_window_change_update_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateDrawState()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(chat_friend_window_change_page_terminal)
        state_machine.add(chat_friend_window_change_update_state_terminal)
        state_machine.init()
    end
    init_chat_friend_window_terminal()
end

function ChatFriendWindow:updateDrawState( ... )
    for k,v in pairs(self._pages) do
        state_machine.excute("chat_friend_window_list_update", 0, v)
    end
end

function ChatFriendWindow:changeSelectPage(page)
    local root = self.roots[1]
    local Panel_search = ccui.Helper:seekWidgetByName(root, "Panel_search")
    for k,v in pairs(self._buttons) do
        if page == k then
            v:setHighlighted(true)
        else
            v:setHighlighted(false)
        end
    end
    if page == self._current_page then
        return
    end
    self._current_page = page
    for k,v in pairs(self._pages) do
        v:setVisible(false)
    end
    if self._pages[""..page] == nil then
        self._pages[""..page] = state_machine.excute("chat_friend_window_listview_open", 0, {Panel_search, page, self._from_type})
    else
        self._pages[""..page]:setVisible(true)
    end

    local Text_not_payer = ccui.Helper:seekWidgetByName(root, "Text_not_payer")
    Text_not_payer:setVisible(true)
    if self._current_page == 1 then
        local have_friend = false
        for i, v in pairs(_ED.friend_info) do
            if v.is_delete ~= "" and v.is_delete ~= nil and tonumber(v.is_delete) == 0 then
                have_friend = true
                break
            end
        end
        if have_friend == false then
            Text_not_payer:setString(red_alert_time_str[282])
        else
            Text_not_payer:setString("")
        end
    else
        if _ED.union.union_info == nil 
            or _ED.union.union_info == {} 
            or _ED.union.union_info.union_id == nil 
            or _ED.union.union_info.union_id == "" 
            or tonumber(_ED.union.union_info.union_id) == 0 
            then
            Text_not_payer:setString(red_alert_time_str[158])
        else
            if tonumber(_ED.union.union_member_list_sum) ~= nil and tonumber(_ED.union.union_member_list_sum) <= 1 then
                Text_not_payer:setString(red_alert_time_str[283])
            else
                Text_not_payer:setString("")
            end
        end
    end
end

function ChatFriendWindow:onEnterTransitionFinish()

end

function ChatFriendWindow:onInit(params)
    local csbItem = csb.createNode(config_csb.chats.chat_friend_window)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "chat_friend_window_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "chat_friend_window_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    self._buttons = {ccui.Helper:seekWidgetByName(root, "Button_search_people"),
                    ccui.Helper:seekWidgetByName(root, "Button_search_mine")}

    for k,v in pairs(self._buttons) do
        fwin:addTouchEventListener(v, nil, 
        {
            terminal_name = "chat_friend_window_change_page", 
            terminal_state = 0, 
            _page = k,
        }, nil, 1)
    end

    local page = 1
    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        page = tonumber(params._datas._page)
    end

    local function getLegionMemberInfo()
        if _ED.union.union_info == nil 
            or _ED.union.union_info == {} 
            or _ED.union.union_info.union_id == nil 
            or _ED.union.union_info.union_id == "" 
            or tonumber(_ED.union.union_info.union_id) == 0 
            then
            self:changeSelectPage(page)
        else
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                       response.node:changeSelectPage(page)
                    end
                end
            end
            protocol_command.union_persion_list.param_list = _ED.union.union_info.union_id.."\r\n".._ED.union.union_info.union_camp
            NetworkManager:register(protocol_command.union_persion_list.code, nil, nil, nil, self, responseCallback, false, nil)
        end
    end

    local function responseInitCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                getLegionMemberInfo()
            end
        end
    end
    NetworkManager:register(protocol_command.friend_update.code, nil, nil, nil, self, responseInitCallback, false, nil)
end

function ChatFriendWindow:init(params)
    self._from_type = params._datas.from_type
    self:setTouchEnabled(true)
    self:onInit(params)
    return self
end

function ChatFriendWindow:onExit()
    state_machine.remove("chat_friend_window_change_page")
    state_machine.remove("chat_friend_window_change_update_state")
end
