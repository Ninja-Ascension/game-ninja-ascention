-- ----------------------------------------------------------------------------------------------------
-- 说明：公会红包发送类型选择
-------------------------------------------------------------------------------------------------------
SmUnionRedEnvelopesSendType = class("SmUnionRedEnvelopesSendTypeClass", Window)

local sm_union_red_envelopes_send_type_open_terminal = {
    _name = "sm_union_red_envelopes_send_type_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionRedEnvelopesSendTypeClass")
        if nil == _homeWindow then
            local panel = SmUnionRedEnvelopesSendType:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_red_envelopes_send_type_close_terminal = {
    _name = "sm_union_red_envelopes_send_type_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionRedEnvelopesSendTypeClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionRedEnvelopesSendTypeClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_red_envelopes_send_type_open_terminal)
state_machine.add(sm_union_red_envelopes_send_type_close_terminal)
state_machine.init()
    
function SmUnionRedEnvelopesSendType:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    app.load("client.l_digital.cells.union.redEnvelopes.union_hair_red_envelopes_list_cell")
    local function init_sm_union_red_envelopes_send_type_terminal()
        -- 显示界面
        local sm_union_red_envelopes_send_type_display_terminal = {
            _name = "sm_union_red_envelopes_send_type_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionRedEnvelopesSendTypeWindow = fwin:find("SmUnionRedEnvelopesSendTypeClass")
                if SmUnionRedEnvelopesSendTypeWindow ~= nil then
                    SmUnionRedEnvelopesSendTypeWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_red_envelopes_send_type_hide_terminal = {
            _name = "sm_union_red_envelopes_send_type_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionRedEnvelopesSendTypeWindow = fwin:find("SmUnionRedEnvelopesSendTypeClass")
                if SmUnionRedEnvelopesSendTypeWindow ~= nil then
                    SmUnionRedEnvelopesSendTypeWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_red_envelopes_send_type_display_terminal)
        state_machine.add(sm_union_red_envelopes_send_type_hide_terminal)

        state_machine.init()
    end
    init_sm_union_red_envelopes_send_type_terminal()
end

function SmUnionRedEnvelopesSendType:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local ListView_fhb = ccui.Helper:seekWidgetByName(root, "ListView_fhb")
    ListView_fhb:removeAllItems()
    local redEnvelopesMould = dms.searchs(dms["union_red_reward"], union_red_reward.m_type, self.m_type)

    for i, v in pairs(redEnvelopesMould) do
        local cell = unionHairRedEnvelopesListCell:createCell()
        cell:init(v,i)
        ListView_fhb:addChild(cell)
    end
    ListView_fhb:requestRefreshView()
end

function SmUnionRedEnvelopesSendType:init(params)
    self.m_type = tonumber(params)
    self:onInit()
    return self
end


function SmUnionRedEnvelopesSendType:onInit()
    local csbSmUnionRedEnvelopesSendType = csb.createNode("legion/sm_legion_red_packet_distribute.csb")
    local root = csbSmUnionRedEnvelopesSendType:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionRedEnvelopesSendType)
    self:onUpdateDraw()
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_union_red_envelopes_send_type_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)

end

function SmUnionRedEnvelopesSendType:onExit()
    state_machine.remove("sm_union_red_envelopes_send_type_display")
    state_machine.remove("sm_union_red_envelopes_send_type_hide")
end