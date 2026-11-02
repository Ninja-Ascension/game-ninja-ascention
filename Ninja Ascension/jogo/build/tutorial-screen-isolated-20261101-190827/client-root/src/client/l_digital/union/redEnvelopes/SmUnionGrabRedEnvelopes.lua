-----------------------------
--工会抢红包
-----------------------------
SmUnionGrabRedEnvelopes = class("SmUnionGrabRedEnvelopesClass", Window)
SmUnionGrabRedEnvelopes.__size = nil

local sm_union_grab_red_envelopes_window_open_terminal = {
    _name = "sm_union_grab_red_envelopes_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local panel = SmUnionGrabRedEnvelopes:new():init(params)
		fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_grab_red_envelopes_window_open_terminal)
state_machine.init()

function SmUnionGrabRedEnvelopes:ctor()
    self.super:ctor()
    self.roots = {}
    app.load("client.l_digital.cells.union.redEnvelopes.union_member_red_envelopes_list_cell")
    app.load("client.l_digital.cells.union.redEnvelopes.union_my_red_envelopes_list_cell")

    app.load("client.l_digital.union.redEnvelopes.SmUnionRedEnvelopesRank")
    local function init_sm_union_grab_red_envelopes_terminal()
		--显示界面
		local sm_union_grab_red_envelopes_show_terminal = {
            _name = "sm_union_grab_red_envelopes_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:onShow()
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--隐藏界面
		local sm_union_grab_red_envelopes_hide_terminal = {
            _name = "sm_union_grab_red_envelopes_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:onHide()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

        local sm_union_grab_red_envelopes_update_draw_terminal = {
            _name = "sm_union_grab_red_envelopes_update_draw",
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

        local sm_union_grab_red_envelopes_open_rank_terminal = {
            _name = "sm_union_grab_red_envelopes_open_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("sm_union_red_envelopes_rank_open", 0, {20})
                        end 
                    end
                end
                protocol_command.union_red_packet_rap_rank.param_list = 20
                NetworkManager:register(protocol_command.union_red_packet_rap_rank.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(sm_union_grab_red_envelopes_show_terminal)	
		state_machine.add(sm_union_grab_red_envelopes_hide_terminal)
        state_machine.add(sm_union_grab_red_envelopes_update_draw_terminal)
        state_machine.add(sm_union_grab_red_envelopes_open_rank_terminal)

        state_machine.init()
    end
    init_sm_union_grab_red_envelopes_terminal()
end

function SmUnionGrabRedEnvelopes:onHide()
    self:setVisible(false)
end

function SmUnionGrabRedEnvelopes:onShow()
    self:setVisible(true)
end

function SmUnionGrabRedEnvelopes:onUpdateDraw()
    local root = self.roots[1]

    --个人抢夺信息
    local ListView_qhb_xinxi = ccui.Helper:seekWidgetByName(root, "ListView_qhb_xinxi")
    ListView_qhb_xinxi:removeAllItems()
    local index1 = 0
    if _ED.union_red_envelopes_my_info ~= nil then
        table.sort(_ED.union_red_envelopes_my_info, function(c1, c2)
            if c1 ~= nil 
                and c2 ~= nil 
                and zstring.tonumber(zstring.split(c1, ",")[4]) > zstring.tonumber(zstring.split(c2, ",")[4]) then
                return true
            end
            return false
        end)
        for i, v in pairs(_ED.union_red_envelopes_my_info) do
            index1 = index1 + 1
            local arsc2 = unionMyRedEnvelopesListCell:createCell()
            arsc2:init(v, index1)
            ListView_qhb_xinxi:addChild(arsc2)
        end
    end
    ListView_qhb_xinxi:requestRefreshView()

    --发的红包信息
    local ListView_fhb_xinxi = ccui.Helper:seekWidgetByName(root, "ListView_fhb_xinxi")
    ListView_fhb_xinxi:removeAllItems()
    local index = 0
    if _ED.union_red_envelopes_can_be_snatched ~= nil then
        table.sort(_ED.union_red_envelopes_can_be_snatched, function(c1, c2)
            if c1 ~= nil 
                and c2 ~= nil 
                and zstring.tonumber(c1.times) > zstring.tonumber(c2.times) then
                return true
            end
            return false
        end)
        for i, v in pairs(_ED.union_red_envelopes_can_be_snatched) do
            index = index + 1
            local arsc = unionMemberRedEnvelopesListCell:createCell()
            arsc:init(v, index)
            ListView_fhb_xinxi:addChild(arsc)
        end
    end
    ListView_fhb_xinxi:requestRefreshView()


    --抢红包的数量
    local Text_qhb_cishu = ccui.Helper:seekWidgetByName(root, "Text_qhb_cishu")
    local resetCountElement = dms.element(dms["base_consume"], 61)
    local count = dms.atoi(resetCountElement, base_consume.vip_0_value + zstring.tonumber(_ED.vip_grade))
    local science_info = zstring.split(_ED.union_science_info,"|")
    local datas = zstring.split(science_info[6],",")
    Text_qhb_cishu:setString((count-tonumber(datas[6])).."/"..count)

end

function SmUnionGrabRedEnvelopes:onUpdate(dt)
    
end

function SmUnionGrabRedEnvelopes:onEnterTransitionFinish()

end

function SmUnionGrabRedEnvelopes:onInit( )
    local csbItem = csb.createNode("legion/sm_legion_red_packet_tab_3.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    if SmUnionGrabRedEnvelopes.__size == nil then
        SmUnionGrabRedEnvelopes.__size = root:getContentSize()
    end
    self:setContentSize(SmUnionGrabRedEnvelopes.__size)

    self:onUpdateDraw()
    
    --排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rank"), nil, 
    {
        terminal_name = "sm_union_grab_red_envelopes_open_rank", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function SmUnionGrabRedEnvelopes:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function SmUnionGrabRedEnvelopes:onExit()
    state_machine.remove("sm_union_grab_red_envelopes_show")    
    state_machine.remove("sm_union_grab_red_envelopes_hide")
    state_machine.remove("sm_union_grab_red_envelopes_update_draw")
end
