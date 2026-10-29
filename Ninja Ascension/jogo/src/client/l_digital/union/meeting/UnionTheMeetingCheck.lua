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
        local panel = UnionTheMeetingCheck:new():init(params)
        fwin:open(panel)
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
    app.load("client.l_digital.cells.union.union_then_meeting_check_cell")
    app.load("client.l_digital.union.meeting.SmUnionLimitWindow")

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
                instance:updateDraw()
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

        --刷新限制信息
        local union_the_meeting_check_update_limit_terminal = {
            _name = "union_the_meeting_check_update_limit",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Text_condition = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_condition")
                local approval_status = zstring.split(_ED.union.union_info.approval_status ,",")
                local strs = ""
                if tonumber(approval_status[2]) == 0 then
                    strs = union_limit_title[4]
                else
                    strs = approval_status[2]
                end
                Text_condition:setString(strs.."("..union_limit_title[tonumber(approval_status[1])+1]..")")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --一键拒绝
        local union_the_meeting_check_all_refuse_terminal = {
            _name = "union_the_meeting_check_all_refuse",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        _ED.union.union_examine_list_sum = nil
                        state_machine.excute("union_the_meeting_check_refresh_info", 0, nil)
                    end
                end
                local persionParam = "-1\r\n3"
                protocol_command.union_persion_manage.param_list = persionParam
                NetworkManager:register(protocol_command.union_persion_manage.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_the_meeting_share_message_terminal = {
            _name = "union_the_meeting_share_message",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseSendMessageCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(_new_interface_text[121])
                    end
                end
                if os.time() - _ED._last_send_chat_time < 10 then
                    TipDlg.drawTextDailog(string.format(_new_interface_text[169]))
                    return
                end
                _ED._last_send_chat_time = os.time()
                local approval_status = zstring.split(_ED.union.union_info.approval_status ,",")
                local paramsInfo = _ED.union.union_info.union_name.."|"..approval_status[2].."|".._ED.union.union_info.union_id
                protocol_command.send_message.param_list = "\r\n16\r\n0\r\n45\r\n"..paramsInfo
                -- Se ESPERA la respuesta en vez de fingirla.
                NetworkManager:socketRequest(protocol_command.send_message.code, instance, responseSendMessageCallback)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(union_the_meeting_check_hide_event_terminal)
		state_machine.add(union_the_meeting_check_show_event_terminal)
        state_machine.add(union_the_meeting_check_refresh_info_terminal)
        state_machine.add(union_the_meeting_check_update_limit_terminal)
		state_machine.add(union_the_meeting_check_all_refuse_terminal)
        state_machine.add(union_the_meeting_share_message_terminal)
        state_machine.init()
    end
    
    -- call func init union the meeting check  machine.
    init_union_the_meeting_check_terminal()

end

function UnionTheMeetingCheck:onHide()
	self:setVisible(false)
end

function UnionTheMeetingCheck:onShow()
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

    local Text_condition = ccui.Helper:seekWidgetByName(root, "Text_condition")
    local approval_status = zstring.split(_ED.union.union_info.approval_status ,",")
    local strs = ""
    if tonumber(approval_status[2]) == 0 then
        strs = union_limit_title[4]
    else
        strs = approval_status[2]
    end
    Text_condition:setString(strs.."("..union_limit_title[tonumber(approval_status[1])+1]..")")
end

function UnionTheMeetingCheck:onInit()
    _ED._last_send_chat_time = _ED._last_send_chat_time or 0
    local csbUnionTheMeetingCheckCell = csb.createNode("legion/legion_pro_shenhe.csb")
    local root = csbUnionTheMeetingCheckCell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnionTheMeetingCheckCell)

    -- local action = csb.createTimeline("legion/legion_pro_shenhe.csb")
    -- table.insert(self.actions, action)
    -- csbUnionTheMeetingCheckCell:runAction(action)
    -- action:play("window_open", false)

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
    --设置界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shezhi"), nil, 
    {
        terminal_name = "sm_union_limit_window_open", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhaomu"), nil, 
    {
        terminal_name = "union_the_meeting_share_message", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --一键拒绝
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yjjj"), nil, 
    {
        terminal_name = "union_the_meeting_check_all_refuse", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    
	self:updateDraw()
    self:registerOnNoteUpdate(self)
end

function UnionTheMeetingCheck:onEnterTransitionFinish()
    

    -- self:init()

    -- state_machine.unlock("union_the_meeting_check_open", 0, "")
end

function UnionTheMeetingCheck:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow   
	self:onInit()
	return self
end

function UnionTheMeetingCheck:onExit()
    self:unregisterOnNoteUpdate(self)
	state_machine.remove("union_the_meeting_check_hide_event")
	state_machine.remove("union_the_meeting_check_show_event")
	state_machine.remove("union_the_meeting_check_refresh_info")
    state_machine.remove("union_the_meeting_share_message")
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