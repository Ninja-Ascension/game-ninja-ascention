SmFriendOther = class("SmFriendOtherClass", Window)

local sm_friend_other_open_terminal = {
    _name = "sm_friend_other_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = SmFriendOther:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_friend_other_open_terminal)
state_machine.init()

function SmFriendOther:ctor()
    self.super:ctor()
    self.roots = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    app.load("client.l_digital.cells.friend.sm_friend_cell")

    local function init_sm_friend_other_terminal()
        local sm_friend_other_show_terminal = {
            _name = "sm_friend_other_show",
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

        local sm_friend_other_hide_terminal = {
            _name = "sm_friend_other_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local root = instance.roots[1]
                -- local ListView_103 = ccui.Helper:seekWidgetByName(root,"ListView_103")
                -- local ScrollView_103 = ccui.Helper:seekWidgetByName(root,"ScrollView_103")
                -- if __lua_project_id == __lua_project_l_digital then
                --     local ScrollView_103 = ccui.Helper:seekWidgetByName(root,"ScrollView_103")
                --     ScrollView_103:jumpToTop()
                --     ScrollView_103:removeAllChildren(true)
                -- else
                    local ListView_103 = ccui.Helper:seekWidgetByName(root,"ListView_103")
                    ListView_103:jumpToTop()
                    ListView_103:removeAllItems()
                --end
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_friend_other_update_terminal = {
            _name = "sm_friend_other_update",
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

        local sm_friend_other_request_refresh_terminal = {
            _name = "sm_friend_other_request_refresh",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then 
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end
                NetworkManager:register(protocol_command.random_user_list.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --全部申请
        local sm_friend_other_reply_all_terminal = {
            _name = "sm_friend_other_reply_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function respondCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            for i, v in pairs(_ED.friend_find) do
                                v.isApplyEd = true
                            end
                            response.node:onUpdateDraw()
                        end
                        TipDlg.drawTextDailog(_new_interface_text[55])
                    end
                end
                local str = ""
                for i , v in pairs(_ED.friend_find) do
                    str = str..v.user_id..","
                end
                if str ~= nil then
                    str = string.sub(str, 1, -2)
                    protocol_command.friend_request.param_list = str .."\r\n".."1"
                    NetworkManager:register(protocol_command.friend_request.code, nil, nil, nil, instance, respondCallBack, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --搜索好友
        local sm_friend_other_search_by_name_terminal = {
            _name = "sm_friend_other_search_by_name",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local text = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_friend_name")
                if text:getString() == nil or text:getString() == "" then
                    TipDlg.drawTextDailog(_string_piece_info[280])
                else
                    local function respondCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                response.node:onUpdateDraw()
                            end
                        end
                    end
                    protocol_command.search_user.param_list = _ED.user_info.user_id .. "\r\n" ..text:getString()
                    NetworkManager:register(protocol_command.search_user.code, nil, nil, nil, instance, respondCallBack, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_friend_other_show_terminal)   
        state_machine.add(sm_friend_other_hide_terminal)
        state_machine.add(sm_friend_other_update_terminal)
        state_machine.add(sm_friend_other_request_refresh_terminal)
        state_machine.add(sm_friend_other_reply_all_terminal)
        state_machine.add(sm_friend_other_search_by_name_terminal)
        state_machine.init()
    end
    init_sm_friend_other_terminal()
end

function SmFriendOther:onUpdateDraw()
    local root = self.roots[1]
    local ListView_103 = ccui.Helper:seekWidgetByName(root,"ListView_103")
    local Text_friend_n = ccui.Helper:seekWidgetByName(root,"Text_friend_n")
    local Text_my_uid = ccui.Helper:seekWidgetByName(root,"Text_my_uid")
    ListView_103:jumpToTop()
    ListView_103:removeAllItems()
    Text_my_uid:setString(_ED.user_info.user_id)
    local max_friend_number = dms.int(dms["friend_config"], 1, friend_config.param)
    Text_friend_n:setString(_ED.friend_number.."/"..max_friend_number)

    -- if __lua_project_id == __lua_project_l_digital then
    --     local m_ScrollView = ccui.Helper:seekWidgetByName(root,"ScrollView_103")
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
    --     local number = #_ED.friend_find
    --     local m_number = math.ceil(number/2) + 1
    --     cellHeight = m_number*140+50
    --     sHeight = math.max(sHeight, cellHeight)
    --     panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
    --     local index = 1
    --     local cell_height = 0
    --     for j, v in pairs(_ED.friend_find) do
    --         --local cell = SmFriendCell:createCell()
    --         local cell = state_machine.excute("sm_friend_cell", 0, {2, v})          
    --         panel:addChild(cell)
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
        local ListView_103 = ccui.Helper:seekWidgetByName(root,"ListView_103")
        ListView_103:jumpToTop()
        ListView_103:removeAllItems()
        for i, v in pairs(_ED.friend_find) do
            local cell = state_machine.excute("sm_friend_cell", 0, {2, v})
            ListView_103:addChild(cell)
        end
        ListView_103:requestRefreshView()
    --end
end

function SmFriendOther:onUpdate( dt )
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

function SmFriendOther:onInit(params)
    local csbItem = csb.createNode("friend/friend_tuijian.csb")
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_298"), nil, 
    {
        terminal_name = "sm_friend_other_request_refresh", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_all_apply"), nil, 
    {
        terminal_name = "sm_friend_other_reply_all", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_find"), nil, 
    {
        terminal_name = "sm_friend_other_search_by_name", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, nil, 1)
    
    draw:addEditBox(ccui.Helper:seekWidgetByName(root, "TextField_friend_name"), _new_interface_text[49], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_find"), 16, cc.KEYBOARD_RETURNTYPE_DONE)
    self:onUpdateDraw()
end

function SmFriendOther:onEnterTransitionFinish()
end

function SmFriendOther:init(params)
    self._rootWindows = params[1]
    self:onInit()
    return self
end

function SmFriendOther:onExit()
    state_machine.remove("sm_friend_other_show")
    state_machine.remove("sm_friend_other_hide")
    state_machine.remove("sm_friend_other_update")
    state_machine.remove("sm_friend_other_request_refresh")
    state_machine.remove("sm_friend_other_reply_all")
    state_machine.remove("sm_friend_other_search_by_name")
end