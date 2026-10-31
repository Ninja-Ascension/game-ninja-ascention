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
        -- if unionTheMeetingPlaceWindow ~= nil and unionTheMeetingPlaceWindow:isVisible() == true then
        --     return true
        -- end
        -- state_machine.lock("union_the_meeting_place_open", 0, "")
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
        state_machine.excute("union_unlock_state_machine", 0, nil)
        UnionTheMeetingPlace:closeCell()
        fwin:close(fwin:find("UnionTheMeetingPlaceClass"))
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
    app.load("client.l_digital.union.meeting.UnionTheMeetingPlaceInformation")
    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital then
        app.load("client.l_digital.union.meeting.UnionTheMeetingPlaceInformationNew")
    end
    app.load("client.l_digital.union.meeting.UnionTheMeetingPlaceMember")
    app.load("client.l_digital.union.meeting.UnionTheMeetingPlaceTrends")

    self._current_page = 0
    self._info_data = nil     --信息
    self._ranking = nil      --排行榜
    self._review = nil        --审核
    self._Log = nil        --日志
    self.textTable = {}
	
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
                -- instance:updateDrawEx()
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
                if __lua_project_id == __lua_project_gragon_tiger_gate
                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    or __lua_project_id == __lua_project_red_alert 
                    then
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

        local sm_union_the_meeting_place_open_change_page_terminal = {
            _name = "sm_union_the_meeting_place_open_change_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeSelectPage(params._datas._page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 点击打开审核
        local sm_union_the_meeting_place_information_open_apply_info_terminal = {
            _name = "sm_union_the_meeting_place_information_open_apply_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        self:changeSelectPage(3)
                    end
                end
                NetworkManager:register(protocol_command.union_examine_list.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --点击军团排行
        local sm_union_go_to_rank_terminal = {
            _name = "sm_union_go_to_rank",
            _init = function (terminal)
                app.load("client.l_digital.union.rank.UnionRank")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseUnionListCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            self:changeSelectPage(2)
                        end 
                    end
                end
                -- _ED.union.union_list_info = nil  
                -- protocol_command.union_list.param_list = "0"
                protocol_command.union_order.param_list = "1\r\n10\r\n0"
                NetworkManager:register(protocol_command.union_order.code, nil, nil, nil, instance, responseUnionListCallback, false, nil)
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
        state_machine.add(sm_union_the_meeting_place_open_change_page_terminal)
        state_machine.add(sm_union_the_meeting_place_information_open_apply_info_terminal)
		state_machine.add(sm_union_go_to_rank_terminal)
        state_machine.init()
    end
    
    -- call func init union the meeting place machine.
    init_union_the_meeting_place_terminal()

end

function UnionTheMeetingPlace:changeSelectPage( page )
    local root = self.roots[1]

    local Panel_gg_xx = ccui.Helper:seekWidgetByName(root, "Panel_gg_xx")
    local Button_xinxi = ccui.Helper:seekWidgetByName(root, "Button_xinxi")
    local Button_phb = ccui.Helper:seekWidgetByName(root, "Button_phb")
    local Button_shenhe = ccui.Helper:seekWidgetByName(root, "Button_shenhe")
    local Button_dongtai = ccui.Helper:seekWidgetByName(root, "Button_dongtai")

    if page == self._current_page then
        if page == 1 then
            Button_xinxi:setHighlighted(true)
        elseif page == 2 then
            Button_phb:setHighlighted(true)
        elseif page == 3 then
            Button_shenhe:setHighlighted(true)
        elseif page == 4 then
            Button_dongtai:setHighlighted(true)
        end
        return
    end

    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital then
        for i, v in ipairs(self.textTable) do
            if v ~= nil then
                v:setVisible(page == i)
            end
        end
    end

    self._current_page = page
    Button_xinxi:setHighlighted(false)
    Button_phb:setHighlighted(false)
    Button_shenhe:setHighlighted(false)
    Button_dongtai:setHighlighted(false)
    state_machine.excute("union_the_meeting_place_information_hide_event", 0, nil)
    state_machine.excute("union_rank_hide_event", 0, nil)
    state_machine.excute("union_the_meeting_check_hide_event", 0, nil)
    state_machine.excute("union_the_meeting_place_trends_hide_event", 0, nil)
        
    if page == 1 then
        Button_xinxi:setHighlighted(true)
        if self._info_data == nil then
            self._info_data = state_machine.excute("union_the_meeting_place_information_open", 0, {Panel_gg_xx})
        else
            state_machine.excute("union_the_meeting_place_information_show_event", 0, nil)
        end
    elseif page == 2 then
        Button_phb:setHighlighted(true)
        if self._ranking == nil then
            self._ranking = state_machine.excute("union_rank_open", 0, {Panel_gg_xx})
        else
            state_machine.excute("union_rank_show_event", 0, nil)
        end
    elseif page == 3 then
        Button_shenhe:setHighlighted(true)
        if self._review == nil then
            self._review = state_machine.excute("union_the_meeting_check_open", 0, {Panel_gg_xx})
        else
            state_machine.excute("union_the_meeting_check_show_event", 0, nil)
        end
    elseif page == 4 then
        Button_dongtai:setHighlighted(true)
        if self._Log == nil then
            self._Log = state_machine.excute("union_the_meeting_place_trends_open", 0, {Panel_gg_xx})
        else
            state_machine.excute("union_the_meeting_place_trends_show_event", 0, nil)
        end
    end
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
    if self.infoCell == nil then    --基础信息
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
    -- self:updateDrawEx()
end

function UnionTheMeetingPlace:onInit()
	self:updateDraw()
end

function UnionTheMeetingPlace:onEnterTransitionFinish()
    local csbUnionTheMeetingPlaceCell = csb.createNode("legion/legion_procedure_hall.csb")
    local root = csbUnionTheMeetingPlaceCell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnionTheMeetingPlaceCell)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xinxi"),  nil, 
    {
        terminal_name = "sm_union_the_meeting_place_open_change_page",
        cell = self,
        _page = 1,
        terminal_state = 0
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_phb"),  nil, 
    {
        terminal_name = "sm_union_go_to_rank",
        cell = self,
        _page = 2,
        terminal_state = 0
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shenhe"),  nil, 
    {
        terminal_name = "sm_union_the_meeting_place_information_open_apply_info",
        cell = self,
        _page = 3,
        terminal_state = 0
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_dongtai"),  nil, 
    {
        terminal_name = "sm_union_the_meeting_place_open_change_page",
        cell = self,
        _page = 4,
        terminal_state = 0
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_03"),  nil, 
    {
        terminal_name = "union_the_meeting_place_close",
        cell = self,
        terminal_state = 0
    }, 
    nil, 0)

    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital then
        self:updateCheckBtnState()
    else
        if ccui.Helper:seekWidgetByName(root, "Button_shenhe")._x == nil then
            ccui.Helper:seekWidgetByName(root, "Button_shenhe")._x = ccui.Helper:seekWidgetByName(root, "Button_shenhe"):getPositionX()
        end
        if ccui.Helper:seekWidgetByName(root, "Button_dongtai")._x == nil then
            ccui.Helper:seekWidgetByName(root, "Button_dongtai")._x = ccui.Helper:seekWidgetByName(root, "Button_dongtai"):getPositionX()
        end

        ccui.Helper:seekWidgetByName(root, "Button_shenhe"):setPositionX(ccui.Helper:seekWidgetByName(root, "Button_shenhe")._x)
        ccui.Helper:seekWidgetByName(root, "Button_dongtai"):setPositionX(ccui.Helper:seekWidgetByName(root, "Button_dongtai")._x)

        if tonumber(_ED.union.user_union_info.union_post) ~= 1 
            and tonumber(_ED.union.user_union_info.union_post) ~= 2
            then
            ccui.Helper:seekWidgetByName(root, "Button_dongtai"):setPositionX(ccui.Helper:seekWidgetByName(root, "Button_shenhe")._x)
            ccui.Helper:seekWidgetByName(root, "Button_shenhe"):setVisible(false)
        else    
            ccui.Helper:seekWidgetByName(root, "Button_dongtai"):setPositionX(ccui.Helper:seekWidgetByName(root, "Button_dongtai")._x)
            ccui.Helper:seekWidgetByName(root, "Button_shenhe"):setVisible(true)
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "sm_push_notification_center_union_main_window_union_examine_apply",
            _widget = ccui.Helper:seekWidgetByName(root, "Button_shenhe"),
            _invoke = nil,
            _interval = 0.5,})
        end
    end

    -- DSC重塑
    self.textTable = {}
    if __lua_project_id == __lua_project_l_digital then
        local Text_xinxi_1 = ccui.Helper:seekWidgetByName(root, "Text_xinxi_1")
        local Text_phb_1 = ccui.Helper:seekWidgetByName(root, "Text_phb_1")
        local Text_shenhe_1 = ccui.Helper:seekWidgetByName(root, "Text_shenhe_1")
        local Text_dongtai_1 = ccui.Helper:seekWidgetByName(root, "Text_dongtai_1")

        table.insert(self.textTable, Text_xinxi_1)
        table.insert(self.textTable, Text_phb_1)
        table.insert(self.textTable, Text_shenhe_1)
        table.insert(self.textTable, Text_dongtai_1)
        
        for _, v in ipairs(self.textTable) do
            if v ~= nil then
                v:setVisible(false)
            end
        end
    end

    -- DSC重塑
    -- 公会详情常驻界面
    if __lua_project_id == __lua_project_l_digital then
        self:initUnionDetailUI()
    end

    self:init()
    self:changeSelectPage(1)
end

function UnionTheMeetingPlace:initUnionDetailUI()
    local root = self.roots[1]
    local Panel_xinxi = ccui.Helper:seekWidgetByName(root, "Panel_xinxi")
    state_machine.excute("union_the_meeting_place_information_new_open", 0, {Panel_xinxi})
end

function UnionTheMeetingPlace:updateCheckBtnState()
    local root = self.roots[1]
    if ccui.Helper:seekWidgetByName(root, "Button_shenhe")._y == nil then
        ccui.Helper:seekWidgetByName(root, "Button_shenhe")._y = ccui.Helper:seekWidgetByName(root, "Button_shenhe"):getPositionY()
    end

    if ccui.Helper:seekWidgetByName(root, "Button_dongtai")._y == nil then
        ccui.Helper:seekWidgetByName(root, "Button_dongtai")._y = ccui.Helper:seekWidgetByName(root, "Button_dongtai"):getPositionY()
    end

    if ccui.Helper:seekWidgetByName(root, "Text_shenhe_2")._y == nil then
        ccui.Helper:seekWidgetByName(root, "Text_shenhe_2")._y = ccui.Helper:seekWidgetByName(root, "Text_shenhe_2"):getPositionY()
    end

    if ccui.Helper:seekWidgetByName(root, "Text_dongtai_2")._y == nil then
        ccui.Helper:seekWidgetByName(root, "Text_dongtai_2")._y = ccui.Helper:seekWidgetByName(root, "Text_dongtai_2"):getPositionY()
    end

    ccui.Helper:seekWidgetByName(root, "Button_shenhe"):setPositionY(ccui.Helper:seekWidgetByName(root, "Button_shenhe")._y)
    ccui.Helper:seekWidgetByName(root, "Button_dongtai"):setPositionY(ccui.Helper:seekWidgetByName(root, "Button_dongtai")._y)

    ccui.Helper:seekWidgetByName(root, "Text_shenhe_2"):setPositionY(ccui.Helper:seekWidgetByName(root, "Text_shenhe_2")._y)
    ccui.Helper:seekWidgetByName(root, "Text_dongtai_2"):setPositionY(ccui.Helper:seekWidgetByName(root, "Text_dongtai_2")._y)

    local isNormal = tonumber(_ED.union.user_union_info.union_post) ~= 1 and tonumber(_ED.union.user_union_info.union_post) ~= 2
    if isNormal == true then
        ccui.Helper:seekWidgetByName(root, "Button_dongtai"):setPositionY(ccui.Helper:seekWidgetByName(root, "Button_shenhe")._y)
        ccui.Helper:seekWidgetByName(root, "Button_shenhe"):setVisible(false)

        ccui.Helper:seekWidgetByName(root, "Text_shenhe_2"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Text_dongtai_2"):setPositionY(ccui.Helper:seekWidgetByName(root, "Text_shenhe_2")._y)
    else    
        ccui.Helper:seekWidgetByName(root, "Button_dongtai"):setPositionY(ccui.Helper:seekWidgetByName(root, "Button_dongtai")._y)
        ccui.Helper:seekWidgetByName(root, "Button_shenhe"):setVisible(true)

        ccui.Helper:seekWidgetByName(root, "Text_shenhe_2"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Text_dongtai_2"):setPositionY(ccui.Helper:seekWidgetByName(root, "Text_dongtai_2")._y)

        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "sm_push_notification_center_union_main_window_union_examine_apply",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_shenhe"),
        _invoke = nil,
        _interval = 0.5,})
    end
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