-- ----------------------------------------------------------------------------------------------------
-- 说明：节日红包领取信息主界面
-------------------------------------------------------------------------------------------------------
RedPacketDrawInfo = class("RedPacketDrawInfoClass", Window)

local red_packet_draw_open_terminal = {
    _name = "red_packet_draw_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("RedPacketDrawInfoClass") == nil then           
            fwin:open(RedPacketDrawInfo:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_packet_draw_close_terminal = {
    _name = "red_packet_draw_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("RedPacketDrawInfoClass") then
            fwin:close(fwin:find("RedPacketDrawInfoClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_packet_draw_open_terminal)
state_machine.add(red_packet_draw_close_terminal)
state_machine.init()

function RedPacketDrawInfo:ctor()
    self.super:ctor()
    self.roots = {}
    self.activity = {}
    app.load("client.cells.activity.red_packet_draw_list_cell")
end

function RedPacketDrawInfo:init(params)
    self.activity = params[1]
    return self
end

function RedPacketDrawInfo:onMeRanking()
    
end

function RedPacketDrawInfo:onUpdate(dt)
end


function RedPacketDrawInfo:upDataDraw()
    local ListView_hb_phb = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_hb_phb")
    ListView_hb_phb:removeAllItems()
    if not self.activity then
        return
    end
    local Text_title_wj = ccui.Helper:seekWidgetByName(self.roots[1], "Text_title_wj")
    Text_title_wj:setString(self.activity.senderName..tipStringInfo_red_packet[1])
    for i, v in ipairs(self.activity.drawInfo) do 
        local cell = state_machine.excute("red_packet_draw_list_cell_create",0,{v,i})
        ListView_hb_phb:addChild(cell)
    end
    ListView_hb_phb:requestRefreshView()
end

function RedPacketDrawInfo:onEnterTransitionFinish()
  
    local csbNode = csb.createNode("activity/wonderful/red_packet_infor.csb")
    local root = csbNode:getChildByName("root")                         
    table.insert(self.roots, root)
    self:addChild(csbNode)
     -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
    {
        terminal_name = "red_packet_draw_close", 
        isPressedActionEnabled = true
    },
    nil, 0)
    self:registerOnNoteUpdate(self, 1)
    self:upDataDraw()
end

function RedPacketDrawInfo:onExit()
   
end 
