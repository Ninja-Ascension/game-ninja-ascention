SmFriendApply = class("SmFriendApplyClass", Window)

local sm_friend_apply_open_terminal = {
    _name = "sm_friend_apply_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = SmFriendApply:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_friend_apply_open_terminal)
state_machine.init()

function SmFriendApply:ctor()
    self.super:ctor()
    self.roots = {}

    self.currPage = 0
    self.maxPage = 0

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    local function init_sm_friend_apply_terminal()
        local sm_friend_apply_show_terminal = {
            _name = "sm_friend_apply_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(true)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_friend_apply_hide_terminal = {
            _name = "sm_friend_apply_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local root = instance.roots[1]
                local ListView_15 = ccui.Helper:seekWidgetByName(root,"ListView_15")
                ListView_15:jumpToTop()
                ListView_15:removeAllItems()
                -- if __lua_project_id == __lua_project_l_digital then
                --     local ScrollView_15 = ccui.Helper:seekWidgetByName(root,"ScrollView_15")
                --     ScrollView_15:jumpToTop()
                --     ScrollView_15:removeAllChildren(true)
                -- else
                --     local ListView_15 = ccui.Helper:seekWidgetByName(root,"ListView_15")
                --     ListView_15:jumpToTop()
                --     ListView_15:removeAllItems()
                -- end
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_friend_apply_update_terminal = {
            _name = "sm_friend_apply_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_friend_apply_all_refuse_terminal = {
            _name = "sm_friend_apply_all_refuse",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local user_id = ""
                for i, v in pairs(_ED.request_user) do
                    user_id = user_id..v.user_id..","
                end
                local function respondCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(_new_interface_text[57])
                        state_machine.excute("sm_friend_apply_update", 0, nil)
                        state_machine.excute("notification_center_update", 0, "push_notification_center_friend_apply")
                        state_machine.excute("notification_center_update", 0, "push_notification_center_friend_all")
                    end
                end
                if user_id ~= "" then
                    user_id = string.sub(user_id,1,-2)
                    protocol_command.friend_pass.param_list = user_id .."\r\n".."2"
                    NetworkManager:register(protocol_command.friend_pass.code, nil, nil, nil, instance, respondCallBack, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_friend_apply_all_agree_terminal = {
            _name = "sm_friend_apply_all_agree",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local user_id = ""
                for i, v in pairs(_ED.request_user) do 
                    user_id = user_id..v.user_id..","
                end
                local function respondCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(_new_interface_text[56])
                        state_machine.excute("sm_friend_apply_update", 0, nil)
                        state_machine.excute("notification_center_update", 0, "push_notification_center_friend_apply")
                        state_machine.excute("notification_center_update", 0, "push_notification_center_friend_all")
                    end
                end
                if user_id ~= "" then
                    user_id = string.sub(user_id, 1, -2)
                    protocol_command.friend_pass.param_list = user_id .."\r\n".."1"
                    NetworkManager:register(protocol_command.friend_pass.code, nil, nil, nil, instance, respondCallBack, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_friend_apply_change_page_terminal = {
            _name = "sm_friend_apply_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local currType = params._datas._type
                local page = instance.currPage + currType
                if page < 1 then
                    return
                end
                if page > instance.maxPage then
                    return
                end
                instance.currPage = page
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_friend_apply_show_terminal)   
        state_machine.add(sm_friend_apply_hide_terminal)
        state_machine.add(sm_friend_apply_update_terminal)
        state_machine.add(sm_friend_apply_all_refuse_terminal)
        state_machine.add(sm_friend_apply_all_agree_terminal)
        state_machine.add(sm_friend_apply_change_page_terminal)
        state_machine.init()
    end
    init_sm_friend_apply_terminal()
end

function SmFriendApply:onUpdateDraw()
    local root = self.roots[1]
    local onePageNumber = dms.int(dms["friend_config"], 5, friend_config.param)

    local request_user_num = tonumber(_ED.request_user_num)
    if request_user_num == nil then
        request_user_num = 0
    end

    self.maxPage = math.ceil(request_user_num / onePageNumber)
    self.maxPage = math.max(self.maxPage, 1)
    local Text_friend_n = ccui.Helper:seekWidgetByName(root,"Text_friend_n")
    local Text_sq_n = ccui.Helper:seekWidgetByName(root,"Text_sq_n")
    local ListView_15 = ccui.Helper:seekWidgetByName(root,"ListView_15")
    local Text_page_n = ccui.Helper:seekWidgetByName(root,"Text_page_n")
    local Text_tip = ccui.Helper:seekWidgetByName(root,"Text_tip")
    ListView_15:jumpToTop()
    ListView_15:removeAllItems()
    Text_sq_n:setString(request_user_num)
    Text_page_n:setString(self.currPage.."/"..self.maxPage)
    local max_friend_number = dms.int(dms["friend_config"], 1, friend_config.param)
    Text_friend_n:setString(_ED.friend_number.."/"..max_friend_number)

    Text_tip:setVisible(true)
    if tonumber(request_user_num) > 0 then
        Text_tip:setVisible(false)
    end

    if request_user_num == 0 then
        return
    end

    for i, v in pairs(_ED.request_user) do
        if i <= onePageNumber * self.currPage and i > onePageNumber * (self.currPage - 1) then
            local cell = state_machine.excute("sm_friend_cell", 0, {3, v})
            ListView_15:addChild(cell)
        end
    end
    ListView_15:requestRefreshView()

    -- if __lua_project_id == __lua_project_l_digital then
    --     local m_ScrollView = ccui.Helper:seekWidgetByName(root,"ScrollView_15")
    --     m_ScrollView:jumpToTop()
    --     local panel = m_ScrollView:getInnerContainer()
    --     panel:setContentSize(m_ScrollView:getContentSize())
    --     panel:setPosition(cc.p(0,0))
    --     panel:removeAllChildren(true)
    --     local sSize = panel:getContentSize()
    --     local sHeight = sSize.height
    --     local sWidth = sSize.width
    --     local controlSize = m_ScrollView:getInnerContainerSize()
    --     local nextY = sSize.height
    --     local nextX = sSize.width
    --     local tHeight = 0
    --     local cellHeight = 0
    --     local tWidth = 0
    --     local wPosition = sWidth/2
    --     local Hlindex = 0
    --     local number = #_ED.request_user
    --     local m_number = math.ceil(number/2) + 1
    --     cellHeight = m_number*140+50
    --     sHeight = math.max(sHeight, cellHeight)
    --     panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
    --     local index = 1
    --     local cell_height = 0
    --     for j, v in pairs(_ED.request_user) do
    --         if i <= onePageNumber * self.currPage and i > onePageNumber * (self.currPage - 1) then
    --             local cell = state_machine.excute("sm_friend_cell", 0, {3, v})
    --             panel:addChild(cell)
    --         end

    --         cell_height = cell:getContentSize().height
    --         tWidth = tWidth + wPosition
    --         if (index-1)%2 ==0 then
    --             Hlindex = Hlindex+1
    --             tWidth = 0
    --             tHeight = sHeight - cell_height*Hlindex  
    --         end
    --         if index <= 2 then
    --             tHeight = sHeight - cell_height
    --         end
    --         cell:setPosition(cc.p(tWidth,tHeight))
    --         index = index + 1
    --     end
    --     m_ScrollView:jumpToTop()
        
    --     self.currentScrollView = m_ScrollView
    --     self.currentScrollViewInnerContainer = self.currentScrollView:getInnerContainer()
    --     self.currentScrollViewInnerContainerPosY = self.currentScrollViewInnerContainer:getPositionY()
    -- else
    --     local ListView_103 = ccui.Helper:seekWidgetByName(root,"ListView_15")
    --     ListView_103:jumpToTop()
    --     ListView_103:removeAllItems()
    --     for i, v in pairs(_ED.request_user) do
    --         if i <= onePageNumber * self.currPage and i > onePageNumber * (self.currPage - 1) then
    --             local cell = state_machine.excute("sm_friend_cell", 0, {3, v})
    --             ListView_103:addChild(cell)
    --         end
    --     end
    --     ListView_103:requestRefreshView()
    -- end
end

function SmFriendApply:onUpdate( dt )
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_arrow_down:setVisible(true)
        else
            self._Image_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_arrow_up:setVisible(true)
        else
            self._Image_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function SmFriendApply:onInit(params)
    local csbItem = csb.createNode("friend/friend_requests.csb")
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_all_reject"), nil, 
    {
        terminal_name = "sm_friend_apply_all_refuse", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_all_agree"), nil, 
    {
        terminal_name = "sm_friend_apply_all_agree", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_flip_left"), nil, 
    {
        terminal_name = "sm_friend_apply_change_page", 
        terminal_state = 0, 
        _type = -1,
        isPressedActionEnabled = true
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_flip_right"), nil, 
    {
        terminal_name = "sm_friend_apply_change_page", 
        terminal_state = 0, 
        _type = 1,
        isPressedActionEnabled = true
    }, nil, 1)

    self.currPage = 1
    self:onUpdateDraw()
end

function SmFriendApply:onEnterTransitionFinish()
end

function SmFriendApply:init(params)
    self._rootWindows = params[1]
    self:onInit()
    return self
end

function SmFriendApply:onExit()
    state_machine.remove("sm_friend_apply_show")
    state_machine.remove("sm_friend_apply_hide")
    state_machine.remove("sm_friend_apply_update")
    state_machine.remove("sm_friend_apply_all_refuse")
    state_machine.remove("sm_friend_apply_all_agree")
    state_machine.remove("sm_friend_apply_change_page")
end