-----------------------------
-- 工会红包主界面
-----------------------------
SmUnionRedEnvelopes = class("SmUnionRedEnvelopesClass", Window)

--打开界面
local sm_union_red_envelopes_open_terminal = {
	_name = "sm_union_red_envelopes_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        state_machine.excute("union_lock_state_machine", 0, nil)
        local server_time = _ED.system_time + (os.time() - _ED.native_time) - _ED.GTM_Time
        if _ED.union.user_union_info.union_last_enter_time - server_time > 0 then
            state_machine.excute("union_unlock_state_machine", 0, nil)
            TipDlg.drawTextDailog(_new_interface_text[195])
            return
        end
		if fwin:find("SmUnionRedEnvelopesClass") == nil then
			fwin:open(SmUnionRedEnvelopes:new():init(), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_union_red_envelopes_close_terminal = {
	_name = "sm_union_red_envelopes_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        state_machine.excute("union_unlock_state_machine", 0, nil)
        fwin:close(fwin:find("UserTopInfoAClass"))
		fwin:close(fwin:find("SmUnionRedEnvelopesClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_union_red_envelopes_open_terminal)
state_machine.add(sm_union_red_envelopes_close_terminal)
state_machine.init()

function SmUnionRedEnvelopes:ctor()
	self.super:ctor()
	self.roots = {}

    self._current_page = 0
    self._system_red = nil
    self._hair_red = nil
    self._grab_red = nil

    self.textTable = {}

    app.load("client.l_digital.union.redEnvelopes.SmUnionSystemRedEnvelopes")
    app.load("client.l_digital.union.redEnvelopes.SmUnionHairRedEnvelopes")
    app.load("client.l_digital.union.redEnvelopes.SmUnionGrabRedEnvelopes")

    local function init_sm_union_red_envelopes_terminal()
        local sm_union_red_envelopes_change_page_terminal = {
            _name = "sm_union_red_envelopes_change_page",
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

        local sm_union_red_envelopes_open_snatch_terminal = {
            _name = "sm_union_red_envelopes_open_snatch",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            instance:changeSelectPage(params._datas._page)
                        end 
                    end
                end
                protocol_command.union_red_packet_rap_manager.param_list = "-1"
                NetworkManager:register(protocol_command.union_red_packet_rap_manager.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --画动画
        local sm_union_red_envelopes_draw_animation_terminal = {
            _name = "sm_union_red_envelopes_draw_animation",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_dhbg = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_dhbg")
                Panel_dhbg:setVisible(true)
                local function changeActionCallback( armatureBack ) 
                    app.load("client.reward.DrawRareReward")
                    local getRewardWnd = DrawRareReward:new()
                    getRewardWnd:init(25)
                    fwin:open(getRewardWnd, fwin._ui)
                    armatureBack:removeFromParent(true)
                    state_machine.excute(params[2], 0, nil)
                    Panel_dhbg:setVisible(false)
                    state_machine.unlock("sm_union_system_red_envelopes_grad")
                    state_machine.unlock("union_member_red_envelopes_list_cell_hair", 0, "")
                end
                local jsonFile = "sprite/sprite_kaihongbao.json"
                local atlasFile = "sprite/sprite_kaihongbao.atlas"
                local names = ""
                if tonumber(params[1]) == 1 then
                    names = "open_red_packet_1"
                elseif tonumber(params[1]) == 2 then  
                    names = "open_red_packet_2"
                else
                    names = "open_red_packet_3"
                end
                local animation = sp.spine(jsonFile, atlasFile, 1, 0, names, true, nil)
                animation.animationNameList = {names}
                sp.initArmature(animation, false)
                animation._invoke = changeActionCallback
                animation:setPosition(cc.p(Panel_dhbg:getContentSize().width/2-(Panel_dhbg:getContentSize().width-instance.roots[1]:getContentSize().width)/4,Panel_dhbg:getContentSize().height/2))
                instance.roots[1]:addChild(animation)
                animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                csb.animationChangeToAction(animation, 0, 0, false)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(sm_union_red_envelopes_change_page_terminal)
        state_machine.add(sm_union_red_envelopes_open_snatch_terminal)
        state_machine.add(sm_union_red_envelopes_draw_animation_terminal)
        state_machine.init()
    end
    init_sm_union_red_envelopes_terminal()
end

function SmUnionRedEnvelopes:changeSelectPage( page )
    local root = self.roots[1]

    local Panel_hongbao = ccui.Helper:seekWidgetByName(root, "Panel_hongbao")
    local Button_red_1 = ccui.Helper:seekWidgetByName(root, "Button_red_1")
    local Button_red_2 = ccui.Helper:seekWidgetByName(root, "Button_red_2")
    local Button_red_3 = ccui.Helper:seekWidgetByName(root, "Button_red_3")
    if page == self._current_page then
        if page == 1 then
            Button_red_1:setHighlighted(true)
        elseif page == 2 then
            Button_red_2:setHighlighted(true)
        elseif page == 3 then
            Button_red_3:setHighlighted(true)
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
    Button_red_1:setHighlighted(false)
    Button_red_2:setHighlighted(false)
    Button_red_3:setHighlighted(false)
    state_machine.excute("sm_union_system_red_envelopes_hide", 0, nil)
    state_machine.excute("sm_union_hair_red_envelopes_hide", 0, nil)
    state_machine.excute("sm_union_grab_red_envelopes_hide", 0, nil)

    if page == 1 then
        Button_red_1:setHighlighted(true)
        if self._system_red == nil then
            self._system_red = state_machine.excute("sm_union_system_red_envelopes_window_open", 0, {Panel_hongbao})
        else
            state_machine.excute("sm_union_system_red_envelopes_show", 0, nil)
        end
	elseif page == 2 then
		Button_red_2:setHighlighted(true)
		if self._hair_red == nil then
            self._hair_red = state_machine.excute("sm_union_hair_red_envelopes_window_open", 0, {Panel_hongbao})
        else
            state_machine.excute("sm_union_hair_red_envelopes_show", 0, nil)
        end
	elseif page == 3 then
		Button_red_3:setHighlighted(true)
		if self._grab_red == nil then
            self._grab_red = state_machine.excute("sm_union_grab_red_envelopes_window_open", 0, {Panel_hongbao})
        else
            state_machine.excute("sm_union_grab_red_envelopes_show", 0, nil)
        end
	end
end

function SmUnionRedEnvelopes:init()
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

function SmUnionRedEnvelopes:onInit()
    local csbItem = csb.createNode("legion/sm_legion_red_packet.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, 
    {
        terminal_name = "sm_union_red_envelopes_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    --公会红包
   	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_red_1"), nil, 
    {
        terminal_name = "sm_union_red_envelopes_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)
    
    -- DSC重塑
    local widget = ccui.Helper:seekWidgetByName(root,"Button_red_1")
    if __lua_project_id == __lua_project_l_digital then
        widget = ccui.Helper:seekWidgetByName(root,"Panel_red_1")
    end
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "sm_push_notification_center_union_sys_red_envelopes_snatched",
        _widget = widget,
        _invoke = nil,
        _interval = 0.5,}) 
	
    --发红包
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_red_2"), nil, 
    {
        terminal_name = "sm_union_red_envelopes_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    --抢红包
   	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_red_3"), nil, 
    {
        terminal_name = "sm_union_red_envelopes_open_snatch", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)

    -- DSC重塑
    local widget = ccui.Helper:seekWidgetByName(root,"Button_red_3")
    if __lua_project_id == __lua_project_l_digital then
        widget = ccui.Helper:seekWidgetByName(root,"Panel_red_3")
    end
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "sm_push_notification_center_union_red_envelopes_snatched",
        _widget = widget,
        _invoke = nil,
        _interval = 0.5,}) 

    -- DSC重塑
    self.textTable = {}
    if __lua_project_id == __lua_project_l_digital then
        local Text_red_white_1 = ccui.Helper:seekWidgetByName(root, "Text_red_white_1")
        local Text_red_white_2 = ccui.Helper:seekWidgetByName(root, "Text_red_white_2")
        local Text_red_white_3 = ccui.Helper:seekWidgetByName(root, "Text_red_white_3")

        table.insert(self.textTable, Text_red_white_1)
        table.insert(self.textTable, Text_red_white_2)
        table.insert(self.textTable, Text_red_white_3)
        
        for _, v in ipairs(self.textTable) do
            if v ~= nil then
                v:setVisible(false)
            end
        end
    end

    -- DSC重塑
    --规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rule"), nil, 
    {
        terminal_name = "sm_union_red_envelopes_tip_open", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self:changeSelectPage(1)


end

function SmUnionRedEnvelopes:onEnterTransitionFinish()
    
end


function SmUnionRedEnvelopes:onExit()
	state_machine.remove("sm_union_red_envelopes_change_page")
end

