--------------------------------------------------------------------------------------------------------------
--  说明：军团议事大厅成员界面
--------------------------------------------------------------------------------------------------------------
UnionTheMeetingPlaceMember = class("UnionTheMeetingPlaceMemberClass", Window)

--打开界面
local union_the_meeting_place_member_open_terminal = {
    _name = "union_the_meeting_place_member_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local unionTheMeetingPlaceMemberWindow = fwin:find("UnionTheMeetingPlaceMemberClass")
        if unionTheMeetingPlaceMemberWindow ~= nil and unionTheMeetingPlaceMemberWindow:isVisible() == true then
            return true
        end
        state_machine.lock("union_the_meeting_place_member_open", 0, "")
        return UnionTheMeetingPlaceMember:createCell()
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local union_the_meeting_place_member_close_terminal = {
    _name = "union_the_meeting_place_member_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        UnionTheMeetingPlaceMember:closeCell()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_the_meeting_place_member_open_terminal)
state_machine.add(union_the_meeting_place_member_close_terminal)
state_machine.init()

function UnionTheMeetingPlaceMember:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.red_alert.cells.union.union_the_meeting_place_member_cell")

    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
    self._post = -1
    self._height = 0
	-- Initialize union the meeting place member machine.
    local function init_union_the_meeting_place_member_terminal()
		-- 隐藏界面
        local union_the_meeting_place_member_hide_event_terminal = {
            _name = "union_the_meeting_place_member_hide_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 显示界面
        local union_the_meeting_place_member_show_event_terminal = {
            _name = "union_the_meeting_place_member_show_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onShow()
                instance:updateDraw()
                local height = instance.currentListView:getContentSize().height
                if instance._height > height then
                    instance.currentListView:getInnerContainer():setPositionY(height - instance._height)
                else
                    instance.currentListView:getInnerContainer():setPositionY(0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新信息
		local union_the_meeting_place_member_refresh_info_terminal = {
            _name = "union_the_meeting_place_member_refresh_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_the_meeting_place_information_refresh", 0, nil)
                instance:updateDraw()
                local height = instance.currentListView:getContentSize().height
                if instance._height > height then
                    instance.currentListView:getInnerContainer():setPositionY(height - instance._height)
                else
                    instance.currentListView:getInnerContainer():setPositionY(0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(union_the_meeting_place_member_hide_event_terminal)
		state_machine.add(union_the_meeting_place_member_show_event_terminal)
		state_machine.add(union_the_meeting_place_member_refresh_info_terminal)
        state_machine.init()
    end
    
    -- call func init union the meeting place member  machine.
    init_union_the_meeting_place_member_terminal()

end

function UnionTheMeetingPlaceMember:onHide()
	self:setVisible(false)
end

function UnionTheMeetingPlaceMember:onShow()
	self:setVisible(true)
end

function UnionTheMeetingPlaceMember:updateDraw()
    if tonumber(_ED.union.union_member_list_sum) == nil then
        return
    end
    local root = self.roots[1]
    if root == nil then
        return
    end

    self._post = tonumber(_ED.union.user_union_info.union_post) 
    local arry = _ED.union.union_member_list_info
    local function sortfunction( a,b )
        local result = false
        if tonumber(a.post) < tonumber(b.post)  then
            return true
        end 
        return result
    end
    table.sort( arry, sortfunction )
    self.currentListView = ccui.Helper:seekWidgetByName(root, "ListView_072")
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    if #self.currentListView:getItems() > 0 then
        self.currentListView:removeAllItems()
    end

    for i=1,tonumber(_ED.union.union_member_list_sum) do
        local infoData = arry[i]
        local cell = state_machine.excute("union_the_meeting_place_member_create_cell", 0, {infoData, i})
        self.currentListView:addChild(cell)
        
        self._height = cell:getContentSize().height + self._height
    end
    self.currentListView:requestRefreshView()
    self.listViewPosYOne = self.currentListView:getInnerContainer():getPositionY()
end

function UnionTheMeetingPlaceMember:onUpdate( dt )
    if _ED.union.user_union_info ~= nil and _ED.union.user_union_info.union_post ~= nil then
        if self._post ~= -1 and tonumber(_ED.union.user_union_info.union_post) ~= self._post  then
            self._post = tonumber(_ED.union.user_union_info.union_post)
            self:updateDraw()
        end
    end
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

function UnionTheMeetingPlaceMember:onInit()
	self:updateDraw()
    self:registerOnNoteUpdate(self)
end

function UnionTheMeetingPlaceMember:onEnterTransitionFinish()
    local csbItem = csb.createNode(config_csb.legion.legion_procedure_hall_listview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:init()
    state_machine.unlock("union_the_meeting_place_member_open", 0, "")
end

function UnionTheMeetingPlaceMember:init()
	self:onInit()
	return self
end

function UnionTheMeetingPlaceMember:onExit()
    self:unregisterOnNoteUpdate(self)
	state_machine.remove("union_the_meeting_place_member_hide_event")
	state_machine.remove("union_the_meeting_place_member_show_event")
	state_machine.remove("union_the_meeting_place_member_refresh_info")
end

function UnionTheMeetingPlaceMember:createCell( ... )
    local cell = UnionTheMeetingPlaceMember:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

function UnionTheMeetingPlaceMember:closeCell( ... )
    local unionTheMeetingPlaceMemberWindow = fwin:find("UnionTheMeetingPlaceMemberClass")
    if unionTheMeetingPlaceMemberWindow == nil then
        return
    end
    fwin:close(unionTheMeetingPlaceMemberWindow)
end