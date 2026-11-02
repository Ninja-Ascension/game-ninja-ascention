--------------------------------------------------------------------------------------------------------------
--  说明：军团议事大厅动态界面
--------------------------------------------------------------------------------------------------------------
UnionTheMeetingPlaceTrends = class("UnionTheMeetingPlaceTrendsClass", Window)

--打开界面
local union_the_meeting_place_trends_open_terminal = {
    _name = "union_the_meeting_place_trends_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local unionTheMeetingPlaceTrendsWindow = fwin:find("UnionTheMeetingPlaceTrendsClass")
        if unionTheMeetingPlaceTrendsWindow ~= nil and unionTheMeetingPlaceTrendsWindow:isVisible() == true then
            return true
        end
        state_machine.lock("union_the_meeting_place_trends_open", 0, "")
        return UnionTheMeetingPlaceTrends:createCell()
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local union_the_meeting_place_trends_close_terminal = {
    _name = "union_the_meeting_place_trends_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        UnionTheMeetingPlaceTrends:closeCell()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_the_meeting_place_trends_open_terminal)
state_machine.add(union_the_meeting_place_trends_close_terminal)
state_machine.init()

function UnionTheMeetingPlaceTrends:ctor()
	self.super:ctor()
	self.roots = {}
    self.listView = nil
    self.listViewPosYOne = nil
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        app.load("client.l_digital.cells.union.union_the_meeting_trends_other_cell")
    else
	   app.load("client.cells.union.union_the_meeting_trends_other_cell")
	end
	 -- Initialize union the meeting place trends machine.
    local function init_union_the_meeting_place_trends_terminal()
		
		-- 隐藏界面
        local union_the_meeting_place_trends_hide_event_terminal = {
            _name = "union_the_meeting_place_trends_hide_event",
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
        local union_the_meeting_place_trends_show_event_terminal = {
            _name = "union_the_meeting_place_trends_show_event",
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
		local union_the_meeting_place_trends_refresh_info_terminal = {
            _name = "union_the_meeting_place_trends_refresh_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(union_the_meeting_place_trends_hide_event_terminal)
		state_machine.add(union_the_meeting_place_trends_show_event_terminal)
		state_machine.add(union_the_meeting_place_trends_refresh_info_terminal)
        state_machine.init()
    end
    
    -- call func init union the meeting place trends  machine.
    init_union_the_meeting_place_trends_terminal()

end

function UnionTheMeetingPlaceTrends:onHide()
	self:setVisible(false)
end

function UnionTheMeetingPlaceTrends:onShow()
	self:setVisible(true)
end

function UnionTheMeetingPlaceTrends:onUpdate( dt )
    if self.listView == nil then
        return
    end
    local size = self.listView:getContentSize()
    local posY = self.listView:getInnerContainer():getPositionY()
    local items = self.listView:getItems()    
    if self.listViewPosYOne == posY then
        return
    end
    self.listViewPosYOne = posY
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

function UnionTheMeetingPlaceTrends:updateDraw()
    local root = self.roots[1]
    self.listView = ccui.Helper:seekWidgetByName(root, "ListView_12")
    self.listView:removeAllItems()
    if _ED.union.union_message_number == nil or zstring.tonumber(_ED.union.union_message_number) == 0 then
        return
    end
    local arry = _ED.union.union_message_info_list
    local function sortfunction( a,b )
        local result = false
        if tonumber(a.dateTime) > tonumber(b.dateTime)  then
            return true
        end 
        return result
    end
    table.sort( arry, sortfunction )
    for i = 1, zstring.tonumber(_ED.union.union_message_number) do 
        local info = arry[i]
        if info ~= nil then
            local cell = UnionTheMeetingTrendsOtherCell:createCell():init(info, i)
            self.listView:addChild(cell)
        end
    end
    self.listViewPosYOne = self.listView:getInnerContainer():getPositionY()
end

function UnionTheMeetingPlaceTrends:onInit()
	self:updateDraw()
    self:registerOnNoteUpdate(self)
end

function UnionTheMeetingPlaceTrends:onEnterTransitionFinish()
    local csbUnionTheMeetingPlaceTrendsCell = csb.createNode("legion/legion_procedure_hall_dongtai.csb")
    local root = csbUnionTheMeetingPlaceTrendsCell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnionTheMeetingPlaceTrendsCell)

    self:init()
    state_machine.unlock("union_the_meeting_place_trends_open", 0, "")
end

function UnionTheMeetingPlaceTrends:init()
	self:onInit()
	return self
end

function UnionTheMeetingPlaceTrends:onExit()
    self:unregisterOnNoteUpdate(self)
	state_machine.remove("union_the_meeting_place_trends_hide_event")
	state_machine.remove("union_the_meeting_place_trends_show_event")
	state_machine.remove("union_the_meeting_place_trends_refresh_info")
end

function UnionTheMeetingPlaceTrends:createCell( ... )
    local cell = UnionTheMeetingPlaceTrends:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

function UnionTheMeetingPlaceTrends:closeCell( ... )
    local unionTheMeetingPlaceTrendsWindow = fwin:find("UnionTheMeetingPlaceTrendsClass")
    if unionTheMeetingPlaceTrendsWindow == nil then
        return
    end
    fwin:close(unionTheMeetingPlaceTrendsWindow)
end