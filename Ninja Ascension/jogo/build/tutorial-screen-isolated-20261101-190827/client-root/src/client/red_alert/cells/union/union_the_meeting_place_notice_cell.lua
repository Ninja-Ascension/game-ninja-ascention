--------------------------------------------------------------------------------------------------------------
--  说明：军团议事大厅修改公告
--------------------------------------------------------------------------------------------------------------
UnionTheMeetingPlaceNoticeCell = class("UnionTheMeetingPlaceNoticeCellClass", Window)

--打开界面
local union_the_meeting_place_notice_open_terminal = {
    _name = "union_the_meeting_place_notice_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local unionTheMeetingPlaceNoticeWindow = fwin:find("UnionTheMeetingPlaceNoticeCellClass")
        if unionTheMeetingPlaceNoticeWindow ~= nil and unionTheMeetingPlaceNoticeWindow:isVisible() == true then
            return true
        end
        state_machine.lock("union_the_meeting_place_notice_open", 0, "")
        fwin:open(UnionTheMeetingPlaceNoticeCell:createCell():init(), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local union_the_meeting_place_notice_close_terminal = {
    _name = "union_the_meeting_place_notice_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        UnionTheMeetingPlaceNoticeCell:closeCell()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}       
state_machine.add(union_the_meeting_place_notice_open_terminal)
state_machine.add(union_the_meeting_place_notice_close_terminal)
state_machine.init()

function UnionTheMeetingPlaceNoticeCell:ctor()
	self.super:ctor()
	self.roots = {}

    local function init_union_the_meeting_place_notice_cell_terminal()
		local union_the_meeting_place_notice_change_announcement_terminal = {
            _name = "union_the_meeting_place_notice_change_announcement",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:sendInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(union_the_meeting_place_notice_change_announcement_terminal)
        state_machine.init()
    end

    init_union_the_meeting_place_notice_cell_terminal()
end

function UnionTheMeetingPlaceNoticeCell:sendInfo( ... )
    local root = self.roots[1]
    if root ==nil then
        return
    end
    local text = ccui.Helper:seekWidgetByName(root, "TextField_gg_xinxi")
    local str = zstring.exchangeTo(text:getString())
    local str2 = string.gsub(text:getString(), " ", "")

    local text_1 = ccui.Helper:seekWidgetByName(root, "TextField_gg_xuanyan")
    local str_1 = zstring.exchangeTo(text_1:getString())
    local str_2 = string.gsub(text_1:getString(), " ", "")
    if text:getString() ~= "" and str2 ~= "" then
        local function responseCallback( response )
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                state_machine.excute("union_the_meeting_place_notice_close", 0, nil)
                state_machine.excute("union_the_meeting_place_information_refresh", 0, nil)
            end
        end
        protocol_command.union_content_update.param_list = 
            _ED.union.union_info.union_id.."\r\n".._ED.union.union_info.union_camp.."\r\n"..str.."\r\n"..str_1
        NetworkManager:register(protocol_command.union_content_update.code, nil, nil, nil, self, responseCallback, false, nil)
    else
        TipDlg.drawTextDailog(tipStringInfo_union_str[51])
    end
end

function UnionTheMeetingPlaceNoticeCell:updateDraw()
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "TextField_gg_xinxi"):setString(_ED.union.union_info.bulletin)
	ccui.Helper:seekWidgetByName(root, "TextField_gg_xuanyan"):setString(_ED.union.union_info.watchword)
end

function UnionTheMeetingPlaceNoticeCell:onInit()
	self:updateDraw()
end

function UnionTheMeetingPlaceNoticeCell:onEnterTransitionFinish()
	
end

function UnionTheMeetingPlaceNoticeCell:init()
    local csbItem = csb.createNode(config_csb.legion.legion_gg_xiugai)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local max_length = dms.int(dms["union_config"], 23, union_config.param)
    local text = ccui.Helper:seekWidgetByName(root, "TextField_gg_xinxi")
    draw:addEditBox(text, "", "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_5_bc"), max_length, cc.KEYBOARD_RETURNTYPE_DONE)
    
    max_length = dms.int(dms["union_config"], 24, union_config.param)
    text = ccui.Helper:seekWidgetByName(root, "TextField_gg_xuanyan")
    draw:addEditBox(text, "", "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_5_bc"), max_length, cc.KEYBOARD_RETURNTYPE_DONE)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5_qx"), nil, 
    {
        terminal_name = "union_the_meeting_place_notice_close",
        cell = self,
        terminal_state = 0
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "union_the_meeting_place_notice_close",
        cell = self,
        terminal_state = 0
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5_bc"), nil, 
    {
        terminal_name = "union_the_meeting_place_notice_change_announcement",
        terminal_state = 0
    }, 
    nil, 0)

	self:onInit()
    state_machine.unlock("union_the_meeting_place_notice_open", 0, "")
	return self
end

function UnionTheMeetingPlaceNoticeCell:onExit()
	state_machine.remove("union_the_meeting_place_notice_change_announcement")
end

function UnionTheMeetingPlaceNoticeCell:createCell()
	local cell = UnionTheMeetingPlaceNoticeCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function UnionTheMeetingPlaceNoticeCell:closeCell( ... )
    local unionTheMeetingPlaceNoticeWindow = fwin:find("UnionTheMeetingPlaceNoticeCellClass")
    if unionTheMeetingPlaceNoticeWindow == nil then
        return
    end
    fwin:close(unionTheMeetingPlaceNoticeWindow)
end
