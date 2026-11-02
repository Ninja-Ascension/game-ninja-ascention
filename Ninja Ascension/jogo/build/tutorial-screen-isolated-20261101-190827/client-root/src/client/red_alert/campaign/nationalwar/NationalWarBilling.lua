-----------------------------
--国战结束
-----------------------------
NationalWarBilling = class("NationalWarBillingClass", Window)

local national_war_billing_window_open_terminal = {
    _name = "national_war_billing_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("NationalWarBillingClass") == nil then
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                   fwin:open(NationalWarBilling:new():init(), fwin._ui)
                end
            end
            NetworkManager:register(protocol_command.get_warfare_ranking.code, nil, nil, nil,nil, responseCallback, false, nil) 
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_war_billing_window_close_terminal = {
    _name = "national_war_billing_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarBillingClass"))  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_billing_window_open_terminal)
state_machine.add(national_war_billing_window_close_terminal)
state_machine.init()

function NationalWarBilling:ctor()
    self.super:ctor()
    self.roots = {}
    self.win_type = nil
        -- 查看排行
    local function init_national_war_billing_terminal()
        local national_war_billing_show_rank_terminal = {
            _name = "national_war_billing_show_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("national_war_billing_window_close",0,"")
                fwin:removeAll()
                state_machine.excute("national_truce_open",0,"")
                state_machine.excute("national_rank_window_open",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(national_war_billing_show_rank_terminal)    
        state_machine.init()
    end
    init_national_war_billing_terminal()
end

function NationalWarBilling:onUpdateDraw()
    local root = self.roots[1]
    local Image_billing_1 = ccui.Helper:seekWidgetByName(root,"Image_billing_1")
    local Image_billing_2 = ccui.Helper:seekWidgetByName(root,"Image_billing_2")
    if self.win_type == 1 then
        Image_billing_1:setVisible(true)
        Image_billing_2:setVisible(false)        
    elseif self.win_type == 2 then
        Image_billing_1:setVisible(false)
        Image_billing_2:setVisible(true)
    end
end

function NationalWarBilling:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_billing)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --查看排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_billing_rank"), nil, 
    {
        terminal_name = "national_war_billing_show_rank", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
     
    self:onUpdateDraw() 
end

function NationalWarBilling:getWarState()
    local camp = tonumber(_ED.user_info.user_force)
    for i, v in pairs(_ED.war_rank_info.country) do
        local rank_order = tonumber(v.rank_order)
        if tonumber(v.rank_camp) == camp then
            return rank_order
        end
    end
end

function NationalWarBilling:init(win_type)
    self.win_type = self:getWarState()
    --print("=========",self.win_type)
    self:onInit()
    return self
end

function NationalWarBilling:onExit()
    state_machine.remove("national_war_billing_show_rank")
end
