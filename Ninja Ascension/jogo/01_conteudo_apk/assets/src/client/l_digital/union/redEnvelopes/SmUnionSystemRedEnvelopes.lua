-----------------------------
--工会系统红包
-----------------------------
SmUnionSystemRedEnvelopes = class("SmUnionSystemRedEnvelopesClass", Window)
SmUnionSystemRedEnvelopes.__size = nil

local sm_union_system_red_envelopes_window_open_terminal = {
    _name = "sm_union_system_red_envelopes_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local panel = SmUnionSystemRedEnvelopes:new():init(params)
		fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_system_red_envelopes_window_open_terminal)
state_machine.init()

function SmUnionSystemRedEnvelopes:ctor()
    self.super:ctor()
    self.roots = {}

    self.prop_list = {}
    app.load("client.l_digital.union.redEnvelopes.SmUnionRedEnvelopesTip")
    app.load("client.l_digital.union.redEnvelopes.SmUnionRedEnvelopesRank")
    app.load("client.activity.adventure.AdventureTaskWindow")
    local function init_sm_union_system_red_envelopes_terminal()
		--显示界面
		local sm_union_system_red_envelopes_show_terminal = {
            _name = "sm_union_system_red_envelopes_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                state_machine.unlock("sm_union_system_red_envelopes_grad")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--隐藏界面
		local sm_union_system_red_envelopes_hide_terminal = {
            _name = "sm_union_system_red_envelopes_hide",
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

        local sm_union_system_red_envelopes_update_draw_terminal = {
            _name = "sm_union_system_red_envelopes_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_union_system_red_envelopes_grad_terminal = {
            _name = "sm_union_system_red_envelopes_grad",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("sm_union_system_red_envelopes_grad")
                local index = tonumber(params._datas._page)
                local science_info = zstring.split(_ED.union_science_info,"|")
                local science_data = zstring.split(science_info[5+index],",")
                if tonumber(science_data[4]) > 0 then
                    --进排行
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                state_machine.excute("sm_union_red_envelopes_rank_open", 0, {tonumber(params._datas._page)})
                            end 
                        end
                        state_machine.unlock("sm_union_system_red_envelopes_grad")
                    end
                    protocol_command.union_red_packet_rap_rank.param_list = tonumber(params._datas._page)-1
                    NetworkManager:register(protocol_command.union_red_packet_rap_rank.code, nil, nil, nil, instance, responseCallback, false, nil)
                else
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                state_machine.excute("sm_union_red_envelopes_draw_animation", 0, {params._datas._page,"sm_union_system_red_envelopes_update_draw"})
                                state_machine.excute("notification_center_update", 0, "sm_push_notification_center_union_sys_red_envelopes_snatched")--工会系统红包界面推送
                                state_machine.excute("adventure_task_window_onUpdate_data", 0, nil)
                            end 
                        end
                    end
                    protocol_command.union_red_packet_draw_reward.param_list = tonumber(params._datas._page)-1
                    NetworkManager:register(protocol_command.union_red_packet_draw_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(sm_union_system_red_envelopes_show_terminal)	
		state_machine.add(sm_union_system_red_envelopes_hide_terminal)
        state_machine.add(sm_union_system_red_envelopes_update_draw_terminal)
        state_machine.add(sm_union_system_red_envelopes_grad_terminal)

        state_machine.init()
    end
    init_sm_union_system_red_envelopes_terminal()
end

function SmUnionSystemRedEnvelopes:onHide()
    self:setVisible(false)
end

function SmUnionSystemRedEnvelopes:onShow()
    self:setVisible(true)
end

function SmUnionSystemRedEnvelopes:onUpdateDraw()
    local root = self.roots[1]

    local red_envelopes_info = zstring.split(_ED.union_red_envelopes_info ,"|") 
    local science_info = zstring.split(_ED.union_science_info,"|")
    for i=1, 3 do
        local red_envelopes_data = zstring.split(red_envelopes_info[i] ,",") 
        
        local open_level = dms.int(dms["union_science_mould"], tonumber(5+i), union_science_mould.open_level)
        
        --总量
        local Text_zl = ccui.Helper:seekWidgetByName(root, "Text_zl_"..i)
        Text_zl:setString(red_envelopes_data[2].." "..union_red_envelopes_tips[i])
        --剩余个数
        local Text_gs = ccui.Helper:seekWidgetByName(root, "Text_gs_"..i)
        Text_gs:setString(red_envelopes_data[4].."/"..red_envelopes_data[3])
        --最高人名
        local Text_zg = ccui.Helper:seekWidgetByName(root, "Text_zg_"..i)
        if zstring.tonumber(red_envelopes_data[5]) == 0 then
            Text_zg:setString(_string_piece_info[310])
        else
            Text_zg:setString(red_envelopes_data[5])
        end

        --已经抢过
        local Image_yqg = ccui.Helper:seekWidgetByName(root, "Image_yqg_"..i)
        local Text_zl_0 = ccui.Helper:seekWidgetByName(root, "Text_zl_"..i.."_0")
        local science_data = zstring.split(science_info[5+i],",")
        if tonumber(science_data[4]) > 0 then
            Image_yqg:setVisible(true)
            if Text_zl_0 ~= nil then
                Text_zl_0:setVisible(false)
            end
        else
            Image_yqg:setVisible(false)
            if Text_zl_0 ~= nil then
                Text_zl_0:setVisible(true)
            end
        end
        --未开启
        local Image_lock = ccui.Helper:seekWidgetByName(root, "Image_lock_"..i)
        if Image_lock ~= nil then
            if open_level > tonumber(_ED.union.union_info.union_grade) then
                Image_lock:setVisible(true)
                ccui.Helper:seekWidgetByName(root, "Panel_red_"..i):setTouchEnabled(false)
            else
                Image_lock:setVisible(false)
                ccui.Helper:seekWidgetByName(root, "Panel_red_"..i):setTouchEnabled(true)
            end
            --开启描述
            local Text_open_lv_info = ccui.Helper:seekWidgetByName(root, "Text_open_lv_info_"..i)
            Text_open_lv_info:setString(string.format(_new_interface_text[62],open_level))
        end
    end
   
end

function SmUnionSystemRedEnvelopes:onUpdate(dt)
    
end

function SmUnionSystemRedEnvelopes:onEnterTransitionFinish()

end

function SmUnionSystemRedEnvelopes:onInit( )
    local csbItem = csb.createNode("legion/sm_legion_red_packet_tab_1.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    if SmUnionSystemRedEnvelopes.__size == nil then
        SmUnionSystemRedEnvelopes.__size = root:getContentSize()
    end
    self:setContentSize(SmUnionSystemRedEnvelopes.__size)

    self:onUpdateDraw()

    for i=1, 3 do
        --抢红包
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_red_"..i), nil, 
        {
            terminal_name = "sm_union_system_red_envelopes_grad", 
            terminal_state = 0,
            _page = i,
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end

    --规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rule"), nil, 
    {
        terminal_name = "sm_union_red_envelopes_tip_open", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    
end

function SmUnionSystemRedEnvelopes:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function SmUnionSystemRedEnvelopes:onExit()
    state_machine.remove("sm_union_system_red_envelopes_show")    
    state_machine.remove("sm_union_system_red_envelopes_hide")
    state_machine.remove("sm_union_system_red_envelopes_update_draw")
end
