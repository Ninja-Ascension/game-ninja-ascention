-- ----------------------------------------------------------------------------------------------------
-- 说明：特殊节日红包主界面
-------------------------------------------------------------------------------------------------------
RedPacketSpecial = class("RedPacketSpecialClass", Window)

local red_packet_special_open_terminal = {
    _name = "red_packet_special_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("RedPacketSpecialClass") == nil then           
            fwin:open(RedPacketSpecial:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_packet_special_close_terminal = {
    _name = "red_packet_special_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("RedPacketSpecialClass") then
            fwin:close(fwin:find("RedPacketSpecialClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_packet_special_open_terminal)
state_machine.add(red_packet_special_close_terminal)
state_machine.init()

function RedPacketSpecial:ctor()
    self.super:ctor()
    self.roots = {}
    app.load("client.activity.redpacket.RedPacketWindow")
    local function init_red_packet_special_terminal()
        --
         local red_packet_special_terminal = {
            _name = "red_packet_special",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
             -- params._datas.m_type
              state_machine.excute("send_red_packet", 0,params) 
              instance:upDataDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_packet_special_terminal)
        state_machine.init()
    end

    init_red_packet_special_terminal()
end

function RedPacketSpecial:init(params)
    return self
end

function RedPacketSpecial:onMeRanking()
    
end

function RedPacketSpecial:onUpdate(dt)
end


function RedPacketSpecial:upDataDraw()
    local parms = zstring.split(_ED.active_activity[155].need_recharge_count,":")
    local Text_props_n_3 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_props_n_3") --红包总额
    Text_props_n_3:setString(parms[2])

    local Text_legion_props_n_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_legion_props_n_2") --红包总额
    Text_legion_props_n_2:setString(parms[2])

    local Text_props_n_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_props_n_1") --红包数量
    Text_props_n_1:setString(parms[6])

    local Text_legion_props_n_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_legion_props_n_1") --红包数量
    Text_legion_props_n_1:setString(parms[6])

    local specialnums = json.decode(_ED.active_activity[155].activity_params)
    local Text_red_packet_time_n = ccui.Helper:seekWidgetByName(self.roots[1], "Text_red_packet_time_n") --特殊红包数量
    Text_red_packet_time_n:setString(specialnums.specailSendCount)
end

function RedPacketSpecial:onEnterTransitionFinish()
  
    local csbNode = csb.createNode("activity/wonderful/red_packet_special.csb")
    local root = csbNode:getChildByName("root")                         
    table.insert(self.roots, root)
    self:addChild(csbNode)
     -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
    {
        terminal_name = "red_packet_special_close", 
        isPressedActionEnabled = true
    },
    nil, 0)
    --世界红包
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fhb"), nil, 
    {
        terminal_name = "red_packet_special", 
        isPressedActionEnabled = true,
        m_type = 3
    },
    nil, 0)
     --工会红包
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_fhb"), nil, 
    {
        terminal_name = "red_packet_special", 
        isPressedActionEnabled = true,
        m_type = 2
    },
    nil, 0)
    self:registerOnNoteUpdate(self, 1)
    self:upDataDraw()
end

function RedPacketSpecial:onExit()
   
end 
