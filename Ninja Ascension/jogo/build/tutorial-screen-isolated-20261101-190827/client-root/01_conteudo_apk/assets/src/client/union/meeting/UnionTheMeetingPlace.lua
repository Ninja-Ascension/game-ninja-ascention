--------------------------------------------------------------------------------------------------------------
--  说明：军团议事大厅主界面
--------------------------------------------------------------------------------------------------------------
UnionTheMeetingPlace = class("UnionTheMeetingPlaceClass", Window)

--打开界面
local union_the_meeting_place_open_terminal = {
    _name = "union_the_meeting_place_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local unionTheMeetingPlaceWindow = fwin:find("UnionTheMeetingPlaceClass")
        if unionTheMeetingPlaceWindow ~= nil and unionTheMeetingPlaceWindow:isVisible() == true then
            return true
        end
        state_machine.lock("union_the_meeting_place_open", 0, "")
        fwin:open(UnionTheMeetingPlace:createCell(), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local union_the_meeting_place_close_terminal = {
    _name = "union_the_meeting_place_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        UnionTheMeetingPlace:closeCell()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_the_meeting_place_open_terminal)
state_machine.add(union_the_meeting_place_close_terminal)
state_machine.init()

local Choose_Type = {
    type_info = 1,
    type_member = 2,
    type_other = 3,
}

function UnionTheMeetingPlace:ctor()
	self.super:ctor()
	self.roots = {}
    self.chooseType = Choose_Type.type_info
    self.infoCell = nil
    self.memberCell = nil
    self.otherCell = nil
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        app.load("client.l_digital.union.meeting.UnionTheMeetingPlaceInformation")
        app.load("client.l_digital.union.meeting.UnionTheMeetingPlaceMember")
        app.load("client.l_digital.union.meeting.UnionTheMeetingPlaceTrends")
    else
        app.load("client.union.meeting.UnionTheMeetingPlaceInformation")
        app.load("client.union.meeting.UnionTheMeetingPlaceMember")
        app.load("client.union.meeting.UnionTheMeetingPlaceTrends")
    end
	
	 -- Initialize union the meeting place machine.
    local function init_union_the_meeting_place_terminal()
		-- 隐藏界面
        local union_the_meeting_place_hide_event_terminal = {
            _name = "union_the_meeting_place_hide_event",
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
        local union_the_meeting_place_show_event_terminal = {
            _name = "union_the_meeting_place_show_event",
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
		local union_the_meeting_place_refresh_terminal = {
            _name = "union_the_meeting_place_refresh",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawEx()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 打开军团信息界面
		local union_the_meeting_place_open_information_page_terminal = {
            _name = "union_the_meeting_place_open_information_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Button_huodong"):setHighlighted(true)
                else
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Button_xinxi"):setHighlighted(true)
                end
                ccui.Helper:seekWidgetByName(instance.roots[1], "Image_073"):setVisible(true)
                if instance.chooseType == Choose_Type.type_info then
                    return
                end
                instance.chooseType = Choose_Type.type_info
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--打开军团成员界面
		local union_the_meeting_place_open_member_page_terminal = {
            _name = "union_the_meeting_place_open_member_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chengyuan"):setHighlighted(true)
                ccui.Helper:seekWidgetByName(instance.roots[1], "Image_074"):setVisible(true)
                if instance.chooseType == Choose_Type.type_member then
                    return
                end
                instance.chooseType = Choose_Type.type_member
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 打开军团动态界面
		local union_the_meeting_place_open_trends_page_terminal = {
            _name = "union_the_meeting_place_open_trends_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                ccui.Helper:seekWidgetByName(instance.roots[1], "Button_dongtai"):setHighlighted(true)
                ccui.Helper:seekWidgetByName(instance.roots[1], "Image_075"):setVisible(true)
                if instance.chooseType == Choose_Type.type_other then
                    return
                end
                instance.chooseType = Choose_Type.type_other
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 打开审核申请界面
		local union_the_meeting_place_open_check_page_terminal = {
            _name = "union_the_meeting_place_open_check_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(union_the_meeting_place_hide_event_terminal)
		state_machine.add(union_the_meeting_place_show_event_terminal)
		state_machine.add(union_the_meeting_place_refresh_terminal)
		state_machine.add(union_the_meeting_place_open_information_page_terminal)
		state_machine.add(union_the_meeting_place_open_member_page_terminal)
		state_machine.add(union_the_meeting_place_open_trends_page_terminal)
		state_machine.add(union_the_meeting_place_open_check_page_terminal)
        state_machine.init()
    end
    
    -- call func init union the meeting place machine.
    init_union_the_meeting_place_terminal()

end

function UnionTheMeetingPlace:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function UnionTheMeetingPlace:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function UnionTheMeetingPlace:updateDrawEx( ... )
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Button_huodong"):setHighlighted(false)
    ccui.Helper:seekWidgetByName(root, "Button_chengyuan"):setHighlighted(false)
    ccui.Helper:seekWidgetByName(root, "Button_dongtai"):setHighlighted(false)
    ccui.Helper:seekWidgetByName(root, "Image_073"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Image_074"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Image_075"):setVisible(false)

    state_machine.excute("union_the_meeting_place_member_hide_event", 0, nil)
    state_machine.excute("union_the_meeting_place_trends_hide_event", 0, nil)
    if self.infoCell == nil then
        self.infoCell = state_machine.excute("union_the_meeting_place_information_open", 0, nil)
        local Panel_gg_xx = ccui.Helper:seekWidgetByName(root, "Panel_gg_xx")
        Panel_gg_xx:addChild(self.infoCell)
    end
    if self.chooseType == Choose_Type.type_info then
        state_machine.excute("union_change_right_list_view_state", 0, true)
        ccui.Helper:seekWidgetByName(root, "Button_huodong"):setHighlighted(true)
        ccui.Helper:seekWidgetByName(root, "Image_073"):setVisible(true)
    else
        if self.chooseType == Choose_Type.type_member then
            ccui.Helper:seekWidgetByName(root, "Button_chengyuan"):setHighlighted(true)
            ccui.Helper:seekWidgetByName(root, "Image_074"):setVisible(true)
            if self.memberCell == nil then
                self.memberCell = state_machine.excute("union_the_meeting_place_member_open", 0, nil)
                self:addChild(self.memberCell)
            else
                state_machine.excute("union_the_meeting_place_member_show_event", 0, nil)
            end
        else
            ccui.Helper:seekWidgetByName(root, "Button_dongtai"):setHighlighted(true)
            ccui.Helper:seekWidgetByName(root, "Image_075"):setVisible(true)
            if self.otherCell == nil then
                self.otherCell = state_machine.excute("union_the_meeting_place_trends_open", 0, nil)
                self:addChild(self.otherCell)
            else
                state_machine.excute("union_the_meeting_place_trends_show_event", 0, nil)
            end
        end
        state_machine.excute("union_change_right_list_view_state", 0, false)
    end
end

function UnionTheMeetingPlace:updateDraw()
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        self:updateDrawEx()
        return
    end
    state_machine.excute("union_the_meeting_place_information_hide_event", 0, nil)
    state_machine.excute("union_the_meeting_place_member_hide_event", 0, nil)
    state_machine.excute("union_the_meeting_place_trends_hide_event", 0, nil)
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Button_xinxi"):setHighlighted(false)
    ccui.Helper:seekWidgetByName(root, "Button_chengyuan"):setHighlighted(false)
    ccui.Helper:seekWidgetByName(root, "Button_dongtai"):setHighlighted(false)
    ccui.Helper:seekWidgetByName(root, "Image_073"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Image_074"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Image_075"):setVisible(false)
    if self.chooseType == Choose_Type.type_info then
        ccui.Helper:seekWidgetByName(root, "Button_xinxi"):setHighlighted(true)
        ccui.Helper:seekWidgetByName(root, "Image_073"):setVisible(true)
        if self.infoCell == nil then
            self.infoCell = state_machine.excute("union_the_meeting_place_information_open", 0, nil)
            self:addChild(self.infoCell)
        else
            state_machine.excute("union_the_meeting_place_information_show_event", 0, nil)
        end
    elseif self.chooseType == Choose_Type.type_member then
        ccui.Helper:seekWidgetByName(root, "Button_chengyuan"):setHighlighted(true)
        ccui.Helper:seekWidgetByName(root, "Image_074"):setVisible(true)
        if self.memberCell == nil then
            self.memberCell = state_machine.excute("union_the_meeting_place_member_open", 0, nil)
            self:addChild(self.memberCell)
        else
            state_machine.excute("union_the_meeting_place_member_show_event", 0, nil)
        end
    elseif self.chooseType == Choose_Type.type_other then
        ccui.Helper:seekWidgetByName(root, "Button_dongtai"):setHighlighted(true)
        ccui.Helper:seekWidgetByName(root, "Image_075"):setVisible(true)
        if self.otherCell == nil then
            self.otherCell = state_machine.excute("union_the_meeting_place_trends_open", 0, nil)
            self:addChild(self.otherCell)
        else
            state_machine.excute("union_the_meeting_place_trends_show_event", 0, nil)
        end
    end
end

function UnionTheMeetingPlace:onInit()
	self:updateDraw()
end

function UnionTheMeetingPlace:onEnterTransitionFinish()
    local csbUnionTheMeetingPlaceCell = csb.createNode("legion/legion_procedure_hall.csb")
    local root = csbUnionTheMeetingPlaceCell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnionTheMeetingPlaceCell)

    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_huodong"),  nil, 
        {
            terminal_name = "union_the_meeting_place_open_information_page",
            cell = self,
            terminal_state = 0
        }, 
        nil, 0)
    else
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xinxi"),  nil, 
        {
            terminal_name = "union_the_meeting_place_open_information_page",
            cell = self,
            terminal_state = 0
        }, 
        nil, 0)
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chengyuan"),  nil, 
    {
        terminal_name = "union_the_meeting_place_open_member_page",
        cell = self,
        terminal_state = 0
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_dongtai"),  nil, 
    {
        terminal_name = "union_the_meeting_place_open_trends_page",
        cell = self,
        terminal_state = 0
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_077"),  nil, 
    {
        terminal_name = "union_the_meeting_place_close",
        cell = self,
        terminal_state = 0
    }, 
    nil, 0)

    self:init()
    state_machine.unlock("union_the_meeting_place_open", 0, "")
end

function UnionTheMeetingPlace:init()
	self:onInit()
	return self
end

function UnionTheMeetingPlace:onExit()
    self.infoCell = nil
    self.memberCell = nil
    self.otherCell = nil
	state_machine.remove("union_the_meeting_place_hide_event")
	state_machine.remove("union_the_meeting_place_show_event")
	state_machine.remove("union_the_meeting_place_refresh")
	state_machine.remove("union_the_meeting_place_open_information_page")
	state_machine.remove("union_the_meeting_place_open_member_page")
	state_machine.remove("union_the_meeting_place_open_trends_page")
	state_machine.remove("union_the_meeting_place_open_check_page")
	-- _ED.union.union_member_list_sum = nil
	-- _ED.union.union_message_number = nil
end

function UnionTheMeetingPlace:createCell( ... )
    local cell = UnionTheMeetingPlace:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

function UnionTheMeetingPlace:closeCell( ... )
    local unionTheMeetingPlaceWindow = fwin:find("UnionTheMeetingPlaceClass")
    if unionTheMeetingPlaceWindow == nil then
        return
    end
    fwin:close(unionTheMeetingPlaceWindow)
end