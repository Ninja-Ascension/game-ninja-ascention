--------------------------------------------------------------------------------------------------------------
--  说明：军团议事大厅审核申请界面
--------------------------------------------------------------------------------------------------------------
UnionTheMeetingCheck = class("UnionTheMeetingCheckClass", Window)

--打开界面
local union_the_meeting_check_open_terminal = {
    _name = "union_the_meeting_check_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local unionTheMeetingCheckWindow = fwin:find("UnionTheMeetingCheckClass")
        if unionTheMeetingCheckWindow ~= nil and unionTheMeetingCheckWindow:isVisible() == true then
            return true
        end
        state_machine.lock("union_the_meeting_check_open", 0, "")
        fwin:open(UnionTheMeetingCheck:createCell(), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local union_the_meeting_check_close_terminal = {
    _name = "union_the_meeting_check_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        UnionTheMeetingCheck:closeCell()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_the_meeting_check_open_terminal)
state_machine.add(union_the_meeting_check_close_terminal)
state_machine.init()

function UnionTheMeetingCheck:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
    self.listView = nil
    self.listViewPosYOne = nil
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        app.load("client.l_digital.cells.union.union_then_meeting_check_cell")
    else
        app.load("client.cells.union.union_then_meeting_check_cell")
	end
	 -- Initialize union the meeting check machine.
    local function init_union_the_meeting_check_terminal()
		
		-- 隐藏界面
        local union_the_meeting_check_hide_event_terminal = {
            _name = "union_the_meeting_check_hide_event",
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
        local union_the_meeting_check_show_event_terminal = {
            _name = "union_the_meeting_check_show_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新信息
		local union_the_meeting_check_refresh_info_terminal = {
            _name = "union_the_meeting_check_refresh_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(union_the_meeting_check_hide_event_terminal)
		state_machine.add(union_the_meeting_check_show_event_terminal)
		state_machine.add(union_the_meeting_check_refresh_info_terminal)
        state_machine.init()
    end
    
    -- call func init union the meeting check  machine.
    init_union_the_meeting_check_terminal()

end

function UnionTheMeetingCheck:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function UnionTheMeetingCheck:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function UnionTheMeetingCheck:onUpdate( dt )
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

function UnionTheMeetingCheck:updateDraw()
    local root = self.roots[1]
    self.listView = ccui.Helper:seekWidgetByName(root, "ListView_123")
    self.listView:removeAllItems()
    if _ED.union.union_examine_list_sum ~= nil and tonumber(_ED.union.union_examine_list_sum) ~= 0 then
        ccui.Helper:seekWidgetByName(root, "Text_2"):setVisible(false)
        for i=1,tonumber(_ED.union.union_examine_list_sum) do
            local unionData = _ED.union.union_examine_list_info[i]
            local cell = UnionTheMeetingCheckCell:createCell():init(unionData, i)
            self.listView:addChild(cell)
        end
    else
        ccui.Helper:seekWidgetByName(root, "Text_2"):setVisible(true)
    end
    self.listViewPosYOne = self.listView:getInnerContainer():getPositionY()
end

function UnionTheMeetingCheck:onInit()
	self:updateDraw()
    self:registerOnNoteUpdate(self)
end

function UnionTheMeetingCheck:onEnterTransitionFinish()
    local csbUnionTheMeetingCheckCell = csb.createNode("legion/legion_pro_shenhe.csb")
    local root = csbUnionTheMeetingCheckCell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnionTheMeetingCheckCell)

    local action = csb.createTimeline("legion/legion_pro_shenhe.csb")
    table.insert(self.actions, action)
    csbUnionTheMeetingCheckCell:runAction(action)
    action:play("window_open", false)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_122"), nil, 
    {
        terminal_name = "union_the_meeting_check_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_123"), nil, 
    {
        terminal_name = "union_the_meeting_check_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self:init()

    state_machine.unlock("union_the_meeting_check_open", 0, "")
end

function UnionTheMeetingCheck:init()
	self:onInit()
	return self
end

function UnionTheMeetingCheck:onExit()
    self:unregisterOnNoteUpdate(self)
	state_machine.remove("union_the_meeting_check_hide_event")
	state_machine.remove("union_the_meeting_check_show_event")
	state_machine.remove("union_the_meeting_check_refresh_info")
end

function UnionTheMeetingCheck:createCell( ... )
    local cell = UnionTheMeetingCheck:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

function UnionTheMeetingCheck:closeCell( ... )
    local unionTheMeetingCheckWindow = fwin:find("UnionTheMeetingCheckClass")
    if unionTheMeetingCheckWindow == nil then
        return
    end
    fwin:close(unionTheMeetingCheckWindow)
end