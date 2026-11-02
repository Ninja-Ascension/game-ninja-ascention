-- ----------------------------------------------------------------------------------------------------
-- 说明：好友管理
-------------------------------------------------------------------------------------------------------
AdventureFriendManger = class("AdventureFriendMangerClass", Window)

app.load("client.adventure.cells.friend.adventure_firend_list_cell")

function AdventureFriendManger:ctor()
    self.super:ctor()
    self.roots = {}
    self.friendCount = 0
    self.maxFriendCount = 20                -- 最大好友数

    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
    self.state = nil
    self.Panel_noFriend = nil

    -- Initialize adventure friend manager state machine.
    local function init_adventure_friend_manager_terminal()
        -- 搜索好友
        local adventure_friend_manager_search_terminal = {
            _name = "adventure_friend_manager_search",
            _init = function (terminal)
                app.load("client.adventure.friend.AdventureFriendSearch")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureFriendSearch:new(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        local adventure_friend_manager_recommend_terminal = {
            _name = "adventure_friend_manager_recommend",
            _init = function (terminal)
                app.load("client.adventure.friend.AdventureFriendRecommend")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureFriendRecommend:new(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }


        -- 更新好友列表
        local adventure_friend_manager_update_friend_list_terminal = {
            _name = "adventure_friend_manager_update_friend_list",
            _init = function (terminal)
                app.load("client.adventure.friend.AdventureFriendSearch")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                self:updateListView()
                self:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        -- 好友申请
        local adventure_friend_manager_apply_terminal = {
            _name = "adventure_friend_manager_apply",
            _init = function (terminal)
                app.load("client.adventure.friend.AdventureFriendApply")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureFriendApply:new(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        -- 删除好友
        local adventure_friend_manager_del_friends_terminal = {
            _name = "adventure_friend_manager_del_friends",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local delBtn = params._datas._switch_buttons.deleteBtn
                local exitBtn = params._datas._switch_buttons.exitBtn

                delBtn:setVisible(false)
                exitBtn:setVisible(true)
                instance.state = "delete" 
                instance:switchFriendsDeleteState("delete")

                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        -- 退出删除好友
        local adventure_friend_manager_exit_del_friends_terminal = {
            _name = "adventure_friend_manager_exit_del_friends",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local delBtn = params._datas._switch_buttons.deleteBtn
                local exitBtn = params._datas._switch_buttons.exitBtn

                delBtn:setVisible(true)
                exitBtn:setVisible(false)

                instance.state = "exit" 
                instance:switchFriendsDeleteState("exit")

                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        --移除好友(删除时调用)
        local adventure_friend_manager_delete_friend_terminal = {
            _name = "adventure_friend_manager_delete_friend",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:deleteFriend(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 增加好友
        local adventure_friend_manager_insert_friend_terminal = {
            _name = "adventure_friend_manager_insert_friend",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseInitCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        instance:updateListView()
                        instance:updateDraw()
                    end
                end
                NetworkManager:register(protocol_command.friend_update.code, nil, nil, nil, nil, responseInitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_friend_manager_search_terminal)
        state_machine.add(adventure_friend_manager_apply_terminal)
        state_machine.add(adventure_friend_manager_del_friends_terminal)
        state_machine.add(adventure_friend_manager_exit_del_friends_terminal)
        state_machine.add(adventure_friend_manager_delete_friend_terminal)
        state_machine.add(adventure_friend_manager_insert_friend_terminal)
        state_machine.add(adventure_friend_manager_update_friend_list_terminal)
        state_machine.add(adventure_friend_manager_recommend_terminal)
        state_machine.init()
    end
    
    -- call func init adventure friend manager state machine.
    init_adventure_friend_manager_terminal()
end

function AdventureFriendManger:init()
	return self
end

function AdventureFriendManger:onUpdate(dt)
    if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
        local size = self.currentListView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.currentListView:getItems()
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

function AdventureFriendManger:updateListView()
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_friend")

    listView:removeAllItems()
    self.friendCount = 0

     local sortFunc = function( cell1, cell2 )
        return cell2._flag > cell1._flag
    end

    local items = {}
    for i,v in pairs(_ED.friend_info) do
        if tonumber(v.is_send) == 1 then 
         -- 领取了的,放在后面
            v._flag = 1
        else 
            v._flag = 0
        end
        table.insert(items,v)
    end
  
    table.sort(items, sortFunc)
    for i,v in pairs(items) do
        local cell = AdventureFirendListCell:createCell()
        cell:init(v, i,self)
        listView:addChild(cell)
        self.friendCount = self.friendCount + 1
        listView:requestRefreshView()
    end
    self.currentListView = listView
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function AdventureFriendManger:switchFriendsDeleteState(state)
    local items = self.currentListView:getItems()
    
    for i, v in ipairs(items) do
        state_machine.excute("firend_list_cell_update_del_send_button", 0, {_cell = v, _state = state})
    end
end

function AdventureFriendManger:deleteFriend(_id)
    local deleted = false
    local items = self.currentListView:getItems()
    for i,v in pairs(items) do
        if tonumber(v.friendInfo.user_id) == tonumber(_id) then
            self.currentListView:removeItem(i-1)
            deleted = true
        end
    end

    if deleted then
        self.friendCount = self.friendCount - 1
        if self.friendCount < 0 then
            self.friendCount = 0
        end

        self:updateDraw()
    end
end

function AdventureFriendManger:updateDraw()
    local root = self.roots[1]
    local idText = ccui.Helper:seekWidgetByName(root, "Text_id")
    idText:setString(_ED.user_info.user_id)

    local heartText = ccui.Helper:seekWidgetByName(root, "Text_aixin")
    heartText:setString(_ED.user_friendship_data.friendship_value) --_ED.user_info.endurance

    local friendNum = ccui.Helper:seekWidgetByName(root, "Text_number")
    friendNum:setString("(" .. self.friendCount .. "/" .. self.maxFriendCount .. ")")
      if #_ED.friend_info > 0 then 
        --有玩家
        self.Panel_noFriend:setVisible(false)
    else
        self.Panel_noFriend:setVisible(true)
        --无玩家
    end
end

function AdventureFriendManger:onEnterTransitionFinish()
	local csbAdventureFriendManger = csb.createNode("friend/friend.csb")
    local root = csbAdventureFriendManger:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureFriendManger)
    self.Panel_noFriend = ccui.Helper:seekWidgetByName(root, "Panel_friend_1")
    self.Panel_noFriend:setVisible(false)

    --搜索好友
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_friend_1"), nil, 
    {
        terminal_name = "adventure_friend_manager_search", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    },
    nil,0)

    --好友推荐
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shousuo_0"), nil, 
    {
        terminal_name = "adventure_friend_manager_recommend", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    },
    nil,0)


    self.state = "exit"

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
		terminal_name = "menu_manager",     
		next_terminal_name = "menu_show_home_page", 
		current_button_name = "Button_daditu",
		but_image = "Image_daditu",         
		terminal_state = 0, 
		isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 搜索好友
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shousuo"), nil, 
    {
        terminal_name = "adventure_friend_manager_search", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    },
    nil,0)

    -- 好友申请
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shengqing"), nil, 
    {
        terminal_name = "adventure_friend_manager_apply", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    },
    nil,0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_adventure_home_friend",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_shengqing"),
        _invoke = nil,
        _interval = 0.8,})
    -- 删除/退出删除好友
    local delButton = ccui.Helper:seekWidgetByName(root, "Button_del")
    local exitButton = ccui.Helper:seekWidgetByName(root, "Button_exit")
    delButton:setVisible(true)
    exitButton:setVisible(false)
    fwin:addTouchEventListener(delButton, nil, 
    {
        terminal_name = "adventure_friend_manager_del_friends", 
        terminal_state = 0,
        _switch_buttons = {deleteBtn = delButton, exitBtn = exitButton},
        isPressedActionEnabled = true,
    },
    nil,0)

    fwin:addTouchEventListener(exitButton, nil, 
    {
        terminal_name = "adventure_friend_manager_exit_del_friends", 
        terminal_state = 0,
        _switch_buttons = {deleteBtn = delButton, exitBtn = exitButton},
        isPressedActionEnabled = true,
    },
    nil,0)

    -- 刷新好友
    local function responseInitCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            self:updateListView()
            self:updateDraw()
        end
    end
    NetworkManager:register(protocol_command.friend_update.code, nil, nil, nil, nil, responseInitCallback, false, nil)

    --self:updateListView()
    --self:updateDraw()
end

function AdventureFriendManger:onExit()
    state_machine.remove("adventure_friend_manager_search")
    state_machine.remove("adventure_friend_manager_apply")
    state_machine.remove("adventure_friend_manager_del_friends")
    state_machine.remove("adventure_friend_manager_exit_del_friends")
    state_machine.remove("adventure_friend_manager_delete_friend")
    state_machine.remove("adventure_friend_manager_insert_friend")
    state_machine.remove("adventure_friend_manager_update_friend_list")
end