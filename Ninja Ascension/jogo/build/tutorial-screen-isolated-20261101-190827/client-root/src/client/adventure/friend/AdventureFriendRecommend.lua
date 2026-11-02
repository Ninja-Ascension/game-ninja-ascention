-- ----------------------------------------------------------------------------------------------------
-- 说明：好友推荐
-------------------------------------------------------------------------------------------------------
AdventureFriendRecommend = class("AdventureFriendRecommendClass", Window)
    
function AdventureFriendRecommend:ctor()
    self.super:ctor()
    self.roots = {}
    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
    app.load("client.adventure.cells.friend.adventure_firend_recommend_list_cell")
    -- Initialize adventure friend search state machine.
    local function init_adventure_friend_recommend_terminal()
    	--刷新
		local adventure_friend_recommend_udpate_terminal = {
            _name = "adventure_friend_recommend_udpate",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onRefrush()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

     
		state_machine.add(adventure_friend_recommend_udpate_terminal)
        state_machine.init()
    end
    
    -- call func init adventure friend search state machine.
    init_adventure_friend_recommend_terminal()
end

function AdventureFriendRecommend:init()

end

function AdventureFriendRecommend:checkDel(_id)
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_103")
    local items = listView:getItems()
    for i,v in pairs(items) do
        if tonumber(v.person.user_id) == tonumber(_id) then
            listView:removeItem(i-1)
        end
    end
end

function AdventureFriendRecommend:onUpdateSort()
    local onTime = {}
    local leaveTime = {}
    local all = {}
    function _idSortTime(a, b)
        if a.leave_time < b.leave_time then
            return true
        end
        return false
    end
    
    function _idSortGrade(a, b)
        if a.grade > b.grade then
            return true
        end
        return false
    end
    
    for i , v in pairs(_ED.friend_find) do
        if tonumber(v.leave_time) > 0 then
            table.insert(leaveTime,v)
        else
            table.insert(onTime,v)
        end
    end
    
    table.sort(leaveTime, _idSortTime)
    table.sort(onTime, _idSortGrade)
    
    for i, v in ipairs(onTime) do
        table.insert(all, v)
    end
    for i, v in ipairs(leaveTime) do
        table.insert(all, v)
    end
    
    return all
end

function AdventureFriendRecommend:onRefrush()
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_103")
    local function responseInitCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            self.butStatus = false
            listView:removeAllItems()
            listView:requestRefreshView()
            listView:jumpToTop()
            for i , v in pairs(self:onUpdateSort()) do
                local cell = AdventureFirendRecommendListCell:createCell()
                cell:init(v,i)
                listView:addChild(cell)
            end
        end
    end
    NetworkManager:register(protocol_command.random_user_list.code, nil, nil, nil, nil, responseInitCallback, true, nil)
end

function AdventureFriendRecommend:isOpenRefreshTime()
    local times = math.ceil(os.time() - zstring.tonumber(_ED.friend_find_refresh_time))
    if times < 10 then
        return false
    end
    return true
end

function AdventureFriendRecommend:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_103")
    listView:removeAllItems()
    listView:requestRefreshView()
    local _ncount = 0
    for i , v in pairs(self:onUpdateSort()) do
        local cell = AdventureFirendRecommendListCell:createCell()
        cell:init(v,i)
        listView:addChild(cell)
        _ncount = _ncount + 1
        
    end

    listView:jumpToTop()    
    self.currentListView = listView
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY() 
end

function AdventureFriendRecommend:onUpdate(dt)
  if self.butStatus == false then
        local root = self.roots[1]
        local buttonRefresh = ccui.Helper:seekWidgetByName(root, "Button_298")
        local times = math.ceil(os.time() - zstring.tonumber(_ED.friend_find_refresh_time))
        if false == self:isOpenRefreshTime() and zstring.tonumber(_ED.friend_find_refresh_time) > 0 then
            ccui.Helper:seekWidgetByName(root, "Text_3"):setString(_string_piece_info[307] .. 10-times .. _string_piece_info[308])
            buttonRefresh:setBright(false)
            buttonRefresh:setTouchEnabled(false)
            self.startTime = times
        else
            self.butStatus = true
            buttonRefresh:setBright(true)
            buttonRefresh:setTouchEnabled(true)
            ccui.Helper:seekWidgetByName(root, "Text_3"):setString("")
        end
    end
end

function AdventureFriendRecommend:onEnterTransitionFinish()
	local csbFriendSearch = csb.createNode("friend/friend_tuijian.csb")
    local root = csbFriendSearch:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbFriendSearch)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_691"), nil, 
    {
    	func_string = [[fwin:close(fwin:find("AdventureFriendRecommendClass"))]],       
    	terminal_state = 0, 
    	isPressedActionEnabled = true
    }, 
    nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_298"), nil, 
	{
		terminal_name = "adventure_friend_recommend_udpate", 
		terminal_state = 0, 
		input_editbox = inputBox,
        friend_list = friendList,
		isPressedActionEnabled = true
	}, 
	nil, 0)

    
    local function responseInitCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            local node = fwin:find("AdventureFriendRecommendClass")
            if nil ~= node  then
                node.butStatus = false
                node.times = os.time()
                node:onUpdateDraw()
            end
        end
    end
    self.butStatus = true
    if true == self:isOpenRefreshTime()  then
        if nil ~= _ED.friend_find_number and zstring.tonumber(_ED.friend_find_number) > 0 then
            self:onUpdateDraw()
        else
            NetworkManager:register(protocol_command.random_user_list.code, nil, nil, nil, self, responseInitCallback, true, nil)
        end
    else
        self.butStatus = false
        self:onUpdateDraw()
    end
end


function AdventureFriendRecommend:updateCleanListView()
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_friend")

    listView:removeAllItems()
    listView:requestRefreshView()
    
end

function AdventureFriendRecommend:onExit()
	state_machine.remove("adventure_friend_recommend_udpate")
end