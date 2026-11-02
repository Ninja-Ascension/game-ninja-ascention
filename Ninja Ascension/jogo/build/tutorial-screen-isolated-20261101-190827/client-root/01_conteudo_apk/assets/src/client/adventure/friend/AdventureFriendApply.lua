-- ----------------------------------------------------------------------------------------------------
-- 说明：好友申请
-------------------------------------------------------------------------------------------------------
AdventureFriendApply = class("AdventureFriendApplyClass", Window)
    
app.load("client.adventure.cells.friend.adventure_firend_apply_list_cell")

function AdventureFriendApply:ctor()
    self.super:ctor()
    self.roots = {}

    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0

    -- Initialize adventure friend apply state machine.
    local function init_adventure_friend_apply_terminal()
    	--关闭
		local adventure_friend_apply_close_terminal = {
            _name = "adventure_friend_apply_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
			
        -- 删除好友申请
        local adventure_friend_apply_delete_terminal = {
            _name = "adventure_friend_apply_delete",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:deleteFriendApply(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_friend_apply_close_terminal)
		state_machine.add(adventure_friend_apply_delete_terminal)

        state_machine.init()
    end
    
    -- call func init adventure friend apply state machine.
    init_adventure_friend_apply_terminal()
end

function AdventureFriendApply:init()

end

function AdventureFriendApply:deleteFriendApply(_id)
    local root = self.roots[1]
    local items = self.currentListView:getItems()
    for i,v in pairs(items) do
        if tonumber(v.friendInfo.user_id) == tonumber(_id) then
            self.currentListView:removeItem(i-1)
        end
    end
end

function AdventureFriendApply:onUpdate(dt)
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

function AdventureFriendApply:updateListView()
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_friend")

    listView:removeAllItems()

    for i = 1, tonumber(_ED.request_user_num) do
        local cell = AdventureFirendApplyListCell:createCell()
        cell:init(_ED.request_user[i], i, 1)
        listView:addChild(cell)
    end

    listView:requestRefreshView()

    self.currentListView = listView
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function AdventureFriendApply:updateSelect()
    local root = self.roots[1]
    local switchCheck = ccui.Helper:seekWidgetByName(root, "CheckBox_choose")
    local isSelected = switchCheck:isSelected()
    
    -- _is_accept_friend 1 同意接受好友申请  0 不同意
    if isSelected == false then
        -- TODO
        -- 实际上是选中了
        -- false 的时候是没有选中 ,实际上是执行的 已经选中状态 这里是因为checkbox组件,在点击时候,自己会把状态修改,处理完了后,又执行了这个回调.实际上是获取的上次的状态
        protocol_command.set_accept_friend_request.param_list = 0 .."\r\n"
        NetworkManager:register(protocol_command.set_accept_friend_request.code, nil, nil, nil, nil, recruitSendCallBack, false, nil)
    else
        protocol_command.set_accept_friend_request.param_list = 1 .."\r\n"
        NetworkManager:register(protocol_command.set_accept_friend_request.code, nil, nil, nil, nil, recruitSendCallBack, false, nil)
    end
end

function AdventureFriendApply:onEnterTransitionFinish()
	local csbFriendApply = csb.createNode("friend/friend_notice.csb")
    local root = csbFriendApply:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbFriendApply)

    local friendList = ccui.Helper:seekWidgetByName(root, "ListView_friend")

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
    	terminal_name = "adventure_friend_apply_close", 
    	terminal_state = 0, 
    	isPressedActionEnabled = true
    }, 
    nil, 0)

    local function onOpenTouchEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
            self:updateSelect()
        end
    end
   local checkbox  = ccui.Helper:seekWidgetByName(root, "CheckBox_choose")
   checkbox:addTouchEventListener(onOpenTouchEvent)

    checkbox:setSelected(_ED._is_accept_friend == 0)
    local function recruitInitCallBack(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            self:updateListView()
        end
    end
    
    NetworkManager:register(protocol_command.search_friend_apply.code, nil, nil, nil, nil, recruitInitCallBack, false, nil)
end

function AdventureFriendApply:onExit()
    state_machine.remove("adventure_friend_apply_close")
	state_machine.remove("adventure_friend_apply_delete")
end