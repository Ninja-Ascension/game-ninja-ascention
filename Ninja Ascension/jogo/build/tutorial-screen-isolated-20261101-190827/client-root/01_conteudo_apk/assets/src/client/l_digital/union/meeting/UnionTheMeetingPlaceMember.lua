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
    self.listView = nil
    app.load("client.l_digital.cells.union.union_the_meeting_place_member_cell")
    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
	self.ischange = false
    self._post = -1
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
    -- print("============",tonumber(_ED.union.union_member_list_sum))
    if tonumber(_ED.union.union_member_list_sum) == nil then
        return
    end

    local root = self.roots[1]
    if root == nil then
        return
    end


    -- self.ischange = false
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
    self.listView = ccui.Helper:seekWidgetByName(root, "ListView_072")


    UnionTheMeetingPlaceMember.asyncIndex = 1
    UnionTheMeetingPlaceMember.cacheListView =  self.listView 
    
    if #self.listView:getItems() > 0 then
        self.listView:removeAllItems()
    end

    -- if #self.listView:getItems() > 0 then
        -- self.listView:removeAllItems()
    -- end
    for i=1,tonumber(_ED.union.union_member_list_sum) do
        local infoData = arry[i]
        local cell = UnionTheMeetingPlaceMemberCell:createCell():init(infoData,UnionTheMeetingPlaceMember.asyncIndex)

        UnionTheMeetingPlaceMember.cacheListView:addChild(cell)
        UnionTheMeetingPlaceMember.cacheListView:requestRefreshView()
        UnionTheMeetingPlaceMember.asyncIndex = UnionTheMeetingPlaceMember.asyncIndex + 1
        -- print("============",i)
    end
    UnionTheMeetingPlaceMember.cacheListView:jumpToTop()

    self.currentListView = UnionTheMeetingPlaceMember.cacheListView
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    self.listViewPosYOne = self.listView:getInnerContainer():getPositionY()
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
            if tempY + itemSize.height < 0 or tempY > size.height + itemSize.height then
                v:unload()
            else
                v:reload()
            end
        end
    end
    -- if self.listView == nil then
    --     return
    -- end
    -- local size = self.listView:getContentSize()
    -- local posY = self.listView:getInnerContainer():getPositionY()
    -- local items = self.listView:getItems()    
    -- if self.listViewPosYOne == posY then
    --     return
    -- end
    -- self.listViewPosYOne = posY
    -- if items[1] == nil then
    --     return
    -- end
    -- local itemSize = items[1]:getContentSize()
    -- for i, v in pairs(items) do
    --     local tempY = v:getPositionY() + posY
    --     if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
    --         v:unload()
    --     else
    --         v:reload()
    --     end
    -- end
end


function UnionTheMeetingPlaceMember:onInit()
	self:updateDraw()
    self:registerOnNoteUpdate(self, 1)
end

function UnionTheMeetingPlaceMember:onEnterTransitionFinish()
    local csbUnionTheMeetingPlaceMember = csb.createNode("legion/legion_procedure_hall_listview.csb")
    local root = csbUnionTheMeetingPlaceMember:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnionTheMeetingPlaceMember)

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