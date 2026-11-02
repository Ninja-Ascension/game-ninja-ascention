-----------------------------
--号令
-----------------------------
NationalWarDecree = class("NationalWarDecreeClass", Window)

local national_war_decree_window_open_terminal = {
    _name = "national_war_decree_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("NationalWarDecreeClass") == nil then
            fwin:open(NationalWarDecree:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_war_decree_window_close_terminal = {
    _name = "national_war_decree_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarDecreeClass"))  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_decree_window_open_terminal)
state_machine.add(national_war_decree_window_close_terminal)
state_machine.init()

function NationalWarDecree:ctor()
    self.super:ctor()
    self.roots = {}
    app.load("client.red_alert.campaign.nationalwar.NationalWarDecreeCell")
    -- -- Initialize national_war_decree machine.
    local function init_national_war_decree_terminal()

        -- 移除cell
        local national_war_decree_remove_cell_terminal = {
            _name = "national_war_decree_remove_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:removeCell(params[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(national_war_decree_remove_cell_terminal)    
        state_machine.init()
    end
    
    -- call func init national_war_decree machine.
    init_national_war_decree_terminal()
end

function NationalWarDecree:removeCell(cell)
    local root = self.roots[1]
    local ListView_decree = ccui.Helper:seekWidgetByName(root,"ListView_decree")
    ListView_decree:removeItem(ListView_decree:getIndex(cell))
end

function NationalWarDecree:onUpdateDraw()
    local root = self.roots[1]
    local ListView_decree = ccui.Helper:seekWidgetByName(root,"ListView_decree")
    for i,v in pairs(_ED.warfare_order_info) do
        local city_id = tonumber(v.city)
        local order_type = tonumber(v.order_type)
        local leave_time = 0
        if order_type == 1 then
            leave_time = _ED.war_decree_time[city_id].country_leave_time
        elseif order_type == 2 then
            if _ED.user_war_info.union_id == v.union_id then
                leave_time = _ED.war_decree_time[city_id].family_leave_time
            end  
        end
        if leave_time > 0 then
            local cell = state_machine.excute("national_war_decree_cell_create_cell",0,{v,1})
            ListView_decree:addChild(cell)
        end
    end
    local Panel_no_decree = ccui.Helper:seekWidgetByName(root,"Panel_no_decree")
    if #_ED.warfare_order_info == 0 then   
        if Panel_no_decree ~= nil then
            Panel_no_decree:setVisible(true)
        end
    else
        if Panel_no_decree ~= nil then
            Panel_no_decree:setVisible(false)
        end        
    end
end

function NationalWarDecree:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_decree)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_decree_close"), nil, 
    {
        terminal_name = "national_war_decree_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
     
    self:onUpdateDraw() 
end

function NationalWarDecree:init()
    self:onInit()
    return self
end

function NationalWarDecree:onExit()
    state_machine.remove("national_war_decree_remove_cell",0,"")
end
