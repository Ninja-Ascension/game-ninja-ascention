--------------------------------------------------------------------------------------------------------------
--  说明：军团议事大厅成员
--------------------------------------------------------------------------------------------------------------
UnionTheMeetingPlaceMemberCell = class("UnionTheMeetingPlaceMemberCellClass", Window)
UnionTheMeetingPlaceMemberCell.__size = nil
--创建cell
local union_the_meeting_place_member_create_cell_terminal = {
    _name = "union_the_meeting_place_member_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local unionData = params[1]
        local index = params[2]
        local cell = UnionTheMeetingPlaceMemberCell:new()
        cell:init(unionData,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_the_meeting_place_member_create_cell_terminal)
state_machine.init()

function UnionTheMeetingPlaceMemberCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
    self.unionData = nil

    app.load("client.utils.ConfirmTip")
    app.load("client.red_alert.union.UnionManager")

    local function init_union_the_meeting_place_member_cell_terminal()
		-- 查看玩家信息
		 local union_the_meeting_place_member_list_cell_look_info_terminal = {
            _name = "union_the_meeting_place_member_cell_look_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                state_machine.excute("user_info_window_open",0,{_datas = {user_id = cell.unionData.id}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local union_the_meeting_place_member_cell_chat_terminal = {
            _name = "union_the_meeting_place_member_cell_chat",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local _datas = {user_data = {user_name = cell.unionData.name, user_id = cell.unionData.id}}
                state_machine.excute("chat_sent_window_open",0,"")
                state_machine.excute("chat_sent_change_to_person_chat", 0, {_datas = _datas})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local union_the_meeting_place_member_cell_go_out_terminal = {
            _name = "union_the_meeting_place_member_cell_go_out",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if tonumber(_ED.union.user_union_info.union_post) == 1 then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[46])
                else 
                    local tip = ConfirmTip:new()
                    tip:init(cell, cell.quxSureTipCallBack, tipStringInfo_union_str[47])
                    fwin:open(tip, fwin._ui)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local union_the_meeting_place_member_cell_open_manager_terminal = {
            _name = "union_the_meeting_place_member_cell_open_manager",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                state_machine.excute("union_manager_open", 0, {cell.unionData, cell})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_the_meeting_place_member_list_cell_look_info_terminal)
        state_machine.add(union_the_meeting_place_member_cell_chat_terminal)
		state_machine.add(union_the_meeting_place_member_cell_go_out_terminal)
		state_machine.add(union_the_meeting_place_member_cell_open_manager_terminal)
        state_machine.init()
    end
    init_union_the_meeting_place_member_cell_terminal()
end

function UnionTheMeetingPlaceMemberCell:quxSureTipCallBack(n)
    if n ~= 0 then
        return
    end
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("union_the_meeting_place_clean_all_data", 0, nil)
        end
    end
    protocol_command.union_appoint.param_list = _ED.union.union_info.union_id.."\r\n"..self.unionData.id.."\r\n5"
    NetworkManager:register(protocol_command.union_appoint.code, nil, nil, nil, self, responseCallback, false, nil)
end

function UnionTheMeetingPlaceMemberCell:updateDraw()
    local root = self.roots[1]
    local nameText = ccui.Helper:seekWidgetByName(root, "Text_081")         -- 名字
    local Text_zhanli = ccui.Helper:seekWidgetByName(root, "Text_zhanli")   -- 战力
    local Text_state = ccui.Helper:seekWidgetByName(root, "Text_state")
    local Panel_on_card_on_1 = ccui.Helper:seekWidgetByName(root, "Panel_on_card_on_1"):setVisible(false)     -- 金卡
    local Panel_on_card_on_2 = ccui.Helper:seekWidgetByName(root, "Panel_on_card_on_2"):setVisible(false)     -- 钻卡
    local Image_16 = ccui.Helper:seekWidgetByName(root, "Image_16"):setVisible(false)
    local Image_17 = ccui.Helper:seekWidgetByName(root, "Image_17"):setVisible(false)
    local Image_18 = ccui.Helper:seekWidgetByName(root, "Image_18"):setVisible(false)
    local Image_19 = ccui.Helper:seekWidgetByName(root, "Image_19"):setVisible(false)
    local Panel_4 = ccui.Helper:seekWidgetByName(root, "Panel_4")
    Panel_4:removeAllChildren(true)
    local Panel_5 = ccui.Helper:seekWidgetByName(root, "Panel_5"):setVisible(false)
    local Panel_5_0 = ccui.Helper:seekWidgetByName(root, "Panel_5_0"):setVisible(false)
    local Panel_7 = ccui.Helper:seekWidgetByName(root, "Panel_7"):setVisible(false)

    if self.unionData == nil then
        return
    end
    if tonumber(self.unionData.gold_card) == 1 then
        Panel_on_card_on_1:setVisible(true)
    end
    if tonumber(self.unionData.diamond_card) == 1 then
        Panel_on_card_on_2:setVisible(true)
    end
    nameText:setString(self.unionData.name)
    Text_zhanli:setString(self.unionData.capactity)
    if self.unionData.is_online == true then
        Text_state:setString(tipStringInfo_union_str[72])
    else
        Text_state:setString(self:getLeaveTimeString(self.unionData.offline_time))
    end
    local data = {
        user_sex = self.unionData.user_sex, 
        user_level = self.unionData.level,
        user_camp = _ED.union.union_info.union_camp,
    }
    Panel_4:addChild(state_machine.excute("user_head_icon_create", 0, {data, 2}))
    if tonumber(self.unionData.post) == 1 then
        Image_18:setVisible(true)
    elseif tonumber(self.unionData.post) == 2 then
        Image_17:setVisible(true)
    elseif tonumber(self.unionData.post) == 3 then
        Image_19:setVisible(true)
    else
        Image_16:setVisible(true)
    end

    if tonumber(self.unionData.id) == tonumber(_ED.user_info.user_id) then -- 自己（退出）
        Panel_7:setVisible(true)
    else
        -- 会长
        if tonumber(_ED.union.user_union_info.union_post) == 1 then
            Panel_5_0:setVisible(true)
        -- 副会长
        elseif tonumber(_ED.union.user_union_info.union_post) == 2 then
            if tonumber(self.unionData.post) <= 2 then
                Panel_5:setVisible(true)
            else
                Panel_5_0:setVisible(true)
            end
        -- 精英
        elseif tonumber(_ED.union.user_union_info.union_post) == 3 then
            if tonumber(self.unionData.post) <= 3 then
                Panel_5:setVisible(true)
            else
                Panel_5_0:setVisible(true)
            end
        -- 成员
        else
            Panel_5:setVisible(true)
        end
    end
end

function UnionTheMeetingPlaceMemberCell:getLeaveTimeString(leave_time)
    local server_time = _ED.system_time + (os.time() - _ED.native_time)
    leave_time = (server_time - tonumber(leave_time))
    local str = ""
    local hour = math.floor(tonumber(leave_time)/3600)
    local mins = math.floor((tonumber(leave_time)%3600)/60)
    local day = ""
    if tonumber(leave_time) == 0 or (mins < 1 and hour == 0) then
        str = tipStringInfo_union_str[72]
    elseif hour < 1 then
        str = string.format(tipStringInfo_union_str[73], mins)
    elseif hour >= 1 and hour < 24 then
        str = string.format(tipStringInfo_union_str[74], hour)
    elseif hour >= 24 and hour < 168 then
        day = math.ceil(hour / 24)
        str = string.format(tipStringInfo_union_str[75], day)
    elseif hour >= 168 then
        str = string.format(tipStringInfo_union_str[76], 1)
    end
    return str
end

function UnionTheMeetingPlaceMemberCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_procedure_hall_list, "root")
    self:addChild(root)
    table.insert(self.roots, root)

    if UnionTheMeetingPlaceMemberCell.__size == nil then
        UnionTheMeetingPlaceMemberCell.__size = root:getContentSize()
    end
    -- local action = csb.createTimeline(config_csb.cells.legion.legion_procedure_hall_list)
    -- table.insert(self.actions, action)
    -- action:play("list_view_cell_open", false)
    -- csbItem:runAction(action)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tuichu"), nil, 
    {
        terminal_name = "union_the_meeting_place_member_cell_go_out", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chakan"), nil, 
    {
        terminal_name = "union_the_meeting_place_member_cell_look_info", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chakan_1"), nil, 
    {
        terminal_name = "union_the_meeting_place_member_cell_look_info", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat"), nil, 
    {
        terminal_name = "union_the_meeting_place_member_cell_chat", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_1"), nil, 
    {
        terminal_name = "union_the_meeting_place_member_cell_chat", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_manage"), nil, 
    {
        terminal_name = "union_the_meeting_place_member_cell_open_manager", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	self:updateDraw()
end

function UnionTheMeetingPlaceMemberCell:onEnterTransitionFinish()

end

function UnionTheMeetingPlaceMemberCell:init(unionData,index)
    self.unionData = unionData
    if index ~= nil and index < 6 then
        self:onInit()
    end
    self:setContentSize(UnionTheMeetingPlaceMemberCell.__size)
	return self
end

function UnionTheMeetingPlaceMemberCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionTheMeetingPlaceMemberCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    ccui.Helper:seekWidgetByName(root, "Panel_4"):removeAllChildren(true)
    cacher.freeRef(config_csb.cells.legion.legion_procedure_hall_list, root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
    self.actions = {}
end

function UnionTheMeetingPlaceMemberCell:onExit()
    if self.roots[1] ~= nil then
        local Panel_4 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_4")
        if Panel_4 ~= nil then
            Panel_4:removeAllChildren(true)
        end
        cacher.freeRef(config_csb.cells.legion.legion_procedure_hall_list, self.roots[1])
    end
end

function UnionTheMeetingPlaceMemberCell:createCell()
	local cell = UnionTheMeetingPlaceMemberCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
