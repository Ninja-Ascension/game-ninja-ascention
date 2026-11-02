-----------------------------
--工会发红包
-----------------------------
SmUnionHairRedEnvelopes = class("SmUnionHairRedEnvelopesClass", Window)
SmUnionHairRedEnvelopes.__size = nil

local sm_union_hair_red_envelopes_window_open_terminal = {
    _name = "sm_union_hair_red_envelopes_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local panel = SmUnionHairRedEnvelopes:new():init(params)
		fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_hair_red_envelopes_window_open_terminal)
state_machine.init()

function SmUnionHairRedEnvelopes:ctor()
    self.super:ctor()
    self.roots = {}

    self.prop_list = {}
    app.load("client.l_digital.union.redEnvelopes.SmUnionRedEnvelopesTip")
    app.load("client.l_digital.union.redEnvelopes.SmUnionRedEnvelopesSendType")
    app.load("client.l_digital.union.redEnvelopes.SmUnionRedEnvelopesRank")
    local function init_sm_union_hair_red_envelopes_terminal()
		--显示界面
		local sm_union_hair_red_envelopes_show_terminal = {
            _name = "sm_union_hair_red_envelopes_show",
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
		--隐藏界面
		local sm_union_hair_red_envelopes_hide_terminal = {
            _name = "sm_union_hair_red_envelopes_hide",
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

        local sm_union_hair_red_envelopes_update_draw_terminal = {
            _name = "sm_union_hair_red_envelopes_update_draw",
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

        local sm_union_hair_red_envelopes_hair_terminal = {
            _name = "sm_union_hair_red_envelopes_hair",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local m_type = params._datas._page
                state_machine.excute("sm_union_red_envelopes_send_type_open", 0, m_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_union_hair_red_envelopes_open_rank_terminal = {
            _name = "sm_union_hair_red_envelopes_open_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("sm_union_red_envelopes_rank_open", 0, {10})
                        end 
                    end
                end
                protocol_command.union_red_packet_rap_rank.param_list = 10
                NetworkManager:register(protocol_command.union_red_packet_rap_rank.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(sm_union_hair_red_envelopes_show_terminal)	
		state_machine.add(sm_union_hair_red_envelopes_hide_terminal)
        state_machine.add(sm_union_hair_red_envelopes_update_draw_terminal)
        state_machine.add(sm_union_hair_red_envelopes_hair_terminal)
        state_machine.add(sm_union_hair_red_envelopes_open_rank_terminal)

        state_machine.init()
    end
    init_sm_union_hair_red_envelopes_terminal()
end

function SmUnionHairRedEnvelopes:onHide()
    self:setVisible(false)
end

function SmUnionHairRedEnvelopes:onShow()
    self:setVisible(true)
end

function SmUnionHairRedEnvelopes:onUpdateDraw()
    local root = self.roots[1]
    
    --发红包次数
    local Text_fhb_cishu = ccui.Helper:seekWidgetByName(root, "Text_fhb_cishu")
    for i=1,3 do
        local open_level = dms.int(dms["union_science_mould"], tonumber(5+i), union_science_mould.open_level)
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

    local resetCountElement = dms.element(dms["base_consume"], 60)
    local count = dms.atoi(resetCountElement, base_consume.vip_0_value + zstring.tonumber(_ED.vip_grade))
    local science_info = zstring.split(_ED.union_science_info,"|")
    local datas = zstring.split(science_info[6],",")
    Text_fhb_cishu:setString((count-tonumber(datas[5])).."/"..count)
end

function SmUnionHairRedEnvelopes:onUpdate(dt)
    
end

function SmUnionHairRedEnvelopes:onEnterTransitionFinish()

end

function SmUnionHairRedEnvelopes:onInit( )
    local csbItem = csb.createNode("legion/sm_legion_red_packet_tab_2.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    if SmUnionHairRedEnvelopes.__size == nil then
        SmUnionHairRedEnvelopes.__size = root:getContentSize()
    end
    self:setContentSize(SmUnionHairRedEnvelopes.__size)

    self:onUpdateDraw()
    for i=1, 3 do
        --发红包
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_red_"..i), nil, 
        {
            terminal_name = "sm_union_hair_red_envelopes_hair", 
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

    --排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rank"), nil, 
    {
        terminal_name = "sm_union_hair_red_envelopes_open_rank", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function SmUnionHairRedEnvelopes:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function SmUnionHairRedEnvelopes:onExit()
    state_machine.remove("sm_union_hair_red_envelopes_show")    
    state_machine.remove("sm_union_hair_red_envelopes_hide")
    state_machine.remove("sm_union_hair_red_envelopes_update_draw")
end
