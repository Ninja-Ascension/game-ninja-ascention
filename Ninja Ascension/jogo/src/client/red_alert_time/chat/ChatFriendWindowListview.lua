-- ------------------------------------------------------------------------------------------------------------
--  联系人Listview
-- ------------------------------------------------------------------------------------------------------------
ChatFriendWindowListview = class("ChatFriendWindowListviewClass", Window)

--打开界面
local chat_friend_window_listview_open_terminal = {
	_name = "chat_friend_window_listview_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = ChatFriendWindowListview:new():init(params)
		fwin:open(panel)
        return panel
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(chat_friend_window_listview_open_terminal)
state_machine.init()

function ChatFriendWindowListview:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self._page = 0
    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._Image_search_arrow_down = nil
    self._Image_search_arrow_up = nil

    self._from_type = 0

    app.load("client.red_alert_time.cells.chats.chat_friend_cell")

    local function init_chat_friend_window_listview_terminal()
        local chat_friend_window_listview_update_terminal = {
            _name = "chat_friend_window_listview_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params ~= nil and params.roots ~= nil and params.roots[1] ~= nil then
                    params:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(chat_friend_window_listview_update_terminal)
        state_machine.init()
    end
    
    init_chat_friend_window_listview_terminal()
end

function ChatFriendWindowListview:updateDraw()
    local root = self.roots[1]
    local ListView_search = ccui.Helper:seekWidgetByName(root, "ListView_search")
    self._list_view = ListView_search
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    if self._page == 1 then
        local result = {}
        for i, v in pairs(_ED.friend_info) do
            if v.is_delete ~= "" and v.is_delete ~= nil and tonumber(v.is_delete) == 0 then
                table.insert(result, v)
            end
        end
        function sortfunction(a, b)
            return tonumber(a.fighting) < tonumber(b.fighting)
        end
        table.sort(result, sortfunction)

        local index = 0
        for i,v in pairs(result) do
            local info_data = {}
            info_data.fighting = v.fighting
            info_data.name = v.name
            info_data.head_pic = v.head_pic
            info_data.user_id = v.user_id
            info_data._type = self._page
            if tonumber(self._from_type) == 5 then
                if _ED.union.union_member_list_info ~= nil then
                    for k,w in pairs(_ED.union.union_member_list_info) do
                        if tonumber(v.user_id) == tonumber(w.id) then
                            index = index + 1
                            local cell = state_machine.excute("chat_friend_create_cell", 0, {index,info_data, self._from_type})
                            ListView_search:addChild(cell)
                        end
                    end
                end
            else
                local cell = state_machine.excute("chat_friend_create_cell", 0, {i,info_data, self._from_type})
                ListView_search:addChild(cell)
            end
        end
    else
        if _ED.union.union_member_list_info ~= nil and tonumber(_ED.union.union_member_list_sum) ~= nil and tonumber(_ED.union.union_member_list_sum) > 0 then
            local arry = _ED.union.union_member_list_info
            function sortfunction(a, b)
                return tonumber(a.capactity) < tonumber(b.capactity)
            end
            table.sort(arry, sortfunction)
            for i=1,tonumber(_ED.union.union_member_list_sum) do
                local info = arry[i]
                if info ~= nil then
                    if tonumber(info.id) ~= tonumber(_ED.user_info.user_id) then
                        local info_data = {}
                        info_data.fighting = info.capactity
                        info_data.name = info.name
                        info_data.head_pic = info.user_head_id
                        info_data.user_id = info.id
                        info_data._type = self._page
                        local cell = state_machine.excute("chat_friend_create_cell", 0, {i, info_data, self._from_type})
                        ListView_search:addChild(cell)
                    end
                end
            end
        end
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()
end

function ChatFriendWindowListview:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_search_arrow_down:setVisible(true)
        else
            self._Image_search_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_search_arrow_up:setVisible(true)
        else
            self._Image_search_arrow_up:setVisible(false)
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

--初始化
function ChatFriendWindowListview:onInit()
    local csbItem = csb.createNode(config_csb.chats.chat_friend_window_listview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_search_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_search_arrow_down")
    self._Image_search_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_search_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_search_arrow_down:stopAllActions()
    self._Image_search_arrow_up:stopAllActions()
    playActions(self._Image_search_arrow_down)
    playActions(self._Image_search_arrow_up)
    self._Image_search_arrow_down:setVisible(false)
    self._Image_search_arrow_up:setVisible(false)

    self:updateDraw()
end

function ChatFriendWindowListview:onEnterTransitionFinish()

end

function ChatFriendWindowListview:init(param)
    self._rootWindows = param[1]
    self._page = param[2]
    self._from_type = param[3]
	self:onInit()
    return self
end

function ChatFriendWindowListview:onExit()
    state_machine.remove("chat_friend_window_listview_update")
end