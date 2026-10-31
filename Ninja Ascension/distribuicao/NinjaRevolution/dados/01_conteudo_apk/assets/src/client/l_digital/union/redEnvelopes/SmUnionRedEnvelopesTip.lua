-- ----------------------------------------------------------------------------------------------------
-- 说明：公会系统红包规则
-------------------------------------------------------------------------------------------------------
SmUnionRedEnvelopesTip = class("SmUnionRedEnvelopesTipClass", Window)

local sm_union_red_envelopes_tip_open_terminal = {
    _name = "sm_union_red_envelopes_tip_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionRedEnvelopesTipClass")
        if nil == _homeWindow then
            local panel = SmUnionRedEnvelopesTip:new():init()
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_red_envelopes_tip_close_terminal = {
    _name = "sm_union_red_envelopes_tip_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionRedEnvelopesTipClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionRedEnvelopesTipClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_red_envelopes_tip_open_terminal)
state_machine.add(sm_union_red_envelopes_tip_close_terminal)
state_machine.init()
    
function SmUnionRedEnvelopesTip:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    self.action_number = 0
    local function init_sm_union_red_envelopes_tip_terminal()
        -- 显示界面
        local sm_union_red_envelopes_tip_display_terminal = {
            _name = "sm_union_red_envelopes_tip_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionRedEnvelopesTipWindow = fwin:find("SmUnionRedEnvelopesTipClass")
                if SmUnionRedEnvelopesTipWindow ~= nil then
                    SmUnionRedEnvelopesTipWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_red_envelopes_tip_hide_terminal = {
            _name = "sm_union_red_envelopes_tip_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionRedEnvelopesTipWindow = fwin:find("SmUnionRedEnvelopesTipClass")
                if SmUnionRedEnvelopesTipWindow ~= nil then
                    SmUnionRedEnvelopesTipWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_red_envelopes_tip_display_terminal)
        state_machine.add(sm_union_red_envelopes_tip_hide_terminal)
        state_machine.init()
    end
    init_sm_union_red_envelopes_tip_terminal()
end

function SmUnionRedEnvelopesTip:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    
end

function SmUnionRedEnvelopesTip:init()
    self:onInit()
    return self
end

function SmUnionRedEnvelopesTip:onInit()
    local csbSmUnionRedEnvelopesTip = csb.createNode("legion/sm_legion_red_packet_rule.csb")
    local root = csbSmUnionRedEnvelopesTip:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionRedEnvelopesTip)
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_union_red_envelopes_tip_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
end

function SmUnionRedEnvelopesTip:onExit()
    state_machine.remove("sm_union_red_envelopes_tip_display")
    state_machine.remove("sm_union_red_envelopes_tip_hide")
end